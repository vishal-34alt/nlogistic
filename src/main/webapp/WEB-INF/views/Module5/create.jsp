<jsp:useBean id="nlViewSupport_Module5_create" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module5_create" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module5_create" property="view" value="Module5/create.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.math.*,model.Row" %>


<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>
</head><body data-nl-screen="module5-create" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module5_create__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">

<jsp:include page="/WEB-INF/views/shared/header.jsp"><jsp:param name="pageTitle" value="Create missing invoice"/><jsp:param name="activeModule" value="billing"/></jsp:include>

<jsp:include page="/WEB-INF/views/shared/tabs.jsp"><jsp:param name="module" value="billing"/><jsp:param name="activeTab" value="createinvoice"/></jsp:include>
<div class="d-flex align-items-center gap-3 mb-3"><a href="${requestScope.nlv_Module5_create__2}?action=outstanding">Outstanding report</a></div>
<section class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle"><p>Only shipments without an invoice are eligible. Charges must match the confirmed quote, including database-calculated tax.</p><form method="post" action="${requestScope.nlv_Module5_create__3}" class="d-flex flex-wrap gap-2 mb-3"><input type="hidden" name="csrf" value="${requestScope.nlv_Module5_create__4}"><input type="hidden" name="action" value="create"><label>Shipment<select class="form-select" name="shipment" required><option value="">Select shipment</option><jsp:setProperty name="nlViewSupport_Module5_create" property="fragment" value="nlv_Module5_create__5" /><jsp:getProperty name="nlViewSupport_Module5_create" property="fragment" /></select></label><label>Due date<input class="form-control" name="due" type="date" value="" required></label><label>Freight (₹)<input class="form-control" name="freight" type="number" value="0" min="0" step="0.01" required></label><label>Handling (₹)<input class="form-control" name="handling" type="number" value="0" min="0" step="0.01" required></label><label>Customs (₹)<input class="form-control" name="customs" type="number" value="0" min="0" step="0.01" required></label><label>Insurance (₹)<input class="form-control" name="insurance" type="number" value="0" min="0" step="0.01" required></label><button class="btn btn-warning bg-gradient">Create invoice</button></form>${requestScope.nlv_Module5_create__6}</section><jsp:include page="/WEB-INF/views/shared/footer.jsp"/>

</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>