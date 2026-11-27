
package controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.UUID;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Booking;
import model.BookingItem;
import model.Container;
import model.PricingRule;
import model.DirectoryActions;

@WebServlet("/ContainerAllocationPricingController")
public class ContainerAllocationPricingController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================
    // GET REQUESTS
    // =========================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (!isLoggedIn(session)) {
            response.sendRedirect(
                    request.getContextPath() + "/Module1Controller?action=viewLogin");
            return;
        }

        String module = request.getParameter("module");

        try {

            if ("booking_hints".equalsIgnoreCase(module)) {
                if (!"CONSUMER".equals(session.getAttribute("role"))) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,"Consumer access required");return;
                }
                int pid=Integer.parseInt(requiredParameter(request,"productId"));
                String when=request.getParameter("bookingDate");
                java.sql.Date date=(when==null || when.trim().isEmpty())?
                    new java.sql.Date(System.currentTimeMillis()):java.sql.Date.valueOf(when.trim());
                int routePage=readPositiveNumber(request.getParameter("page"),1,100000);
                int routeSize=readPositiveNumber(request.getParameter("pageSize"),10,50);
                Map<String,Object> directory=new DirectoryActions().routePage(getSessionInt(session,"userId"),pid,date,
                    request.getParameter("q"),request.getParameter("sort"),routePage,routeSize,
                    "1".equals(request.getParameter("activeOnly")),
                    readOptionalPortId(request.getParameter("originPortId")),
                    readOptionalPortId(request.getParameter("destPortId")));
                @SuppressWarnings("unchecked")
                List<Map<String,Object>> routes=(List<Map<String,Object>>)directory.get("routes");
                response.setContentType("application/json; charset=UTF-8");
                response.setHeader("Cache-Control","no-store, private");
                StringBuilder json=new StringBuilder("{\"total\":"+directory.get("total")+
                    ",\"page\":"+directory.get("page")+",\"pageSize\":"+directory.get("pageSize")+",\"routes\":[");
                for(Map<String,Object> r:routes){
                    if(json.charAt(json.length()-1)!='[')json.append(',');
                    json.append("{\"originPortId\":").append(r.get("originPortId"))
                        .append(",\"destPortId\":").append(r.get("destPortId"))
                        .append(",\"origin\":").append(jsonString(String.valueOf(r.get("origin"))))
                        .append(",\"destination\":").append(jsonString(String.valueOf(r.get("destination"))))
                        .append(",\"availableContainers\":").append(r.get("availableContainers"))
                        .append(",\"activeShipments\":").append(r.get("activeShipments"))
                        .append(",\"historicalTransitDays\":").append(r.get("historicalTransitDays")==null?"null":r.get("historicalTransitDays"))
                        .append(",\"historySamples\":").append(r.get("historySamples")).append('}');
                }
                response.getWriter().write(json.append("]}").toString());return;
            } else if ("booking".equalsIgnoreCase(module)) {
                if (!"CONSUMER".equals(session.getAttribute("role"))) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,"Consumer access required");return;
                }
                populateBookingLookups(request,getSessionInt(session,"userId"));
                request.getRequestDispatcher("/WEB-INF/views/Module3/booking.jsp")
                        .forward(request, response);

            } else if ("container".equalsIgnoreCase(module)) {

                requireSeller(session);

                int sellerId = getSessionInt(session, "companyId");

                Container containerModel = new Container();

                List<Container> containers = containerModel.searchContainers(
                        getSessionInt(session,"userId"),sellerId,
                        request.getParameter("q"),request.getParameter("status"));
                request.setAttribute("directoryPorts",new DirectoryActions().ports(getSessionInt(session,"userId")));

                request.setAttribute("containers", containers);

                request.getRequestDispatcher("/WEB-INF/views/Module3/containers.jsp")
                        .forward(request, response);

            } else if ("pricing".equalsIgnoreCase(module)) {

                requireSeller(session);

                int sellerId = getSessionInt(session, "companyId");

                PricingRule pricingModel = new PricingRule();

                List<Map<String, Object>> pricingRules = pricingModel.searchPricingRules(
                        getSessionInt(session,"userId"),sellerId,request.getParameter("q"));
                request.setAttribute("directoryPorts",new DirectoryActions().ports(getSessionInt(session,"userId")));

                request.setAttribute("pricingRules", pricingRules);

                request.getRequestDispatcher("/WEB-INF/views/Module3/pricing.jsp")
                        .forward(request, response);

            } else {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid module."
                );
            }

        } catch (IllegalArgumentException | SecurityException e) {

            forwardError(request, response, e.getMessage());

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to load requested module.", e);
        }
    }

    /** Optional directory filters; zero means no restriction. Validated against route SQL as parameters. */
    private static int readOptionalPortId(String raw){
        if(raw==null || raw.trim().isEmpty())return 0;
        try{int id=Integer.parseInt(raw.trim());return id>0?id:0;}
        catch(NumberFormatException ignored){return 0;}
    }

    private static int readPositiveNumber(String raw,int fallback,int maximum){
        if(raw==null || raw.trim().isEmpty())return fallback;
        try{return Math.min(maximum,Math.max(1,Integer.parseInt(raw.trim())));}
        catch(NumberFormatException ignored){return fallback;}
    }

    // =========================================
    // POST REQUESTS
    // =========================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (!isLoggedIn(session)) {
            response.sendRedirect(
                    request.getContextPath() + "/Module1Controller?action=viewLogin");
            return;
        }

        if (session.getAttribute("csrfToken") == null || !session.getAttribute("csrfToken").equals(request.getParameter("csrfToken"))) {
            response.sendError(403,"Invalid form token");return;
        }

        String module = request.getParameter("module");

        try {

            if ("booking".equalsIgnoreCase(module)) {

                handleBooking(request, response, session);

            } else if ("container".equalsIgnoreCase(module)) {

                requireSeller(session);

                handleContainer(request, response, session);

            } else if ("pricing".equalsIgnoreCase(module)) {

                requireSeller(session);

                handlePricing(request, response, session);

            } else {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid module."
                );
            }

        } catch (IllegalArgumentException | SecurityException e) {
            if("booking".equalsIgnoreCase(module) && !(e instanceof SecurityException)){
                populateBookingLookups(request,getSessionInt(session,"userId"));
                request.setAttribute("bookingError",e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/Module3/booking.jsp").forward(request,response);
            } else if ("pricing".equalsIgnoreCase(module) && !(e instanceof SecurityException)) {
                showPricingError(request,response,session,e.getMessage());
            } else forwardError(request, response, e.getMessage());
        } catch (Exception e) {
            getServletContext().log("Booking or Module 3 operation failed",e);
            if("booking".equalsIgnoreCase(module)) {
                String error=Booking.explainFailure(e);
                populateBookingLookups(request,getSessionInt(session,"userId"));
                request.setAttribute("bookingError",error);
                request.getRequestDispatcher("/WEB-INF/views/Module3/booking.jsp").forward(request,response);
            } else if ("container".equalsIgnoreCase(module)
                    && e instanceof java.sql.SQLException
                    && ("45000".equals(((java.sql.SQLException)e).getSQLState())
                        || "23000".equals(((java.sql.SQLException)e).getSQLState()))) {
                // A referenced or active container must remain in the history.
                // This is a business-rule failure, not an HTTP 500 crash.
                request.setAttribute("errorMessage",
                    "This container cannot be deleted because it is in use, has shipment history, "
                    + "or is not in Available/Maintenance status.");
                int actor=getSessionInt(session,"userId");
                int seller=getSessionInt(session,"companyId");
                try {
                    request.setAttribute("containers", new Container().getContainersBySeller(seller));
                    request.setAttribute("directoryPorts",new DirectoryActions().ports(actor));
                    request.getRequestDispatcher("/WEB-INF/views/Module3/containers.jsp")
                        .forward(request,response);
                } catch (Exception reloadFailure) {
                    getServletContext().log("Unable to reload containers after rejected deletion",reloadFailure);
                    throw new ServletException("Unable to load the container list.",reloadFailure);
                }
            } else if ("pricing".equalsIgnoreCase(module)
                    && e instanceof java.sql.SQLException
                    && ("45000".equals(((java.sql.SQLException)e).getSQLState())
                        || "23000".equals(((java.sql.SQLException)e).getSQLState()))) {
                String message=e.getMessage();
                if(message != null && message.contains("active pricing rules cannot overlap dates")) {
                    message="An active pricing rule already covers the selected route, container type and dates. "
                        + "Use Edit on the existing rule, or choose a non-overlapping date range "
                        + "or a different route/container type. The existing rate was not changed.";
                } else if (message == null || message.trim().isEmpty()) {
                    message="The pricing rule could not be saved because it violates a database rule.";
                }
                showPricingError(request,response,session,message);
            } else throw new ServletException("Unable to process request.",e);
        }
    }

    // An expected pricing validation must return to the Pricing Rules page rather
    // than exposing a Tomcat HTTP 500. No database queries are performed here;
    // existing Model/POJO calls supply the directory and port choices.
    private void showPricingError(HttpServletRequest request,
            HttpServletResponse response,HttpSession session,String message)
            throws ServletException, IOException {
        try {
            int actor=getSessionInt(session,"userId");
            int seller=getSessionInt(session,"companyId");
            request.setAttribute("errorMessage",message);
            request.setAttribute("pricingCreateFailed",
                    "insert".equalsIgnoreCase(request.getParameter("action")));
            request.setAttribute("pricingRules",new PricingRule().searchPricingRules(actor,seller,""));
            request.setAttribute("directoryPorts",new DirectoryActions().ports(actor));
            request.getRequestDispatcher("/WEB-INF/views/Module3/pricing.jsp")
                    .forward(request,response);
        } catch (Exception reloadFailure) {
            getServletContext().log("Unable to reload pricing after validation failure",reloadFailure);
            throw new ServletException("Unable to reload the pricing rules.",reloadFailure);
        }
    }

    // =========================================
    // MODULE 1: BOOKING
    // =========================================

    private void handleBooking(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws Exception {

        if (!"CONSUMER".equals(session.getAttribute("role"))) throw new SecurityException("Consumer access required");
        int userId = getSessionInt(session, "userId");

        String action = requiredParameter(request, "action");

        int originPortId = Integer.parseInt(
                requiredParameter(request, "originPortId"));

        int destPortId = Integer.parseInt(
                requiredParameter(request, "destPortId"));

        Date bookingDate = Date.valueOf(
                requiredParameter(request, "bookingDate"));

        List<BookingItem> items = getBookingItems(request);

        // Create Booking Model object
        Booking booking = new Booking(
                userId,
                originPortId,
                destPortId,
                bookingDate
        );

        Map<String, Object> result;

        String dueDateValue=requiredParameter(request, "dueDate");
        Date dueDate=Date.valueOf(dueDateValue);
        Booking.validateDueDate(bookingDate,dueDate);
        String fingerprint=Booking.quoteFingerprint(userId,originPortId,destPortId,bookingDate,dueDate,items);
        if ("quote".equalsIgnoreCase(action)) {
            // Quote returns actual container availability and server-computed prices without writing a booking.
            result = booking.calculateQuote(items);
            if(result==null)throw new IllegalStateException("No matching quote is available");
            String quoteToken=UUID.randomUUID().toString();
            session.setAttribute("module3QuoteToken",quoteToken);
            session.setAttribute("module3QuoteFingerprint",fingerprint);
            session.setAttribute("module3QuoteCreatedAt",System.currentTimeMillis());
            request.setAttribute("bookingQuoteToken",quoteToken);

        } else if ("confirm".equalsIgnoreCase(action)) {
            String provided=requiredParameter(request,"quoteToken");
            // Atomically claim a quote token; a repeated Submit cannot create two bookings.
            synchronized(session){
                Object saved=session.getAttribute("module3QuoteToken");
                Object savedFingerprint=session.getAttribute("module3QuoteFingerprint");
                Object at=session.getAttribute("module3QuoteCreatedAt");
                boolean fresh=at instanceof Long && System.currentTimeMillis()-(Long)at <= 15L*60_000L;
                if(!fresh || !(saved instanceof String) || !(savedFingerprint instanceof String)
                   || !MessageDigest.isEqual(((String)saved).getBytes(StandardCharsets.UTF_8),provided.getBytes(StandardCharsets.UTF_8))
                   || !MessageDigest.isEqual(((String)savedFingerprint).getBytes(StandardCharsets.UTF_8),fingerprint.getBytes(StandardCharsets.UTF_8))) {
                    throw new SecurityException("Quotation expired or changed. Calculate a fresh quote before confirming.");
                }
                session.removeAttribute("module3QuoteToken");
                session.removeAttribute("module3QuoteFingerprint");
                session.removeAttribute("module3QuoteCreatedAt");
            }
            // The DB transaction again checks stock, capacity, pricing and availability.
            result = booking.confirmBooking(dueDate,items);
            // Keep only opaque server-created identifiers for one next-step payment redirect.
            if(result!=null && result.get("invoiceId") instanceof Number && result.get("shipmentId") instanceof Number){
                session.setAttribute("nlBookingPayInvoice",((Number)result.get("invoiceId")).intValue());
                session.setAttribute("nlBookingPayShipment",((Number)result.get("shipmentId")).intValue());
            }

        } else {

            throw new IllegalArgumentException(
                    "Invalid booking action.");
        }

        request.setAttribute("bookingResult", result);

        request.getRequestDispatcher("/WEB-INF/views/Module3/booking-result.jsp")
                .forward(request, response);
    }

    // Convert submitted product details into BookingItem objects

    private List<BookingItem> getBookingItems(
            HttpServletRequest request) {

        String[] productIds =
                request.getParameterValues("productId");

        String[] quantities =
                request.getParameterValues("quantity");

        String[] unitCbms =
                request.getParameterValues("unitCbm");

        if (productIds == null ||
                quantities == null ||
                unitCbms == null ||
                productIds.length == 0 ||
                productIds.length != quantities.length ||
                productIds.length != unitCbms.length) {

            throw new IllegalArgumentException(
                    "Invalid booking item details.");
        }

        List<BookingItem> items = new ArrayList<>();

        for (int i = 0; i < productIds.length; i++) {

            BookingItem item = new BookingItem();

            item.setProductId(
                    Integer.parseInt(productIds[i]));

            item.setQuantity(
                    Integer.parseInt(quantities[i]));

            item.setUnitCbm(
                    Double.parseDouble(unitCbms[i]));

            items.add(item);
        }

        return items;
    }

    // =========================================
    // MODULE 2: CONTAINER
    // =========================================

    private void handleContainer(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws Exception {

        int userId = getSessionInt(session, "userId");

        int sellerId = getSessionInt(session, "companyId");

        String action = requiredParameter(request, "action");

        // Create Container Model object
        Container container = new Container();

        if ("insert".equalsIgnoreCase(action)) {

            container.setContainerNumber(
                    requiredParameter(request, "containerNumber"));

            container.setSellerId(sellerId);

            container.setContainerType(
                    requiredParameter(request, "containerType"));

            container.setSizeFt(Integer.parseInt(
                    requiredParameter(request, "sizeFt")));

            container.setMaxWeightKg(new BigDecimal(
                    requiredParameter(request, "maxWeightKg")));

            container.setMaxVolumeCbm(new BigDecimal(
                    requiredParameter(request, "maxVolumeCbm")));

            container.setCurrentPortId(Integer.parseInt(
                    requiredParameter(request, "currentPortId")));

            // Model handles insertion
            int containerId = container.insertContainer();

            request.setAttribute(
                    "message",
                    "Container added successfully. ID: " + containerId
            );

        } else if ("delete".equalsIgnoreCase(action)) {
            container.deleteEligibleContainer(userId,sellerId,Integer.parseInt(requiredParameter(request,"containerId")));
            request.setAttribute("message","Unused container removed. Shipment history was preserved.");
        } else if ("maintenance".equalsIgnoreCase(action)) {
            int id=Integer.parseInt(requiredParameter(request,"containerId"));
            boolean allowed=false;
            for(Container c:container.getContainersBySeller(sellerId))if(c.getContainerId()==id&&"AVAILABLE".equals(c.getStatus()))allowed=true;
            if(!allowed)throw new IllegalArgumentException("Only available containers can enter maintenance");
            container.updateContainerField(userId,id,"status","MAINTENANCE",request.getRemoteAddr());
            request.setAttribute("message","Container placed in maintenance.");
        } else if ("update".equalsIgnoreCase(action)) {

            int containerId = Integer.parseInt(
                    requiredParameter(request, "containerId"));

            String fieldName =
                    requiredParameter(request, "fieldName");

            String newValue =
                    requiredParameter(request, "newValue");

            // Model handles update
            Container updatedContainer =
                    container.updateContainerField(
                            userId,
                            containerId,
                            fieldName,
                            newValue,
                            request.getRemoteAddr()
                    );

            request.setAttribute(
                    "updatedContainer",
                    updatedContainer
            );

            request.setAttribute(
                    "message",
                    "Container updated successfully."
            );

        } else {

            throw new IllegalArgumentException(
                    "Invalid container action.");
        }

        // Reload containers through Model
        List<Container> containers =
                container.getContainersBySeller(sellerId);

        request.setAttribute("containers", containers);
        request.setAttribute("directoryPorts",new DirectoryActions().ports(userId));
        request.getRequestDispatcher("/WEB-INF/views/Module3/containers.jsp")
                .forward(request, response);
    }

    // =========================================
    // MODULE 3: PRICING
    // =========================================

    private void handlePricing(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session)
            throws Exception {

        int userId = getSessionInt(session, "userId");

        int sellerId = getSessionInt(session, "companyId");

        String action = requiredParameter(request, "action");

        // Create PricingRule Model object
        PricingRule pricing = new PricingRule();

        if ("insert".equalsIgnoreCase(action)) {

            int originPortId = Integer.parseInt(
                    requiredParameter(request, "originPortId"));

            int destPortId = Integer.parseInt(
                    requiredParameter(request, "destPortId"));

            String containerType =
                    requiredParameter(request, "containerType");

            BigDecimal baseRate = new BigDecimal(
                    requiredParameter(request, "baseRate"));

            BigDecimal ratePerKg = new BigDecimal(
                    requiredParameter(request, "ratePerKg"));

            BigDecimal ratePerCbm = new BigDecimal(
                    requiredParameter(request, "ratePerCbm"));

            BigDecimal seasonMultiplier = new BigDecimal(
                    requiredParameter(request, "seasonMultiplier"));

            BigDecimal demandMultiplier = new BigDecimal(
                    requiredParameter(request, "demandMultiplier"));

            Date validFrom = Date.valueOf(
                    requiredParameter(request, "validFrom"));

            String validToValue = request.getParameter("validTo");

            Date validTo = null;

            if (validToValue != null &&
                    !validToValue.trim().isEmpty()) {

                validTo = Date.valueOf(validToValue);
            }

            // Model handles pricing rule insertion
            int ruleId = pricing.insertPricingRule(
                    userId,
                    sellerId,
                    originPortId,
                    destPortId,
                    containerType,
                    baseRate,
                    ratePerKg,
                    ratePerCbm,
                    seasonMultiplier,
                    demandMultiplier,
                    validFrom,
                    validTo
            );

            request.setAttribute(
                    "message",
                    "Pricing rule added successfully. ID: " + ruleId
            );

        } else if ("edit".equalsIgnoreCase(action)) {
            int ruleId = Integer.parseInt(requiredParameter(request, "ruleId"));
            BigDecimal baseRate = new BigDecimal(requiredParameter(request, "baseRate"));
            BigDecimal ratePerKg = new BigDecimal(requiredParameter(request, "ratePerKg"));
            BigDecimal ratePerCbm = new BigDecimal(requiredParameter(request, "ratePerCbm"));
            BigDecimal seasonMultiplier = new BigDecimal(requiredParameter(request, "seasonMultiplier"));
            BigDecimal demandMultiplier = new BigDecimal(requiredParameter(request, "demandMultiplier"));
            Date validFrom = Date.valueOf(requiredParameter(request, "validFrom"));
            String to = request.getParameter("validTo");
            Date validTo = to == null || to.trim().isEmpty() ? null : Date.valueOf(to.trim());
            pricing.editPricingRule(userId,ruleId,baseRate,ratePerKg,ratePerCbm,
                    seasonMultiplier,demandMultiplier,validFrom,validTo);
            request.setAttribute("message", "Pricing rule #" + ruleId + " updated successfully.");

        } else if ("delete".equalsIgnoreCase(action)) {
            int ruleId = Integer.parseInt(requiredParameter(request, "ruleId"));
            pricing.archivePricingRule(userId,sellerId,ruleId);
            request.setAttribute("message", "Pricing rule #" + ruleId
                    + " deleted from your active directory. Pricing audit history was retained.");

        } else if ("update".equalsIgnoreCase(action)) {

            int ruleId = Integer.parseInt(
                    requiredParameter(request, "ruleId"));

            String fieldName =
                    requiredParameter(request, "fieldName");

            String newValue =
                    requiredParameter(request, "newValue");

            pricing.updatePricingRuleField(
                    userId,
                    ruleId,
                    fieldName,
                    newValue
            );

            request.setAttribute(
                    "message",
                    "Pricing rule updated successfully."
            );

        } else if ("deactivate".equalsIgnoreCase(action)) {

            int ruleId = Integer.parseInt(
                    requiredParameter(request, "ruleId"));

            pricing.deactivatePricingRule(userId, ruleId);

            request.setAttribute(
                    "message",
                    "Pricing rule deactivated successfully."
            );

        } else if ("audit".equalsIgnoreCase(action)) {

            int ruleId = Integer.parseInt(
                    requiredParameter(request, "ruleId"));

            // Audit access must not leak competitor seller pricing history.
            boolean owned=false;
            for(Map<String,Object> item:pricing.getPricingRules(sellerId)) {
                Object value=item.get("rule_id");
                if(value instanceof Number&&((Number)value).intValue()==ruleId){owned=true;break;}
            }
            if(!owned)throw new SecurityException("Pricing rule not owned by Seller");
            List<Map<String, Object>> auditList =
                    pricing.getPricingAudit(ruleId);

            request.setAttribute("pricingAudit", auditList);

            request.getRequestDispatcher("/WEB-INF/views/Module3/pricing-audit.jsp")
                    .forward(request, response);

            return;

        } else {

            throw new IllegalArgumentException(
                    "Invalid pricing action.");
        }

        // Reload pricing rules
        List<Map<String, Object>> pricingRules =
                pricing.searchPricingRules(userId,sellerId,"");

        request.setAttribute("pricingRules", pricingRules);
        request.setAttribute("directoryPorts",new DirectoryActions().ports(userId));
        request.getRequestDispatcher("/WEB-INF/views/Module3/pricing.jsp")
                .forward(request, response);
    }

    // =========================================
    // COMMON METHODS
    // =========================================

    private static String jsonString(String value){
        StringBuilder s=new StringBuilder("\"");
        for(int i=0;i<value.length();i++){
            char ch=value.charAt(i);
            switch(ch){
            case '"':s.append("\\\"");break;
            case '\\':s.append("\\\\");break;
            case '\n':s.append("\\n");break;
            case '\r':s.append("\\r");break;
            case '\t':s.append("\\t");break;
            default:if(ch<32){String hex=Integer.toHexString(ch);s.append("\\u");for(int z=hex.length();z<4;z++)s.append('0');s.append(hex);}else s.append(ch);
            }
        }return s.append('"').toString();
    }

    private void populateBookingLookups(HttpServletRequest request,int actor) {
        try {
            DirectoryActions directory=new DirectoryActions();
            request.setAttribute("directoryPorts",directory.ports(actor));
            request.setAttribute("directoryProducts",directory.products(actor));
        } catch(Exception e){throw new IllegalStateException("Booking catalogue cannot be loaded",e);}
    }
    private boolean isLoggedIn(HttpSession session) {

        return session != null &&
                session.getAttribute("userId") != null;
    }

    private void requireSeller(HttpSession session) {

        String role = String.valueOf(
                session.getAttribute("role"));

        if (!"SELLER".equalsIgnoreCase(role)) {

            throw new IllegalArgumentException(
                    "Access denied. Seller access required.");
        }
    }

    private int getSessionInt(
            HttpSession session,
            String attributeName) {

        Object value = session.getAttribute(attributeName);

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        if (value instanceof String) {
            return Integer.parseInt((String) value);
        }

        throw new IllegalArgumentException(
                "Invalid session value: " + attributeName);
    }

    private String requiredParameter(
            HttpServletRequest request,
            String parameterName) {

        String value = request.getParameter(parameterName);

        if (value == null || value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    parameterName + " is required.");
        }

        return value.trim();
    }

    private void forwardError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);

        request.getRequestDispatcher("/WEB-INF/views/Module1/error.jsp")
                .forward(request, response);
    }
}
