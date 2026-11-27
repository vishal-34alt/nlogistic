<jsp:useBean id="nlViewSupport_shared__nav" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_shared__nav" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_shared__nav" property="view" value="shared/_nav.jsp" />
<%@ page pageEncoding="UTF-8" %>

<jsp:include page="/WEB-INF/views/shared/_shell_start.jsp" />
