<jsp:useBean id="nlViewSupport_Module1_customers" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_customers" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_customers" property="view" value="Module1/customers.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,model.Customer" %>

<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Customer Management | N-LOGISTIC</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="../shared/_theme.jsp" %>
<style>
.nl-customer-admin{--cu-ink:#3a281f;--cu-accent:#c75418;--cu-line:#ecd5c3;--cu-muted:#7a6456;color:var(--cu-ink)}
.nl-customer-admin .cu-hero{display:grid;grid-template-columns:minmax(0,1.35fr) minmax(260px,.8fr);gap:18px;border:1px solid #ecccb0;border-radius:24px;background:linear-gradient(125deg,#fffdfa,#fff1e1 72%,#ffe5cb);padding:clamp(18px,2.4vw,32px);box-shadow:0 16px 34px rgba(87,53,23,.08);margin-bottom:18px;overflow:hidden;position:relative}
.nl-customer-admin .cu-hero:after{content:"";position:absolute;right:-80px;top:-78px;width:250px;height:250px;border-radius:50%;border:1px solid rgba(212,91,23,.13);box-shadow:0 0 0 34px rgba(212,91,23,.05),0 0 0 68px rgba(212,91,23,.03)}
.nl-customer-admin .cu-eyebrow{font-size:.76rem;font-weight:850;letter-spacing:.14em;text-transform:uppercase;color:#ae4a1b}
.nl-customer-admin h1{font-size:clamp(1.9rem,3vw,2.9rem);font-weight:900;margin:.45rem 0}
.nl-customer-admin .cu-desc{max-width:720px;color:var(--cu-muted);line-height:1.6;margin:0}
.nl-customer-admin .cu-hero-side{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px;align-content:start;position:relative;z-index:1}
.nl-customer-admin .cu-mini{background:rgba(255,255,255,.68);backdrop-filter:blur(4px);border:1px solid #edcfb6;border-radius:16px;padding:14px;min-height:96px}
.nl-customer-admin .cu-mini strong{display:block;font-size:1.55rem;color:#b14916;line-height:1.1}
.nl-customer-admin .cu-mini span{display:block;font-weight:760;font-size:.84rem;margin-top:4px}
.nl-customer-admin .cu-mini small{display:block;color:#82695a;margin-top:8px;font-size:.76rem}
.nl-customer-admin .cu-card{background:#fffdfa;border:1px solid var(--cu-line);border-radius:20px;box-shadow:0 14px 28px rgba(88,54,27,.06);padding:18px;margin-bottom:18px}
.nl-customer-admin .cu-card h2{font-size:1.2rem;font-weight:860;margin:0 0 4px}
.nl-customer-admin .cu-card p{color:var(--cu-muted)}
.nl-customer-admin .cu-toolbar{display:flex;gap:10px;align-items:center;justify-content:space-between;flex-wrap:wrap;margin-bottom:14px}
.nl-customer-admin .cu-kpis{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin-bottom:16px}
.nl-customer-admin .cu-kpi{background:#fff7ef;border:1px solid #efd6c1;border-radius:15px;padding:14px}
.nl-customer-admin .cu-kpi span{display:block;font-size:.78rem;color:#7d6455;font-weight:700}.nl-customer-admin .cu-kpi strong{display:block;font-size:1.5rem;color:#b24613;line-height:1.15;margin-top:6px}
.nl-customer-admin .cu-btn{border-radius:12px;font-weight:800;padding:10px 16px}.nl-customer-admin .cu-btn-primary{background:#cf5a18;border:1px solid #c35215;color:#fff}.nl-customer-admin .cu-btn-soft{background:#fff7ef;border:1px solid #e8c8aa;color:#8f4318}
.nl-customer-admin .cu-form label{font-size:.84rem;font-weight:760;color:#674b3a;margin-bottom:6px}.nl-customer-admin .cu-form .form-control,.nl-customer-admin .cu-form .form-select{border-radius:13px;border-color:#e8ccb7;background:#fffdfa;min-height:46px}.nl-customer-admin .cu-form textarea.form-control{min-height:110px}
.nl-customer-admin .cu-table-wrap{border:1px solid #eedbcc;border-radius:16px;overflow:hidden;background:#fff}.nl-customer-admin .cu-table{margin:0;min-width:980px}.nl-customer-admin .cu-table thead th{background:#fff2e5;color:#93431a;text-transform:uppercase;font-size:.73rem;letter-spacing:.07em;border-bottom:1px solid #edd7c5;padding:14px 12px;white-space:nowrap}.nl-customer-admin .cu-table tbody td{padding:14px 12px;border-bottom:1px solid #f3e5d8;vertical-align:middle;font-size:.88rem}.nl-customer-admin .cu-table tbody tr:nth-child(even){background:#fffaf4}.nl-customer-admin .cu-table tbody tr:hover{background:#fff0e1}
.nl-customer-admin .cu-actions{display:flex;gap:8px;flex-wrap:wrap}.nl-customer-admin .cu-link-btn{border:1px solid #e7c9ad;background:#fffaf4;color:#954519;border-radius:10px;padding:8px 12px;font-size:.8rem;font-weight:800}.nl-customer-admin .cu-link-btn.cu-danger{border-color:#efbdb8;color:#b1382d;background:#fff6f5}
.nl-customer-admin .cu-search-grid{display:grid;grid-template-columns:2.2fr 1.3fr auto;gap:12px}.nl-customer-admin .cu-helper{font-size:.78rem;color:#8a6c5a}.nl-customer-admin .cu-empty{padding:30px 18px;text-align:center;color:#7c6557}
.nl-customer-admin .cu-modal .modal-content{border-radius:24px;border:1px solid #ebc8ad;overflow:hidden;box-shadow:0 28px 64px rgba(78,39,12,.22)}.nl-customer-admin .cu-modal .modal-header{border-bottom:1px solid #edd6c3;background:linear-gradient(140deg,#fff3e7,#fffaf4);padding:20px 22px}.nl-customer-admin .cu-modal .modal-body{padding:22px}.nl-customer-admin .cu-modal .modal-footer{border-top:1px solid #edd6c3;padding:18px 22px;background:#fffdfa}
.nl-customer-admin .cu-modal-title{font-size:1.8rem;font-weight:860;line-height:1.1;margin:4px 0 0}.nl-customer-admin .cu-modal-kicker{font-size:.76rem;letter-spacing:.14em;text-transform:uppercase;font-weight:820;color:#af4a1a}
@media(max-width:1100px){.nl-customer-admin .cu-search-grid{grid-template-columns:1fr 1fr}.nl-customer-admin .cu-search-grid .cu-search-actions{grid-column:1/-1}.nl-customer-admin .cu-hero{grid-template-columns:1fr}.nl-customer-admin .cu-kpis{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:640px){.nl-customer-admin .cu-kpis{grid-template-columns:1fr}.nl-customer-admin .cu-modal .modal-body,.nl-customer-admin .cu-modal .modal-header,.nl-customer-admin .cu-modal .modal-footer{padding:16px}}

/* v16.3: the modal nodes are siblings of main, so scope their theme through body. */
.nl-customer-admin .cu-modal .modal-content{background:#fffaf4;border-radius:26px;box-shadow:0 30px 80px #4726144d}
.nl-customer-admin .cu-modal .modal-header{background:linear-gradient(118deg,#fff5ea,#ffe3ca);align-items:flex-start}
.nl-customer-admin .cu-modal .modal-footer{background:#fff2e6;gap:10px}
.nl-customer-admin .cu-modal .cu-modal-kicker{font-weight:900;color:#b44c18;letter-spacing:.12em}
.nl-customer-admin .cu-modal .cu-form label{font-weight:800;color:#6b4532}
.nl-customer-admin .cu-modal .cu-form .form-control,.nl-customer-admin .cu-modal .cu-form .form-select{background:#fffdf9;border:1px solid #e2bf9e;box-shadow:none;border-radius:13px}
.nl-customer-admin .cu-modal .cu-form .form-control:focus,.nl-customer-admin .cu-modal .cu-form .form-select:focus{border-color:#d45c1d;box-shadow:0 0 0 3px #df884830}
.nl-customer-admin .cu-btn-primary{background:linear-gradient(110deg,#bf4811,#e66a20);color:white!important;border-color:#b94412;box-shadow:0 8px 18px #c4561e24}
.nl-customer-admin .cu-btn-primary:hover{background:linear-gradient(110deg,#a8370d,#d15c15);transform:translateY(-1px)}
.nl-customer-admin .cu-btn-soft:hover{background:#ffe7d0}
.nl-customer-admin .cu-modal .modal-dialog{max-width:min(980px,94vw)}
.nl-customer-admin .cu-hero-art{position:relative;z-index:1;align-self:center;display:flex;align-items:center;justify-content:center;min-height:208px}
.nl-customer-admin .cu-hero-scene{width:min(100%,440px);height:auto;filter:drop-shadow(0 16px 20px #ac6e4430)}

.nl-customer-admin .cu-hero-scene .cu-id{animation:cuLift 5s ease-in-out infinite}
.nl-customer-admin .cu-hero-scene .cu-check{animation:cuPulse 4.5s ease-in-out infinite;transform-origin:349px 78px}
.nl-customer-admin .cu-hero-scene .cu-spark{animation:cuTwinkle 3.5s ease-in-out infinite}
@keyframes cuLift{0%,100%{transform:translateY(0)}50%{transform:translateY(-6px)}}
@keyframes cuPulse{0%,100%{transform:scale(1)}50%{transform:scale(1.09)}}
@keyframes cuTwinkle{0%,100%{opacity:1}50%{opacity:.46}}
@media(max-width:1080px){.nl-customer-admin .cu-hero-art{min-height:180px}}
@media(prefers-reduced-motion:reduce){.nl-customer-admin .cu-hero-scene *{animation:none!important;transition:none!important}}

/* No /assets or SVG: customer identification illustration from CSS shapes. */
.nl-customer-admin .cu-hero-scene{position:relative;isolation:isolate;width:min(100%,440px);height:255px;flex:none;filter:drop-shadow(0 16px 18px rgba(124,72,40,.12))}
.nl-customer-admin .cu-visual-halo{position:absolute;inset:12px 22px 0;border-radius:50%;border:1px solid rgba(205,100,41,.16);background:radial-gradient(circle at 55% 48%,rgba(255,255,255,.85),rgba(255,216,181,.16) 75%,transparent 76%);box-shadow:0 0 0 18px rgba(255,231,203,.23)}
.nl-customer-admin .cu-css-account{position:absolute;z-index:2;top:45px;left:13%;width:73%;height:160px;border:3px solid #9e532c;border-radius:20px;background:linear-gradient(145deg,#fffcf4,#ffdeba);box-shadow:9px 12px 0 rgba(148,74,33,.13);transform:rotate(-7deg);animation:cuAccountFloat 6s ease-in-out infinite}
.nl-customer-admin .cu-css-avatar{position:absolute;top:28px;left:22px;width:101px;height:95px;border-radius:16px;background:linear-gradient(160deg,#ffbb86,#f3965d);overflow:hidden;border:1px solid rgba(118,60,38,.2)}
.nl-customer-admin .cu-css-head{position:absolute;top:15px;left:34px;width:34px;height:34px;border-radius:50%;background:#ffead4;border:3px solid #b66436}
.nl-customer-admin .cu-css-shoulders{position:absolute;bottom:-16px;left:10px;width:83px;height:65px;border-radius:46% 46% 0 0;background:#984b29;border:3px solid #b76a43}
.nl-customer-admin .cu-css-account-lines{position:absolute;left:142px;right:19px;top:44px;display:grid;gap:12px}
.nl-customer-admin .cu-css-account-lines i{height:10px;border-radius:10px;background:#d49b70}.nl-customer-admin .cu-css-account-lines i:nth-child(2){width:80%;background:#edbf9d}.nl-customer-admin .cu-css-account-lines i:nth-child(3){width:58%;background:#edbf9d}
.nl-customer-admin .cu-css-account-band{position:absolute;bottom:0;left:0;right:0;height:14px;border-radius:0 0 17px 17px;background:linear-gradient(90deg,#a8512c,#dc7b41)}
.nl-customer-admin .cu-css-check{position:absolute;z-index:4;right:2%;top:12px;width:81px;height:81px;border:8px solid #fff5e8;border-radius:50%;background:linear-gradient(135deg,#e57b3d,#bc4917);box-shadow:0 6px 18px rgba(131,53,21,.19);animation:cuCheckPulse 5s ease-in-out infinite}
.nl-customer-admin .cu-css-check span{position:absolute;top:20px;left:21px;width:25px;height:15px;border-left:6px solid #fff9ef;border-bottom:6px solid #fff9ef;transform:rotate(-45deg);border-radius:2px}
.nl-customer-admin .cu-css-note{position:absolute;z-index:3;left:25%;bottom:10px;width:125px;height:58px;border:2px solid #b26638;background:#fff9ef;border-radius:12px;transform:rotate(8deg);box-shadow:6px 7px rgba(139,73,42,.12);padding:13px 15px;display:grid;gap:7px;animation:cuNoteFloat 5.5s ease-in-out infinite}
.nl-customer-admin .cu-css-note span{height:5px;background:#efbd98;border-radius:7px}.nl-customer-admin .cu-css-note span:last-child{width:58%}
.nl-customer-admin .cu-css-star{position:absolute;width:11px;height:11px;transform:rotate(45deg);border-radius:3px;background:#dc753c;animation:cuStar 3.5s ease-in-out infinite}.nl-customer-admin .cu-star-one{top:28px;left:16%}.nl-customer-admin .cu-star-two{bottom:27px;right:14%;animation-delay:1.2s}
@keyframes cuAccountFloat{0%,100%{transform:translateY(0) rotate(-7deg)}50%{transform:translateY(-7px) rotate(-5deg)}}
@keyframes cuCheckPulse{0%,100%{transform:scale(1)}50%{transform:scale(1.07)}}
@keyframes cuNoteFloat{0%,100%{transform:translateY(0) rotate(8deg)}50%{transform:translateY(-5px) rotate(8deg)}}
@keyframes cuStar{0%,100%{opacity:1}50%{opacity:.35}}
@media(prefers-reduced-motion:reduce){.nl-customer-admin .cu-hero-scene *{animation:none!important}}


/* v16.7 aligned customers hero; artwork uses inline HTML/CSS, not assets. */
.nl-customer-admin .cu-hero{padding:20px 26px!important;grid-template-columns:minmax(0,1.7fr) minmax(240px,.72fr)!important;align-items:center!important;gap:18px!important;min-height:0!important;overflow:visible!important}
.nl-customer-admin .cu-hero-art{min-height:148px!important;height:158px!important;max-height:158px!important;overflow:visible!important;justify-content:flex-end!important;padding-right:6px}
.nl-customer-admin .cu-hero-scene{transform:scale(.54);transform-origin:72% 10%;height:255px!important;margin:0 -6px 0 0!important}
.nl-customer-admin .cu-hero h1{font-size:clamp(1.7rem,2.55vw,2.3rem)!important;margin:3px 0 7px!important}
.nl-customer-admin .cu-hero .cu-desc{font-size:.87rem!important;line-height:1.45!important;max-width:680px}
@media(max-width:800px){.nl-customer-admin .cu-hero{grid-template-columns:1fr!important;padding:18px 20px!important}.nl-customer-admin .cu-hero-art{display:none!important}}

/* v16.9 | fixed-size illustration viewport. The animation no longer extends past the hero. */
.nl-customer-admin .cu-hero{overflow:hidden!important;isolation:isolate;grid-template-columns:minmax(0,1fr) minmax(220px,292px)!important;min-height:195px!important;gap:16px!important;padding:19px 25px!important}
.nl-customer-admin .cu-hero:after{pointer-events:none;z-index:0}
.nl-customer-admin .cu-hero > div:first-child{min-width:0;position:relative;z-index:1}
.nl-customer-admin .cu-hero-art{position:relative!important;z-index:1!important;display:block!important;justify-self:end!important;align-self:center!important;width:min(100%,292px)!important;height:172px!important;min-height:172px!important;max-height:172px!important;overflow:hidden!important;padding:0!important;margin:0!important;border-radius:17px}
.nl-customer-admin .cu-hero-scene{position:absolute!important;top:5px!important;left:3px!important;width:440px!important;max-width:none!important;height:255px!important;min-height:255px!important;margin:0!important;transform:scale(.64)!important;transform-origin:top left!important;filter:none!important}
@media(max-width:840px){.nl-customer-admin .cu-hero{grid-template-columns:1fr!important;padding:18px 20px!important}.nl-customer-admin .cu-hero-art{display:none!important}}
@media(prefers-reduced-motion:reduce){.nl-customer-admin .cu-hero-scene *{animation:none!important}}
/* Accessible, prefilled multi-field customer edit. */
.cu-modal .cu-edit-note{background:#fff1e2;border:1px solid #edccb0;border-radius:13px;padding:13px 15px;font-size:.9rem;color:#72533e;line-height:1.5}
.cu-modal #cuFullCustomerEdit label{display:block;margin:0 0 7px;font-weight:750}
.cu-modal #cuFullCustomerEdit .modal-body .row>div{min-width:0}
</style>
</head>
<body data-nl-screen="module1-customers" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark nl-customer-admin">
<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3">Administration / Customers</div><div class="nl-view-body container-fluid p-0 px-0"><main class="nl-customer-admin">
<section class="cu-hero">
  <div>
    <div class="cu-eyebrow">Administration / Consumer directory</div>
    <h1>Customer management</h1>
    <p class="cu-desc">Keep customer records aligned with users and companies. This refreshed page improves the popup design, adds faster filtering, and keeps frequent administration actions easier to reach.</p>
  </div>
  <div class="cu-hero-art" aria-hidden="true">
<div class="cu-hero-scene" aria-hidden="true">
  <div class="cu-visual-halo"></div>
  <div class="cu-css-account"><div class="cu-css-avatar"><span class="cu-css-head"></span><span class="cu-css-shoulders"></span></div><div class="cu-css-account-lines"><i></i><i></i><i></i></div><span class="cu-css-account-band"></span></div>
  <div class="cu-css-check"><span></span></div>
  <div class="cu-css-note"><span></span><span></span><span></span></div>
  <span class="cu-css-star cu-star-one"></span><span class="cu-css-star cu-star-two"></span>
</div></div>
</section>

${requestScope.nlv_Module1_customers__1}
<section class="cu-card">
  <div class="cu-toolbar">
    <div>
      <h2>Find a customer</h2>
      <p class="mb-0 small">Search from the database, then filter the loaded results instantly without another round trip.</p>
    </div>
    <div class="d-flex gap-2 flex-wrap">
      <button type="button" class="btn cu-btn cu-btn-soft" id="cuExportCsv">Export visible CSV</button>
      <button type="button" class="btn cu-btn cu-btn-primary" data-bs-toggle="modal" data-bs-target="#customerAddModal">+ Add customer</button>
    </div>
  </div>
  <div class="cu-kpis"><div class="cu-kpi"><span>Loaded rows</span><strong>${requestScope.nlv_Module1_customers__2}</strong></div><div class="cu-kpi"><span>Local search</span><strong id="cuVisibleCount">${requestScope.nlv_Module1_customers__3}</strong></div><div class="cu-kpi"><span>Update mode</span><strong>Full details</strong></div></div>
  <form action="Module1Controller" method="get" class="cu-form">
    <input type="hidden" name="action" value="searchCustomers">
    <div class="cu-search-grid">
      <div><label for="cuKeyword">Database search</label><input id="cuKeyword" type="text" name="keyword" class="form-control" value="${requestScope.nlv_Module1_customers__4}" placeholder="Search customer details"></div>
      <div><label for="cuLocalSearch">Loaded table search</label><input id="cuLocalSearch" type="search" class="form-control" placeholder="Filter visible rows instantly"></div>
      <div class="d-flex align-items-end gap-2 cu-search-actions"><button type="submit" class="btn cu-btn cu-btn-primary flex-grow-1">Search</button><a href="Module1Controller?action=customers" class="btn cu-btn cu-btn-soft">Reset</a></div>
    </div>
    <div class="cu-helper mt-2">The current backend contract is preserved: Customer records still use the approved controller and DAO flow.</div>
  </form>
</section>

<section class="cu-card">
  <div class="cu-toolbar"><div><h2>Registered customers</h2><p class="mb-0 small">Use Update to review and edit all permitted customer details together. Delete remains restricted by existing record dependencies.</p></div><div class="small text-secondary"><span id="cuVisibleCountText">${requestScope.nlv_Module1_customers__5}</span> of ${requestScope.nlv_Module1_customers__6} rows visible</div></div>
  <div class="cu-table-wrap table-responsive rounded-4">
    <table class="table cu-table align-middle" id="cuCustomerTable">
      <thead><tr><th>Customer ID</th><th>User ID</th><th>Company ID</th><th>Contact person</th><th>Billing address</th><th>Credit limit</th><th>Actions</th></tr></thead>
      <tbody>
      <jsp:setProperty name="nlViewSupport_Module1_customers" property="fragment" value="nlv_Module1_customers__7" /><jsp:getProperty name="nlViewSupport_Module1_customers" property="fragment" />
      </tbody>
    </table>
  </div>
</section>
</main></div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>

<div class="modal fade cu-modal" id="customerAddModal" tabindex="-1" aria-labelledby="customerAddTitle" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <form action="Module1Controller" method="post" class="cu-form">
        <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_customers__8}"><input type="hidden" name="action" value="addCustomer">
        <div class="modal-header"><div><div class="cu-modal-kicker">Administration / Customer registry</div><h2 class="cu-modal-title" id="customerAddTitle">Add new customer</h2><p class="mb-0 small text-secondary">Create a new customer record with a cleaner popup that follows the current workspace theme.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div>
        <div class="modal-body"><div class="row g-3"><div class="col-lg-6"><label for="cuAddUserId">User ID</label><input id="cuAddUserId" type="number" name="userId" min="1" class="form-control" required></div><div class="col-lg-6"><label for="cuAddCompanyId">Company ID</label><input id="cuAddCompanyId" type="number" name="companyId" min="1" class="form-control" required></div><div class="col-12"><label for="cuAddContact">Contact person</label><input id="cuAddContact" type="text" name="contactPerson" class="form-control" maxlength="100"></div><div class="col-12"><label for="cuAddAddress">Billing address</label><textarea id="cuAddAddress" name="billingAddress" class="form-control" rows="4"></textarea></div><div class="col-lg-6"><label for="cuAddCredit">Credit limit</label><input id="cuAddCredit" type="number" min="0" step="0.01" name="creditLimit" class="form-control"></div><div class="col-lg-6"><label>Helpful note</label><div class="alert alert-warning-subtle border border-warning-subtle rounded-4 mb-0">Use a valid User ID and Company ID that already exist in the approved database. This page keeps the existing backend validation unchanged.</div></div></div></div>
        <div class="modal-footer"><button type="button" class="btn cu-btn cu-btn-soft" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn cu-btn cu-btn-primary">Save customer</button></div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade cu-modal" id="customerUpdateModal" tabindex="-1" aria-labelledby="customerUpdateTitle" aria-hidden="true">
 <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable"><div class="modal-content">
  <form action="Module1Controller" method="post" class="cu-form" id="cuFullCustomerEdit">
   <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_customers__9}"><input type="hidden" name="action" value="updateCustomerAll"><input type="hidden" name="recordId" id="cuUpdateRecordId">
   <div class="modal-header"><div><div class="cu-modal-kicker">Administration / Customer details</div><h2 class="cu-modal-title" id="customerUpdateTitle">Edit customer details</h2><p class="mb-0 small text-secondary" id="cuUpdateSubtitle">Review saved customer details and update one or more fields.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div>
   <div class="modal-body"><div class="cu-edit-note">Contact person, billing address and credit limit can be updated in one save. Linked User ID and Company ID remain unchanged.</div>
    <div class="row g-3 mt-1">
     <div class="col-md-7"><label for="cuEditContact">Contact person</label><input id="cuEditContact" name="contactPerson" class="form-control" maxlength="100"></div>
     <div class="col-md-5"><label for="cuEditCredit">Credit limit (INR) <span class="text-danger">*</span></label><input id="cuEditCredit" name="creditLimit" type="number" min="0" max="9999999999.99" step="0.01" required class="form-control"><div class="form-text">Display and approval rules remain unchanged.</div></div>
     <div class="col-12"><label for="cuEditAddress">Billing address</label><textarea id="cuEditAddress" name="billingAddress" rows="4" class="form-control"></textarea></div>
    </div>
   </div><div class="modal-footer"><button type="button" class="btn cu-btn cu-btn-soft" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn cu-btn cu-btn-primary">Save customer details</button></div>
  </form>
 </div></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){'use strict';
const table=document.getElementById('cuCustomerTable');
if(!table)return;
const rows=Array.from(table.querySelectorAll('tbody tr'));
const localSearch=document.getElementById('cuLocalSearch');
const visibleCount=document.getElementById('cuVisibleCount');
const visibleCountText=document.getElementById('cuVisibleCountText');
function filterRows(){
  const term=(localSearch.value||'').trim().toLowerCase();
  let shown=0;
  rows.forEach(row=>{
    if(row.children.length===1){row.hidden=false;return;}
    const ok=!term || (row.dataset.customerSearch||'').includes(term);
    row.hidden=!ok;
    if(ok)shown++;
  });
  if(visibleCount)visibleCount.textContent=String(shown);
  if(visibleCountText)visibleCountText.textContent=String(shown);
}
localSearch&&localSearch.addEventListener('input',filterRows);filterRows();

document.getElementById('cuExportCsv')?.addEventListener('click',()=>{
  const quote=value=>'"'+String(value??'').replace(/"/g,'""')+'"';
  const csv=[Array.from(table.querySelectorAll('thead th')).slice(0,6).map(th=>quote(th.textContent.trim())).join(',')];
  rows.filter(row=>!row.hidden && row.children.length>1).forEach(row=>{
    const cells=Array.from(row.querySelectorAll('td')).slice(0,6).map(td=>quote(td.textContent.replace(/\s+/g,' ').trim()));
    csv.push(cells.join(','));
  });
  const blob=new Blob(['\uFEFF'+csv.join('\r\n')],{type:'text/csv;charset=utf-8'});
  const link=document.createElement('a');
  link.href=URL.createObjectURL(blob);link.download='nlogistic-customers-visible.csv';link.click();
  setTimeout(()=>URL.revokeObjectURL(link.href),1200);
});

document.querySelectorAll('[data-customer-id]').forEach(button=>button.addEventListener('click',()=>{
 const data=button.dataset;
 document.getElementById('cuUpdateRecordId').value=data.customerId||'';
 document.getElementById('cuUpdateSubtitle').textContent='Editing '+(data.customerLabel||('Customer #'+data.customerId))+'. Review the current details.';
 document.getElementById('cuEditContact').value=data.contactPerson||'';
 document.getElementById('cuEditAddress').value=data.billingAddress||'';
 document.getElementById('cuEditCredit').value=data.creditLimit||'0';
}));
})();
</script>
</body>
</html>
