package model;
import javax.servlet.*;import javax.servlet.annotation.WebFilter;import javax.servlet.http.*;
import java.io.IOException;import java.sql.SQLException;import java.util.*;
/** All seven modules trust ONLY Module1's authenticated session, refreshed from active users table. */
@WebFilter(urlPatterns="/*")
public final class UnifiedAuthFilter implements Filter {
 private static final Set<String> ADMIN_JSP=new HashSet<>(Arrays.asList("/WEB-INF/views/Module1/users.jsp","/WEB-INF/views/Module1/companies.jsp","/WEB-INF/views/Module1/customers.jsp","/WEB-INF/views/Module1/audit-log.jsp"));
 @Override public void doFilter(ServletRequest input,ServletResponse output,FilterChain chain)throws IOException,ServletException {
  HttpServletRequest r=(HttpServletRequest)input;HttpServletResponse p=(HttpServletResponse)output;
  p.setHeader("X-Content-Type-Options","nosniff");p.setHeader("X-Frame-Options","SAMEORIGIN");p.setHeader("Referrer-Policy","strict-origin-when-cross-origin");
  String path=r.getRequestURI().substring(r.getContextPath().length());
  if(path.startsWith("/assets/")||path.startsWith("/templates/")||path.equals("/favicon.ico")||path.equals("/")){
   HttpSession s=r.getSession(true);if(s.getAttribute("csrfToken")==null)s.setAttribute("csrfToken",java.util.UUID.randomUUID().toString());chain.doFilter(input,output);return;
  }
  if(path.equals("/Module1Controller")&&("login".equals(r.getParameter("action"))||"register".equals(r.getParameter("action"))||"viewLogin".equals(r.getParameter("action"))||"viewRegister".equals(r.getParameter("action"))||(r.getParameter("action")==null&&"GET".equals(r.getMethod())))){
   HttpSession s=r.getSession(true);if(s.getAttribute("csrfToken")==null)s.setAttribute("csrfToken",java.util.UUID.randomUUID().toString());chain.doFilter(input,output);return;
  }
  HttpSession session=r.getSession(false);
  if(session==null||!(session.getAttribute("userId") instanceof Number)){p.sendRedirect(r.getContextPath()+"/Module1Controller?action=viewLogin&error=login_required");return;}
  int user=((Number)session.getAttribute("userId")).intValue();
  User active;
  try {active=new AuthSessionActions().activeUser(user);}
  catch(SQLException e){
   r.getServletContext().log("Authentication DB check failed; session has been retained for retry",e);
   p.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
   p.setHeader("Cache-Control","no-store");
   p.setHeader("Retry-After","10");
   r.getRequestDispatcher("/WEB-INF/views/Module1/database-unavailable.jsp").forward(r,p);
   return;
  }
  String role=active==null?null:active.getRole();
  Integer company=active==null?null:active.getCompanyId();
  String name=active==null?null:active.getFullName();
  if(role==null){session.invalidate();p.sendRedirect(r.getContextPath()+"/Module1Controller?action=viewLogin&error=login_required");return;}
  session.setAttribute("role",role);session.setAttribute("companyId",company);session.setAttribute("userName",name);session.setAttribute("fullName",name);
  if(session.getAttribute("csrfToken")==null)session.setAttribute("csrfToken",java.util.UUID.randomUUID().toString());
  if(ADMIN_JSP.contains(path)&&!"ADMIN".equals(role)){p.sendError(403);return;}
  if(Arrays.asList("/WEB-INF/views/Module3/containers.jsp","/WEB-INF/views/Module3/pricing.jsp","/WEB-INF/views/Module3/pricing-audit.jsp").contains(path)&&!"SELLER".equals(role)){p.sendError(403);return;}
  if(Arrays.asList("/WEB-INF/views/Module3/booking.jsp","/WEB-INF/views/Module3/booking-result.jsp").contains(path)&&!"CONSUMER".equals(role)){p.sendError(403);return;}
  if(path.equals("/WEB-INF/views/Module6/analytics.jsp") && !("ADMIN".equals(role)||"SELLER".equals(role))){p.sendError(403);return;}
  if((path.equals("/stock")||path.startsWith("/WEB-INF/views/Module4/"))&&!"SELLER".equals(role)){p.sendError(403);return;}
  if(path.equals("/analytics")&&"CONSUMER".equals(role)){p.sendError(403);return;}
  if(path.equals("/ContainerAllocationPricingController")){
   String module=r.getParameter("module");if("booking".equalsIgnoreCase(module)&&!"CONSUMER".equals(role)){p.sendError(403);return;}
   if(("container".equalsIgnoreCase(module)||"pricing".equalsIgnoreCase(module))&&!"SELLER".equals(role)){p.sendError(403);return;}
  }
  p.setHeader("Cache-Control","no-store");chain.doFilter(input,output);
 }
}
