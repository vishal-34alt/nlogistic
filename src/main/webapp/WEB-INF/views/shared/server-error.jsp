<jsp:useBean id="nlViewSupport_shared_server_error" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_shared_server_error" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_shared_server_error" property="view" value="shared/server-error.jsp" />
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Request could not be completed | N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="_theme.jsp" %></head>
<body class="nl-themed-page text-dark min-vh-100 d-flex align-items-center justify-content-center">
<main class="container py-5"><section class="row justify-content-center"><div class="col-12 col-md-8 col-lg-6">
<div class="card rounded-4 border border-warning-subtle shadow-lg bg-white"><div class="card-body p-4 p-md-5 text-center">
<div class="badge bg-dark text-warning rounded-pill p-3 mb-4">N-LOGISTIC</div>
<h1 class="h2 fw-bold text-warning-emphasis mb-3">Unable to complete this request</h1>
<p class="text-secondary mb-4">Something went wrong. You can return to your workspace and try again. If the problem continues, contact your administrator.</p>
<a class="btn btn-warning bg-gradient fw-semibold px-4 py-2" href="${requestScope.nlv_shared_server_error__1}/Module1Controller?action=dashboard">Return to workspace</a>
</div></div></div></section></main><script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
