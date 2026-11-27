<jsp:useBean id="nlViewSupport_shared_header" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_shared_header" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_shared_header" property="view" value="shared/header.jsp" />
<%@ page pageEncoding="UTF-8" %>

<div class="nl-shared-page-header bg-white rounded-4 border border-warning-subtle shadow-sm p-3 p-md-4 mb-4"><h1 class="h2 fw-bold text-warning-emphasis mb-2">${requestScope.nlv_shared_header__1}</h1>${requestScope.nlv_shared_header__2}</div>
