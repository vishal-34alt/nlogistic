<jsp:useBean id="nlViewSupport_Module7_claim_details" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module7_claim_details" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module7_claim_details" property="view" value="Module7/claim_details.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.math.*,model.*" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Claim ${requestScope.nlv_Module7_claim_details__1} Details | N-LOGISTIC</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    
<%@ include file="../shared/_theme.jsp" %>
<style>
/* v17.4 evidence toolbar: rename opens a tidy editor rather than overflowing. */
.evidence-item-card{min-width:0}.evidence-item-card>div{align-items:flex-start!important;gap:14px!important}
.evidence-item-card>div>div:first-child{min-width:0;flex:1 1 250px}
.evidence-item-card>div>div:last-child{display:flex;align-items:flex-start;gap:8px;flex-wrap:wrap;min-width:0}
.evidence-item-card .fw-bold{text-wrap:pretty;overflow-wrap:anywhere}
.nl-evidence-rename{position:relative;min-width:0}.nl-evidence-rename>summary{list-style:none;cursor:pointer;display:inline-flex!important}
.nl-evidence-rename>summary:after{display:none!important}
.nl-evidence-rename-editor{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:8px;align-items:center;background:#fff8f0;border:1px solid #ead1b9;border-radius:12px;box-shadow:0 10px 26px #5b33121b;padding:12px;margin-top:8px;width:min(360px,calc(100vw - 55px));position:relative;z-index:2}
.nl-evidence-rename-editor label{grid-column:1/-1;margin:0}.nl-evidence-rename-editor input{min-width:0;width:100%;font-size:.9rem}.nl-evidence-rename-editor .btn{white-space:nowrap}
@media(max-width:580px){.nl-evidence-rename-editor{grid-template-columns:minmax(0,1fr)}.evidence-item-card>div>div:last-child{width:100%}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-surface,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-kpi,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-policy,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-note,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-history,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-preview-card,html[data-nl-mode="dark"] body.nl-themed-page .nl-evidence-rename-editor,html[data-nl-mode="dark"] body.nl-themed-page .evidence-item-card{background:#203044!important;color:#edf4fc!important;border-color:#526b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-surface :is(h2,h3,p,small,strong,span),html[data-nl-mode="dark"] body.nl-themed-page .evidence-item-card :is(h2,h3,p,small,strong,span){color:#edf4fc!important}

/* v20.14 - Claim evidence & communication alignment, limited to these two cards. */
.nl-claim-evidence-card,.nl-claim-timeline-card{min-width:0}
.nl-claim-evidence-card>.nl-card-header-styled,.nl-claim-timeline-card>.nl-card-header-styled{
 display:flex!important;align-items:center!important;justify-content:space-between!important;flex-wrap:wrap;
 gap:10px 14px;padding:15px 16px!important;margin-bottom:14px!important;border-radius:14px!important
}
.nl-claim-evidence-card>.nl-card-header-styled>div,.nl-claim-timeline-card>.nl-card-header-styled h5{
 display:flex;align-items:center;gap:7px;min-width:0;margin:0!important;line-height:1.35
}
.nl-claim-evidence-card>.nl-card-header-styled>.badge,.nl-claim-timeline-card>.nl-card-header-styled>.badge{
 margin-left:auto;flex:none;align-self:center
}
.nl-claim-evidence-card .evidence-item-card{
 min-width:0;padding:14px 16px;margin:10px 0 0;border:1px solid #efd9c4;
 border-radius:13px;background:#fffaf5
}
.nl-claim-evidence-card .evidence-item-card>div{
 display:grid!important;grid-template-columns:minmax(0,1fr);gap:13px!important;align-items:start!important
}
.nl-claim-evidence-card .evidence-item-card>div>div:first-child{
 display:flex;align-items:flex-start!important;gap:12px!important;min-width:0
}
.nl-claim-evidence-card .evidence-item-card>div>div:first-child>div:last-child{
 min-width:0;flex:1;overflow-wrap:anywhere
}
.nl-claim-evidence-card .evidence-item-card>div>div:first-child>div:last-child>.d-flex{flex-wrap:wrap;gap:6px 9px!important}
.nl-claim-evidence-card .evidence-item-card>div>div:last-child{
 display:flex!important;flex-wrap:wrap;align-items:center!important;gap:8px!important;
 width:100%;min-width:0;justify-content:flex-start!important
}
.nl-claim-evidence-card .evidence-item-card>div>div:last-child :is(.btn,summary.btn){
 display:inline-flex!important;align-items:center;justify-content:center;
 min-height:38px;padding:8px 13px!important;margin:0!important;
 border-radius:10px!important;line-height:1.2;white-space:nowrap
}
.nl-claim-evidence-card .evidence-item-card>div>div:last-child>form{display:inline-flex!important;margin:0!important}
.nl-claim-evidence-card .evidence-item-card .nl-evidence-rename{min-width:0}
.nl-claim-evidence-card .nl-evidence-rename-editor{max-width:min(360px,calc(100vw - 68px))}
.nl-claim-evidence-card .nl-claim-upload-row{
 display:grid!important;grid-template-columns:minmax(0,1fr) auto;align-items:stretch;gap:10px
}
.nl-claim-evidence-card .nl-claim-upload-row input[type=file]{
 min-width:0;width:100%;max-width:100%;margin:0;border-radius:11px!important
}
.nl-claim-evidence-card .nl-claim-upload-row button{
 display:inline-flex;align-items:center;justify-content:center;
 min-height:44px;padding:10px 18px!important;white-space:nowrap;border-radius:11px!important
}
.nl-claim-timeline-card .list-group{background:transparent!important;display:grid;gap:10px;margin-bottom:14px!important}
.nl-claim-timeline-card .list-group-item{
 background:#fffaf5!important;color:#443326!important;border:1px solid #efddc8!important;
 border-radius:12px!important;padding:13px 14px!important;min-width:0
}
.nl-claim-timeline-card .list-group-item>.d-flex{
 display:flex!important;flex-wrap:wrap;align-items:center!important;justify-content:space-between;
 gap:8px 12px
}
.nl-claim-timeline-card .list-group-item :is(small,.text-dark){overflow-wrap:anywhere}
.nl-claim-timeline-card .nl-claim-comment-form{margin-top:16px!important;min-width:0}
.nl-claim-timeline-card .nl-claim-comment-form .form-label{margin-bottom:9px!important}
.nl-claim-timeline-card .nl-claim-comment-row{
 display:grid!important;grid-template-columns:minmax(0,1fr) auto;
 grid-template-rows:auto auto;gap:7px 12px;align-items:end;min-width:0
}
.nl-claim-timeline-card .nl-claim-comment-row textarea{
 grid-column:1;grid-row:1;width:100%;min-width:0;min-height:88px;
 margin:0;border-radius:11px!important;resize:vertical
}
.nl-claim-timeline-card .nl-claim-comment-row>.nl18-field-counter{
 grid-column:1;grid-row:2;justify-self:end;margin:0!important;align-self:center;white-space:nowrap
}
.nl-claim-timeline-card .nl-claim-comment-row>button{
 grid-column:2;grid-row:1;align-self:end;min-height:44px;
 padding:10px 20px!important;border-radius:11px!important;white-space:nowrap
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-evidence-card .evidence-item-card,
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-timeline-card .list-group-item{
 background:#26384b!important;border-color:#4b6279!important;color:#edf4fd!important
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-timeline-card .list-group-item :is(.text-dark,.text-muted){color:#d6e2f0!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-timeline-card .list-group-item .badge{
 background:#354b61!important;color:#f4f8ff!important;border-color:#63809a!important
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-timeline-card .nl18-field-counter{color:#bed0e1!important}
@media(max-width:600px){
 .nl-claim-evidence-card>.nl-card-header-styled,.nl-claim-timeline-card>.nl-card-header-styled{padding:13px!important}
 .nl-claim-evidence-card .evidence-item-card{padding:12px}
 .nl-claim-evidence-card .evidence-item-card>div>div:last-child>.btn,
 .nl-claim-evidence-card .evidence-item-card>div>div:last-child>form,
 .nl-claim-evidence-card .evidence-item-card>div>div:last-child>.nl-evidence-rename{flex:1 1 120px}
 .nl-claim-evidence-card .evidence-item-card>div>div:last-child :is(.btn,summary.btn){width:100%}
 .nl-claim-evidence-card .nl-claim-upload-row{grid-template-columns:minmax(0,1fr)}
 .nl-claim-evidence-card .nl-claim-upload-row button{width:100%}
 .nl-claim-timeline-card .nl-claim-comment-row{grid-template-columns:minmax(0,1fr) auto}
 .nl-claim-timeline-card .nl-claim-comment-row>button{padding-inline:15px!important}
}
@media(max-width:380px){
 .nl-claim-timeline-card .nl-claim-comment-row{grid-template-columns:minmax(0,1fr)}
 .nl-claim-timeline-card .nl-claim-comment-row>button{grid-column:1;grid-row:3;justify-self:end}
}

/* v20.16: Evidence Rename/Delete use exactly the filled primary-orange action treatment.
   These two scoped controls remain solid in both themes without affecting Delete semantics. */
body.nl-themed-page.nl-themed-page .nl-view-body .nl-claim-evidence-card .evidence-item-card :is(summary.nl-evidence-solid-action,button.nl-evidence-solid-action),
html[data-nl-mode="dark"] body.nl-themed-page.nl-themed-page .nl-view-body .nl-claim-evidence-card .evidence-item-card :is(summary.nl-evidence-solid-action,button.nl-evidence-solid-action){
 background:var(--nl-action-gradient,linear-gradient(112deg,#bf430d,#e76a15))!important;
 background-image:var(--nl-action-gradient,linear-gradient(112deg,#bf430d,#e76a15))!important;
 background-color:#ce510e!important;
 color:#fff!important;-webkit-text-fill-color:#fff!important;
 border:1px solid #ba430f!important;
 border-radius:12px!important;
 box-shadow:0 5px 13px rgba(170,60,11,.16)!important;
 font-weight:750!important;
 text-decoration:none!important;
}
body.nl-themed-page.nl-themed-page .nl-view-body .nl-claim-evidence-card .evidence-item-card :is(summary.nl-evidence-solid-action,button.nl-evidence-solid-action):is(:hover,:focus-visible),
html[data-nl-mode="dark"] body.nl-themed-page.nl-themed-page .nl-view-body .nl-claim-evidence-card .evidence-item-card :is(summary.nl-evidence-solid-action,button.nl-evidence-solid-action):is(:hover,:focus-visible){
 background:var(--nl-action-hover,linear-gradient(112deg,#a73507,#d4560e))!important;
 background-image:var(--nl-action-hover,linear-gradient(112deg,#a73507,#d4560e))!important;
 color:#fff!important;-webkit-text-fill-color:#fff!important;
 border-color:#b13c09!important;
 box-shadow:0 8px 18px rgba(170,60,11,.27)!important;
}

/* v20.23 - claims evidence toolbar and readable timeline */
body[data-nl-screen="module7-claim_details"] .evidence-item-card{transition:box-shadow .18s ease;border-radius:14px!important}
body[data-nl-screen="module7-claim_details"] .evidence-item-card:hover{box-shadow:0 8px 22px rgba(131,76,29,.12)}
body[data-nl-screen="module7-claim_details"] .nl-claim-evidence-card .evidence-item-card>div>div:last-child{gap:9px!important}
body[data-nl-screen="module7-claim_details"] .nl-claim-evidence-card .nl23-claim-evidence-hint{margin:0 0 12px}
body[data-nl-screen="module7-claim_details"] .nl-claim-timeline-card .list-group-item{line-height:1.55}
html[data-nl-mode="dark"] body[data-nl-screen="module7-claim_details"] .nl-claim-evidence-card .nl23-claim-evidence-hint{color:#cad8e8!important}

</style>
</head>
<body data-nl-screen="module7-claim_details" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-body nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module7_claim_details__2} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">


<main class="nl-claims-content container-fluid p-0">
        <!-- Title and Quick Action Bar -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${requestScope.nlv_Module7_claim_details__3}?action=list" class="text-muted text-decoration-none">CLAIMS</a></li>
                        <li class="breadcrumb-item text-muted">CLAIM</li>
                        <li class="breadcrumb-item active">${requestScope.nlv_Module7_claim_details__4}</li>
                    </ol>
                </nav>
                <div class="d-flex align-items-center gap-3">
                    <h1 class="h3 fw-bold mb-0">Claim ${requestScope.nlv_Module7_claim_details__5}</h1>
                    <span class="badge rounded-pill ${requestScope.nlv_Module7_claim_details__6} px-3 py-1">
                        ● ${requestScope.nlv_Module7_claim_details__7}
                    </span>
                </div>
                <p class="text-muted mb-0">Review submitted evidence, verification timeline, and settlement status.</p>
            </div>
            <div class="d-flex gap-2">
                <a class="btn btn-outline-dark btn-sm" href="${requestScope.nlv_Module7_claim_details__8}?action=list">
                    &larr; All Claims
                </a>
                <a class="btn btn-warning btn-sm" target="_blank" rel="noopener" href="${requestScope.nlv_Module7_claim_details__9}?action=printReport&amp;claim_id=${requestScope.nlv_Module7_claim_details__10}">Print claim PDF</a>
                <a class="btn btn-outline-warning btn-sm" href="${requestScope.nlv_Module7_claim_details__11}?action=downloadReport&amp;claim_id=${requestScope.nlv_Module7_claim_details__12}">Download claim PDF</a>
                <!-- Claim report is not a financial invoice and does not create payment records. -->
                
            </div>
        </div>

        <section class="card shadow-sm p-3 mb-4 rounded-4 border-warning-subtle" aria-label="Claim at a glance">
          <div class="row g-3 align-items-center">
            <div class="col-md-4"><span class="text-secondary small">Compensation requested</span><div class="h4 fw-bold mb-0">₹${requestScope.nlv_Module7_claim_details__13}</div></div>
            <div class="col-md-4"><span class="text-secondary small">Approved settlement</span><div class="h4 fw-bold mb-0">₹${requestScope.nlv_Module7_claim_details__14}</div></div>
            <div class="col-md-4"><span class="text-secondary small">Next step</span><div class="fw-semibold">${requestScope.nlv_Module7_claim_details__15}</div></div>
          </div>
          <div class="small text-secondary mt-3">Print and Download generate the same professional A4 claim statement. A claim statement is not a payment receipt or additional shipment invoice.</div>
        </section>
                ${requestScope.nlv_Module7_claim_details__16}

        <!-- Alert messages -->
        ${requestScope.nlv_Module7_claim_details__17}
        ${requestScope.nlv_Module7_claim_details__18}
        ${requestScope.nlv_Module7_claim_details__19}
        ${requestScope.nlv_Module7_claim_details__20}
        ${requestScope.nlv_Module7_claim_details__21}

        <!-- Status Progress Stepper -->
        <div class="nl-card py-3 mb-4 card border-0 shadow-sm rounded-4 p-4 border-warning-subtle">
            
            <div class="nl-stepper d-flex flex-wrap gap-2 mb-4">
                <div class="nl-step badge text-bg-light border rounded-pill p-2 ${requestScope.nlv_Module7_claim_details__22}">
                    <div class="nl-step-icon fw-bold me-2">1</div>
                    <div class="nl-step-title fw-medium">Submitted</div>
                </div>
                <div class="nl-step badge text-bg-light border rounded-pill p-2 ${requestScope.nlv_Module7_claim_details__23}">
                    <div class="nl-step-icon fw-bold me-2">2</div>
                    <div class="nl-step-title fw-medium">Under Review</div>
                </div>
                <div class="nl-step badge text-bg-light border rounded-pill p-2 ${requestScope.nlv_Module7_claim_details__24}">
                    <div class="nl-step-icon fw-bold me-2">3</div>
                    <div class="nl-step-title fw-medium">${requestScope.nlv_Module7_claim_details__25}</div>
                </div>
                <div class="nl-step badge text-bg-light border rounded-pill p-2 ${requestScope.nlv_Module7_claim_details__26}">
                    <div class="nl-step-icon fw-bold me-2">4</div>
                    <div class="nl-step-title fw-medium">Settled</div>
                </div>
            </div>
        </div>

        <!-- KPI Metrics Row -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card accent-shipment card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <small class="text-muted fw-bold">SHIPMENT NUMBER</small>
                    <div class="fw-bold mt-1 text-primary font-monospace">${requestScope.nlv_Module7_claim_details__27}</div>
                    <small class="text-muted">ID: ${requestScope.nlv_Module7_claim_details__28}</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card accent-claim card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <small class="text-muted fw-bold">CLAIMED AMOUNT</small>
                    <div class="fw-bold mt-1">₹${requestScope.nlv_Module7_claim_details__29}</div>
                    <small class="text-muted">Filing valuation</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card accent-approved card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <small class="text-muted fw-bold">APPROVED AMOUNT</small>
                    <div class="fw-bold mt-1 text-success">₹${requestScope.nlv_Module7_claim_details__30}</div>
                    <small class="text-muted">Settlement payout</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card accent-type card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <small class="text-muted fw-bold">CLAIM NATURE</small>
                    <div class="fw-bold mt-1 text-dark">${requestScope.nlv_Module7_claim_details__31}</div>
                    <small class="text-muted">${requestScope.nlv_Module7_claim_details__32}</small>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Left Column: Claim Details &amp; Evidence -->
            <div class="col-lg-7">
                <!-- Primary Claim Particulars Card -->
                <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">
                    <div class="nl-card-header-styled card-header border-0 rounded-top-4 bg-warning-subtle p-3">
                        <h5 class="fw-bold mb-0"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjQiIHk9IjIiIHdpZHRoPSIxNiIgaGVpZ2h0PSIyMCIgcng9IjIiLz48cGF0aCBkPSJNOCA4aDhNOCAxMmg4TTggMTZoNiIvPjwvc3ZnPg==" width="20" height="20" alt="" aria-hidden="true" class="me-1"> Claim Particulars &amp; Assessment</h5>
                        <span class="badge bg-light text-dark border">Ref #${requestScope.nlv_Module7_claim_details__33}</span>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-sm-6">
                            <span class="text-muted small d-block">Container Identifier</span>
                            <span class="fw-semibold font-monospace">${requestScope.nlv_Module7_claim_details__34}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted small d-block">Filing Date</span>
                            <span class="fw-semibold">${requestScope.nlv_Module7_claim_details__35}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted small d-block">Settlement Date</span>
                            <span class="fw-semibold">${requestScope.nlv_Module7_claim_details__36}</span>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted small d-block">Current Status</span>
                            <span class="badge ${requestScope.nlv_Module7_claim_details__37}">${requestScope.nlv_Module7_claim_details__38}</span>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="text-muted small fw-bold d-block mb-1">Issue &amp; Damage Description</label>
                        <div class="p-3 bg-light rounded-3 text-dark border">
                            ${requestScope.nlv_Module7_claim_details__39}
                        </div>
                    </div>

                    <div>
                        <label class="text-muted small fw-bold d-block mb-1">Seller Assessment / Inspection Remarks</label>
                        <div class="p-3 bg-light rounded-3 text-dark border">
                            ${requestScope.nlv_Module7_claim_details__40}
                        </div>
                    </div>
                </div>

                ${requestScope.nlv_Module7_claim_details__41}
                <!-- ========================================================================= -->
                <!-- REQUIREMENT 2: UPLOADED EVIDENCE SECTION - VISIBLE TO USER               -->
                <!-- ========================================================================= -->
                <div class="card nl-claim-evidence-card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">
                    <div class="nl-card-header-styled card-header border-0 rounded-top-4 bg-warning-subtle p-3">
                        <div class="d-flex align-items-center gap-2">
                            <span><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0xOCA4IDkgMTdhNCA0IDAgMCAxLTYtNkwxMyAxYTYgNiAwIDEgMSA4IDhMMTAgMjBhMiAyIDAgMCAxLTMtM2w4LTgiLz48L3N2Zz4=" width="20" height="20" alt="" aria-hidden="true" class="me-1"></span>
                            <h5 class="fw-bold mb-0">Attached Evidence &amp; Verification</h5>
                        </div>
                        <span class="badge bg-secondary-subtle text-secondary">${requestScope.nlv_Module7_claim_details__42} File${requestScope.nlv_Module7_claim_details__43}</span>
                    </div>

                    ${requestScope.nlv_Module7_claim_details__44}

                    <!-- Add additional evidence if Consumer -->
                    ${requestScope.nlv_Module7_claim_details__45}
                </div>
            </div>

            <!-- Right Column: Status Operations, Seller Actions, Comments -->
            <div class="col-lg-5">
                <!-- Seller Decision / Review Card -->
                ${requestScope.nlv_Module7_claim_details__46}

                <!-- Settle Claim Card (Seller only) -->
                ${requestScope.nlv_Module7_claim_details__47}

                <!-- Audit History and Communication Timeline -->
                <div class="card nl-claim-timeline-card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">
                    <div class="nl-card-header-styled card-header border-0 rounded-top-4 bg-warning-subtle p-3">
                        <h5 class="fw-bold mb-0"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM2MTQ1MmYiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxjaXJjbGUgY3g9IjEyIiBjeT0iMTIiIHI9IjkiLz48cGF0aCBkPSJNMTIgNnY2bDQgMyIvPjwvc3ZnPg==" width="20" height="20" alt="" aria-hidden="true" class="me-1"> History &amp; Timeline</h5>
                        <span class="badge bg-light text-muted border">${requestScope.nlv_Module7_claim_details__48} Events</span>
                    </div>

                    ${requestScope.nlv_Module7_claim_details__49}

                    <!-- Add Comment -->
                    ${requestScope.nlv_Module7_claim_details__50}
                </div>
            </div>
        </div>
    </main>

<!-- Claim PDF is generated from authorized data by model.ClaimPdfBuilder,
     not by printing the entire authenticated webpage. -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script>
(function(){'use strict';
 const choice=document.querySelector('select[name="decision"],select[name="status"],select[name="new_status"]');
 const amount=document.getElementById('approved_amount');if(!choice||!amount)return;
 const full=Number(amount.dataset.nlClaimFull||amount.value||0);
 choice.addEventListener('change',()=>{
  if(choice.value==='PARTIALLY_APPROVED' && full>0){amount.value=(Math.round(full*50)/100).toFixed(2);amount.setAttribute('aria-description','Suggested 50 percent; adjust as necessary');}
  else if(choice.value==='APPROVED' && full>0){amount.value=full.toFixed(2);}
 });
})();
</script>
</body>
</html>