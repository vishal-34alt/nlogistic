package model;
import java.math.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Locale;
import java.util.Set;
import java.util.TreeSet;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.jsp.PageContext;
import javax.el.ExpressionFactory;
import java.lang.reflect.Array;

/** Tiny JSP-only adapter to replace JSTL.  No tag libraries, CSS, or JavaScript dependency. */
public final class JspSupport {
    public JspSupport() {}
    // Called by standard JSP actions, not by scriptlets or JSTL.
    private transient javax.servlet.jsp.PageContext currentPageContext;
    private String currentFragment;
    public void setPageContext(javax.servlet.jsp.PageContext context) { this.currentPageContext=context; }
    public void setView(String view) {
        if (currentPageContext==null) throw new IllegalStateException("PageContext not initialized");
        prepare(currentPageContext,view);
    }
    public void setFragment(String name) { this.currentFragment=name; }
    public String getFragment() {
        if (currentPageContext==null || currentFragment==null) return "";
        Object value=currentPageContext.getRequest().getAttribute(currentFragment);
        return value==null ? "" : String.valueOf(value);
    }
    public static Object value(PageContext pc, String s) {
        if(s==null)return null;
        String e=s.trim();
        if(e.startsWith("${fn:length(") && e.endsWith(")}"))
            return length(value(pc,"${"+e.substring(12,e.length()-2)+"}"));
        if(e.startsWith("${fn:escapeXml(") && e.endsWith(")}"))
            return value(pc,"${"+e.substring(15,e.length()-2)+"}");
        if(!e.startsWith("${"))return e;
        try { return ExpressionFactory.newInstance().createValueExpression(pc.getELContext(),e,Object.class).getValue(pc.getELContext()); }
        catch(RuntimeException ex) { throw new IllegalArgumentException("Invalid JSP expression: "+e,ex); }
    }
    public static boolean truth(PageContext pc,String s){ Object v=value(pc,s);return v instanceof Boolean?(Boolean)v:v!=null&&!"false".equalsIgnoreCase(String.valueOf(v))&& !"".equals(String.valueOf(v)); }
    public static String out(PageContext pc,String expr,String fallback){Object v=value(pc,expr);return Html.escape(v==null?fallback:v);}
    public static int length(Object o){if(o==null)return 0;if(o instanceof Collection)return ((Collection<?>)o).size();if(o instanceof Map)return ((Map<?,?>)o).size();if(o.getClass().isArray())return Array.getLength(o);if(o instanceof CharSequence)return ((CharSequence)o).length();return 0;}
    public static List<?> list(Object o){if(o==null)return Collections.emptyList();if(o instanceof List<?>)return (List<?>)o;if(o instanceof Iterable<?>){List<Object>a=new ArrayList<>();for(Object x:(Iterable<?>)o)a.add(x);return a;}if(o instanceof Map<?,?>)return new ArrayList<>(((Map<?,?>)o).entrySet());if(o.getClass().isArray()){List<Object>a=new ArrayList<>();for(int i=0;i<Array.getLength(o);i++)a.add(Array.get(o,i));return a;}return Collections.singletonList(o);}
    public static <T> java.util.List<T> typed(Object value, Class<T> type) {
        java.util.List<T> result = new java.util.ArrayList<>();
        if (value instanceof java.lang.Iterable<?>) for(Object item:(java.lang.Iterable<?>)value)
            if(type.isInstance(item))result.add(type.cast(item));
        return result;
    }
    public static java.util.List<java.util.Map<String,Object>> maps(Object value) {
        java.util.List<java.util.Map<String,Object>> result=new java.util.ArrayList<>();
        if(value instanceof java.lang.Iterable<?>) for(Object x:(java.lang.Iterable<?>)value) {
            if(x instanceof java.util.Map) {
                java.util.Map<String,Object> record=new java.util.LinkedHashMap<>();
                for(java.util.Map.Entry<?,?>e:((java.util.Map<?,?>)x).entrySet())
                    record.put(String.valueOf(e.getKey()),e.getValue());
                result.add(record);
            }
        }
        return result;
    }
    public static java.util.Map<String,Object> map(Object value) {
        java.util.Map<String,Object> result=new java.util.LinkedHashMap<>();
        if(value instanceof java.util.Map)for(java.util.Map.Entry<?,?>e:((java.util.Map<?,?>)value).entrySet())
            result.put(String.valueOf(e.getKey()),e.getValue());
        return result;
    }
    public static String replace(Object o,String a,String b){return (o==null?"":String.valueOf(o)).replace(a,b);}
    public static String url(PageContext pc,String url){if(url==null)return "";return url.startsWith("/")?pc.getRequest().getServletContext().getContextPath()+url:url;}
    public static String param(Object x){try{return java.net.URLEncoder.encode(x==null?"":String.valueOf(x),"UTF-8");}catch(java.io.UnsupportedEncodingException ex){throw new IllegalStateException(ex);}}
    public static final class LoopStatus {
       private final int index,size;
       public LoopStatus(int index,int size){this.index=index;this.size=size;}
       public int getIndex(){return index;}public int getCount(){return index+1;}public boolean isFirst(){return index==0;}public boolean isLast(){return index==size-1;}
    }


public String prepare(javax.servlet.jsp.PageContext pc,String view) {
 try {
 if("Module1/audit-log.jsp".equals(view))return prepare_Module1_audit_log(pc);
if("Module1/companies.jsp".equals(view))return prepare_Module1_companies(pc);
if("Module1/customers.jsp".equals(view))return prepare_Module1_customers(pc);
if("Module1/dashboard.jsp".equals(view))return prepare_Module1_dashboard(pc);
if("Module1/database-unavailable.jsp".equals(view))return prepare_Module1_database_unavailable(pc);
if("Module1/error.jsp".equals(view))return prepare_Module1_error(pc);
if("Module1/infrastructure.jsp".equals(view))return prepare_Module1_infrastructure(pc);
if("Module1/login.jsp".equals(view))return prepare_Module1_login(pc);
if("Module1/profile.jsp".equals(view))return prepare_Module1_profile(pc);
if("Module1/register.jsp".equals(view))return prepare_Module1_register(pc);
if("Module1/users.jsp".equals(view))return prepare_Module1_users(pc);
if("Module1/workspace-search.jsp".equals(view))return prepare_Module1_workspace_search(pc);
if("Module2/module2Error.jsp".equals(view))return prepare_Module2_module2Error(pc);
if("Module2/movementTracking.jsp".equals(view))return prepare_Module2_movementTracking(pc);
if("Module2/movementUpdate.jsp".equals(view))return prepare_Module2_movementUpdate(pc);
if("Module2/profitLossDashboard.jsp".equals(view))return prepare_Module2_profitLossDashboard(pc);
if("Module2/shipmentManagement.jsp".equals(view))return prepare_Module2_shipmentManagement(pc);
if("Module3/booking-result.jsp".equals(view))return prepare_Module3_booking_result(pc);
if("Module3/booking.jsp".equals(view))return prepare_Module3_booking(pc);
if("Module3/containers.jsp".equals(view))return prepare_Module3_containers(pc);
if("Module3/pricing-audit.jsp".equals(view))return prepare_Module3_pricing_audit(pc);
if("Module3/pricing.jsp".equals(view))return prepare_Module3_pricing(pc);
if("Module4/dashboard.jsp".equals(view))return prepare_Module4_dashboard(pc);
if("Module4/import-result.jsp".equals(view))return prepare_Module4_import_result(pc);
if("Module4/import.jsp".equals(view))return prepare_Module4_import(pc);
if("Module4/ledger.jsp".equals(view))return prepare_Module4_ledger(pc);
if("Module4/product-form.jsp".equals(view))return prepare_Module4_product_form(pc);
if("Module4/sales.jsp".equals(view))return prepare_Module4_sales(pc);
if("Module4/stock-form.jsp".equals(view))return prepare_Module4_stock_form(pc);
if("Module4/summary.jsp".equals(view))return prepare_Module4_summary(pc);
if("Module5/create.jsp".equals(view))return prepare_Module5_create(pc);
if("Module5/details.jsp".equals(view))return prepare_Module5_details(pc);
if("Module5/error.jsp".equals(view))return prepare_Module5_error(pc);
if("Module5/invoices.jsp".equals(view))return prepare_Module5_invoices(pc);
if("Module5/payments.jsp".equals(view))return prepare_Module5_payments(pc);
if("Module5/print.jsp".equals(view))return prepare_Module5_print(pc);
if("Module6/analytics.jsp".equals(view))return prepare_Module6_analytics(pc);
if("Module7/claim_details.jsp".equals(view))return prepare_Module7_claim_details(pc);
if("Module7/claims.jsp".equals(view))return prepare_Module7_claims(pc);
if("Module7/index.jsp".equals(view))return prepare_Module7_index(pc);
if("Module7/submit_claim.jsp".equals(view))return prepare_Module7_submit_claim(pc);
if("shared/_nav.jsp".equals(view))return prepare_shared__nav(pc);
if("shared/_shell_end.jsp".equals(view))return prepare_shared__shell_end(pc);
if("shared/_shell_start.jsp".equals(view))return prepare_shared__shell_start(pc);
if("shared/header.jsp".equals(view))return prepare_shared_header(pc);
if("shared/server-error.jsp".equals(view))return prepare_shared_server_error(pc);
if("shared/sidebar.jsp".equals(view))return prepare_shared_sidebar(pc);
if("shared/tabs.jsp".equals(view))return prepare_shared_tabs(pc);
if("shared/topbar.jsp".equals(view))return prepare_shared_topbar(pc);
 return "";
 }catch(Exception ex){throw new IllegalStateException("NLOGISTIC JSP data preparation failed: "+view,ex);}
}


public static String h(Object o){return model.Html.escape(o);}
public static String safe(Object o){return model.Html.escape(o);}
public static String amt(java.math.BigDecimal b){return b==null?"0.00":b.setScale(2,java.math.RoundingMode.HALF_UP).toPlainString();}
public static String tabsEscape(Object o){return model.Html.escape(o);}
public static String tabsHref(String ctx,String path){
 if(path==null||!path.startsWith("/")||path.startsWith("//"))return "";
 if(path.indexOf('"')>=0||path.indexOf('<')>=0||path.indexOf('\\')>=0)return "";
 return ctx+path;
}
public static String statusBadgeClass(String status){
 if("SETTLED".equals(status))return "bg-success text-white";
 if("APPROVED".equals(status))return "bg-success-subtle text-success border border-success-subtle";
 if("REJECTED".equals(status))return "bg-danger-subtle text-danger border border-danger-subtle";
 if("PARTIALLY_APPROVED".equals(status))return "bg-warning-subtle text-dark border border-warning-subtle";
 if("UNDER_REVIEW".equals(status))return "bg-info-subtle text-primary border border-info-subtle";
 return "bg-secondary-subtle text-secondary border border-secondary-subtle";
}

@SuppressWarnings("unused")
private String prepare_Module1_audit_log(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

 if(session.getAttribute("userId")==null){response.sendRedirect(request.getContextPath()+"/Module1Controller?action=viewLogin");return "";}
 if(!"ADMIN".equals(String.valueOf(session.getAttribute("role")))){response.sendError(403);return "";}
 List<AuditLog> events=model.JspSupport.typed(request.getAttribute("auditLogs"),AuditLog.class);
 String userFilter=request.getParameter("userId")==null?"":request.getParameter("userId");
 String tableFilter=request.getParameter("tableName")==null?"":request.getParameter("tableName");
 Set<String> tables=new TreeSet<>(String.CASE_INSENSITIVE_ORDER);
 int created=0,updated=0,auth=0,removed=0;
 for(AuditLog a:events){if(a.getTableName()!=null)tables.add(a.getTableName());
  String t=a.getAction()==null?"":a.getAction().toUpperCase(Locale.ROOT);
  if(t.contains("INSERT")||t.contains("CREATE"))created++;
  else if(t.contains("UPDATE"))updated++;
  else if(t.contains("LOGIN")||t.contains("LOGOUT"))auth++;
  else if(t.contains("DELETE"))removed++;
 }
 String ctx=model.Html.escape(request.getContextPath());
 request.setAttribute("nlActiveModule","Module1");request.setAttribute("nlPageTitle","Audit trail");

request.setAttribute("nlv_Module1_audit_log__1", String.valueOf(ctx));
request.setAttribute("nlv_Module1_audit_log__2", String.valueOf(events.size()));
request.setAttribute("nlv_Module1_audit_log__3", String.valueOf(created));
request.setAttribute("nlv_Module1_audit_log__4", String.valueOf(updated));
request.setAttribute("nlv_Module1_audit_log__5", String.valueOf(auth));
request.setAttribute("nlv_Module1_audit_log__6", String.valueOf(removed));
request.setAttribute("nlv_Module1_audit_log__7", String.valueOf(ctx));
request.setAttribute("nlv_Module1_audit_log__8", String.valueOf(model.Html.escape(userFilter)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
for(String table:tables){
out.write("<option value=\"");
out.print(model.Html.escape(table));
out.write("\" ");
if(table.equals(tableFilter)){
out.write("selected=\"selected\"");
}
out.write(">");
out.print(model.Html.escape(table.replace('_',' ')));
out.write("</option>");
}
out.flush(); request.setAttribute("nlv_Module1_audit_log__9", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_audit_log__10", String.valueOf(ctx));
request.setAttribute("nlv_Module1_audit_log__11", String.valueOf(events.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
for(AuditLog event:events){String action=event.getAction()==null?"UNKNOWN":event.getAction().toUpperCase(Locale.ROOT);String typ=action.contains("INSERT")||action.contains("CREATE")?"CREATE":action.contains("UPDATE")?"UPDATE":action.contains("LOGIN")||action.contains("LOGOUT")?"AUTH":action.contains("DELETE")?"DELETE":"OTHER";
 String old=event.getOldValue()==null?"":event.getOldValue(),now=event.getNewValue()==null?"":event.getNewValue();
 String preview=now.trim().isEmpty()?(old.trim().isEmpty()?"Action recorded; details not supplied":"Previous value on record"):now.trim();
 if(preview.startsWith("{")||preview.startsWith("[")){
   if(preview.contains("\"fields\""))preview="Structured change details recorded";
   else preview="Detailed audit data recorded";
 }
 if("LOGIN".equals(action)||"LOGOUT".equals(action))preview=action.substring(0,1)+action.substring(1).toLowerCase(Locale.ROOT)+" event recorded";
 if(preview.length()>85)preview=preview.substring(0,82)+"...";

out.write("\n<tr data-a-type=\"");
out.print(typ);
out.write("\" data-a-id=\"");
out.print(event.getLogId());
out.write("\" data-a-search=\"");
out.print(model.Html.escape(action+" "+event.getTableName()+" "+event.getRecordId()+" "+event.getUserId()+" "+event.getActorName()+" "+old+" "+now));
out.write("\">\n <td><span class=\"a-id\">#");
out.print(event.getLogId());
out.write("</span></td>\n <td><strong>");
out.print(model.Html.escape(event.getUserId()==null?"System":event.getActorName()==null?"User #"+event.getUserId():event.getActorName()));
out.write("</strong>");
if(event.getUserId()!=null && event.getActorName()!=null){
out.write("<small class=\"d-block text-secondary\">User #");
out.print(event.getUserId());
out.write("</small>");
}
out.write("</td>\n <td><span class=\"a-chip");
out.print("CREATE".equals(typ)?" a-create":"AUTH".equals(typ)?" a-auth":"DELETE".equals(typ)?" a-delete":"");
out.write("\">");
out.print(model.Html.escape(action.replace('_',' ')));
out.write("</span></td>\n <td><strong>");
out.print(model.Html.escape(event.getTableName()==null?"Unspecified":event.getTableName().replace('_',' ')));
out.write("</strong><div class=\"small text-secondary\">Record ");
out.print(event.getRecordId()==null?"—":"#"+event.getRecordId());
out.write("</div></td>\n <td><span class=\"a-preview");
out.print(preview.equals("Action recorded; details not supplied")?" empty":"");
out.write("\" title=\"");
out.print(model.Html.escape(preview));
out.write("\">");
out.print(model.Html.escape(preview));
out.write("</span></td>\n <td><button type=\"button\" class=\"a-row-btn\" data-a-view=\"");
out.print(event.getLogId());
out.write("\" data-a-action=\"");
out.print(model.Html.escape(action));
out.write("\" data-a-table=\"");
out.print(model.Html.escape(event.getTableName()));
out.write("\" data-a-actor=\"");
out.print(model.Html.escape(event.getUserId()==null?"System":event.getActorName()==null?"User #"+event.getUserId():event.getActorName()+" (User #"+event.getUserId()+")"));
out.write("\" data-a-ip=\"");
out.print(model.Html.escape(event.getIpAddress()));
out.write("\">View change</button>\n <span hidden=\"hidden\" id=\"aOld");
out.print(event.getLogId());
out.write("\">");
out.print(model.Html.escape(old));
out.write("</span><span hidden=\"hidden\" id=\"aNew");
out.print(event.getLogId());
out.write("\">");
out.print(model.Html.escape(now));
out.write("</span></td>\n </tr>");
}
out.flush(); request.setAttribute("nlv_Module1_audit_log__12", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_companies(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

if (session.getAttribute("userId") == null) {
    response.sendRedirect("Module1Controller?action=viewLogin");
    return "";
}
String role = String.valueOf(session.getAttribute("role") == null ? "" : session.getAttribute("role"));
if (!"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect("Module1Controller?action=dashboard&error=access_denied");
    return "";
}
List<Company> companies = model.JspSupport.typed(request.getAttribute("companies"), Company.class);
String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
String companyType = request.getParameter("companyType") == null ? "" : request.getParameter("companyType");
String ctx = request.getContextPath();
String csrfToken = model.Html.escape(session.getAttribute("csrfToken") == null ? "" : String.valueOf(session.getAttribute("csrfToken")));
int sellerCount=0, consumerCount=0;
Set<String> countries = new TreeSet<>(String.CASE_INSENSITIVE_ORDER);
for(String iso:java.util.Locale.getISOCountries()){
    String label=new java.util.Locale.Builder().setRegion(iso).build().getDisplayCountry(java.util.Locale.ENGLISH);
    if(label!=null && !label.trim().isEmpty()) countries.add(label);
}
for(Company company:companies){
    String type=company.getCompanyType()==null?"":company.getCompanyType().trim().toUpperCase(java.util.Locale.ROOT);
    if("SELLER".equals(type)) sellerCount++;
    if("CONSUMER".equals(type)) consumerCount++;
    if(company.getCountry()!=null && !company.getCountry().trim().isEmpty()) countries.add(company.getCountry().trim());
}
request.setAttribute("nlActiveModule","Module1");
request.setAttribute("nlPageTitle","Companies");

nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 Object companyFlash=session.getAttribute("companyEditFlash");session.removeAttribute("companyEditFlash");if(companyFlash!=null){String value=String.valueOf(companyFlash);boolean err=value.startsWith("ERROR:");
out.write("\n<div class=\"alert ");
out.print(err?"alert-danger":"alert-success");
out.write("\" role=\"status\">");
out.print(model.Html.escape(value.substring(value.indexOf(':')+1)));
out.write("</div>\n");
 } 
out.flush(); request.setAttribute("nlv_Module1_companies__1", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_companies__2", String.valueOf(companies.size()));
request.setAttribute("nlv_Module1_companies__3", String.valueOf(keyword.trim().isEmpty()?"—":model.Html.escape(keyword)));
request.setAttribute("nlv_Module1_companies__4", String.valueOf(companyType.trim().isEmpty()?"All":model.Html.escape(companyType)));
request.setAttribute("nlv_Module1_companies__5", String.valueOf(model.Html.escape(keyword)));
request.setAttribute("nlv_Module1_companies__6", String.valueOf(companyType.isEmpty()?"selected=\"selected\"":""));
request.setAttribute("nlv_Module1_companies__7", String.valueOf("CONSUMER".equalsIgnoreCase(companyType)?"selected=\"selected\"":""));
request.setAttribute("nlv_Module1_companies__8", String.valueOf("SELLER".equalsIgnoreCase(companyType)?"selected=\"selected\"":""));
request.setAttribute("nlv_Module1_companies__9", String.valueOf(companies.size()));
request.setAttribute("nlv_Module1_companies__10", String.valueOf(companies.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(companies!=null && !companies.isEmpty()){
           for(Company company:companies){
             String type = company.getCompanyType()==null?"":company.getCompanyType().trim().toUpperCase(java.util.Locale.ROOT);
      
out.write("\n        <tr data-company-search=\"");
out.print(model.Html.escape((company.getCompanyName()+" "+company.getCompanyType()+" "+company.getCity()+" "+company.getCountry()+" "+company.getGstNumber()+" "+company.getIecCode()).toLowerCase(java.util.Locale.ROOT)));
out.write("\">\n          <td><strong>#");
out.print(company.getCompanyId());
out.write("</strong></td>\n          <td>");
out.print(model.Html.escape(company.getCompanyName()));
out.write("</td>\n          <td><span class=\"cc-badge ");
out.print("SELLER".equals(type)?"cc-seller":"cc-consumer");
out.write("\">");
out.print(model.Html.escape(type.isEmpty()?"UNSPECIFIED":type));
out.write("</span></td>\n          <td>");
out.print(model.Html.escape(company.getGstNumber()));
out.write("</td>\n          <td>");
out.print(model.Html.escape(company.getIecCode()));
out.write("</td>\n          <td>");
out.print(model.Html.escape(company.getCity()));
out.write("</td>\n          <td>");
out.print(model.Html.escape(company.getCountry()));
out.write("</td>\n          <td>\n            <div class=\"cc-actions\">\n              <button type=\"button\" class=\"cc-link-btn\" data-bs-toggle=\"modal\" data-bs-target=\"#companyUpdateModal\" data-company-id=\"");
out.print(company.getCompanyId());
out.write("\" data-company-name=\"");
out.print(model.Html.escape(company.getCompanyName()));
out.write("\" data-company-type=\"");
out.print(model.Html.escape(company.getCompanyType()));
out.write("\" data-company-gst=\"");
out.print(model.Html.escape(company.getGstNumber()));
out.write("\" data-company-iec=\"");
out.print(model.Html.escape(company.getIecCode()));
out.write("\" data-company-address=\"");
out.print(model.Html.escape(company.getAddress()));
out.write("\" data-company-city=\"");
out.print(model.Html.escape(company.getCity()));
out.write("\" data-company-country=\"");
out.print(model.Html.escape(company.getCountry()));
out.write("\">Update</button>\n              <form action=\"Module1Controller\" method=\"post\" class=\"d-inline\" data-nl-site-confirm=\"Delete this company? The database will block deletion if users, customers, shipments, vessels, products, containers or pricing rules still reference it.\" data-nl-confirm-title=\"Delete company\">\n                <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrfToken);
out.write("\">\n                <input type=\"hidden\" name=\"action\" value=\"deleteCompany\">\n                <input type=\"hidden\" name=\"companyId\" value=\"");
out.print(company.getCompanyId());
out.write("\">\n                <button type=\"submit\" class=\"cc-link-btn cc-danger\">Delete</button>\n              </form>\n            </div>\n          </td>\n        </tr>\n      ");
   }
         } else { 
out.write("\n        <tr><td colspan=\"8\" class=\"cc-empty\">No company records are currently available.</td></tr>\n      ");
 } 
out.flush(); request.setAttribute("nlv_Module1_companies__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_companies__12", String.valueOf(csrfToken));
request.setAttribute("nlv_Module1_companies__13", String.valueOf(csrfToken));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String country:countries){ 
out.write("\n            <button type=\"button\" data-country-value=\"");
out.print(model.Html.escape(country));
out.write("\">");
out.print(model.Html.escape(country));
out.write("</button>\n          ");
 } 
out.flush(); request.setAttribute("nlv_Module1_companies__14", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_customers(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

if (session.getAttribute("userId") == null) {
    response.sendRedirect("Module1Controller?action=viewLogin");
    return "";
}
String role = String.valueOf(session.getAttribute("role") == null ? "" : session.getAttribute("role"));
if (!"ADMIN".equalsIgnoreCase(role)) {
    response.sendRedirect("Module1Controller?action=dashboard&error=access_denied");
    return "";
}
List<Customer> customers = model.JspSupport.typed(request.getAttribute("customers"), Customer.class);
String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");
String ctx = request.getContextPath();
String csrfToken = model.Html.escape(session.getAttribute("csrfToken") == null ? "" : String.valueOf(session.getAttribute("csrfToken")));
java.math.BigDecimal totalCredit = java.math.BigDecimal.ZERO;
for(Customer customer:customers){ if(customer.getCreditLimit()!=null) totalCredit = totalCredit.add(customer.getCreditLimit()); }
request.setAttribute("nlActiveModule","Module1");
request.setAttribute("nlPageTitle","Customers");

nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 Object customerFlash=session.getAttribute("customerEditFlash");session.removeAttribute("customerEditFlash");if(customerFlash!=null){String value=String.valueOf(customerFlash);boolean err=value.startsWith("ERROR:");
out.write("\n<div class=\"alert ");
out.print(err?"alert-danger":"alert-success");
out.write("\" role=\"status\">");
out.print(model.Html.escape(value.substring(value.indexOf(':')+1)));
out.write("</div>\n");
 } 
out.flush(); request.setAttribute("nlv_Module1_customers__1", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_customers__2", String.valueOf(customers.size()));
request.setAttribute("nlv_Module1_customers__3", String.valueOf(customers.size()));
request.setAttribute("nlv_Module1_customers__4", String.valueOf(model.Html.escape(keyword)));
request.setAttribute("nlv_Module1_customers__5", String.valueOf(customers.size()));
request.setAttribute("nlv_Module1_customers__6", String.valueOf(customers.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(customers!=null && !customers.isEmpty()){
           for(Customer customer:customers){ 
out.write("\n        <tr data-customer-search=\"");
out.print(model.Html.escape((String.valueOf(customer.getCustomerId())+' '+String.valueOf(customer.getUserId())+' '+String.valueOf(customer.getCompanyId())+' '+String.valueOf(customer.getContactPerson())+' '+String.valueOf(customer.getBillingAddress())+' '+String.valueOf(customer.getCreditLimit())).toLowerCase(java.util.Locale.ROOT)));
out.write("\">\n          <td><strong>#");
out.print(customer.getCustomerId());
out.write("</strong></td>\n          <td>");
out.print(model.Html.escape(customer.getUserId()));
out.write("</td>\n          <td>");
out.print(model.Html.escape(customer.getCompanyId()));
out.write("</td>\n          <td>");
out.print(model.Html.escape(customer.getContactPerson()));
out.write("</td>\n          <td>");
out.print(model.Html.escape(customer.getBillingAddress()));
out.write("</td>\n          <td>");
out.print(model.Html.escape(customer.getCreditLimit()));
out.write("</td>\n          <td><div class=\"cu-actions\"><button type=\"button\" class=\"cu-link-btn\" data-bs-toggle=\"modal\" data-bs-target=\"#customerUpdateModal\" data-customer-id=\"");
out.print(customer.getCustomerId());
out.write("\" data-customer-label=\"Customer #");
out.print(customer.getCustomerId());
out.write(" · ");
out.print(model.Html.escape(customer.getContactPerson()));
out.write("\" data-contact-person=\"");
out.print(model.Html.escape(customer.getContactPerson()));
out.write("\" data-billing-address=\"");
out.print(model.Html.escape(customer.getBillingAddress()));
out.write("\" data-credit-limit=\"");
out.print(model.Html.escape(customer.getCreditLimit()));
out.write("\">Update</button><form action=\"Module1Controller\" method=\"post\" class=\"d-inline\" data-nl-site-confirm=\"Delete this customer? Continue only if you are sure this approved record is no longer required.\" data-nl-confirm-title=\"Delete customer\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrfToken);
out.write("\"><input type=\"hidden\" name=\"action\" value=\"deleteCustomer\"><input type=\"hidden\" name=\"customerId\" value=\"");
out.print(customer.getCustomerId());
out.write("\"><button type=\"submit\" class=\"cu-link-btn cu-danger\">Delete</button></form></div></td>\n        </tr>\n      ");
   }
         } else { 
out.write("\n        <tr><td colspan=\"7\" class=\"cu-empty\">No customer records are currently available.</td></tr>\n      ");
 } 
out.flush(); request.setAttribute("nlv_Module1_customers__7", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_customers__8", String.valueOf(csrfToken));
request.setAttribute("nlv_Module1_customers__9", String.valueOf(csrfToken));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_dashboard(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

 if(session.getAttribute("userId")==null){response.sendRedirect(request.getContextPath()+"/Module1Controller?action=viewLogin");return "";}
 String role=String.valueOf(session.getAttribute("role")==null?"USER":session.getAttribute("role")).toUpperCase(java.util.Locale.ROOT);
 String userName=String.valueOf(session.getAttribute("userName")==null?"Account":session.getAttribute("userName"));
 boolean admin="ADMIN".equals(role),seller="SELLER".equals(role),consumer="CONSUMER".equals(role);
 String ctx=request.getContextPath();
 DashboardSummary summary=request.getAttribute("dashboardSummary") instanceof DashboardSummary?(DashboardSummary)request.getAttribute("dashboardSummary"):null;
 request.setAttribute("nlActiveModule","Module1");request.setAttribute("nlPageTitle","Dashboard");

nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(admin){ 
out.write("\n<main class=\"nl-admin-v16\" aria-label=\"Administration dashboard\">\n<section class=\"na-hero\"><div class=\"na-hero-content\"><div class=\"na-eyebrow\">N-LOGISTIC / ADMIN WORKSPACE</div><h1>Administration overview</h1><p>Keep the logistics directory, accounts and shipment operations organized from one place.</p><div class=\"na-date\">Live data from your authorized database records</div></div><div class=\"na-hero-art\" aria-hidden=\"true\"><div class=\"na-scene\"><div class=\"na-halo\"></div><div class=\"na-gear\"></div><div class=\"na-board\"><span class=\"na-bars\"><i></i><i></i><i></i></span></div><div class=\"na-cardlet\"></div></div></div></section>\n<section class=\"na-quick-actions\" aria-label=\"Administration quick actions\"><div class=\"na-quick-actions-head\"><h2 class=\"mb-0\">Quick actions</h2><span class=\"small text-secondary\">Jump straight to the main administration screens</span></div><div class=\"na-quick-actions-grid\"><a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=users\">Manage users</a><a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=companies\">Companies</a><a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=customers\">Customers</a><a href=\"");
out.print(ctx);
out.write("/adminInfrastructure?tab=ports\">Ports</a><a href=\"");
out.print(ctx);
out.write("/adminInfrastructure?tab=vessels\">Vessels</a><a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=auditLogs\">Audit trail</a></div></section>\n");
if(summary==null){
out.write("<div class=\"alert alert-warning\" role=\"status\">Dashboard totals could not be loaded. Your administration pages are still available.</div>");
}
out.write("\n<section class=\"na-kpi-area\" aria-label=\"Live administrative totals\"><div class=\"na-kpi-head\"><h2>Workspace at a glance</h2><span>Scroll horizontally to see all cards on a narrow screen</span></div><div class=\"na-kpi-row\">\n<a class=\"na-kpi\" href=\"");
out.print(ctx);
out.write("/containerMovement?action=shipments\"><span class=\"na-kpi-icon\"><span class=\"na-css-icon na-css-ship\" aria-hidden=\"true\"><i></i></span></span><strong>");
out.print(summary==null?"—":summary.getActiveShipments());
out.write("</strong><span>Active shipments</span><small>Open shipment register</small></a>\n<a class=\"na-kpi\" href=\"");
out.print(ctx);
out.write("/Module1Controller?action=users\"><span class=\"na-kpi-icon\"><span class=\"na-css-icon na-css-users\" aria-hidden=\"true\"><i></i></span></span><strong>");
out.print(summary==null?"—":summary.getRegisteredUsers());
out.write("</strong><span>User accounts</span><small>Manage access</small></a>\n<a class=\"na-kpi\" href=\"");
out.print(ctx);
out.write("/Module1Controller?action=companies\"><span class=\"na-kpi-icon\"><span class=\"na-css-icon na-css-company\" aria-hidden=\"true\"><i></i></span></span><strong>");
out.print(summary==null?"—":summary.getRegisteredCompanies());
out.write("</strong><span>Companies</span><small>Seller / Consumer</small></a>\n<a class=\"na-kpi\" href=\"");
out.print(ctx);
out.write("/Module1Controller?action=customers\"><span class=\"na-kpi-icon\"><span class=\"na-css-icon na-css-customer\" aria-hidden=\"true\"><i></i></span></span><strong>");
out.print(summary==null?"—":summary.getRegisteredCustomers());
out.write("</strong><span>Customer profiles</span><small>View records</small></a>\n<a class=\"na-kpi\" href=\"");
out.print(ctx);
out.write("/adminInfrastructure?tab=ports\"><span class=\"na-kpi-icon\"><span class=\"na-css-icon na-css-port\" aria-hidden=\"true\"><i></i></span></span><strong>");
out.print(summary==null?"—":summary.getRegisteredPorts());
out.write("</strong><span>Ports</span><small>Locations directory</small></a>\n<a class=\"na-kpi\" href=\"");
out.print(ctx);
out.write("/adminInfrastructure?tab=vessels\"><span class=\"na-kpi-icon\"><span class=\"na-css-icon na-css-vessel\" aria-hidden=\"true\"><i></i></span></span><strong>");
out.print(summary==null?"—":summary.getRegisteredVessels());
out.write("</strong><span>Vessels</span><small>");
out.print(summary==null?"—":summary.getMaintenanceVessels());
out.write(" in maintenance</small></a>\n<a class=\"na-kpi\" href=\"");
out.print(ctx);
out.write("/Module1Controller?action=auditLogs\"><span class=\"na-kpi-icon\"><span class=\"na-css-icon na-css-audit\" aria-hidden=\"true\"><i></i></span></span><strong>");
out.print(summary==null?"—":summary.getAuditEvents());
out.write("</strong><span>Audit events</span><small>Recorded history</small></a>\n</div></section>\n<div class=\"row g-3 mt-1\">\n<div class=\"col-xl-7\"><section class=\"na-panel h-100\"><div class=\"na-panel-header\"><div><div class=\"na-eyebrow\">OPERATIONS</div><h2>Shipment status overview</h2></div><a href=\"");
out.print(ctx);
out.write("/containerMovement?action=shipments\">View all shipments</a></div>\n");
if(summary!=null&&!summary.getShipmentStatuses().isEmpty()){
out.write("<div class=\"na-chart\"><canvas id=\"nlDashboardStatusChart\" role=\"img\" aria-label=\"Shipment counts by status\"></canvas></div>\n<div class=\"na-status-row\">");
for(Map.Entry<String,Integer> e:summary.getShipmentStatuses().entrySet()){
out.write("<div class=\"na-status-chip\"><strong>");
out.print(e.getValue());
out.write("</strong><span>");
out.print(model.Html.escape(e.getKey().replace('_',' ')));
out.write("</span></div>");
}
out.write("</div>\n");
}else{
out.write("<p class=\"p-4 text-secondary\">Shipment statistics appear when records are available.</p>");
}
out.write("\n</section></div>\n<div class=\"col-xl-5\"><section class=\"na-panel h-100\"><div class=\"na-eyebrow\">RECOMMENDED ACTIONS</div><h2>Quick tasks</h2><p class=\"text-secondary small\">Only administration, tracking and analytical tools appear here.</p>\n<div class=\"na-shortcuts\"><a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=users\"><span>Manage users and statuses</span><strong>Open</strong></a><a href=\"");
out.print(ctx);
out.write("/adminInfrastructure?tab=ports\"><span>Update port directory</span><strong>Open</strong></a><a href=\"");
out.print(ctx);
out.write("/adminInfrastructure?tab=vessels\"><span>Activate or maintain vessels</span><strong>Open</strong></a><a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=auditLogs\"><span>Review changes and access</span><strong>Open</strong></a><a href=\"");
out.print(ctx);
out.write("/analytics\"><span>Business analytics</span><strong>Open</strong></a></div>\n");
if(summary!=null&&summary.getMaintenanceVessels()>0){
out.write("<div class=\"na-advisory\"><strong>");
out.print(summary.getMaintenanceVessels());
out.write(" vessel");
out.print(summary.getMaintenanceVessels()==1?"":"s");
out.write(" in maintenance</strong><p class=\"mb-0\">Review availability before assigning future journeys.</p></div>");
}
out.write("</section></div>\n</div>\n<section class=\"na-panel mt-3\"><div class=\"na-panel-header\"><div><div class=\"na-eyebrow\">ACCOUNT SECURITY</div><h2>Recent actions by your account</h2></div><a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=auditLogs\">View complete audit trail</a></div>\n");
if(summary!=null&&!summary.getRecentActions().isEmpty()){
out.write("<div class=\"na-recent\">");
for(String item:summary.getRecentActions()){
out.write("<div><span class=\"na-recent-mark\" aria-hidden=\"true\"></span><span>");
out.print(model.Html.escape(item));
out.write("</span></div>");
}
out.write("</div>");
}else{
out.write("<p class=\"text-secondary mb-0\">No recent actions were recorded for this account.</p>");
}
out.write("</section>\n</main>\n");
 }else{ 
out.write("\n\n<section class=\"nl-role-dashboard-hero card shadow-sm border-warning-subtle rounded-4 mb-4\"><div class=\"nl-role-dashboard-hero-copy\"><span class=\"nl-role-dashboard-eyebrow\">OPERATIONS OVERVIEW</span><h1 class=\"display-6 fw-bold text-dark mb-2\">");
out.print(model.Html.escape(role.substring(0,1)+role.substring(1).toLowerCase(java.util.Locale.ROOT)));
out.write(" dashboard</h1><p>Your logistics, bookings and account activity at a glance.</p></div>\n<div class=\"nl-role-dashboard-hero-actions\">");
 if(consumer){ 
out.write("<a href=\"");
out.print(ctx);
out.write("/ContainerAllocationPricingController?module=booking\" class=\"btn btn-warning bg-gradient\">Create booking</a>");
 }else if(seller){ 
out.write("<a href=\"");
out.print(ctx);
out.write("/stock?action=new-stock\" class=\"btn btn-warning bg-gradient\">Add stock</a>");
 }else if(admin){ 
out.write("<a href=\"");
out.print(ctx);
out.write("/Module1Controller?action=users\" class=\"btn btn-warning bg-gradient\">Manage accounts</a>");
 } 
out.write("</div></section>\n");
 if(summary==null){ 
out.write("<div class=\"alert alert-warning\" role=\"status\">Live dashboard statistics are temporarily unavailable. You can still access your modules below.</div>");
 } 
out.write("\n");
 if(summary!=null && (summary.getOpenInvoices()>0 || summary.getOpenClaims()>0)){ 
out.write("\n<section class=\"card p-3 mb-4 border-warning-subtle rounded-4 shadow-sm border\" aria-label=\"Items needing attention\"><h2 class=\"h6 mb-2\">Items needing attention</h2>\n <div class=\"d-flex flex-wrap gap-3\">\n ");
 if(summary.getOpenInvoices()>0){ 
out.write("<a href=\"");
out.print(model.Html.escape(ctx));
out.write("/billing?action=outstanding\" class=\"link-dark\"><strong>");
out.print(summary.getOpenInvoices());
out.write("</strong> open invoice");
out.print(summary.getOpenInvoices()==1?"":"s");
out.write(" to review</a>");
 } 
out.write("\n ");
 if(summary.getOpenClaims()>0){ 
out.write("<a href=\"");
out.print(model.Html.escape(ctx));
out.write("/ClaimController?action=list\" class=\"link-dark\"><strong>");
out.print(summary.getOpenClaims());
out.write("</strong> unresolved claim");
out.print(summary.getOpenClaims()==1?"":"s");
out.write("</a>");
 } 
out.write("\n </div><p class=\"text-secondary small mb-0 mt-2\">These indicators are derived from your authorized records, not push notifications.</p></section>\n");
 } 
out.write("\n<div class=\"row g-3 mb-4\">\n<div class=\"col-sm-6 col-xl-3\"><a class=\"nl-dash-kpi card border-0 shadow-sm rounded-4 p-4 h-100 text-dark text-decoration-none d-block border-warning-subtle\" href=\"");
out.print(ctx);
out.write("/containerMovement?action=shipments\"><span class=\"bg-warning-subtle rounded-3 p-3 mb-3 d-inline-flex\"><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM0RDM0MjUiIHN0cm9rZS13aWR0aD0iMS44IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0zIDE2aDE4bC0zIDRINnpNNiAxNlY3aDEydjlNOSA3VjNoNnY0TTMgMjBxMiAyIDQgMHQ0IDB0NCAwdDQgMHQzIDAiLz48L3N2Zz4=\" width=\"25\" height=\"25\" alt=\"\" aria-hidden=\"true\"></span><span class=\"nl-kpi-label small text-secondary d-block mb-2\">Active shipments</span><span class=\"nl-kpi-value fs-2 fw-bold text-dark d-block mb-1\">");
out.print(summary==null?"—":summary.getActiveShipments());
out.write("</span><span class=\"nl-kpi-link small fw-semibold text-warning-emphasis d-block\">View shipments</span></a></div>\n<div class=\"col-sm-6 col-xl-3\"><a class=\"nl-dash-kpi card border-0 shadow-sm rounded-4 p-4 h-100 text-dark text-decoration-none d-block border-warning-subtle\" href=\"");
out.print(ctx);
out.write("/billing?action=payments\"><span class=\"bg-warning-subtle rounded-3 p-3 mb-3 d-inline-flex\"><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM0RDM0MjUiIHN0cm9rZS13aWR0aD0iMS44IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjMiIHk9IjUiIHdpZHRoPSIxOCIgaGVpZ2h0PSIxNSIgcng9IjMiLz48cGF0aCBkPSJNMyAxMGgxOE03IDE1aDUiLz48L3N2Zz4=\" width=\"25\" height=\"25\" alt=\"\" aria-hidden=\"true\"></span><span class=\"nl-kpi-label small text-secondary d-block mb-2\">Recorded payments (INR)</span><span class=\"nl-kpi-value fs-2 fw-bold text-dark d-block mb-1\">");
out.print(summary==null?"—":model.Html.escape(summary.getRecordedPayments().setScale(2,java.math.RoundingMode.HALF_UP)));
out.write("</span><span class=\"nl-kpi-link small fw-semibold text-warning-emphasis d-block\">View payments</span></a></div>\n<div class=\"col-sm-6 col-xl-3\"><a class=\"nl-dash-kpi card border-0 shadow-sm rounded-4 p-4 h-100 text-dark text-decoration-none d-block border-warning-subtle\" href=\"");
out.print(ctx);
out.write("/billing?action=outstanding\"><span class=\"bg-warning-subtle rounded-3 p-3 mb-3 d-inline-flex\"><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM0RDM0MjUiIHN0cm9rZS13aWR0aD0iMS44IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik02IDJoOWw1IDV2MTVINmEyIDIgMCAwIDEtMi0yVjRhMiAyIDAgMCAxIDItMnpNMTQgMnY2aDZNOCAxM2g4TTggMTdoOCIvPjwvc3ZnPg==\" width=\"25\" height=\"25\" alt=\"\" aria-hidden=\"true\"></span><span class=\"nl-kpi-label small text-secondary d-block mb-2\">Open invoices</span><span class=\"nl-kpi-value fs-2 fw-bold text-dark d-block mb-1\">");
out.print(summary==null?"—":summary.getOpenInvoices());
out.write("</span><span class=\"nl-kpi-link small fw-semibold text-warning-emphasis d-block\">View invoices</span></a></div>\n<div class=\"col-sm-6 col-xl-3\"><a class=\"nl-dash-kpi card border-0 shadow-sm rounded-4 p-4 h-100 text-dark text-decoration-none d-block border-warning-subtle\" href=\"");
out.print(ctx);
out.write("/ClaimController?action=list\"><span class=\"bg-warning-subtle rounded-3 p-3 mb-3 d-inline-flex\"><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM0RDM0MjUiIHN0cm9rZS13aWR0aD0iMS44IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0xMiAyIDQgNXY2YzAgNSAzIDggOCAxMSA1LTMgOC02IDgtMTFWNXpNOSAxMmwyIDIgNC00Ii8+PC9zdmc+\" width=\"25\" height=\"25\" alt=\"\" aria-hidden=\"true\"></span><span class=\"nl-kpi-label small text-secondary d-block mb-2\">Open claims</span><span class=\"nl-kpi-value fs-2 fw-bold text-dark d-block mb-1\">");
out.print(summary==null?"—":summary.getOpenClaims());
out.write("</span><span class=\"nl-kpi-link small fw-semibold text-warning-emphasis d-block\">View claims</span></a></div>\n</div>\n<div class=\"row g-3 mb-4\"><div class=\"col-lg-7\"><section class=\"nl-dash-panel card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle\"><div class=\"d-flex justify-content-between align-items-center gap-2 mb-3\"><h2 class=\"h5 fw-bold mb-0 text-warning-emphasis\">Shipment status overview</h2><small class=\"text-muted\">Live counts</small></div>\n");
 if(summary==null||summary.getShipmentStatuses().isEmpty()){ 
out.write("<div class=\"nl-dashboard-empty bg-body-tertiary rounded-4 border p-4 text-center my-3\"><strong>No shipment statistics available</strong><p>Counts appear after booking records exist.</p><a href=\"");
out.print(ctx);
out.write("/containerMovement?action=shipments\" class=\"btn btn-outline-dark btn-sm\">View shipments</a></div>");
 }else{ 
out.write("\n<div class=\"position-relative nl-dashboard-chart\"><canvas id=\"nlDashboardStatusChart\" role=\"img\" aria-label=\"Shipment status counts\"></canvas></div>\n<ul class=\"nl-status-count-list list-unstyled\" aria-label=\"Shipment status counts\">");
 for(Map.Entry<String,Integer> row:summary.getShipmentStatuses().entrySet()){ 
out.write("<li><span class=\"nl-status-dot\" aria-hidden=\"true\"></span><span>");
out.print(model.Html.escape(row.getKey().replace('_',' ')));
out.write("</span><strong>");
out.print(row.getValue());
out.write("</strong></li>");
 } 
out.write("</ul>\n");
 } 
out.write("</section></div>\n<div class=\"col-lg-5\"><section class=\"nl-dash-panel card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle\"><div class=\"nl-eyebrow\">FAST ACCESS</div><h2 class=\"h5 fw-bold text-warning-emphasis mb-1\">Workspace shortcuts</h2><p class=\"text-secondary small mb-3\">Jump straight to the task you need, without leaving your role's permissions.</p><div class=\"nl-shortcut-grid\">\n<a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/containerMovement?action=shipments\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Shipments &amp; tracking</span><span>›</span></a>\n");
 if(consumer){ 
out.write("<a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/ContainerAllocationPricingController?module=booking\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Book goods / containers</span><span>›</span></a>");
 } 
out.write("\n");
 if(seller){ 
out.write("<a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/stock\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Products &amp; stock</span><span>›</span></a><a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/ContainerAllocationPricingController?module=container\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Containers &amp; pricing</span><span>›</span></a>");
 } 
out.write("\n<a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/billing?action=invoices\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Invoices &amp; payments</span><span>›</span></a>\n<a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/ClaimController?action=list\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Claims &amp; resolutions</span><span>›</span></a>\n");
 if(seller||admin){ 
out.write("<a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/analytics\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Business analytics</span><span>›</span></a>");
 } 
out.write("\n");
 if(admin){ 
out.write("<a class=\"nl-action-link list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3 px-2 text-dark text-decoration-none border-bottom\" href=\"");
out.print(ctx);
out.write("/Module1Controller?action=users\"><span><i class=\"nl-action-dot badge bg-warning rounded-pill p-1 me-2\"></i>Administration</span><span>›</span></a>");
 } 
out.write("\n</div></section></div></div>\n\n<section class=\"card p-4 mb-4 border-0 shadow-sm rounded-4 border-warning-subtle\" id=\"account\"><h2 class=\"h5\">Profile</h2><a class=\"btn btn-outline-dark btn-sm mb-3\" href=\"");
out.print(ctx);
out.write("/Module1Controller?action=viewProfile\">Manage profile</a><p class=\"mb-1\"><strong>Name:</strong> ");
out.print(model.Html.escape(userName));
out.write("</p><p class=\"mb-0\"><strong>Role:</strong> ");
out.print(model.Html.escape(role));
out.write("</p></section>\n");
 } 
out.flush(); request.setAttribute("nlv_Module1_dashboard__1", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(summary!=null&&!summary.getShipmentStatuses().isEmpty()){ 
out.write("<script src=\"https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js\"></script><script>\n(function(){const canvas=document.getElementById('nlDashboardStatusChart');if(!canvas||typeof Chart==='undefined')return;\nconst labels=[");
boolean first=true;for(String key:summary.getShipmentStatuses().keySet()){if(!first)out.print(",");first=false;out.print("'"+key.replace("'","")+"'");}
out.write("];\nconst values=[");
first=true;for(Integer n:summary.getShipmentStatuses().values()){if(!first)out.print(",");first=false;out.print(n);}
out.write("];\nnew Chart(canvas,{type:'bar',data:{labels,datasets:[{label:'Shipments',data:values,backgroundColor:['#a64712','#c65b16','#e1791e','#f0a13b','#b67b39','#ad5f22','#e7b15f','#6b4329'],borderRadius:7}]},options:{maintainAspectRatio:false,plugins:{legend:{display:false}},scales:{y:{beginAtZero:true,ticks:{precision:0}}}}});})();\n</script>");
 } 
out.flush(); request.setAttribute("nlv_Module1_dashboard__2", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_database_unavailable(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
request.setAttribute("nlv_Module1_database_unavailable__1", String.valueOf(model.Html.escape(request.getContextPath())));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_error(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    String errorMessage =
        (String) request.getAttribute("errorMessage");

    if (errorMessage == null || errorMessage.trim().isEmpty()) {
        errorMessage = "Something went wrong. Please try again.";
    }

 request.setAttribute("nlActiveModule", "Module1"); request.setAttribute("nlPageTitle", "Workspace error"); 
request.setAttribute("nlv_Module1_error__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
request.setAttribute("nlv_Module1_error__2", String.valueOf(model.Html.escape(errorMessage)));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_infrastructure(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    java.util.List<model.InfrastructureRecord> ports=model.JspSupport.typed(request.getAttribute("ports"),model.InfrastructureRecord.class);
    java.util.List<model.InfrastructureRecord> vessels=model.JspSupport.typed(request.getAttribute("vessels"),model.InfrastructureRecord.class);
    java.util.List<model.Company> sellers=model.JspSupport.typed(request.getAttribute("sellers"),model.Company.class);
    String ctx=model.Html.escape(request.getContextPath());
    String token=model.Html.escape(session.getAttribute("csrfToken"));
    String feedback=(String)request.getAttribute("infrastructureFlash");
    int activeVessels=0;for(model.InfrastructureRecord vessel:vessels)if("ACTIVE".equals(vessel.getStatus()))activeVessels++;
    String initialTab="vessels".equalsIgnoreCase(request.getParameter("tab"))?"vessels":"ports";
    java.util.Set<String> countryNames=new java.util.TreeSet<>(String.CASE_INSENSITIVE_ORDER);
    for(String iso:java.util.Locale.getISOCountries()){
       String label=new java.util.Locale.Builder().setRegion(iso).build().getDisplayCountry(java.util.Locale.ENGLISH);
       if(label!=null&&!label.trim().isEmpty())countryNames.add(label);
    }
    for(model.InfrastructureRecord port:ports)if(port.getCountry()!=null&&!port.getCountry().trim().isEmpty())countryNames.add(port.getCountry());
    request.setAttribute("nlActiveModule","Module1");request.setAttribute("nlPageTitle","vessels".equals(initialTab)?"Vessels":"Ports");

request.setAttribute("nlv_Module1_infrastructure__1", String.valueOf("vessels".equals(initialTab)?"Vessel management":"Port management"));
request.setAttribute("nlv_Module1_infrastructure__2", String.valueOf(ports.size()));
request.setAttribute("nlv_Module1_infrastructure__3", String.valueOf(vessels.size()));
request.setAttribute("nlv_Module1_infrastructure__4", String.valueOf(activeVessels));
request.setAttribute("nlv_Module1_infrastructure__5", String.valueOf(vessels.size()-activeVessels));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(feedback!=null){boolean failure=feedback.startsWith("ERROR:"); String feedbackText=feedback.substring(feedback.indexOf(':')+1); 
out.write("\n<div role=\"alert\" class=\"i-banner");
out.print(failure?" i-error":"");
out.write("\">");
out.print(model.Html.escape(feedbackText));
out.write("</div>\n<div class=\"i-toast-wrap\" aria-live=\"polite\" aria-atomic=\"true\"><div class=\"i-toast");
out.print(failure?" i-error":"");
out.write("\" role=\"status\"><div><strong>");
out.print(failure?"Action needs attention":"Action completed");
out.write("</strong><p>");
out.print(model.Html.escape(feedbackText));
out.write("</p></div><button type=\"button\" aria-label=\"Dismiss\" data-i-dismiss-toast>&times;</button></div></div>\n");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__6", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_infrastructure__7", String.valueOf("ports".equals(initialTab)?"true":"false"));
request.setAttribute("nlv_Module1_infrastructure__8", String.valueOf(ports.size()));
request.setAttribute("nlv_Module1_infrastructure__9", String.valueOf("vessels".equals(initialTab)?"true":"false"));
request.setAttribute("nlv_Module1_infrastructure__10", String.valueOf(vessels.size()));
request.setAttribute("nlv_Module1_infrastructure__11", String.valueOf(ctx));
request.setAttribute("nlv_Module1_infrastructure__12", String.valueOf(token));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord port:ports){ 
out.write("<option value=\"");
out.print(port.getId());
out.write("\">");
out.print(model.Html.escape(port.getName()+" · "+port.getCity()+", "+port.getCountry()));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__13", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord port:ports){ 
out.write("<option value=\"");
out.print(port.getId());
out.write("\">");
out.print(model.Html.escape(port.getName()+" ("+port.getCode()+")"));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__14", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord port:ports){if(port.getCity()!=null && !port.getCity().trim().isEmpty()){ 
out.write("<option value=\"");
out.print(model.Html.escape(port.getCity()));
out.write("\"></option>");
 }} 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__15", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_infrastructure__16", String.valueOf(ports.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord port:ports){ 
out.write("\n <tr data-i-record=\"port\" data-id=\"");
out.print(port.getId());
out.write("\" data-code=\"");
out.print(model.Html.escape(port.getCode()));
out.write("\" data-name=\"");
out.print(model.Html.escape(port.getName()));
out.write("\" data-city=\"");
out.print(model.Html.escape(port.getCity()));
out.write("\" data-country=\"");
out.print(model.Html.escape(port.getCountry()));
out.write("\" data-latitude=\"");
out.print(model.Html.escape(port.getLatitude()));
out.write("\" data-longitude=\"");
out.print(model.Html.escape(port.getLongitude()));
out.write("\">\n <td><span class=\"i-row-title\">");
out.print(model.Html.escape(port.getName()));
out.write("</span><span class=\"i-small\">Directory #");
out.print(port.getId());
out.write("</span></td>\n <td><span class=\"i-code nl-inline-copy\" role=\"button\" tabindex=\"0\" data-nl-copy-value=\"");
out.print(model.Html.escape(port.getCode()));
out.write("\" aria-label=\"Copy port code ");
out.print(model.Html.escape(port.getCode()));
out.write("\" title=\"Click to copy port code\">");
out.print(model.Html.escape(port.getCode()));
out.write("</span></td>\n <td>");
out.print(model.Html.escape(port.getLocation()));
out.write("</td>\n <td><a class=\"i-count-link\" title=\"Open the shipment register\" href=\"");
out.print(ctx);
out.write("/containerMovement?action=shipments\"><strong>");
out.print(port.getActiveShipmentCount());
out.write("</strong> ongoing</a></td>\n <td class=\"i-small\">");
out.print(port.getLatitude()==null||port.getLongitude()==null?"Not set":model.Html.escape(port.getLatitude()+", "+port.getLongitude()));
out.write("</td>\n <td><div class=\"i-actions\"><button type=\"button\" class=\"i-row-btn\" data-i-edit=\"port\" data-id=\"");
out.print(port.getId());
out.write("\">Edit details</button>\n <form method=\"post\" action=\"");
out.print(ctx);
out.write("/adminInfrastructure\" data-nl-site-confirm=\"Delete this port? This only works if it is not used by a booking, container or pricing rule.\" data-nl-confirm-title=\"Delete unused port\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(token);
out.write("\"><input type=\"hidden\" name=\"action\" value=\"deletePort\"><input type=\"hidden\" name=\"id\" value=\"");
out.print(port.getId());
out.write("\"><button type=\"submit\" class=\"i-row-btn i-danger\" title=\"Delete only if this port has no linked records\">Delete</button></form></div></td></tr>\n ");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__17", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord port:ports){ 
out.write("<div class=\"i-activity-row\"><span class=\"i-row-title\">");
out.print(model.Html.escape(port.getName()));
out.write(" <small class=\"i-small\">(");
out.print(model.Html.escape(port.getCode()));
out.write(")</small></span><strong>");
out.print(port.getActiveShipmentCount());
out.write(" ongoing</strong></div>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__18", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_infrastructure__19", String.valueOf(ctx));
request.setAttribute("nlv_Module1_infrastructure__20", String.valueOf(token));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord v:vessels){ 
out.write("<option value=\"");
out.print(v.getId());
out.write("\">");
out.print(model.Html.escape(v.getName()));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__21", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_infrastructure__22", String.valueOf(vessels.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord v:vessels){ 
out.write("\n<tr data-i-record=\"vessel\" data-id=\"");
out.print(v.getId());
out.write("\" data-name=\"");
out.print(model.Html.escape(v.getName()));
out.write("\" data-imo=\"");
out.print(model.Html.escape(v.getCode()));
out.write("\" data-owner=\"");
out.print(model.Html.escape(v.getOwnerCompanyId()));
out.write("\" data-capacity=\"");
out.print(model.Html.escape(v.getCapacityTeu()));
out.write("\" data-status=\"");
out.print(model.Html.escape(v.getStatus()));
out.write("\" data-active-shipments=\"");
out.print(v.getActiveShipmentCount());
out.write("\" data-history-shipments=\"");
out.print(v.getTotalShipmentCount());
out.write("\">\n<td><span class=\"i-row-title\">");
out.print(model.Html.escape(v.getName()));
out.write("</span><span class=\"i-small\">Vessel #");
out.print(v.getId());
out.write("</span></td>\n<td><span class=\"i-code\">");
out.print(v.getCode()==null?"Not assigned":model.Html.escape(v.getCode()));
out.write("</span></td><td>");
out.print(model.Html.escape(v.getLocation()));
out.write("</td><td>");
out.print(v.getCapacityTeu()==null?"Not specified":model.Html.escape(v.getCapacityTeu()+" TEU"));
out.write("</td>\n<td><span class=\"i-assigned-count\" title=\"Shipments assigned to this vessel that are not delivered or cancelled\">");
out.print(v.getActiveShipmentCount());
out.write(" active</span></td>\n<td><span class=\"i-pill");
out.print("ACTIVE".equals(v.getStatus())?"":" i-off");
out.write("\">");
out.print("ACTIVE".equals(v.getStatus())?"Active":"Maintenance");
out.write("</span></td>\n<td><div class=\"i-actions\"><button type=\"button\" class=\"i-row-btn\" data-i-edit=\"vessel\" data-id=\"");
out.print(v.getId());
out.write("\">Edit details</button>\n");
 boolean vesselHasActive=v.getActiveShipmentCount()>0;boolean vesselHasHistory=v.getTotalShipmentCount()>0;boolean vesselActive="ACTIVE".equals(v.getStatus()); 
out.write("\n<form method=\"post\" action=\"");
out.print(ctx);
out.write("/adminInfrastructure\" data-nl-site-confirm=\"");
out.print(vesselActive?"Move this vessel into Maintenance? It will not be available for new journeys.":"Activate this vessel for future journeys?");
out.write("\" data-nl-confirm-title=\"Confirm vessel status\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(token);
out.write("\"><input type=\"hidden\" name=\"action\" value=\"setVesselStatus\"><input type=\"hidden\" name=\"id\" value=\"");
out.print(v.getId());
out.write("\"><input type=\"hidden\" name=\"status\" value=\"");
out.print(vesselActive?"MAINTENANCE":"ACTIVE");
out.write("\"><button type=\"submit\" class=\"i-row-btn\" title=\"");
out.print(vesselActive?"Move to Maintenance. Existing shipment records will be preserved":"Reactivate vessel for future assignments");
out.write("\">");
out.print(vesselActive?"Maintenance":"Activate");
out.write("</button></form>\n<form method=\"post\" action=\"");
out.print(ctx);
out.write("/adminInfrastructure\" data-nl-site-confirm=\"");
out.print(vesselHasHistory?"This vessel has shipment history. Deletion is protected by the approved database. Continue to see the database result?":"Delete this vessel permanently?");
out.write("\" data-nl-confirm-title=\"Delete unused vessel\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(token);
out.write("\"><input type=\"hidden\" name=\"action\" value=\"deleteVessel\"><input type=\"hidden\" name=\"id\" value=\"");
out.print(v.getId());
out.write("\"><button type=\"submit\" class=\"i-row-btn i-danger\" title=\"");
out.print(vesselHasHistory?"Delete requires no shipment history; click to see database explanation":"Delete this unused vessel");
out.write("\">Delete</button></form>\n</div></td>\n</tr>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__23", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Company seller:sellers){ 
out.write("<span data-seller-id=\"");
out.print(seller.getCompanyId());
out.write("\" data-seller-name=\"");
out.print(model.Html.escape(seller.getCompanyName()));
out.write("\"></span>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__24", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_infrastructure__25", String.valueOf(ctx));
request.setAttribute("nlv_Module1_infrastructure__26", String.valueOf(token));
request.setAttribute("nlv_Module1_infrastructure__27", String.valueOf(ctx));
request.setAttribute("nlv_Module1_infrastructure__28", String.valueOf(token));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String country:countryNames){ 
out.write("<button type=\"button\" class=\"i-country-option\" data-country-choice=\"");
out.print(model.Html.escape(country));
out.write("\" role=\"option\">");
out.print(model.Html.escape(country));
out.write("</button>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__29", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_infrastructure__30", String.valueOf(ctx));
request.setAttribute("nlv_Module1_infrastructure__31", String.valueOf(token));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InfrastructureRecord port:ports){ 
out.write("<option value=\"");
out.print(port.getId());
out.write("\">");
out.print(model.Html.escape(port.getName()+" · "+port.getCity()+", "+port.getCountry()));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module1_infrastructure__32", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_login(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

String nlLoginNotice=""; String nlLoginNoticeKind="error";
String nlLoginError=request.getParameter("error"), nlLoginInfo=request.getParameter("msg");
if(request.getAttribute("errorMessage")!=null){nlLoginNotice=String.valueOf(request.getAttribute("errorMessage"));}
else if("invalid".equals(nlLoginError)){nlLoginNotice="The email or password is incorrect. Please check your details and try again.";}
else if("login_required".equals(nlLoginError)){nlLoginNotice="Please sign in to continue. Your session may have expired.";}
else if("session_expired".equals(nlLoginError)){nlLoginNotice="This sign-in form expired. Please sign in again using the refreshed page.";}
else if(nlLoginError!=null){nlLoginNotice="Sign-in could not be completed. Please try again.";}
else if("logout".equals(nlLoginInfo)){nlLoginNotice="You have signed out successfully.";nlLoginNoticeKind="success";}
else if("registered".equals(nlLoginInfo)){nlLoginNotice="Account created successfully. You can now sign in.";nlLoginNoticeKind="success";}
else if("password_changed".equals(nlLoginInfo)||"password".equals(nlLoginInfo)){nlLoginNotice="Password updated. Sign in using your new password.";nlLoginNoticeKind="success";}

request.setAttribute("nlv_Module1_login__1", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(!nlLoginNotice.isEmpty()){
out.write("<div class=\"nl-login-status\" data-kind=\"");
out.print(nlLoginNoticeKind);
out.write("\" role=\"status\">");
out.print(model.Html.escape(nlLoginNotice));
out.write("</div><div class=\"nl-login-toast\" data-kind=\"");
out.print(nlLoginNoticeKind);
out.write("\" role=\"alert\" id=\"nlLoginToast\"><span>");
out.print(model.Html.escape(nlLoginNotice));
out.write("</span><button type=\"button\" aria-label=\"Dismiss message\" onclick=\"this.closest('.nl-login-toast').remove()\">Close</button></div>");
}
out.flush(); request.setAttribute("nlv_Module1_login__2", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_login__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module1_login__4", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
request.setAttribute("nlv_Module1_login__5", String.valueOf(model.Html.escape(request.getContextPath())));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_profile(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("activeNav","profile"); 

User own=(User)request.getAttribute("profile");if(own==null){response.sendError(401);return "";}
String ctx=request.getContextPath(),token=model.Html.escape(session.getAttribute("csrfToken"));


String accountRole=own.getRole()==null?"":own.getRole();
boolean profileAdmin="ADMIN".equals(accountRole),profileSeller="SELLER".equals(accountRole);
String workspaceLabel=profileAdmin?"Platform administrator":profileSeller?"Seller workspace":"Customer workspace";
String workspaceMessage=profileAdmin?"Monitor shipments and movement history across the platform. Financial reports are available in read-only mode.":profileSeller?"Record verified shipment checkpoints, review cargo movement, and manage your company's financial reports.":"Follow the progress of your bookings and inspect the movement events recorded by your logistics partner.";
String workspaceScope=profileAdmin?"All shipments":profileSeller?"Your company shipments":"Your booked shipments";
String companyLabel=profileAdmin?"Platform-wide":(own.getCompanyId()==null?"Not assigned":"Company #"+own.getCompanyId());
String loginLabel=own.getLastLogin()==null?"Not yet recorded":new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(own.getLastLogin());
String accountName=own.getFullName()==null?"Account":own.getFullName().trim();
String monogram=accountName.isEmpty()?"U":accountName.substring(0,1).toUpperCase(java.util.Locale.ROOT);

request.setAttribute("nlv_Module1_profile__1", String.valueOf(model.Html.escape(ctx)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if("saved".equals(request.getParameter("msg"))){
out.write("<div class=\"alert\" role=\"status\">Profile updated successfully. Your changes are saved.</div>");
}
out.flush(); request.setAttribute("nlv_Module1_profile__2", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(request.getAttribute("profileError")!=null){
out.write("<div class=\"alert error\" role=\"alert\">");
out.print(model.Html.escape(request.getAttribute("profileError")));
out.write("</div>");
}
out.flush(); request.setAttribute("nlv_Module1_profile__3", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_profile__4", String.valueOf(model.Html.escape(monogram)));
request.setAttribute("nlv_Module1_profile__5", String.valueOf(model.Html.escape(accountName)));
request.setAttribute("nlv_Module1_profile__6", String.valueOf(model.Html.escape(workspaceLabel)));
request.setAttribute("nlv_Module1_profile__7", String.valueOf(model.Html.escape(own.getStatus())));
request.setAttribute("nlv_Module1_profile__8", String.valueOf(model.Html.escape(ctx)));
request.setAttribute("nlv_Module1_profile__9", String.valueOf(model.Html.escape(workspaceLabel)));
request.setAttribute("nlv_Module1_profile__10", String.valueOf(model.Html.escape(companyLabel)));
request.setAttribute("nlv_Module1_profile__11", String.valueOf(profileAdmin?"Platform-wide account":"Your organization's records"));
request.setAttribute("nlv_Module1_profile__12", String.valueOf(model.Html.escape(loginLabel)));
request.setAttribute("nlv_Module1_profile__13", String.valueOf(model.Html.escape(ctx)));
request.setAttribute("nlv_Module1_profile__14", String.valueOf(token));
request.setAttribute("nlv_Module1_profile__15", String.valueOf(model.Html.escape(own.getFullName())));
request.setAttribute("nlv_Module1_profile__16", String.valueOf(model.Html.escape(own.getEmail())));
request.setAttribute("nlv_Module1_profile__17", String.valueOf(model.Html.escape(own.getPhone())));
request.setAttribute("nlv_Module1_profile__18", String.valueOf(model.Html.escape(ctx)));
request.setAttribute("nlv_Module1_profile__19", String.valueOf(token));
request.setAttribute("nlv_Module1_profile__20", String.valueOf(profileAdmin?"Platform oversight":profileSeller?"Seller operations":"Shipment visibility"));
request.setAttribute("nlv_Module1_profile__21", String.valueOf(model.Html.escape(workspaceMessage)));
request.setAttribute("nlv_Module1_profile__22", String.valueOf(profileAdmin?"View all shipment records":profileSeller?"View your company shipments":"View only your bookings"));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(profileSeller){
out.write("<li><span class=\"perm-icon\" aria-hidden=\"true\">↗</span><span><strong>Record shipment movements</strong><small>Add validated checkpoints to your company's shipments.</small></span></li>");
}else{
out.write("<li><span class=\"perm-icon\" aria-hidden=\"true\">◉</span><span><strong>Read-only tracking</strong><small>Updates belong to the owning Seller.</small></span></li>");
}
out.flush(); request.setAttribute("nlv_Module1_profile__23", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(profileAdmin||profileSeller){
out.write("<li><span class=\"perm-icon\" aria-hidden=\"true\">▥</span><span><strong>Profit &amp; loss reporting</strong><small>");
out.print(profileAdmin?"View and export company reports":"Calculate and export your company's financial data");
out.write("</small></span></li>");
}else{
out.write("<li><span class=\"perm-icon\" aria-hidden=\"true\">◷</span><span><strong>Movement history</strong><small>Review dated checkpoints and shipment details.</small></span></li>");
}
out.flush(); request.setAttribute("nlv_Module1_profile__24", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_profile__25", String.valueOf(model.Html.escape(ctx)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(profileAdmin||profileSeller){
out.write("<a class=\"btn light\" href=\"");
out.print(model.Html.escape(ctx));
out.write("/containerMovement?action=profitLoss\">P&amp;L reports</a>");
}
out.flush(); request.setAttribute("nlv_Module1_profile__26", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_register(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

@SuppressWarnings("unchecked")
java.util.Map<String,String> draft=session.getAttribute("registrationDraft") instanceof java.util.Map
 ? (java.util.Map<String,String>)session.getAttribute("registrationDraft") : java.util.Collections.emptyMap();
session.removeAttribute("registrationDraft");
String error=request.getParameter("error"); String message="";
if("invalid_email".equals(error)) message="Please enter a valid email address.";
else if("password_mismatch".equals(error)) message="Passwords do not match.";
else if("invalid_role".equals(error)) message="Please select a permitted role.";
else if("company_required".equals(error) || "invalid_company".equals(error)) message="Please enter a valid company name.";
else if("invalid".equals(error)) message="Please check your registration details.";
else if("session_expired".equals(error)) message="This registration form expired. The page has been refreshed. Please review your details and submit again.";

nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(!message.isEmpty()){ 
out.write("<div class=\"alert alert-danger\" role=\"alert\">");
out.print(model.Html.escape(message));
out.write("</div>");
 } 
out.flush(); request.setAttribute("nlv_Module1_register__1", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_register__2", String.valueOf(request.getContextPath()));
request.setAttribute("nlv_Module1_register__3", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
request.setAttribute("nlv_Module1_register__4", String.valueOf(model.Html.escape(draft.get("fullName"))));
request.setAttribute("nlv_Module1_register__5", String.valueOf(model.Html.escape(draft.get("companyName"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("company_required".equals(error)){ 
out.write("<div class=\"invalid-feedback d-block\">A company name is required.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module1_register__6", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_register__7", String.valueOf(model.Html.escape(draft.get("email"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("invalid_email".equals(error)){ 
out.write("<div class=\"invalid-feedback d-block\">Enter a valid email address.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module1_register__8", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_register__9", String.valueOf("CONSUMER".equals(draft.get("role"))?"selected":""));
request.setAttribute("nlv_Module1_register__10", String.valueOf("SELLER".equals(draft.get("role"))?"selected":""));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("password_mismatch".equals(error)){ 
out.write("<div class=\"invalid-feedback d-block\">Passwords do not match.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module1_register__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_register__12", String.valueOf(model.Html.escape(draft.get("phone"))));
request.setAttribute("nlv_Module1_register__13", String.valueOf(request.getContextPath()));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_users(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    if (session.getAttribute("userId") == null) {
        response.sendRedirect("Module1Controller?action=viewLogin");
        return "";
    }

    String role = (String) session.getAttribute("role");

    if (!"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect("Module1Controller?action=dashboard&error=access_denied");
        return "";
    }

    List<User> users = model.JspSupport.typed(request.getAttribute("users"), User.class);
    @SuppressWarnings("unchecked")
    java.util.Map<String,String> nlUserDraft = session.getAttribute("nlAddUserDraft") instanceof java.util.Map
      ? (java.util.Map<String,String>)session.getAttribute("nlAddUserDraft") : java.util.Collections.emptyMap();
    String nlUserCreationError = (String)session.getAttribute("nlAddUserError");
    session.removeAttribute("nlAddUserDraft");
    session.removeAttribute("nlAddUserError");

 request.setAttribute("nlActiveModule", "Module1"); request.setAttribute("nlPageTitle", "Users"); 
request.setAttribute("nlv_Module1_users__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(request.getParameter("created")!=null){ 
out.write("<div class=\"alert alert-success\" role=\"status\">Account created successfully. ID: ");
out.print(model.Html.escape(request.getParameter("created")));
out.write("</div>");
 } 
out.flush(); request.setAttribute("nlv_Module1_users__2", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 String accountNotice=request.getParameter("accountNotice");
               if("saved".equals(accountNotice)){ 
out.write("\n              <div class=\"alert alert-success\" role=\"status\">Account details saved. All selected changes were recorded together.</div>\n            ");
 }else if("duplicate".equals(accountNotice)){ 
out.write("\n              <div class=\"alert alert-warning\" role=\"alert\">That email address is already registered. Open the account editor and choose another email.</div>\n            ");
 }else if("invalid".equals(accountNotice)){ 
out.write("\n              <div class=\"alert alert-warning\" role=\"alert\">Please review the name, email, phone and account access status. No changes were saved.</div>\n            ");
 }else if("failed".equals(accountNotice)){ 
out.write("\n              <div class=\"alert alert-danger\" role=\"alert\">The account update could not be saved. No partial update was made; please try again.</div>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module1_users__3", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(nlUserCreationError!=null && !nlUserCreationError.isEmpty()){ 
out.write("<div class=\"alert alert-danger nl-user-feedback\" role=\"alert\"><strong>Account not created.</strong> ");
out.print(model.Html.escape(nlUserCreationError));
out.write(" The form below retains your non-sensitive entries; enter the temporary password again.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module1_users__4", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_users__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module1_users__6", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
request.setAttribute("nlv_Module1_users__7", String.valueOf(model.Html.escape(nlUserDraft.get("fullName"))));
request.setAttribute("nlv_Module1_users__8", String.valueOf(model.Html.escape(nlUserDraft.get("email"))));
request.setAttribute("nlv_Module1_users__9", String.valueOf(model.Html.escape(nlUserDraft.get("phone"))));
request.setAttribute("nlv_Module1_users__10", String.valueOf("CONSUMER".equals(nlUserDraft.get("role"))?"selected":""));
request.setAttribute("nlv_Module1_users__11", String.valueOf("SELLER".equals(nlUserDraft.get("role"))?"selected":""));
request.setAttribute("nlv_Module1_users__12", String.valueOf("ADMIN".equals(nlUserDraft.get("role"))?"selected":""));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Company c:model.JspSupport.typed(request.getAttribute("companies"),model.Company.class)){ 
out.write("<option value=\"");
out.print(c.getCompanyId());
out.write("\" data-type=\"");
out.print(model.Html.escape(c.getCompanyType()));
out.write("\" ");
out.print(String.valueOf(c.getCompanyId()).equals(nlUserDraft.get("companyId"))?"selected":"");
out.write(">");
out.print(model.Html.escape(c.getCompanyName()));
out.write(" (#");
out.print(c.getCompanyId());
out.write(")</option>");
 } 
out.flush(); request.setAttribute("nlv_Module1_users__13", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (users != null && !users.isEmpty()) {
                                for (User user : users) { 
out.write("\n\n                                <tr>\n\n                                    <td>");
out.print(model.Html.escape(user.getUserId()));
out.write("</td>\n\n                                    <td>\n                                        ");
out.print(model.Html.escape(user.getFullName()));
 if(String.valueOf(user.getUserId()).equals(String.valueOf(session.getAttribute("userId")))){ 
out.write("<span class=\"badge bg-primary-subtle text-primary-emphasis border border-primary-subtle ms-2\">Current user</span>");
 } 
out.write("\n                                    </td>\n\n                                    <td>");
out.print(model.Html.escape(user.getEmail()));
out.write("</td>\n\n                                    <td>");
out.print(model.Html.escape(user.getPhone()));
out.write("</td>\n\n                                    <td>\n                                        <span class=\"badge bg-warning text-dark\">\n                                            ");
out.print(model.Html.escape(user.getRole()));
out.write("\n                                        </span>\n                                    </td>\n\n                                    <td>\n                                        <span class=\"badge ");
out.print("ACTIVE".equalsIgnoreCase(user.getStatus()) ? "bg-success" : "bg-secondary");
out.write("\">\n                                            ");
out.print(model.Html.escape(user.getStatus()));
out.write("\n                                        </span>\n                                    </td>\n\n                                    <td>\n\n                                        <button type=\"button\"\n                                                class=\"btn btn-sm btn-outline-dark\"\n                                                data-bs-toggle=\"modal\"\n                                                data-bs-target=\"#updateModal\"\n                                                data-id=\"");
out.print(model.Html.escape(user.getUserId()));
out.write("\"\n                                                data-name=\"");
out.print(model.Html.escape(user.getFullName()));
out.write("\"\n                                                data-email=\"");
out.print(model.Html.escape(user.getEmail()));
out.write("\"\n                                                data-phone=\"");
out.print(model.Html.escape(user.getPhone()));
out.write("\"\n                                                data-status=\"");
out.print(model.Html.escape(user.getStatus()));
out.write("\">\n                                            Update\n                                        </button>\n\n                                        ");
 if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) { 
out.write("\n                                        <form action=\"Module1Controller\" method=\"post\" class=\"d-inline\">\n                                            <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\">\n                                            <input type=\"hidden\" name=\"action\" value=\"updateUser\">\n                                            <input type=\"hidden\" name=\"recordId\" value=\"");
out.print(user.getUserId());
out.write("\">\n                                            <input type=\"hidden\" name=\"fieldName\" value=\"status\">\n                                            <input type=\"hidden\" name=\"newValue\" value=\"ACTIVE\">\n                                            <button type=\"submit\" class=\"btn btn-sm btn-outline-success\" title=\"Activate this account\">Activate</button>\n                                        </form>\n                                        ");
 } else if(!String.valueOf(user.getUserId()).equals(String.valueOf(session.getAttribute("userId")))) { 
out.write("\n                                        <form action=\"Module1Controller\"\n                                              method=\"post\"\n                                              class=\"d-inline\">\n<input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken") == null ? "" : session.getAttribute("csrfToken")));
out.write("\">\n\n                                            <input type=\"hidden\"\n                                                   name=\"action\"\n                                                   value=\"deleteUser\">\n\n                                            <input type=\"hidden\"\n                                                   name=\"userId\"\n                                                   value=\"");
out.print(model.Html.escape(user.getUserId()));
out.write("\">\n\n                                            <button type=\"submit\"\n                                                    class=\"btn btn-sm btn-outline-danger\" title=\"Deactivate this user while retaining audit history\">\n                                                Deactivate\n                                            </button>\n\n                                        </form>\n                                        ");
 } 
out.write("\n\n                                    </td>\n\n                                </tr>\n\n                            ");
  }
                                } else { 
out.write("\n\n                                <tr>\n                                    <td colspan=\"7\"\n                                        class=\"text-center text-secondary py-4\">\n                                        No user records available.\n                                    </td>\n                                </tr>\n\n                            ");
 } 
out.flush(); request.setAttribute("nlv_Module1_users__14", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module1_users__15", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module1_users__16", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
request.setAttribute("nlv_Module1_users__17", String.valueOf(model.Html.escape(session.getAttribute("userId"))));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module1_workspace_search(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

 request.setAttribute("nlActiveModule","Module1");request.setAttribute("nlPageTitle","Workspace search");
 List<WorkspaceSearchHit> hits=model.JspSupport.typed(request.getAttribute("searchHits"),WorkspaceSearchHit.class);
 String term=model.Html.escape(request.getAttribute("searchTerm"));
 String ctx=request.getContextPath();
 Map<String,List<WorkspaceSearchHit>> groups=new LinkedHashMap<>();
 for(WorkspaceSearchHit hit:hits){ groups.computeIfAbsent(hit.getCategory(),k->new ArrayList<>()).add(hit); }

request.setAttribute("nlv_Module1_workspace_search__1", String.valueOf(model.Html.escape(ctx)));
request.setAttribute("nlv_Module1_workspace_search__2", String.valueOf(term));
request.setAttribute("nlv_Module1_workspace_search__3", String.valueOf(hits.size()));
request.setAttribute("nlv_Module1_workspace_search__4", String.valueOf(term));
request.setAttribute("nlv_Module1_workspace_search__5", String.valueOf(groups.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(hits.isEmpty()){ 
out.write("<div class=\"alert alert-info\" role=\"status\">No matching accessible records. Try a different shipment, container, SKU, invoice, or claim reference.</div>");
 } else { 
out.write("\n");
 for(Map.Entry<String,List<WorkspaceSearchHit>> section:groups.entrySet()){ 
out.write("\n<section class=\"mb-4\" aria-label=\"");
out.print(model.Html.escape(section.getKey()));
out.write(" results\"><h3 class=\"h6 mb-3 fw-bold\">");
out.print(model.Html.escape(section.getKey()));
out.write(" <span class=\"badge text-bg-light border text-secondary\">");
out.print(section.getValue().size());
out.write("</span></h3>\n");
 if("Workspace page".equals(section.getKey())){ 
out.write("<div class=\"nl-search-page-grid\">");
 for(WorkspaceSearchHit hit:section.getValue()){ 
out.write("<a class=\"nl-search-page-tile\" href=\"");
out.print(model.Html.escape(ctx+hit.getUrl()));
out.write("\"><span class=\"nl-search-page-label\">OPEN WORKSPACE SCREEN</span><strong>");
out.print(model.Html.escape(hit.getTitle()));
out.write("</strong><small>");
out.print(model.Html.escape(hit.getSubtitle()));
out.write("</small><span class=\"nl-search-page-open\">Open page</span></a>");
 } 
out.write("</div>");
 }else{ 
out.write("\n<div class=\"table-responsive rounded-3\"><table class=\"table table-hover align-middle\"><thead class=\"table-warning\"><tr><th scope=\"col\">Reference</th><th scope=\"col\">Details</th><th scope=\"col\">Action</th></tr></thead><tbody>\n");
 for(WorkspaceSearchHit hit:section.getValue()){ 
out.write("<tr><td><strong>");
out.print(model.Html.escape(hit.getTitle()));
out.write("</strong></td><td>");
out.print(model.Html.escape(hit.getSubtitle()));
out.write("</td><td><a class=\"btn btn-outline-dark btn-sm\" href=\"");
out.print(model.Html.escape(ctx+hit.getUrl()));
out.write("\" aria-label=\"View ");
out.print(model.Html.escape(hit.getCategory()+" "+hit.getTitle()));
out.write("\">View details</a></td></tr>");
 } 
out.write("\n</tbody></table></div>");
 } 
out.write("</section>");
 } 
 } 
out.flush(); request.setAttribute("nlv_Module1_workspace_search__6", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module2_module2Error(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("activeNav","shipments"); 
String u=request.getContextPath()+"/containerMovement";
int code=request.getAttribute("statusCode") instanceof Number?((Number)request.getAttribute("statusCode")).intValue():500;
String msg=String.valueOf(request.getAttribute("errorMessage")==null?"The request could not be completed.":request.getAttribute("errorMessage"));
request.setAttribute("nlv_Module2_module2Error__1", String.valueOf(code));
request.setAttribute("nlv_Module2_module2Error__2", String.valueOf(model.Html.escape(msg)));
request.setAttribute("nlv_Module2_module2Error__3", String.valueOf(model.Html.escape(u)));
request.setAttribute("nlv_Module2_module2Error__4", String.valueOf(model.Html.escape(u)));
request.setAttribute("nlv_Module2_module2Error__5", String.valueOf(model.Html.escape(request.getContextPath())));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module2_movementTracking(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("activeNav","movements"); 

String ctx=request.getContextPath(), url=ctx+"/containerMovement";
Object rawEventsAttribute=request.getAttribute("movements");
List<ContainerMovementPojo> events=new ArrayList<ContainerMovementPojo>();
if (rawEventsAttribute instanceof List<?>) {
    for (Object item : (List<?>) rawEventsAttribute) {
        if (item instanceof ContainerMovementPojo) events.add((ContainerMovementPojo) item);
    }
}
ShipmentPojo selected=(ShipmentPojo)request.getAttribute("shipment");
boolean timeline=Boolean.TRUE.equals(request.getAttribute("isTimeline"));
String role=String.valueOf(request.getAttribute("currentRole"));boolean staff="ADMIN".equals(role)||"SELLER".equals(role);
String id=request.getParameter("shipmentId")==null?"":request.getParameter("shipmentId");
String status=request.getParameter("status")==null?"":request.getParameter("status");
String start=request.getParameter("startDate")==null?"":request.getParameter("startDate");
String end=request.getParameter("endDate")==null?"":request.getParameter("endDate");

request.setAttribute("nlv_Module2_movementTracking__1", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_movementTracking__2", String.valueOf(timeline?"SHIPMENT JOURNEY":"MOVEMENT HISTORY"));
request.setAttribute("nlv_Module2_movementTracking__3", String.valueOf(timeline?"Shipment":"Movement"));
request.setAttribute("nlv_Module2_movementTracking__4", String.valueOf(timeline?"tracking":"history"));
request.setAttribute("nlv_Module2_movementTracking__5", String.valueOf(timeline?"Follow verified checkpoints from booking to delivery.":"Browse timestamped movement events across shipments."));
request.setAttribute("nlv_Module2_movementTracking__6", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_movementTracking__7", String.valueOf(model.Html.escape(url)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(request.getAttribute("notice")!=null){
out.write("<div class=\"alert\" role=\"status\">");
out.print(model.Html.escape(request.getAttribute("notice")));
out.write("</div>");
}
out.flush(); request.setAttribute("nlv_Module2_movementTracking__8", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(request.getAttribute("correctionError")!=null){
out.write("<div class=\"alert correction-error\" role=\"alert\"><strong>Checkpoint not changed.</strong> ");
out.print(model.Html.escape(request.getAttribute("correctionError")));
out.write("<br><small>Check eligibility and retry only if this checkpoint is still current.</small></div>");
}
out.flush(); request.setAttribute("nlv_Module2_movementTracking__9", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(selected!=null){
out.write("<section class=\"card soft\"><div class=\"card-head\"><div><div class=\"caps\">TRACKING · ");
out.print(model.Html.escape(selected.getShipmentNo()));
out.write("</div><h2>");
out.print(model.Html.escape(selected.getOriginPortName()));
out.write(" → ");
out.print(model.Html.escape(selected.getDestPortName()));
out.write("</h2><p class=\"sub\">Container ");
out.print(model.Html.escape(selected.getContainerNumber()));
out.write(" · Current status ");
out.print(selected.getStatusLabel());
out.write("</p></div><div class=\"heading-actions\"><span class=\"pill ");
out.print(selected.isTerminal()?"gray":"blue");
out.write("\">");
out.print(selected.getStatusLabel());
out.write("</span>");
if(!Boolean.TRUE.equals(request.getAttribute("canEdit"))){
out.write("<span class=\"pill gray\">View only</span>");
}
if(Boolean.TRUE.equals(request.getAttribute("canEdit"))&&!selected.isTerminal()){
out.write("<a href=\"");
out.print(model.Html.escape(url));
out.write("?action=movementUpdate&amp;shipmentId=");
out.print(selected.getShipmentId());
out.write("\" class=\"btn primary\">Change status</a>");
}
out.write("</div></div>\n");

  // Cancellation is a terminal branch, not the last step of the delivery path.
  // Keep reached checkpoints based on existing movement events for cancelled cargo.
  boolean cancelled="CANCELLED".equals(selected.getStatus());
  java.util.List<String> stages=ShipmentPojo.STATUSES.subList(0,7);
  int reached=stages.indexOf(selected.getStatus());
  if(cancelled){
    reached=-1;
    for(ContainerMovementPojo event:events) reached=Math.max(reached,stages.indexOf(event.getStatus()));
  }
  reached=Math.max(reached,0);
  int journeyPct=Math.round(reached*100f/6f);

out.write("\n<div class=\"journey-panel\" aria-label=\"Shipment journey stages\">\n  <div class=\"journey-head\"><div><span class=\"row-kicker\">SHIPMENT JOURNEY</span><h3>Checkpoint progress</h3><p>Milestones are updated manually by the Seller as cargo moves.</p></div>\n    <span class=\"pill ");
out.print(cancelled?"bad":selected.isTerminal()?"good":"blue");
out.write("\">");
out.print(cancelled?"Journey cancelled":selected.isTerminal()?"Delivery complete":journeyPct+"% through route");
out.write("</span>\n  </div>\n  <div class=\"journey-scroll\" tabindex=\"0\" role=\"region\" aria-label=\"Scrollable shipment progress\">\n    <div class=\"journey-flow\" style=\"--journey-progress:");
out.print(journeyPct);
out.write("%;\">\n      <div class=\"journey-rail\" aria-hidden=\"true\"><span class=\"journey-fill\"></span></div>\n      <ol class=\"journey-steps\">\n      ");
int stageIndex=0;for(String code:stages){
          boolean finished=stageIndex<reached||("DELIVERED".equals(selected.getStatus())&&stageIndex==reached)||cancelled&&stageIndex<=reached;
          boolean now=!cancelled&&!"DELIVERED".equals(selected.getStatus())&&stageIndex==reached;
      
out.write("\n        <li class=\"journey-stage ");
out.print(finished?"done":now?"current":"upcoming");
out.write("\" aria-label=\"");
out.print(code.replace('_',' '));
out.write(" — ");
out.print(finished?"completed":now?"current":"upcoming");
out.write("\">\n          <span class=\"journey-dot\">");
out.print(finished?"✓":now?"●":String.valueOf(stageIndex+1));
out.write("</span>\n          <span class=\"journey-stage-label\">");
out.print(model.Html.escape(code.replace('_',' ')));
out.write("</span>\n          <span class=\"journey-stage-caption\">");
out.print(finished?"Completed":now?"Current":"Upcoming");
out.write("</span>\n        </li>\n      ");
stageIndex++;}
out.write("\n      </ol>\n    </div>\n  </div>\n  ");
if(cancelled){
out.write("<div class=\"journey-cancel-note\" role=\"status\"><span aria-hidden=\"true\">⊘</span><div><strong>This shipment was cancelled.</strong><br/>Completed checkpoints remain visible for reference. No further movement updates are allowed.</div></div>");
}
out.write("\n</div>\n<div class=\"detail-grid\"><div class=\"detail-box\"><small>ETD</small><strong>");
out.print(selected.getEtd()==null?"Not scheduled":selected.getEtd());
out.write("</strong></div><div class=\"detail-box\"><small>ETA</small><strong>");
out.print(selected.getEta()==null?"Not scheduled":selected.getEta());
out.write("</strong></div><div class=\"detail-box\"><small>Actual arrival</small><strong>");
out.print(selected.getActualArrival()==null?"Pending":selected.getActualArrival());
out.write("</strong></div><div class=\"detail-box\"><small>Shipment ID</small><strong>#");
out.print(selected.getShipmentId());
out.write("</strong></div></div></section>");
renderDelayNotice(out,selected);
}
out.flush(); request.setAttribute("nlv_Module2_movementTracking__10", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(!timeline){
out.write("<section class=\"card\"><div class=\"card-head\"><div><h2>Search movement history</h2><p class=\"sub\">Filter by shipment, status or event date.</p></div></div><form class=\"form-grid\" method=\"get\" action=\"");
out.print(model.Html.escape(url));
out.write("\" data-filter-range><input type=\"hidden\" name=\"action\" value=\"searchMovements\"/><div class=\"field\"><label for=\"m-id\">Shipment ID</label><input id=\"m-id\" class=\"input\" type=\"number\" min=\"1\" name=\"shipmentId\" placeholder=\"All shipments\" value=\"");
out.print(model.Html.escape(id));
out.write("\"/></div><div class=\"field\"><label for=\"m-status\">Movement status</label><select id=\"m-status\" class=\"select\" name=\"status\"><option value=\"\">All statuses</option>");
for(String code:ShipmentPojo.STATUSES){
out.write("<option value=\"");
out.print(code);
out.write("\" ");
out.print(code.equals(status)?"selected":"");
out.write(">");
out.print(code.replace('_',' '));
out.write("</option>");
}
out.write("</select></div><div class=\"field\"><label for=\"m-start\">From date</label><input id=\"m-start\" class=\"input\" type=\"date\" name=\"startDate\" value=\"");
out.print(model.Html.escape(start));
out.write("\"/></div><div class=\"field\"><label for=\"m-end\">To date</label><input id=\"m-end\" class=\"input\" type=\"date\" name=\"endDate\" value=\"");
out.print(model.Html.escape(end));
out.write("\"/></div><div class=\"date-shortcuts\" aria-label=\"Quick date ranges\"><span>Quick range</span><button type=\"button\" class=\"date-chip\" data-days=\"7\">7 days</button><button type=\"button\" class=\"date-chip\" data-days=\"30\">30 days</button><button type=\"button\" class=\"date-chip\" data-days=\"90\">90 days</button></div><div class=\"form-actions\"><button type=\"submit\" class=\"btn primary\">Apply filters</button><a class=\"btn light\" href=\"");
out.print(model.Html.escape(url));
out.write("?action=movements\">Reset</a></div></form></section>");
}
out.flush(); request.setAttribute("nlv_Module2_movementTracking__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module2_movementTracking__12", String.valueOf(timeline?"Journey timeline":"Recorded movement events"));
request.setAttribute("nlv_Module2_movementTracking__13", String.valueOf(events.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(events.isEmpty()){
out.write("<div class=\"empty\"><strong>No movement records found</strong>Choose another shipment or date range.</div>");
}else if(timeline){
out.write("<div class=\"timeline\">");
for(ContainerMovementPojo ev:events){
out.write("<div class=\"timeline-item\"><div class=\"card-head\" style=\"margin-bottom:6px\"><h3>");
out.print(model.Html.escape(ev.getStatusLabel()));
out.write("</h3><span class=\"pill blue\">");
out.print(ev.getEventTime()==null?"Time unavailable":model.Html.escape(ev.getEventTime().toString().replace('T',' ')));
out.write("</span></div><p><strong>");
out.print(model.Html.escape(ev.getLocationText()));
out.write("</strong> ");
out.print(ev.getRemarks()==null?"":" · "+model.Html.escape(ev.getRemarks()));
out.write("</p></div>");
}
out.write("</div>");
}else{
java.util.Map<Integer,java.util.List<ContainerMovementPojo>> byShipment=new java.util.LinkedHashMap<Integer,java.util.List<ContainerMovementPojo>>();
for(ContainerMovementPojo event:events){
  if(!byShipment.containsKey(event.getShipmentId()))byShipment.put(event.getShipmentId(),new java.util.ArrayList<ContainerMovementPojo>());
  byShipment.get(event.getShipmentId()).add(event);
}

out.write("\n<div class=\"movement-viewbar\">\n <div><strong>");
out.print(byShipment.size());
out.write(" shipments</strong> <span class=\"muted\">· ");
out.print(events.size());
out.write(" matching events</span><p class=\"sub\">Showing the events returned by your selected filters.</p></div>\n <div class=\"movement-viewactions\" role=\"group\" aria-label=\"Movement history arrangement\">\n  <button type=\"button\" class=\"view-switch is-active\" data-movement-view=\"grouped\" aria-pressed=\"true\">Grouped by shipment</button>\n  <button type=\"button\" class=\"view-switch\" data-movement-view=\"chronological\" aria-pressed=\"false\">All events by date</button>\n </div>\n</div>\n<div id=\"groupedMovements\" data-movement-panel=\"grouped\" class=\"movement-groups\">\n <div class=\"group-utility\"><span class=\"muted small\">Select a shipment to view each recorded checkpoint. Cancelled bookings retain their historical events.</span><div class=\"table-buttons\"><button type=\"button\" class=\"btn light small\" data-group-action=\"expand\">Expand all</button><button type=\"button\" class=\"btn light small\" data-group-action=\"collapse\">Collapse all</button></div></div>\n ");
int groupIndex=0;for(java.util.Map.Entry<Integer,java.util.List<ContainerMovementPojo>> entry:byShipment.entrySet()){
   java.util.List<ContainerMovementPojo> groupEvents=entry.getValue();
   ContainerMovementPojo newest=groupEvents.get(0);
 
out.write("\n <details class=\"movement-group\" ");
out.print(groupIndex<1?"open='open'":"");
out.write(">\n  <summary><span class=\"group-identity\"><span class=\"group-symbol\" aria-hidden=\"true\">▤</span><span><strong class=\"nl-inline-copy\" role=\"button\" tabindex=\"0\" data-nl-copy-value=\"");
out.print(entry.getKey());
out.write("\" title=\"Click to copy shipment ID\" aria-label=\"Copy shipment ID ");
out.print(entry.getKey());
out.write("\">Shipment #");
out.print(entry.getKey());
out.write("</strong><small>");
out.print(groupEvents.size());
out.write(" logged event");
out.print(groupEvents.size()==1?"":"s");
out.write(" · Latest ");
out.print(model.Html.escape(newest.getStatusLabel()));
out.write("</small></span></span>\n  <span class=\"group-aside\"><span class=\"pill ");
out.print("CANCELLED".equals(newest.getStatus())?"bad":"DELIVERED".equals(newest.getStatus())?"good":"blue");
out.write("\">");
out.print(model.Html.escape(newest.getStatusLabel()));
out.write("</span><span class=\"muted small\">");
out.print(newest.getEventTime()==null?"Time unavailable":model.Html.escape(newest.getEventTime().toString().replace('T',' ')));
out.write("</span><span class=\"group-chevron\" aria-hidden=\"true\">⌄</span></span></summary>\n  <div class=\"group-body\">\n  <div class=\"group-events\">\n  ");
for(int ei=0;ei<groupEvents.size();ei++){ContainerMovementPojo ev=groupEvents.get(ei);
out.write("\n   <div class=\"group-event\"><div class=\"group-event-step\"><span class=\"event-bullet\">");
out.print(ei==0?"●":"✓");
out.write("</span></div><div class=\"event-details\"><div class=\"event-topline\"><strong>");
out.print(model.Html.escape(ev.getStatusLabel()));
out.write("</strong><time>");
out.print(ev.getEventTime()==null?"—":model.Html.escape(ev.getEventTime().toString().replace('T',' ')));
out.write("</time></div><div class=\"event-location\">");
out.print(model.Html.escape(ev.getLocationText()==null?"Location not recorded":ev.getLocationText()));
out.write("</div>");
if(ev.getRemarks()!=null&&!ev.getRemarks().trim().isEmpty()){
out.write("<div class=\"event-comment\">");
out.print(model.Html.escape(ev.getRemarks()));
out.write("</div>");
}
if(ev.getUpdatedBy()!=null){
out.write("<span class=\"event-actor\">Recorded by user #");
out.print(ev.getUpdatedBy());
out.write("</span>");
}
out.write("</div></div>\n  ");
}
out.write("\n  </div>\n  <div class=\"group-footer\"><a class=\"btn light small\" href=\"");
out.print(model.Html.escape(url));
out.write("?action=timeline&amp;shipmentId=");
out.print(entry.getKey());
out.write("\">Open full shipment timeline →</a></div>\n  </div>\n </details>\n ");
groupIndex++;}
out.write("\n</div>\n<div id=\"chronologicalMovements\" data-movement-panel=\"chronological\" hidden=\"hidden\"><div class=\"table-toolbar\"><span class=\"table-status\">Newest recorded events first · Sort by a column heading</span></div><div class=\"table-wrap\"><table id=\"movementTable\" class=\"data-table\"><thead><tr><th data-table-sort>Shipment ↕</th><th data-table-sort>Status ↕</th><th>Location</th><th data-table-sort>Event time ↕</th><th>Remarks</th><th>Open</th></tr></thead><tbody>");
for(ContainerMovementPojo ev:events){
out.write("<tr><td><strong>#");
out.print(ev.getShipmentId());
out.write("</strong></td><td><span class=\"pill blue\">");
out.print(model.Html.escape(ev.getStatusLabel()));
out.write("</span></td><td>");
out.print(model.Html.escape(ev.getLocationText()));
out.write("</td><td class=\"mono\">");
out.print(ev.getEventTime()==null?"—":model.Html.escape(ev.getEventTime().toString().replace('T',' ')));
out.write("</td><td>");
out.print(model.Html.escape(ev.getRemarks()==null?"—":ev.getRemarks()));
out.write("</td><td><a class=\"btn small light\" href=\"");
out.print(model.Html.escape(url));
out.write("?action=timeline&amp;shipmentId=");
out.print(ev.getShipmentId());
out.write("\">Timeline</a></td></tr>");
}
out.write("</tbody></table></div></div>\n");
}
out.flush(); request.setAttribute("nlv_Module2_movementTracking__14", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(timeline && selected!=null && Boolean.TRUE.equals(request.getAttribute("canEdit")) && !selected.isTerminal() && events.size()>1){
 ContainerMovementPojo latest=events.get(events.size()-1);
 if(!"BOOKED".equals(latest.getStatus()) && !"CANCELLED".equals(latest.getStatus()) && !"DELIVERED".equals(latest.getStatus())){
out.write("\n<details class=\"expander correction-panel\"><summary>Incorrect checkpoint? Undo the most recent update</summary><div><p>This action restores the <strong>previous recorded status</strong> and leaves earlier milestones intact. Use it only to correct an accidental Seller update.</p>\n");
ContainerMovementPojo previous=events.get(events.size()-2);
out.write("\n<div class=\"correction-preview\" aria-label=\"Checkpoint correction preview\"><div><small>Current checkpoint</small><strong>");
out.print(model.Html.escape(latest.getStatusLabel()));
out.write("</strong></div><span class=\"correction-arrow\" aria-hidden=\"true\">←</span><div><small>Restore to</small><strong>");
out.print(model.Html.escape(previous.getStatusLabel()));
out.write("</strong></div></div>\n<p class=\"correction-help\">Only the latest, non-final checkpoint is eligible. A shipment with claims or protected history cannot be corrected. MySQL validates eligibility and writes an audit record.</p>\n<form method=\"post\" action=\"");
out.print(model.Html.escape(url));
out.write("\" class=\"form-grid two\" data-review=\"correction\" data-review-title=\"Review checkpoint correction\">\n<input type=\"hidden\" name=\"action\" value=\"deleteMovement\"/><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(request.getAttribute("csrfToken")));
out.write("\"/>\n<input type=\"hidden\" name=\"shipmentId\" value=\"");
out.print(selected.getShipmentId());
out.write("\"/>\n<input type=\"hidden\" name=\"movementId\" value=\"");
out.print(latest.getMovementId());
out.write("\"/>\n<div class=\"field\"><label for=\"correctionReason\">Why are you undoing this checkpoint?</label><input id=\"correctionReason\" class=\"input\" name=\"reason\" required=\"required\" maxlength=\"255\" placeholder=\"e.g. Status selected by mistake\"/></div><div class=\"form-actions\"><button class=\"btn light\" type=\"submit\">Review correction →</button></div></form></div></details>\n");
}}
out.flush(); request.setAttribute("nlv_Module2_movementTracking__15", nlvString.toString());out=null;nlvString=null;
return "";
}


/** The Consumer's persistent in-app shipment delay notice, rendered after authorization. */
private static void renderDelayNotice(java.io.PrintWriter out, ShipmentPojo shipment) {
    if(shipment==null||!shipment.hasReportedDelay())return;
    java.util.Map<String,String> latest=shipment.getLatestDelayNotice();
    out.write("<section class=\"nl-delay-notice\" role=\"status\" aria-label=\"Shipment delay reported\">"
        +"<div class=\"nl-delay-notice-head\"><span class=\"nl-delay-emblem\" aria-hidden=\"true\">!</span>"
        +"<div><strong>Shipment delay reported</strong><small>Notice from the Seller - delivery estimate revised</small></div></div>"
        +"<div class=\"nl-delay-date-strip\"><span>Previous ETA <strong>"+Html.escape(latest.get("previous_eta"))+"</strong></span>"
        +"<span>Reported revised ETA <strong>"+Html.escape(latest.get("revised_eta"))+"</strong></span>"
        +"<span>Current ETA <strong>"+Html.escape(shipment.getEta()==null?"Not scheduled":shipment.getEta())+"</strong></span></div>"
        +"<p class=\"nl-delay-reason\"><b>Reason:</b> "+Html.escape(latest.get("reason"))+"</p>");
    if(latest.get("reported_at")!=null)
        out.write("<small class=\"nl-delay-reported-at\">Reported on "+Html.escape(latest.get("reported_at"))+"</small>");
    if(shipment.getDelayNotices().size()>1) {
        out.write("<details class=\"nl-delay-history\"><summary>Earlier delay reports ("
            +(shipment.getDelayNotices().size()-1)+")</summary><div>");
        for(int i=1;i<shipment.getDelayNotices().size();i++) {
            java.util.Map<String,String> notice=shipment.getDelayNotices().get(i);
            out.write("<p><b>"+Html.escape(notice.get("previous_eta"))+" to "
                +Html.escape(notice.get("revised_eta"))+"</b> - "+Html.escape(notice.get("reason"))+"</p>");
        }
        out.write("</div></details>");
    }
    out.write("<p class=\"nl-delay-visibility-note\">This notice is visible to the Consumer in shipment details and tracking. It does not change the movement checkpoint.</p></section>");
}

/** Owning Seller's voluntary delay report; no new shipment status is created. */
private static void renderDelayReportForm(java.io.PrintWriter out, ShipmentPojo shipment,
        String url, Object token, boolean fromMovement, Object error) {
    if(shipment==null||shipment.isTerminal())return;
    out.write("<details class=\"nl-delay-report\" id=\"nlDelayReport\""+(error!=null?" open=\"open\"":"")+">"
        +"<summary>Report shipment delay <span class=\"nl-delay-summary-hint\">Notify Consumer in tracking</span></summary><div class=\"nl-delay-report-body\">"
        +"<p>Share why the shipment will arrive late. The revised ETA and your reason will be saved together and shown to the Consumer.</p>");
    if(error!=null)out.write("<div class=\"nl-delay-error\" role=\"alert\">"+Html.escape(error)+"</div>");
    if(shipment.getEta()==null) {
        out.write("<p class=\"nl-delay-error\">Set the expected arrival date in Shipment Schedule before reporting a delay.</p>");
    } else if("ARRIVED".equals(shipment.getStatus())||"CUSTOMS_CLEARED".equals(shipment.getStatus())) {
        out.write("<p class=\"nl-delay-muted\">The shipment has already reached the destination. Delay reports cannot be submitted after arrival.</p>");
    } else {
        out.write("<form method=\"post\" action=\""+Html.escape(url)+"\" class=\"nl-delay-form\">"
            +"<input type=\"hidden\" name=\"action\" value=\"reportShipmentDelay\"/>"
            +"<input type=\"hidden\" name=\"shipmentId\" value=\""+shipment.getShipmentId()+"\"/>"
            +"<input type=\"hidden\" name=\"csrfToken\" value=\""+Html.escape(token)+"\"/>");
        if(fromMovement)out.write("<input type=\"hidden\" name=\"returnTo\" value=\"movementUpdate\"/>");
        out.write("<div class=\"nl-delay-form-grid\">"
            +"<div class=\"field\"><label>Current ETA</label><div class=\"nl-delay-current\">"+Html.escape(shipment.getEta())+"</div></div>"
            +"<div class=\"field\"><label for=\"nlRevisedEta\">Revised expected arrival <span aria-hidden=\"true\">*</span></label>"
            +"<input class=\"input nl-delay-date\" id=\"nlRevisedEta\" type=\"date\" name=\"revisedEta\" required=\"required\" min=\""
            +shipment.getEta().plusDays(1)+"\"/></div>"
            +"</div><div class=\"field\"><label for=\"nlDelayReason\">Reason for delay <span aria-hidden=\"true\">*</span></label>"
            +"<textarea class=\"textarea\" id=\"nlDelayReason\" name=\"delayReason\" rows=\"3\" required=\"required\" minlength=\"10\" maxlength=\"255\" "
            +"placeholder=\"For example: Vessel departure postponed because of port congestion\"></textarea></div>"
            +"<div class=\"nl-delay-report-actions\"><button class=\"btn primary\" type=\"submit\">Save delay and notify Consumer</button>"
            +"<small>In-app notification only; no email or SMS is sent.</small></div></form>");
    }
    out.write("</div></details>");
}

/** Module 2 scheduling controls: one form updates both dates atomically. */
private static void renderShipmentSchedule(java.io.PrintWriter out, ShipmentPojo shipment,
        String url, Object token, boolean fromMovement) {
    String csrf=Html.escape(token),target=Html.escape(url);
    out.write("<section class=\"nl-schedule-panel\" id=\"nlShipmentSchedule\" aria-labelledby=\"nl-schedule-heading\">"
       +"<div class=\"nl-schedule-header\"><div class=\"nl-schedule-emblem\" aria-hidden=\"true\">&#128197;</div>"
       +"<div class=\"nl-schedule-header-copy\"><h3 id=\"nl-schedule-heading\">Shipment schedule</h3>"
       +"<p>Set expected departure and arrival together. These are estimates, not actual arrival events.</p>"
       +"</div><span class=\"nl-schedule-pill\">Seller scheduling</span></div>"
       +"<form class=\"nl-schedule-combined\" method=\"post\" action=\""+target+"\">"
       +"<input type=\"hidden\" name=\"action\" value=\"updateShipmentSchedule\"/>"
       +"<input type=\"hidden\" name=\"shipmentId\" value=\""+shipment.getShipmentId()+"\"/>"
       +"<input type=\"hidden\" name=\"csrfToken\" value=\""+csrf+"\"/>");
    if(fromMovement)out.write("<input type=\"hidden\" name=\"returnTo\" value=\"movementUpdate\"/>");
    out.write("<div class=\"nl-schedule-grid\">");
    String[] fields={"etd","eta"},names={"Expected departure (ETD)","Expected arrival (ETA)"};
    for(int i=0;i<fields.length;i++){
        String field=fields[i], id="nl-sched-"+field;
        java.time.LocalDate saved=i==0?shipment.getEtd():shipment.getEta();
        out.write("<div class=\"nl-schedule-form\">"
          +"<label for=\""+id+"\">"+names[i]+" <span class=\"nl-sched-required\">*</span></label>"
          +"<div class=\"nl-schedule-date-slot\"><input class=\"nl-schedule-date\" type=\"date\" name=\""+field+"\" data-schedule-field=\""+field+"\" id=\""+id+"\" required=\"required\" value=\""+(saved==null?"":saved.toString())+"\"/></div>"
          +"<small class=\"nl-schedule-saved\">Currently saved: <strong>"+(saved==null?"Not scheduled":saved.toString())+"</strong></small>"
          +"</div>");
    }
    out.write("</div><p class=\"nl-schedule-error\" role=\"alert\" aria-live=\"polite\"></p>");
    out.write("<div class=\"nl-schedule-toolbar\"><button class=\"btn primary nl-schedule-save\" type=\"submit\">Save both dates</button>"
       +"<span class=\"nl-schedule-helper\">ETA must be on or after ETD. Both dates save in one update.</span></div></form>");
    out.write("<p class=\"nl-schedule-footer\">"+(fromMovement?
        "Save the schedule first, then record the next checkpoint below.":
        "The saved dates appear in shipment details and status updates.")+"</p></section>");
}

/** Collapsible cargo and vessel editor, shared by details and status-update views.
 * The Update Status JSP owns the visible disclosure/summary: the model supplies ONLY
 * the form body, preventing a missing/disallowed server fragment from hiding the heading.
 */
private static void renderOtherShipmentFields(java.io.PrintWriter out, ShipmentPojo shipment,
        String url, Object token, boolean fromMovement) {
    if(!fromMovement) {
        out.write("<details class=\"expander nl-other-shipment-fields\"><summary>Other shipment details - cargo and vessel</summary><div>");
    }
    out.write("<p>Update the vessel or cargo description. Use the Shipment schedule card for ETD and ETA.</p>"
        +"<form method=\"post\" action=\""+Html.escape(url)+"\" class=\"nl-metadata-form\" data-confirm=\"Save this shipment field change?\">"
        +"<input type=\"hidden\" name=\"action\" value=\"updateShipmentField\"/>"
        +"<input type=\"hidden\" name=\"shipmentId\" value=\""+shipment.getShipmentId()+"\"/>"
        +"<input type=\"hidden\" name=\"csrfToken\" value=\""+Html.escape(token)+"\"/>");
    if(fromMovement)out.write("<input type=\"hidden\" name=\"returnTo\" value=\"movementUpdate\"/>");
    out.write("<div class=\"field\"><label for=\"edit-field\">Detail to update <span class=\"nl-sched-required\">*</span></label>"
       +"<select class=\"select\" id=\"edit-field\" name=\"field\" required=\"required\">"
       +"<option value=\"cargo_description\">Cargo description</option><option value=\"vessel_id\">Vessel ID</option></select></div>"
       +"<div class=\"field\"><label for=\"edit-value\">New value <span class=\"nl-sched-required\">*</span></label>"
       +"<input class=\"input\" id=\"edit-value\" name=\"value\" required=\"required\" maxlength=\"255\" placeholder=\"Enter updated description\"/></div>"
       +"<div class=\"nl-metadata-action\"><button class=\"btn primary\" type=\"submit\">Save detail</button></div>"
       +"</form>");
    if(!fromMovement)out.write("</div></details>");
}

/** Correction body for the permanently visible, collapsed checkpoint-correction section.
 * Never hide the whole section: show the reason when undo is not presently allowed.
 */
private static void renderCheckpointCorrection(java.io.PrintWriter out, ShipmentPojo shipment,
        java.util.List<ContainerMovementPojo> events, String url, Object token, Object error) {
    if(error!=null)out.write("<div class=\"correction-error\" role=\"alert\">"+Html.escape(error)+"</div>");
    if(shipment.isTerminal()){
        out.write("<p class=\"nl-status-unavailable\">Correction is unavailable for a delivered or cancelled shipment. Its completed history remains protected.</p>");
        return;
    }
    if(events.size()<2){
        out.write("<p class=\"nl-status-unavailable\">Correction becomes available after at least two checkpoints are recorded. The original BOOKED event cannot be undone.</p>");
        return;
    }
    ContainerMovementPojo latest=events.get(events.size()-1),previous=events.get(events.size()-2);
    if("BOOKED".equals(latest.getStatus())||"CANCELLED".equals(latest.getStatus())||"DELIVERED".equals(latest.getStatus())){
        out.write("<p class=\"nl-status-unavailable\">The most recent status is not eligible for correction. Completed or cancelled checkpoints are protected.</p>");
        return;
    }
    out.write("<p>Restore the previous recorded status without removing earlier checkpoints. Only the latest eligible event can be corrected.</p>");
    out.write("<div class=\"correction-preview\"><div><small>Current checkpoint</small><strong>"
        +Html.escape(latest.getStatusLabel())+"</strong></div><span class=\"correction-arrow\" aria-hidden=\"true\">&larr;</span>"
        +"<div><small>Restore to</small><strong>"+Html.escape(previous.getStatusLabel())+"</strong></div></div>"
        +"<p class=\"correction-help\">Correction is audited and may be blocked if there are claims or protected events.</p>"
        +"<form method=\"post\" action=\""+Html.escape(url)+"\" class=\"form-grid two\" "
        +"data-review=\"correction\" data-review-title=\"Review checkpoint correction\">"
        +"<input type=\"hidden\" name=\"action\" value=\"deleteMovement\"/>"
        +"<input type=\"hidden\" name=\"returnTo\" value=\"movementUpdate\"/>"
        +"<input type=\"hidden\" name=\"csrfToken\" value=\""+Html.escape(token)+"\"/>"
        +"<input type=\"hidden\" name=\"shipmentId\" value=\""+shipment.getShipmentId()+"\"/>"
        +"<input type=\"hidden\" name=\"movementId\" value=\""+latest.getMovementId()+"\"/>"
        +"<div class=\"field\"><label for=\"statusCorrectionReason\">Reason for correction <span class=\"nl-sched-required\">*</span></label>"
        +"<input id=\"statusCorrectionReason\" class=\"input\" name=\"reason\" required=\"required\" maxlength=\"255\" placeholder=\"Describe the incorrect update\"/></div>"
        +"<div class=\"form-actions\"><button class=\"btn primary\" type=\"submit\">Review correction</button></div>"
        +"</form>");
}

@SuppressWarnings("unused")
private String prepare_Module2_movementUpdate(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("activeNav","movements"); 

String url=request.getContextPath()+"/containerMovement";
ShipmentPojo shipment=(ShipmentPojo)request.getAttribute("shipment");
Object rawEventsAttribute=request.getAttribute("movements");
List<ContainerMovementPojo> events=new ArrayList<ContainerMovementPojo>();
if (rawEventsAttribute instanceof List<?>) {
    for (Object item : (List<?>) rawEventsAttribute) {
        if (item instanceof ContainerMovementPojo) events.add((ContainerMovementPojo) item);
    }
}
Object rawPortsAttribute=request.getAttribute("ports");
List<PortPojo> ports=new ArrayList<PortPojo>();
if (rawPortsAttribute instanceof List<?>) {
    for (Object item : (List<?>) rawPortsAttribute) {
        if (item instanceof PortPojo) ports.add((PortPojo) item);
    }
}
if(shipment==null){response.sendError(404);return "";}

request.setAttribute("nlv_Module2_movementUpdate__1", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_movementUpdate__2", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_movementUpdate__3", String.valueOf(shipment.getShipmentId()));
request.setAttribute("nlv_Module2_movementUpdate__4", String.valueOf(model.Html.escape(shipment.getShipmentNo())));
request.setAttribute("nlv_Module2_movementUpdate__5", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_movementUpdate__6", String.valueOf(shipment.getShipmentId()));
request.setAttribute("nlv_Module2_movementUpdate__7", String.valueOf(model.Html.escape(shipment.getShipmentNo())));
request.setAttribute("nlv_Module2_movementUpdate__8", String.valueOf(model.Html.escape(shipment.getOriginPortName())));
request.setAttribute("nlv_Module2_movementUpdate__9", String.valueOf(model.Html.escape(shipment.getDestPortName())));
request.setAttribute("nlv_Module2_movementUpdate__10", String.valueOf(model.Html.escape(shipment.getStatusLabel())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(shipment.getNextStatuses().isEmpty()){
out.write("<div class=\"hint\">This shipment is closed or has no permitted next status. Movement updates are unavailable.</div>");
}else{
if(request.getAttribute("notice")!=null){
    out.write("<div class=\"alert alert-success\" role=\"status\"> ");
    out.print(model.Html.escape(request.getAttribute("notice")));
    out.write("</div>");
}
if(request.getAttribute("scheduleError")!=null)
    out.write("<div class=\"nl-schedule-server-error\" role=\"alert\">"+Html.escape(request.getAttribute("scheduleError"))+"</div>");
renderShipmentSchedule(out, shipment, url, request.getAttribute("csrfToken"), true);
out.write("<div class=\"hint\" style=\"margin-bottom:18px\">This action adds a new checkpoint to the shipment history. The system records the current time and validates the next permitted status. Only the owning Seller can submit this update.</div>\n<form method=\"post\" action=\"");
out.print(model.Html.escape(url));
out.write("\" data-review=\"movement\" data-review-title=\"Confirm checkpoint update\" class=\"form-grid two\"><input type=\"hidden\" name=\"action\" value=\"addMovement\"/><input type=\"hidden\" name=\"shipmentId\" value=\"");
out.print(shipment.getShipmentId());
out.write("\"/><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(request.getAttribute("csrfToken")));
out.write("\"/>\n<div class=\"field\"><label for=\"next\">Next checkpoint status</label><select class=\"select\" name=\"status\" id=\"next\" required>");
for(String next:shipment.getNextStatuses()){
out.write("<option value=\"");
out.print(next);
out.write("\">");
out.print(next.replace('_',' '));
out.write("</option>");
}
out.write("</select></div>\n<div class=\"field\"><label for=\"port\">Checkpoint port (optional)</label><select class=\"select\" name=\"portId\" id=\"port\"><option value=\"\">Other / offshore location</option>");
for(PortPojo p:ports){
out.write("<option value=\"");
out.print(p.getPortId());
out.write("\">");
out.print(model.Html.escape(p.getPortName()));
out.write("</option>");
}
out.write("</select></div>\n<div class=\"field\"><label for=\"location\">Location / checkpoint</label><input class=\"input\" name=\"locationText\" id=\"location\" placeholder=\"e.g. Mumbai Container Terminal\" required maxlength=\"150\"/></div>\n<div class=\"field\"><label for=\"remarks\">Remarks</label><textarea class=\"textarea\" name=\"remarks\" id=\"remarks\" placeholder=\"Optional movement notes (up to 255 characters)\" maxlength=\"255\"></textarea></div>\n<div class=\"form-actions\"><button class=\"btn primary\" type=\"submit\">Review checkpoint update →</button><a class=\"btn light\" href=\"");
out.print(model.Html.escape(url));
out.write("?action=timeline&amp;shipmentId=");
out.print(shipment.getShipmentId());
out.write("\">Cancel</a></div></form>");
}
renderDelayReportForm(out,shipment,url,request.getAttribute("csrfToken"),true,request.getAttribute("delayError"));
renderDelayNotice(out,shipment);
out.flush(); request.setAttribute("nlv_Module2_movementUpdate__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module2_movementUpdate__12", String.valueOf(events.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(events.isEmpty()){
out.write("<div class=\"empty\">No movement events yet.</div>");
}else{
out.write("<div class=\"timeline\">");
for(ContainerMovementPojo ev:events){
out.write("<div class=\"timeline-item\"><h3>");
out.print(model.Html.escape(ev.getStatusLabel()));
out.write("</h3><p>");
out.print(model.Html.escape(ev.getLocationText()));
out.write(" · ");
out.print(ev.getEventTime()==null?"—":model.Html.escape(ev.getEventTime().toString().replace('T',' ')));
out.write("</p></div>");
}
out.write("</div>");
}
out.flush(); request.setAttribute("nlv_Module2_movementUpdate__13", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(!shipment.isTerminal()) {
    renderOtherShipmentFields(out,shipment,url,request.getAttribute("csrfToken"),true);
} else {
    out.write("<p class=\"nl-status-unavailable\">Cargo and vessel fields cannot be changed after a shipment is delivered or cancelled.</p>");
}
out.flush(); request.setAttribute("nlv_Module2_movementUpdate__15",nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
renderCheckpointCorrection(out,shipment,events,url,request.getAttribute("csrfToken"),request.getAttribute("correctionError"));
out.flush(); request.setAttribute("nlv_Module2_movementUpdate__16",nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module2_profitLossDashboard(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("activeNav","profit"); 

String ctx=request.getContextPath(),url=ctx+"/containerMovement";
Object rawMonthlyAttribute=request.getAttribute("monthlyRecords");
List<ProfitLossPojo> monthly=new ArrayList<ProfitLossPojo>();
if (rawMonthlyAttribute instanceof List<?>) {
    for (Object item : (List<?>) rawMonthlyAttribute) {
        if (item instanceof ProfitLossPojo) monthly.add((ProfitLossPojo) item);
    }
}
Object rawRowsAttribute=request.getAttribute("shipmentRecords");
List<ProfitLossPojo> rows=new ArrayList<ProfitLossPojo>();
if (rawRowsAttribute instanceof List<?>) {
    for (Object item : (List<?>) rawRowsAttribute) {
        if (item instanceof ProfitLossPojo) rows.add((ProfitLossPojo) item);
    }
}
String start=request.getParameter("startDate")==null?"":request.getParameter("startDate");
String end=request.getParameter("endDate")==null?"":request.getParameter("endDate");
String seller=request.getParameter("sellerId")==null?"":request.getParameter("sellerId");
boolean admin="ADMIN".equals(String.valueOf(request.getAttribute("currentRole")));
BigDecimal revenue=BigDecimal.ZERO,costs=BigDecimal.ZERO,claims=BigDecimal.ZERO,net=BigDecimal.ZERO;
for(ProfitLossPojo p:monthly){revenue=revenue.add(p.getRevenue());costs=costs.add(p.getOperatingCost());claims=claims.add(p.getClaimLoss());net=net.add(p.getNetProfit());}
ProfitLossPojo calculated=(ProfitLossPojo)request.getAttribute("calculated");

request.setAttribute("nlv_Module2_profitLossDashboard__1", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_profitLossDashboard__2", String.valueOf(model.Html.escape(url)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(request.getAttribute("notice")!=null){
out.write("<div class=\"alert\" role=\"status\">");
out.print(model.Html.escape(request.getAttribute("notice")));
out.write("</div>");
}
out.flush(); request.setAttribute("nlv_Module2_profitLossDashboard__3", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module2_profitLossDashboard__4", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_profitLossDashboard__5", String.valueOf(admin?"":"three"));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(admin){
out.write("<div class=\"field\"><label for=\"seller\">Seller company ID</label><input id=\"seller\" class=\"input\" type=\"number\" min=\"1\" name=\"sellerId\" value=\"");
out.print(model.Html.escape(seller));
out.write("\" placeholder=\"All sellers\"/></div>");
}
out.flush(); request.setAttribute("nlv_Module2_profitLossDashboard__6", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module2_profitLossDashboard__7", String.valueOf(model.Html.escape(start)));
request.setAttribute("nlv_Module2_profitLossDashboard__8", String.valueOf(model.Html.escape(end)));
request.setAttribute("nlv_Module2_profitLossDashboard__9", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module2_profitLossDashboard__10", String.valueOf(revenue.setScale(2,java.math.RoundingMode.HALF_UP)));
request.setAttribute("nlv_Module2_profitLossDashboard__11", String.valueOf(costs.setScale(2,java.math.RoundingMode.HALF_UP)));
request.setAttribute("nlv_Module2_profitLossDashboard__12", String.valueOf(claims.setScale(2,java.math.RoundingMode.HALF_UP)));
request.setAttribute("nlv_Module2_profitLossDashboard__13", String.valueOf(net.setScale(2,java.math.RoundingMode.HALF_UP)));
request.setAttribute("nlv_Module2_profitLossDashboard__14", String.valueOf(monthly.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(monthly.isEmpty()){
out.write("<div class=\"empty\"><strong>No financial records in this period</strong>Try a wider date range or refresh a shipment P&amp;L record.</div>");
}else{
out.write("<div class=\"chart-frame\"><canvas id=\"monthlyChart\" role=\"img\" aria-label=\"Financial trend by month: revenue, operating costs, and net profit\"></canvas></div><div class=\"form-note\" id=\"chartStatus\">Use the switches above to show or hide each series. A detailed data table is below.</div><div id=\"monthlyData\" hidden=\"hidden\">");
for(ProfitLossPojo p:monthly){
out.write("<span data-label=\"");
out.print(model.Html.escape(p.getMonthLabel()));
out.write("\" data-revenue=\"");
out.print(p.getRevenue());
out.write("\" data-cost=\"");
out.print(p.getOperatingCost());
out.write("\" data-profit=\"");
out.print(p.getNetProfit());
out.write("\"></span>");
}
out.write("</div>");
}
out.flush(); request.setAttribute("nlv_Module2_profitLossDashboard__15", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module2_profitLossDashboard__16", String.valueOf(monthly.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(monthly.isEmpty()){
out.write("<div class=\"empty\">No monthly report rows for the selected range.</div>");
}else{
out.write("<div class=\"table-wrap\"><table class=\"data-table\" id=\"monthTable\"><thead><tr><th data-table-sort>Month ↕</th><th class=\"numeric\" data-table-sort>Revenue ↕</th><th class=\"numeric\">Operating cost</th><th class=\"numeric\">Claim loss</th><th class=\"numeric\" data-table-sort>Net profit ↕</th></tr></thead><tbody>");
for(ProfitLossPojo p:monthly){
out.write("<tr><td>");
out.print(model.Html.escape(p.getMonthLabel()));
out.write("</td><td class=\"numeric\">₹");
out.print(p.getRevenue());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getOperatingCost());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getClaimLoss());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getNetProfit());
out.write("</td></tr>");
}
out.write("</tbody><tfoot><tr style=\"background:#fff0de;font-weight:900\"><td style=\"padding:13px\">TOTAL</td><td class=\"numeric\">₹");
out.print(revenue);
out.write("</td><td class=\"numeric\">₹");
out.print(costs);
out.write("</td><td class=\"numeric\">₹");
out.print(claims);
out.write("</td><td class=\"numeric\">₹");
out.print(net);
out.write("</td></tr></tfoot></table></div>");
}
out.flush(); request.setAttribute("nlv_Module2_profitLossDashboard__17", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module2_profitLossDashboard__18", String.valueOf(rows.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(rows.isEmpty()){
out.write("<div class=\"empty\">No shipment-level records match these filters.</div>");
}else{
out.write("<div class=\"table-toolbar\"><span class=\"table-status\">");
out.print(rows.size());
out.write(" detailed records · Click any sortable heading to reorder</span></div><div class=\"table-wrap\"><table class=\"data-table\" id=\"profitTable\"><thead><tr><th data-table-sort>Month ↕</th><th>Shipment</th><th class=\"numeric\">Revenue</th><th class=\"numeric\">Freight</th><th class=\"numeric\">Port</th><th class=\"numeric\">Handling</th><th class=\"numeric\">Claims</th><th class=\"numeric\" data-table-sort>Net profit ↕</th></tr></thead><tbody>");
for(ProfitLossPojo p:rows){
out.write("<tr><td>");
out.print(model.Html.escape(p.getMonthLabel()));
out.write("</td><td><span class=\"mono\">");
out.print(model.Html.escape(p.getShipmentNo()));
out.write("</span><span class=\"inline-muted\">#");
out.print(p.getShipmentId());
out.write("</span></td><td class=\"numeric\">₹");
out.print(p.getRevenue());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getFreightCost());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getPortCost());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getHandlingCost());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getClaimLoss());
out.write("</td><td class=\"numeric\">₹");
out.print(p.getNetProfit());
out.write("</td></tr>");
}
out.write("</tbody></table></div>");
}
out.flush(); request.setAttribute("nlv_Module2_profitLossDashboard__19", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(calculated!=null){
out.write("<section class=\"card soft\"><div class=\"caps\">READ-ONLY CALCULATION PREVIEW</div><h2>Shipment #");
out.print(calculated.getShipmentId());
out.write(" · ");
out.print(calculated.getMonthLabel());
out.write("</h2><div class=\"detail-grid\"><div class=\"detail-box\"><small>Revenue</small><strong>₹");
out.print(calculated.getRevenue());
out.write("</strong></div><div class=\"detail-box\"><small>Operating cost</small><strong>₹");
out.print(calculated.getOperatingCost());
out.write("</strong></div><div class=\"detail-box\"><small>Claim loss</small><strong>₹");
out.print(calculated.getClaimLoss());
out.write("</strong></div><div class=\"detail-box\"><small>Net profit</small><strong>₹");
out.print(calculated.getNetProfit());
out.write("</strong></div></div></section>");
}
out.flush(); request.setAttribute("nlv_Module2_profitLossDashboard__20", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(!admin){
out.write("\n<details class=\"expander\"><summary>Calculate or refresh a specific shipment's P&amp;L</summary><div><p>Calculate a preview without writing, or save verified costs to the financial ledger. Only the owning Seller can calculate or save shipment P&amp;L.</p><form action=\"");
out.print(model.Html.escape(url));
out.write("\" method=\"get\" class=\"form-grid three\"><input type=\"hidden\" name=\"action\" value=\"calculateProfitLoss\"/><div class=\"field\"><label for=\"calcId\">Shipment ID</label><input id=\"calcId\" class=\"input\" type=\"number\" name=\"shipmentId\" min=\"1\" required/></div><div class=\"field\"><label for=\"calcPeriod\">Month</label><input id=\"calcPeriod\" class=\"input\" type=\"month\" name=\"periodMonth\" required/></div><div class=\"form-actions\"><button class=\"btn light\" type=\"submit\">Calculate preview</button></div></form><hr class=\"section-divider\"/><form method=\"post\" action=\"");
out.print(model.Html.escape(url));
out.write("\" class=\"form-grid\" data-confirm=\"Refresh this shipment's profit/loss record using the supplied costs?\"><input type=\"hidden\" name=\"action\" value=\"refreshProfitLoss\"/><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(request.getAttribute("csrfToken")));
out.write("\"/><div class=\"field\"><label for=\"rfId\">Shipment ID</label><input class=\"input\" id=\"rfId\" type=\"number\" min=\"1\" name=\"shipmentId\" required/></div><div class=\"field\"><label for=\"rfMonth\">Period</label><input class=\"input\" id=\"rfMonth\" type=\"month\" name=\"periodMonth\" required/></div><div class=\"field\"><label for=\"rfFreight\">Freight cost (₹)</label><input class=\"input\" id=\"rfFreight\" type=\"number\" min=\"0\" step=\"0.01\" name=\"freightCost\" required/></div><div class=\"field\"><label for=\"rfPort\">Port cost (₹)</label><input class=\"input\" id=\"rfPort\" type=\"number\" min=\"0\" step=\"0.01\" name=\"portCost\" required/></div><div class=\"field\"><label for=\"rfHandling\">Handling cost (₹)</label><input class=\"input\" id=\"rfHandling\" type=\"number\" min=\"0\" step=\"0.01\" name=\"handlingCost\" required/></div><div class=\"form-actions\"><button type=\"submit\" class=\"btn primary\">Refresh P&amp;L</button></div></form></div></details>\n");
}else{
out.write("\n<div class=\"hint\" role=\"note\">Admin access is view-only for shipments, movement events and financial calculations. You can inspect and export the reports above; only the owning Seller can change shipment or P&amp;L records.</div>\n");
}
out.flush(); request.setAttribute("nlv_Module2_profitLossDashboard__21", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module2_shipmentManagement(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("activeNav","shipments"); 

String ctx=request.getContextPath(), uri=ctx+"/containerMovement";
Object rawEntriesAttribute=request.getAttribute("shipments");
List<ShipmentPojo> entries=new ArrayList<ShipmentPojo>();
if (rawEntriesAttribute instanceof List<?>) {
    for (Object item : (List<?>) rawEntriesAttribute) {
        if (item instanceof ShipmentPojo) entries.add((ShipmentPojo) item);
    }
}
Object rawPortsAttribute=request.getAttribute("ports");
List<PortPojo> ports=new ArrayList<PortPojo>();
if (rawPortsAttribute instanceof List<?>) {
    for (Object item : (List<?>) rawPortsAttribute) {
        if (item instanceof PortPojo) ports.add((PortPojo) item);
    }
}
ShipmentPojo selected=(ShipmentPojo)request.getAttribute("shipment");
String role=String.valueOf(request.getAttribute("currentRole"));
User currentUser=request.getAttribute("currentUser") instanceof User?(User)request.getAttribute("currentUser"):null;
Set<?> cancelEligible=request.getAttribute("cancelEligible") instanceof Set<?> ? (Set<?>)request.getAttribute("cancelEligible") : Collections.emptySet();
int total=request.getAttribute("totalShipments") instanceof Number?((Number)request.getAttribute("totalShipments")).intValue():entries.size();
int current=request.getAttribute("currentPage") instanceof Number?((Number)request.getAttribute("currentPage")).intValue():1;
int totalPages=request.getAttribute("pageCount") instanceof Number?((Number)request.getAttribute("pageCount")).intValue():1;
int active=0,delayed=0,closed=0,delivered=0,transit=0,awaiting=0;
for(ShipmentPojo s:entries){if(s.hasDelayAlert())delayed++;if(s.isTerminal())closed++;else active++;if("DELIVERED".equals(s.getStatus()))delivered++;if("IN_TRANSIT".equals(s.getStatus())||"DEPARTED".equals(s.getStatus()))transit++;if("BOOKED".equals(s.getStatus())||"LOADED".equals(s.getStatus()))awaiting++;}
String container=request.getParameter("containerNumber")==null?"":request.getParameter("containerNumber");
String status=request.getParameter("status")==null?"":request.getParameter("status");
String port=request.getParameter("portId")==null?"":request.getParameter("portId");
String shipmentId=request.getParameter("shipmentId")==null?"":request.getParameter("shipmentId");
String filterQuery="&containerNumber="+java.net.URLEncoder.encode(container,"UTF-8")+"&status="+java.net.URLEncoder.encode(status,"UTF-8")+"&portId="+java.net.URLEncoder.encode(port,"UTF-8")+"&shipmentId="+java.net.URLEncoder.encode(shipmentId,"UTF-8");

nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(selected!=null && request.getAttribute("notice")!=null){
out.write("\n<div class=\"alert alert-success rounded-4 fw-semibold nl-payment-shipment-notice\" role=\"status\" aria-live=\"polite\">\n  <strong>Payment recorded.</strong> ");
out.print(model.Html.escape(request.getAttribute("notice")));
out.write("\n</div>\n");
}
out.flush(); request.setAttribute("nlv_Module2_shipmentManagement__1", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(selected==null){
out.write("\n<div class=\"bread\"><a href=\"");
out.print(model.Html.escape(uri));
out.write("?action=shipments\">Workspace</a> <span>/</span> <b>Shipment management</b></div>\n");
 if(session.getAttribute("paymentSuccess")!=null){ 
out.write("<div class=\"alert alert-success rounded-4 fw-semibold\" role=\"status\"><strong>Payment recorded.</strong> ");
out.print(model.Html.escape(session.getAttribute("paymentSuccess")));
out.write(" The related shipment is highlighted below.");
 session.removeAttribute("paymentSuccess"); 
out.write("</div>");
 } 
out.write("\n<div class=\"page-heading page-hero\"><div class=\"hero-copy\"><div class=\"caps\">SHIPMENT OPERATIONS</div><h1>Shipment <span>management</span></h1><p>Track every shipment, review routes and manage authorized movement updates.</p></div><div class=\"hero-art\" aria-hidden=\"true\"><div class=\"ship-scene\"><div class=\"ship-halo\"></div><div class=\"ship-wave\"></div><div class=\"ship-line\"></div><div class=\"ship-boat\"><span class=\"ship-sail\"></span><span class=\"ship-sail small\"></span></div><div class=\"ship-boxes\"><i></i><i></i><i></i></div><span class=\"ship-spark one\"></span><span class=\"ship-spark two\"></span></div></div><div class=\"hero-actions\"><a class=\"btn light\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=movements\">◎ Movement history</a>");
if(!"CONSUMER".equals(role)){
out.write("<a class=\"btn primary\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=profitLoss\">▥ P&amp;L report ↗</a>");
}
out.write("</div></div>\n\n");
if(request.getAttribute("notice")!=null){
out.write("<div class=\"alert\" role=\"status\">");
out.print(model.Html.escape(request.getAttribute("notice")));
out.write("</div>");
}
out.write("\n");
if(request.getAttribute("cancellationError")!=null){
out.write("<div class=\"nl-cancel-feedback\" role=\"alert\"><strong>Booking could not be cancelled.</strong> ");
out.print(model.Html.escape(request.getAttribute("cancellationError")));
out.write("</div>");
}
out.write("\n");

boolean sellerView="SELLER".equals(role),adminView="ADMIN".equals(role),consumerView="CONSUMER".equals(role);
String[] cardLabels=adminView?new String[]{"Visible shipments","Active operations","Delivered","Delayed shipments"}:sellerView?new String[]{"Your shipments","Awaiting dispatch","In transit","Delivered"}:new String[]{"My bookings","On the way","Delivered to destination","Upcoming dispatch"};
int[] cardCounts=adminView?new int[]{total,active,delivered,delayed}:sellerView?new int[]{total,awaiting,transit,delivered}:new int[]{total,transit,delivered,awaiting};
String[] cardNotes=adminView?new String[]{"Network records in view","Open shipments on this page","Completed deliveries on this page","Reported or overdue arrivals"}:sellerView?new String[]{"For your company","Booked or loaded on this page","Departed and in transit","Completed deliveries"}:new String[]{"Bookings you can access","Departed or in transit","Successfully delivered","Booked or loaded"};
String[] cardSymbols={"▤","◷","✓","↗"};

out.write("\n<div class=\"role-summary-head\"><div class=\"role-summary-label\"><span class=\"role-indicator\">");
out.print(adminView?"ADMIN · SHIPMENT OVERSIGHT":sellerView?"SELLER · OPERATIONS":"CONSUMER · TRACKING");
out.write("</span><strong>");
out.print(adminView?"Network visibility":sellerView?"Your shipment operations":"Your delivery overview");
out.write("</strong></div><p class=\"muted small\">Totals use your selected search. Status breakdowns describe the records loaded on this page.</p></div>\n<div class=\"stats-grid role-stats\">\n");
for(int ci=0;ci<4;ci++){
out.write("<div class=\"stat\" aria-label=\"");
out.print(cardLabels[ci]);
out.write(": ");
out.print(cardCounts[ci]);
out.write("\"><div class=\"stat-icon\">");
out.print(cardSymbols[ci]);
out.write("</div><div class=\"stat-label\">");
out.print(cardLabels[ci]);
out.write("</div><div class=\"stat-value\">");
out.print(cardCounts[ci]);
out.write("</div><div class=\"stat-sub\">");
out.print(cardNotes[ci]);
out.write("</div></div>");
}
out.write("\n</div>\n<section class=\"card\"><div class=\"card-head\"><div><h2>Search shipments</h2><p class=\"sub\">Use any combination of these server-side filters.</p></div><span class=\"pill\">Role-aware results</span></div><form method=\"get\" action=\"");
out.print(model.Html.escape(uri));
out.write("\" class=\"form-grid\"><input type=\"hidden\" name=\"action\" value=\"search\"/>\n <div class=\"field\"><label for=\"s-container\">Container number</label><input class=\"input\" id=\"s-container\" type=\"search\" name=\"containerNumber\" maxlength=\"15\" placeholder=\"e.g. QABOM00012\" value=\"");
out.print(model.Html.escape(container));
out.write("\"/></div>\n <div class=\"field\"><label for=\"s-id\">Shipment ID</label><input class=\"input\" id=\"s-id\" type=\"number\" min=\"1\" name=\"shipmentId\" placeholder=\"e.g. 20\" value=\"");
out.print(model.Html.escape(shipmentId));
out.write("\"/></div>\n <div class=\"field\"><label for=\"s-port\">Route port</label><select class=\"select\" id=\"s-port\" name=\"portId\"><option value=\"\">All ports</option>");
for(PortPojo p:ports){
out.write("<option value=\"");
out.print(p.getPortId());
out.write("\" ");
out.print(String.valueOf(p.getPortId()).equals(port)?"selected":"");
out.write(">");
out.print(model.Html.escape(p.getPortName()));
out.write("</option>");
}
out.write("</select></div>\n <div class=\"field\"><label for=\"s-status\">Shipment status</label><select class=\"select\" id=\"s-status\" name=\"status\"><option value=\"\">All statuses</option>");
for(String s:ShipmentPojo.STATUSES){
out.write("<option value=\"");
out.print(s);
out.write("\" ");
out.print(s.equals(status)?"selected":"");
out.write(">");
out.print(s.replace('_',' '));
out.write("</option>");
}
out.write("</select></div>\n <div class=\"form-actions\"><button class=\"btn primary\" type=\"submit\">Search shipments</button><a class=\"btn light\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=shipments\">Reset</a></div></form></section>\n");
}else{
out.write("\n<div class=\"bread\"><a href=\"");
out.print(model.Html.escape(uri));
out.write("?action=shipments\">Shipments</a> <span>/</span> <b>Shipment details</b></div>\n<div class=\"page-heading detail-heading\"><div><div class=\"caps\">SHIPMENT OVERVIEW</div><h1>Shipment <span>details</span></h1><p>Read the selected record, inspect tracking events and authorized operations.</p></div><a class=\"btn light\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=shipments\">← Back to shipments</a></div>\n");
}
out.flush(); request.setAttribute("nlv_Module2_shipmentManagement__2", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(selected!=null){
out.write("\n");
if(request.getAttribute("cancellationError")!=null){
out.write("<div class=\"nl-cancel-feedback\" role=\"alert\"><strong>Cancellation unavailable.</strong> ");
out.print(model.Html.escape(request.getAttribute("cancellationError")));
out.write("</div>");
}
out.write("\n");
if(request.getAttribute("notice")!=null){
out.write("<div class=\"alert\" role=\"status\">");
out.print(model.Html.escape(request.getAttribute("notice")));
out.write("</div>");
}
out.write("\n<section class=\"card soft\" id=\"details\"><div class=\"card-head\"><div><div class=\"caps\">SHIPMENT RECORD</div><h2>");
out.print(model.Html.escape(selected.getShipmentNo()));
out.write(" <span class=\"pill ");
out.print(selected.isTerminal()?"gray":"blue");
out.write("\">");
out.print(selected.getStatusLabel());
out.write("</span></h2></div><div class=\"heading-actions\">");
if(!Boolean.TRUE.equals(request.getAttribute("canEdit"))){
out.write("<span class=\"pill gray\" title=\"Shipment movement editing is restricted to the Seller\">");
out.print(cancelEligible.contains(selected.getShipmentId())?"Cancellation permitted":"View only");
out.write("</span>");
}
out.write("<a class=\"btn light\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=timeline&amp;shipmentId=");
out.print(selected.getShipmentId());
out.write("\">View timeline</a>");
if(currentUser!=null&&currentUser.isConsumer()&&("DELIVERED".equalsIgnoreCase(selected.getStatus())||"ARRIVED".equalsIgnoreCase(selected.getStatus()))){
out.write("<a class=\"btn primary\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ClaimController?action=new&amp;shipmentId=");
out.print(selected.getShipmentId());
out.write("\">Raise a claim</a>");
}
if(Boolean.TRUE.equals(request.getAttribute("canEdit"))&&!selected.isTerminal()){
out.write("<a class=\"btn light\" href=\"#nlShipmentSchedule\">Edit schedule</a>");
out.write("<a class=\"btn primary\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=movementUpdate&amp;shipmentId=");
out.print(selected.getShipmentId());
out.write("\">Change status ↗</a>");
}
out.write("</div></div>\n<div class=\"detail-grid\">\n<div class=\"detail-box\"><small>Container</small><strong>");
out.print(model.Html.escape(selected.getContainerNumber()));
out.write("</strong></div><div class=\"detail-box\"><small>Origin → destination</small><strong>");
out.print(model.Html.escape(selected.getOriginPortName()));
out.write(" → ");
out.print(model.Html.escape(selected.getDestPortName()));
out.write("</strong></div><div class=\"detail-box\"><small>Expected departure</small><strong>");
out.print(selected.getEtd()==null?"Not scheduled":selected.getEtd());
out.write("</strong></div><div class=\"detail-box\"><small>Expected arrival</small><strong>");
out.print(selected.getEta()==null?"Not scheduled":selected.getEta());
out.write("</strong></div><div class=\"detail-box\"><small>Actual arrival</small><strong>");
out.print(selected.getActualArrival()==null?"Not yet recorded":selected.getActualArrival());
out.write("</strong></div><div class=\"detail-box\"><small>Quoted price</small><strong>₹");
out.print(selected.getQuotedPrice()==null?"—":selected.getQuotedPrice());
out.write("</strong></div><div class=\"detail-box\"><small>Cargo weight / volume</small><strong>");
out.print(selected.getCargoWeightKg());
out.write(" kg · ");
out.print(selected.getCargoVolumeCbm());
out.write(" CBM</strong></div><div class=\"detail-box\"><small>Cargo description</small><strong>");
out.print(model.Html.escape(selected.getCargoDescription()));
out.write("</strong></div>\n</div>\n");
renderDelayNotice(out,selected);
if(Boolean.TRUE.equals(request.getAttribute("canEdit"))&&!selected.isTerminal()) {
    if(request.getAttribute("scheduleError")!=null)
        out.write("<div class=\"nl-schedule-server-error\" role=\"alert\">"+Html.escape(request.getAttribute("scheduleError"))+"</div>");
    renderShipmentSchedule(out, selected, uri, request.getAttribute("csrfToken"), false);
    renderDelayReportForm(out,selected,uri,request.getAttribute("csrfToken"),false,request.getAttribute("delayError"));
}
out.write("<div class=\"nl-record-more\" aria-label=\"Shipment detailed information\">\n  <section class=\"nl-record-section\" aria-label=\"Parties and booking information\">\n    <div class=\"nl-record-section-heading\"><span class=\"nl-record-section-icon\" aria-hidden=\"true\">01</span><div><h3>Booking and shipping parties</h3><p>Verified booking ownership, carrier allocation and record creation</p></div></div>\n    <div class=\"nl-record-info-grid\">\n      <div><small>Booking Consumer</small><strong>");
out.print(model.Html.escape(selected.getConsumerName()==null?"Not available":selected.getConsumerName()));
out.write("</strong></div>\n      <div><small>Seller organization</small><strong>");
out.print(model.Html.escape(selected.getSellerCompanyName()==null?"Not available":selected.getSellerCompanyName()));
out.write("</strong></div>\n      <div><small>Container type</small><strong>");
out.print(model.Html.escape(selected.getContainerType()==null?"Not recorded":selected.getContainerType()));
out.write("</strong></div>\n      <div><small>Assigned vessel</small><strong>");
out.print(model.Html.escape(selected.getVesselName()==null?"Not yet assigned":selected.getVesselName()));
out.write("</strong></div>\n      <div><small>Booking registered</small><strong>");
out.print(model.Html.escape(selected.getBookedAt()==null?"Not recorded":selected.getBookedAt()));
out.write("</strong></div>\n      <div><small>Booked goods</small><strong>");
out.print(selected.getTotalBookedUnits());
out.write(" units · ");
out.print(selected.getCargoLines().size());
out.write(" line item(s)</strong></div>\n    </div>\n  </section>\n  <section class=\"nl-record-section\" aria-label=\"Goods on shipment\">\n    <div class=\"nl-record-section-heading\"><span class=\"nl-record-section-icon\" aria-hidden=\"true\">02</span><div><h3>Goods in this shipment</h3><p>Original booked quantities and item values are retained if a booking is cancelled</p></div></div>\n    ");
if(selected.getCargoLines().isEmpty()){
out.write("\n      <p class=\"nl-record-muted\">No itemized goods were found for this shipment.</p>\n    ");
}else{
out.write("\n      <div class=\"nl-cargo-table-wrap\"><table class=\"nl-cargo-table\"><thead><tr><th scope=\"col\">Goods / SKU</th><th scope=\"col\">Quantity</th><th scope=\"col\">Weight</th><th scope=\"col\">Volume</th><th scope=\"col\">Goods value</th></tr></thead><tbody>\n      ");
for(ShipmentPojo.CargoLine line:selected.getCargoLines()){
out.write("\n       <tr><td><strong>");
out.print(model.Html.escape(line.getProductName()));
out.write("</strong><small>");
out.print(model.Html.escape(line.getSku()));
out.write("</small></td><td>");
out.print(line.getQuantity());
out.write("</td><td>");
out.print(line.getWeightKg()==null?"—":line.getWeightKg());
out.write(" kg</td><td>");
out.print(line.getVolumeCbm()==null?"—":line.getVolumeCbm());
out.write(" CBM</td><td>₹");
out.print(line.getAmount()==null?"—":line.getAmount());
out.write("</td></tr>\n      ");
}
out.write("\n      </tbody></table></div>\n    ");
}
out.write("\n  </section>\n  <div class=\"nl-record-bottom\">\n    <section class=\"nl-record-section\" aria-label=\"Last recorded movement\">\n      <div class=\"nl-record-section-heading\"><span class=\"nl-record-section-icon\" aria-hidden=\"true\">03</span><div><h3>Latest recorded checkpoint</h3><p>Activity entered by an authorized user, not GPS</p></div></div>\n      <div class=\"nl-record-info-grid compact\">\n        <div><small>Movement status</small><strong>");
out.print(model.Html.escape(selected.getLatestEventStatus()==null?"No recorded event":selected.getLatestEventStatus().replace('_',' ')));
out.write("</strong></div>\n        <div><small>Recorded at</small><strong>");
out.print(model.Html.escape(selected.getLatestEventTime()==null?"Not recorded":selected.getLatestEventTime()));
out.write("</strong></div>\n        <div class=\"nl-wide-info\"><small>Location / event</small><strong>");
out.print(model.Html.escape(selected.getLatestEventLocation()==null?"Not recorded":selected.getLatestEventLocation()));
out.write("</strong></div>\n        <div class=\"nl-wide-info\"><small>Remarks</small><strong>");
out.print(model.Html.escape(selected.getLatestEventRemarks()==null?"No remarks":selected.getLatestEventRemarks()));
out.write("</strong></div>\n      </div>\n    </section>\n    <section class=\"nl-record-section\" aria-label=\"Invoice snapshot\">\n      <div class=\"nl-record-section-heading\"><span class=\"nl-record-section-icon\" aria-hidden=\"true\">04</span><div><h3>Invoice snapshot</h3><p>Linked billing record and historical amount</p></div></div>\n      <div class=\"nl-record-info-grid compact\">\n        <div><small>Invoice reference</small><strong>");
out.print(model.Html.escape(selected.getInvoiceNo()==null?"No invoice found":selected.getInvoiceNo()));
out.write("</strong></div>\n        <div><small>Invoice state</small><strong>");
out.print("CANCELLED".equalsIgnoreCase(selected.getStatus())?"CANCELLED":model.Html.escape(selected.getInvoiceStatus()==null?"Not recorded":selected.getInvoiceStatus()));
out.write("</strong></div>\n        <div><small>Invoice total</small><strong>₹");
out.print(selected.getInvoiceTotal()==null?"—":selected.getInvoiceTotal());
out.write("</strong></div>\n        <div><small>Payments recorded</small><strong>₹");
out.print(selected.getInvoicePaid()==null?"—":selected.getInvoicePaid());
out.write("</strong></div>\n      </div>\n      ");
if("CANCELLED".equalsIgnoreCase(selected.getStatus())){
out.write("<p class=\"nl-record-archive-note\">This booking is cancelled. Invoice details remain for history; further payments are blocked.</p>");
}
out.write("\n    </section>\n  </div>\n</div>\n");
if(currentUser!=null&&cancelEligible.contains(selected.getShipmentId())){
out.write("\n<div class=\"nl-detail-cancel-action\"><button type=\"button\" class=\"btn nl-cancel-trigger\" data-open-cancel=\"cancel-dialog-detail-");
out.print(selected.getShipmentId());
out.write("\" aria-haspopup=\"dialog\">Cancel ");
out.print("LOADED".equals(selected.getStatus())?"shipment":"this booking");
out.write("</button><span>Unpaid ");
out.print(model.Html.escape(selected.getStatus()));
out.write(" shipment · history retained</span></div>\n<div id=\"cancel-dialog-detail-");
out.print(selected.getShipmentId());
out.write("\" class=\"nl-cancel-dialog\" role=\"dialog\" aria-modal=\"true\" tabindex=\"-1\" hidden=\"hidden\" aria-labelledby=\"cancel-heading-detail-");
out.print(selected.getShipmentId());
out.write("\" aria-describedby=\"cancel-explainer-detail-");
out.print(selected.getShipmentId());
out.write("\">\n    <div class=\"nl-cancel-panel\">\n      <div class=\"nl-cancel-top\"><span class=\"nl-cancel-mark\" aria-hidden=\"true\">!</span><div class=\"nl-cancel-title\"><small>BOOKING CANCELLATION</small><h3 id=\"cancel-heading-detail-");
out.print(selected.getShipmentId());
out.write("\">Cancel shipment #");
out.print(selected.getShipmentId());
out.write("?</h3></div><button type=\"button\" class=\"nl-cancel-close\" data-close-cancel aria-label=\"Close cancellation dialog\">&times;</button></div>\n      <p class=\"nl-cancel-explainer\" id=\"cancel-explainer-detail-");
out.print(selected.getShipmentId());
out.write("\">This <strong>");
out.print(model.Html.escape(selected.getStatus()));
out.write("</strong> shipment will be marked cancelled. The database releases its allocated container and returns the reserved goods to available stock.</p>\n      <div class=\"nl-cancel-impact\" aria-label=\"What happens next\"><div><span aria-hidden=\"true\">↩</span><strong>Stock returned</strong><small>Reserved units released</small></div><div><span aria-hidden=\"true\">□</span><strong>Container available</strong><small>Allocation released</small></div><div><span aria-hidden=\"true\">▤</span><strong>History saved</strong><small>Invoice and events retained</small></div></div>\n      <form method=\"post\" action=\"");
out.print(model.Html.escape(uri));
out.write("\" class=\"nl-cancel-form\">\n        <input type=\"hidden\" name=\"action\" value=\"cancelBooking\"/><input type=\"hidden\" name=\"shipmentId\" value=\"");
out.print(selected.getShipmentId());
out.write("\"/><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(request.getAttribute("csrfToken")));
out.write("\"/>\n        <label for=\"cancel-reason-detail-");
out.print(selected.getShipmentId());
out.write("\">Cancellation reason</label>\n        <textarea class=\"input\" id=\"cancel-reason-detail-");
out.print(selected.getShipmentId());
out.write("\" name=\"reason\" rows=\"3\" maxlength=\"255\" required=\"required\" placeholder=\"For example: I entered the wrong delivery destination\"></textarea>\n        <p class=\"nl-cancel-note\">Cancellation is final. The shipment, invoice, stock ledger and movement history are retained for audit.</p>\n        <div class=\"nl-cancel-footer\"><button type=\"button\" class=\"btn light\" data-close-cancel>Keep booking</button><button type=\"submit\" class=\"btn nl-cancel-confirm\">Yes, cancel shipment</button></div>\n      </form>\n    </div>\n    </div>\n");
}
out.write("\n");
if(Boolean.TRUE.equals(request.getAttribute("canEdit"))&&!selected.isTerminal()){
    renderOtherShipmentFields(out,selected,uri,request.getAttribute("csrfToken"),false);
}
out.write("</section>\n");
}
out.flush(); request.setAttribute("nlv_Module2_shipmentManagement__3", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
if(selected==null){
out.write("\n<section class=\"card shipment-records\" id=\"records\">\n  <div class=\"card-head\"><div><h2>Shipment records <span class=\"pill\">");
out.print(total);
out.write(" found</span></h2><p class=\"sub\">Each shipment has its own details, checkpoints and tracking view.</p></div>\n  <span class=\"muted small\">Page ");
out.print(current);
out.write(" of ");
out.print(totalPages);
out.write("</span></div>\n  ");
if(entries.isEmpty()){
out.write("\n    <div class=\"empty\"><strong>No shipments match your filters.</strong> Clear the filters above or try another route.</div>\n  ");
}else{
out.write("\n  <div class=\"shipment-toolbar\">\n    <div class=\"status-tabs\" role=\"group\" aria-label=\"Filter shipments on this page\">\n      <button type=\"button\" class=\"status-tab is-active\" data-status-filter=\"ALL\" aria-pressed=\"true\">All</button>\n      <button type=\"button\" class=\"status-tab\" data-status-filter=\"ACTIVE\" aria-pressed=\"false\">Active</button>\n      <button type=\"button\" class=\"status-tab\" data-status-filter=\"DELIVERED\" aria-pressed=\"false\">Delivered</button>\n      <button type=\"button\" class=\"status-tab\" data-status-filter=\"CANCELLED\" aria-pressed=\"false\">Cancelled</button>\n      <button type=\"button\" class=\"status-tab\" data-status-filter=\"DELAYED\" aria-pressed=\"false\">Delayed</button>\n    </div>\n    <div class=\"records-tools\">\n      <div class=\"nl-local-find\"><label class=\"visually-hidden\" for=\"nlShipmentQuickFind\">Find on this page</label><input class=\"input\" type=\"search\" id=\"nlShipmentQuickFind\" placeholder=\"Find shipment, port or container…\" autocomplete=\"off\" aria-label=\"Search shipments shown on this page\"/></div>\n      <button class=\"btn light small nl-local-clear\" type=\"button\" id=\"nlClearShipmentQuickFind\" hidden=\"hidden\">Clear</button>\n      <label class=\"sort-label\" for=\"shipmentSort\">Sort <select class=\"select\" id=\"shipmentSort\" aria-label=\"Order shipments on this page\">\n        <option value=\"newest\">Newest first</option><option value=\"oldest\">Oldest first</option>\n        <option value=\"eta\">ETA soonest</option><option value=\"status\">Status A–Z</option>\n      </select></label>\n      <span class=\"table-status\" id=\"shipmentCount\" role=\"status\">");
out.print(entries.size());
out.write(" records on this page</span>\n    </div>\n  </div>\n  <p class=\"nl-local-search-note\">Quick search filters this page only. Use <strong>Search shipments</strong> above to search the complete register.</p>\n  <div class=\"shipment-collection\" id=\"shipmentCollection\" role=\"list\" aria-label=\"Shipments\">\n  ");
for(ShipmentPojo s:entries){
out.write("\n    <article id=\"shipment-");
out.print(s.getShipmentId());
out.write("\" class=\"shipment-row\" role=\"listitem\" data-shipment-status=\"");
out.print(model.Html.escape(s.getStatus()));
out.write("\"\n      data-shipment-id=\"");
out.print(s.getShipmentId());
out.write("\" data-eta=\"");
out.print(s.getEta()==null?"9999-12-31":s.getEta());
out.write("\"\n      data-delayed=\"");
out.print(s.hasDelayAlert()?"true":"false");
out.write("\">\n      <div class=\"shipment-reference\" aria-label=\"Shipment identification\">\n        <div class=\"nl-card-heading\"><span class=\"nl-card-id-mark\" aria-hidden=\"true\">▤</span><span>Shipment <strong>#");
out.print(s.getShipmentId());
out.write("</strong></span></div>\n        <div class=\"nl-label\">Shipment reference</div>\n        <div class=\"nl-reference-value\"><strong class=\"mono nl-inline-copy\" role=\"button\" tabindex=\"0\" data-nl-copy-value=\"");
out.print(model.Html.escape(s.getShipmentNo()));
out.write("\" title=\"Click to copy shipment reference\" aria-label=\"Copy shipment reference ");
out.print(model.Html.escape(s.getShipmentNo()));
out.write("\">");
out.print(model.Html.escape(s.getShipmentNo()));
out.write("</strong></div>\n        <div class=\"nl-container-info\"><span class=\"nl-label\">Assigned container</span><div class=\"nl-container-value\">\n          <span class=\"mono nl-inline-copy\" role=\"button\" tabindex=\"0\" data-nl-copy-value=\"");
out.print(model.Html.escape(s.getContainerNumber()));
out.write("\" title=\"Click to copy container number\" aria-label=\"Copy container number ");
out.print(model.Html.escape(s.getContainerNumber()));
out.write("\">");
out.print(model.Html.escape(s.getContainerNumber()));
out.write("</span></div></div>\n        <div class=\"nl-compact-route\" aria-label=\"Shipping route\"><span class=\"nl-compact-origin\"><small>From</small><strong>");
out.print(model.Html.escape(s.getOriginPortName()));
out.write("</strong></span><span class=\"nl-compact-arrow\" aria-hidden=\"true\">→</span><span class=\"nl-compact-destination\"><small>To</small><strong>");
out.print(model.Html.escape(s.getDestPortName()));
out.write("</strong></span></div>\n      </div>\n      <div class=\"shipment-insight\">\n        <div class=\"shipment-summary\">\n          <div class=\"nl-status-head\"><div><div class=\"nl-section-title\">Current progress</div><span class=\"pill ");
out.print(s.isTerminal()?"gray":s.hasDelayAlert()?"bad":"blue");
out.write("\">");
out.print(model.Html.escape(s.getStatusLabel()));
out.write("</span>\n            ");
if(s.hasActiveDelayReport()){
out.write("<span class=\"pill bad\" role=\"status\">Delay reported</span>");
} else if(s.isDelayed()){
out.write("<span class=\"pill bad\">Arrival delayed</span>");
}
out.write("</div>\n            ");
if(s.getProgressStepNumber()>0){
out.write("<span class=\"nl-progress-count\">Step ");
out.print(s.getProgressStepNumber());
out.write(" of 7</span>");
}
out.write("\n          </div>\n          <p class=\"nl-status-description\">");
out.print(model.Html.escape(s.getStatusSummary()));
out.write("</p>");
if(s.hasActiveDelayReport()){
    java.util.Map<String,String> delay=s.getLatestDelayNotice();
    out.write("<div class=\"nl-list-delay-alert\" role=\"status\" aria-label=\"Delay reported by Seller\">"
        +"<div class=\"nl-list-delay-head\"><span class=\"nl-list-delay-icon\" aria-hidden=\"true\">!</span>"
        +"<strong>Seller reported a shipment delay</strong></div>"
        +"<div class=\"nl-list-delay-dates\">Previous ETA: <strong>"+model.Html.escape(delay.get("previous_eta"))
        +"</strong> <span aria-hidden=\"true\">&rarr;</span> Revised ETA: <strong>"
        +model.Html.escape(delay.get("revised_eta"))+"</strong></div>");
    if(delay.get("reason")!=null&&!delay.get("reason").trim().isEmpty()){
        out.write("<p class=\"nl-list-delay-reason\"><b>Reason:</b> "
            +model.Html.escape(delay.get("reason"))+"</p>");
    }
    out.write("</div>");
}
out.write("\n          <div class=\"nl-progress-track\" aria-hidden=\"true\">\n            ");
for(ShipmentPojo.ProgressStep progressStep : s.getProgressSteps()){
out.write("<span class=\"");
out.print(progressStep.isCompleted()?"is-complete":progressStep.isCurrent()?"is-current":"");
out.write("\" title=\"");
out.print(model.Html.escape(progressStep.getLabel()));
out.write("\"></span>");
}
out.write("\n          </div>\n          <div class=\"row-facts\"><span><small>Estimated arrival</small><b>");
out.print(s.getEta()==null?"Awaiting schedule":s.getEta());
out.write("</b></span>\n            <span><small>Shipment quotation</small><b>₹");
out.print(s.getQuotedPrice()==null?"—":new java.text.DecimalFormat("#,##,##0.00").format(s.getQuotedPrice()));
out.write("</b></span></div>\n        </div>\n        <div class=\"shipment-actions\">\n          <a class=\"btn light small\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=shipmentDetails&amp;shipmentId=");
out.print(s.getShipmentId());
out.write("\" aria-label=\"View details for shipment ");
out.print(model.Html.escape(s.getShipmentNo()));
out.write("\">View details</a>\n          ");
if(!"CANCELLED".equalsIgnoreCase(s.getStatus())){
out.write("<a class=\"btn primary small\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=timeline&amp;shipmentId=");
out.print(s.getShipmentId());
out.write("\" aria-label=\"Track shipment ");
out.print(model.Html.escape(s.getShipmentNo()));
out.write("\">Track shipment <span aria-hidden=\"true\">→</span></a>");
}
out.write("\n");
if(currentUser!=null&&currentUser.isConsumer()&&( "DELIVERED".equalsIgnoreCase(s.getStatus())||"ARRIVED".equalsIgnoreCase(s.getStatus()))){
out.write("<a class=\"btn small nl-raise-claim\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ClaimController?action=new&amp;shipmentId=");
out.print(s.getShipmentId());
out.write("\" title=\"Start a claim for this arrived or delivered shipment (subject to the claim filing window)\">Raise a claim</a>");
}
out.write("\n          ");
if(currentUser!=null&&cancelEligible.contains(s.getShipmentId())){
out.write("\n          <button type=\"button\" class=\"btn small nl-cancel-trigger\" data-open-cancel=\"cancel-dialog-");
out.print(s.getShipmentId());
out.write("\" aria-haspopup=\"dialog\">Cancel ");
out.print("LOADED".equals(s.getStatus())?"shipment":"booking");
out.write("</button>\n          <div id=\"cancel-dialog-");
out.print(s.getShipmentId());
out.write("\" class=\"nl-cancel-dialog\" role=\"dialog\" aria-modal=\"true\" tabindex=\"-1\" hidden=\"hidden\" aria-labelledby=\"cancel-heading-");
out.print(s.getShipmentId());
out.write("\" aria-describedby=\"cancel-explainer-");
out.print(s.getShipmentId());
out.write("\">\n    <div class=\"nl-cancel-panel\">\n      <div class=\"nl-cancel-top\"><span class=\"nl-cancel-mark\" aria-hidden=\"true\">!</span><div class=\"nl-cancel-title\"><small>BOOKING CANCELLATION</small><h3 id=\"cancel-heading-");
out.print(s.getShipmentId());
out.write("\">Cancel shipment #");
out.print(s.getShipmentId());
out.write("?</h3></div><button type=\"button\" class=\"nl-cancel-close\" data-close-cancel aria-label=\"Close cancellation dialog\">&times;</button></div>\n      <p class=\"nl-cancel-explainer\" id=\"cancel-explainer-");
out.print(s.getShipmentId());
out.write("\">This <strong>");
out.print(model.Html.escape(s.getStatus()));
out.write("</strong> shipment will be marked cancelled. The database releases its container and restores reserved goods to available stock.</p>\n      <div class=\"nl-cancel-impact\" aria-label=\"What happens next\"><div><span aria-hidden=\"true\">↩</span><strong>Stock returned</strong><small>Reserved units released</small></div><div><span aria-hidden=\"true\">□</span><strong>Container available</strong><small>Allocation released</small></div><div><span aria-hidden=\"true\">▤</span><strong>History saved</strong><small>Invoice and events retained</small></div></div>\n      <form method=\"post\" action=\"");
out.print(model.Html.escape(uri));
out.write("\" class=\"nl-cancel-form\">\n        <input type=\"hidden\" name=\"action\" value=\"cancelBooking\"/><input type=\"hidden\" name=\"shipmentId\" value=\"");
out.print(s.getShipmentId());
out.write("\"/><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(request.getAttribute("csrfToken")));
out.write("\"/>\n        <label for=\"cancel-reason-");
out.print(s.getShipmentId());
out.write("\">Cancellation reason</label>\n        <textarea class=\"input\" id=\"cancel-reason-");
out.print(s.getShipmentId());
out.write("\" name=\"reason\" rows=\"3\" maxlength=\"255\" required=\"required\" placeholder=\"For example: I entered the wrong delivery destination\"></textarea>\n        <p class=\"nl-cancel-note\">Cancellation is final. The shipment, invoice, stock ledger and movement history are retained for audit.</p>\n        <div class=\"nl-cancel-footer\"><button type=\"button\" class=\"btn light\" data-close-cancel>Keep booking</button><button type=\"submit\" class=\"btn nl-cancel-confirm\">Yes, cancel shipment</button></div>\n      </form>\n    </div>\n    </div>\n          ");
}
out.write("\n          ");
if((currentUser!=null&&currentUser.canUpdateShipment(s.getSellerId()))&&!s.isTerminal()){
out.write("\n            <a class=\"btn light small status-action\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=movementUpdate&amp;shipmentId=");
out.print(s.getShipmentId());
out.write("\">Update status</a>\n          ");
}
out.write("\n        </div>\n      </div>\n    </article>\n  ");
}
out.write("\n  </div>\n  <div class=\"empty\" id=\"noLocalRecords\" hidden=\"hidden\">No shipments in this category on this page. Choose All to see every loaded record.</div>\n  ");
}
out.write("\n  ");
if(totalPages>1){
out.write("\n  <nav class=\"records-pagination\" aria-label=\"Shipment pages\"><span class=\"muted small\">Up to 25 records per page</span><div class=\"table-buttons\">\n    ");
if(current>1){
out.write("<a class=\"btn light small\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=search&amp;page=");
out.print(current-1);
out.print(model.Html.escape(filterQuery));
out.write("\">← Previous</a>");
}
out.write("\n    <span class=\"pill\">Page ");
out.print(current);
out.write(" / ");
out.print(totalPages);
out.write("</span>\n    ");
if(current<totalPages){
out.write("<a class=\"btn primary small\" href=\"");
out.print(model.Html.escape(uri));
out.write("?action=search&amp;page=");
out.print(current+1);
out.print(model.Html.escape(filterQuery));
out.write("\">Next page →</a>");
}
out.write("\n  </div></nav>\n  ");
}
out.write("\n</section>\n");
}
out.flush(); request.setAttribute("nlv_Module2_shipmentManagement__4", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module3_booking_result(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    request.setAttribute("pageTitle", "Booking Result");

    Map<String, Object> result =
        model.JspSupport.map(request.getAttribute("bookingResult"));

    String bookingAction = result == null || result.get("bookingAction") == null
        ? "" : result.get("bookingAction").toString();

    boolean confirmed = "CONFIRM".equalsIgnoreCase(bookingAction);

 request.setAttribute("nlActiveModule", "Module3"); request.setAttribute("nlPageTitle", "Quotation review"); 
request.setAttribute("nlv_Module3_booking_result__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(confirmed && result!=null && result.get("shipmentId")!=null){ 
out.write("\n<section class=\"nl-booking-success\" role=\"status\" aria-live=\"polite\">\n <div class=\"nl-confirm-mark\" aria-hidden=\"true\"><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNlNGZhZTkiIHN0cm9rZS13aWR0aD0iMS44NSIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48Y2lyY2xlIGN4PSIxMiIgY3k9IjEyIiByPSI5Ii8+PHBhdGggZD0ibTggMTIgMyAzIDUtNiIvPjwvc3ZnPg==\" width=\"45\" height=\"45\" alt=\"\" aria-hidden=\"true\"></div>\n <div><span class=\"nl-eyebrow\">BOOKING COMPLETED</span><h2 class=\"mb-2\">Shipment successfully booked</h2>\n <p class=\"mb-2\">Your shipment <strong>");
out.print(model.Html.escape(result.get("shipmentNo")));
out.write("</strong> was created and connected to invoice <strong>");
out.print(model.Html.escape(result.get("invoiceNo")));
out.write("</strong>.</p>\n <div class=\"d-flex gap-2 flex-wrap\"><a class=\"btn btn-light\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/containerMovement?action=shipments\">View my shipment</a><a class=\"btn btn-outline-light\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/billing?action=invoices\">Open invoices</a></div></div>\n</section>\n");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking_result__2", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(confirmed && result!=null && result.get("invoiceId")!=null && result.get("shipmentId")!=null){ 
out.write("\n<div class=\"d-flex justify-content-end mb-3\"><button type=\"button\" class=\"btn btn-warning fw-bold px-4\" id=\"nlReopenPayment\" aria-haspopup=\"dialog\">Choose payment option</button></div>\n<section class=\"nl-nextstep-panel mb-4\" id=\"payment-options\" role=\"dialog\" aria-modal=\"true\" tabindex=\"-1\" aria-labelledby=\"nlNextPaymentTitle\" aria-describedby=\"nlNextPaymentDesc\" hidden=\"hidden\">\n  <div class=\"d-flex justify-content-end\"><button type=\"button\" id=\"nlDismissPayment\" class=\"btn btn-outline-secondary btn-sm\" aria-label=\"Close payment choices\">Close ×</button></div>\n  <div class=\"d-flex align-items-start justify-content-between flex-wrap gap-3 mb-3\">\n    <div><span class=\"nl-next-eyebrow\">STEP 6 · PAYMENT ARRANGEMENT</span>\n      <h2 class=\"h4 mb-1\" id=\"nlNextPaymentTitle\">Your shipment is booked. How would you like to pay?</h2>\n      <p class=\"mb-0 text-secondary\" id=\"nlNextPaymentDesc\">Invoice <strong>");
out.print(model.Html.escape(result.get("invoiceNo")));
out.write("</strong> was generated automatically for this booking. Choose how to continue.</p></div>\n    <span class=\"badge text-bg-light border p-2\">Booking confirmed</span>\n  </div>\n  <div class=\"nl-next-total mb-3\"><span>Confirmed amount due</span><strong>INR ");
out.print(model.Html.escape(result.get("quotationTotal")));
out.write("</strong>\n    <small>Use the linked invoice for the authoritative balance and tax breakdown.</small></div>\n  <div class=\"nl-next-options\">\n    <a class=\"nl-next-choice\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/billing?action=details&amp;invoice=");
out.print(model.Html.escape(result.get("invoiceId")));
out.write("&amp;payMode=FULL#record-payment\">\n      <span class=\"nl-next-icon\">01</span><strong>Full payment</strong><span>Record the complete outstanding amount in one step.</span><b>Continue to full payment →</b>\n    </a>\n    <a class=\"nl-next-choice\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/billing?action=details&amp;invoice=");
out.print(model.Html.escape(result.get("invoiceId")));
out.write("&amp;payMode=PARTIAL#record-payment\">\n      <span class=\"nl-next-icon\">02</span><strong>Partial payment</strong><span>Record part now. The balance stays payable later.</span><b>Choose an amount →</b>\n    </a>\n  </div>\n  <p class=\"small text-secondary mt-3 mb-0\">N-LOGISTIC records payments that have already been made. These choices do not transfer money or charge your account.</p>\n</section>\n");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking_result__3", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_booking_result__4", String.valueOf(model.Html.escape(confirmed?"active":"")));
request.setAttribute("nlv_Module3_booking_result__5", String.valueOf(model.Html.escape(confirmed?"✓":"5.")));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (result == null) { 
out.write("\n\n                <div class=\"card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle\">\n                    <div class=\"card-body text-center py-5 p-4\">\n                        \n                        <h5 class=\"fw-bold mt-3\">No Booking Result Found</h5>\n                        <p class=\"text-secondary\">\n                            Please create a booking first.\n                        </p>\n\n                        <a href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ContainerAllocationPricingController?module=booking\"\n                           class=\"btn btn-warning bg-gradient\">\n                            Create Booking\n                        </a>\n                    </div>\n                </div>\n\n            ");
 } else { 
out.write("\n\n                <!-- STATUS -->\n                <div class=\"card shadow-sm p-3 mb-3 border-0 rounded-4 mb-4 border-warning-subtle\">\n                    <div class=\"card-body p-4\">\n\n                        <div class=\"d-flex align-items-center gap-3\">\n\n                            <div class=\"rounded-circle p-3\n                                ");
out.print(model.Html.escape(confirmed ? "bg-success-subtle text-success" : "bg-warning-subtle text-warning"));
out.write("\">\n                                <img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIzMSIgaGVpZ2h0PSIzMSIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9ImN1cnJlbnRDb2xvciIgc3Ryb2tlLXdpZHRoPSIxLjkiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCIgYXJpYS1oaWRkZW49InRydWUiPjxjaXJjbGUgY3g9IjEyIiBjeT0iMTIiIHI9IjkiLz48cGF0aCBkPSJtOCAxMiAzIDMgNS02Ii8+PC9zdmc+\" width=\"31\" height=\"31\" alt=\"\" aria-hidden=\"true\">\n                            </div>\n\n                            <div>\n                                <h5 class=\"fw-bold mb-1\">\n                                    ");
out.print(model.Html.escape(confirmed ? "Booking Confirmed" : "Quotation ready for confirmation"));
out.write("\n                                </h5>\n\n                                <p class=\"text-secondary mb-0\">\n                                    ");
out.print(model.Html.escape(confirmed
                                        ? "Your booking has been processed successfully."
                                        : "Your freight quotation is ready for review."));
out.write("\n                                </p>\n                            </div>\n\n                            <span class=\"badge ms-auto\n                                ");
out.print(model.Html.escape(confirmed ? "bg-success" : "bg-warning text-dark"));
out.write("\">\n                                ");
out.print(model.Html.escape(bookingAction));
out.write("\n                            </span>\n\n                        </div>\n                    </div>\n                </div>\n\n                ");
 if(!confirmed && result!=null) { 
out.write("\n                <div class=\"nl-quote-guide\" aria-label=\"Quotation workflow\"><span class=\"nl-quote-step-done\">✓ Goods and route checked</span><span class=\"nl-quote-guide-arrow\">→</span><span class=\"nl-quote-step-current\">2 · Review quotation</span><span class=\"nl-quote-guide-arrow\">→</span><span>3 · Confirm booking</span></div>\n                ");
 } 
out.write("\n                <!-- BOOKING INFORMATION -->\n                <div class=\"card shadow-sm p-3 mb-3 border-0 rounded-4 mb-4 border-warning-subtle\">\n                    <div class=\"card-body p-4\">\n\n                        <h5 class=\"fw-bold mb-3\">Your shipment summary</h5>\n\n                        <div class=\"row g-3\">\n\n                            <div class=\"col-md-4\">\n                                <small class=\"text-secondary\">Selected container</small>\n                                <h6 class=\"fw-semibold\">");
out.print(model.Html.escape(result.get("containerNumber")));
out.write("</h6>\n                            </div>\n\n                            <div class=\"col-md-4\">\n                                <small class=\"text-secondary\">Container Type</small>\n                                <h6 class=\"fw-semibold\">\n                                    ");
out.print(model.Html.escape(result.get("containerType")));
out.write("\n                                </h6>\n                            </div>\n\n                            ");
 if (confirmed) { 
out.write("\n\n\n\n                                <div class=\"col-md-4\">\n                                    <small class=\"text-secondary\">Shipment Number</small>\n                                    <h6 class=\"fw-semibold\">\n                                        ");
out.print(model.Html.escape(result.get("shipmentNo")));
out.write("\n                                    </h6>\n                                </div>\n\n                                <div class=\"col-md-4\">\n                                    <small class=\"text-secondary\">Shipment Status</small>\n                                    <h6 class=\"fw-semibold\">\n                                        ");
out.print(model.Html.escape(result.get("shipmentStatus")));
out.write("\n                                    </h6>\n                                </div>\n\n\n\n                                <div class=\"col-md-4\">\n                                    <small class=\"text-secondary\">Invoice Number</small>\n                                    <h6 class=\"fw-semibold\">\n                                        ");
out.print(model.Html.escape(result.get("invoiceNo")));
out.write("\n                                    </h6>\n                                </div>\n\n                            ");
 } 
out.write("\n\n                        </div>\n                    </div>\n                </div>\n\n                <section class=\"card p-4 mb-4 border-0 shadow-sm rounded-4 border-warning-subtle\" aria-label=\"Container availability\">\n                  <h2 class=\"h5\">Container availability and capacity</h2>\n                  <p class=\"text-muted\">Values returned from the selected database container. Availability is checked again when you confirm.</p>\n                  <div class=\"row g-3\"><div class=\"col-sm-6 col-lg-3\"><small>Container</small><div class=\"fw-semibold\">");
out.print(model.Html.escape(result.get("containerNumber")));
out.write("</div></div>\n                  <div class=\"col-sm-6 col-lg-3\"><small>Status at quote</small><div class=\"fw-semibold\">");
out.print(model.Html.escape(result.get("containerAvailability")));
out.write("</div></div>\n                  <div class=\"col-sm-6 col-lg-3\"><small>Maximum weight</small><div class=\"fw-semibold\">");
out.print(model.Html.escape(result.get("maxWeightKg")));
out.write(" kg</div></div>\n                  <div class=\"col-sm-6 col-lg-3\"><small>Maximum volume</small><div class=\"fw-semibold\">");
out.print(model.Html.escape(result.get("maxVolumeCbm")));
out.write(" CBM</div></div></div>\n                </section>\n\n                <!-- CARGO INFORMATION -->\n                <div class=\"card shadow-sm p-3 mb-3 border-0 rounded-4 mb-4 border-warning-subtle\">\n                    <div class=\"card-body p-4\">\n\n                        <h5 class=\"fw-bold mb-3\">Cargo Information</h5>\n\n                        <div class=\"row g-3\">\n\n                            <div class=\"col-md-4\">\n                                <small class=\"text-secondary\">Cargo Weight</small>\n                                <h6 class=\"fw-semibold\">\n                                    ");
out.print(model.Html.escape(result.get("cargoWeightKg")));
out.write(" KG\n                                </h6>\n                            </div>\n\n                            <div class=\"col-md-4\">\n                                <small class=\"text-secondary\">Cargo Volume</small>\n                                <h6 class=\"fw-semibold\">\n                                    ");
out.print(model.Html.escape(result.get("cargoVolumeCbm")));
out.write(" CBM\n                                </h6>\n                            </div>\n\n                            <div class=\"col-md-4\">\n                                <small class=\"text-secondary\">Goods Value</small>\n                                <h6 class=\"fw-semibold\">\n                                    Rs. ");
out.print(model.Html.escape(result.get("goodsValue")));
out.write("\n                                </h6>\n                            </div>\n\n                        </div>\n                    </div>\n                </div>\n\n                <!-- PRICE BREAKDOWN -->\n                <div class=\"card shadow-sm p-3 mb-3 border-0 rounded-4 mb-4 border-warning-subtle\">\n                    <div class=\"card-body p-4\">\n\n                        <h5 class=\"fw-bold mb-3\">Your quotation</h5>\n\n                        <div class=\"table-responsive rounded-3\">\n                            <table class=\"table table-hover align-middle table-striped\">\n\n                                <tbody>\n\n                                    <tr>\n                                        <td class=\"text-secondary\">Freight Amount</td>\n                                        <td class=\"text-end fw-semibold\">\n                                            Rs. ");
out.print(model.Html.escape(result.get("freightAmount")));
out.write("\n                                        </td>\n                                    </tr>\n\n                                    <tr>\n                                        <td class=\"text-secondary\">Handling Amount</td>\n                                        <td class=\"text-end fw-semibold\">\n                                            Rs. ");
out.print(model.Html.escape(result.get("handlingAmount")));
out.write("\n                                        </td>\n                                    </tr>\n\n                                    <tr>\n                                        <td class=\"text-secondary\">Tax Amount</td>\n                                        <td class=\"text-end fw-semibold\">\n                                            Rs. ");
out.print(model.Html.escape(result.get("taxAmount")));
out.write("\n                                        </td>\n                                    </tr>\n\n                                    <tr class=\"table-warning\">\n                                        <td class=\"fw-bold\">Quotation Total</td>\n                                        <td class=\"text-end fw-bold fs-5\">\n                                            Rs. ");
out.print(model.Html.escape(result.get("quotationTotal")));
out.write("\n                                        </td>\n                                    </tr>\n\n                                </tbody>\n                            </table>\n                        </div>\n\n                    </div>\n                </div>\n\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking_result__6", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(result!=null && confirmed && result.get("shipmentId")!=null){ 
out.write("\n            <section class=\"card p-4 mb-4 border-0 shadow-sm rounded-4 border-warning-subtle\" aria-label=\"Continue your shipment journey\">\n                <h2 class=\"h5 mb-2\">Your booking is connected</h2>\n                <p class=\"text-secondary\">These links open the records created by your confirmed booking. Each module verifies access again.</p>\n                <div class=\"d-flex gap-2 flex-wrap\">\n                    <a class=\"btn btn-warning bg-gradient\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/containerMovement?action=shipmentDetails&amp;shipmentId=");
out.print(model.Html.escape(result.get("shipmentId")));
out.write("\">Shipment details</a>\n                    <a class=\"btn btn-outline-dark\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/containerMovement?action=timeline&amp;shipmentId=");
out.print(model.Html.escape(result.get("shipmentId")));
out.write("\">Track journey</a>\n                    <a class=\"btn btn-outline-dark\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/billing?action=shipmentInvoice&amp;shipmentId=");
out.print(model.Html.escape(result.get("shipmentId")));
out.write("\">View invoice</a>\n                    <a class=\"btn btn-outline-secondary\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ClaimController?action=list\">My claims</a>\n                </div>\n            </section>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking_result__7", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(result!=null && !confirmed && request.getAttribute("bookingQuoteToken")!=null) { 
out.write("\n            ");
out.write("\n            <form id=\"nlEditBooking\" method=\"get\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ContainerAllocationPricingController\">\n                <input type=\"hidden\" name=\"module\" value=\"booking\">\n                ");
 for(String key : new String[]{"originPortId","destPortId","bookingDate","dueDate"}) { 
out.write("\n                  <input type=\"hidden\" name=\"");
out.print(model.Html.escape(key));
out.write("\" value=\"");
out.print(model.Html.escape(request.getParameter(key)));
out.write("\">\n                ");
 } 
out.write("\n                ");
 for(String key : new String[]{"productId","quantity","unitCbm"}) {
                     String[] values=request.getParameterValues(key);
                     if(values!=null)for(String item:values){ 
out.write("\n                  <input type=\"hidden\" name=\"");
out.print(model.Html.escape(key));
out.write("\" value=\"");
out.print(model.Html.escape(item));
out.write("\">\n                ");
 }} 
out.write("\n            </form>\n            <section class=\"card p-4 mb-4 border-0 shadow-sm rounded-4 border-warning-subtle nl-final-confirm\" aria-label=\"Confirm booking\">\n              <div class=\"d-flex flex-wrap justify-content-between align-items-start gap-2 mb-2\"><div><h2 class=\"h5\">Final confirmation</h2><p>Confirm the route and quoted charges above. We recheck stock, container capacity and active pricing at confirmation; no booking is created until you confirm.</p></div></div>\n              <form method=\"post\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ContainerAllocationPricingController\" data-nl-confirm=\"Confirm booking at the displayed quoted rates? This creates a shipment and invoice.\">\n                <input type=\"hidden\" name=\"module\" value=\"booking\"><input type=\"hidden\" name=\"action\" value=\"confirm\">\n                <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\">\n                <input type=\"hidden\" name=\"quoteToken\" value=\"");
out.print(model.Html.escape(request.getAttribute("bookingQuoteToken")));
out.write("\">\n                ");
 for(String key:new String[]{"originPortId","destPortId","bookingDate","dueDate"}) { 
out.write("\n                  <input type=\"hidden\" name=\"");
out.print(model.Html.escape(key));
out.write("\" value=\"");
out.print(model.Html.escape(request.getParameter(key)));
out.write("\">\n                ");
 } 
out.write("\n                ");
 for(String key:new String[]{"productId","quantity","unitCbm"}) {
                     String[] values=request.getParameterValues(key);
                     if(values!=null)for(String item:values){ 
out.write("\n                     <input type=\"hidden\" name=\"");
out.print(model.Html.escape(key));
out.write("\" value=\"");
out.print(model.Html.escape(item));
out.write("\">\n                ");
 }} 
out.write("\n                <button class=\"btn btn-warning bg-gradient nl-booking-primary-action\" type=\"submit\">Confirm booking and create shipment <span aria-hidden=\"true\">→</span></button>\n                <button type=\"submit\" form=\"nlEditBooking\" class=\"btn btn-outline-secondary nl-booking-secondary-action\">← Edit goods or route</button>\n              </form>\n            </section>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking_result__8", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module3_booking(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    request.setAttribute("pageTitle", "Create Booking");

    String today = LocalDate.now().toString();

 request.setAttribute("nlActiveModule", "Module3"); request.setAttribute("nlPageTitle", "Create booking"); 
request.setAttribute("nlv_Module3_booking__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(request.getParameter("productId")!=null && !request.getParameter("productId").isEmpty()) { 
out.write("\n              <div class=\"nl-resumed-booking\" role=\"status\"><span class=\"nl-resumed-dot\">✓</span><div><strong>Your quotation details are restored</strong><p class=\"mb-0\">Adjust your goods, quantity or route below. Recalculate the quotation to confirm the updated price.</p></div></div>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking__2", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(request.getAttribute("bookingError")!=null){ 
out.write("\n              <div class=\"alert alert-danger nl-booking-error\" role=\"alert\"><strong>Booking could not be completed.</strong><div class=\"mt-1\">");
out.print(model.Html.escape(request.getAttribute("bookingError")));
out.write("</div><p class=\"mb-0 mt-2 small\">Check that the route has an active pricing rule, the Seller has sufficient available stock, and a container can carry the total weight and volume. You can reduce quantity or choose another route, then request a new quotation.</p></div>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking__3", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_booking__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module3_booking__5", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> row:model.JspSupport.maps(request.getAttribute("directoryProducts"))){String selection=String.valueOf(row.get("id")); 
out.write("<option value=\"");
out.print(model.Html.escape(selection));
out.write("\" data-stock=\"");
out.print(model.Html.escape(row.get("available")));
out.write("\" data-weight=\"");
out.print(model.Html.escape(row.get("unitWeightKg")));
out.write("\" data-unit-cbm=\"");
out.print(model.Html.escape(row.get("historicalUnitCbm")));
out.write("\" data-samples=\"");
out.print(model.Html.escape(row.get("historySamples")));
out.write("\" ");
out.print(selection.equals(request.getParameter("productId"))?"selected":"");
out.write(">");
out.print(model.Html.escape(row.get("label")));
out.write(" · ");
out.print(model.Html.escape(row.get("available")));
out.write(" available</option>");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking__6", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_booking__7", String.valueOf(model.Html.escape(request.getParameter("quantity"))));
request.setAttribute("nlv_Module3_booking__8", String.valueOf(model.Html.escape(request.getParameter("unitCbm"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> row:model.JspSupport.maps(request.getAttribute("directoryPorts"))){String selection=String.valueOf(row.get("id")); 
out.write("<option value=\"");
out.print(model.Html.escape(selection));
out.write("\" ");
out.print(selection.equals(request.getParameter("originPortId"))?"selected":"");
out.write(">");
out.print(model.Html.escape(row.get("label")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking__9", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> row:model.JspSupport.maps(request.getAttribute("directoryPorts"))){String selection=String.valueOf(row.get("id")); 
out.write("<option value=\"");
out.print(model.Html.escape(selection));
out.write("\" ");
out.print(selection.equals(request.getParameter("destPortId"))?"selected":"");
out.write(">");
out.print(model.Html.escape(row.get("label")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module3_booking__10", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_booking__11", String.valueOf(model.Html.escape(request.getParameter("bookingDate")==null?today:request.getParameter("bookingDate"))));
request.setAttribute("nlv_Module3_booking__12", String.valueOf(model.Html.escape(request.getParameter("dueDate"))));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module3_containers(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    List<Container> containers =
        model.JspSupport.typed(request.getAttribute("containers"), Container.class);

    String message = (String) request.getAttribute("message");
    String errorMessage = (String) request.getAttribute("errorMessage");
    Map<String,String> nlPortLabels = new HashMap<String,String>();
    for(Map<String,Object> portRow:model.JspSupport.maps(request.getAttribute("directoryPorts"))){
        nlPortLabels.put(String.valueOf(portRow.get("id")), String.valueOf(portRow.get("label")));
    }

    request.setAttribute("pageTitle", "Container Directory");

 request.setAttribute("nlActiveModule", "Module3"); request.setAttribute("nlPageTitle", "Containers"); 
request.setAttribute("nlv_Module3_containers__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (message != null) { 
out.write("\n                <div class=\"alert alert-success alert-dismissible fade show\">\n                    \n                    ");
out.print(model.Html.escape(message));
out.write("\n\n                    <button type=\"button\" class=\"btn-close\"\n                            data-bs-dismiss=\"alert\"></button>\n                </div>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_containers__2", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (errorMessage != null) { 
out.write("\n                <div class=\"alert alert-danger alert-dismissible fade show\">\n                    \n                    ");
out.print(model.Html.escape(errorMessage));
out.write("\n\n                    <button type=\"button\" class=\"btn-close\"\n                            data-bs-dismiss=\"alert\"></button>\n                </div>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_containers__3", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_containers__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module3_containers__5", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> item:model.JspSupport.maps(request.getAttribute("directoryPorts"))){ 
out.write("<option value=\"");
out.print(model.Html.escape(item.get("id")));
out.write("\">");
out.print(model.Html.escape(item.get("label")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module3_containers__6", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_containers__7", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module3_containers__8", String.valueOf(model.Html.escape(request.getParameter("q"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String st:new String[]{"AVAILABLE","ALLOCATED","IN_TRANSIT","MAINTENANCE"}){ 
out.write("<option value=\"");
out.print(st);
out.write("\" ");
out.print(st.equals(request.getParameter("status"))?"selected":"");
out.write(">");
out.print(st);
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module3_containers__9", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_containers__10", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module3_containers__11", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(Container listed:containers){ 
out.write("\n    <option value=\"");
out.print(listed.getContainerId());
out.write("\">");
out.print(model.Html.escape(listed.getContainerNumber()));
out.write(" &middot; ");
out.print(model.Html.escape(listed.getContainerType()));
out.write(" &middot; ");
out.print(model.Html.escape(listed.getStatus()));
out.write("</option>\n  ");
 } 
out.flush(); request.setAttribute("nlv_Module3_containers__12", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(Map<String,Object> pRow:model.JspSupport.maps(request.getAttribute("directoryPorts"))){ 
out.write("\n                                    <option value=\"");
out.print(model.Html.escape(pRow.get("id")));
out.write("\">");
out.print(model.Html.escape(pRow.get("label")));
out.write("</option>\n                                    ");
 } 
out.flush(); request.setAttribute("nlv_Module3_containers__13", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_containers__14", String.valueOf(model.Html.escape(containers == null ? 0 : containers.size())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (containers != null && !containers.isEmpty()) { 
out.write("\n\n                                    ");
 for (Container c : containers) { 
out.write("\n\n                                        <tr data-container-id=\"");
out.print(c.getContainerId());
out.write("\" data-container-number=\"");
out.print(model.Html.escape(c.getContainerNumber()));
out.write("\" data-container-type=\"");
out.print(model.Html.escape(c.getContainerType()));
out.write("\" data-size-ft=\"");
out.print(model.Html.escape(c.getSizeFt()));
out.write("\" data-max-weight=\"");
out.print(model.Html.escape(c.getMaxWeightKg()));
out.write("\" data-max-volume=\"");
out.print(model.Html.escape(c.getMaxVolumeCbm()));
out.write("\" data-port-id=\"");
out.print(model.Html.escape(c.getCurrentPortId()));
out.write("\" data-container-status=\"");
out.print(model.Html.escape(c.getStatus()));
out.write("\">\n\n                                            <td>\n                                                <div class=\"fw-semibold\">\n                                                    ");
out.print(model.Html.escape(c.getContainerNumber()));
out.write("\n                                                </div>\n\n                                                <small class=\"text-secondary\">\n                                                    ID: ");
out.print(model.Html.escape(c.getContainerId()));
out.write("\n                                                </small>\n                                            </td>\n\n                                            <td>\n                                                <span class=\"badge bg-info-subtle text-dark\">\n                                                    ");
out.print(model.Html.escape(c.getContainerType()));
out.write("\n                                                </span>\n                                            </td>\n\n                                            <td>\n                                                ");
out.print(model.Html.escape(c.getSizeFt()));
out.write(" FT\n                                            </td>\n\n                                            <td>\n                                                ");
out.print(model.Html.escape(c.getMaxWeightKg()));
out.write(" KG\n                                            </td>\n\n                                            <td>\n                                                ");
out.print(model.Html.escape(c.getMaxVolumeCbm()));
out.write(" CBM\n                                            </td>\n\n                                            <td>\n                                                ");
out.print(model.Html.escape(nlPortLabels.getOrDefault(String.valueOf(c.getCurrentPortId()),"Port #"+c.getCurrentPortId())));
out.write("\n                                            </td>\n\n                                            <td>\n                                                ");
 if ("AVAILABLE".equalsIgnoreCase(c.getStatus())) { 
out.write("\n\n                                                    <span class=\"badge bg-success-subtle text-success\">\n                                                        AVAILABLE\n                                                    </span>\n\n                                                ");
 } else if ("MAINTENANCE".equalsIgnoreCase(c.getStatus())) { 
out.write("\n\n                                                    <span class=\"badge bg-warning-subtle text-warning\">\n                                                        MAINTENANCE\n                                                    </span>\n\n                                                ");
 } else { 
out.write("\n\n                                                    <span class=\"badge bg-secondary-subtle text-secondary\">\n                                                        ");
out.print(model.Html.escape(c.getStatus()));
out.write("\n                                                    </span>\n\n                                                ");
 } 
out.write("\n                                            </td>\n                                            <td class=\"text-end\"><div class=\"d-inline-flex align-items-center gap-2 flex-wrap justify-content-end\"><button type=\"button\" class=\"btn btn-outline-warning btn-sm nl-container-edit\" data-container-id=\"");
out.print(c.getContainerId());
out.write("\" aria-label=\"Edit ");
out.print(model.Html.escape(c.getContainerNumber()));
out.write("\">Edit</button>\n");
 if(("AVAILABLE".equalsIgnoreCase(c.getStatus())||"MAINTENANCE".equalsIgnoreCase(c.getStatus())) && !c.hasShipmentHistory()){ 
out.write("\n<form method=\"post\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ContainerAllocationPricingController\" class=\"d-inline\" data-nl-site-confirm=\"Permanently delete container ");
out.print(model.Html.escape(c.getContainerNumber()));
out.write("? This is possible only when no shipment references it.\" data-nl-confirm-title=\"Delete unused container\">\n<input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\"><input type=\"hidden\" name=\"module\" value=\"container\"><input type=\"hidden\" name=\"action\" value=\"delete\"><input type=\"hidden\" name=\"containerId\" value=\"");
out.print(c.getContainerId());
out.write("\"><button type=\"submit\" class=\"btn btn-outline-danger btn-sm\">Delete</button></form>");
 } else { 
out.write("<span class=\"small text-secondary\" title=\"Cannot delete: only unused Available or Maintenance containers can be removed\">Deletion protected</span>");
 } 
out.write("</div></td>\n                                        </tr>\n\n                                    ");
 } 
out.write("\n\n                                ");
 } else { 
out.write("\n\n                                    <tr>\n                                        <td colspan=\"8\" class=\"text-center py-5\">\n\n                                            \n\n                                            <h6 class=\"fw-bold mt-3\">\n                                                No Containers Found\n                                            </h6>\n\n                                            <p class=\"text-secondary small mb-0\">\n                                                Add your first container to get started.\n                                            </p>\n\n                                        </td>\n                                    </tr>\n\n                                ");
 } 
out.flush(); request.setAttribute("nlv_Module3_containers__15", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module3_pricing_audit(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    List<Map<String, Object>> pricingAudit =
        model.JspSupport.maps(request.getAttribute("pricingAudit"));

    Object ruleIdValue = request.getAttribute("ruleId");

 request.setAttribute("nlActiveModule", "Module3"); request.setAttribute("nlPageTitle", "Pricing audit"); 
request.setAttribute("nlv_Module3_pricing_audit__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));

                request.setAttribute("pageTitle", "Pricing Audit History");
            
request.setAttribute("nlv_Module3_pricing_audit__2", String.valueOf(model.Html.escape(pricingAudit == null ? 0 : pricingAudit.size())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (pricingAudit != null && !pricingAudit.isEmpty()) { 
out.write("\n\n                                ");
 for (Map<String, Object> audit : pricingAudit) { 
out.write("\n\n                                    <tr>\n                                        <td class=\"fw-semibold\">\n                                            ");
out.print(model.Html.escape(audit.get("audit_id")));
out.write("\n                                        </td>\n\n                                        <td>\n                                            #");
out.print(model.Html.escape(audit.get("rule_id")));
out.write("\n                                        </td>\n\n                                        <td>\n                                            ");
out.print(model.Html.escape(audit.get("old_rate") == null
                                                ? "—" : audit.get("old_rate")));
out.write("\n                                        </td>\n\n                                        <td class=\"fw-semibold text-success\">\n                                            ");
out.print(model.Html.escape(audit.get("new_rate") == null
                                                ? "—" : audit.get("new_rate")));
out.write("\n                                        </td>\n\n                                        <td>\n                                            ");
out.print(model.Html.escape(audit.get("old_multiplier") == null
                                                ? "—" : audit.get("old_multiplier")));
out.write("\n                                        </td>\n\n                                        <td>\n                                            ");
out.print(model.Html.escape(audit.get("new_multiplier") == null
                                                ? "—" : audit.get("new_multiplier")));
out.write("\n                                        </td>\n\n                                        <td>\n                                            ");
out.print(model.Html.escape(audit.get("changed_by_name") == null
                                                ? "Unknown" : audit.get("changed_by_name")));
out.write("\n                                        </td>\n\n                                        <td>\n                                            <small class=\"text-secondary\">\n                                                ");
out.print(model.Html.escape(audit.get("changed_at") == null
                                                    ? "—" : audit.get("changed_at")));
out.write("\n                                            </small>\n                                        </td>\n                                    </tr>\n\n                                ");
 } 
out.write("\n\n                            ");
 } else { 
out.write("\n\n                                <tr>\n                                    <td colspan=\"8\" class=\"text-center py-5\">\n                                        \n                                        <h6 class=\"fw-semibold mt-3\">No Audit Records Found</h6>\n                                        <p class=\"text-secondary mb-0\">\n                                            Pricing changes will appear here.\n                                        </p>\n                                    </td>\n                                </tr>\n\n                            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_pricing_audit__3", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module3_pricing(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    List<Map<String, Object>> pricingRules =
        model.JspSupport.maps(request.getAttribute("pricingRules"));

    String message = (String) request.getAttribute("message");
    String errorMessage = (String) request.getAttribute("errorMessage");

    request.setAttribute("pageTitle", "Pricing Rules");

 request.setAttribute("nlActiveModule", "Module3"); request.setAttribute("nlPageTitle", "Pricing rules"); 
request.setAttribute("nlv_Module3_pricing__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
request.setAttribute("nlv_Module3_pricing__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module3_pricing__3", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
request.setAttribute("nlv_Module3_pricing__4", String.valueOf(model.Html.escape(request.getParameter("q"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (message != null) { 
out.write("\n                <div class=\"alert alert-success alert-dismissible fade show\">\n                    \n                    ");
out.print(model.Html.escape(message));
out.write("\n                    <button type=\"button\" class=\"btn-close\"\n                            data-bs-dismiss=\"alert\"></button>\n                </div>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_pricing__5", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (errorMessage != null) { 
out.write("\n                <div class=\"alert alert-danger alert-dismissible fade show\">\n                    \n                    ");
out.print(model.Html.escape(errorMessage));
out.write("\n                    <button type=\"button\" class=\"btn-close\"\n                            data-bs-dismiss=\"alert\"></button>\n                </div>\n            ");
 } 
out.flush(); request.setAttribute("nlv_Module3_pricing__6", nlvString.toString());out=null;nlvString=null;
// Refill rejected pricing form values without using JSP scriptlets.
for(String name:new String[]{"originPortId","destPortId","containerType","baseRate","ratePerKg",
        "ratePerCbm","seasonMultiplier","demandMultiplier","validFrom","validTo"}) {
    request.setAttribute("nlv_Module3_pricing_retry_"+name,
        model.Html.escape(Boolean.TRUE.equals(request.getAttribute("pricingCreateFailed"))
            ?request.getParameter(name):""));
}
request.setAttribute("nlv_Module3_pricing__7", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module3_pricing__8", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> item:model.JspSupport.maps(request.getAttribute("directoryPorts"))){ 
out.write("<option value=\"");
out.print(model.Html.escape(item.get("id")));
out.write("\">");
out.print(model.Html.escape(item.get("label")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module3_pricing__9", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> item:model.JspSupport.maps(request.getAttribute("directoryPorts"))){ 
out.write("<option value=\"");
out.print(model.Html.escape(item.get("id")));
out.write("\">");
out.print(model.Html.escape(item.get("label")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module3_pricing__10", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_pricing__11", String.valueOf(model.Html.escape(pricingRules == null ? 0 : pricingRules.size())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (pricingRules != null && !pricingRules.isEmpty()) { 
out.write("\n\n                                    ");
 for (Map<String, Object> rule : pricingRules) { 
out.write("\n\n                                        <tr data-nl-pricing-rule-id=\"");
out.print(model.Html.escape(rule.get("rule_id")));
out.write("\" data-nl-pricing-origin-id=\"");
out.print(model.Html.escape(rule.get("origin_port_id")));
out.write("\" data-nl-pricing-dest-id=\"");
out.print(model.Html.escape(rule.get("dest_port_id")));
out.write("\" data-nl-pricing-container-type=\"");
out.print(model.Html.escape(rule.get("container_type")));
out.write("\" data-nl-pricing-active=\"");
out.print(model.Html.escape(rule.get("is_active")));
out.write("\" data-nl-pricing-valid-from=\"");
out.print(model.Html.escape(rule.get("valid_from") == null ? "" : rule.get("valid_from")));
out.write("\" data-nl-pricing-valid-to=\"");
out.print(model.Html.escape(rule.get("valid_to") == null ? "" : rule.get("valid_to")));
out.write("\">\n\n                                            <td class=\"fw-semibold\">\n                                                #");
out.print(model.Html.escape(rule.get("rule_id")));
out.write("\n                                            </td>\n\n                                            <td>\n                                                <div class=\"fw-semibold\">\n                                                    ");
out.print(model.Html.escape(rule.get("origin_port")));
out.write("\n                                                </div>\n                                                <small class=\"text-secondary\">\n                                                    to ");
out.print(model.Html.escape(rule.get("dest_port")));
out.write("\n                                                </small>\n                                            </td>\n\n                                            <td>\n                                                <span class=\"badge bg-info-subtle text-dark\">\n                                                    ");
out.print(model.Html.escape(rule.get("container_type")));
out.write("\n                                                </span>\n                                            </td>\n\n                                            <td>\n                                                ₹");
out.print(model.Html.escape(rule.get("base_rate")));
out.write("\n                                            </td>\n\n                                            <td>\n                                                ₹");
out.print(model.Html.escape(rule.get("rate_per_kg")));
out.write("\n                                            </td>\n\n                                            <td>\n                                                ₹");
out.print(model.Html.escape(rule.get("rate_per_cbm")));
out.write("\n                                            </td>\n\n                                            <td>\n                                                ");
out.print(model.Html.escape(rule.get("season_multiplier")));
out.write("x\n                                            </td>\n\n                                            <td>\n                                                ");
out.print(model.Html.escape(rule.get("demand_multiplier")));
out.write("x\n                                            </td>\n\n                                            <td>\n                                                <small>\n                                                    ");
out.print(model.Html.escape(rule.get("valid_from")));
out.write("\n                                                    <br>\n                                                    to ");
out.print(model.Html.escape(rule.get("valid_to") == null
                                                        ? "No expiry"
                                                        : rule.get("valid_to")));
out.write("\n                                                </small>\n                                            </td>\n\n                                            <td>\n                                                ");
 if (Boolean.TRUE.equals(rule.get("is_active"))
                                                      || "1".equals(String.valueOf(rule.get("is_active")))
                                                      || "true".equalsIgnoreCase(String.valueOf(rule.get("is_active")))) { 
out.write("\n\n                                                    <span class=\"badge bg-success-subtle text-success\">\n                                                        Active\n                                                    </span>\n\n                                                ");
 } else { 
out.write("\n\n                                                    <span class=\"badge bg-secondary-subtle text-secondary\">\n                                                        Inactive\n                                                    </span>\n\n                                                ");
 } 
out.write("\n                                            </td>\n\n                                            <td>\n                                                <div class=\"nl-pricing-actions\">\n\n                                                    <!-- AUDIT -->\n                                                    <form action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ContainerAllocationPricingController\"\n                                                          method=\"post\">\n\n                                                        <input type=\"hidden\" name=\"module\" value=\"pricing\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\">\n                                                        <input type=\"hidden\" name=\"action\" value=\"audit\">\n                                                        <input type=\"hidden\" name=\"ruleId\"\n                                                               value=\"");
out.print(model.Html.escape(rule.get("rule_id")));
out.write("\">\n\n                                                        <button type=\"submit\"\n                                                                class=\"btn btn-sm btn-light border\"\n                                                                title=\"View pricing audit\"><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM4NzQ1MjQiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik00IDRoMTZ2MTZINHpNNyA5aDEwTTcgMTNoMTBNNyAxN2g2Ii8+PC9zdmc+\" width=\"16\" height=\"16\" alt=\"\" aria-hidden=\"true\"> View audit</button>\n\n                                                    </form>");
out.write("\n\n                                                    <!-- PRE-FILLED EDIT -->\n                                                    <button type=\"button\" class=\"btn btn-sm btn-warning bg-gradient nl-pricing-edit\" aria-haspopup=\"dialog\" aria-controls=\"nlPricingEditDialog\" data-rule-id=\"");
out.print(model.Html.escape(rule.get("rule_id")));
out.write("\" data-origin=\"");
out.print(model.Html.escape(rule.get("origin_port")));
out.write("\" data-destination=\"");
out.print(model.Html.escape(rule.get("dest_port")));
out.write("\" data-container=\"");
out.print(model.Html.escape(rule.get("container_type")));
out.write("\" data-base-rate=\"");
out.print(model.Html.escape(rule.get("base_rate")));
out.write("\" data-rate-per-kg=\"");
out.print(model.Html.escape(rule.get("rate_per_kg")));
out.write("\" data-rate-per-cbm=\"");
out.print(model.Html.escape(rule.get("rate_per_cbm")));
out.write("\" data-season-multiplier=\"");
out.print(model.Html.escape(rule.get("season_multiplier")));
out.write("\" data-demand-multiplier=\"");
out.print(model.Html.escape(rule.get("demand_multiplier")));
out.write("\" data-valid-from=\"");
out.print(model.Html.escape(rule.get("valid_from")));
out.write("\" data-valid-to=\"");
out.print(model.Html.escape(rule.get("valid_to") == null ? "" : rule.get("valid_to")));
out.write("\" title=\"Edit this pricing rule\">Edit</button>\n\n                                                    <!-- DELETE / ARCHIVE; preserve audit history -->\n                                                    <form action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ContainerAllocationPricingController\" method=\"post\" data-nl-site-confirm=\"Delete this pricing rule from the active directory? It will no longer be usable for new bookings. Its audit history will be preserved.\" data-nl-confirm-title=\"Delete pricing rule\"><input type=\"hidden\" name=\"module\" value=\"pricing\"><input type=\"hidden\" name=\"action\" value=\"delete\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\"><input type=\"hidden\" name=\"ruleId\" value=\"");
out.print(model.Html.escape(rule.get("rule_id")));
out.write("\"><button type=\"submit\" class=\"btn btn-sm btn-warning bg-gradient\" title=\"Delete rule (preserve pricing audit)\">Delete</button></form>");

out.write("\n\n                                                </div>\n                                            </td>\n\n                                        </tr>\n\n                                    ");
 } 
out.write("\n\n                                ");
 } else { 
out.write("\n\n                                    <tr>\n                                        <td colspan=\"11\" class=\"text-center py-5\">\n\n                                            \n\n                                            <h6 class=\"fw-bold mt-3\">\n                                                No Pricing Rules Found\n                                            </h6>\n\n                                            <p class=\"text-secondary small mb-0\">\n                                                Add a pricing rule to get started.\n                                            </p>\n\n                                        </td>\n                                    </tr>\n\n                                ");
 } 
out.flush(); request.setAttribute("nlv_Module3_pricing__12", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module3_pricing__13", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module3_pricing__14", String.valueOf(model.Html.escape(session.getAttribute("csrfToken"))));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_dashboard(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Stock overview"); 
request.setAttribute("nlv_Module4_dashboard__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__7", String.valueOf(model.Html.escape(request.getContextPath())));

List<model.Stock> stockRows=model.JspSupport.typed(request.getAttribute("stockRows"),model.Stock.class);
List<model.Product> products=model.JspSupport.typed(request.getAttribute("products"),model.Product.class);
List<model.Row> shipmentChoices=model.JspSupport.typed(request.getAttribute("shipmentOptions"),model.Row.class);
int generalCount=0,reservedCount=0,damagedCount=0;
BigDecimal generalAvailable=BigDecimal.ZERO;
for(model.Stock row:stockRows){if(row.getShipmentId()!=null){reservedCount++;}else{generalCount++;if(row.getAvailableQty()!=null)generalAvailable=generalAvailable.add(row.getAvailableQty());}if(row.getDamagedQty()!=null&&row.getDamagedQty().signum()>0)damagedCount++;}
String stockFlash=(String)session.getAttribute("stockFlash");
String flashKind=(String)session.getAttribute("stockFlashKind");
if(stockFlash!=null){session.removeAttribute("stockFlash");session.removeAttribute("stockFlashKind");}

nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(stockFlash!=null&&!stockFlash.trim().isEmpty()){ 
out.write("<div class=\"iv-toast\" role=\"status\"><div><strong>");
out.print("error".equalsIgnoreCase(flashKind)?"Action needs attention":"Saved successfully");
out.write("</strong><div>");
out.print(model.Html.escape(stockFlash));
out.write("</div></div><button class=\"iv-btn\" type=\"button\" aria-label=\"Dismiss message\">Close</button></div>");
 } 
out.flush(); request.setAttribute("nlv_Module4_dashboard__8", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(request.getAttribute("error")!=null){ 
out.write("<div class=\"iv-notice error\" role=\"alert\">");
out.print(model.Html.escape(request.getAttribute("error")));
out.write("</div>");
 } 
out.flush(); request.setAttribute("nlv_Module4_dashboard__9", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module4_dashboard__10", String.valueOf(products.size()));
request.setAttribute("nlv_Module4_dashboard__11", String.valueOf(generalCount));
request.setAttribute("nlv_Module4_dashboard__12", String.valueOf(reservedCount));
request.setAttribute("nlv_Module4_dashboard__13", String.valueOf(generalAvailable.stripTrailingZeros().toPlainString()));
request.setAttribute("nlv_Module4_dashboard__14", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__15", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__16", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__17", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__18", String.valueOf(model.Html.escape(request.getParameter("q"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Row sh:shipmentChoices){ 
out.write("<option value=\"");
out.print(model.Html.escape(sh.text("shipment_id")));
out.write("\" ");
out.print(sh.text("shipment_id").equals(request.getParameter("shipmentId"))?"selected=\"selected\"":"");
out.write(">");
out.print(model.Html.escape(sh.text("shipment_no")));
out.write(" — ");
out.print(model.Html.escape(sh.text("status")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module4_dashboard__19", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module4_dashboard__20", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__21", String.valueOf(stockRows.size()));
request.setAttribute("nlv_Module4_dashboard__22", String.valueOf(products.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Stock s:stockRows){boolean reserved=s.getShipmentId()!=null || s.getContainerId()!=null; 
out.write("\n<tr data-iv-row=\"true\" data-iv-kind=\"");
out.print(reserved?"reserved":"general");
out.write("\"><td><strong>");
out.print(model.Html.escape(s.getProductName()));
out.write("</strong><small><span class=\"nl-inline-copy\" role=\"button\" tabindex=\"0\" data-nl-copy-value=\"");
out.print(model.Html.escape(s.getSku()));
out.write("\" title=\"Click to copy SKU\" aria-label=\"Copy SKU ");
out.print(model.Html.escape(s.getSku()));
out.write("\">");
out.print(model.Html.escape(s.getSku()));
out.write("</span></small></td>\n<td><span class=\"iv-pill ");
out.print(reserved?"reserved":"ok");
out.write("\">");
out.print(reserved?"Reserved":"General stock");
out.write("</span></td>\n<td>");
 if(reserved){ 
out.write("<strong>Shipment #");
out.print(s.getShipmentId());
out.write("</strong><small>");
out.print(model.Html.escape(s.getShipmentNo()));
out.write(" · Container ");
out.print(model.Html.escape(s.getContainerNumber()==null?s.getContainerId():s.getContainerNumber()));
out.write("</small>");
 }else{ 
out.write("<span class=\"text-secondary\">Not assigned</span>");
 } 
out.write("</td>\n<td>");
out.print(model.Html.escape(s.getQuantity()));
out.write("</td><td>");
out.print(model.Html.escape(s.getDamagedQty()));
out.write("</td><td><strong>");
out.print(model.Html.escape(s.getAvailableQty()));
out.write("</strong></td><td>");
out.print(model.Html.escape(s.getLastUpdated()));
out.write("</td>\n<td>");
 if(!reserved){ 
out.write("<div class=\"iv-table-actions\"><button class=\"iv-btn\" type=\"button\" data-iv-edit-stock data-id=\"");
out.print(s.getStockId());
out.write("\" data-name=\"");
out.print(model.Html.escape(s.getProductName()));
out.write("\" data-quantity=\"");
out.print(model.Html.escape(s.getQuantity()));
out.write("\" data-damaged=\"");
out.print(model.Html.escape(s.getDamagedQty()));
out.write("\">Edit stock</button><a class=\"iv-btn\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/stock?action=new-stock&amp;productId=");
out.print(s.getProductId());
out.write("\">Add stock</a>\n<form method=\"post\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/stock\" data-nl-site-confirm=\"Remove this general stock balance from active inventory? Any remaining units will be adjusted to zero, and inventory ledger/history will be preserved. Shipment-reserved stock cannot be removed.\" data-nl-confirm-title=\"Delete stock record\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("stockCsrfToken")));
out.write("\"><input type=\"hidden\" name=\"action\" value=\"delete-stock\"><input type=\"hidden\" name=\"stockId\" value=\"");
out.print(s.getStockId());
out.write("\"><button class=\"iv-btn danger\" type=\"submit\" title=\"Remove general stock and keep ledger history\">Delete</button></form></div>");
 }else{ 
out.write("<span class=\"iv-counter\">Booking-managed</span>");
 } 
out.write("</td></tr>\n");
 } 
out.flush(); request.setAttribute("nlv_Module4_dashboard__23", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(stockRows.isEmpty()){ 
out.write("<tr><td colspan=\"8\" class=\"iv-empty\">No matching stock found. Try resetting your filters or add stock for an existing product.</td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_dashboard__24", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module4_dashboard__25", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Product p:products){ 
out.write("<tr data-iv-row=\"true\"><td><span class=\"nl-inline-copy\" role=\"button\" tabindex=\"0\" data-nl-copy-value=\"");
out.print(model.Html.escape(p.getSku()));
out.write("\" title=\"Click to copy SKU\" aria-label=\"Copy SKU ");
out.print(model.Html.escape(p.getSku()));
out.write("\">");
out.print(model.Html.escape(p.getSku()));
out.write("</span></td><td><strong>");
out.print(model.Html.escape(p.getProductName()));
out.write("</strong></td><td>");
out.print(model.Html.escape(p.getCategory()));
out.write("</td><td>");
out.print(model.Html.escape(p.getHsCode()));
out.write("</td><td>");
out.print(model.Html.escape(p.getUnit()));
out.write("<small>");
out.print(model.Html.escape(p.getUnitWeightKg()));
out.write(" kg per unit</small></td><td><strong>&#8377; ");
out.print(model.Html.escape(p.getUnitPrice()));
out.write("</strong></td>\n<td><div class=\"iv-table-actions\"><a class=\"iv-btn\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/stock?action=edit-product&amp;id=");
out.print(p.getProductId());
out.write("\">Edit</a><a class=\"iv-btn\" href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/stock?action=new-stock&amp;productId=");
out.print(p.getProductId());
out.write("\">Add stock</a>\n<form method=\"post\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/stock\" data-nl-site-confirm=\"Delete this product? Deletion will be blocked if stock, sales or shipment history still depends on it.\" data-nl-confirm-title=\"Delete product\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("stockCsrfToken")));
out.write("\"><input type=\"hidden\" name=\"action\" value=\"delete-product\"><input type=\"hidden\" name=\"productId\" value=\"");
out.print(p.getProductId());
out.write("\"><button type=\"submit\" class=\"iv-btn danger\">Delete</button></form></div></td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_dashboard__26", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(products.isEmpty()){ 
out.write("<tr><td colspan=\"7\" class=\"iv-empty\">Your product catalogue is empty. Add your first product to begin tracking stock.</td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_dashboard__27", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module4_dashboard__28", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__29", String.valueOf(model.Html.escape(session.getAttribute("stockCsrfToken"))));
request.setAttribute("nlv_Module4_dashboard__30", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_dashboard__31", String.valueOf(model.Html.escape(session.getAttribute("stockCsrfToken"))));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_import_result(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Import results"); 
request.setAttribute("nlv_Module4_import_result__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import_result__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import_result__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import_result__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import_result__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import_result__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import_result__7", String.valueOf(model.Html.escape(request.getContextPath())));
 model.StockImportReport report=(model.StockImportReport)request.getAttribute("report");if(report==null)report=new model.StockImportReport(); 
request.setAttribute("nlv_Module4_import_result__8", String.valueOf(report.getRows().size()));
request.setAttribute("nlv_Module4_import_result__9", String.valueOf(report.getSuccessCount()));
request.setAttribute("nlv_Module4_import_result__10", String.valueOf(report.getErrorCount()));
request.setAttribute("nlv_Module4_import_result__11", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import_result__12", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.StockImportResult row:report.getRows()){ 
out.write("<tr data-iv-row=\"true\"><td>#");
out.print(row.getRowNumber());
out.write("</td><td>");
out.print(model.Html.escape(row.getSku()));
out.write("</td><td><span class=\"iv-pill ");
out.print(row.isSuccess()?"ok":"warn");
out.write("\">");
out.print(row.isSuccess()?"Imported":"Rejected");
out.write("</span></td><td>");
out.print(model.Html.escape(row.getMessage()));
out.write("</td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_import_result__13", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(report.getRows().isEmpty()){ 
out.write("<tr><td colspan=\"4\" class=\"iv-empty\">No import results were returned.</td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_import_result__14", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_import(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Import stock"); 
request.setAttribute("nlv_Module4_import__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__7", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__8", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__9", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_import__10", String.valueOf(model.Html.escape(session.getAttribute("stockCsrfToken"))));
request.setAttribute("nlv_Module4_import__11", String.valueOf(model.Html.escape(request.getContextPath())));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_ledger(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Inventory ledger"); 
request.setAttribute("nlv_Module4_ledger__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_ledger__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_ledger__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_ledger__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_ledger__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_ledger__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_ledger__7", String.valueOf(model.Html.escape(request.getContextPath())));
 List<model.InventoryLedger> ledger=model.JspSupport.typed(request.getAttribute("ledger"),model.InventoryLedger.class);List<model.Product> productChoices=model.JspSupport.typed(request.getAttribute("products"),model.Product.class);String chosenType=request.getParameter("txnType")==null?"":request.getParameter("txnType"); 
request.setAttribute("nlv_Module4_ledger__8", String.valueOf(ledger.size()));
request.setAttribute("nlv_Module4_ledger__9", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Product p:productChoices){ 
out.write("<option value=\"");
out.print(p.getProductId());
out.write("\" ");
out.print(String.valueOf(p.getProductId()).equals(request.getParameter("productId"))?"selected=\"selected\"":"");
out.write(">");
out.print(model.Html.escape(p.getProductName()));
out.write(" — ");
out.print(model.Html.escape(p.getSku()));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module4_ledger__10", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String kind:new String[]{"IN","OUT","DAMAGE","ADJUST","CLAIM_LOSS"}){ 
out.write("<option value=\"");
out.print(kind);
out.write("\" ");
out.print(kind.equals(chosenType)?"selected=\"selected\"":"");
out.write(">");
out.print(kind);
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module4_ledger__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module4_ledger__12", String.valueOf(model.Html.escape(request.getParameter("referenceType"))));
request.setAttribute("nlv_Module4_ledger__13", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_ledger__14", String.valueOf(model.Html.escape(request.getParameter("referenceId"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.InventoryLedger l:ledger){ 
out.write("<tr data-iv-row=\"true\"><td>");
out.print(model.Html.escape(l.getTxnTime()));
out.write("</td><td><strong>");
out.print(model.Html.escape(l.getProductName()));
out.write("</strong><small>");
out.print(model.Html.escape(l.getSku()));
out.write("</small></td><td><span class=\"iv-pill ");
out.print("IN".equals(l.getTxnType())?"ok":"OUT".equals(l.getTxnType())?"warn":"");
out.write("\">");
out.print(model.Html.escape(l.getTxnType()));
out.write("</span></td><td>");
out.print(model.Html.escape(l.getQuantity()));
out.write("</td><td><strong>");
out.print(model.Html.escape(l.getBalanceAfter()));
out.write("</strong></td><td>");
out.print(model.Html.escape(l.getReferenceType()));
out.write("<small>");
out.print(model.Html.escape(l.getReferenceId()));
out.write("</small></td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_ledger__15", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(ledger.isEmpty()){ 
out.write("<tr><td colspan=\"6\" class=\"iv-empty\">No transactions match the filters. Change the date or record filters to view more activity.</td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_ledger__16", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_product_form(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Add product"); 
request.setAttribute("nlv_Module4_product_form__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__7", String.valueOf(model.Html.escape(request.getContextPath())));
 model.Product p=(model.Product)request.getAttribute("formProduct");if(p==null)p=new model.Product();boolean editing=p.getProductId()>0; 
request.setAttribute("nlv_Module4_product_form__8", String.valueOf(editing?"Update product information":"Create a new product"));
request.setAttribute("nlv_Module4_product_form__9", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__10", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_product_form__11", String.valueOf(model.Html.escape(session.getAttribute("stockCsrfToken"))));
request.setAttribute("nlv_Module4_product_form__12", String.valueOf(p.getProductId()));
request.setAttribute("nlv_Module4_product_form__13", String.valueOf(editing?"update-product":"create-product"));
request.setAttribute("nlv_Module4_product_form__14", String.valueOf(model.Html.escape(p.getSku())));
request.setAttribute("nlv_Module4_product_form__15", String.valueOf(model.Html.escape(p.getProductName())));
request.setAttribute("nlv_Module4_product_form__16", String.valueOf(model.Html.escape(p.getCategory())));
request.setAttribute("nlv_Module4_product_form__17", String.valueOf(model.Html.escape(p.getHsCode())));
request.setAttribute("nlv_Module4_product_form__18", String.valueOf(model.Html.escape(p.getUnit())));
request.setAttribute("nlv_Module4_product_form__19", String.valueOf(model.Html.escape(p.getUnitWeightKg())));
request.setAttribute("nlv_Module4_product_form__20", String.valueOf(model.Html.escape(p.getUnitPrice())));
request.setAttribute("nlv_Module4_product_form__21", String.valueOf(editing?"Save product changes":"Create product"));
request.setAttribute("nlv_Module4_product_form__22", String.valueOf(model.Html.escape(request.getContextPath())));
Object productError=request.getAttribute("stockProductError");
request.setAttribute("nlv_Module4_product_form__23",productError==null?"":"<div class=\"iv-notice error\" role=\"alert\">"+model.Html.escape(productError)+"</div>");
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_sales(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Sales history"); 
request.setAttribute("nlv_Module4_sales__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__7", String.valueOf(model.Html.escape(request.getContextPath())));
 List<model.Row> sales=model.JspSupport.typed(request.getAttribute("salesRows"),model.Row.class);BigDecimal totalSales=BigDecimal.ZERO;BigDecimal totalUnits=BigDecimal.ZERO;for(model.Row s:sales){if("CANCELLED".equals(s.text("shipment_status")))continue;try{totalSales=totalSales.add(new BigDecimal(s.text("total_amount")));}catch(Exception ignored){}try{totalUnits=totalUnits.add(new BigDecimal(s.text("quantity")));}catch(Exception ignored){}} 
request.setAttribute("nlv_Module4_sales__8", String.valueOf(sales.size()));
request.setAttribute("nlv_Module4_sales__9", String.valueOf(totalUnits.stripTrailingZeros().toPlainString()));
request.setAttribute("nlv_Module4_sales__10", String.valueOf(totalSales.setScale(2,RoundingMode.HALF_UP)));
request.setAttribute("nlv_Module4_sales__11", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__12", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_sales__13", String.valueOf(model.Html.escape(request.getParameter("q"))));
request.setAttribute("nlv_Module4_sales__14", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Row sale:sales){ 
out.write("<tr data-iv-row=\"true\"><td><strong>#");
out.print(model.Html.escape(sale.text("sale_id")));
out.write("</strong></td><td>");
out.print(model.Html.escape(sale.text("sale_date")));
out.write("</td><td>");
out.print(model.Html.escape(sale.text("shipment_no")));
if("CANCELLED".equals(sale.text("shipment_status"))){
out.write("<small class=\"d-block text-danger fw-bold\">Cancelled — historical only</small>");
}
out.write("</td><td><strong>");
out.print(model.Html.escape(sale.text("product_name")));
out.write("</strong><small>");
out.print(model.Html.escape(sale.text("sku")));
out.write("</small></td><td>");
out.print(model.Html.escape(sale.text("quantity")));
out.write("</td><td>&#8377; ");
out.print(model.Html.escape(sale.text("unit_price")));
out.write("</td><td><strong>&#8377; ");
out.print(model.Html.escape(sale.text("total_amount")));
out.write("</strong></td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_sales__15", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(sales.isEmpty()){ 
out.write("<tr><td colspan=\"7\" class=\"iv-empty\">No sale records found. Adjust your search or check back after sales are recorded.</td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module4_sales__16", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_stock_form(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Add stock"); 
request.setAttribute("nlv_Module4_stock_form__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__7", String.valueOf(model.Html.escape(request.getContextPath())));
 List<model.Product> choices=model.JspSupport.typed(request.getAttribute("products"),model.Product.class);String selectedId=request.getParameter("productId"); 
request.setAttribute("nlv_Module4_stock_form__8", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__9", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_stock_form__10", String.valueOf(model.Html.escape(session.getAttribute("stockCsrfToken"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Product p:choices){ 
out.write("<option value=\"");
out.print(p.getProductId());
out.write("\" ");
out.print(String.valueOf(p.getProductId()).equals(selectedId)?"selected=\"selected\"":"");
out.write(">");
out.print(model.Html.escape(p.getProductName()));
out.write(" — ");
out.print(model.Html.escape(p.getSku()));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module4_stock_form__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module4_stock_form__12", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(choices.isEmpty()){ 
out.write("<div class=\"iv-notice error\" style=\"margin-top:14px\">No products are available. Create a product first using Add product.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module4_stock_form__13", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module4_summary(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule","Module4");request.setAttribute("nlPageTitle","Shipment stock"); 
request.setAttribute("nlv_Module4_summary__1", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_summary__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_summary__3", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_summary__4", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_summary__5", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_summary__6", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_summary__7", String.valueOf(model.Html.escape(request.getContextPath())));
 List<model.Row> shipments=model.JspSupport.typed(request.getAttribute("shipments"),model.Row.class);model.StockSummary stockSummary=(model.StockSummary)request.getAttribute("summary");String selected=request.getParameter("shipmentId"); 
request.setAttribute("nlv_Module4_summary__8", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module4_summary__9", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(model.Row sh:shipments){ 
out.write("<option value=\"");
out.print(model.Html.escape(sh.text("shipment_id")));
out.write("\" ");
out.print(sh.text("shipment_id").equals(selected)?"selected=\"selected\"":"");
out.write(">");
out.print(model.Html.escape(sh.text("shipment_no")));
out.write(" — ");
out.print(model.Html.escape(sh.text("status")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module4_summary__10", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(stockSummary!=null){ 
out.write("\n<div class=\"iv-kpis\"><div class=\"iv-kpi\"><small>Shipment</small><strong>#");
out.print(stockSummary.getShipmentId());
out.write("</strong><span>Authorized record</span></div><div class=\"iv-kpi\"><small>Booked quantity</small><strong>");
out.print(model.Html.escape(stockSummary.getTotalQuantity()));
out.write("</strong><span>Total units</span></div><div class=\"iv-kpi\"><small>Goods value</small><strong>&#8377; ");
out.print(model.Html.escape(stockSummary.getTotalValue()));
out.write("</strong><span>Recorded product valuation</span></div><div class=\"iv-kpi\"><small>Line items</small><strong>");
out.print(stockSummary.getLines().size());
out.write("</strong><span>Products in shipment</span></div></div>\n<section class=\"iv-panel\" data-iv-table=\"shipment-goods\"><div class=\"iv-section-head\"><div><h2>Products in this shipment</h2><p>Itemized quantities and recorded values for your selected shipment.</p></div><span class=\"iv-pill\">Authorized view</span></div><div class=\"iv-local-bar\"><div class=\"iv-actions\"><input type=\"search\" data-iv-search placeholder=\"Find product in shipment\" aria-label=\"Search loaded rows\"><button type=\"button\" class=\"iv-btn\" data-iv-clear>Clear</button><button type=\"button\" class=\"iv-btn\" data-iv-csv>Export CSV</button></div><span class=\"iv-counter\" data-iv-count></span></div>\n<div class=\"iv-table-wrap\"><table class=\"iv-table\" data-nl-server-paged=\"true\" data-nl-no-auto-copy=\"true\"><thead><tr><th>SKU</th><th>Product</th><th>Quantity</th><th>Unit price</th><th>Goods value</th></tr></thead><tbody>\n");
 for(model.StockSummary.Line line:stockSummary.getLines()){ 
out.write("<tr data-iv-row=\"true\"><td>");
out.print(model.Html.escape(line.getSku()));
out.write("</td><td><strong>");
out.print(model.Html.escape(line.getProductName()));
out.write("</strong></td><td>");
out.print(model.Html.escape(line.getQuantity()));
out.write("</td><td>&#8377; ");
out.print(model.Html.escape(line.getUnitPrice()));
out.write("</td><td><strong>&#8377; ");
out.print(model.Html.escape(line.getStockValue()));
out.write("</strong></td></tr>");
 } 
out.write("\n");
 if(stockSummary.getLines().isEmpty()){ 
out.write("<tr><td colspan=\"5\" class=\"iv-empty\">This shipment has no recorded product lines.</td></tr>");
 } 
out.write("</tbody></table></div><div class=\"iv-table-controls\"><div class=\"iv-actions\"><label class=\"iv-counter\" for=\"ivRowsSelect\">Rows per page</label><select id=\"ivRowsSelect\" style=\"width:auto;min-height:36px\" data-iv-size><option value=\"10\">10</option><option value=\"20\">20</option><option value=\"50\">50</option></select></div><div class=\"iv-pagination\"><button type=\"button\" class=\"iv-btn\" data-iv-prev>Previous</button><span data-iv-page>Page 1 / 1</span><button type=\"button\" class=\"iv-btn\" data-iv-next>Next</button></div></div></section>\n");
 }else{ 
out.write("<div class=\"iv-panel iv-notice info\" role=\"status\"><strong>Select a shipment to begin.</strong><p class=\"mb-0\">The selected shipment's products and total goods value will appear here.</p></div>");
 } 
out.flush(); request.setAttribute("nlv_Module4_summary__11", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module5_create(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 String url=request.getContextPath()+"/billing"; String role=(String)request.getAttribute("role"); String csrf=h(request.getAttribute("csrf")); 
 request.setAttribute("nlActiveModule", "Module5"); request.setAttribute("nlPageTitle", "Create invoice"); 
request.setAttribute("nlv_Module5_create__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
request.setAttribute("nlv_Module5_create__2", String.valueOf(url));
 List<Row> rows=model.JspSupport.typed(request.getAttribute("rows"), Row.class); 
request.setAttribute("nlv_Module5_create__3", String.valueOf(url));
request.setAttribute("nlv_Module5_create__4", String.valueOf(csrf));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(Row x:rows){ 
out.write("<option value=\"");
out.print(x.id("shipment_id"));
out.write("\">");
out.print(h(x.text("shipment_no")));
out.write(" | Quote ₹");
out.print(h(x.text("quoted_price")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module5_create__5", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(rows.isEmpty()){ 
out.write("<p>No eligible shipments. Confirmed bookings normally generate invoices automatically.</p>");
 } 
out.flush(); request.setAttribute("nlv_Module5_create__6", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module5_details(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    String url = request.getContextPath() + "/billing";
    String role = (String) request.getAttribute("role");
    String csrf = h(request.getAttribute("csrf"));

    Row inv = (Row) request.getAttribute("invoice");

    List<Row> items =
        model.JspSupport.typed(request.getAttribute("items"), Row.class);

    List<Row> payments =
        model.JspSupport.typed(request.getAttribute("payments"), Row.class);

    boolean seller = "SELLER".equals(role);
    boolean consumer = "CONSUMER".equals(role);
    boolean cancelled = "CANCELLED".equals(inv.text("shipment_status"));
    boolean unpaid = !cancelled && "UNPAID".equals(inv.text("status"));
    boolean open = !cancelled && !"PAID".equals(inv.text("status"));
    boolean deliveredChoice = Boolean.TRUE.equals(request.getAttribute("deliveryArrangement"));
    String preferredPayment = String.valueOf(request.getAttribute("payMode"));
    boolean preferPartial = "PARTIAL".equals(preferredPayment);
    String invoiceNonce = String.valueOf(request.getAttribute("paymentNonce") == null ? "" : request.getAttribute("paymentNonce"));

 request.setAttribute("nlActiveModule", "Module5"); request.setAttribute("nlPageTitle", "Invoice details"); 
request.setAttribute("nlv_Module5_details__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
request.setAttribute("nlv_Module5_details__2", String.valueOf(url));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(request.getAttribute("paymentSuccess") != null) { 
out.write("\n<div class=\"payment-success nl-payment-receipt\" role=\"status\" aria-live=\"polite\">\n    <strong>Payment successfully recorded</strong>\n    <p class=\"mb-1\">");
out.print(h(request.getAttribute("paymentSuccess")));
out.write("\n       Current invoice status: <strong>");
out.print(h(inv.text("status")));
out.write("</strong>.\n       Outstanding balance: <strong>&#8377; ");
out.print(h(inv.text("balance")));
out.write("</strong>.</p>\n    <a href=\"#nlPaymentHistory\">Review recorded payment history</a>\n</div>\n");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__3", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(request.getAttribute("paymentArrangementSuccess")!=null){ 
out.write("\n<div class=\"alert alert-info rounded-4 border\" role=\"status\"><strong>Payment arrangement recorded</strong><p class=\"mb-0\">");
out.print(h(request.getAttribute("paymentArrangementSuccess")));
out.write("</p></div>\n");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__4", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(cancelled){ 
out.write("\n<section class=\"alert alert-warning rounded-4 border border-warning p-3 mb-3\" role=\"status\">\n  <strong>Booking cancelled — invoice retained for audit.</strong>\n  <p class=\"mb-0 mt-1\">This invoice is a historical record only. Its original amount is not payable, and no new payments or due-date changes are allowed. The shipment's cancellation movement and stock reversal remain on record.</p>\n</section>\n");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__5", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_details__6", String.valueOf(h(inv.text("invoice_no"))));
request.setAttribute("nlv_Module5_details__7", String.valueOf(h(inv.text("shipment_no"))));
request.setAttribute("nlv_Module5_details__8", String.valueOf(cancelled?"badge text-bg-dark":"PAID".equals(inv.text("status"))
                ? "status-paid"
                : "PARTIAL".equals(inv.text("status"))
                    ? "status-partial"
                    : "status-unpaid"));
request.setAttribute("nlv_Module5_details__9", String.valueOf(cancelled?"CANCELLED":h(inv.text("status"))));
request.setAttribute("nlv_Module5_details__10", String.valueOf(h(inv.text("seller_name"))));
request.setAttribute("nlv_Module5_details__11", String.valueOf(h(inv.text("consumer_name"))));
request.setAttribute("nlv_Module5_details__12", String.valueOf(h(inv.text("issue_date"))));
request.setAttribute("nlv_Module5_details__13", String.valueOf(h(inv.text("due_date"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String k : Arrays.asList(
            "sub_total",
            "tax_amount",
            "total_amount",
            "paid_amount",
            "balance"
        )) { 
out.write("\n\n            <div>\n\n                ");
out.print(h(k.replace("_", " ")));
out.write("\n\n                <strong>\n                    &#8377; ");
out.print(h(inv.text(k)));
out.write("\n                </strong>\n\n            </div>\n\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__14", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(cancelled){ 
out.write("<p class=\"text-warning-emphasis fw-semibold small mb-3\">Historical amounts only — no outstanding payment obligation for this cancelled booking.</p>");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__15", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_details__16", String.valueOf(url));
request.setAttribute("nlv_Module5_details__17", String.valueOf(inv.id("invoice_id")));
request.setAttribute("nlv_Module5_details__18", String.valueOf(url));
request.setAttribute("nlv_Module5_details__19", String.valueOf(inv.id("invoice_id")));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(seller && open) { 
out.write("\n\n        <form method=\"post\"\n              action=\"");
out.print(url);
out.write("\"\n              class=\"nl-inline-form mb-3\">\n\n            <input type=\"hidden\"\n                   name=\"csrf\"\n                   value=\"");
out.print(csrf);
out.write("\">\n\n            <input type=\"hidden\"\n                   name=\"action\"\n                   value=\"due\">\n\n            <input type=\"hidden\"\n                   name=\"invoice\"\n                   value=\"");
out.print(inv.id("invoice_id"));
out.write("\">\n\n            <label>\n\n                Due date\n\n                <input class=\"form-control\" name=\"due\"\n                       type=\"date\"\n                       value=\"");
out.print(h(inv.text("due_date")));
out.write("\"\n                       required>\n\n            </label>\n\n            <button class=\"btn btn-warning bg-gradient\" type=\"submit\">\n\n                Save due date\n\n            </button>\n\n        </form>\n\n    ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__20", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(seller && unpaid) { 
out.write("\n                        <th>Actions</th>\n                    ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__21", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(Row x : items) { 
out.write("\n\n                <tr>\n\n                    <td>");
out.print(h(x.text("item_type")));
out.write("</td>\n\n                    <td>");
out.print(h(x.text("description")));
out.write("</td>\n\n                    <td>");
out.print(h(x.text("quantity")));
out.write("</td>\n\n                    <td>");
out.print(h(x.text("unit_price")));
out.write("</td>\n\n                    <td>");
out.print(h(x.text("amount")));
out.write("</td>\n\n                    ");
 if(seller && unpaid) { 
out.write("\n\n                    <td>\n\n                        ");
 if(x.get("item_id") != null) { 
out.write("\n\n                        <!-- EDIT INVOICE NOTE -->\n\n                        <form method=\"post\"\n                              action=\"");
out.print(url);
out.write("\"\n                              class=\"nl-inline-form mb-3\">\n\n                            <input type=\"hidden\"\n                                   name=\"csrf\"\n                                   value=\"");
out.print(csrf);
out.write("\">\n\n                            <input type=\"hidden\"\n                                   name=\"action\"\n                                   value=\"editNote\">\n\n                            <input type=\"hidden\"\n                                   name=\"invoice\"\n                                   value=\"");
out.print(inv.id("invoice_id"));
out.write("\">\n\n                            <input type=\"hidden\"\n                                   name=\"item\"\n                                   value=\"");
out.print(x.id("item_id"));
out.write("\">\n\n                            <label>\n\n                                Description\n\n                                <input class=\"form-control\" name=\"description\"\n                                       type=\"text\"\n                                       value=\"");
out.print(h(x.text("description")));
out.write("\"\n                                       required\n                                       maxlength=\"150\">\n\n                            </label>\n\n                            <button class=\"btn btn-warning bg-gradient\" type=\"submit\">\n                                Save\n                            </button>\n\n                        </form>\n\n                        ");
 if("OTHER".equals(x.text("item_type"))
                            && x.money("amount").signum() == 0) { 
out.write("\n\n                        <form method=\"post\"\n                              action=\"");
out.print(url);
out.write("\"\n                              class=\"nl-inline-form mb-3\">\n\n                            <input type=\"hidden\"\n                                   name=\"csrf\"\n                                   value=\"");
out.print(csrf);
out.write("\">\n\n                            <input type=\"hidden\"\n                                   name=\"action\"\n                                   value=\"deleteNote\">\n\n                            <input type=\"hidden\"\n                                   name=\"invoice\"\n                                   value=\"");
out.print(inv.id("invoice_id"));
out.write("\">\n\n                            <input type=\"hidden\"\n                                   name=\"item\"\n                                   value=\"");
out.print(x.id("item_id"));
out.write("\">\n\n                            <button class=\"btn btn-warning bg-gradient\" type=\"submit\">\n\n                                Delete note\n\n                            </button>\n\n                        </form>\n\n                        ");
 } 
out.write("\n\n                        ");
 } 
out.write("\n\n                    </td>\n\n                    ");
 } 
out.write("\n\n                </tr>\n\n                ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__22", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(items.isEmpty()) { 
out.write("\n\n            <p>No invoice charges found.</p>\n\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__23", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(seller && unpaid) { 
out.write("\n\n        <form method=\"post\"\n              action=\"");
out.print(url);
out.write("\"\n              class=\"nl-inline-form mb-3\">\n\n            <input type=\"hidden\"\n                   name=\"csrf\"\n                   value=\"");
out.print(csrf);
out.write("\">\n\n            <input type=\"hidden\"\n                   name=\"action\"\n                   value=\"note\">\n\n            <input type=\"hidden\"\n                   name=\"invoice\"\n                   value=\"");
out.print(inv.id("invoice_id"));
out.write("\">\n\n            <label>\n\n                Add zero-value note\n\n                <input class=\"form-control\" name=\"description\"\n                       type=\"text\"\n                       required\n                       maxlength=\"150\">\n\n            </label>\n\n            <button class=\"btn btn-warning bg-gradient\" type=\"submit\">\n\n                Add note\n\n            </button>\n\n        </form>\n\n        \n\n    ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__24", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_details__25", String.valueOf(url));
request.setAttribute("nlv_Module5_details__26", String.valueOf(url));
request.setAttribute("nlv_Module5_details__27", String.valueOf(url));
request.setAttribute("nlv_Module5_details__28", String.valueOf(inv.id("invoice_id")));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(Row x : payments) { 
out.write("\n\n                <tr>\n\n                    <td>\n                        ");
out.print(h(x.text("payment_id")));
out.write("\n                    </td>\n\n                    <td>\n                        &#8377; ");
out.print(h(x.text("amount")));
out.write("\n                    </td>\n\n                    <td>\n                        ");
out.print(h(x.text("payment_mode")));
out.write("\n                    </td>\n\n                    <td>\n                        ");
out.print(h(x.text("reference_no")));
out.write("\n                    </td>\n\n                    <td>\n                        ");
out.print(h(x.text("payment_date")));
out.write("\n                    </td>\n\n                </tr>\n\n                ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__29", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(payments.isEmpty()) { 
out.write("\n\n            <p>No payments recorded yet.</p>\n\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__30", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(consumer && open && inv.money("balance").signum() > 0) { 
out.write("\n<section class=\"nl-card payment-card nl-payment-workspace card border-0 shadow-sm rounded-4 p-4 mb-4 border-warning-subtle\" id=\"record-payment\" aria-labelledby=\"paymentSectionTitle\">\n    <div class=\"nl-payment-heading\">\n        <div>\n            <span class=\"nl-payment-eyebrow\">SECURE PAYMENT RECORD</span>\n            <h3 id=\"paymentSectionTitle\">Record full or partial payment</h3>\n            <p class=\"payment-subtitle mb-0\">Choose a full or partial payment. This records money you have already paid; it does not transfer funds.</p>\n        </div>\n        <span class=\"nl-payment-invoice-pill\">Invoice ");
out.print(h(inv.text("invoice_no")));
out.write("</span>\n    </div>\n    <div class=\"nl-payment-balance-overview\">\n        <div><span>Invoice total</span><strong>&#8377; ");
out.print(h(inv.text("total_amount")));
out.write("</strong></div>\n        <div><span>Already recorded</span><strong>&#8377; ");
out.print(h(inv.text("paid_amount")));
out.write("</strong></div>\n        <div class=\"nl-payment-due\"><span>Outstanding balance</span><strong>&#8377; ");
out.print(h(inv.text("balance")));
out.write("</strong></div>\n    </div>\n    <div class=\"nl-payment-progress\" role=\"progressbar\" aria-label=\"Invoice paid percentage\"\n         aria-valuemin=\"0\" aria-valuemax=\"100\"\n         aria-valuenow=\"");
out.print(inv.money("total_amount").signum()>0
             ? inv.money("paid_amount").multiply(new java.math.BigDecimal("100"))
                 .divide(inv.money("total_amount"),0,java.math.RoundingMode.HALF_UP)
                 .min(new java.math.BigDecimal("100")).max(java.math.BigDecimal.ZERO).intValue()
             : 0);
out.write("\">\n        <div class=\"nl-payment-progress-fill\" style=\"width:");
out.print(inv.money("total_amount").signum()>0
             ? inv.money("paid_amount").multiply(new java.math.BigDecimal("100"))
                 .divide(inv.money("total_amount"),0,java.math.RoundingMode.HALF_UP)
                 .min(new java.math.BigDecimal("100")).max(java.math.BigDecimal.ZERO).intValue()
             : 0);
out.write("%\"></div>\n    </div>\n    <form method=\"post\" action=\"");
out.print(url);
out.write("\" class=\"nl-inline-form mb-0\" id=\"recordPaymentForm\" data-nl-no-submit-lock=\"true\">\n        <input type=\"hidden\" name=\"csrf\" value=\"");
out.print(csrf);
out.write("\">\n        <input type=\"hidden\" name=\"action\" value=\"pay\">\n        <input type=\"hidden\" name=\"paymentNonce\" value=\"");
out.print(h(invoiceNonce));
out.write("\">\n        <input type=\"hidden\" name=\"invoice\" value=\"");
out.print(inv.id("invoice_id"));
out.write("\">\n        <fieldset class=\"nl-payment-modes\">\n            <legend>Payment type</legend>\n            <div class=\"nl-payment-mode-grid\">\n                <input class=\"visually-hidden\" type=\"radio\" name=\"paymentType\" value=\"FULL\" id=\"nlPaymentFull\" ");
out.print(preferPartial?"":"checked='checked'");
out.write(">\n                <label class=\"nl-payment-mode-option\" for=\"nlPaymentFull\">\n                    <span class=\"nl-payment-mode-mark\" aria-hidden=\"true\"></span>\n                    <span><strong>Full payment</strong><small>Pay the remaining balance in one record</small></span>\n                </label>\n                <input class=\"visually-hidden\" type=\"radio\" name=\"paymentType\" value=\"PARTIAL\" id=\"nlPaymentPartial\" ");
out.print(preferPartial?"checked='checked'":"");
out.write(">\n                <label class=\"nl-payment-mode-option\" for=\"nlPaymentPartial\">\n                    <span class=\"nl-payment-mode-mark\" aria-hidden=\"true\"></span>\n                    <span><strong>Partial payment</strong><small>Record an instalment and pay the rest later</small></span>\n                </label>\n            </div>\n        </fieldset>\n        <label class=\"nl-pay-field\" for=\"nlPaymentAmount\">\n            <span class=\"nl-pay-field-heading\">Payment amount (&#8377;) <span class=\"nl-required\" aria-hidden=\"true\">*</span></span>\n            <input class=\"form-control\" id=\"nlPaymentAmount\" name=\"amount\" type=\"number\"\n                   value=\"");
out.print(h(inv.text("balance")));
out.write("\" min=\"0.01\"\n                   max=\"");
out.print(h(inv.text("balance")));
out.write("\" step=\"0.01\" inputmode=\"decimal\"\n                   autocomplete=\"off\" readonly=\"readonly\" required=\"required\">\n        </label>\n        <label class=\"nl-pay-field\" for=\"nlPaymentMode\">\n            <span class=\"nl-pay-field-heading\">Payment method <span class=\"nl-required\" aria-hidden=\"true\">*</span></span>\n            <select class=\"form-select\" id=\"nlPaymentMode\" name=\"mode\" required=\"required\">\n                <option value=\"UPI\">UPI</option><option value=\"BANK\">Bank transfer</option>\n                <option value=\"CHEQUE\">Cheque</option><option value=\"CASH\">Cash</option>\n            </select>\n        </label>\n        <label class=\"nl-pay-field\" for=\"nlPaymentReference\">\n            <span class=\"nl-pay-field-heading\">Payment reference <span id=\"nlPaymentReferenceRequired\" class=\"nl-required nl-payment-reference-required\" aria-hidden=\"true\">*</span></span>\n            <input class=\"form-control\" id=\"nlPaymentReference\" name=\"reference\" type=\"text\"\n                   placeholder=\"Transaction ID / cheque number\" maxlength=\"50\" autocomplete=\"off\"\n                   aria-describedby=\"nlPaymentReferenceHelp\">\n            <span class=\"nl-payment-reference-help\" id=\"nlPaymentReferenceHelp\">Required for UPI, bank transfer and cheque.</span>\n        </label>\n        <label class=\"nl-pay-field\" for=\"nlPaymentDate\">\n            <span class=\"nl-pay-field-heading\">Payment date <span class=\"nl-required\" aria-hidden=\"true\">*</span></span>\n            <input class=\"form-control\" id=\"nlPaymentDate\" name=\"date\" type=\"date\"\n                   value=\"");
out.print(java.time.LocalDate.now());
out.write("\" max=\"");
out.print(java.time.LocalDate.now());
out.write("\" required=\"required\">\n        </label>\n        <div class=\"nl-partial-shortcuts\" id=\"nlPartialShortcuts\" hidden=\"hidden\">\n            <span>Quick amount</span>\n            <button type=\"button\" class=\"nl-amount-chip\" data-payment-fraction=\"0.25\">25%</button>\n            <button type=\"button\" class=\"nl-amount-chip\" data-payment-fraction=\"0.50\">50%</button>\n            <button type=\"button\" class=\"nl-amount-chip\" data-payment-fraction=\"0.75\">75%</button>\n            <span class=\"nl-payment-help\">Or enter any amount smaller than the outstanding balance.</span>\n        </div>\n        <div class=\"nl-payment-live-summary\" aria-live=\"polite\">\n            <div><span>You'll record</span><strong id=\"nlPayingNow\">&#8377; 0.00</strong></div>\n            <div><span>Balance after payment</span><strong id=\"nlAfterPayment\">&#8377; 0.00</strong></div>\n            <div><span>Expected invoice status</span><strong id=\"nlExpectedStatus\">Paid</strong></div>\n        </div>\n        <p class=\"nl-payment-inline-error\" id=\"nlPaymentInlineError\" role=\"alert\" hidden=\"hidden\"></p>\n        <div class=\"nl-payment-submit-row\">\n            <p>Payment history is permanent. Review the amount, mode and reference before confirming.</p>\n            <button class=\"btn btn-warning bg-gradient\" type=\"submit\" id=\"recordPaymentButton\">Review payment</button>\n        </div>\n    </form>\n</section>\n\n<!-- Accessible, JSP-safe payment confirmation overlay -->\n<div id=\"paymentConfirmDialog\" class=\"payment-dialog\" role=\"dialog\" aria-labelledby=\"paymentTitle\"\n     aria-modal=\"true\" tabindex=\"-1\" hidden=\"hidden\">\n    <div class=\"payment-dialog-surface\">\n        <div class=\"payment-dialog-header\">\n            <div class=\"payment-dialog-icon\" aria-hidden=\"true\">&#8377;</div>\n            <div><h2 class=\"h4 fw-bold text-dark mb-2\" id=\"paymentTitle\">Confirm payment</h2>\n                <p>Check the details before recording this payment.</p></div>\n        </div>\n        <div class=\"payment-amount-box\"><span id=\"reviewPaymentType\">Payment amount</span><strong id=\"reviewAmount\"></strong></div>\n        <dl class=\"payment-review\">\n            <dt>Invoice number</dt><dd>");
out.print(h(inv.text("invoice_no")));
out.write("</dd>\n            <dt>Payment method</dt><dd id=\"reviewMode\"></dd>\n            <dt>Reference</dt><dd id=\"reviewReference\"></dd>\n            <dt>Payment date</dt><dd id=\"reviewDate\"></dd>\n            <dt>Remaining balance</dt><dd id=\"reviewBalance\"></dd>\n            <dt>Expected status</dt><dd id=\"reviewExpectedStatus\"></dd>\n        </dl>\n        <div class=\"payment-warning\"><strong>Please confirm</strong>\n            <p>The application records an existing payment; it does not initiate a transfer. Recorded payments cannot be edited or deleted through the website.</p>\n        </div>\n        <div class=\"payment-actions\">\n            <button type=\"button\" id=\"cancelPayment\" class=\"payment-cancel\">Go back</button>\n            <button type=\"button\" id=\"confirmPayment\" class=\"payment-confirm\">Confirm &amp; record payment</button>\n        </div>\n    </div>\n</div>\n\n");
 } else if(consumer && "PAID".equals(inv.text("status"))) { 
out.write("\n\n<section class=\"card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle\">\n\n    <div class=\"payment-success\">\n\n        <strong>Invoice fully paid</strong>\n\n        <p>\n            All payments for this invoice have been\n            completed. No outstanding balance remains.\n        </p>\n\n    </div>\n\n</section>\n\n");
 } 
out.flush(); request.setAttribute("nlv_Module5_details__31", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_details__32", String.valueOf(h(inv.text("balance"))));
request.setAttribute("nlv_Module5_details__33", String.valueOf(h(inv.text("paid_amount"))));
request.setAttribute("nlv_Module5_details__34", String.valueOf(h(inv.text("total_amount"))));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module5_error(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 String url=request.getContextPath()+"/billing"; String role=(String)request.getAttribute("role"); String csrf=h(request.getAttribute("csrf")); 
 request.setAttribute("nlActiveModule", "Module5"); request.setAttribute("nlPageTitle", "Billing error"); 
request.setAttribute("nlv_Module5_error__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
request.setAttribute("nlv_Module5_error__2", String.valueOf(h(request.getAttribute("error"))));
request.setAttribute("nlv_Module5_error__3", String.valueOf(url));
request.setAttribute("nlv_Module5_error__4", String.valueOf(url));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module5_invoices(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

  request.setAttribute("nlActiveModule","Module5");request.setAttribute("nlPageTitle","Invoices");
  String ctx=request.getContextPath(),base=ctx+"/billing";
  List<Row> invoices=model.JspSupport.typed(request.getAttribute("rows"),Row.class);
  BillingInvoiceSummary totals=request.getAttribute("invoiceSummary") instanceof BillingInvoiceSummary?
    (BillingInvoiceSummary)request.getAttribute("invoiceSummary"):new BillingInvoiceSummary(invoices,java.time.LocalDate.now());
  String role = String.valueOf(request.getAttribute("role"));
  boolean consumer="CONSUMER".equals(role);
  String screen=String.valueOf(request.getAttribute("screen")==null?"invoices":request.getAttribute("screen"));

request.setAttribute("nlv_Module5_invoices__1", String.valueOf("outstanding".equals(screen)?"Outstanding invoices":"Invoices &amp; <span class=\"nl-title-accent\">payments</span>"));
request.setAttribute("nlv_Module5_invoices__2", String.valueOf(model.Html.escape(base)));
request.setAttribute("nlv_Module5_invoices__3", String.valueOf(model.Html.escape(base)));
request.setAttribute("nlv_Module5_invoices__4", String.valueOf(model.Html.escape(totals.getTotal())));
request.setAttribute("nlv_Module5_invoices__5", String.valueOf(model.Html.escape(totals.getPaid())));
request.setAttribute("nlv_Module5_invoices__6", String.valueOf(model.Html.escape(totals.getOutstanding())));
request.setAttribute("nlv_Module5_invoices__7", String.valueOf(totals.getOverdueCount()));
request.setAttribute("nlv_Module5_invoices__8", String.valueOf(model.Html.escape(base)));
request.setAttribute("nlv_Module5_invoices__9", String.valueOf(model.Html.escape(screen)));
request.setAttribute("nlv_Module5_invoices__10", String.valueOf(model.Html.escape(request.getParameter("q"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String st:Arrays.asList("UNPAID","PARTIAL","PAID")){ 
out.write("<option value=\"");
out.print(st);
out.write("\" ");
out.print(st.equals(request.getParameter("status"))?"selected":"");
out.write(">");
out.print(st);
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module5_invoices__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_invoices__12", String.valueOf(model.Html.escape(base)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(Row row:invoices){boolean cancelled="CANCELLED".equals(row.text("shipment_status"));boolean overdue=!cancelled&&totals.isOverdue(row.id("invoice_id")); 
out.write("\n<tr><td><strong>");
out.print(model.Html.escape(row.text("invoice_no")));
out.write("</strong></td><td>");
out.print(model.Html.escape(row.text("shipment_no")));
out.write("</td>\n<td>");
out.print(model.Html.escape(row.text("total_amount")));
out.write("</td><td>");
out.print(model.Html.escape(row.text("paid_amount")));
out.write("</td><td>");
out.print(cancelled?"Not payable":model.Html.escape(row.text("balance")));
out.write("</td>\n<td><span class=\"badge ");
out.print(cancelled?"text-bg-dark":"PAID".equals(row.text("status"))?"text-bg-success":"PARTIAL".equals(row.text("status"))?"text-bg-warning":"text-bg-secondary");
out.write("\">");
out.print(cancelled?"CANCELLED":"PAID".equals(row.text("status"))?"Paid":"PARTIAL".equals(row.text("status"))?"Partially paid":"Unpaid");
out.write("</span>");
 if(overdue){ 
out.write(" <span class=\"badge text-bg-danger\">Overdue</span>");
 } 
out.write("</td>\n<td>");
out.print(model.Html.escape(row.text("due_date")));
out.write("</td><td class=\"nl-invoice-action-cell\"><div class=\"nl-invoice-action-group\"><a class=\"btn btn-outline-dark btn-sm\" href=\"");
out.print(model.Html.escape(base));
out.write("?action=details&amp;invoice=");
out.print(row.id("invoice_id"));
out.write("\">View invoice</a>\n");
 if(consumer && !cancelled && row.money("balance").signum()>0){ 
out.write("\n<a class=\"btn btn-warning btn-sm fw-bold\" href=\"");
out.print(model.Html.escape(base));
out.write("?action=details&amp;invoice=");
out.print(row.id("invoice_id"));
out.write("&amp;payMode=FULL#record-payment\">");
out.print("PARTIAL".equals(row.text("status"))?"Pay remaining balance":"Record payment");
out.write("</a>\n");
 } 
out.write("\n</div></td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module5_invoices__13", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(invoices.isEmpty()){ 
out.write("<div class=\"alert alert-info mt-3\">No invoices match your authorized search. Try clearing the filters.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module5_invoices__14", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module5_payments(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

String ctx=request.getContextPath(), url=ctx+"/billing";
List<Row> history=model.JspSupport.typed(request.getAttribute("rows"),Row.class);
List<Row> invoices=model.JspSupport.typed(request.getAttribute("paymentInvoices"),Row.class);
BillingInvoiceSummary summary = request.getAttribute("paymentInvoiceSummary") instanceof BillingInvoiceSummary
    ? (BillingInvoiceSummary)request.getAttribute("paymentInvoiceSummary")
    : new BillingInvoiceSummary(invoices,java.time.LocalDate.now());
String role=String.valueOf(request.getAttribute("role"));
boolean consumer="CONSUMER".equals(role);
String view=String.valueOf(request.getAttribute("paymentFilter"));
if(!Arrays.asList("all","pending","partial","completed").contains(view))view="all";
request.setAttribute("nlActiveModule","Module5");request.setAttribute("nlPageTitle","Payments");

request.setAttribute("nlv_Module5_payments__1", String.valueOf(safe(url)));
request.setAttribute("nlv_Module5_payments__2", String.valueOf(safe(summary.getTotal())));
request.setAttribute("nlv_Module5_payments__3", String.valueOf(safe(summary.getPaid())));
request.setAttribute("nlv_Module5_payments__4", String.valueOf(safe(summary.getOutstanding())));
request.setAttribute("nlv_Module5_payments__5", String.valueOf(safe(url)));
request.setAttribute("nlv_Module5_payments__6", String.valueOf(safe(view)));
request.setAttribute("nlv_Module5_payments__7", String.valueOf(safe(request.getParameter("q"))));
request.setAttribute("nlv_Module5_payments__8", String.valueOf(safe(url)));
request.setAttribute("nlv_Module5_payments__9", String.valueOf(invoices.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String[] tab:new String[][]{{"all","All invoices"},{"pending","Pending"},{"partial","Partial"},{"completed","Completed"}}){ 
out.write("\n<a class=\"nl-bill-tab\" ");
out.print(tab[0].equals(view)?"aria-current=\"page\"":"");
out.write(" href=\"");
out.print(safe(url));
out.write("?action=payments&amp;view=");
out.print(tab[0]);
out.write("&amp;q=");
out.print(java.net.URLEncoder.encode(String.valueOf(request.getParameter("q")==null?"":request.getParameter("q")),"UTF-8"));
out.write("\">");
out.print(tab[1]);
out.write("</a>\n");
 } 
out.flush(); request.setAttribute("nlv_Module5_payments__10", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 int shown=0;for(Row row:invoices){String status=row.text("status");boolean cancelled="CANCELLED".equals(row.text("shipment_status"));boolean overdue=!cancelled&&summary.isOverdue(row.id("invoice_id"));
 if(("pending".equals(view)&&(!"UNPAID".equals(status)||cancelled))||("partial".equals(view)&&(!"PARTIAL".equals(status)||cancelled))||("completed".equals(view)&&(!"PAID".equals(status)||cancelled)))continue;
 shown++;

out.write("\n<article class=\"nl-bill-record\"><div><strong>");
out.print(safe(row.text("invoice_no")));
out.write("</strong><small class=\"nl-muted\">Shipment ");
out.print(safe(row.text("shipment_no")));
out.write(" · Due ");
out.print(safe(row.text("due_date")));
out.write("</small></div>\n<div><span class=\"nl-bill-status ");
out.print(cancelled?"archived":overdue?"overdue":"PAID".equals(status)?"paid":"");
out.write("\">");
out.print(cancelled?"CANCELLED":overdue?"Overdue":"PAID".equals(status)?"Paid":"PARTIAL".equals(status)?"Partially paid":"Unpaid");
out.write("</span><span class=\"nl-muted\">Billed INR ");
out.print(safe(row.text("total_amount")));
out.write("</span></div>\n<div><span class=\"nl-amount\">");
out.print(cancelled?"Not payable":"INR "+safe(row.text("balance")));
out.write("</span><small class=\"nl-muted\">");
out.print(cancelled?"Historical invoice":"Balance due");
out.write(" · Paid ");
out.print(safe(row.text("paid_amount")));
out.write("</small></div>\n<div class=\"nl-bill-actions\"><a class=\"btn btn-outline-dark btn-sm\" href=\"");
out.print(safe(url));
out.write("?action=details&amp;invoice=");
out.print(row.id("invoice_id"));
out.write("\">View invoice</a>\n");
 if(consumer&&!cancelled&&row.money("balance").signum()>0){ 
out.write("<a class=\"btn btn-warning btn-sm fw-bold\" href=\"");
out.print(safe(url));
out.write("?action=details&amp;invoice=");
out.print(row.id("invoice_id"));
out.write("&amp;payMode=FULL#record-payment\">");
out.print("PARTIAL".equals(status)?"Pay remaining":"Record payment");
out.write("</a>");
 } 
out.write("</div></article>\n");
 } if(shown==0){ 
out.write("<div class=\"nl-bill-empty\">No invoices in this category. Try another filter or clear the search.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module5_payments__11", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_payments__12", String.valueOf(safe(url)));
request.setAttribute("nlv_Module5_payments__13", String.valueOf(safe(request.getParameter("reference"))));
request.setAttribute("nlv_Module5_payments__14", String.valueOf(safe(request.getParameter("from"))));
request.setAttribute("nlv_Module5_payments__15", String.valueOf(safe(request.getParameter("to"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(Row payment:history){ 
out.write("<tr><td><strong>");
out.print(safe(payment.text("invoice_no")));
out.write("</strong></td><td class=\"fw-semibold\">INR ");
out.print(safe(payment.text("amount")));
out.write("</td><td>");
out.print(safe(payment.text("payment_mode")));
out.write("</td><td>");
out.print(safe(payment.text("reference_no")));
out.write("</td><td>");
out.print(safe(payment.text("payment_date")));
out.write("</td><td><a class=\"btn btn-outline-secondary btn-sm\" href=\"");
out.print(safe(url));
out.write("?action=details&amp;invoice=");
out.print(payment.id("invoice_id"));
out.write("\">Invoice</a></td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module5_payments__16", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(history.isEmpty()){ 
out.write("<p class=\"nl-bill-empty\">No recorded payments match those filters.</p>");
 } 
out.flush(); request.setAttribute("nlv_Module5_payments__17", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module5_print(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

Row inv=(Row)request.getAttribute("invoice");
List<Row> items=model.JspSupport.typed(request.getAttribute("items"),Row.class);
String url=request.getContextPath()+"/billing";
List<Row> payments=model.JspSupport.typed(request.getAttribute("payments"),Row.class);
boolean payOnDelivery=Boolean.TRUE.equals(request.getAttribute("deliveryArrangement"));
boolean cancelled="CANCELLED".equals(inv.text("shipment_status"));
boolean overdue=false;
try{overdue=!cancelled && inv.money("balance").signum()>0 && java.time.LocalDate.parse(inv.text("due_date").substring(0,10)).isBefore(java.time.LocalDate.now());}catch(Exception ignored){}

request.setAttribute("nlv_Module5_print__1", String.valueOf(model.Html.escape(inv.text("invoice_no"))));
request.setAttribute("nlv_Module5_print__2", String.valueOf(model.Html.escape(url)));
request.setAttribute("nlv_Module5_print__3", String.valueOf(inv.id("invoice_id")));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(cancelled){ 
out.write("<section style=\"margin:18px 0;padding:14px;border:2px solid #bd652f;background:#fff5e9;border-radius:10px;font-size:13px;font-weight:800;color:#793a17\">CANCELLED BOOKING · INVOICE ARCHIVED · NOT PAYABLE<br><small style=\"font-size:11px;font-weight:500\">Original amounts are retained for audit only. No payment is due against this cancelled booking.</small></section>");
 } 
out.flush(); request.setAttribute("nlv_Module5_print__4", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_print__5", String.valueOf(model.Html.escape(inv.text("invoice_no"))));
request.setAttribute("nlv_Module5_print__6", String.valueOf(model.Html.escape(inv.text("shipment_no"))));
request.setAttribute("nlv_Module5_print__7", String.valueOf(model.Html.escape(inv.text("invoice_no"))));
request.setAttribute("nlv_Module5_print__8", String.valueOf(model.Html.escape(inv.text("shipment_no"))));
request.setAttribute("nlv_Module5_print__9", String.valueOf(model.Html.escape(inv.text("issue_date"))));
request.setAttribute("nlv_Module5_print__10", String.valueOf(model.Html.escape(inv.text("due_date"))));
request.setAttribute("nlv_Module5_print__11", String.valueOf(model.Html.escape(inv.text("seller_name"))));
request.setAttribute("nlv_Module5_print__12", String.valueOf(model.Html.escape(inv.text("consumer_name"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 int chargeCount=0;for(Row row:items){if(row.get("item_id")==null)continue;chargeCount++; 
out.write("\n<tr><td>");
out.print(model.Html.escape(row.text("item_type")));
out.write("</td><td class=\"desc\">");
out.print(model.Html.escape(row.text("description")));
out.write("</td><td class=\"number\">");
out.print(model.Html.escape(row.text("quantity")));
out.write("</td><td class=\"number\">");
out.print(model.Html.escape(row.text("unit_price")));
out.write("</td><td class=\"number\">");
out.print(model.Html.escape(row.text("amount")));
out.write("</td></tr>");
 }if(chargeCount==0){ 
out.write("<tr><td colspan=\"5\">Itemized charges are not available for this record.</td></tr>");
 } 
out.flush(); request.setAttribute("nlv_Module5_print__13", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module5_print__14", String.valueOf(model.Html.escape(inv.text("sub_total"))));
request.setAttribute("nlv_Module5_print__15", String.valueOf(model.Html.escape(inv.text("tax_amount"))));
request.setAttribute("nlv_Module5_print__16", String.valueOf(model.Html.escape(inv.text("total_amount"))));
request.setAttribute("nlv_Module5_print__17", String.valueOf(model.Html.escape(inv.text("paid_amount"))));
request.setAttribute("nlv_Module5_print__18", String.valueOf(cancelled?"Historical balance":"Balance due"));
request.setAttribute("nlv_Module5_print__19", String.valueOf(model.Html.escape(inv.text("balance"))));
request.setAttribute("nlv_Module5_print__20", String.valueOf(cancelled?"Booking status: ":"Payment status: "+(overdue?"OVERDUE · ":"")));
request.setAttribute("nlv_Module5_print__21", String.valueOf(cancelled?"CANCELLED":model.Html.escape(inv.text("status"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(!payments.isEmpty()){ 
out.write("\n  ");
out.print(payments.size());
out.write(" recorded payment(s). Latest transaction: ");
out.print(model.Html.escape(payments.get(0).text("payment_date")));
out.write(" ·\n  ");
out.print(model.Html.escape(payments.get(0).text("payment_mode")));
out.write(" · Reference ");
out.print(model.Html.escape(payments.get(0).text("reference_no")));
out.write(".<br>\n");
 }else{ 
out.write("No payment has been recorded yet.<br>");
 } 
out.flush(); request.setAttribute("nlv_Module5_print__22", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(payOnDelivery){ 
out.write("Pay-on-delivery was requested. The original invoice due date is unchanged; any alternative terms require Seller agreement.");
 } 
out.flush(); request.setAttribute("nlv_Module5_print__23", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module6_analytics(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 request.setAttribute("nlActiveModule", "Module6"); request.setAttribute("nlPageTitle", "Business analytics"); 
request.setAttribute("nlv_Module6_analytics__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));

    // Names for forecast table only; sourced from the same permitted port options as filters.
    java.util.Map<Integer,String> nlAnalyticsPortNames = new java.util.LinkedHashMap<>();
    for(java.util.Map<String,Object> option : model.JspSupport.maps(request.getAttribute("analyticsPorts"))){
        try{
            int portId=Integer.parseInt(String.valueOf(option.get("id")));
            nlAnalyticsPortNames.put(portId,String.valueOf(option.get("label")));
        }catch(NumberFormatException ignored){ /* No invalid ID is displayed. */ }
    }

request.setAttribute("nlv_Module6_analytics__2", String.valueOf(model.JspSupport.length(request.getAttribute("salesList"))));
request.setAttribute("nlv_Module6_analytics__3", String.valueOf(model.JspSupport.length(request.getAttribute("abcList"))));
request.setAttribute("nlv_Module6_analytics__4", String.valueOf(model.JspSupport.length(request.getAttribute("inventoryList"))));
request.setAttribute("nlv_Module6_analytics__5", String.valueOf(model.JspSupport.length(request.getAttribute("profitabilityList"))));
request.setAttribute("nlv_Module6_analytics__6", String.valueOf(model.JspSupport.length(request.getAttribute("forecastList"))));
request.setAttribute("nlv_Module6_analytics__7", String.valueOf(model.JspSupport.length(request.getAttribute("profitLossList"))));
request.setAttribute("nlv_Module6_analytics__8", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_Module6_analytics__9", String.valueOf(model.Html.escape(request.getAttribute("reportFrom"))));
request.setAttribute("nlv_Module6_analytics__10", String.valueOf(model.Html.escape(request.getAttribute("reportTo"))));
request.setAttribute("nlv_Module6_analytics__11", String.valueOf(model.Html.escape(request.getContextPath())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if((request.getParameter("origin")!=null&&!request.getParameter("origin").trim().isEmpty())||(request.getParameter("dest")!=null&&!request.getParameter("dest").trim().isEmpty())||(request.getParameter("company")!=null&&!request.getParameter("company").trim().isEmpty())){ 
out.write(" open=\"open\"");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__12", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> port:model.JspSupport.maps(request.getAttribute("analyticsPorts"))){String id=String.valueOf(port.get("id")); 
out.write("<option value=\"");
out.print(model.Html.escape(id));
out.write("\" ");
out.print(id.equals(String.valueOf(request.getAttribute("analyticsOrigin")))?"selected":"");
out.write(">");
out.print(model.Html.escape(port.get("label")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__13", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(java.util.Map<String,Object> port:model.JspSupport.maps(request.getAttribute("analyticsPorts"))){String id=String.valueOf(port.get("id")); 
out.write("<option value=\"");
out.print(model.Html.escape(id));
out.write("\" ");
out.print(id.equals(String.valueOf(request.getAttribute("analyticsDest")))?"selected":"");
out.write(">");
out.print(model.Html.escape(port.get("label")));
out.write("</option>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__14", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("ADMIN".equals(request.getAttribute("analyticsRole"))){ 
out.write("<div class=\"col-md-3\"><label class=\"form-label\">Seller company</label><select class=\"form-select\" name=\"company\"><option value=\"\">All companies</option>");
 for(model.Company c:model.JspSupport.typed(request.getAttribute("analyticsCompanies"),model.Company.class))if("SELLER".equals(c.getCompanyType())){String id=String.valueOf(c.getCompanyId()); 
out.write("<option value=\"");
out.print(id);
out.write("\" ");
out.print(id.equals(String.valueOf(request.getAttribute("analyticsCompany")))?"selected":"");
out.write(">");
out.print(model.Html.escape(c.getCompanyName()));
out.write("</option>");
 } 
out.write("</select></div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__15", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(session.getAttribute("analyticsFlash")!=null){ 
out.write("<div class=\"alert alert-success\" role=\"status\">");
out.print(model.Html.escape(session.getAttribute("analyticsFlash")));
out.write("</div>");
 session.removeAttribute("analyticsFlash"); } 
out.flush(); request.setAttribute("nlv_Module6_analytics__16", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 model.DashboardSummary kpi=(model.DashboardSummary)request.getAttribute("kpiSummary");if(kpi!=null){ 
out.write("\n        <div class=\"nl-ops-kpis\">\n          <div class=\"nl-ops-kpi\"><small>Shipments in progress</small><strong>");
out.print(kpi.getActiveShipments());
out.write("</strong></div>\n          <div class=\"nl-ops-kpi\"><small>Invoices awaiting payment</small><strong>");
out.print(kpi.getOpenInvoices());
out.write("</strong></div>\n          <div class=\"nl-ops-kpi\"><small>Claims to review</small><strong>");
out.print(kpi.getOpenClaims());
out.write("</strong></div>\n          <div class=\"nl-ops-kpi\"><small>Payments recorded</small><strong>₹");
out.print(model.Html.escape(kpi.getRecordedPayments()));
out.write("</strong></div>\n        </div>\n        <div class=\"nl-ops-links\"><span class=\"badge text-bg-warning\">Available containers: ");
out.print(kpi.getAvailableContainers());
out.write("</span>\n         <a href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/containerMovement?action=shipments\">View shipments</a>\n         <a href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/billing?action=outstanding\">Check unpaid invoices</a>\n         <a href=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/ClaimController?action=list\">Review claims</a>\n        </div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__17", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("ADMIN".equals(request.getAttribute("analyticsRole"))){ 
out.write("\n        <details class=\"nl-action-drawer\"><summary>Admin tools — update sales reports or estimate demand</summary><div class=\"nl-action-drawer-inner\">\n        <form method=\"post\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/analytics\" class=\"d-flex gap-2 flex-wrap align-items-center\">\n           <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\"><input type=\"hidden\" name=\"action\" value=\"refreshSalesCache\">\n           <button class=\"btn btn-warning\" type=\"submit\">Update sales report</button><span class=\"small text-muted\">Refresh sales aggregates from recorded transactions.</span>\n        </form>\n        <form method=\"post\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/analytics\" class=\"mt-4 border-top pt-3\">\n         <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\"><input type=\"hidden\" name=\"action\" value=\"baselineForecast\">\n         <h6 class=\"fw-bold\">Create demand estimate</h6><p class=\"small text-muted\">Uses recent shipment history and available containers. This is a rule-based estimate, not a trained ML prediction.</p>\n         <div class=\"row g-2 align-items-end\"><div class=\"col-md-3\"><label class=\"form-label\">Origin</label><select class=\"form-select\" name=\"origin\" required><option value=\"\">Origin port</option>");
 for(java.util.Map<String,Object> p:model.JspSupport.maps(request.getAttribute("analyticsPorts"))){ 
out.write("<option value=\"");
out.print(model.Html.escape(p.get("id")));
out.write("\">");
out.print(model.Html.escape(p.get("label")));
out.write("</option>");
 } 
out.write("</select></div>\n         <div class=\"col-md-3\"><label class=\"form-label\">Destination</label><select class=\"form-select\" name=\"dest\" required><option value=\"\">Destination port</option>");
 for(java.util.Map<String,Object> p:model.JspSupport.maps(request.getAttribute("analyticsPorts"))){ 
out.write("<option value=\"");
out.print(model.Html.escape(p.get("id")));
out.write("\">");
out.print(model.Html.escape(p.get("label")));
out.write("</option>");
 } 
out.write("</select></div>\n         <div class=\"col-md-2\"><label class=\"form-label\">Container type</label><select class=\"form-select\" name=\"containerType\"><option>DRY</option><option>REEFER</option><option>OPEN_TOP</option><option>TANK</option></select></div><div class=\"col-md-2\"><label class=\"form-label\">Forecast month</label><input type=\"date\" class=\"form-control\" name=\"month\" required title=\"Use the first day of the target month\"></div><div class=\"col-md-2\"><button class=\"btn btn-outline-warning w-100\">Generate estimate</button></div></div>\n        </form></div></details>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__18", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("SELLER".equals(request.getAttribute("analyticsRole")) && !model.JspSupport.typed(request.getAttribute("forecastList"),model.DemandForecast.class).isEmpty()){ 
out.write("\n       <details class=\"nl-action-drawer\"><summary>Seller tools — update shipping rates from a reviewed forecast</summary><div class=\"nl-action-drawer-inner\"><h5 class=\"fw-bold mb-2\">Apply a reviewed demand forecast</h5><p class=\"text-muted small\">Select a forecast and matching pricing rule. The forecast must already exist in your authorized records. The change uses the audited pricing update operation.</p>\n       <form method=\"post\" action=\"");
out.print(model.Html.escape(request.getContextPath()));
out.write("/analytics\" class=\"row g-2 align-items-end\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(model.Html.escape(session.getAttribute("csrfToken")));
out.write("\"><input type=\"hidden\" name=\"action\" value=\"applyMultiplier\">\n       <div class=\"col-md-5\"><label class=\"form-label\">Forecast</label><select name=\"forecastId\" class=\"form-select\" required><option value=\"\">Select verified forecast</option>");
 for(model.DemandForecast f:model.JspSupport.typed(request.getAttribute("forecastList"),model.DemandForecast.class)){ 
out.write("<option value=\"");
out.print(f.getForecastId());
out.write("\">#");
out.print(f.getForecastId());
out.write(" · ");
out.print(f.getOriginPortId());
out.write(" → ");
out.print(f.getDestPortId());
out.write(" · ");
out.print(model.Html.escape(f.getContainerType()));
out.write(" · x");
out.print(model.Html.escape(f.getSuggestedMultiplier()));
out.write("</option>");
 } 
out.write("</select></div>\n       <div class=\"col-md-5\"><label class=\"form-label\">Pricing rule</label><select name=\"ruleId\" class=\"form-select\" required><option value=\"\">Select matching rule</option>");
 for(java.util.Map<String,Object> pr:model.JspSupport.maps(request.getAttribute("pricingChoices"))){ 
out.write("<option value=\"");
out.print(model.Html.escape(pr.get("rule_id")));
out.write("\">#");
out.print(model.Html.escape(pr.get("rule_id")));
out.write(" · ");
out.print(model.Html.escape(pr.get("origin_port_id")));
out.write(" → ");
out.print(model.Html.escape(pr.get("dest_port_id")));
out.write(" · ");
out.print(model.Html.escape(pr.get("container_type")));
out.write("</option>");
 } 
out.write("</select></div>\n       <div class=\"col-md-2\"><button class=\"btn btn-outline-warning w-100\">Apply &amp; audit</button></div></form></div></details>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__19", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 { boolean __chosen1 = false; 
out.write("\n\n                           ");
 if (!__chosen1 && model.JspSupport.truth(pageContext,"${not empty salesList}")) { __chosen1=true; 
out.write("\n\n                               ");
 java.util.List<?> __list3 = model.JspSupport.list(model.JspSupport.value(pageContext,"${salesList}")); for (int __i3 = 0; __i3 < __list3.size(); __i3++) { pageContext.setAttribute("s", __list3.get(__i3)); 
out.write("\n\n                                   <tr>\n\n                                       <td>");
out.print(value(pc, "${s.periodMonth}"));
out.write("</td>\n\n                                       <td>");
out.print(model.Html.escape(value(pc, "${s.groupCode}")));
out.write("</td>\n\n                                       <td>");
out.print(model.Html.escape(value(pc, "${s.groupName}")));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${s.totalSales}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${s.totalQty}"));
out.write("</td>\n\n                                       <td>");
if(value(pc,"${s.growthPct}")!=null){
 out.print(model.Html.escape(value(pc,"${s.growthPct}")));
 out.write("%");
}else{
 out.write("<span class=\"nl-growth-unavailable\" title=\"No sales data in the immediately preceding calendar month\">—</span>");
}
out.write("</td>\n\n                                   </tr>\n\n                               ");
 } 
out.write("\n\n                           ");
 } 
out.write("\n\n                           ");
 if (!__chosen1) { 
out.write("\n\n                               <tr>\n\n                                   <td colspan=\"6\" class=\"no-data\">\n\n                                       No sales trend records available.\n\n                                   </td>\n\n                               </tr>\n\n                           ");
 } 
out.write("\n\n                       ");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__20", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("salesList"))==0){ 
out.write("disabled=\"disabled\"");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__21", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("salesList"))>0){ 
out.write("<div class=\"nl-report-chart-frame\"><canvas id=\"nlAnalyticsSales\" role=\"img\" aria-label=\"Sales by month; all source records are listed in the adjacent table\"></canvas></div><div class=\"nl-chart-fallback\" data-nl-fallback-for=\"nlAnalyticsSales\" hidden=\"hidden\" role=\"status\">Chart unavailable. The report table remains available.</div>");
 }else{ 
out.write("<div class=\"nl-chart-empty\" role=\"status\">No sales records match this selection. Try clearing the date, route or company filters.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__22", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 { boolean __chosen9 = false; 
out.write("\n\n                           ");
 if (!__chosen9 && model.JspSupport.truth(pageContext,"${not empty abcList}")) { __chosen9=true; 
out.write("\n\n                               ");
 java.util.List<?> __list11 = model.JspSupport.list(model.JspSupport.value(pageContext,"${abcList}")); for (int __i11 = 0; __i11 < __list11.size(); __i11++) { pageContext.setAttribute("a", __list11.get(__i11)); 
out.write("\n\n                                   <tr>\n\n                                       <td>Product #");
out.print(value(pc, "${a.productId}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${a.annualValue}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${a.cumulativePct}"));
out.write("%</td>\n\n                                       <td>\n\n                                           ");
 { boolean __chosen12 = false; 
out.write("\n\n                                               ");
 if (!__chosen12 && model.JspSupport.truth(pageContext,"${a.abcClass == 'A'}")) { __chosen12=true; 
out.write("\n\n                                                   <span class=\"class-badge class-a\">\n\n                                                       Class A\n\n                                                   </span>\n\n                                               ");
 } 
out.write("\n\n                                               ");
 if (!__chosen12 && model.JspSupport.truth(pageContext,"${a.abcClass == 'B'}")) { __chosen12=true; 
out.write("\n\n                                                   <span class=\"class-badge class-b\">\n\n                                                       Class B\n\n                                                   </span>\n\n                                               ");
 } 
out.write("\n\n                                               ");
 if (!__chosen12) { 
out.write("\n\n                                                   <span class=\"class-badge class-c\">\n\n                                                       Class C\n\n                                                   </span>\n\n                                               ");
 } 
out.write("\n\n                                           ");
 } 
out.write("\n\n                                       </td>\n\n                                   </tr>\n\n                               ");
 } 
out.write("\n\n                           ");
 } 
out.write("\n\n                           ");
 if (!__chosen9) { 
out.write("\n\n                               <tr>\n\n                                   <td colspan=\"4\" class=\"no-data\">\n\n                                       No ABC classification records available.\n\n                                   </td>\n\n                               </tr>\n\n                           ");
 } 
out.write("\n\n                       ");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__23", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("abcList"))==0){ 
out.write("disabled=\"disabled\"");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__24", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("abcList"))>0){ 
out.write("<div class=\"nl-report-chart-frame nl-donut-frame\"><canvas id=\"nlAnalyticsABC\" role=\"img\" aria-label=\"ABC product mix; all source records are listed in the adjacent table\"></canvas></div><div class=\"nl-chart-fallback\" data-nl-fallback-for=\"nlAnalyticsABC\" hidden=\"hidden\" role=\"status\">Chart unavailable. The report table remains available.</div>");
 }else{ 
out.write("<div class=\"nl-chart-empty\" role=\"status\">No ABC classification results are available. Check that product classification records have been generated; date and route filters do not create these results.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__25", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 { boolean __chosen25 = false; 
out.write("\n\n                           ");
 if (!__chosen25 && model.JspSupport.truth(pageContext,"${not empty inventoryList}")) { __chosen25=true; 
out.write("\n\n                               ");
 java.util.List<?> __list27 = model.JspSupport.list(model.JspSupport.value(pageContext,"${inventoryList}")); for (int __i27 = 0; __i27 < __list27.size(); __i27++) { pageContext.setAttribute("i", __list27.get(__i27)); 
out.write("\n\n                                   <tr>\n\n                                       <td>Product #");
out.print(value(pc, "${i.productId}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${i.cogs}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${i.avgInventory}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${i.turnoverRatio}"));
out.write("x</td>\n\n                                   </tr>\n\n                               ");
 } 
out.write("\n\n                           ");
 } 
out.write("\n\n                           ");
 if (!__chosen25) { 
out.write("\n\n                               <tr>\n\n                                   <td colspan=\"4\" class=\"no-data\">\n\n                                       No inventory turnover records available.\n\n                                   </td>\n\n                               </tr>\n\n                           ");
 } 
out.write("\n\n                       ");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__26", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("inventoryList"))==0){ 
out.write("disabled=\"disabled\"");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__27", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("inventoryList"))>0){ 
out.write("<div class=\"nl-report-chart-frame\"><canvas id=\"nlAnalyticsInventory\" role=\"img\" aria-label=\"Stock usage &amp; turnover; all source records are listed in the adjacent table\"></canvas></div><div class=\"nl-chart-fallback\" data-nl-fallback-for=\"nlAnalyticsInventory\" hidden=\"hidden\" role=\"status\">Chart unavailable. The report table remains available.</div>");
 }else{ 
out.write("<div class=\"nl-chart-empty\" role=\"status\">No inventory turnover results are available for this reporting period. Check the stored turnover results or try a wider date range.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__28", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 { boolean __chosen33 = false; 
out.write("\n\n                           ");
 if (!__chosen33 && model.JspSupport.truth(pageContext,"${not empty profitabilityList}")) { __chosen33=true; 
out.write("\n\n                               ");
 java.util.List<?> __list35 = model.JspSupport.list(model.JspSupport.value(pageContext,"${profitabilityList}")); for (int __i35 = 0; __i35 < __list35.size(); __i35++) { pageContext.setAttribute("p", __list35.get(__i35)); 
out.write("\n\n                                   <tr>\n\n                                       <td>Product #");
out.print(value(pc, "${p.productId}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${p.periodMonth}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${p.revenue}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${p.cost}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${p.marginPct}"));
out.write("%</td>\n\n                                   </tr>\n\n                               ");
 } 
out.write("\n\n                           ");
 } 
out.write("\n\n                           ");
 if (!__chosen33) { 
out.write("\n\n                               <tr>\n\n                                   <td colspan=\"5\" class=\"no-data\">\n\n                                       No profitability records available.\n\n                                   </td>\n\n                               </tr>\n\n                           ");
 } 
out.write("\n\n                       ");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__29", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("profitabilityList"))==0){ 
out.write("disabled=\"disabled\"");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__30", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("profitabilityList"))>0){ 
out.write("<div class=\"nl-report-chart-frame\"><canvas id=\"nlAnalyticsProductProfit\" role=\"img\" aria-label=\"Revenue, cost &amp; margin; all source records are listed in the adjacent table\"></canvas></div><div class=\"nl-chart-fallback\" data-nl-fallback-for=\"nlAnalyticsProductProfit\" hidden=\"hidden\" role=\"status\">Chart unavailable. The report table remains available.</div>");
 }else{ 
out.write("<div class=\"nl-chart-empty\" role=\"status\">No product profitability results are available for this reporting period. Try a wider date range or another permitted seller.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__31", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 { boolean __chosen41 = false; 
out.write("\n\n                           ");
 if (!__chosen41 && model.JspSupport.truth(pageContext,"${not empty forecastList}")) { __chosen41=true; 
out.write("\n\n                               ");
 java.util.List<?> __list43 = model.JspSupport.list(model.JspSupport.value(pageContext,"${forecastList}")); for (int __i43 = 0; __i43 < __list43.size(); __i43++) { pageContext.setAttribute("d", __list43.get(__i43)); 
out.write("\n\n                                   <tr>\n\n                                       <td>");
out.print(model.Html.escape(nlAnalyticsPortNames.getOrDefault(((model.DemandForecast)pageContext.getAttribute("d")).getOriginPortId(),"Port #"+((model.DemandForecast)pageContext.getAttribute("d")).getOriginPortId())));
out.write("</td>\n\n                                       <td>");
out.print(model.Html.escape(nlAnalyticsPortNames.getOrDefault(((model.DemandForecast)pageContext.getAttribute("d")).getDestPortId(),"Port #"+((model.DemandForecast)pageContext.getAttribute("d")).getDestPortId())));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${d.containerType}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${d.forecastMonth}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${d.predictedBookings}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${d.confidencePct}"));
out.write("%</td>\n\n                                       <td>");
out.print(value(pc, "${d.suggestedMultiplier}"));
out.write("x</td>\n\n                                   </tr>\n\n                               ");
 } 
out.write("\n\n                           ");
 } 
out.write("\n\n                           ");
 if (!__chosen41) { 
out.write("\n\n                               <tr>\n\n                                   <td colspan=\"7\" class=\"no-data\">\n\n                                       No demand forecast records available.\n\n                                   </td>\n\n                               </tr>\n\n                           ");
 } 
out.write("\n\n                       ");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__32", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("forecastList"))==0){ 
out.write("disabled=\"disabled\"");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__33", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("forecastList"))>0){ 
out.write("<div class=\"nl-report-chart-frame\"><canvas id=\"nlAnalyticsForecast\" role=\"img\" aria-label=\"Expected bookings by route; all source records are listed in the adjacent table\"></canvas></div><div class=\"nl-chart-fallback\" data-nl-fallback-for=\"nlAnalyticsForecast\" hidden=\"hidden\" role=\"status\">Chart unavailable. The report table remains available.</div>");
 }else{ 
out.write("<div class=\"nl-chart-empty\" role=\"status\">No recorded demand forecasts match the selected route or company. An authorized Admin can generate a rule-based baseline above.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__34", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 { boolean __chosen49 = false; 
out.write("\n\n                           ");
 if (!__chosen49 && model.JspSupport.truth(pageContext,"${not empty profitLossList}")) { __chosen49=true; 
out.write("\n\n                               ");
 java.util.List<?> __list51 = model.JspSupport.list(model.JspSupport.value(pageContext,"${profitLossList}")); for (int __i51 = 0; __i51 < __list51.size(); __i51++) { pageContext.setAttribute("p", __list51.get(__i51)); 
out.write("\n\n                                   <tr>\n\n                                       <td>");
out.print(value(pc, "${p.shipmentId}"));
out.write("</td>\n\n                                       <td>");
out.print(value(pc, "${p.sellerId}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${p.revenue}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${p.freightCost}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${p.portCost}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${p.handlingCost}"));
out.write("</td>\n\n                                       <td>₹ ");
out.print(value(pc, "${p.claimLoss}"));
out.write("</td>\n\n                                       <td class=\"profit-value\">\n\n                                           ₹ ");
out.print(value(pc, "${p.netProfit}"));
out.write("\n\n                                       </td>\n\n                                   </tr>\n\n                               ");
 } 
out.write("\n\n                           ");
 } 
out.write("\n\n                           ");
 if (!__chosen49) { 
out.write("\n\n                               <tr>\n\n                                   <td colspan=\"8\" class=\"no-data\">\n\n                                       No profit and loss records available.\n\n                                   </td>\n\n                               </tr>\n\n                           ");
 } 
out.write("\n\n                       ");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__35", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("profitLossList"))==0){ 
out.write("disabled=\"disabled\"");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__36", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(model.JspSupport.length(request.getAttribute("profitLossList"))>0){ 
out.write("<div class=\"nl-report-chart-frame\"><canvas id=\"nlAnalyticsProfit\" role=\"img\" aria-label=\"Monthly revenue, costs &amp; profit; all source records are listed in the adjacent table\"></canvas></div><div class=\"nl-chart-fallback\" data-nl-fallback-for=\"nlAnalyticsProfit\" hidden=\"hidden\" role=\"status\">Chart unavailable. The report table remains available.</div>");
 }else{ 
out.write("<div class=\"nl-chart-empty\" role=\"status\">No profit and loss records match this selection. Try clearing the date, route or company filters.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module6_analytics__37", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module6_analytics__38", String.valueOf(request.getAttribute("salesChartJson")));
request.setAttribute("nlv_Module6_analytics__39", String.valueOf(request.getAttribute("abcChartJson")));
request.setAttribute("nlv_Module6_analytics__40", String.valueOf(request.getAttribute("profitChartJson")));
request.setAttribute("nlv_Module6_analytics__41", String.valueOf(request.getAttribute("inventoryChartJson")));
request.setAttribute("nlv_Module6_analytics__42", String.valueOf(request.getAttribute("productProfitChartJson")));
request.setAttribute("nlv_Module6_analytics__43", String.valueOf(request.getAttribute("forecastChartJson")));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module7_claim_details(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

String ctx=request.getContextPath();
String base=ctx+"/ClaimController";
String role=request.getAttribute("claimRole") instanceof String?(String)request.getAttribute("claimRole"):"";
boolean isConsumer="CONSUMER".equals(role),isSeller="SELLER".equals(role),isAdmin="ADMIN".equals(role);
String csrf=h(request.getAttribute("csrfToken"));
String msg=request.getParameter("msg");
String error=request.getAttribute("errorMessage") instanceof String?(String)request.getAttribute("errorMessage"):null;

Claim claim=(Claim)request.getAttribute("claim");
List<ClaimDocument> docs=typed(request.getAttribute("docs"),ClaimDocument.class);
List<ClaimStatusHistory> history=typed(request.getAttribute("history"),ClaimStatusHistory.class);
List<ClaimStockOption> stocks=typed(request.getAttribute("stockOptions"),ClaimStockOption.class);

boolean editable=isConsumer && "SUBMITTED".equals(claim.getStatus());
boolean reviewStart=isSeller && "SUBMITTED".equals(claim.getStatus());
boolean reviewDecision=isSeller && "UNDER_REVIEW".equals(claim.getStatus());
boolean canSettle=isSeller && ("APPROVED".equals(claim.getStatus())||"PARTIALLY_APPROVED".equals(claim.getStatus()));

request.setAttribute("nlv_Module7_claim_details__1", String.valueOf(h(claim.getClaimNo())));
 request.setAttribute("nlActiveModule", "Module7"); request.setAttribute("nlPageTitle", "Claim details"); 
request.setAttribute("nlv_Module7_claim_details__2", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
request.setAttribute("nlv_Module7_claim_details__3", String.valueOf(base));
request.setAttribute("nlv_Module7_claim_details__4", String.valueOf(h(claim.getClaimNo())));
request.setAttribute("nlv_Module7_claim_details__5", String.valueOf(h(claim.getClaimNo())));
request.setAttribute("nlv_Module7_claim_details__6", String.valueOf(statusBadgeClass(claim.getStatus())));
request.setAttribute("nlv_Module7_claim_details__7", String.valueOf(h(claim.getStatus()).replace('_',' ')));
request.setAttribute("nlv_Module7_claim_details__8", String.valueOf(base));
request.setAttribute("nlv_Module7_claim_details__9", String.valueOf(base));
request.setAttribute("nlv_Module7_claim_details__10", String.valueOf(claim.getClaimId()));
request.setAttribute("nlv_Module7_claim_details__11", String.valueOf(base));
request.setAttribute("nlv_Module7_claim_details__12", String.valueOf(claim.getClaimId()));
request.setAttribute("nlv_Module7_claim_details__13", String.valueOf(amt(claim.getClaimedAmount())));
request.setAttribute("nlv_Module7_claim_details__14", String.valueOf(amt(claim.getApprovedAmount())));
request.setAttribute("nlv_Module7_claim_details__15", String.valueOf("SUBMITTED".equals(claim.getStatus())?"Awaiting seller review":"UNDER_REVIEW".equals(claim.getStatus())?"Seller is reviewing":"SETTLED".equals(claim.getStatus())?"Settlement recorded":"View claim status and history"));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(editable){ 
out.write("\n                <section class=\"card border-danger-subtle rounded-4 p-3 mb-3\" aria-label=\"Delete submitted claim\"><div class=\"d-flex flex-wrap justify-content-between gap-3 align-items-center\"><h2 class=\"h6 fw-bold text-danger mb-0\">Delete submitted claim</h2><span class=\"badge bg-danger-subtle text-danger border\">SUBMITTED only</span></div>\n                <p class=\"small text-secondary mt-2\">Remove this unreviewed claim from active records. The claim and evidence will no longer be available in the workspace; the database retains protected history for audit.</p>\n                <form action=\"");
out.print(base);
out.write("\" method=\"post\"  data-nl-site-confirm=\"Remove this unreviewed claim from the workspace? Its history will be retained for audit, but the claim cannot be reopened here.\" data-nl-confirm-title=\"Delete submitted claim\">\n                <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\"><input type=\"hidden\" name=\"action\" value=\"delete\"><input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\">\n                <button type=\"submit\" class=\"btn btn-outline-danger\">Delete submitted claim</button></form></section>");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__16", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(error!=null){ 
out.write("\n            <div class=\"alert alert-danger alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Error:</strong> ");
out.print(h(error));
out.write("\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__17", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("submitted".equals(msg)){ 
out.write("\n            <div class=\"alert alert-success alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Claim Submitted Successfully:</strong> Your claim and uploaded evidence have been received and recorded in the database.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__18", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("evidence_added".equals(msg)){ 
out.write("\n            <div class=\"alert alert-success alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Evidence Uploaded:</strong> Additional supporting documentation has been saved to this claim.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__19", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("evidence_failed".equals(msg)){ 
out.write("\n            <div class=\"alert alert-warning alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Attachment Error:</strong> The claim was created, but the evidence attachment failed. You can re-upload it below.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__20", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("reviewed".equals(msg)||"updated".equals(msg)||"settled".equals(msg)||"comment_added".equals(msg)||"evidence_deleted".equals(msg)||"evidence_updated".equals(msg)){ 
out.write("\n            <div class=\"alert alert-success alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Success:</strong> Operation completed successfully.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__21", nlvString.toString());out=null;nlvString=null;

                String st = claim.getStatus();
                boolean stepSub = true;
                boolean stepRev = "UNDER_REVIEW".equals(st) || "APPROVED".equals(st) || "PARTIALLY_APPROVED".equals(st) || "SETTLED".equals(st) || "REJECTED".equals(st);
                boolean stepDec = "APPROVED".equals(st) || "PARTIALLY_APPROVED".equals(st) || "SETTLED".equals(st) || "REJECTED".equals(st);
                boolean stepSet = "SETTLED".equals(st);
            
request.setAttribute("nlv_Module7_claim_details__22", String.valueOf(stepSub?"completed":""));
request.setAttribute("nlv_Module7_claim_details__23", String.valueOf(stepRev?"completed":("SUBMITTED".equals(st)?"active":"")));
request.setAttribute("nlv_Module7_claim_details__24", String.valueOf(stepDec?"completed":("UNDER_REVIEW".equals(st)?"active":"")));
request.setAttribute("nlv_Module7_claim_details__25", String.valueOf("REJECTED".equals(st)?"Rejected":"Decision"));
request.setAttribute("nlv_Module7_claim_details__26", String.valueOf(stepSet?"completed":("APPROVED".equals(st)||"PARTIALLY_APPROVED".equals(st)?"active":"")));
request.setAttribute("nlv_Module7_claim_details__27", String.valueOf(h(claim.getShipmentNo())));
request.setAttribute("nlv_Module7_claim_details__28", String.valueOf(claim.getShipmentId()));
request.setAttribute("nlv_Module7_claim_details__29", String.valueOf(amt(claim.getClaimedAmount())));
request.setAttribute("nlv_Module7_claim_details__30", String.valueOf(amt(claim.getApprovedAmount())));
request.setAttribute("nlv_Module7_claim_details__31", String.valueOf(h(claim.getClaimType())));
request.setAttribute("nlv_Module7_claim_details__32", String.valueOf(claim.getRaisedAt()==null?"—":h(claim.getRaisedAt())));
request.setAttribute("nlv_Module7_claim_details__33", String.valueOf(claim.getClaimId()));
request.setAttribute("nlv_Module7_claim_details__34", String.valueOf(claim.getContainerId()==null?"Not Specified":claim.getContainerId()));
request.setAttribute("nlv_Module7_claim_details__35", String.valueOf(claim.getRaisedAt()==null?"—":h(claim.getRaisedAt())));
request.setAttribute("nlv_Module7_claim_details__36", String.valueOf(claim.getSettledAt()==null?"Pending Settlement":h(claim.getSettledAt())));
request.setAttribute("nlv_Module7_claim_details__37", String.valueOf(statusBadgeClass(claim.getStatus())));
request.setAttribute("nlv_Module7_claim_details__38", String.valueOf(h(claim.getStatus()).replace('_',' ')));
request.setAttribute("nlv_Module7_claim_details__39", String.valueOf(h(claim.getDescription())));
request.setAttribute("nlv_Module7_claim_details__40", String.valueOf(claim.getSellerRemarks()==null?"<em>Awaiting seller review and inspection remarks.</em>":h(claim.getSellerRemarks())));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(editable){ 
out.write("\n                <section class=\"card shadow-sm rounded-4 border-warning-subtle mb-4 p-4\" aria-label=\"Edit submitted claim\">\n                 <h5 class=\"fw-bold mb-1\">Edit submitted claim</h5><p class=\"text-muted small\">Allowed only before seller review. Changes are validated by the database.</p>\n                 <form action=\"");
out.print(base);
out.write("\" method=\"post\" class=\"row g-3\">\n                 <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\"><input type=\"hidden\" name=\"action\" value=\"update_field\"><input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\">\n                 <div class=\"col-md-4\"><label class=\"form-label\">Update field</label><select class=\"form-select\" name=\"field_name\" id=\"nlClaimField\"><option value=\"description\">Description</option><option value=\"claim_type\">Claim type</option><option value=\"claimed_amount\">Claimed amount</option><option value=\"container_id\">Container ID</option></select></div>\n                 <div class=\"col-md-8\"><label class=\"form-label\">New value</label><input name=\"new_value\" class=\"form-control\" maxlength=\"255\" required placeholder=\"Enter corrected information\"><div class=\"form-text\">Claim type must be LOSS, DAMAGE, DELAY or SHORTAGE.</div></div>\n                 <div class=\"col-12\"><button class=\"btn btn-warning px-4\">Save claim change</button></div></form>\n                </section>");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__41", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_claim_details__42", String.valueOf(docs.size()));
request.setAttribute("nlv_Module7_claim_details__43", String.valueOf(docs.size()==1?"":"s"));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(docs.isEmpty()){ 
out.write("\n                        <div class=\"text-center py-4 text-muted bg-light rounded-3 border\">\n                            <div><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0zIDdhMiAyIDAgMCAxIDItMmg1bDIgMmg3YTIgMiAwIDAgMSAyIDJ2MTBIM3oiLz48L3N2Zz4=\" width=\"20\" height=\"20\" alt=\"\" aria-hidden=\"true\" class=\"me-1\"></div>\n                            <div class=\"fw-bold mt-2\">No evidence documents attached</div>\n                            <small>No inspection photos or survey receipts were submitted with this claim.</small>\n                        </div>\n                    ");
 } else { 
out.write("\n                        <div class=\"mb-3\">\n                            <small class=\"text-muted d-block mb-2\">The following supporting files were submitted for cargo inspection (uploaded does not mean independently verified):</small>\n                            ");
 for(ClaimDocument d: docs) {
                                boolean downloadable = d.getFilePath() != null && d.getFilePath().matches("[0-9a-f]{32}\\.(pdf|jpg|png)");
                                String fileType = d.getFileType() != null ? d.getFileType().toUpperCase() : "FILE";
                            
out.write("\n                                <div class=\"evidence-item-card\">\n                                    <div class=\"d-flex align-items-center justify-content-between flex-wrap gap-2\">\n                                        <div class=\"d-flex align-items-center gap-3\">\n                                            <div>\n                                                ");
 if("PDF".equals(fileType)) { 
out.write("<img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjQiIHk9IjIiIHdpZHRoPSIxNiIgaGVpZ2h0PSIyMCIgcng9IjIiLz48cGF0aCBkPSJNOCA4aDhNOCAxMmg4TTggMTZoNiIvPjwvc3ZnPg==\" width=\"20\" height=\"20\" alt=\"\" aria-hidden=\"true\" class=\"me-1\">");
 } else { 
out.write("<img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjMiIHk9IjMiIHdpZHRoPSIxOCIgaGVpZ2h0PSIxOCIgcng9IjIiLz48Y2lyY2xlIGN4PSI4IiBjeT0iOCIgcj0iMiIvPjxwYXRoIGQ9Im0zIDE3IDYtNiA0IDQgMy0zIDUgNSIvPjwvc3ZnPg==\" width=\"20\" height=\"20\" alt=\"\" aria-hidden=\"true\" class=\"me-1\">");
 } 
out.write("\n                                            </div>\n                                            <div>\n                                                <div class=\"fw-bold text-dark mb-0\">");
out.print(h(d.getFileName()));
out.write("</div>\n                                                <div class=\"d-flex align-items-center gap-2 mt-1\">\n                                                    <span class=\"badge bg-secondary-subtle text-secondary\">");
out.print(h(fileType));
out.write("</span>\n                                                    <small class=\"text-muted\">Uploaded: ");
out.print(h(d.getUploadedAt()));
out.write("</small>\n                                                </div>\n                                            </div>\n                                        </div>\n                                        <div class=\"d-flex align-items-center gap-2\">\n                                            ");
 if(downloadable){ 
out.write("\n                                                <a class=\"btn btn-outline-warning btn-sm\" target=\"_blank\" rel=\"noopener\" href=\"");
out.print(base);
out.write("?action=preview&amp;claim_id=");
out.print(claim.getClaimId());
out.write("&amp;cdoc_id=");
out.print(d.getCdocId());
out.write("\">View evidence</a>\n                                                <a class=\"btn btn-outline-dark btn-sm py-1 px-3\" href=\"");
out.print(base);
out.write("?action=download&amp;claim_id=");
out.print(claim.getClaimId());
out.write("&amp;cdoc_id=");
out.print(d.getCdocId());
out.write("\">\n                                                    <img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0yIDEyczQtNiAxMC02IDEwIDYgMTAgNi00IDYtMTAgNlMyIDEyIDIgMTJ6Ii8+PGNpcmNsZSBjeD0iMTIiIGN5PSIxMiIgcj0iMyIvPjwvc3ZnPg==\" width=\"20\" height=\"20\" alt=\"\" aria-hidden=\"true\" class=\"me-1\"> Download\n                                                </a>\n                                            ");
 } else { 
out.write("\n                                                <span class=\"badge bg-light text-muted\">Path unavailable</span>\n                                            ");
 } 
out.write("\n\n                                            ");
 if(editable){ 
out.write("\n                                                <details class=\"nl-evidence-rename\">\n                                                  <summary class=\"btn btn-warning btn-sm nl-evidence-solid-action\" aria-label=\"Rename ");
out.print(h(d.getFileName()));
out.write("\">Rename</summary>\n                                                  <form action=\"");
out.print(base);
out.write("\" method=\"post\" class=\"nl-evidence-rename-editor\">\n                                                    <input type=\"hidden\" name=\"action\" value=\"update_doc\"><input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\"><input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\"><input type=\"hidden\" name=\"cdoc_id\" value=\"");
out.print(d.getCdocId());
out.write("\"><input type=\"hidden\" name=\"field_name\" value=\"file_name\">\n                                                    <label class=\"form-label small fw-bold\" for=\"nlRenameEvidence");
out.print(d.getCdocId());
out.write("\">New filename</label>\n                                                    <input id=\"nlRenameEvidence");
out.print(d.getCdocId());
out.write("\" class=\"form-control form-control-sm\" name=\"new_value\" value=\"");
out.print(h(d.getFileName()));
out.write("\" maxlength=\"150\" required>\n                                                    <button type=\"submit\" class=\"btn btn-warning btn-sm\">Save filename</button>\n                                                  </form>\n                                                </details>\n                                                <!-- Consumer can rename or delete while claim is still SUBMITTED -->\n                                                <form action=\"");
out.print(base);
out.write("\" method=\"post\" class=\"d-inline\">\n                                                    <input type=\"hidden\" name=\"action\" value=\"delete_doc\">\n                                                    <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\">\n                                                    <input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\">\n                                                    <input type=\"hidden\" name=\"cdoc_id\" value=\"");
out.print(d.getCdocId());
out.write("\">\n                                                    <button type=\"submit\" class=\"btn btn-warning btn-sm py-1 px-2 nl-evidence-solid-action\" title=\"Delete file\">Delete</button>\n                                                </form>\n                                            ");
 } 
out.write("\n                                        </div>\n                                    </div>\n                                </div>\n                            ");
 } 
out.write("\n                        </div>\n                    ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__44", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(isConsumer){ 
out.write("\n                        <div class=\"mt-3 pt-3 border-top\">\n                            <label class=\"form-label fw-bold text-dark small mb-2\">Upload Additional Evidence</label>\n                            <form action=\"");
out.print(base);
out.write("\" enctype=\"multipart/form-data\" method=\"post\">\n                                <input type=\"hidden\" name=\"action\" value=\"add_doc\">\n                                <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\">\n                                <input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\">\n                                <div class=\"nl-claim-upload-row\">\n                                    <input class=\"form-control\" type=\"file\" name=\"evidence_file\" data-nl18-file=\"true\" accept=\".pdf,.jpg,.jpeg,.png\" required>\n                                    <button class=\"btn btn-warning bg-gradient\" type=\"submit\">Upload File</button>\n                                </div>\n                                <div class=\"form-text text-muted\">PDF, JPG, PNG formats up to 10 MB accepted.</div>\n                            </form>\n                        </div>\n                    ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__45", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(reviewStart || reviewDecision){ 
out.write("\n                    <div class=\"nl-card border-warning-subtle card border-0 shadow-sm rounded-4 p-4 mb-4\">\n                        <h5 class=\"fw-bold mb-2 text-warning-emphasis\" >Seller Claim Review</h5>\n                        <p class=\"text-muted small mb-3\">Make a formal decision regarding this cargo claim.</p>\n\n                        <form method=\"post\" action=\"");
out.print(base);
out.write("\">\n                            <input type=\"hidden\" name=\"action\" value=\"update_status\">\n                            <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\">\n                            <input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\">\n\n                            <div class=\"mb-3\">\n                                <label class=\"form-label fw-bold small\">Decision</label>\n                                <select name=\"decision\" id=\"decision\" class=\"form-select\" required >\n                                    ");
 if(reviewStart){ 
out.write("\n                                        <option value=\"UNDER_REVIEW\">Begin Investigation (Under Review)</option>\n                                        <option value=\"REJECTED\">Reject Claim</option>\n                                    ");
 } 
out.write("\n                                    ");
 if(reviewDecision){ 
out.write("\n                                        <option value=\"APPROVED\">Approve Full Claim (₹");
out.print(amt(claim.getClaimedAmount()));
out.write(")</option>\n                                        <option value=\"PARTIALLY_APPROVED\">Partially Approve Claim</option>\n                                        <option value=\"REJECTED\">Reject Claim</option>\n                                    ");
 } 
out.write("\n                                </select>\n                            </div>\n\n                            <div class=\"mb-3\">\n                                <label class=\"form-label fw-bold small\">Approved Compensation (₹)</label>\n                                <input class=\"form-control\" type=\"number\" step=\"0.01\" min=\"0.01\" max=\"9999999999.99\" name=\"approved_amount\" id=\"approved_amount\" value=\"");
out.print(amt(claim.getClaimedAmount()));
out.write("\" data-nl-claim-full=\"");
out.print(amt(claim.getClaimedAmount()));
out.write("\">\n                                <div class=\"form-text text-muted\">Choosing Partial Approval suggests 50% of the claimed amount. You can change the suggested figure before saving.</div>\n                            </div>\n\n                            <div class=\"mb-3\">\n                                <label class=\"form-label fw-bold small\">Official Inspection Remarks <span class=\"text-danger\">*</span></label>\n                                <textarea name=\"remarks\" class=\"form-control\" required maxlength=\"255\" rows=\"3\" placeholder=\"Explain the decision rationale based on verified evidence...\"></textarea>\n                            </div>\n\n                            <button type=\"submit\" class=\"btn btn-warning bg-gradient w-100\">Submit Review Decision</button>\n                        </form>\n                    </div>\n                    \n                ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__46", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(canSettle){ 
out.write("\n                    <div class=\"nl-card border-success-subtle card border-0 shadow-sm rounded-4 p-4 mb-4 border-warning-subtle\">\n                        <h5 class=\"fw-bold mb-2 text-success\">Payment: Settle Approved Claim</h5>\n                        <p class=\"text-muted small mb-3\">Execute payout / ledger write-off through database transaction triggers.</p>\n\n                        <form method=\"post\" action=\"");
out.print(base);
out.write("\">\n                            <input type=\"hidden\" name=\"action\" value=\"settle\">\n                            <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\">\n                            <input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\">\n\n                            ");
 if(stocks != null && !stocks.isEmpty()){ 
out.write("\n                                <div class=\"mb-3\">\n                                    <label class=\"form-label fw-bold small\">Inventory / Stock Replacement (Optional)</label>\n                                    <select name=\"stock_id\" class=\"form-select\">\n                                        <option value=\"\">None / Direct Financial Payout</option>\n                                        ");
 for(ClaimStockOption stk: stocks){ 
out.write("\n                                            <option value=\"");
out.print(stk.getStockId());
out.write("\">");
out.print(h(stk.getProductName()));
out.write(" (Avail: ");
out.print(stk.getAvailable());
out.write(")</option>\n                                        ");
 } 
out.write("\n                                    </select>\n                                </div>\n                                <div class=\"mb-3\">\n                                    <label class=\"form-label fw-bold small\">Replacement Quantity</label>\n                                    <input type=\"number\" name=\"quantity\" min=\"1\" class=\"form-control\" placeholder=\"Qty\">\n                                </div>\n                            ");
 } 
out.write("\n\n                            <div class=\"mb-3\">\n                                <label class=\"form-label fw-bold small\">Settlement Remarks</label>\n                                <textarea name=\"remarks\" class=\"form-control\" rows=\"2\" placeholder=\"e.g. Compensation credited to bank / ledger write-off completed.\"></textarea>\n                            </div>\n\n                            <button type=\"submit\" class=\"btn btn-success w-100 fw-bold\">Execute Claim Settlement</button>\n                        </form>\n                    </div>\n                ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__47", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_claim_details__48", String.valueOf(history.size()));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(history.isEmpty()){ 
out.write("\n                        <div class=\"text-muted small text-center py-3\">No status events recorded yet.</div>\n                    ");
 } else { 
out.write("\n                        <div class=\"list-group list-group-flush mb-3\">\n                            ");
 for(ClaimStatusHistory r: history){ 
out.write("\n                                <div class=\"list-group-item px-0 py-2 border-bottom\">\n                                    <div class=\"d-flex justify-content-between align-items-center mb-1\">\n                                        <span class=\"badge bg-light text-dark border font-monospace\">\n                                            ");
out.print(h(r.getNewStatus()));
out.write("\n                                        </span>\n                                        <small class=\"text-muted\">");
out.print(h(r.getChangedAt()));
out.write("</small>\n                                    </div>\n                                    <div class=\"text-dark small\">");
out.print(h(r.getRemarks()));
out.write("</div>\n                                    <small class=\"text-muted\">By: ");
out.print(r.getChangedByName()==null?"System":h(r.getChangedByName()));
out.write("</small>\n                                </div>\n                            ");
 } 
out.write("\n                        </div>\n                    ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__49", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(!isAdmin){ 
out.write("\n                        <form action=\"");
out.print(base);
out.write("\" method=\"post\" class=\"nl-claim-comment-form mt-3\">\n                            <input type=\"hidden\" name=\"action\" value=\"comment\">\n                            <input type=\"hidden\" name=\"csrfToken\" value=\"");
out.print(csrf);
out.write("\">\n                            <input type=\"hidden\" name=\"claim_id\" value=\"");
out.print(claim.getClaimId());
out.write("\">\n                            <label class=\"form-label fw-bold small text-muted\">Post a Communication Comment</label>\n                            <div class=\"nl-claim-comment-row\">\n                                <textarea class=\"form-control\" name=\"comment\" rows=\"2\" maxlength=\"255\" placeholder=\"Add note or response...\" required></textarea>\n                                <button type=\"submit\" class=\"btn btn-outline-dark\">Send</button>\n                            </div>\n                        </form>\n                    ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claim_details__50", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_Module7_claims(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

String ctx=request.getContextPath();
String base=ctx+"/ClaimController";
String role=request.getAttribute("claimRole") instanceof String?(String)request.getAttribute("claimRole"):"";
boolean isConsumer="CONSUMER".equals(role),isSeller="SELLER".equals(role),isAdmin="ADMIN".equals(role);
String csrf=h(request.getAttribute("csrfToken"));
String msg=request.getParameter("msg");
String error=request.getAttribute("errorMessage") instanceof String?(String)request.getAttribute("errorMessage"):null;

List<Claim> claims=typed(request.getAttribute("claims"),Claim.class);
String selected=request.getAttribute("selectedStatus") instanceof String?(String)request.getAttribute("selectedStatus"):"ALL";
int submitted=0,review=0,approved=0,settled=0;
for(Claim c:claims){
    if("SUBMITTED".equals(c.getStatus())) submitted++;
    else if("UNDER_REVIEW".equals(c.getStatus())) review++;
    else if("APPROVED".equals(c.getStatus())||"PARTIALLY_APPROVED".equals(c.getStatus())) approved++;
    else if("SETTLED".equals(c.getStatus())) settled++;
}

 request.setAttribute("nlActiveModule", "Module7"); request.setAttribute("nlPageTitle", "Claims"); 
request.setAttribute("nlv_Module7_claims__1", String.valueOf(model.Html.escape(String.valueOf(request.getAttribute("nlPageTitle")==null?"Workspace":request.getAttribute("nlPageTitle")))));
request.setAttribute("nlv_Module7_claims__2", String.valueOf(ctx));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(isConsumer){ 
out.write("\n                    <a class=\"btn btn-warning bg-gradient btn-sm\" href=\"");
out.print(base);
out.write("?action=new\">\n                        + File New Claim\n                    </a>\n                ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__3", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_claims__4", String.valueOf(base));
request.setAttribute("nlv_Module7_claims__5", String.valueOf(h(selected)));
request.setAttribute("nlv_Module7_claims__6", String.valueOf(h(request.getAttribute("claimSearch"))));
request.setAttribute("nlv_Module7_claims__7", String.valueOf(h(request.getParameter("filedFrom"))));
request.setAttribute("nlv_Module7_claims__8", String.valueOf(h(request.getParameter("filedTo"))));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(error!=null){ 
out.write("\n            <div class=\"alert alert-danger alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Error:</strong> ");
out.print(h(error));
out.write("\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__9", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("deleted".equals(msg)){ 
out.write("\n            <div class=\"alert alert-success alert-dismissible fade show shadow-sm\" role=\"status\">\n                <strong>Claim removed:</strong> Your unreviewed claim has been removed from the workspace. Its protected audit history is retained.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__10", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("submitted".equals(msg)){ 
out.write("\n            <div class=\"alert alert-success alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Success!</strong> Your claim has been submitted with evidence successfully and is awaiting review.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__11", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("evidence_failed".equals(msg)){ 
out.write("\n            <div class=\"alert alert-warning alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Notice:</strong> Your claim record was created, but the evidence attachment could not be saved. You can upload it from the claim details page.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__12", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("reviewed".equals(msg)||"updated".equals(msg)||"settled".equals(msg)||"comment_added".equals(msg)||"evidence_added".equals(msg)||"evidence_deleted".equals(msg)||"evidence_updated".equals(msg)){ 
out.write("\n            <div class=\"alert alert-success alert-dismissible fade show shadow-sm\" role=\"alert\">\n                <strong>Success!</strong> Operation completed successfully.\n                <button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>\n            </div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__13", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(isSeller && submitted>0){ 
out.write("\n        <div class=\"alert alert-info\" role=\"status\"><strong>Review needed:</strong> ");
out.print(submitted);
out.write(" submitted claim");
out.print(submitted==1?"":"s");
out.write(" in the current results await Seller review. Use the status filter to open them.</div>\n        ");
 } else if(isConsumer && (review+approved+settled)>0){ 
out.write("\n        <div class=\"alert alert-info\" role=\"status\"><strong>Claim updates:</strong> ");
out.print(review);
out.write(" under review, ");
out.print(approved);
out.write(" approved or partially approved, and ");
out.print(settled);
out.write(" settled in the current results. Open claim details to read the recorded status history.</div>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__14", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_claims__15", String.valueOf(claims.size()));
request.setAttribute("nlv_Module7_claims__16", String.valueOf(submitted));
request.setAttribute("nlv_Module7_claims__17", String.valueOf(review));
request.setAttribute("nlv_Module7_claims__18", String.valueOf(approved+settled));
request.setAttribute("nlv_Module7_claims__19", String.valueOf(base));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String st: new String[]{"ALL","SUBMITTED","UNDER_REVIEW","APPROVED","PARTIALLY_APPROVED","REJECTED","SETTLED"}) { 
out.write("\n                            <option value=\"");
out.print(st);
out.write("\" ");
out.print(st.equalsIgnoreCase(selected)?"selected":"");
out.write(">");
out.print(st.replace('_',' '));
out.write("</option>\n                        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_claims__20", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(claims.isEmpty()) { 
out.write("\n                            <tr>\n                                <td colspan=\"8\" class=\"text-center py-4 text-muted\">\n                                    <div class=\"py-3\">\n                                        <div><img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0zIDdhMiAyIDAgMCAxIDItMmg1bDIgMmg3YTIgMiAwIDAgMSAyIDJ2MTBIM3oiLz48L3N2Zz4=\" width=\"20\" height=\"20\" alt=\"\" aria-hidden=\"true\" class=\"me-1\"></div>\n                                        <div class=\"fw-bold mt-2\">No claim records found</div>\n                                        <small>There are no claims matching the current filter criteria.</small>\n                                    </div>\n                                </td>\n                            </tr>\n                        ");
 } else { for(Claim c: claims) { 
out.write("\n                            <tr>\n                                <td>\n                                    <div class=\"nl-claim-id-wrap\">\n                                      <span class=\"claim-link nl-inline-copy\" role=\"button\" tabindex=\"0\" data-nl-copy-value=\"");
out.print(h(c.getClaimNo()));
out.write("\" aria-label=\"Copy claim number ");
out.print(h(c.getClaimNo()));
out.write("\" title=\"Click to copy claim number\">");
out.print(h(c.getClaimNo()));
out.write("</span>\n                                    </div>\n                                </td>\n                                <td><span class=\"nl-claim-shipment font-monospace\">");
out.print(h(c.getShipmentNo()));
out.write("</span></td>\n                                <td>\n                                    <span class=\"fw-semibold text-secondary\">\n                                        ");
 if("DAMAGE".equals(c.getClaimType())) { 
out.write("Shipment: Cargo Damage\n                                        ");
 } else if("LOSS".equals(c.getClaimType())) { 
out.write("Cargo Loss\n                                        ");
 } else if("DELAY".equals(c.getClaimType())) { 
out.write("Delivery Delay\n                                        ");
 } else { 
out.print(h(c.getClaimType()));
 } 
out.write("\n                                    </span>\n                                </td>\n                                <td class=\"text-end fw-bold text-dark\">₹");
out.print(amt(c.getClaimedAmount()));
out.write("</td>\n                                <td class=\"text-end fw-bold ");
out.print(c.getApprovedAmount()!=null&&c.getApprovedAmount().compareTo(BigDecimal.ZERO)>0?"text-success":"text-muted");
out.write("\">\n                                    ₹");
out.print(amt(c.getApprovedAmount()));
out.write("\n                                </td>\n                                <td>\n                                    <span class=\"badge rounded-pill ");
out.print(statusBadgeClass(c.getStatus()));
out.write(" px-2 py-1\">\n                                        ● ");
out.print(h(c.getStatus()).replace('_',' '));
out.write("\n                                    </span>\n                                </td>\n                                <td class=\"text-muted small nl-claim-datetime\">");
out.print(c.getRaisedAt()==null?"—":h(c.getRaisedAt()));
out.write("</td>\n                                <td class=\"text-center nl-noprint d-print-none\"><div class=\"nl-claim-actions\">\n                                    <a class=\"btn btn-outline-secondary btn-sm py-1 px-2\" href=\"");
out.print(base);
out.write("?action=view&amp;claim_id=");
out.print(c.getClaimId());
out.write("\">\n                                        View Details\n                                    </a>\n                                    <a class=\"btn btn-outline-dark btn-sm py-1 px-2\" href=\"");
out.print(base);
out.write("?action=view&amp;claim_id=");
out.print(c.getClaimId());
out.write("&amp;print=1\" title=\"Print claim report\">\n                                        <img src=\"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik02IDlWM2gxMnY2TTYgMThIM3YtOGgxOHY4aC0zTTYgMTRoMTJ2N0g2eiIvPjwvc3ZnPg==\" width=\"20\" height=\"20\" alt=\"\" aria-hidden=\"true\" class=\"me-1\"> Print report\n                                    </a></div>\n                                </td>\n                            </tr>\n                        ");
 } } 
out.flush(); request.setAttribute("nlv_Module7_claims__21", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_claims__22", String.valueOf(claims.size()));
return "";
}
@SuppressWarnings("unused")
private String prepare_Module7_index(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 response.sendRedirect(request.getContextPath() + "/ClaimController?action=list"); 
return "";
}
@SuppressWarnings("unused")
private String prepare_Module7_submit_claim(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

String ctx=request.getContextPath();
String base=ctx+"/ClaimController";
String csrf=h(request.getAttribute("csrfToken"));
String error=request.getAttribute("errorMessage") instanceof String?(String)request.getAttribute("errorMessage"):null;
List<ClaimShipmentOption> candidates=typed(request.getAttribute("claimShipmentCandidates"),ClaimShipmentOption.class);
int windowDays=request.getAttribute("claimWindowDays") instanceof Number?((Number)request.getAttribute("claimWindowDays")).intValue():30;
int eligibleCount=0;
for(ClaimShipmentOption c:candidates)if(c.isSelectable())eligibleCount++;
String selectedShipment=request.getParameter("shipment_id");
if(selectedShipment==null)selectedShipment=request.getParameter("shipmentId");
String oldClaimType=request.getParameter("claim_type");
String oldClaimAmount=request.getParameter("claimed_amount");
String oldDescription=request.getParameter("description");

 request.setAttribute("nlActiveModule", "Module7"); request.setAttribute("nlPageTitle", "File a claim"); 
request.setAttribute("nlv_Module7_submit_claim__1", String.valueOf(base));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(error!=null){ 
out.write("<div class=\"alert alert-danger\" role=\"alert\"><strong>Could not submit claim:</strong> ");
out.print(h(error));
out.write("</div>");
 } 
out.flush(); request.setAttribute("nlv_Module7_submit_claim__2", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_submit_claim__3", String.valueOf(windowDays));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(candidates.isEmpty()){ 
out.write("<div class=\"alert alert-warning\">No arrived or delivered shipments are available on this account. Check the shipment's movement status.</div>");
 } else if(eligibleCount==0){ 
out.write("<div class=\"alert alert-warning\">Your arrived or delivered shipments are outside the ");
out.print(windowDays);
out.write("-day filing window or have no recorded actual arrival date.</div>");
 } 
out.flush(); request.setAttribute("nlv_Module7_submit_claim__4", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_submit_claim__5", String.valueOf(base));
request.setAttribute("nlv_Module7_submit_claim__6", String.valueOf(csrf));
request.setAttribute("nlv_Module7_submit_claim__7", String.valueOf(eligibleCount==0?"disabled=\"disabled\"":""));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(ClaimShipmentOption s:candidates){
            String deadline=s.getActualArrival()==null?"":s.getActualArrival().toLocalDate().plusDays(windowDays).toString();
        
out.write("\n        <option value=\"");
out.print(s.getShipmentId());
out.write("\" ");
out.print(s.isSelectable()?"":"disabled=\"disabled\"");
out.write(" ");
out.print(s.isSelectable() && String.valueOf(s.getShipmentId()).equals(selectedShipment)?"selected=\"selected\"":"");
out.write("\n          data-number=\"");
out.print(h(s.getShipmentNo()));
out.write("\" data-status=\"");
out.print(h(s.getStatus()));
out.write("\" data-arrived=\"");
out.print(h(s.getActualArrival()));
out.write("\"\n          data-deadline=\"");
out.print(h(deadline));
out.write("\" data-cargo=\"");
out.print(h(s.getCargoValue()));
out.write("\" data-quote=\"");
out.print(h(s.getBookingQuote()));
out.write("\"\n          data-invoice=\"");
out.print(h(s.getInvoiceTotal()));
out.write("\" data-units=\"");
out.print(h(s.getCargoUnits()));
out.write("\"\n          data-origin=\"");
out.print(h(s.getOriginName()));
out.write("\" data-destination=\"");
out.print(h(s.getDestinationName()));
out.write("\"\n          data-seller=\"");
out.print(h(s.getSellerName()));
out.write("\" data-container=\"");
out.print(h(s.getContainerNumber()));
out.write("\">\n            ");
out.print(h(s.getShipmentNo()));
out.write(" — ");
out.print(h(s.getStatus()));
out.write(" — Arrived ");
out.print(h(s.getActualArrival()==null?"not recorded":s.getActualArrival()));
out.write("\n            ");
out.print(s.isSelectable()?"":" — Not eligible: "+h(s.getIneligibilityReason()));
out.write("\n        </option>\n        ");
 } 
out.flush(); request.setAttribute("nlv_Module7_submit_claim__8", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_Module7_submit_claim__9", String.valueOf(oldClaimType==null||"DAMAGE".equals(oldClaimType)?"selected=\"selected\"":""));
request.setAttribute("nlv_Module7_submit_claim__10", String.valueOf("LOSS".equals(oldClaimType)?"selected=\"selected\"":""));
request.setAttribute("nlv_Module7_submit_claim__11", String.valueOf("SHORTAGE".equals(oldClaimType)?"selected=\"selected\"":""));
request.setAttribute("nlv_Module7_submit_claim__12", String.valueOf("DELAY".equals(oldClaimType)?"selected=\"selected\"":""));
request.setAttribute("nlv_Module7_submit_claim__13", String.valueOf(h(oldClaimAmount)));
request.setAttribute("nlv_Module7_submit_claim__14", String.valueOf(h(oldDescription)));
request.setAttribute("nlv_Module7_submit_claim__15", String.valueOf(base));
request.setAttribute("nlv_Module7_submit_claim__16", String.valueOf(eligibleCount==0?"disabled=\"disabled\"":""));
return "";
}
@SuppressWarnings("unused")
private String prepare_shared__nav(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 if(request.getAttribute("nlActiveModule")==null)request.setAttribute("nlActiveModule", "profile".equals(request.getAttribute("activeNav")) ? "Module1" : "Module2");
   if(request.getAttribute("nlPageTitle")==null)request.setAttribute("nlPageTitle", "profile".equals(request.getAttribute("activeNav"))?"Profile":"Shipments"); 
return "";
}
@SuppressWarnings("unused")
private String prepare_shared__shell_end(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
request.setAttribute("nlv_shared__shell_end__1", String.valueOf(model.Html.escape(request.getAttribute("nlPageTitle") == null ? "Workspace" : request.getAttribute("nlPageTitle"))));
return "";
}
@SuppressWarnings("unused")
private String prepare_shared__shell_start(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

javax.servlet.http.HttpSession nlSession=request.getSession(false);
String nlCtx=request.getContextPath();
String nlRole=nlSession==null?"":String.valueOf(nlSession.getAttribute("role"));
String nlUser=nlSession==null?"Account":String.valueOf(nlSession.getAttribute("userName") != null ? nlSession.getAttribute("userName") : nlSession.getAttribute("fullName") != null ? nlSession.getAttribute("fullName") : "Account");

request.setAttribute("nlv_shared__shell_start__1", String.valueOf(model.Html.escape(nlCtx)));
request.setAttribute("nlv_shared__shell_start__2", String.valueOf(model.Html.escape(nlCtx)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("CONSUMER".equals(nlRole)){ 
out.write("\n  <a class=\"nl-pay-reminder\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/billing?action=outstanding\" title=\"Check unpaid invoices and record an already-made full or partial payment\"><span class=\"nl-pay-reminder-dot\" aria-hidden=\"true\"></span><strong>Pay outstanding amount</strong><small>Check your balance</small></a>\n  ");
 } 
out.flush(); request.setAttribute("nlv_shared__shell_start__3", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_shared__shell_start__4", String.valueOf(model.Html.escape(nlCtx)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("CONSUMER".equals(nlRole)){ 
out.write("<li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/ContainerAllocationPricingController?module=booking\">Create booking</a></li>");
 } 
out.flush(); request.setAttribute("nlv_shared__shell_start__5", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("SELLER".equals(nlRole)){ 
out.write("<li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/stock\">Inventory &amp; products</a></li><li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/ContainerAllocationPricingController?module=container\">Containers &amp; pricing</a></li>");
 } 
out.flush(); request.setAttribute("nlv_shared__shell_start__6", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if("ADMIN".equals(nlRole)){ 
out.write("<li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/Module1Controller?action=users\">Manage users</a></li>\n        <li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/adminInfrastructure?tab=ports\">Port directory</a></li>\n        <li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/adminInfrastructure?tab=vessels\">Vessel directory</a></li>\n        <li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/Module1Controller?action=auditLogs\">Audit trail</a></li>");
 } 
out.flush(); request.setAttribute("nlv_shared__shell_start__7", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(!"ADMIN".equals(nlRole)){ 
out.write("<li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/billing?action=invoices\">Billing &amp; payments</a></li>\n        <li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/ClaimController?action=list\">Claims</a></li>");
 } 
out.flush(); request.setAttribute("nlv_shared__shell_start__8", nlvString.toString());out=null;nlvString=null;
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(!"CONSUMER".equals(nlRole)){ 
out.write("<li><a class=\"dropdown-item\" href=\"");
out.print(model.Html.escape(nlCtx));
out.write("/analytics\">Analytics</a></li>");
 } 
out.flush(); request.setAttribute("nlv_shared__shell_start__9", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_shared__shell_start__10", String.valueOf(model.Html.escape(nlRole)));
request.setAttribute("nlv_shared__shell_start__11", String.valueOf(model.Html.escape(nlRole)));
request.setAttribute("nlv_shared__shell_start__12", String.valueOf(model.Html.escape(nlUser)));
request.setAttribute("nlv_shared__shell_start__13", String.valueOf(model.Html.escape(nlRole)));
request.setAttribute("nlv_shared__shell_start__14", String.valueOf(model.Html.escape(nlCtx)));
request.setAttribute("nlv_shared__shell_start__15", String.valueOf(model.Html.escape(nlCtx)));
request.setAttribute("nlv_shared__shell_start__16", String.valueOf(model.Html.escape(nlCtx)));
request.setAttribute("nlv_shared__shell_start__17", String.valueOf(model.Html.escape(nlSession==null?null:nlSession.getAttribute("csrfToken"))));
request.setAttribute("nlv_shared__shell_start__18", String.valueOf(model.Html.escape(nlCtx)));
return "";
}
@SuppressWarnings("unused")
private String prepare_shared_header(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
 String pageTitle=request.getParameter("pageTitle");String pageSubtitle=request.getParameter("pageSubtitle");if(pageTitle==null)pageTitle="Workspace"; 
request.setAttribute("nlv_shared_header__1", String.valueOf(model.Html.escape(pageTitle)));
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if(pageSubtitle!=null&&!pageSubtitle.isEmpty()){ 
out.write("<p class=\"text-secondary mb-0\">");
out.print(model.Html.escape(pageSubtitle));
out.write("</p>");
 } 
out.flush(); request.setAttribute("nlv_shared_header__2", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_shared_server_error(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;
request.setAttribute("nlv_shared_server_error__1", String.valueOf(model.Html.escape(request.getContextPath())));
return "";
}
@SuppressWarnings("unused")
private String prepare_shared_sidebar(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

javax.servlet.http.HttpSession uNavSession=request.getSession(false);
String uNavRole=uNavSession==null?"":String.valueOf(uNavSession.getAttribute("role"));
boolean uNavAdmin="ADMIN".equals(uNavRole),uNavSeller="SELLER".equals(uNavRole),uNavConsumer="CONSUMER".equals(uNavRole);
String uNavCtx=request.getContextPath();
String uNavModule=String.valueOf(request.getAttribute("nlActiveModule") == null ? "Module1" : request.getAttribute("nlActiveModule"));
String uNavPage=String.valueOf(request.getAttribute("nlPageTitle") == null ? "" : request.getAttribute("nlPageTitle"));
String uNavAction=request.getParameter("action")==null?"":request.getParameter("action");
String uNavArea=request.getParameter("module")==null?"":request.getParameter("module");
String uNavMovement=String.valueOf(request.getAttribute("activeNav") == null ? "" : request.getAttribute("activeNav"));
// id, caption, symbol, target URL, allowed roles (A/S/C), child code
String[][] uNavGroups={
 // A practical task sequence for each role, filtered by the existing role guards:
 // Admin: Overview -> Administration -> Shipments -> Analytics
 // Seller: Overview -> Inventory -> Containers & pricing -> Shipments -> Billing -> Claims -> Analytics -> Profile
 // Consumer: Overview -> Bookings -> Shipments -> Billing -> Claims -> Profile
 {"Module1Overview","Overview","OV","/Module1Controller?action=dashboard","ASC","overview"},
 {"Module1","Administration","AD","/Module1Controller?action=users","A","admin"},
 {"Module3Consumer","Bookings","BK","/ContainerAllocationPricingController?module=booking","C","booking"},
 {"Module4","Inventory","ST","/stock","S","inventory"},
 {"Module3","Containers & pricing","CN","/ContainerAllocationPricingController?module=container","S","container"},
 {"Module2","Shipments","SH","/containerMovement?action=shipments","ASC","movement"},
 {"Module5","Billing & payments","BI","/billing?action=invoices","SC","billing"},
 {"Module7","Claims","CL","/ClaimController?action=list","SC","claims"},
 {"Module6","Analytics","AN","/analytics","AS","analytics"},
 {"Profile","My profile","ME","/Module1Controller?action=viewProfile","SC","profile"}
};

nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 for(String[] uNavGroup:uNavGroups){
  String uNavAllowed=uNavGroup[4];
  if(!(uNavAdmin&&uNavAllowed.contains("A") || uNavSeller&&uNavAllowed.contains("S") || uNavConsumer&&uNavAllowed.contains("C")))continue;
  String uKey=uNavGroup[0], uMenu=uNavGroup[5];
  boolean uSelected=("Module1Overview".equals(uKey) && "Module1".equals(uNavModule) && ("Dashboard".equalsIgnoreCase(uNavPage)||"Overview".equalsIgnoreCase(uNavPage)))
      || ("Module1".equals(uKey) && "Module1".equals(uNavModule) && !"Dashboard".equalsIgnoreCase(uNavPage) && !"Overview".equalsIgnoreCase(uNavPage) && !"Profile".equalsIgnoreCase(uNavPage))
      || ("Module3Consumer".equals(uKey) && "Module3".equals(uNavModule) && uNavConsumer)
      || (uKey.equals(uNavModule) && !"Module1".equals(uKey) && !"Module3Consumer".equals(uKey) && !("Module2".equals(uKey) && "profitLoss".equals(uNavAction)))
      || ("Module6".equals(uKey) && "Module2".equals(uNavModule) && "profitLoss".equals(uNavAction))
      || ("Profile".equals(uKey) && ("Profile".equalsIgnoreCase(uNavPage) || "profile".equals(uNavMovement)));
  boolean uHasChildren=!("overview".equals(uMenu)||"profile".equals(uMenu));
 String uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjMiIHk9IjMiIHdpZHRoPSI3IiBoZWlnaHQ9IjciIHJ4PSIxLjQiLz48cmVjdCB4PSIxNCIgeT0iMyIgd2lkdGg9IjciIGhlaWdodD0iNyIgcng9IjEuNCIvPjxyZWN0IHg9IjMiIHk9IjE0IiB3aWR0aD0iNyIgaGVpZ2h0PSI3IiByeD0iMS40Ii8+PHJlY3QgeD0iMTQiIHk9IjE0IiB3aWR0aD0iNyIgaGVpZ2h0PSI3IiByeD0iMS40Ii8+PC9zdmc+";
  if("overview".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjMiIHk9IjMiIHdpZHRoPSI3IiBoZWlnaHQ9IjciIHJ4PSIxLjQiLz48cmVjdCB4PSIxNCIgeT0iMyIgd2lkdGg9IjciIGhlaWdodD0iNyIgcng9IjEuNCIvPjxyZWN0IHg9IjMiIHk9IjE0IiB3aWR0aD0iNyIgaGVpZ2h0PSI3IiByeD0iMS40Ii8+PHJlY3QgeD0iMTQiIHk9IjE0IiB3aWR0aD0iNyIgaGVpZ2h0PSI3IiByeD0iMS40Ii8+PC9zdmc+";
  else if("admin".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxjaXJjbGUgY3g9IjgiIGN5PSI4IiByPSIzIi8+PHBhdGggZD0iTTIgMjB2LTJhNiA2IDAgMCAxIDEyIDB2Mk0xNSA5aDdNMTguNSA1LjV2N00xNSAxN2g3Ii8+PC9zdmc+";
  else if("movement".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjMiIHk9IjciIHdpZHRoPSIxOCIgaGVpZ2h0PSIxMiIgcng9IjIiLz48cGF0aCBkPSJNNyA3VjRoMTB2M004IDExdjRNMTIgMTF2NE0xNiAxMXY0TTMgMTZoMTgiLz48L3N2Zz4=";
  else if("container".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjIiIHk9IjUiIHdpZHRoPSIyMCIgaGVpZ2h0PSIxNCIgcng9IjIiLz48cGF0aCBkPSJNNiA1djE0TTEwIDV2MTRNMTQgNXYxNE0xOCA1djE0Ii8+PC9zdmc+";
  else if("booking".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjQiIHk9IjMiIHdpZHRoPSIxNiIgaGVpZ2h0PSIxOCIgcng9IjIiLz48cGF0aCBkPSJNOCA4aDhNOCAxMmg0TTkgMTdsMiAyIDQtNCIvPjwvc3ZnPg==";
  else if("inventory".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Im0xMiAyIDkgNS05IDUtOS01IDktNVpNMyA3djEwbDkgNSA5LTVWN00xMiAxMnYxMCIvPjwvc3ZnPg==";
  else if("billing".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjMiIHk9IjQiIHdpZHRoPSIxOCIgaGVpZ2h0PSIxNiIgcng9IjMiLz48cGF0aCBkPSJNMyAxMGgxOE03IDE1aDQiLz48L3N2Zz4=";
  else if("analytics".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0zIDIxaDE4TTYgMjF2LThoNHY4TTEzIDIxVjRoNHYxN00xOSAyMXYtMTFoMnYxMSIvPjwvc3ZnPg==";
  else if("claims".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0xMiAyIDQgNXY2YzAgNSAzIDggOCAxMSA1LTMgOC02IDgtMTFWNWwtOC0zWiIvPjxwYXRoIGQ9Im04LjUgMTIgMi4zIDIuMyA0LjctNSIvPjwvc3ZnPg==";
  else if("profile".equals(uMenu)) uNavIcon="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNhOTRiMTgiIHN0cm9rZS13aWR0aD0iMS45IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxjaXJjbGUgY3g9IjEyIiBjeT0iOCIgcj0iNCIvPjxwYXRoIGQ9Ik00IDIxdi0yYTggOCAwIDAgMSAxNiAwdjIiLz48L3N2Zz4=";
 
out.write("\n <div class=\"nl-side-group ");
out.print(uSelected?"is-selected":"");
out.write("\" data-u-menu=\"");
out.print(uMenu);
out.write("\">\n  <div class=\"nl-side-parent\">\n   <a class=\"nl-side-main ");
out.print(uSelected?"is-current":"");
out.write("\" href=\"");
out.print(model.Html.escape(uNavCtx+uNavGroup[3]));
out.write("\" ");
out.print(uSelected?"aria-current=\"page\"":"");
out.write(" title=\"");
out.print(model.Html.escape(uNavGroup[1]));
out.write("\">\n    <span class=\"nl-side-icon\" aria-hidden=\"true\"><img src=\"");
out.print(uNavIcon);
out.write("\" alt=\"\" width=\"21\" height=\"21\" /></span><span class=\"nl-side-name\">");
out.print(model.Html.escape(uNavGroup[1]));
out.write("</span>\n   </a>\n   ");
 if(uHasChildren){ 
out.write("<button type=\"button\" class=\"nl-side-toggle\" aria-label=\"Toggle ");
out.print(model.Html.escape(uNavGroup[1]));
out.write(" submenu\" aria-expanded=\"");
out.print(uSelected?"true":"false");
out.write("\"><span aria-hidden=\"true\">&#9662;</span></button>");
 } 
out.write("\n  </div>\n  ");
 if(uHasChildren){ 
out.write("<div class=\"nl-side-children\" ");
out.print(uSelected?"":"hidden");
out.write(">\n  ");

  String[][] uNavChildren=new String[0][];
  if("admin".equals(uMenu))uNavChildren=new String[][]{{"Users","/Module1Controller?action=users","users"},{"Companies","/Module1Controller?action=companies","companies"},{"Customers","/Module1Controller?action=customers","customers"},{"Ports","/adminInfrastructure?tab=ports","ports"},{"Vessels","/adminInfrastructure?tab=vessels","vessels"},{"Audit trail","/Module1Controller?action=auditLogs","auditLogs"}};
  if("movement".equals(uMenu))uNavChildren=new String[][]{{"Shipment management","/containerMovement?action=shipments","shipments"},{"Movement history","/containerMovement?action=movements","movements"}};
  if("container".equals(uMenu))uNavChildren=new String[][]{{"Container inventory","/ContainerAllocationPricingController?module=container","container"},{"Pricing rules","/ContainerAllocationPricingController?module=pricing","pricing"}};
  if("booking".equals(uMenu))uNavChildren=new String[][]{{"Create booking","/ContainerAllocationPricingController?module=booking","booking"},{"My shipments","/containerMovement?action=shipments","shipments"},{"My invoices","/billing?action=invoices","invoices"}};
  if("inventory".equals(uMenu))uNavChildren=new String[][]{{"Stock overview","/stock",""},{"Add product","/stock?action=new-product","new-product"},{"Add stock","/stock?action=new-stock","new-stock"},{"Import stock","/stock?action=import","import"},{"Inventory ledger","/stock?action=ledger","ledger"},{"Sales history","/stock?action=sales","sales"},{"Shipment stock","/stock?action=summary","summary"}};
  if("billing".equals(uMenu))uNavChildren=new String[][]{{"Invoices","/billing?action=invoices","invoices"},{"Outstanding","/billing?action=outstanding","outstanding"},{"Payment history","/billing?action=payments","payments"},{"Create invoice","/billing?action=createInvoice","createInvoice"}};
  if("analytics".equals(uMenu))uNavChildren=new String[][]{{"Business dashboard","/analytics",""},{"Sales trends","/analytics#sales-trends","sales-trends"},{"ABC classification","/analytics#abc-classification","abc-classification"},{"Inventory turnover","/analytics#inventory-turnover","inventory-turnover"},{"Demand forecast","/analytics#demand-forecast","demand-forecast"},{"Product profitability","/analytics#profitability","profitability"},{"Profit & loss report","/containerMovement?action=profitLoss","profitLoss"}};
  if("claims".equals(uMenu))uNavChildren=new String[][]{{"Claims register","/ClaimController?action=list","list"},{"File new claim","/ClaimController?action=new","new"}};
  for(String[] uLink:uNavChildren){
   if("movement".equals(uMenu)&&"profitLoss".equals(uLink[2])&&uNavConsumer)continue;
   if("billing".equals(uMenu)&&"createInvoice".equals(uLink[2])&&!uNavSeller)continue;
   if("claims".equals(uMenu)&&"new".equals(uLink[2])&&!uNavConsumer)continue;
   if("admin".equals(uMenu)&&!uNavAdmin)continue;
   String uTarget=uLink[1];
   boolean uExact=("movement".equals(uMenu) ? (uNavAction.equals(uLink[2]) || uNavMovement.equals(uLink[2]) || ("shipments".equals(uLink[2])&&uNavAction.isEmpty()))
     : "container".equals(uMenu)||"booking".equals(uMenu) ? uNavArea.equals(uLink[2])
     : "inventory".equals(uMenu)||"billing".equals(uMenu)||"claims".equals(uMenu)||"admin".equals(uMenu) ? (uNavAction.equals(uLink[2]) || (("ports".equals(uLink[2]) || "vessels".equals(uLink[2])) && "admin".equals(uMenu)
       && "/adminInfrastructure".equals(request.getServletPath())
       && uLink[2].equals("vessels".equalsIgnoreCase(request.getParameter("tab"))?"vessels":"ports")))
     : "analytics".equals(uMenu) ? (("profitLoss".equals(uLink[2]) && "Module2".equals(uNavModule) && "profitLoss".equals(uNavAction)) || ("".equals(uLink[2]) && "Module6".equals(uNavModule) && request.getParameter("action")==null))
     : false);
  
out.write("\n   <a class=\"nl-side-child ");
out.print(uExact?"is-current":"");
out.write("\" href=\"");
out.print(model.Html.escape(uNavCtx+uTarget));
out.write("\" ");
out.print(uExact?"aria-current=\"page\"":"");
out.write("><span class=\"nl-child-marker\" aria-hidden=\"true\"></span>");
out.print(model.Html.escape(uLink[0]));
out.write("</a>\n  ");
 } 
out.write("\n  </div>");
 } 
out.write("\n </div>\n ");
 } 
out.flush(); request.setAttribute("nlv_shared_sidebar__1", nlvString.toString());out=null;nlvString=null;
request.setAttribute("nlv_shared_sidebar__2", String.valueOf(model.Html.escape(uNavRole)));
request.setAttribute("nlv_shared_sidebar__3", String.valueOf(model.Html.escape(uNavCtx)));
request.setAttribute("nlv_shared_sidebar__4", String.valueOf(model.Html.escape(uNavSession==null?null:uNavSession.getAttribute("csrfToken"))));
return "";
}
@SuppressWarnings("unused")
private String prepare_shared_tabs(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

    // Supports built-in tabs for integrated modules, OR custom tabs for every other module.
    String tabsModule = request.getParameter("module");
    if (tabsModule == null || tabsModule.trim().isEmpty()) tabsModule = request.getParameter("activeModule");
    if (tabsModule == null) tabsModule = "";
    tabsModule = tabsModule.trim().toLowerCase(java.util.Locale.ROOT);
    String tabsActive = request.getParameter("activeTab");
    if (tabsActive == null) tabsActive = "";
    javax.servlet.http.HttpSession tabsSession = request.getSession(false);
    Object tabsRoleObj = tabsSession == null ? null : tabsSession.getAttribute("role");
    String tabsRole = tabsRoleObj == null ? "" : String.valueOf(tabsRoleObj).trim().toUpperCase(java.util.Locale.ROOT);
    boolean tabsAdmin = "ADMIN".equals(tabsRole), tabsSeller = "SELLER".equals(tabsRole), tabsConsumer = "CONSUMER".equals(tabsRole);
    java.util.List<String[]> tabsItems = new java.util.ArrayList<String[]>();
    if ("shipments".equals(tabsModule)) {
        tabsItems.add(new String[]{"shipments","Shipments","/containerMovement?action=shipments","ALL"});
        tabsItems.add(new String[]{"movements","Movement tracking","/containerMovement?action=movements","ALL"});
        tabsItems.add(new String[]{"update","Update movement","/containerMovement?action=shipments","SELLER,ADMIN"});

    } else if ("analytics".equals(tabsModule)) {
        tabsItems.add(new String[]{"dashboard","Analytics dashboard","/analytics","SELLER,ADMIN"});
        tabsItems.add(new String[]{"profitloss","Profit & loss","/containerMovement?action=profitLoss","SELLER,ADMIN"});
    } else if ("billing".equals(tabsModule)) {
        tabsItems.add(new String[]{"dashboard","Dashboard","/billing?action=dashboard","ALL"});
        tabsItems.add(new String[]{"invoices","Invoices","/billing?action=invoices","ALL"});
        tabsItems.add(new String[]{"createinvoice","Create / recover invoice","/billing?action=createInvoice","SELLER"});
        tabsItems.add(new String[]{"payments","Payments","/billing?action=payments","ALL"});
    } else if ("claims".equals(tabsModule)) {
        tabsItems.add(new String[]{"list","All claims","/ClaimController?action=list","ALL"});
        tabsItems.add(new String[]{"submit","Submit claim","/ClaimController?action=new","CONSUMER"});
    }
    // Up to 8 optional overrides / additions; key + label + relative URL + role list.
    // Example: tab1Key=products, tab1Label=Products, tab1Url=/inventory?action=products.
    for (int tabIdx=1; tabIdx<=8; tabIdx++) {
        String tabPrefix = "tab" + tabIdx;
        String customLabel = request.getParameter(tabPrefix + "Label");
        String customPath = request.getParameter(tabPrefix + "Url");
        if (customLabel == null || customLabel.trim().isEmpty() || customPath == null || customPath.trim().isEmpty()) continue;
        String customKey = request.getParameter(tabPrefix + "Key");
        if (customKey == null || customKey.trim().isEmpty()) customKey = "tab" + tabIdx;
        String customRoles = request.getParameter(tabPrefix + "Roles");
        if (customRoles == null || customRoles.trim().isEmpty()) customRoles = "ALL";
        tabsItems.add(new String[]{customKey.trim(), customLabel.trim(), customPath.trim(), customRoles.trim().toUpperCase(java.util.Locale.ROOT)});
    }
    String tabsCtx = request.getContextPath();
    int tabsVisible = 0;

 for (String[] tab : tabsItems) {
    String allowed = "," + tab[3] + ",";
    boolean canSee = (tabsAdmin || tabsSeller || tabsConsumer)
            && ("ALL".equals(tab[3]) || allowed.contains("," + tabsRole + ","));
    if (!canSee) continue;
    String tabTarget = tabsHref(tabsCtx, tab[2]);
    if (tabTarget.isEmpty()) continue;
    tabsVisible++;
} 
nlvString=new java.io.StringWriter(); out=new java.io.PrintWriter(nlvString);
 if (tabsVisible > 0) { 
out.write("\n<nav class=\"nl-tabs nav nav-pills bg-warning-subtle border rounded-4 p-2 gap-2 mb-4\" aria-label=\"Module tabs\">\n    ");
 for (String[] tab : tabsItems) {
        String allowed = "," + tab[3] + ",";
        boolean canSee = (tabsAdmin || tabsSeller || tabsConsumer)
                && ("ALL".equals(tab[3]) || allowed.contains("," + tabsRole + ","));
        if (!canSee) continue;
        String tabTarget = tabsHref(tabsCtx, tab[2]);
        if (tabTarget.isEmpty()) continue;
        boolean selected = tab[0].equalsIgnoreCase(tabsActive);
    
out.write("\n    <a class=\"nl-tab nav-link text-dark fw-semibold rounded-3 ");
out.print(selected ? "bg-warning-subtle border" : "");
out.write("\" href=\"");
out.print(tabsEscape(tabTarget));
out.write("\" ");
out.print(selected ? "aria-current=\"page\"" : "");
out.write(">");
out.print(tabsEscape(tab[1]));
out.write("</a>\n    ");
 } 
out.write("\n</nav>\n");
 } 
out.flush(); request.setAttribute("nlv_shared_tabs__1", nlvString.toString());out=null;nlvString=null;
return "";
}
@SuppressWarnings("unused")
private String prepare_shared_topbar(javax.servlet.jsp.PageContext pc) throws java.io.IOException {
javax.servlet.jsp.PageContext pageContext=pc;
javax.servlet.http.HttpServletRequest request=(javax.servlet.http.HttpServletRequest)pc.getRequest();
javax.servlet.http.HttpServletResponse response=(javax.servlet.http.HttpServletResponse)pc.getResponse();
javax.servlet.http.HttpSession session=request.getSession();
javax.servlet.ServletContext application=pc.getServletContext();
javax.servlet.ServletConfig config=pc.getServletConfig();
Object page=pc.getPage();
java.io.StringWriter nlvString=null; java.io.PrintWriter out=null;

String nlTopTitle=String.valueOf(request.getAttribute("pageTitle") == null ? "Workspace" : request.getAttribute("pageTitle"));
Object nlTopSessionName=session.getAttribute("userName");
String nlTopName=String.valueOf(nlTopSessionName==null ? "Account" : nlTopSessionName);

request.setAttribute("nlv_shared_topbar__1", String.valueOf(model.Html.escape(nlTopTitle)));
request.setAttribute("nlv_shared_topbar__2", String.valueOf(model.Html.escape(request.getContextPath())));
request.setAttribute("nlv_shared_topbar__3", String.valueOf(model.Html.escape(nlTopName)));
return "";
}
}
