package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;
import java.math.*;
import java.time.LocalDate;

import model.Row;
import model.BillingActions;
import model.InvoicePdfBuilder;

@WebServlet(
    name = "BillingController",
    urlPatterns = {"/billing"},
    loadOnStartup = 1
)
public class BillingController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final BillingActions billing = new BillingActions();

    private String p(HttpServletRequest r, String n) {
        String s = r.getParameter(n);
        return s == null ? "" : s.trim();
    }

    private String opt(HttpServletRequest r, String n) {
        String s = p(r, n);
        return s.isEmpty() ? null : s;
    }

    private int id(HttpServletRequest r, String n) {
        int x = Integer.parseInt(p(r, n));

        if (x <= 0) {
            throw new IllegalArgumentException();
        }

        return x;
    }

    private java.sql.Date date(
            HttpServletRequest r, String n) {

        return java.sql.Date.valueOf(
                LocalDate.parse(p(r, n))
        );
    }

    private BigDecimal amount(
            HttpServletRequest r, String n) {

        String s = p(r, n);

        if (!s.matches("[0-9]{1,10}(\\.[0-9]{1,2})?")) {
            throw new IllegalArgumentException();
        }

        return new BigDecimal(s);
    }

    private Row first(List<Row> rows) {

        if (rows.isEmpty()) {
            throw new SecurityException(
                    "Record not available"
            );
        }

        return rows.get(0);
    }

    private void role(String actual, String expected) {

        if (!expected.equals(actual)) {
            throw new SecurityException(
                    "Operation not permitted"
            );
        }
    }

    private String token(HttpSession s) {

        Object t = s.getAttribute("billingCsrf");

        if (t == null) {
            t = UUID.randomUUID().toString();
            s.setAttribute("billingCsrf", t);
        }

        return t.toString();
    }

    private void page(
            HttpServletRequest r,
            HttpServletResponse s,
            String name)
            throws ServletException, IOException {

        r.getRequestDispatcher(
                "/WEB-INF/views/Module5/" + name + ".jsp"
        ).forward(r, s);
    }

    private void redirect(
            HttpServletRequest r,
            HttpServletResponse s,
            String a)
            throws IOException {

        s.sendRedirect(
                r.getContextPath() + "/billing?action=" + a
        );
    }

    @Override
    protected void doGet(
            HttpServletRequest r,
            HttpServletResponse s)
            throws ServletException, IOException {

        handle(r, s, false);
    }

    @Override
    protected void doPost(
            HttpServletRequest r,
            HttpServletResponse s)
            throws ServletException, IOException {

        handle(r, s, true);
    }

    private void handle(
            HttpServletRequest r,
            HttpServletResponse s,
            boolean post)
            throws ServletException, IOException {

        r.setCharacterEncoding("UTF-8");
        s.setCharacterEncoding("UTF-8");

        s.setHeader("Cache-Control", "no-store");
        s.setHeader("X-Content-Type-Options", "nosniff");
        s.setHeader("X-Frame-Options", "DENY");

        HttpSession session = r.getSession(false);
        if (session == null) { s.sendRedirect(r.getContextPath() + "/Module1Controller?action=viewLogin"); return; }

        String a = p(r, "action");

        if (a.isEmpty()) {
            a = "dashboard";
        }

        r.setAttribute("csrf", token(session));

        try {

            // CSRF PROTECTION

            if (post && !token(session).equals(p(r, "csrf"))) {
                throw new SecurityException(
                        "Invalid request token"
                );
            }

            // Module 1 is the ONLY authentication authority.
            if (a.equals("login")) {
                s.sendRedirect(r.getContextPath() + "/Module1Controller?action=viewLogin");
                return;
            }

            // AUTHENTICATION

            Object uid = session.getAttribute("userId");

            if (uid == null) {
                redirect(r, s, "login");
                return;
            }

            int user = Integer.parseInt(uid.toString());

            Row u = billing.activeUser(user);

            String role = u.text("role");

            if (!Arrays.asList(
                    "ADMIN", "SELLER", "CONSUMER"
            ).contains(role)) {

                throw new SecurityException(
                        "Unsupported user role"
                );
            }

            session.setAttribute("role", role);
            session.setAttribute("fullName", u.text("full_name"));
            session.setAttribute("companyId", u.get("company_id"));
            r.setAttribute("role", role);

            // POST OPERATIONS

            if (post) {

                String ip = r.getRemoteAddr();
                int inv = 0;

                switch (a) {

                    case "create":

                        role(role, "SELLER");

                        inv = billing.createInvoice(user,id(r,"shipment"),date(r,"due"),
                                amount(r,"freight"),amount(r,"handling"),amount(r,"customs"),amount(r,"insurance"),ip);

                        break;

                    case "due":

                        role(role, "SELLER");

                        inv = id(r, "invoice");

                        billing.editDueDate(user,inv,date(r,"due"),ip);

                        break;

                    case "deleteInvoice":

                        role(role, "SELLER");

                        billing.deleteInvoice(user,id(r,"invoice"),ip);

                        redirect(r, s, "invoices");
                        return;

                    case "note":

                        role(role, "SELLER");

                        inv = id(r, "invoice");

                        billing.addNote(user,inv,p(r,"description"),ip);

                        break;

                    case "editNote":

                        role(role, "SELLER");

                        inv = id(r, "invoice");

                        billing.editNote(user,id(r,"item"),p(r,"description"),ip);

                        break;

                    case "deleteNote":

                        role(role, "SELLER");

                        inv = id(r, "invoice");

                        billing.deleteNote(user,id(r,"item"),ip);

                        break;

                    // Historical payment arrangements remain in the audit trail.
                    // New pay-on-delivery requests are intentionally disabled.
                    case "payLater":
                        throw new IllegalArgumentException("Pay on delivery is no longer offered. Choose Full or Partial payment.");

                    // CONSUMER PAYMENT

                    case "pay":

                        role(role, "CONSUMER");

                        inv = id(r, "invoice");

                        Integer paidShipment = billing.shipmentForInvoice(user, inv);
                        if (paidShipment == null || paidShipment.intValue() <= 0)
                            throw new SecurityException("Invoice shipment not available to this account");

                        // Single-use request token prevents double-click/replay from recording twice.
                        synchronized (session) {
                            String nonceKey = "billingPaymentNonce_" + inv;
                            Object savedNonce = session.getAttribute(nonceKey);
                            if (savedNonce == null || !savedNonce.equals(p(r, "paymentNonce"))) {
                                throw new SecurityException("This payment form has expired or was already submitted. Reopen the invoice before trying again.");
                            }
                            session.removeAttribute(nonceKey);
                            billing.recordPayment(user,inv,amount(r,"amount"),p(r,"paymentType"),p(r,"mode"),
                                    opt(r,"reference"),date(r,"date"));
                        }

                        // Route every successful FULL or PARTIAL recording to the exact
                        // authorized shipment, not the invoice or a generic shipment list.
                        // The model resolves ownership; the browser cannot choose the ID.
                        session.removeAttribute("nlBookingPayInvoice");
                        session.removeAttribute("nlBookingPayShipment");
                        session.setAttribute("module2Flash",
                            p(r,"paymentType") + " payment of INR "
                            + amount(r,"amount").toPlainString()
                            + " was recorded. You are viewing the shipment linked to your invoice.");
                        s.sendRedirect(s.encodeRedirectURL(r.getContextPath()
                            + "/containerMovement?action=shipmentDetails&shipmentId=" + paidShipment));
                        return;

                    // PAYMENT MODIFICATION DISABLED

                    case "editPayment":
                    case "deletePayment":

                        throw new SecurityException(
                            "Recorded payments cannot be "
                            + "updated or deleted."
                        );

                    default:

                        throw new IllegalArgumentException();
                }

                redirect(r, s, "details&invoice=" + inv);
                return;
            }

            // GET OPERATIONS

            switch (a) {

                case "dashboard":
                case "invoices":
                case "outstanding": {

                    List<Row> rows=billing.invoices(user,opt(r,"status"),
                            a.equals("outstanding"),p(r,"q"));

                    r.setAttribute("rows", rows);
                    r.setAttribute("invoiceSummary",billing.summarizeInvoices(rows));
                    r.setAttribute("screen", a);

                    page(r, s, "invoices");
                    return;
                }

                case "shipmentInvoice": {
                    // The model and implementor recheck shipment ownership; no SQL in controller.
                    Integer linkedInvoice=billing.invoiceForShipment(user,id(r,"shipmentId"));
                    if(linkedInvoice==null){ s.sendError(404,"No accessible invoice exists for this shipment"); return; }
                    redirect(r,s,"details&invoice="+linkedInvoice);
                    return;
                }

                case "createInvoice":

                    role(role, "SELLER");

                    r.setAttribute("rows",billing.eligibleShipments(
                           ((Number)u.get("company_id")).intValue()));

                    page(r, s, "create");
                    return;

                case "payments":
                    // Same authorized invoice data drives actionable Pending/Partial/Paid tabs.
                    List<Row> paymentInvoices=billing.invoices(user,null,false,p(r,"q"));
                    r.setAttribute("paymentInvoices",paymentInvoices);
                    r.setAttribute("paymentInvoiceSummary",billing.summarizeInvoices(paymentInvoices));
                    r.setAttribute("paymentFilter",p(r,"view"));

                    r.setAttribute("rows",billing.payments(user,opt(r,"reference"),
                            opt(r,"from")==null?null:date(r,"from"),
                            opt(r,"to")==null?null:date(r,"to")));

                    page(r, s, "payments");
                    return;

                case "details":
                case "print":
                case "download": {

                    int inv = id(r, "invoice");

                    List<Row> rows=billing.invoiceDetails(user,inv);

                    Row invoice = first(rows);

                    List<Row> history=billing.paymentHistory(inv);
                    boolean deliveryChoice=billing.payOnDeliverySelected(user,inv);
                    if (a.equals("download") || a.equals("print")) {
                        pdf(s, invoice, rows, history, deliveryChoice, a.equals("print"));
                        return;
                    }

                    r.setAttribute("invoice", invoice);
                    r.setAttribute("items", rows);
                    r.setAttribute("payments",history);
                    r.setAttribute("deliveryArrangement",deliveryChoice);

                    if (a.equals("details")) {
                        // A fresh token is issued on each invoice-detail load.
                        String nonce=UUID.randomUUID().toString();
                        session.setAttribute("billingPaymentNonce_"+inv,nonce);
                        r.setAttribute("paymentNonce",nonce);
                        r.setAttribute("deliveryArrangement",deliveryChoice);
                        r.setAttribute("payMode",p(r,"payMode"));
                        r.setAttribute("paymentArrangementSuccess",session.getAttribute("paymentArrangementSuccess"));
                        session.removeAttribute("paymentArrangementSuccess");

                        Object message =
                            session.getAttribute("paymentSuccess");

                        r.setAttribute("paymentSuccess", message);

                        session.removeAttribute("paymentSuccess");
                    }

                    page(
                        r, s,
                        a.equals("print") ? "print" : "details"
                    );

                    return;
                }

                default:

                    s.sendError(404);
            }

        } catch (SecurityException e) {

            s.setStatus(403);
            r.setAttribute("error", e.getMessage());
            page(r, s, "error");

        } catch (
            IllegalArgumentException
            | java.time.DateTimeException e
        ) {

            s.setStatus(400);

            // Payment validation messages are authored in the model and contain
            // no SQL details. Show them so consumers can correct the request.
            String validationMessage = e.getMessage();
            r.setAttribute(
                "error",
                post && "pay".equals(a) && validationMessage != null
                    && !validationMessage.isEmpty()
                    ? validationMessage : "Check the supplied values and dates."
            );

            page(r, s, "error");

        } catch (SQLException e) {

            log(
                "Billing database operation failed: "
                + e.getSQLState(), e
            );

            boolean validationError =
                "45000".equals(e.getSQLState());

            s.setStatus(validationError ? 400 : 500);

            r.setAttribute(
                "error",
                validationError
                    ? e.getMessage()
                    : "Database operation failed. "
                    + "Check server configuration and logs."
            );

            page(r, s, "error");
        }
    }

    // Controller only handles HTTP response delivery; rendering lives in model.InvoicePdfBuilder.
    private void pdf(HttpServletResponse response,Row invoice,List<Row> items,
                     List<Row> payments,boolean payOnDelivery,boolean inline)throws IOException {
        byte[] bytes=InvoicePdfBuilder.build(invoice,items,payments,payOnDelivery);
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",(inline?"inline":"attachment")+"; filename=invoice-"+invoice.id("invoice_id")+".pdf");
        response.setContentLength(bytes.length);
        response.getOutputStream().write(bytes);
    }
}
