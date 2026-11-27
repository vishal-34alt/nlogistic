
package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

import model.User;
import model.Company;
import model.Customer;
import model.InfrastructureActions;
import model.WorkspaceSearchActions;
import model.DashboardActions;
import model.ProfileActions;
import model.AccountRegistrationActions;
import model.Module1Actions;



@WebServlet(urlPatterns = {"/Module1Controller", "/adminInfrastructure"})
public class Module1Controller extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Module1Actions accounts=new Module1Actions();
    // Admin ports/vessels belong to Module 1, not a separate servlet.
    private InfrastructureActions infrastructureActions;

    @Override
    public void init() throws ServletException {
        infrastructureActions=new InfrastructureActions();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (isInfrastructureRoute(request)) {
            processInfrastructure(request, response, false);
            return;
        }
        processRequest(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (isInfrastructureRoute(request)) {
            processInfrastructure(request, response, true);
            return;
        }
        processRequest(request, response);
    }

    private void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = "viewLogin";
        }

        HttpSession csrfSession = request.getSession();
        if (csrfSession.getAttribute("csrfToken") == null) {
            csrfSession.setAttribute("csrfToken", UUID.randomUUID().toString());
        }
        List<String> changes=Arrays.asList("login","register","logout","updateUser","deleteUser","addUser","addCompany","updateCompany","updateCompanyAll","deleteCompany","addCustomer","updateCustomer","updateCustomerAll","deleteCustomer","saveProfile","changePassword");
        if(changes.contains(action)) {
            if(!"POST".equalsIgnoreCase(request.getMethod())){response.sendError(405,"Use POST for changes");return;}
            String expected=(String)csrfSession.getAttribute("csrfToken");
            String provided=request.getParameter("csrfToken");
            if(provided==null||!MessageDigest.isEqual(expected.getBytes(StandardCharsets.UTF_8),provided.getBytes(StandardCharsets.UTF_8))) {
                // A sign-in form left open across session expiry/restart has an old token.
                // Do not process its credentials or bypass CSRF; issue a fresh form instead.
                if("login".equals(action)||"register".equals(action)) {
                    response.sendRedirect(request.getContextPath()+"/Module1Controller?action="
                            +("login".equals(action)?"viewLogin":"viewRegister")+"&error=session_expired");
                } else {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN,
                            "This form has expired. Reload the page before submitting again.");
                }
                return;
            }
        }

        // Public pages are forwarded, not exposed as web-root JSPs.
        if ("viewLogin".equals(action) || "viewRegister".equals(action)) {
            if (!"GET".equalsIgnoreCase(request.getMethod())) {
                response.sendError(405, "Use GET to display this page");
                return;
            }
            request.getRequestDispatcher("/WEB-INF/views/Module1/" +
                    ("viewLogin".equals(action) ? "login.jsp" : "register.jsp"))
                    .forward(request, response);
            return;
        }
        if ("dashboard".equals(action)) {
            if (!"GET".equalsIgnoreCase(request.getMethod())) {
                response.sendError(405, "Use GET to display the dashboard");
                return;
            }
            HttpSession loggedIn = request.getSession(false);
            if (loggedIn == null || !(loggedIn.getAttribute("userId") instanceof Number)) {
                response.sendRedirect(request.getContextPath() +
                        "/Module1Controller?action=viewLogin&error=login_required");
                return;
            }
            try {
                request.setAttribute("dashboardSummary",new DashboardActions().summary(((Number)loggedIn.getAttribute("userId")).intValue()));
            } catch(SQLException metricsError) {
                getServletContext().log("Dashboard metrics unavailable",metricsError);
                // Keep the workspace available. The view displays 'unavailable', never fabricated metrics.
            }
            request.getRequestDispatcher("/WEB-INF/views/Module1/dashboard.jsp")
                    .forward(request, response);
            return;
        }

        if (!checkAccess(request, response, action)) {
            return;
        }

        // Profile requests are available to every authenticated role.
        // Model performs field validation; DAO implementation performs all JDBC.
        if("viewProfile".equals(action) || "saveProfile".equals(action) || "changePassword".equals(action)) {
            handleProfile(request,response,action);
            return;
        }

        try {

            switch (action) {

                // LOGIN
                case "login":
                    loginUser(request, response);
                    break;

                // REGISTRATION
                case "register":
                    registerUser(request, response);
                    break;

                // AUTHENTICATED WORKSPACE SEARCH: scoped by the DB user's role/company.
                case "workspaceSearch":
                    if(!"GET".equalsIgnoreCase(request.getMethod())){
                        response.sendError(405,"Use GET for search");return;
                    }
                    String term=request.getParameter("q");
                    request.setAttribute("searchTerm",term==null?"":term.trim());
                    request.setAttribute("searchHits",new WorkspaceSearchActions().search(getLoggedInUserId(request),term));
                    request.getRequestDispatcher("/WEB-INF/views/Module1/workspace-search.jsp").forward(request,response);
                    break;

                // USERS
                case "users":
                    request.setAttribute("companies", accounts.companies());
                    request.setAttribute(
                        "users", accounts.users()
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/users.jsp")
                           .forward(request, response);
                    break;

                case "searchUsers":
                    request.setAttribute("companies", accounts.companies());
                    request.setAttribute(
                        "users",
                        accounts.searchUsers(
                            request.getParameter("keyword"),
                            request.getParameter("role"),
                            request.getParameter("status")
                        )
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/users.jsp")
                           .forward(request, response);
                    break;

                case "addUser": {
                    try {
                        String companyRaw=request.getParameter("companyId");
                        Integer company=(companyRaw==null||companyRaw.trim().isEmpty())?null:Integer.valueOf(companyRaw.trim());
                        int newUser=accounts.addUser(getLoggedInUserId(request),request.getParameter("fullName"),request.getParameter("email"),request.getParameter("phone"),request.getParameter("role"),request.getParameter("password"),company);
                        request.getSession().removeAttribute("nlAddUserDraft");
                        request.getSession().removeAttribute("nlAddUserError");
                        response.sendRedirect("Module1Controller?action=users&created="+newUser);
                    } catch (SQLException | IllegalArgumentException | SecurityException ex) {
                        getServletContext().log("Add User rejected; administrator remains logged in", ex);
                        java.util.Map<String,String> draft=new java.util.HashMap<>();
                        for(String field:new String[]{"fullName","email","phone","role","companyId"}) {
                            String value=request.getParameter(field);
                            draft.put(field,value==null?"":value.substring(0,Math.min(value.length(),170)));
                        }
                        HttpSession active=request.getSession();
                        active.setAttribute("nlAddUserDraft",draft); // Never store the temporary password
                        String explanation;
                        if(ex instanceof SecurityException) explanation="You do not have permission to create this account.";
                        else if(ex instanceof NumberFormatException) explanation="Choose a valid existing company.";
                        else if(ex instanceof SQLException && "23000".equals(((SQLException)ex).getSQLState())) explanation="The email or another unique account value is already registered.";
                        else if(ex instanceof SQLException && "45000".equals(((SQLException)ex).getSQLState())) explanation="The database rejected the supplied account details. Check the role, company, email and password.";
                        else if(ex instanceof IllegalArgumentException) explanation="Check the name, email, role, company and password (minimum eight characters).";
                        else explanation="Account creation could not be completed. No account was confirmed; check the values and try again.";
                        active.setAttribute("nlAddUserError",explanation);
                        response.sendRedirect("Module1Controller?action=users&addUserFailed=1");
                    }
                    break;
                }
                case "updateUser":
                    updateUser(request, response);
                    break;

                case "deleteUser":
                    int targetId=Integer.parseInt(request.getParameter("userId"));
                    accounts.deactivateUser(getLoggedInUserId(request),targetId,request.getRemoteAddr());

                    response.sendRedirect(
                        "Module1Controller?action=users"
                    );
                    break;

                // LOGOUT
                case "logout":
                    logoutUser(request, response);
                    break;

                // COMPANIES
                case "companies":
                    request.setAttribute(
                        "companies", accounts.companies()
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/companies.jsp")
                           .forward(request, response);
                    break;

                case "searchCompanies":
                    request.setAttribute(
                        "companies",
                        accounts.searchCompanies(
                            request.getParameter("keyword"),
                            request.getParameter("companyType")
                        )
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/companies.jsp")
                           .forward(request, response);
                    break;

                case "addCompany": {
                    try {
                        addCompany(request);
                        request.getSession().setAttribute("companyEditFlash", "OK:Company created successfully.");
                    } catch (SQLException | IllegalArgumentException ex) {
                        getServletContext().log("Company creation rejected", ex);
                        request.getSession().setAttribute("companyEditFlash", "ERROR:"+directoryEditError(ex));
                    }
                    response.sendRedirect("Module1Controller?action=companies");
                    break;
                }

                case "updateCompany":
                    updateCompany(request, response);
                    break;

                case "updateCompanyAll": {
                    try {
                        accounts.updateCompanyAll(getLoggedInUserId(request),Integer.parseInt(request.getParameter("recordId")),
                            request.getParameter("companyName"),request.getParameter("companyType"),
                            request.getParameter("gstNumber"),request.getParameter("iecCode"),request.getParameter("address"),
                            request.getParameter("city"),request.getParameter("country"),request.getRemoteAddr());
                        request.getSession().setAttribute("companyEditFlash","OK:Company details updated successfully.");
                    }catch(SQLException|IllegalArgumentException ex){
                        getServletContext().log("Company edit rejected",ex);
                        request.getSession().setAttribute("companyEditFlash","ERROR:"+directoryEditError(ex));
                    }
                    response.sendRedirect("Module1Controller?action=companies");break;
                }
                case "deleteCompany":
                    accounts.deleteCompany(getLoggedInUserId(request),Integer.parseInt(request.getParameter("companyId")));
                    response.sendRedirect("Module1Controller?action=companies&removed=1");
                    break;

                // CUSTOMERS
                case "customers":
                    request.setAttribute(
                        "customers", accounts.customers()
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/customers.jsp")
                           .forward(request, response);
                    break;

                case "searchCustomers":
                    request.setAttribute(
                        "customers",
                        accounts.searchCustomers(
                            request.getParameter("keyword")
                        )
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/customers.jsp")
                           .forward(request, response);
                    break;

                case "addCustomer":
                    addCustomer(request, response);
                    break;

                case "updateCustomer":
                    updateCustomer(request, response);
                    break;

                case "updateCustomerAll": {
                    try {
                        accounts.updateCustomerAll(getLoggedInUserId(request),Integer.parseInt(request.getParameter("recordId")),
                            request.getParameter("contactPerson"),request.getParameter("billingAddress"),
                            request.getParameter("creditLimit"),request.getRemoteAddr());
                        request.getSession().setAttribute("customerEditFlash","OK:Customer details updated successfully.");
                    }catch(SQLException|IllegalArgumentException ex){
                        getServletContext().log("Customer edit rejected",ex);
                        request.getSession().setAttribute("customerEditFlash","ERROR:"+directoryEditError(ex));
                    }
                    response.sendRedirect("Module1Controller?action=customers");break;
                }
                case "deleteCustomer":
                    accounts.deleteConsumer(
                        getLoggedInUserId(request),
                        Integer.parseInt(
                            request.getParameter("customerId")
                        )
                    );

                    response.sendRedirect(
                        "Module1Controller?action=customers"
                    );
                    break;

                // AUDIT LOGS
                case "auditLogs":
                    request.setAttribute(
                        "auditLogs",
                        accounts.auditLogs()
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/audit-log.jsp")
                           .forward(request, response);
                    break;

                case "searchAuditLog":

                    String userIdParam =
                        request.getParameter("userId");

                    String tableName =
                        request.getParameter("tableName");

                    Integer searchUserId = null;

                    if (userIdParam != null &&
                        !userIdParam.trim().isEmpty()) {

                        try {
                            searchUserId =
                                Integer.parseInt(userIdParam.trim());

                            if (searchUserId <= 0) {
                                throw new NumberFormatException();
                            }

                        } catch (NumberFormatException e) {
                            throw new IllegalArgumentException(
                                "Valid User ID is required."
                            );
                        }
                    }

                    request.setAttribute(
                        "auditLogs",
                        accounts.searchAuditLogs(
                            searchUserId,
                            tableName
                        )
                    );

                    request.getRequestDispatcher("/WEB-INF/views/Module1/audit-log.jsp")
                           .forward(request, response);
                    break;

                default:
                    response.sendRedirect("Module1Controller?action=dashboard");
                    break;
            }

        } catch (Exception e) {
            getServletContext().log("Module 1 request failed", e);
            if(e instanceof SQLException && ((SQLException)e).getSQLState()!=null
                    && ((SQLException)e).getSQLState().startsWith("08")) {
                showDatabaseUnavailable(request,response);
                return;
            }
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.setAttribute("errorMessage", "Unable to complete the request. Please check the form or contact the administrator.");
            request.getRequestDispatcher("/WEB-INF/views/Module1/error.jsp")
                   .forward(request, response);
        }
    }


    private void showDatabaseUnavailable(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        response.setHeader("Cache-Control", "no-store");
        response.setHeader("Retry-After", "10");
        request.getRequestDispatcher("/WEB-INF/views/Module1/database-unavailable.jsp")
                .forward(request, response);
    }

    /**
     * Module 1 also owns Admin port and vessel management.
     * Both /Module1Controller and the existing /adminInfrastructure links
     * are handled by this single Module 1 controller.
     */
    private boolean isInfrastructureRoute(HttpServletRequest request) {
        return "/adminInfrastructure".equals(request.getServletPath());
    }

    private String infrastructureParameter(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private Integer optionalInfrastructureInt(HttpServletRequest request, String name) {
        String value = infrastructureParameter(request, name);
        return value.isEmpty() ? null : Integer.valueOf(value);
    }

    private void processInfrastructure(HttpServletRequest request, HttpServletResponse response,
                                       boolean modifying) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute("userId") instanceof Number)) {
            response.sendRedirect(request.getContextPath()+"/Module1Controller?action=viewLogin&error=login_required");
            return;
        }
        if (!"ADMIN".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);return;
        }
        int actor=((Number)session.getAttribute("userId")).intValue();
        if (!modifying) {
            try {
                request.setAttribute("ports",infrastructureActions.ports(actor));
                request.setAttribute("vessels",infrastructureActions.vessels(actor));
                request.setAttribute("sellers",infrastructureActions.sellers(actor));
                Object flash=session.getAttribute("infrastructureFlash");
                if(flash!=null){request.setAttribute("infrastructureFlash",flash);session.removeAttribute("infrastructureFlash");}
                request.getRequestDispatcher("/WEB-INF/views/Module1/infrastructure.jsp").forward(request,response);
            }catch(SQLException ex){
                getServletContext().log("Infrastructure directory unavailable",ex);
                response.sendError(500,"Unable to load port and vessel information.");
            }
            return;
        }
        Object expected=session.getAttribute("csrfToken");
        String provided=request.getParameter("csrfToken");
        if(!(expected instanceof String)||provided==null||!MessageDigest.isEqual(
                ((String)expected).getBytes(StandardCharsets.UTF_8),provided.getBytes(StandardCharsets.UTF_8))){
            response.sendError(403,"Invalid request token");return;
        }
        String action=infrastructureParameter(request,"action");
        // All infrastructure actions use the standard POST / redirect / flash cycle.
        String tab=action.toLowerCase(java.util.Locale.ROOT).contains("vessel")?"vessels":"ports";
        String feedback="Saved successfully.";
        try {
            switch(action){
                case "addPort":
                    infrastructureActions.addPort(actor,infrastructureParameter(request,"portCode"),
                        infrastructureParameter(request,"portName"),infrastructureParameter(request,"city"),
                        infrastructureParameter(request,"country"),infrastructureParameter(request,"latitude"),
                        infrastructureParameter(request,"longitude"));
                    feedback="Port added successfully.";break;
                case "editPort":
                    infrastructureActions.editPort(actor,Integer.parseInt(infrastructureParameter(request,"id")),
                        infrastructureParameter(request,"field"),infrastructureParameter(request,"value"));
                    feedback="Port information updated.";break;
                case "updatePortDetails":
                    infrastructureActions.updatePortDetails(actor,Integer.parseInt(infrastructureParameter(request,"id")),
                        infrastructureParameter(request,"portCode"),infrastructureParameter(request,"portName"),
                        infrastructureParameter(request,"city"),infrastructureParameter(request,"country"),
                        infrastructureParameter(request,"latitude"),infrastructureParameter(request,"longitude"));
                    feedback="All port details updated.";break;
                case "deletePort":
                    infrastructureActions.deletePort(actor,Integer.parseInt(infrastructureParameter(request,"id")));
                    feedback="Port deleted successfully. Related pricing rules were detached automatically if present.";break;
                case "addVesselWithNewSeller":
                    tab="vessels";
                    infrastructureActions.addVesselWithNewSeller(actor,
                        infrastructureParameter(request,"vesselName"),infrastructureParameter(request,"imoNumber"),
                        optionalInfrastructureInt(request,"capacityTeu"),infrastructureParameter(request,"companyName"),
                        infrastructureParameter(request,"gstNumber"),infrastructureParameter(request,"iecCode"),
                        infrastructureParameter(request,"companyAddress"),infrastructureParameter(request,"companyCity"),
                        infrastructureParameter(request,"companyCountry"));
                    feedback="Seller company and vessel created together successfully.";break;
                case "addVessel":
                    infrastructureActions.addVessel(actor,infrastructureParameter(request,"vesselName"),
                        infrastructureParameter(request,"imoNumber"),optionalInfrastructureInt(request,"ownerCompanyId"),
                        optionalInfrastructureInt(request,"capacityTeu"));
                    feedback="Vessel added successfully.";break;
                case "editVessel":
                    infrastructureActions.editVessel(actor,Integer.parseInt(infrastructureParameter(request,"id")),
                        infrastructureParameter(request,"field"),infrastructureParameter(request,"value"));
                    feedback="Vessel updated successfully.";break;
                case "updateVesselDetails":
                    infrastructureActions.updateVesselDetails(actor,Integer.parseInt(infrastructureParameter(request,"id")),
                        infrastructureParameter(request,"vesselName"),infrastructureParameter(request,"imoNumber"),
                        optionalInfrastructureInt(request,"ownerCompanyId"),optionalInfrastructureInt(request,"capacityTeu"),
                        infrastructureParameter(request,"status"));
                    feedback="All vessel details updated.";break;
                case "setVesselStatus":
                    tab="vessels";
                    String state=infrastructureParameter(request,"status");
                    infrastructureActions.setVesselStatus(actor,Integer.parseInt(infrastructureParameter(request,"id")),state);
                    feedback="ACTIVE".equals(state)?"Vessel activated. It is now available for operations.":
                            "Vessel moved to Maintenance. Existing shipments and history are preserved; new assignments are disabled.";
                    break;
                case "deleteVessel":
                    infrastructureActions.deleteVessel(actor,Integer.parseInt(infrastructureParameter(request,"id")));
                    feedback="Unreferenced vessel deleted.";break;
                default:response.sendError(400,"Unknown administration action");return;
            }
            session.setAttribute("infrastructureFlash","OK:"+feedback);
        }catch(SQLException|IllegalArgumentException ex){
            getServletContext().log("Infrastructure update rejected",ex);
            String message=ex.getMessage()==null?"Unable to save the change.":ex.getMessage();
            if(message.length()>240)message=message.substring(0,240);
            if(ex instanceof SQLException) {
                String state=((SQLException)ex).getSQLState();
                if("23000".equals(state))message="This code, IMO number or relationship already exists. Check for duplicates.";
                else if("28000".equals(state))message="Only an active administrator can change these records.";
                else if(!"45000".equals(state))message="Database rejected the change. Check required fields and linked records.";
            }
            session.setAttribute("infrastructureFlash","ERROR:"+message);
        }
        response.sendRedirect(request.getContextPath()+"/adminInfrastructure?tab="+tab);
    }

    private static String directoryEditError(Exception error) {
        if(error instanceof SQLException && "23000".equals(((SQLException)error).getSQLState()))
            return "A unique value or linked record conflicts with this change.";
        String message=error.getMessage();
        return message==null?"Could not save the changes.":message.substring(0,Math.min(180,message.length()));
    }

    // AUTHENTICATION AND ROLE-BASED ACCESS
    private boolean checkAccess(
            HttpServletRequest request,
            HttpServletResponse response,
            String action) throws IOException {

        if ("login".equals(action) ||
            "register".equals(action)) {
            return true;
        }

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                "Module1Controller?action=viewLogin&error=login_required"
            );
            return false;
        }

        if ("logout".equals(action)) {
            return true;
        }
        if ("workspaceSearch".equals(action) || "viewProfile".equals(action) ||
                "saveProfile".equals(action) || "changePassword".equals(action)) {
            return true;
        }

        String role = (String) session.getAttribute("role");

        if (role == null ||
            !"ADMIN".equalsIgnoreCase(role)) {

            response.sendRedirect(
                "Module1Controller?action=dashboard&error=access_denied"
            );
            return false;
        }

        return true;
    }

    /** Single entry point for user profile display/edit, independent of role. */
    private void handleProfile(HttpServletRequest req,HttpServletResponse res,String action)
            throws ServletException,IOException {
        HttpSession session=req.getSession(false);
        if(session==null || !(session.getAttribute("userId") instanceof Number)) {
            res.sendRedirect(req.getContextPath()+"/Module1Controller?action=viewLogin");return;
        }
        final int actor=((Number)session.getAttribute("userId")).intValue();
        ProfileActions profile=new ProfileActions();
        try {
            if("viewProfile".equals(action)) {
                if(!"GET".equalsIgnoreCase(req.getMethod())) {res.sendError(405);return;}
                req.setAttribute("profile",profile.profile(actor));
                req.getRequestDispatcher("/WEB-INF/views/Module1/profile.jsp").forward(req,res);
                return;
            }
            if("saveProfile".equals(action)) {
                User updated="all".equals(req.getParameter("editMode"))
                    ? profile.saveContact(actor,req.getParameter("fullName"),req.getParameter("email"),req.getParameter("phone"),req.getRemoteAddr())
                    : profile.updateOwnField(actor,req.getParameter("fieldName"),req.getParameter("newValue"),req.getRemoteAddr());
                session.setAttribute("userName",updated.getFullName());
                session.setAttribute("fullName",updated.getFullName());
                res.sendRedirect(req.getContextPath()+"/Module1Controller?action=viewProfile&msg=saved");
            } else if("changePassword".equals(action)) {
                profile.changePassword(actor,req.getParameter("currentPassword"),req.getParameter("newPassword"),req.getParameter("confirmPassword"),req.getRemoteAddr());
                session.invalidate();
                res.sendRedirect(req.getContextPath()+"/Module1Controller?action=viewLogin&msg=password_changed");
            } else res.sendError(404);
        } catch (IllegalArgumentException ex) {
            req.setAttribute("profileError",ex.getMessage());
            try {req.setAttribute("profile",profile.profile(actor));}
            catch(SQLException dbError){getServletContext().log("Profile refresh failed",dbError);res.sendError(500);return;}
            res.setStatus(400);
            req.getRequestDispatcher("/WEB-INF/views/Module1/profile.jsp").forward(req,res);
        } catch(SecurityException ex) {
            res.sendError(403,"Account access denied");
        } catch(SQLException ex) {
            getServletContext().log("Profile database update failed",ex);
            req.setAttribute("profileError","Unable to save your changes. Check for duplicate email or invalid input.");
            try {req.setAttribute("profile",profile.profile(actor));}
            catch(SQLException dbError){res.sendError(500);return;}
            res.setStatus("45000".equals(ex.getSQLState())?400:500);
            req.getRequestDispatcher("/WEB-INF/views/Module1/profile.jsp").forward(req,res);
        }
    }

    // LOGIN
    private void loginUser(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user;
        try { user = accounts.login(email, password); }
        catch(SQLException ex) { if("45000".equals(ex.getSQLState())) {
            response.sendRedirect("Module1Controller?action=viewLogin&error=invalid");return;
        } throw ex; }

        if (user != null) {

            HttpSession oldSession = request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);

            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("role", user.getRole());
            session.setAttribute("companyId", user.getCompanyId());
            session.setAttribute("fullName", user.getFullName());
            session.setMaxInactiveInterval(1800);

            response.sendRedirect("Module1Controller?action=dashboard");

        } else {
            response.sendRedirect("Module1Controller?action=viewLogin&error=invalid");
        }
    }

    /** Preserve non-secret registration input after validation errors (PRG). */
    private void registrationError(HttpServletRequest req,HttpServletResponse res,String code) throws IOException {
        java.util.Map<String,String> draft=new java.util.HashMap<>();
        for(String name:new String[]{"fullName","email","companyName","role","phone"}){
            String value=req.getParameter(name);
            if(value!=null)draft.put(name,value.length()>200?value.substring(0,200):value);
        }
        req.getSession().setAttribute("registrationDraft",draft);
        res.sendRedirect(req.getContextPath()+"/Module1Controller?action=viewRegister&error="+code);
    }

    // REGISTRATION
    private void registerUser(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String password = request.getParameter("password");
        String confirmPassword =
            request.getParameter("confirmPassword");

        try {
            int newUserId=new AccountRegistrationActions().register(fullName,email,phone,role,password,
                    confirmPassword,request.getParameter("companyName"));
            if(newUserId>0){response.sendRedirect("Module1Controller?action=viewLogin&msg=registered");return;}
            registrationError(request,response,"invalid");
        } catch (IllegalArgumentException badInput) {
            registrationError(request,response,badInput.getMessage());
        } catch (SQLException databaseError) {
            getServletContext().log("Account registration failed",databaseError);
            registrationError(request,response,"invalid");
        }
    }

    // UPDATE USER: keep administrators on the list with clear feedback.
    private void updateUser(HttpServletRequest request,HttpServletResponse response)
            throws SQLException, IOException {
        String notice="saved";
        try {
            int recordId=Integer.parseInt(request.getParameter("recordId"));
            if("all".equals(request.getParameter("editMode"))){
                accounts.updateUserAll(getLoggedInUserId(request),recordId,
                    request.getParameter("fullName"),request.getParameter("email"),
                    request.getParameter("phone"),request.getParameter("status"),request.getRemoteAddr());
            }else{
                accounts.updateUser(getLoggedInUserId(request),recordId,
                    request.getParameter("fieldName"),request.getParameter("newValue"),request.getRemoteAddr());
            }
        } catch (SecurityException denied) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,"Account update not authorized");
            return;
        } catch (IllegalArgumentException invalid) {
            notice="invalid";
        } catch (SQLException databaseError) {
            getServletContext().log("Account update failed",databaseError);
            notice="23000".equals(databaseError.getSQLState())?"duplicate":"failed";
        }
        response.sendRedirect(request.getContextPath()+"/Module1Controller?action=users&accountNotice="+notice);
    }

    // LOGOUT
    private void logoutUser(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {

            Object id = session.getAttribute("userId");

            if (id != null) {
                accounts.logout((Integer) id);
            }

            session.invalidate();
        }

        response.sendRedirect(
            "Module1Controller?action=viewLogin&msg=logout"
        );
    }

    // ADD COMPANY
    private void addCompany(HttpServletRequest request) throws SQLException {

        Company company = new Company();

        company.setCompanyName(
            request.getParameter("companyName")
        );

        company.setCompanyType(
            request.getParameter("companyType")
        );

        company.setGstNumber(
            request.getParameter("gstNumber")
        );

        company.setIecCode(
            request.getParameter("iecCode")
        );

        company.setAddress(
            request.getParameter("address")
        );

        company.setCity(
            request.getParameter("city")
        );

        company.setCountry(
            request.getParameter("country")
        );

        if (!company.isValidCompany()) {
            throw new IllegalArgumentException(
                "Invalid company details."
            );
        }

        accounts.addCompany(company);
    }

    // UPDATE COMPANY
    private void updateCompany(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        accounts.updateCompany(
            getLoggedInUserId(request),
            Integer.parseInt(
                request.getParameter("recordId")
            ),
            request.getParameter("fieldName"),
            request.getParameter("newValue"),
            request.getRemoteAddr()
        );

        response.sendRedirect(
            "Module1Controller?action=companies"
        );
    }

    // ADD CUSTOMER
    private void addCustomer(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        Customer customer = new Customer();

        customer.setUserId(
            Integer.parseInt(
                request.getParameter("userId")
            )
        );

        customer.setCompanyId(
            Integer.parseInt(
                request.getParameter("companyId")
            )
        );

        customer.setContactPerson(
            request.getParameter("contactPerson")
        );

        customer.setBillingAddress(
            request.getParameter("billingAddress")
        );

        String creditLimit =
            request.getParameter("creditLimit");

        if (creditLimit != null &&
            !creditLimit.trim().isEmpty()) {

            customer.setCreditLimit(
                new BigDecimal(creditLimit.trim())
            );
        }

        if (!customer.isValidCustomer() ||
            !customer.hasValidCreditLimit()) {

            throw new IllegalArgumentException(
                "Invalid customer details or credit limit."
            );
        }

        accounts.addCustomer(customer);

        response.sendRedirect(
            "Module1Controller?action=customers"
        );
    }

    // UPDATE CUSTOMER
    private void updateCustomer(
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException, IOException {

        accounts.updateCustomer(
            getLoggedInUserId(request),
            Integer.parseInt(
                request.getParameter("recordId")
            ),
            request.getParameter("fieldName"),
            request.getParameter("newValue"),
            request.getRemoteAddr()
        );

        response.sendRedirect(
            "Module1Controller?action=customers"
        );
    }

    // GET LOGGED-IN USER ID
    private int getLoggedInUserId(
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            throw new IllegalStateException(
                "Please login first."
            );
        }

        return (Integer) session.getAttribute("userId");
    }
}
