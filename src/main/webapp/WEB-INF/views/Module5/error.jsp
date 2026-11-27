<jsp:useBean id="nlViewSupport_Module5_error" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module5_error" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module5_error" property="view" value="Module5/error.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.math.*,model.Row" %>


<!doctype html><html><head><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><title>Billing message</title><%@ include file="../shared/_theme.jsp" %>
</head><body data-nl-screen="module5-error" data-nl-enhanced="true" data-theme="n-logistic-orange" class="container py-4 nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module5_error__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">
<section class="card border-0 shadow-sm rounded-4 p-4 p-lg-5" style="max-width:780px;margin:40px auto;background:linear-gradient(130deg,#fff,#fff5e9)">
  <div class="mb-3" style="font-weight:850;letter-spacing:.12em;font-size:.75rem;color:#b25018">PAYMENT OR BILLING NEEDS ATTENTION</div>
  <h1 class="h3 fw-bold">We couldn't complete that request</h1>
  <p class="text-secondary">No success has been confirmed for this operation. Review the message below and try the correct invoice again.</p>
  <div role="alert" class="alert alert-warning rounded-4 border"><strong>What happened:</strong> ${requestScope.nlv_Module5_error__2}</div>
  <p class="small text-secondary">If a payment may already have been submitted, open the invoice history to check before recording it again. For other problems, verify the amount, reference and date.</p>
  <div class="d-flex flex-wrap gap-2"><a class="btn btn-warning fw-bold" href="${requestScope.nlv_Module5_error__3}?action=invoices">Return to invoices</a><a class="btn btn-outline-dark" href="${requestScope.nlv_Module5_error__4}?action=payments">View payment history</a></div>
</section><script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
</body></html>