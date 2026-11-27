<jsp:useBean id="nlViewSupport_Module7_claims" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module7_claims" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module7_claims" property="view" value="Module7/claims.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.math.*,model.*" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Claims Management | N-LOGISTIC</title>
    <!-- Bootstrap 5 CSS CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    
<%@ include file="../shared/_theme.jsp" %>

<style>
/* Claims register: prevent broken identifiers / Copy controls, preserve full values. */
.nl-themed-page .nl-view-body #claimTable{min-width:1300px!important;width:100%!important;table-layout:fixed;border-collapse:separate;border-spacing:0}
.nl-themed-page .nl-view-body #claimTable th,.nl-themed-page .nl-view-body #claimTable td{padding:16px 13px!important;vertical-align:middle!important;line-height:1.45}
.nl-themed-page .nl-view-body #claimTable th{white-space:normal!important;line-height:1.3;font-size:.73rem!important;letter-spacing:.02em}
.nl-themed-page .nl-view-body #claimTable .nl-claim-id-wrap{display:flex;align-items:center;gap:8px;flex-wrap:nowrap;min-width:0}
.nl-themed-page .nl-view-body #claimTable .claim-link{display:block;white-space:nowrap!important;overflow:visible!important;overflow-wrap:normal!important;word-break:normal!important;flex:none;text-underline-offset:3px;font-size:.82rem}
.nl-themed-page .nl-view-body #claimTable .nl-claim-copy{flex:none;border:1px solid #eccab0;border-radius:8px;padding:4px 7px;line-height:1.2;white-space:nowrap!important;font-size:.71rem;font-weight:700;background:#fff8ef;color:#a24c18}
.nl-themed-page .nl-view-body #claimTable .nl-claim-copy:hover,.nl-themed-page .nl-view-body #claimTable .nl-claim-copy:focus-visible{background:#cf5b1b;color:#fff}
.nl-themed-page .nl-view-body #claimTable .nl-claim-shipment{font-size:.73rem;font-weight:700;color:#574435;white-space:nowrap!important;overflow-wrap:normal!important;word-break:normal!important}
.nl-themed-page .nl-view-body #claimTable .badge{white-space:nowrap!important;font-size:.7rem!important}
.nl-themed-page .nl-view-body #claimTable td.text-end{font-variant-numeric:tabular-nums;white-space:nowrap!important}
.nl-themed-page .nl-view-body #claimTable .nl-claim-datetime{overflow-wrap:normal;word-break:normal}
.nl-themed-page .nl-view-body #claimTable .nl-claim-actions{min-width:0!important;gap:7px}
.nl-themed-page .nl-view-body #claimTable .nl-claim-actions a{font-size:.75rem!important;min-height:35px!important;padding:6px 7px!important;white-space:nowrap!important}
.nl-themed-page .nl-view-body #claimTable .nl-claim-actions img{width:16px;height:16px}
.nl-themed-page .nl-view-body #claimTable tbody tr:hover{background:#fff2e7!important}
.nl-themed-page .nl-view-body #claimTable+*{max-width:100%}
@media(max-width:700px){.nl-themed-page .nl-view-body #claimTable{min-width:1250px!important}.nl-themed-page .nl-view-body #claimTable tbody tr{display:table-row!important}.nl-themed-page .nl-view-body #claimTable tbody td{display:table-cell!important}.nl-themed-page .nl-view-body #claimTable thead{display:table-header-group!important}.nl-themed-page .nl-view-body #claimTable tbody td:before{display:none!important}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-surface,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-kpi,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-policy,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-note,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-empty,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-preview-card{background:#203044!important;color:#edf4fc!important;border-color:#526b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-surface :is(h2,h3,p,small,strong){color:#edf4fc!important}

/* v20.23 - claim search and timeline status readability */
body[data-nl-screen="module7-claims"] :is(.nl-kpi-card,.card){border-radius:17px!important}
body[data-nl-screen="module7-claims"] .nl-claim-register :is(th,td){vertical-align:middle!important}
body[data-nl-screen="module7-claims"] .nl-claim-register tbody tr:hover{box-shadow:inset 3px 0 #e86f26}
body[data-nl-screen="module7-claims"] :is(.nl-claims-tools,.nl-claims-actions){gap:10px;flex-wrap:wrap}

</style>
</head>
<body data-nl-screen="module7-claims" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-body nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module7_claims__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">


<main class="nl-claims-content container-fluid p-0">
        <!-- Breadcrumb &amp; Title Bar -->
        <div class="d-flex justify-content-between align-items-start mb-3 gap-3 flex-wrap">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${requestScope.nlv_Module7_claims__2}/containerMovement?action=shipments" class="text-muted text-decoration-none">WORKSPACE</a></li>
                        <li class="breadcrumb-item text-muted">CLAIMS</li>
                        <li class="breadcrumb-item active">DASHBOARD</li>
                    </ol>
                </nav>
                <h1 class="h3 fw-bold mb-1">Claims &amp; <span class="nl-title-accent">Damage Management</span></h1>
                <p class="text-muted mb-0">Manage cargo loss, damage claims, evidence verification, and settlement auditing.</p>
            </div>
            <div class="nl-noprint d-flex gap-2 d-print-none">
                
                
                ${requestScope.nlv_Module7_claims__3}
            </div>
        </div>

        <form method="get" action="${requestScope.nlv_Module7_claims__4}" class="card p-3 mb-4 rounded-4 border-warning-subtle shadow-sm" aria-label="Search claims">
           <input type="hidden" name="action" value="list"><input type="hidden" name="status" value="${requestScope.nlv_Module7_claims__5}">
           <div class="row g-2 align-items-end"><div class="col-md-5"><label class="form-label">Claim number or shipment ID</label><input class="form-control" type="search" name="q" maxlength="60" value="${requestScope.nlv_Module7_claims__6}" placeholder="Claim # or shipment ID"></div>
           <div class="col-md-3"><label class="form-label">Filed from</label><input class="form-control" type="date" name="filedFrom" value="${requestScope.nlv_Module7_claims__7}"></div>
           <div class="col-md-3"><label class="form-label">Filed to</label><input class="form-control" type="date" name="filedTo" value="${requestScope.nlv_Module7_claims__8}"></div>
           <div class="col-md-1"><button class="btn btn-warning w-100" title="Search">Go</button></div></div>
        </form>
        <!-- Alert Banners -->
        ${requestScope.nlv_Module7_claims__9}
        ${requestScope.nlv_Module7_claims__10}
        ${requestScope.nlv_Module7_claims__11}
        ${requestScope.nlv_Module7_claims__12}
        ${requestScope.nlv_Module7_claims__13}

        ${requestScope.nlv_Module7_claims__14}
        <!-- KPI Summary Cards -->
        <div class="row g-3 mb-4 nl-noprint d-print-none">
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card nl-dash-kpi accent-total card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <div class="nl-kpi-label small text-secondary d-block mb-2">Total Claims</div>
                    <div class="nl-kpi-value fs-2 fw-bold text-dark d-block mb-1">${requestScope.nlv_Module7_claims__15}</div>
                    <small class="text-muted">All recorded claims</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card nl-dash-kpi accent-submitted card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <div class="nl-kpi-label small text-secondary d-block mb-2">Submitted</div>
                    <div class="nl-kpi-value text-warning-emphasis fs-2 fw-bold text-dark d-block mb-1">${requestScope.nlv_Module7_claims__16}</div>
                    <small class="text-muted">Awaiting seller review</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card nl-dash-kpi accent-review card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <div class="nl-kpi-label small text-secondary d-block mb-2">Under Review</div>
                    <div class="nl-kpi-value text-primary fs-2 fw-bold text-dark d-block mb-1">${requestScope.nlv_Module7_claims__17}</div>
                    <small class="text-muted">Active investigation</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="nl-kpi-card nl-dash-kpi accent-settled card border-0 shadow-sm rounded-4 p-4 h-100 border-warning-subtle">
                    <div class="nl-kpi-label small text-secondary d-block mb-2">Approved &amp; Settled</div>
                    <div class="nl-kpi-value text-success fs-2 fw-bold text-dark d-block mb-1">${requestScope.nlv_Module7_claims__18}</div>
                    <small class="text-muted">Resolved claims</small>
                </div>
            </div>
        </div>

        <!-- Filter &amp; Table Card -->
        <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">
            <div class="row g-3 mb-3 align-items-end nl-noprint d-print-none">
                <div class="col-md-7">
                    <div class="form-label fw-bold text-muted small mb-1">Browse and filter claims</div>
                    <p class="text-muted small">Use the status filter below to narrow claims.</p>
                </div>
                <div class="col-md-5">
                    <label class="form-label fw-bold text-muted small mb-1" for="claimStatus">Filter by Status</label>
                    <form method="get" action="${requestScope.nlv_Module7_claims__19}" class="d-flex gap-2"><input type="hidden" name="action" value="list"><select id="claimStatus" name="status" class="form-select">
                        <jsp:setProperty name="nlViewSupport_Module7_claims" property="fragment" value="nlv_Module7_claims__20" /><jsp:getProperty name="nlViewSupport_Module7_claims" property="fragment" />
                    </select><button type="submit" class="btn btn-outline-dark">Filter</button></form>
                </div>
            </div>

            <!-- Claims Table -->
            <div class="table-responsive rounded-3">
                <table class="table table-hover align-middle table-striped mb-0 nl-claim-register" id="claimTable" data-nl-no-auto-copy="true" aria-label="Claims register">
                    <colgroup><col style="width:18%"><col style="width:17%"><col style="width:15%"><col style="width:10%"><col style="width:10%"><col style="width:12%"><col style="width:9%"><col style="width:9%"></colgroup>
                    <thead class="table-warning">
                        <tr>
                            <th>Claim No</th>
                            <th>Shipment</th>
                            <th>Claim Type</th>
                            <th class="text-end">Claimed Amount</th>
                            <th class="text-end">Approved Amount</th>
                            <th>Status</th>
                            <th>Filing Date</th>
                            <th class="text-center nl-noprint d-print-none">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <jsp:setProperty name="nlViewSupport_Module7_claims" property="fragment" value="nlv_Module7_claims__21" /><jsp:getProperty name="nlViewSupport_Module7_claims" property="fragment" />
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-3 text-muted small nl-noprint d-print-none">
                <div>Showing <strong>${requestScope.nlv_Module7_claims__22}</strong> claims</div>
                <div>Click on any claim number or "View Details" to view evidence, settlement status, or print the report.</div>
            </div>
        </div>
    </main>




<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
</body>
</html>
