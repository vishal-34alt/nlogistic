<jsp:useBean id="nlViewSupport_Module5_payments" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module5_payments" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module5_payments" property="view" value="Module5/payments.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,java.math.*,model.Row,model.BillingInvoiceSummary" %>


<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Payments | N-LOGISTIC</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"><%@ include file="../shared/_theme.jsp" %>
<style>
.nl-bill-hero{background:linear-gradient(118deg,#39251d,#6c3520);color:#fff;border-radius:20px;padding:clamp(20px,3vw,30px);display:flex;align-items:center;justify-content:space-between;gap:20px;flex-wrap:wrap;box-shadow:0 15px 32px #5027181d}
.nl-bill-hero h1{font-size:clamp(1.4rem,2.4vw,2.1rem);margin:4px 0}.nl-bill-hero p{color:#f4d8c7;margin:0}.nl-bill-eyebrow{color:#ffc69d;font-size:.73rem;font-weight:850;letter-spacing:.13em}
.nl-bill-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin:20px 0}
.nl-bill-stat{border:1px solid #e9d7c6;border-radius:17px;background:#fff;padding:21px;min-width:0;box-shadow:0 7px 20px rgba(79,49,25,.05)}.nl-bill-stat small{display:block;color:#7d6656;font-weight:650}.nl-bill-stat strong{display:block;font-size:clamp(1.1rem,2vw,1.55rem);color:#45291d;margin-top:8px}
.nl-bill-tabs{display:flex;flex-wrap:wrap;gap:7px;border-bottom:1px solid #ead7c3;padding-bottom:11px}
.nl-bill-tab{padding:9px 16px;border:1px solid #e9d5c2;border-radius:12px;text-decoration:none;font-weight:700;font-size:.86rem;color:#70452a;background:#fff;transition:background .2s,transform .2s}
.nl-bill-tab:hover,.nl-bill-tab[aria-current="page"]{color:#fff;background:#b95118;border-color:#b95118}.nl-bill-tab:hover{transform:translateY(-1px)}
.nl-bill-list{display:flex;flex-direction:column;gap:12px}.nl-bill-record{display:grid;grid-template-columns:minmax(170px,1.15fr) minmax(140px,1fr) minmax(130px,1fr) minmax(295px,1.4fr);align-items:center;gap:16px;padding:18px 20px;background:#fff;border:1px solid #ebdccb;border-radius:16px}
.nl-bill-record strong{color:#3f281b}.nl-bill-record .nl-muted{display:block;color:#8a7364;font-size:.78rem;margin-top:4px}.nl-bill-record .nl-amount{font-weight:850;font-size:1.03rem;font-variant-numeric:tabular-nums}.nl-bill-actions{display:flex;justify-content:flex-end;align-items:center;gap:9px;flex-wrap:nowrap;min-width:0}.nl-bill-actions .btn{display:inline-flex;justify-content:center;align-items:center;white-space:nowrap;flex:0 0 auto}
.nl-bill-status{display:inline-block;padding:5px 10px;border-radius:99px;background:#f9ead6;color:#99521f;font-weight:800;font-size:.73rem}
.nl-bill-status.paid{background:#e8f8ef;color:#21734c}.nl-bill-status.archived{background:#f0e9e3;color:#675248}.nl-bill-status.overdue{background:#ffe9e9;color:#9c3030}
.nl-bill-search{background:#fff;border-radius:18px;padding:20px;border:1px solid #e8d4c3;margin-top:22px}
.nl-bill-empty{background:#fff;padding:35px;text-align:center;border:1px dashed #d9b79a;border-radius:16px;color:#755b49}
@media(max-width:1150px){.nl-bill-record{grid-template-columns:repeat(2,minmax(0,1fr))}.nl-bill-actions{justify-content:flex-start;flex-wrap:wrap}}
@media(max-width:650px){.nl-bill-stats{grid-template-columns:1fr}.nl-bill-record{grid-template-columns:1fr}.nl-bill-actions{justify-content:flex-start;flex-wrap:wrap}}
@media(prefers-reduced-motion:reduce){.nl-bill-tab{transition:none;transform:none!important}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-bill-stat,html[data-nl-mode="dark"] body.nl-themed-page .nl-bill-record,html[data-nl-mode="dark"] body.nl-themed-page .nl-bill-summary,html[data-nl-mode="dark"] body.nl-themed-page .nl-bill-search,html[data-nl-mode="dark"] body.nl-themed-page .nl-bill-status{background:#203044!important;color:#edf4fc!important;border-color:#516b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-bill-stat :is(strong,small,span),html[data-nl-mode="dark"] body.nl-themed-page .nl-bill-record :is(strong,small,span){color:#edf4fc!important}
</style></head>
<body data-nl-screen="module5-payments" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-themed-page bg-body-tertiary text-dark">
<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="nl-view-body container-fluid p-0 px-0">
<jsp:include page="/WEB-INF/views/shared/header.jsp"><jsp:param name="pageTitle" value="Payments"/><jsp:param name="activeModule" value="billing"/></jsp:include>
<jsp:include page="/WEB-INF/views/shared/tabs.jsp"><jsp:param name="module" value="billing"/><jsp:param name="activeTab" value="payments"/></jsp:include>
<header class="nl-bill-hero"><div><span class="nl-bill-eyebrow">BILLING WORKSPACE</span><h1>Payments made simple</h1><p>See what is paid, what is due, and record a payment against the correct invoice.</p></div><a class="btn btn-light fw-bold" href="${requestScope.nlv_Module5_payments__1}?action=invoices">All invoices</a></header>
<div class="nl-bill-stats" aria-label="Invoice balances"><div class="nl-bill-stat"><small>Active invoiced</small><strong>INR ${requestScope.nlv_Module5_payments__2}</strong></div><div class="nl-bill-stat"><small>Payments recorded</small><strong>INR ${requestScope.nlv_Module5_payments__3}</strong></div><div class="nl-bill-stat"><small>Outstanding balance</small><strong>INR ${requestScope.nlv_Module5_payments__4}</strong></div></div>
<section class="nl-bill-search" aria-labelledby="nlInvoiceSearchTitle"><h2 id="nlInvoiceSearchTitle" class="h5 fw-bold">Find an invoice to settle</h2><p class="small text-secondary">Use the invoice or shipment reference. Your account only sees authorized records.</p>
<form action="${requestScope.nlv_Module5_payments__5}" method="get" class="row g-2 align-items-end"><input type="hidden" name="action" value="payments"><input type="hidden" name="view" value="${requestScope.nlv_Module5_payments__6}">
<div class="col-sm-8"><label for="nlInvoiceQ" class="form-label">Invoice or shipment number</label><input id="nlInvoiceQ" class="form-control" name="q" type="search" maxlength="100" value="${requestScope.nlv_Module5_payments__7}" placeholder="e.g. INV-00025 or SHP-00025"></div>
<div class="col-sm-auto"><button class="btn btn-warning fw-bold" type="submit">Search invoices</button></div><div class="col-sm-auto"><a class="btn btn-outline-secondary" href="${requestScope.nlv_Module5_payments__8}?action=payments">Clear</a></div></form></section>
<section class="mt-4" aria-labelledby="nlPaymentInvoiceTitle"><div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3"><h2 class="h5 mb-0 fw-bold" id="nlPaymentInvoiceTitle">Invoice payment status</h2><span class="text-secondary small">${requestScope.nlv_Module5_payments__9} matching invoices</span></div>
<nav class="nl-bill-tabs mb-3" aria-label="Payment status filters">
${requestScope.nlv_Module5_payments__10}</nav>
<div class="nl-bill-list">
${requestScope.nlv_Module5_payments__11}
</div></section>
<section class="nl-bill-search mt-4" aria-labelledby="nlHistoryTitle"><h2 id="nlHistoryTitle" class="h5 fw-bold">Recorded payment history</h2><p class="small text-secondary">These are recorded transactions, not online transfers initiated by N-LOGISTIC.</p>
<form method="get" action="${requestScope.nlv_Module5_payments__12}" class="row g-2 align-items-end mb-3"><input type="hidden" name="action" value="payments"><div class="col-sm-5"><label class="form-label" for="nlRef">Payment reference</label><input class="form-control" id="nlRef" name="reference" value="${requestScope.nlv_Module5_payments__13}" maxlength="50" placeholder="UPI / bank / cheque reference"></div><div class="col-sm-3"><label class="form-label" for="nlFrom">From</label><input class="form-control" id="nlFrom" name="from" type="date" value="${requestScope.nlv_Module5_payments__14}"></div><div class="col-sm-3"><label class="form-label" for="nlTo">To</label><input class="form-control" id="nlTo" name="to" type="date" value="${requestScope.nlv_Module5_payments__15}"></div><div class="col-auto"><button class="btn btn-outline-warning" type="submit">Filter history</button></div></form>
<div class="table-responsive"><table class="table table-hover align-middle"><thead class="table-warning"><tr><th>Invoice</th><th>Paid amount</th><th>Method</th><th>Reference</th><th>Date</th><th>Details</th></tr></thead><tbody>
<jsp:setProperty name="nlViewSupport_Module5_payments" property="fragment" value="nlv_Module5_payments__16" /><jsp:getProperty name="nlViewSupport_Module5_payments" property="fragment" /></tbody></table></div>
${requestScope.nlv_Module5_payments__17}
</section>
</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body></html>
