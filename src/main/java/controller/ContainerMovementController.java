package controller;

import model.User;
import model.ShipmentPojo;
import model.ContainerMovementPojo;
import model.ProfitLossPojo;
import model.ProfitLossCsvFormatter;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/** Controller: HTTP, auth, input parsing and view dispatch only (no SQL). */
@WebServlet("/containerMovement")
public final class ContainerMovementController extends HttpServlet {
    private static final long serialVersionUID=2L;
    private static final String VIEWS="/WEB-INF/views/Module2/";
    private static final String TOKEN_KEY="module2CsrfToken";
    private static final String FLASH_KEY="module2Flash";
    private static final String CORRECTION_ERROR_KEY="module2CorrectionError";
    private static final String CANCELLATION_ERROR_KEY="module2CancellationError";
    private static final String SCHEDULE_ERROR_KEY="module2ScheduleError";
    private static final String DELAY_ERROR_KEY="module2DelayError";

    private final ShipmentPojo shipments=new ShipmentPojo();
    private final ContainerMovementPojo movements=new ContainerMovementPojo();
    private final ProfitLossPojo profits=new ProfitLossPojo();

    @Override protected void doGet(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {
        resp.setHeader("Cache-Control","private, no-store, max-age=0");
        try {
            User user=verify(req);
            setCommon(req,user);
            String action=param(req,"action");
            if(action==null)action="shipments";
            switch(action) {
                case "shipments": case "search": {
                    List<ShipmentPojo> found=shipments.search(user,param(req,"containerNumber"),
                       optionalId(req,"shipmentId"),optionalId(req,"portId"),param(req,"status"));
                    final int pageSize=25;
                    int pageNumber=optionalId(req,"page")==null?1:optionalId(req,"page");
                    int pages=Math.max(1,(found.size()+pageSize-1)/pageSize);
                    pageNumber=Math.min(pageNumber,pages);
                    int from=(pageNumber-1)*pageSize;
                    req.setAttribute("shipments",found.subList(from,Math.min(from+pageSize,found.size())));
                    req.setAttribute("totalShipments",found.size());
                    req.setAttribute("currentPage",pageNumber);
                    req.setAttribute("pageCount",pages);
                    req.setAttribute("ports",shipments.listPorts(user));
                    req.setAttribute("shipmentListScreen",Boolean.TRUE);
                    if(user.isConsumer()||user.isSeller()||user.isAdmin()){
                        java.util.Set<Integer> eligibleIds=new java.util.HashSet<>();
                        model.BookingCancellationActions cancellations=new model.BookingCancellationActions();
                        for(ShipmentPojo sh:found.subList(from,Math.min(from+pageSize,found.size()))) {
                            if(("BOOKED".equals(sh.getStatus())||(!user.isConsumer()&&"LOADED".equals(sh.getStatus())))
                               && cancellations.eligible(user,sh.getShipmentId()))
                                eligibleIds.add(sh.getShipmentId());
                        }
                        req.setAttribute("cancelEligible",eligibleIds);
                    }
                    page(req,resp,"shipmentManagement.jsp");
                    break;
                }
                case "shipmentDetails": {
                    ShipmentPojo shipment=requireShipment(user,req);
                    req.setAttribute("shipment",shipment);
                    req.setAttribute("shipments",Collections.singletonList(shipment));
                    req.setAttribute("totalShipments",1);
                    req.setAttribute("currentPage",1);
                    req.setAttribute("pageCount",1);
                    req.setAttribute("canEdit",user.canUpdateShipment(shipment.getSellerId()));
                    req.setAttribute("shipmentListScreen",Boolean.FALSE);
                    if(user.isConsumer()||user.isSeller()||user.isAdmin()){
                        java.util.Set<Integer> eligibleIds=new java.util.HashSet<>();
                        if(("BOOKED".equals(shipment.getStatus())||(!user.isConsumer()&&"LOADED".equals(shipment.getStatus())))
                            && new model.BookingCancellationActions().eligible(user,shipment.getShipmentId()))
                            eligibleIds.add(shipment.getShipmentId());
                        req.setAttribute("cancelEligible",eligibleIds);
                    }
                    req.setAttribute("ports",shipments.listPorts(user));
                    page(req,resp,"shipmentManagement.jsp");
                    break;
                }
                case "timeline": {
                    ShipmentPojo shipment=requireShipment(user,req);
                    req.setAttribute("shipment",shipment);
                    req.setAttribute("movements",movements.timeline(user,shipment.getShipmentId()));
                    req.setAttribute("isTimeline",true);
                    req.setAttribute("canEdit",user.canUpdateShipment(shipment.getSellerId()));
                    page(req,resp,"movementTracking.jsp");
                    break;
                }
                case "movements": case "searchMovements": {
                    Integer shipmentId=optionalId(req,"shipmentId");
                    ShipmentPojo selected=shipmentId==null?null:shipments.get(user,shipmentId);
                    if(shipmentId!=null && selected==null)
                        throw new IllegalArgumentException("Shipment not found or unavailable");
                    if(selected!=null)req.setAttribute("shipment",selected);
                    // Preserve authorization on the movement-history page as well.
                    req.setAttribute("canEdit",selected!=null && user.canUpdateShipment(selected.getSellerId()));
                    req.setAttribute("movements",movements.search(user,shipmentId,param(req,"status"),
                        optionalDate(req,"startDate"),optionalDate(req,"endDate")));
                    req.setAttribute("isTimeline",false);
                    page(req,resp,"movementTracking.jsp");
                    break;
                }
                case "movementUpdate": {
                    user.requireSeller();
                    ShipmentPojo shipment=requireShipment(user,req);
                    if(!user.canUpdateShipment(shipment.getSellerId()))throw new SecurityException("Access denied");
                    req.setAttribute("shipment",shipment);
                    req.setAttribute("movements",movements.timeline(user,shipment.getShipmentId()));
                    req.setAttribute("ports",shipments.listPorts(user));
                    page(req,resp,"movementUpdate.jsp");
                    break;
                }
                case "profitLoss": case "monthlyProfitLoss": {
                    loadProfitReports(req,user);
                    req.setAttribute("activeTab","monthlyProfitLoss".equals(action)?"monthly":"shipment");
                    page(req,resp,"profitLossDashboard.jsp");
                    break;
                }
                case "calculateProfitLoss": {
                    user.requireSeller();
                    ShipmentPojo shipment=requireShipment(user,req);
                    req.setAttribute("calculated",profits.calculate(user,shipment,requiredMonth(req)));
                    loadProfitReports(req,user);
                    req.setAttribute("activeTab","shipment");
                    page(req,resp,"profitLossDashboard.jsp");
                    break;
                }
                case "exportProfitLossCsv": case "exportMonthlyProfitLossCsv": {
                    user.requireStaff();
                    Integer seller=optionalId(req,"sellerId");
                    LocalDate start=optionalDate(req,"startDate"),end=optionalDate(req,"endDate");
                    if(start!=null&&end!=null&&start.isAfter(end))throw new IllegalArgumentException("From date cannot be after To date");
                    boolean monthly="exportMonthlyProfitLossCsv".equals(action);
                    List<ProfitLossPojo> records=monthly?profits.monthly(user,seller,start,end)
                        :profits.shipments(user,seller,start,end);
                    exportCsv(resp,(monthly?"NLOG_M2_monthly_":"NLOG_M2_shipments_")+LocalDate.now()+".csv",
                        ProfitLossCsvFormatter.format(records,monthly,user.isAdmin()?seller:user.getCompanyId(),start,end));
                    break;
                }
                default:resp.sendError(404,"Unknown Module 2 action");
            }
        }catch(Exception ex){error(req,resp,ex);}
    }

    @Override protected void doPost(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException,IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control","private, no-store, max-age=0");
        try {
            User user=verify(req);
            // Cancellation is a Consumer-only, auditable exception to the Seller-only movement workflow.
            if(!validToken(req))throw new SecurityException("Invalid or expired request token");
            String action=param(req,"action");
            if("cancelBooking".equals(action)){
                try {
                    long released=new model.BookingCancellationActions().cancel(
                        user,requiredId(req,"shipmentId"),param(req,"reason"));
                    redirect(req,resp,"shipments","Shipment cancelled successfully. " +released+
                        " unit(s) returned to available stock; container released. The CANCELLED movement, invoice and audit history are preserved.");
                } catch (SQLException ex) {
                    // Database business-rule denials should return to the shipment list,
                    // not strand the user on an HTTP 500/error page.
                    if (!"45000".equals(ex.getSQLState()) && !"23000".equals(ex.getSQLState())) throw ex;
                    req.getSession(false).setAttribute(CANCELLATION_ERROR_KEY,
                        safeSqlMessage(ex));
                    resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+"/containerMovement?action=shipments"));
                } catch (IllegalArgumentException | SecurityException ex) {
                    req.getSession(false).setAttribute(CANCELLATION_ERROR_KEY,ex.getMessage());
                    resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+"/containerMovement?action=shipments"));
                }
                return;
            }
            user.requireSeller();
            if("addMovement".equals(action)) {
                ShipmentPojo sh=requireShipment(user,req);
                Integer portId=optionalId(req,"portId");
                movements.add(user,sh,param(req,"status"),portId,param(req,"locationText"),param(req,"remarks"));
                redirect(req,resp,"timeline&shipmentId="+sh.getShipmentId(),"Shipment movement saved");
            }else if("deleteMovement".equals(action)) {
                // Keep the shipment timeline visible after a correction, including rejections.
                ShipmentPojo shipment=requireShipment(user,req);
                try {
                    long eventId=requiredLong(req,"movementId");
                    String restored=movements.correctLatest(user,shipment,eventId,param(req,"reason"));
                    String back="movementUpdate".equals(param(req,"returnTo"))?"movementUpdate":"timeline";
                    redirect(req,resp,back+"&shipmentId="+shipment.getShipmentId(),
                        "Checkpoint corrected and audited. Shipment restored to "+restored+".");
                } catch (IllegalArgumentException ex) {
                    redirectCorrectionError(req,resp,shipment.getShipmentId(),ex.getMessage(),
                        "movementUpdate".equals(param(req,"returnTo")));
                } catch (SQLException ex) {
                    if (!"45000".equals(ex.getSQLState())) throw ex;
                    redirectCorrectionError(req,resp,shipment.getShipmentId(),correctionMessage(ex),
                        "movementUpdate".equals(param(req,"returnTo")));
                }
            }else if("updateShipmentSchedule".equals(action)) {
                int shipmentId=requiredId(req,"shipmentId");
                String back="movementUpdate".equals(param(req,"returnTo"))?"movementUpdate":"shipmentDetails";
                try {
                    shipments.updateSchedule(user,shipmentId,param(req,"etd"),param(req,"eta"));
                    redirect(req,resp,back+"&shipmentId="+shipmentId,"Departure and arrival dates saved together");
                } catch(IllegalArgumentException | SecurityException ex) {
                    req.getSession(false).setAttribute(SCHEDULE_ERROR_KEY,ex.getMessage());
                    resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+
                        "/containerMovement?action="+back+"&shipmentId="+shipmentId+"#nlShipmentSchedule"));
                } catch(SQLException ex) {
                    if(!"45000".equals(ex.getSQLState()) && !"23000".equals(ex.getSQLState()))throw ex;
                    req.getSession(false).setAttribute(SCHEDULE_ERROR_KEY,safeSqlMessage(ex));
                    resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+
                        "/containerMovement?action="+back+"&shipmentId="+shipmentId+"#nlShipmentSchedule"));
                }
            }else if("reportShipmentDelay".equals(action)) {
                int shipmentId=requiredId(req,"shipmentId");
                String back="movementUpdate".equals(param(req,"returnTo"))?"movementUpdate":"shipmentDetails";
                try {
                    shipments.reportDelay(user,shipmentId,param(req,"revisedEta"),param(req,"delayReason"));
                    redirect(req,resp,back+"&shipmentId="+shipmentId+"#nlDelayReport",
                        "Delay reported to the Consumer in shipment details and tracking. Revised ETA saved.");
                } catch(IllegalArgumentException | SecurityException ex) {
                    req.getSession(false).setAttribute(DELAY_ERROR_KEY,ex.getMessage());
                    resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+
                        "/containerMovement?action="+back+"&shipmentId="+shipmentId+"#nlDelayReport"));
                } catch(SQLException ex) {
                    if(!"45000".equals(ex.getSQLState()) && !"23000".equals(ex.getSQLState()))throw ex;
                    req.getSession(false).setAttribute(DELAY_ERROR_KEY,safeSqlMessage(ex));
                    resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+
                        "/containerMovement?action="+back+"&shipmentId="+shipmentId+"#nlDelayReport"));
                }
            }else if("updateShipmentField".equals(action)) {
                int shipmentId=requiredId(req,"shipmentId");
                shipments.updateField(user,shipmentId,param(req,"field"),param(req,"value"));
                String returnTo="movementUpdate".equals(param(req,"returnTo"))?"movementUpdate":"shipmentDetails";
                redirect(req,resp,returnTo+"&shipmentId="+shipmentId,
                    "eta".equals(param(req,"field"))?"Expected arrival date saved":
                    "etd".equals(param(req,"field"))?"Expected departure date saved":"Shipment details saved");
            }else if("refreshProfitLoss".equals(action)) {
                ShipmentPojo sh=requireShipment(user,req);
                profits.refresh(user,sh,requiredMonth(req),requiredMoney(req,"freightCost"),
                     requiredMoney(req,"portCost"),requiredMoney(req,"handlingCost"));
                redirect(req,resp,"profitLoss","Profit/loss report refreshed");
            }else resp.sendError(404,"Unknown Module 2 update action");
        }catch(Exception ex){error(req,resp,ex);}
    }
    private User verify(HttpServletRequest req) throws SQLException {
        HttpSession session=req.getSession(false);
        if(session==null)throw new SecurityException("Please sign in using Module 1");
        Object id=session.getAttribute("userId");
        if(!(id instanceof Number))throw new SecurityException("Please sign in using Module 1");
        // Reload role/company from database to prevent stale or tampered session claims.
        return shipments.verifiedUser(((Number)id).intValue());
    }
    private void setCommon(HttpServletRequest req,User user) {
        req.setAttribute("currentRole",user.getRole());
        req.setAttribute("currentUser",user);
        req.setAttribute("csrfToken",getToken(req.getSession(false)));
        req.setAttribute("statuses",ShipmentPojo.STATUSES);
        HttpSession session=req.getSession(false);
        Object flash=session.getAttribute(FLASH_KEY);
        if(flash!=null){req.setAttribute("notice",flash);session.removeAttribute(FLASH_KEY);}
        Object correctionError=session.getAttribute(CORRECTION_ERROR_KEY);
        if(correctionError!=null){req.setAttribute("correctionError",correctionError);session.removeAttribute(CORRECTION_ERROR_KEY);}
        Object scheduleError=session.getAttribute(SCHEDULE_ERROR_KEY);
        if(scheduleError!=null){req.setAttribute("scheduleError",scheduleError);session.removeAttribute(SCHEDULE_ERROR_KEY);}
        Object delayError=session.getAttribute(DELAY_ERROR_KEY);
        if(delayError!=null){req.setAttribute("delayError",delayError);session.removeAttribute(DELAY_ERROR_KEY);}
        Object cancelError=session.getAttribute(CANCELLATION_ERROR_KEY);
        if(cancelError!=null){req.setAttribute("cancellationError",cancelError);session.removeAttribute(CANCELLATION_ERROR_KEY);}
    }
    private void loadProfitReports(HttpServletRequest req,User user) throws SQLException {
        user.requireStaff();
        Integer seller=optionalId(req,"sellerId");
        LocalDate start=optionalDate(req,"startDate"),end=optionalDate(req,"endDate");
        req.setAttribute("shipmentRecords",profits.shipments(user,seller,start,end));
        req.setAttribute("filterFrom",start);req.setAttribute("filterTo",end);
        req.setAttribute("monthlyRecords",profits.monthly(user,seller,start,end));
    }
    private ShipmentPojo requireShipment(User user,HttpServletRequest req) throws SQLException {
        ShipmentPojo record=shipments.get(user,requiredId(req,"shipmentId"));
        if(record==null)throw new IllegalArgumentException("Shipment not found or access denied");
        return record;
    }
    private static String param(HttpServletRequest req,String name) {return ShipmentPojo.trimToNull(req.getParameter(name));}
    private static int requiredId(HttpServletRequest req,String key) {
        Integer id=optionalId(req,key);
        if(id==null)throw new IllegalArgumentException(key+" is required");
        return id;
    }
    private static Integer optionalId(HttpServletRequest req,String key) {
        String s=param(req,key);
        if(s==null)return null;
        try{int n=Integer.parseInt(s);if(n<=0)throw new NumberFormatException();return n;}
        catch(NumberFormatException ex){throw new IllegalArgumentException(key+" must be a positive integer");}
    }
    private static long requiredLong(HttpServletRequest req,String key) {
        String s=param(req,key);
        try{long n=Long.parseLong(s);if(n<=0)throw new NumberFormatException();return n;}
        catch(Exception ex){throw new IllegalArgumentException(key+" must be a positive integer");}
    }
    private static LocalDate optionalDate(HttpServletRequest req,String key) {
        String s=param(req,key);
        if(s==null)return null;
        try{return LocalDate.parse(s);}catch(DateTimeParseException ex){throw new IllegalArgumentException(key+" must be YYYY-MM-DD");}
    }
    private static LocalDate requiredMonth(HttpServletRequest req) {
        String s=param(req,"periodMonth");
        if(s==null)throw new IllegalArgumentException("Reporting month is required");
        try{return s.length()==7?YearMonth.parse(s).atDay(1):LocalDate.parse(s).withDayOfMonth(1);}
        catch(DateTimeParseException ex){throw new IllegalArgumentException("Invalid reporting month");}
    }
    private static BigDecimal requiredMoney(HttpServletRequest req,String key) {
        String s=param(req,key);
        try{if(s==null)throw new NumberFormatException();return new BigDecimal(s);}
        catch(NumberFormatException ex){throw new IllegalArgumentException(key+" requires a decimal amount");}
    }
    private String getToken(HttpSession session) {
        Object existing=session.getAttribute(TOKEN_KEY);
        if(existing instanceof String)return (String)existing;
        String value=UUID.randomUUID().toString();session.setAttribute(TOKEN_KEY,value);
        return value;
    }
    private boolean validToken(HttpServletRequest req) {
        HttpSession s=req.getSession(false);
        Object expected=s==null?null:s.getAttribute(TOKEN_KEY);
        String supplied=req.getParameter("csrfToken");
        return expected instanceof String&&supplied!=null&&
            MessageDigest.isEqual(((String)expected).getBytes(StandardCharsets.UTF_8),
                                  supplied.getBytes(StandardCharsets.UTF_8));
    }
    private static void page(HttpServletRequest req,HttpServletResponse resp,String name)
            throws ServletException,IOException {
        req.getRequestDispatcher(VIEWS+name).forward(req,resp);
    }
    private static void redirect(HttpServletRequest req,HttpServletResponse resp,String route,String notice)
            throws IOException {
        req.getSession(false).setAttribute(FLASH_KEY,notice);
        resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+"/containerMovement?action="+route));
    }
    private static void redirectCorrectionError(HttpServletRequest req,HttpServletResponse resp,
                                                int shipmentId,String message,boolean movementUpdate) throws IOException {
        req.getSession(false).setAttribute(CORRECTION_ERROR_KEY,
            message==null||message.trim().isEmpty()?"Unable to undo this checkpoint.":message);
        resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath()+
            "/containerMovement?action="+(movementUpdate?"movementUpdate":"timeline")+"&shipmentId="+shipmentId+"#checkpointCorrection"));
    }
    private static String correctionMessage(SQLException ex) {
        String reason=safeSqlMessage(ex);
        String lower=reason.toLowerCase(java.util.Locale.ROOT);
        if(lower.contains("claim")) return "Undo is unavailable because this shipment has claim history.";
        if(lower.contains("latest")) return "Only the newest checkpoint can be undone. Refresh the shipment timeline.";
        if(lower.contains("terminal")||lower.contains("booked")||lower.contains("delivered")||lower.contains("cancelled"))
            return "Booking and final checkpoints are protected and cannot be undone.";
        return "The database did not permit the correction: "+reason;
    }
    private static void exportCsv(HttpServletResponse resp,String file,String data) throws IOException {
        resp.setContentType("text/csv; charset=UTF-8");resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Content-Disposition","attachment; filename=\""+file+"\"");
        resp.getWriter().write('\uFEFF');resp.getWriter().write(data);
    }
    private void error(HttpServletRequest req,HttpServletResponse resp,Exception ex)
            throws ServletException,IOException {
        int status=500;
        String message="Unexpected server error. Check Tomcat logs.";
        if(ex instanceof SecurityException){status=403;message=ex.getMessage();
            if(message!=null&&message.startsWith("Please sign in"))status=401;}
        else if(ex instanceof IllegalArgumentException){status=400;message=ex.getMessage();}
        else if(ex instanceof SQLException){
            SQLException sql=(SQLException)ex;
            if("45000".equals(sql.getSQLState())){status=400;message="Operation rejected by database rules: "+safeSqlMessage(sql);}
            else if("23000".equals(sql.getSQLState())){status=409;message="This change conflicts with existing database records";}
        }
        getServletContext().log("Module 2 request failed: "+message,ex);
        if(resp.isCommitted())return;
        resp.setStatus(status);
        req.setAttribute("errorMessage",message);
        req.setAttribute("statusCode",status);
        page(req,resp,"module2Error.jsp");
    }
    private static String safeSqlMessage(SQLException ex) {
        // MySQL SIGNAL business errors may include user-facing validation details.
        String s=ex.getMessage();
        if(s==null||s.isEmpty())return "Please verify the shipment state and permissions.";
        s=s.replaceAll("(?s)^.*?MESSAGE_TEXT[^:]*: *","");
        return s.length()>180?s.substring(0,180):s;
    }
}
