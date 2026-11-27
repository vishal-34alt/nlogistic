<jsp:useBean id="nlViewSupport_shared__shell_end" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_shared__shell_end" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_shared__shell_end" property="view" value="shared/_shell_end.jsp" />
<footer class="border-top border-warning-subtle text-secondary small d-flex justify-content-between flex-wrap gap-2 mt-5 pt-3 pb-2"><span>N-LOGISTIC &middot; Import &amp; Export Management System</span><span>${requestScope.nlv_shared__shell_end__1}</span></footer>
<%@ include file="_qol.jsp" %>
<%@ include file="_universal_ui.jsp" %>
