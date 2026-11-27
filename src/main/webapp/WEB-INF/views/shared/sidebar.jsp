<jsp:useBean id="nlViewSupport_shared_sidebar" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_shared_sidebar" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_shared_sidebar" property="view" value="shared/sidebar.jsp" />
<%@ page pageEncoding="UTF-8" %>

<nav class="nl-primary-nav nl-universal-navigation" aria-label="Primary navigation">
 <div class="nl-side-heading"><span class="nl-side-heading-caption">WORKSPACE</span><span class="nl-side-heading-line" aria-hidden="true"></span></div>
 <div class="nl-side-groups">
 ${requestScope.nlv_shared_sidebar__1}
 </div>
 <div class="nl-side-footer"><div class="nl-side-signed"><span class="nl-online-pulse" aria-hidden="true"></span><span>Secure ${requestScope.nlv_shared_sidebar__2} workspace</span></div>
 <form action="${requestScope.nlv_shared_sidebar__3}/Module1Controller" method="post"><input type="hidden" name="action" value="logout"><input type="hidden" name="csrfToken" value="${requestScope.nlv_shared_sidebar__4}"><button type="submit" class="nl-side-logout">Sign out</button></form></div>
</nav>
