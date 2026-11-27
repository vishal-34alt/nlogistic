package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.Claim;
import model.ClaimDocument;
import model.ClaimDocumentActions;
import model.ClaimEvidenceStorage;
import model.ClaimActions;
import model.ClaimStatusHistoryActions;

/**
 * One Module 7 controller. All database calls stay in the
 * service/DAO/implementor layers.
 */
@WebServlet(urlPatterns = { "/ClaimController", "/claims" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 10L * 1024 * 1024, maxRequestSize = 15L * 1024 * 1024)
public final class ClaimController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String ROOT = "/WEB-INF/views/Module7/";
	private static final String CSRF = "module7CsrfToken";
	private final ClaimActions claimService = new ClaimActions();
	private final ClaimDocumentActions documentService = new ClaimDocumentActions();
	private final ClaimStatusHistoryActions historyService = new ClaimStatusHistoryActions();

	private static final class User {
		final int id;
		final String role;

		User(int id, String role) {
			this.id = id;
			this.role = role;
		}
	}

	private User user(HttpServletRequest req) {
		HttpSession session = req.getSession(false);
		if (session == null)
			throw new SecurityException("Please log in to use Claims.");
		Object id = session.getAttribute("userId"), role = session.getAttribute("role");
		if (!(id instanceof Number) || !(role instanceof String))
			throw new SecurityException("Please log in to use Claims.");
		int userId = ((Number) id).intValue();
		String r = ((String) role).trim().toUpperCase(Locale.ROOT);
		if (userId <= 0 || !("ADMIN".equals(r) || "CONSUMER".equals(r) || "SELLER".equals(r)))
			throw new SecurityException("Invalid session.");
		return new User(userId, r);
	}

	private void requireRole(User user, String role) {
		if (!role.equals(user.role))
			throw new SecurityException("Only " + role.toLowerCase(Locale.ROOT) + " accounts may do that.");
	}

	private void pageData(HttpServletRequest req, User user) {
		HttpSession session = req.getSession(false);
		if (session.getAttribute(CSRF) == null)
			session.setAttribute(CSRF, UUID.randomUUID().toString());
		req.setAttribute("csrfToken", session.getAttribute(CSRF));
		req.setAttribute("claimRole", user.role);
	}

	private void checkCsrf(HttpServletRequest req) {
		HttpSession s = req.getSession(false);
		String from = req.getParameter("csrfToken");
		Object expected = s == null ? null : s.getAttribute(CSRF);
		if (!(expected instanceof String) || from == null || !MessageDigest
				.isEqual(((String) expected).getBytes(StandardCharsets.UTF_8), from.getBytes(StandardCharsets.UTF_8)))
			throw new SecurityException("Invalid form token. Reload the page and try again.");
	}

	private static int positiveInt(HttpServletRequest req, String param) {
		String value = req.getParameter(param);
		try {
			int n = Integer.parseInt(value);
			if (n > 0)
				return n;
		} catch (NumberFormatException ignored) {
		}
		throw new IllegalArgumentException(param + " must be a positive integer.");
	}

	private static Integer optionalPositive(HttpServletRequest req, String name) {
		String v = req.getParameter(name);
		return v == null || v.trim().isEmpty() ? null : positiveInt(req, name);
	}

	private static BigDecimal money(HttpServletRequest req, String name, boolean optional) {
		String v = req.getParameter(name);
		if (optional && (v == null || v.trim().isEmpty()))
			return BigDecimal.ZERO;
		if (v == null || v.trim().isEmpty())
			throw new IllegalArgumentException(name + " is required.");
		try {
			return new BigDecimal(v.trim());
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("Invalid " + name + ".");
		}
	}

	private static String action(HttpServletRequest req) {
		String a = req.getParameter("action");
		return a == null || a.trim().isEmpty() ? "list" : a.trim();
	}

	private void forward(HttpServletRequest req, HttpServletResponse res, String jsp)
			throws ServletException, IOException {
		req.getRequestDispatcher(ROOT + jsp + ".jsp").forward(req, res);
	}

    private static java.time.LocalDate parseDate(String raw){
        if(raw==null||raw.trim().isEmpty())return null;
        try{return java.time.LocalDate.parse(raw.trim());}
        catch(java.time.format.DateTimeParseException e){throw new IllegalArgumentException("Invalid filing date");}
    }
	private void list(HttpServletRequest req, HttpServletResponse res, User u) throws Exception {
		pageData(req, u);
		String status = req.getParameter("status");
		java.util.List<Claim> filtered=new java.util.ArrayList<>(claimService.searchClaims(u.id,status));
        String search=req.getParameter("q")==null?"":req.getParameter("q").trim();
        String filedFrom=req.getParameter("filedFrom"),filedTo=req.getParameter("filedTo");
        java.time.LocalDate from=parseDate(filedFrom),to=parseDate(filedTo);
        if(from!=null&&to!=null&&from.isAfter(to))throw new IllegalArgumentException("Filing start must be before end");
        filtered.removeIf(c->{
            String match=c.getClaimNo()+" "+c.getClaimId()+" "+c.getShipmentId();
            if(!search.isEmpty()&&!match.toLowerCase(java.util.Locale.ROOT).contains(search.toLowerCase(java.util.Locale.ROOT)))return true;
            java.time.LocalDate day=c.getRaisedAt()==null?null:c.getRaisedAt().toLocalDateTime().toLocalDate();
            return (from!=null&&(day==null||day.isBefore(from)))||(to!=null&&(day==null||day.isAfter(to)));
        });
        req.setAttribute("claims", filtered);
        req.setAttribute("claimSearch",search);
		req.setAttribute("selectedStatus", status == null ? "ALL" : status);
		forward(req, res, "claims");
	}

	private void view(HttpServletRequest req, HttpServletResponse res, User u, int claimId) throws Exception {
		pageData(req, u);
		Claim claim = claimService.getClaimById(claimId, u.id); // stored procedure checks visibility
		if (claim == null)
			throw new IllegalArgumentException("Claim not found.");
		req.setAttribute("claim", claim);
		req.setAttribute("docs", documentService.getDocuments(claimId, u.id));
		req.setAttribute("history", historyService.getHistory(claimId, u.id));
		if ("SELLER".equals(u.role)
				&& ("APPROVED".equals(claim.getStatus()) || "PARTIALLY_APPROVED".equals(claim.getStatus()))
				&& !"DELAY".equals(claim.getClaimType())) {
			req.setAttribute("stockOptions", claimService.getShipmentStock(u.id, claim.getShipmentId()));
		}
		forward(req, res, "claim_details");
	}

	private void create(HttpServletRequest req, HttpServletResponse res, User u) throws Exception {
		requireRole(u, "CONSUMER");
		pageData(req, u);
		req.setAttribute("claimWindowDays",claimService.windowDays());
        req.setAttribute("claimShipmentCandidates", claimService.getClaimCandidateShipments(u.id, claimService.windowDays()));
		forward(req, res, "submit_claim");
	}

	private void redirect(HttpServletRequest req, HttpServletResponse res, int claimId, String msg) throws IOException {
		String target = req.getContextPath() + "/ClaimController?action="
				+ (claimId > 0 ? "view&claim_id=" + claimId : "list") + "&msg=" + msg;
		res.sendRedirect(target);
	}

	private ClaimDocument findDocument(int claimId, int documentId, int userId) throws Exception {
		Claim claim = claimService.getClaimById(claimId, userId);
		if (claim == null)
			throw new IllegalArgumentException("Claim not found.");
		List<ClaimDocument> docs = documentService.getDocuments(claimId, userId);
		for (ClaimDocument d : docs)
			if (d.getCdocId() == documentId)
				return d;
		throw new SecurityException("Evidence does not belong to this claim.");
	}

	private void download(HttpServletRequest req, HttpServletResponse res, User u, boolean preview) throws Exception {
		int claimId = positiveInt(req, "claim_id"), docId = positiveInt(req, "cdoc_id");
		ClaimDocument doc = findDocument(claimId, docId, u.id);
		ClaimEvidenceStorage storage = new ClaimEvidenceStorage();
        byte[] content = storage.loadDocument(doc.getFilePath());
		String mime = "PDF".equals(doc.getFileType()) ? "application/pdf"
				: ("PNG".equals(doc.getFileType()) ? "image/png" : "image/jpeg");
		res.setContentType(mime);
		res.setHeader("X-Content-Type-Options", "nosniff");
		res.setHeader("Content-Disposition", (preview ? "inline" : "attachment") + "; filename=claim-evidence-" + docId + "."
				+ doc.getFilePath().substring(doc.getFilePath().lastIndexOf('.') + 1));
        res.setContentLength(content.length);
        res.getOutputStream().write(content);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {
			User u = user(req);
			switch (action(req)) {
			case "list":
				list(req, res, u);
				break;
			case "view":
				view(req, res, u, positiveInt(req, "claim_id"));
				break;
			case "new":
				create(req, res, u);
				break;
			case "download":
                download(req, res, u, false);
                break;
            case "preview":
                download(req, res, u, true);
                break;
            case "printReport":
                exportClaimReport(req,res,u,true);
                break;
            case "downloadReport":
                exportClaimReport(req,res,u,false);
                break;
			default:
				res.sendRedirect(req.getContextPath() + "/ClaimController?action=list");
			}
		} catch (Exception e) {
			failure(res, e);
		}
	}

    /** Identical PDF content for browser print and download. */
    private void exportClaimReport(HttpServletRequest req,HttpServletResponse res,User user,boolean inline)throws Exception{
        int id=positiveInt(req,"claim_id");
        byte[] content=new model.ClaimPrintActions().pdf(id,user.id);
        res.setContentType("application/pdf");
        res.setHeader("X-Content-Type-Options","nosniff");
        res.setHeader("Cache-Control","private,no-store,max-age=0");
        res.setHeader("Content-Disposition",(inline?"inline":"attachment")+"; filename=claim-"+id+"-statement.pdf");
        res.setContentLength(content.length);
        res.getOutputStream().write(content);
    }

	private void saveEvidence(int claimId, int userId, Part part) throws Exception {
		if (part == null || part.getSize() == 0)
			return;
		ClaimEvidenceStorage storage = new ClaimEvidenceStorage();
		ClaimEvidenceStorage.UploadedFile saved = storage.save(part);
		try {
			int docId = documentService.addDocument(claimId, userId, saved.displayName, saved.storedName, saved.type);
			if (docId <= 0)
				throw new IllegalStateException("The database did not confirm evidence upload.");
		} catch (Exception e) {
			storage.discard(saved.storedName);
			throw e;
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		int claimId = 0;
		try {
			User u = user(req);
			checkCsrf(req);
			String a = action(req);
			switch (a) {
			case "submit": {
				requireRole(u, "CONSUMER");
				Part evidence = req.getPart("evidence_file");
				// Validate file size before creating claim; maxFileSize is enforced by
				// container too.
				if (evidence != null && evidence.getSize() > 10L * 1024L * 1024L)
					throw new IllegalArgumentException("Evidence must be at most 10 MB.");
				claimId = claimService.submitClaim(u.id, positiveInt(req, "shipment_id"),
						req.getParameter("claim_type"), req.getParameter("description"),
						money(req, "claimed_amount", false), claimService.windowDays());
				try {
					saveEvidence(claimId, u.id, evidence);
				} catch (Exception uploadError) {
					getServletContext().log("Claim " + claimId + " created but evidence upload failed", uploadError);
					redirect(req, res, claimId, "evidence_failed");
					return;
				}
				redirect(req, res, claimId, "submitted");
				return;
			}
			case "add_doc": {
				requireRole(u, "CONSUMER");
				claimId = positiveInt(req, "claim_id");
				Part extra = req.getPart("evidence_file");
				if (extra == null || extra.getSize() <= 0)
					throw new IllegalArgumentException("Choose an evidence file.");
				// Recheck claim visibility and user ownership in DB before file write.
				Claim c = claimService.getClaimById(claimId, u.id);
				if (c == null)
					throw new IllegalArgumentException("Claim not found.");
				saveEvidence(claimId, u.id, extra);
				redirect(req, res, claimId, "evidence_added");
				return;
			}
			case "update_field": {
				requireRole(u, "CONSUMER");
				claimId = positiveInt(req, "claim_id");
				claimService.updateClaimField(u.id, claimId, req.getParameter("field_name"),
						req.getParameter("new_value"));
				redirect(req, res, claimId, "updated");
				return;
			}
			case "delete": {
				requireRole(u, "CONSUMER");
				claimId = positiveInt(req, "claim_id");
                Claim preDeletion=claimService.getClaimById(claimId,u.id);
                if(preDeletion==null||!"SUBMITTED".equals(preDeletion.getStatus()))
                    throw new IllegalArgumentException("Only a claim not yet reviewed may be deleted.");
                // Logical removal retains FK-backed history and evidence for audits.
                claimService.deleteClaim(claimId, u.id);
				redirect(req, res, 0, "deleted");
				return;
			}
			case "update_status":
			case "review": {
				requireRole(u, "SELLER");
				claimId = positiveInt(req, "claim_id");
				claimService.reviewClaim(claimId, u.id, req.getParameter("decision"),
						money(req, "approved_amount", true), req.getParameter("remarks"));
				redirect(req, res, claimId, "reviewed");
				return;
			}
			case "settle": {
				requireRole(u, "SELLER");
				claimId = positiveInt(req, "claim_id");
				claimService.settleClaim(claimId, u.id, optionalPositive(req, "stock_id"),
						optionalPositive(req, "quantity"), req.getParameter("remarks"));
				redirect(req, res, claimId, "settled");
				return;
			}
			case "delete_doc": {
				requireRole(u, "CONSUMER");
				claimId = positiveInt(req, "claim_id");
				int docId = positiveInt(req, "cdoc_id");
				ClaimDocument doc = findDocument(claimId, docId, u.id);
				documentService.deleteDocument(u.id, docId); // database restricts to SUBMITTED
				try {
					new ClaimEvidenceStorage().discard(doc.getFilePath());
				} catch (IOException cleanupError) {
					getServletContext().log("Evidence metadata removed; file cleanup failed", cleanupError);
				}
				redirect(req, res, claimId, "evidence_deleted");
				return;
			}
			case "update_doc": {
				requireRole(u, "CONSUMER");
				claimId = positiveInt(req, "claim_id");
				int docId = positiveInt(req, "cdoc_id");
				findDocument(claimId, docId, u.id);
				String field = req.getParameter("field_name");
				if (!"file_name".equals(field))
					throw new IllegalArgumentException(
							"Only the displayed evidence name may be edited from this screen.");
				documentService.updateDocument(u.id, docId, field, req.getParameter("new_value"));
				redirect(req, res, claimId, "evidence_updated");
				return;
			}
			case "comment": {
				if ("ADMIN".equals(u.role))
					throw new SecurityException("Only the Consumer or responsible Seller may comment.");
				claimId = positiveInt(req, "claim_id");
				if(claimService.getClaimById(claimId,u.id)==null)throw new IllegalArgumentException("Claim no longer available.");
				historyService.addComment(claimId, u.id, req.getParameter("comment"));
				redirect(req, res, claimId, "comment_added");
				return;
			}
			default:
				throw new IllegalArgumentException("Unknown claim action.");
			}
		} catch (Exception e) {
			if (!(e instanceof SecurityException)) {
				try {
					User u = user(req);
					req.setAttribute("errorMessage", safeMessage(e));
					if (claimId > 0) {
						view(req, res, u, claimId);
						return;
					}
					if ("submit".equals(action(req)) && "CONSUMER".equals(u.role)) {
						create(req, res, u);
						return;
					}
				} catch (Exception ignored) {
					/* use normal error response below */}
			}
			failure(res, e);
		}
	}

	private String safeMessage(Exception e) {
		if (e instanceof IllegalArgumentException || e instanceof SecurityException)
			return e.getMessage();
		if (e instanceof SQLException && "45000".equals(((SQLException) e).getSQLState()))
			return e.getMessage();
		return "Request could not be completed. Please check the server log.";
	}

	private void failure(HttpServletResponse res, Exception e) throws IOException {
		int code = e instanceof SecurityException ? 403
				: (e instanceof IllegalArgumentException ? 400
						: (e instanceof SQLException && "45000".equals(((SQLException) e).getSQLState()) ? 400 : 500));
		if (code == 500)
			getServletContext().log("Module 7 error", e);
		res.setStatus(code);
		res.setContentType("text/plain; charset=UTF-8");
		res.getWriter().println(safeMessage(e));
	}
}
