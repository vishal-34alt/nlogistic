<jsp:useBean id="nlViewSupport_Module1_error" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_error" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_error" property="view" value="Module1/error.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>



<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>N-LOGISTIC | Error</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
<%@ include file="../shared/_theme.jsp" %>
</head>

<body data-nl-screen="module1-error" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module1_error__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">


<div class="container min-vh-100 d-flex align-items-center justify-content-center">

    <div class="card shadow-sm p-3 mb-3 border-0 text-center rounded-4 border-warning-subtle"
        >

        <div class="card-body p-5">

            <div class="mb-3">
                <span class="display-1 text-danger fw-bold">!</span>
            </div>

            <h3 class="fw-bold mb-3">Something Went Wrong</h3>

            <p class="text-secondary mb-4">
                We could not complete your request.
                Please check the details and try again.
            </p>

            <div class="alert alert-danger text-start">
                <strong>Error Details:</strong>
                <div class="mt-2">
                    ${requestScope.nlv_Module1_error__2}
                </div>
            </div>

            <a href="Module1Controller?action=dashboard"
               class="btn btn-warning bg-gradient mt-3">
                Back to Dashboard
            </a>

            <a href="Module1Controller?action=viewLogin"
               class="btn btn-outline-secondary mt-3">
                Back to Login
            </a>

        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
</body>
</html>
