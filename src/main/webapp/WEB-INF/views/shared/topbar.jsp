<jsp:useBean id="nlViewSupport_shared_topbar" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_shared_topbar" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_shared_topbar" property="view" value="shared/topbar.jsp" />
<%@ page pageEncoding="UTF-8" %>

<header class="d-flex flex-wrap justify-content-between align-items-center gap-3 bg-white rounded-4 border border-warning-subtle shadow-sm p-3 p-lg-4 mb-4">
<div><p class="small text-warning-emphasis text-uppercase fw-semibold mb-1">N-LOGISTIC / Workspace</p><h2 class="h4 fw-bold text-dark mb-0">${requestScope.nlv_shared_topbar__1}</h2></div>
<a class="btn btn-outline-dark btn-sm rounded-pill px-3" href="${requestScope.nlv_shared_topbar__2}/Module1Controller?action=viewProfile" aria-label="Open profile">${requestScope.nlv_shared_topbar__3}</a>
</header>
