package controller;

import java.io.*;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import model.*;

@WebServlet(name = "StockController", urlPatterns = "/stock")
@MultipartConfig(maxFileSize = 10485760L, maxRequestSize = 11534336L)
public final class StockController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final StockActions actions = new StockActions();

	private static final String FOLDER = "/WEB-INF/views/Module4/";

	private int number(HttpServletRequest r, String key) {
		try {
			int v = Integer.parseInt(r.getParameter(key));
			if (v <= 0)
				throw new NumberFormatException();
			return v;
		} catch (Exception e) {
			throw new IllegalArgumentException(key + " must be positive");
		}
	}

	private int nonNegative(HttpServletRequest r, String key) {
		try {
			int v = Integer.parseInt(r.getParameter(key));
			if (v < 0)
				throw new NumberFormatException();
			return v;
		} catch (Exception e) {
			throw new IllegalArgumentException(key + " must be a nonnegative integer");
		}
	}

	private Integer optional(HttpServletRequest r, String key) {
		String v = r.getParameter(key);
		return v == null || v.trim().isEmpty() ? null : number(r, key);
	}

	private Long longOpt(HttpServletRequest r, String key) {
		String v = r.getParameter(key);
		if (v == null || v.trim().isEmpty())
			return null;
		try {
			long n = Long.parseLong(v);
			if (n <= 0)
				throw new NumberFormatException();
			return n;
		} catch (Exception e) {
			throw new IllegalArgumentException("Invalid " + key);
		}
	}

	private String param(HttpServletRequest r, String key) {
		String v = r.getParameter(key);
		return v == null ? "" : v.trim();
	}

	private int[] user(HttpServletRequest r) {
		HttpSession s = r.getSession(false);
		if (s == null || !"SELLER".equals(s.getAttribute("role")) || !(s.getAttribute("userId") instanceof Number)
				|| !(s.getAttribute("companyId") instanceof Number))
			throw new SecurityException("Seller login required");
		return new int[] { ((Number) s.getAttribute("userId")).intValue(),
				((Number) s.getAttribute("companyId")).intValue() };
	}

	private void csrf(HttpSession s) {
		if (s.getAttribute("stockCsrfToken") == null)
			s.setAttribute("stockCsrfToken", UUID.randomUUID().toString());
	}

	private boolean valid(HttpServletRequest r) {
		HttpSession s = r.getSession(false);
		return s != null && s.getAttribute("stockCsrfToken") instanceof String
				&& ((String) s.getAttribute("stockCsrfToken")).equals(r.getParameter("csrfToken"));
	}

	private void show(HttpServletRequest r, HttpServletResponse p, String view) throws ServletException, IOException {
		r.getRequestDispatcher(FOLDER + view).forward(r, p);
	}

	private Product product(HttpServletRequest r) {
		Product p = new Product();
		p.setSku(param(r, "sku"));
		p.setProductName(param(r, "productName"));
		p.setCategory(param(r, "category"));
		p.setHsCode(param(r, "hsCode"));
		p.setUnit(param(r, "unit"));
		p.setUnitWeightKg(new BigDecimal(param(r, "unitWeightKg")));
		p.setUnitPrice(new BigDecimal(param(r, "unitPrice")));
		return p;
	}

	private void flash(HttpServletRequest r, String msg) {
		r.getSession().setAttribute("stockFlash", msg);
		r.getSession().setAttribute("stockFlashKind", "success");
	}

	@Override
	protected void doGet(HttpServletRequest r, HttpServletResponse p) throws ServletException, IOException {
		p.setHeader("Cache-Control", "no-store");
        // FR4.4: Consumers/Admin can inspect their authorized shipment quantities without gaining stock edit access.
        if("summary".equals(param(r,"action"))){
            HttpSession sess=r.getSession(false);
            if(sess==null||!(sess.getAttribute("userId") instanceof Number)){p.sendRedirect(r.getContextPath()+"/Module1Controller?action=viewLogin");return;}
            try{
                int actor=((Number)sess.getAttribute("userId")).intValue();
                r.setAttribute("shipments",actions.authorizedShipmentChoices(actor));
                if(!param(r,"shipmentId").isEmpty())
                    r.setAttribute("summary",actions.authorizedSummary(number(r,"shipmentId"),actor));
                show(r,p,"summary.jsp");
            }catch(SecurityException e){p.sendError(403,"Shipment not authorized");}
            catch(IllegalArgumentException e){p.sendError(400,"Select a valid shipment");}
            catch(Exception e){getServletContext().log("Shipment stock summary failed",e);p.sendError(500,"Shipment summary could not be loaded");}
            return;
        }
		final int[] u;
		try {
			u = user(r);
		} catch (SecurityException ex) {
			p.sendRedirect(r.getContextPath() + "/Module1Controller?action=viewLogin&error=login_required");
			return;
		}
		csrf(r.getSession(false));
		try {
			String a = param(r, "action");
			switch (a) {
			case "new-product":
				r.setAttribute("formProduct", new Product());
				show(r, p, "product-form.jsp");
				return;
			case "edit-product": {
				Product prod = actions.product(number(r, "id"), u[0], u[1]);
				if (prod == null) {
					p.sendError(404);
					return;
				}
				r.setAttribute("formProduct", prod);
				show(r, p, "product-form.jsp");
				return;
			}
			case "new-stock":
				r.setAttribute("products", actions.products(u[0], u[1]));
				show(r, p, "stock-form.jsp");
				return;
			case "download-template":
                p.setContentType("text/csv; charset=UTF-8");
                p.setHeader("Content-Disposition", "attachment; filename=stock_import_template.csv");
                p.setHeader("X-Content-Type-Options", "nosniff");
                p.getWriter().write(StockImportParser.csvTemplate());
                return;
			case "import":
				show(r, p, "import.jsp");
				return;
            case "sales":
                r.setAttribute("salesRows",actions.salesTransactions(u[0],u[1],param(r,"q")));
                show(r,p,"sales.jsp");
                return;
			case "ledger":
				r.setAttribute("products", actions.products(u[0], u[1]));
				r.setAttribute("ledger", actions.ledger(optional(r, "productId"), param(r, "txnType"),
						param(r, "referenceType"), longOpt(r, "referenceId"), u[0], u[1]));
				r.setAttribute("productId", param(r, "productId"));
				show(r, p, "ledger.jsp");
				return;
			case "summary":
				r.setAttribute("summary", actions.summary(number(r, "shipmentId"), u[0], u[1]));
				show(r, p, "summary.jsp");
				return;
			case "":
			case "dashboard": {
				String q = param(r, "q");
				r.setAttribute("q", q);
				r.setAttribute("shipmentId", param(r, "shipmentId"));
				r.setAttribute("products", actions.products(u[0], u[1]));
				r.setAttribute("shipmentOptions", actions.authorizedShipmentChoices(u[0]));
				r.setAttribute("stockRows", actions.stock(q, optional(r, "shipmentId"), u[0], u[1]));
				show(r, p, "dashboard.jsp");
				return;
			}
			default:
				p.sendError(404);
				return;
			}
		} catch (Exception e) {
			getServletContext().log("Stock GET failed", e);
			r.setAttribute("error", safe(e));
			r.setAttribute("products", Collections.emptyList());
			r.setAttribute("stockRows", Collections.emptyList());
			show(r, p, "dashboard.jsp");
		}
	}

	@Override
	protected void doPost(HttpServletRequest r, HttpServletResponse p) throws ServletException, IOException {
		r.setCharacterEncoding("UTF-8");
		final int[] u;
		try {
			u = user(r);
		} catch (SecurityException ex) {
			p.sendError(401);
			return;
		}
		if (!valid(r)) {
			p.sendError(403, "Invalid CSRF token");
			return;
		}
		String a = param(r, "action");
		try {
			switch (a) {
			case "create-product":
				actions.createProduct(product(r), u[0], u[1]);
				flash(r, "Product created");
				break;
			case "update-product": {
				Product prod = product(r);
				prod.setProductId(number(r, "productId"));
				actions.updateProduct(prod, u[0], u[1]);
				flash(r, "Product updated");
				break;
			}
			case "delete-product":
				actions.deleteProduct(number(r, "productId"), u[0], u[1]);
				flash(r, "Product deleted");
				break;
			case "add-stock":
				actions.addStock(number(r, "productId"), number(r, "quantity"), u[0], u[1]);
				flash(r, "Stock added and ledger recorded");
				break;
			case "update-stock":
				actions.updateStock(number(r, "stockId"), param(r, "field"), nonNegative(r, "value"), u[0], u[1]);
				flash(r, "Stock updated and ledger recorded");
				break;
			case "delete-stock":
				actions.deleteStock(number(r, "stockId"), u[0], u[1], r.getRemoteAddr());
				flash(r, "Stock removed from active inventory; adjustment and history preserved");
				break;
			case "import-stock": {
				Part part = r.getPart("file");
				if (part == null || part.getSize() == 0)
					throw new IllegalArgumentException("Choose a CSV or XLSX file");
				StockImportReport report;
				try (InputStream in = part.getInputStream()) {
					report = new StockImportActions(actions).importFile(part.getSubmittedFileName(), in, u[0], u[1]);
				}
				r.setAttribute("report", report);
				show(r, p, "import-result.jsp");
				return;
			}
			default:
				throw new IllegalArgumentException("Unknown stock action");
			}
			p.sendRedirect(r.getContextPath() + "/stock");
		} catch (Exception e) {
            getServletContext().log("Stock POST failed", e);
            if(("create-product".equals(a) || "update-product".equals(a))) {
                try {
                    Product entered=product(r);
                    if("update-product".equals(a))entered.setProductId(number(r,"productId"));
                    r.setAttribute("formProduct",entered);
                    r.setAttribute("stockProductError",safe(e));
                    show(r,p,"product-form.jsp");
                    return;
                } catch(Exception invalidForm) { /* malformed input uses the normal error notice */ }
            }
            r.getSession().setAttribute("stockFlash", safe(e));
            r.getSession().setAttribute("stockFlashKind", "error");
            p.sendRedirect(r.getContextPath() + "/stock");
        }
	}

	private String safe(Exception e) {
		if (e instanceof SQLException) {
			String state = ((SQLException) e).getSQLState();
			if ("28000".equals(state))
				return "Access denied";
			if ("45000".equals(state))
                return e.getMessage();
            if("23000".equals(state))
                return "This SKU is already registered. Use a unique SKU or Add stock to the existing product.";
			return "Database operation failed";
		}
		if (e instanceof IllegalArgumentException)
			return e.getMessage();
		return "Request could not be completed";
	}
}
