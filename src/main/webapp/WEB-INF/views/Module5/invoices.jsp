<jsp:useBean id="nlViewSupport_Module5_invoices" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module5_invoices" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module5_invoices" property="view" value="Module5/invoices.jsp" />
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.Row,model.BillingInvoiceSummary" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Invoices | N-LOGISTIC</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"><%@ include file="../shared/_theme.jsp" %><style>
/* v20.23 - readable billing records and filters */
body[data-nl-screen="module5-invoices"] :is(.card,.nl-kpi-card){border-radius:17px!important}
body[data-nl-screen="module5-invoices"] .nl-invoice-table :is(th,td){vertical-align:middle!important}
body[data-nl-screen="module5-invoices"] .nl-invoice-table tbody tr:hover{background:#fff4e7!important}
body[data-nl-screen="module5-invoices"] .nl23-invoice-hint{margin:13px 5px}
html[data-nl-mode="dark"] body[data-nl-screen="module5-invoices"] .nl-invoice-table tbody tr:hover{background:#304154!important}

</style>
</head>
<body data-nl-screen="module5-invoices" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-themed-page bg-body-tertiary text-dark"><%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">Billing / Invoices</div><div class="nl-view-body container-fluid px-0">
<div class="d-flex flex-wrap align-items-start justify-content-between gap-3 mb-4"><div><h1 class="h2 fw-bold text-dark mb-2">${requestScope.nlv_Module5_invoices__1}</h1><p class="text-secondary">Authorized invoices, recorded payments and outstanding balances.</p></div><div class="d-flex flex-wrap gap-2"><a class="btn btn-outline-dark" href="${requestScope.nlv_Module5_invoices__2}?action=payments">Payment history</a><a class="btn btn-outline-secondary" href="${requestScope.nlv_Module5_invoices__3}?action=outstanding">Outstanding report</a></div></div>
<jsp:include page="/WEB-INF/views/shared/tabs.jsp"><jsp:param name="module" value="billing"/><jsp:param name="activeTab" value="invoices"/></jsp:include>
<div class="row g-3 mb-4">
 <div class="col-sm-6 col-xl-3"><section class="card p-3 h-100 rounded-4 shadow-sm border-warning-subtle border"><span class="text-secondary">Active invoiced (INR)</span><strong class="fs-4">&#8377; ${requestScope.nlv_Module5_invoices__4}</strong></section></div>
 <div class="col-sm-6 col-xl-3"><section class="card p-3 h-100 rounded-4 shadow-sm border-warning-subtle border"><span class="text-secondary">Recorded as paid</span><strong class="fs-4">&#8377; ${requestScope.nlv_Module5_invoices__5}</strong></section></div>
 <div class="col-sm-6 col-xl-3"><section class="card p-3 h-100 rounded-4 shadow-sm border-warning-subtle border"><span class="text-secondary">Outstanding</span><strong class="fs-4">&#8377; ${requestScope.nlv_Module5_invoices__6}</strong></section></div>
 <div class="col-sm-6 col-xl-3"><section class="card p-3 h-100 rounded-4 shadow-sm border-warning-subtle border"><span class="text-secondary">Overdue invoices</span><strong class="fs-4">${requestScope.nlv_Module5_invoices__7}</strong></section></div>
</div>
<section class="card p-3 p-md-4 mb-4 rounded-4 shadow-sm border-warning-subtle border"><h2 class="h5 mb-3">Find invoices</h2>
<form method="get" action="${requestScope.nlv_Module5_invoices__8}" class="row g-2 align-items-end"><input type="hidden" name="action" value="${requestScope.nlv_Module5_invoices__9}">
 <div class="col-md-6"><label class="form-label" for="invoiceQuery">Invoice or shipment number</label><input id="invoiceQuery" class="form-control" type="search" name="q" maxlength="100" value="${requestScope.nlv_Module5_invoices__10}" placeholder="Search reference"></div>
 <div class="col-md-3"><label class="form-label" for="invoiceStatus">Status</label><select class="form-select" id="invoiceStatus" name="status"><option value="">All statuses</option>
 <jsp:setProperty name="nlViewSupport_Module5_invoices" property="fragment" value="nlv_Module5_invoices__11" /><jsp:getProperty name="nlViewSupport_Module5_invoices" property="fragment" /></select></div>
 <div class="col-auto"><button type="submit" class="btn btn-warning bg-gradient">Filter</button></div><div class="col-auto"><a href="${requestScope.nlv_Module5_invoices__12}?action=invoices" class="btn btn-outline-secondary">Clear</a></div></form>
<div class="table-responsive mt-4"><table class="table table-hover align-middle nl-invoice-table" aria-label="Authorized invoice list"><thead class="table-warning"><tr><th scope="col">Invoice</th><th scope="col">Shipment</th><th scope="col">Total (INR)</th><th scope="col">Paid (INR)</th><th scope="col">Balance (INR)</th><th scope="col">Status</th><th scope="col">Due</th><th scope="col">Actions</th></tr></thead><tbody>
<jsp:setProperty name="nlViewSupport_Module5_invoices" property="fragment" value="nlv_Module5_invoices__13" /><jsp:getProperty name="nlViewSupport_Module5_invoices" property="fragment" />
</tbody></table></div>
${requestScope.nlv_Module5_invoices__14}
<p class="text-secondary small mt-3">Cancelled shipments retain historical invoices but are excluded from outstanding amounts and cannot accept payments.</p><p class="text-secondary small mb-0 mt-3">Payments are recorded and reconciled against invoices; N-LOGISTIC does not process online payments.</p></section>
</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
