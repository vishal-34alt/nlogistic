<jsp:useBean id="nlViewSupport_Module1_companies" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_companies" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_companies" property="view" value="Module1/companies.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,model.Company" %>

<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Company Management | N-LOGISTIC</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="../shared/_theme.jsp" %>
<style>
.nl-company-admin{--cc-ink:#3b281f;--cc-accent:#c65216;--cc-line:#ecd5c1;--cc-muted:#7a6455;color:var(--cc-ink)}
.nl-company-admin .cc-hero{display:grid;grid-template-columns:minmax(0,1.35fr) minmax(260px,.8fr);gap:18px;border:1px solid #ecccb0;border-radius:24px;background:linear-gradient(125deg,#fffdfa,#fff1e1 72%,#ffe5cb);padding:clamp(18px,2.4vw,32px);box-shadow:0 16px 34px rgba(87,53,23,.08);margin-bottom:18px;overflow:hidden;position:relative}
.nl-company-admin .cc-hero:after{content:"";position:absolute;right:-80px;top:-78px;width:250px;height:250px;border-radius:50%;border:1px solid rgba(212,91,23,.13);box-shadow:0 0 0 34px rgba(212,91,23,.05),0 0 0 68px rgba(212,91,23,.03)}
.nl-company-admin .cc-eyebrow{font-size:.76rem;font-weight:850;letter-spacing:.14em;text-transform:uppercase;color:#ae4a1b}
.nl-company-admin h1{font-size:clamp(1.9rem,3vw,2.9rem);font-weight:900;margin:.45rem 0}
.nl-company-admin .cc-desc{max-width:720px;color:var(--cc-muted);line-height:1.6;margin:0}
.nl-company-admin .cc-hero-side{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px;align-content:start;position:relative;z-index:1}
.nl-company-admin .cc-mini{background:rgba(255,255,255,.68);backdrop-filter:blur(4px);border:1px solid #edcfb6;border-radius:16px;padding:14px;min-height:96px}
.nl-company-admin .cc-mini strong{display:block;font-size:1.6rem;color:#b14916;line-height:1.1}
.nl-company-admin .cc-mini span{display:block;font-weight:760;font-size:.84rem;margin-top:4px}
.nl-company-admin .cc-mini small{display:block;color:#82695a;margin-top:8px;font-size:.76rem}
.nl-company-admin .cc-card{background:#fffdfa;border:1px solid var(--cc-line);border-radius:20px;box-shadow:0 14px 28px rgba(88,54,27,.06);padding:18px;margin-bottom:18px}
.nl-company-admin .cc-card h2{font-size:1.2rem;font-weight:860;margin:0 0 4px}
.nl-company-admin .cc-card p{color:var(--cc-muted)}
.nl-company-admin .cc-toolbar{display:flex;gap:10px;align-items:center;justify-content:space-between;flex-wrap:wrap;margin-bottom:14px}
.nl-company-admin .cc-kpis{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin-bottom:16px}
.nl-company-admin .cc-kpi{background:#fff7ef;border:1px solid #efd6c1;border-radius:15px;padding:14px}
.nl-company-admin .cc-kpi span{display:block;font-size:.78rem;color:#7d6455;font-weight:700}
.nl-company-admin .cc-kpi strong{display:block;font-size:1.6rem;color:#b24613;line-height:1.15;margin-top:6px}
.nl-company-admin .cc-btn{border-radius:12px;font-weight:800;padding:10px 16px}
.nl-company-admin .cc-btn-primary{background:#cf5a18;border:1px solid #c35215;color:#fff}
.nl-company-admin .cc-btn-soft{background:#fff7ef;border:1px solid #e8c8aa;color:#8f4318}
.nl-company-admin .cc-form label{font-size:.84rem;font-weight:760;color:#674b3a;margin-bottom:6px}
.nl-company-admin .cc-form .form-control,.nl-company-admin .cc-form .form-select{border-radius:13px;border-color:#e8ccb7;background:#fffdfa;min-height:46px}
.nl-company-admin .cc-form textarea.form-control{min-height:110px}
.nl-company-admin .cc-table-wrap{border:1px solid #eedbcc;border-radius:16px;overflow:hidden;background:#fff}
.nl-company-admin .cc-table{margin:0;min-width:980px}
.nl-company-admin .cc-table thead th{background:#fff2e5;color:#93431a;text-transform:uppercase;font-size:.73rem;letter-spacing:.07em;border-bottom:1px solid #edd7c5;padding:14px 12px;white-space:nowrap}
.nl-company-admin .cc-table tbody td{padding:14px 12px;border-bottom:1px solid #f3e5d8;vertical-align:middle;font-size:.88rem}
.nl-company-admin .cc-table tbody tr:nth-child(even){background:#fffaf4}
.nl-company-admin .cc-table tbody tr:hover{background:#fff0e1}
.nl-company-admin .cc-badge{display:inline-flex;align-items:center;border-radius:999px;padding:7px 10px;font-weight:850;font-size:.72rem;letter-spacing:.05em}
.nl-company-admin .cc-badge.cc-seller{background:#fff0df;color:#a24616}
.nl-company-admin .cc-badge.cc-consumer{background:#eef6ff;color:#325c8f}
.nl-company-admin .cc-actions{display:flex;gap:8px;flex-wrap:wrap}
.nl-company-admin .cc-link-btn{border:1px solid #e7c9ad;background:#fffaf4;color:#954519;border-radius:10px;padding:8px 12px;font-size:.8rem;font-weight:800}
.nl-company-admin .cc-link-btn.cc-danger{border-color:#efbdb8;color:#b1382d;background:#fff6f5}
.nl-company-admin .cc-search-grid{display:grid;grid-template-columns:2fr 1.2fr 1fr auto;gap:12px}
.nl-company-admin .cc-helper{font-size:.78rem;color:#8a6c5a}
.nl-company-admin .cc-empty{padding:30px 18px;text-align:center;color:#7c6557}
.nl-company-admin .cc-modal .modal-content{border-radius:24px;border:1px solid #ebc8ad;overflow:hidden;box-shadow:0 28px 64px rgba(78,39,12,.22)}
.nl-company-admin .cc-modal .modal-header{border-bottom:1px solid #edd6c3;background:linear-gradient(140deg,#fff3e7,#fffaf4);padding:20px 22px}
.nl-company-admin .cc-modal .modal-body{padding:22px}
.nl-company-admin .cc-modal .modal-footer{border-top:1px solid #edd6c3;padding:18px 22px;background:#fffdfa}
.nl-company-admin .cc-modal-title{font-size:1.8rem;font-weight:860;line-height:1.1;margin:4px 0 0}
.nl-company-admin .cc-modal-kicker{font-size:.76rem;letter-spacing:.14em;text-transform:uppercase;font-weight:820;color:#af4a1a}
.nl-company-admin .cc-country-picker .modal-content{border-radius:22px;border:1px solid #ebc8ad}
.nl-company-admin .cc-country-list{max-height:360px;overflow:auto;display:grid;grid-template-columns:1fr;gap:6px}
.nl-company-admin .cc-country-list button{border:1px solid #edd7c5;background:#fffaf5;border-radius:12px;padding:10px 12px;text-align:left;font-weight:700;color:#644737}
.nl-company-admin .cc-country-list button:hover{background:#fff0de}
.nl-company-admin .cc-country-chooser{display:flex;gap:8px}
.nl-company-admin .cc-country-chooser .form-control{flex:1}
.nl-company-admin .cc-country-chooser button{white-space:nowrap}
@media(max-width:1100px){.nl-company-admin .cc-search-grid{grid-template-columns:1fr 1fr}.nl-company-admin .cc-search-grid .cc-search-actions{grid-column:1/-1}.nl-company-admin .cc-hero{grid-template-columns:1fr}.nl-company-admin .cc-kpis{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:640px){.nl-company-admin .cc-kpis{grid-template-columns:1fr}.nl-company-admin .cc-country-chooser{flex-direction:column}.nl-company-admin .cc-modal .modal-body,.nl-company-admin .cc-modal .modal-header,.nl-company-admin .cc-modal .modal-footer{padding:16px}}

/* v16.3: the modal nodes are siblings of main, so scope their theme through body. */
.nl-company-admin .cc-modal .modal-content{background:#fffaf4;border-radius:26px;box-shadow:0 30px 80px #4726144d}
.nl-company-admin .cc-modal .modal-header{background:linear-gradient(118deg,#fff5ea,#ffe3ca);align-items:flex-start}
.nl-company-admin .cc-modal .modal-footer{background:#fff2e6;gap:10px}
.nl-company-admin .cc-modal .cc-modal-kicker{font-weight:900;color:#b44c18;letter-spacing:.12em}
.nl-company-admin .cc-modal .cc-form label{font-weight:800;color:#6b4532}
.nl-company-admin .cc-modal .cc-form .form-control,.nl-company-admin .cc-modal .cc-form .form-select{background:#fffdf9;border:1px solid #e2bf9e;box-shadow:none;border-radius:13px}
.nl-company-admin .cc-modal .cc-form .form-control:focus,.nl-company-admin .cc-modal .cc-form .form-select:focus{border-color:#d45c1d;box-shadow:0 0 0 3px #df884830}
.nl-company-admin .cc-btn-primary{background:linear-gradient(110deg,#bf4811,#e66a20);color:white!important;border-color:#b94412;box-shadow:0 8px 18px #c4561e24}
.nl-company-admin .cc-btn-primary:hover{background:linear-gradient(110deg,#a8370d,#d15c15);transform:translateY(-1px)}
.nl-company-admin .cc-btn-soft:hover{background:#ffe7d0}
.nl-company-admin .cc-modal .modal-dialog{max-width:min(980px,94vw)}
.nl-company-admin .cc-hero-art{position:relative;z-index:1;align-self:center;display:flex;align-items:center;justify-content:center;min-height:208px}
.nl-company-admin .cc-hero-scene{width:min(100%,440px);height:auto;filter:drop-shadow(0 16px 20px #ac6e4430)}

.nl-company-admin .cc-hero-scene .cc-document{animation:ccLift 5.5s ease-in-out infinite}
.nl-company-admin .cc-hero-scene .cc-boxmove{animation:ccShift 6.4s ease-in-out infinite}
.nl-company-admin .cc-hero-scene .cc-orbit{animation:ccTwinkle 4s ease-in-out infinite}
@keyframes ccLift{0%,100%{transform:translateY(0)}50%{transform:translateY(-8px)}}
@keyframes ccShift{0%,100%{transform:translateX(0)}50%{transform:translateX(-12px)}}
@keyframes ccTwinkle{0%,100%{opacity:1}50%{opacity:.44}}
@media(max-width:1080px){.nl-company-admin .cc-hero-art{min-height:180px}}
@media(prefers-reduced-motion:reduce){.nl-company-admin .cc-hero-scene *{animation:none!important;transition:none!important}}

/* Asset-free illustrated company workspace: HTML elements + inline CSS only. */
.nl-company-admin .cc-hero-scene{position:relative;width:min(100%,440px);height:255px;flex:none;filter:drop-shadow(0 15px 18px rgba(133,72,36,.12));isolation:isolate}
.nl-company-admin .cc-visual-halo{position:absolute;inset:13px 25px 0;border:1px solid rgba(217,112,42,.19);border-radius:50%;background:radial-gradient(circle at 48% 50%,rgba(255,255,255,.65),rgba(255,218,177,.15) 70%,transparent 71%);box-shadow:0 0 0 18px rgba(255,234,206,.23)}
.nl-company-admin .cc-css-office{position:absolute;z-index:2;bottom:22px;left:27%;width:45%;height:143px;border:3px solid #954c27;border-radius:13px 13px 5px 5px;background:linear-gradient(135deg,#ffd59e,#e78442);box-shadow:12px 13px 0 rgba(113,57,30,.13);animation:ccOfficeFloat 6s ease-in-out infinite}
.nl-company-admin .cc-css-office-roof{position:absolute;top:-26px;left:-12px;right:-12px;height:28px;background:#814224;clip-path:polygon(50% 0,100% 100%,0 100%);border-radius:4px}
.nl-company-admin .cc-css-windows{position:absolute;left:18px;right:18px;top:26px;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:11px}
.nl-company-admin .cc-css-windows i{display:block;height:17px;border-radius:3px;background:linear-gradient(135deg,#fff6dc,#fff3e4);border:1px solid rgba(115,58,32,.28);box-shadow:inset 0 -3px rgba(255,186,116,.24)}
.nl-company-admin .cc-css-door{position:absolute;bottom:0;left:calc(50% - 16px);width:32px;height:30px;background:#9b502b;border-radius:5px 5px 0 0;border:2px solid #7e4128}
.nl-company-admin .cc-css-contract{position:absolute;z-index:3;right:10px;top:29px;width:112px;height:148px;border:2px solid #9e5730;border-radius:13px;background:linear-gradient(145deg,#fffef9,#fff0df);box-shadow:9px 13px 0 rgba(152,78,35,.13);transform:rotate(8deg);animation:ccContractFloat 5.5s ease-in-out infinite}
.nl-company-admin .cc-css-contract-seal{position:absolute;left:22px;top:20px;width:42px;height:42px;border-radius:50%;background:#d96827;border:6px solid #fce5cd;box-shadow:0 0 0 2px #c45e26}
.nl-company-admin .cc-css-document-line{position:absolute;left:18px;right:15px;top:81px;height:5px;border-radius:5px;background:#e6b68d}
.nl-company-admin .cc-css-document-line:nth-of-type(3){top:97px}
.nl-company-admin .cc-css-document-line.cc-short{top:113px;right:43px}
.nl-company-admin .cc-css-crates{position:absolute;z-index:4;left:12px;bottom:20px;display:grid;grid-template-columns:repeat(2,51px);gap:4px;transform:rotate(-5deg);animation:ccCratesFloat 6s ease-in-out infinite}
.nl-company-admin .cc-css-crates span{height:46px;display:block;border:3px solid #9b502b;border-radius:8px;background:repeating-linear-gradient(90deg,#f9ad70 0 9px,#ed9555 9px 17px);box-shadow:3px 5px 0 rgba(121,58,32,.14)}
.nl-company-admin .cc-css-crates span:first-child{grid-column:1/3;width:65px;justify-self:center}
.nl-company-admin .cc-css-spark{position:absolute;z-index:5;width:11px;height:11px;background:#e18d4d;transform:rotate(45deg);border-radius:3px;animation:ccSpark 4s ease-in-out infinite}
.nl-company-admin .cc-spark-one{left:17%;top:39px}.nl-company-admin .cc-spark-two{right:13%;bottom:28px;animation-delay:1.3s}
@keyframes ccOfficeFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-5px)}}
@keyframes ccContractFloat{0%,100%{transform:translateY(0) rotate(8deg)}50%{transform:translateY(-10px) rotate(6deg)}}
@keyframes ccCratesFloat{0%,100%{transform:translateY(0) rotate(-5deg)}50%{transform:translateY(-4px) rotate(-5deg)}}
@keyframes ccSpark{0%,100%{opacity:1;scale:1}50%{opacity:.3;scale:.72}}
@media(prefers-reduced-motion:reduce){.nl-company-admin .cc-hero-scene *{animation:none!important}}


/* v16.7 aligned companies hero; artwork uses inline HTML/CSS, not assets. */
.nl-company-admin .cc-hero{padding:20px 26px!important;grid-template-columns:minmax(0,1.7fr) minmax(240px,.72fr)!important;align-items:center!important;gap:18px!important;min-height:0!important;overflow:visible!important}
.nl-company-admin .cc-hero-art{min-height:148px!important;height:158px!important;max-height:158px!important;overflow:visible!important;justify-content:flex-end!important;padding-right:4px}
.nl-company-admin .cc-hero-scene{transform:scale(.54);transform-origin:72% 10%;height:255px!important;margin:0 -8px 0 0!important}
.nl-company-admin .cc-hero h1{font-size:clamp(1.7rem,2.55vw,2.3rem)!important;margin:3px 0 7px!important}
.nl-company-admin .cc-hero .cc-desc{font-size:.87rem!important;line-height:1.45!important;max-width:680px}
@media(max-width:800px){.nl-company-admin .cc-hero{grid-template-columns:1fr!important;padding:18px 20px!important}.nl-company-admin .cc-hero-art{display:none!important}}

/* v16.9 | fixed-size illustration viewport. The animation no longer extends past the hero. */
.nl-company-admin .cc-hero{overflow:hidden!important;isolation:isolate;grid-template-columns:minmax(0,1fr) minmax(220px,292px)!important;min-height:195px!important;gap:16px!important;padding:19px 25px!important}
.nl-company-admin .cc-hero:after{pointer-events:none;z-index:0}
.nl-company-admin .cc-hero > div:first-child{min-width:0;position:relative;z-index:1}
.nl-company-admin .cc-hero-art{position:relative!important;z-index:1!important;display:block!important;justify-self:end!important;align-self:center!important;width:min(100%,292px)!important;height:172px!important;min-height:172px!important;max-height:172px!important;overflow:hidden!important;padding:0!important;margin:0!important;border-radius:17px}
.nl-company-admin .cc-hero-scene{position:absolute!important;top:5px!important;left:3px!important;width:440px!important;max-width:none!important;height:255px!important;min-height:255px!important;margin:0!important;transform:scale(.64)!important;transform-origin:top left!important;filter:none!important}
@media(max-width:840px){.nl-company-admin .cc-hero{grid-template-columns:1fr!important;padding:18px 20px!important}.nl-company-admin .cc-hero-art{display:none!important}}
@media(prefers-reduced-motion:reduce){.nl-company-admin .cc-hero-scene *{animation:none!important}}
/* Full-record editing uses an uncluttered layout and does not change approved field definitions. */
.nl-company-admin .cc-edit-notice,.cc-modal .cc-edit-notice{padding:12px 14px;border:1px solid #edceb4;background:#fff2e5;border-radius:13px;color:#795238;font-size:.9rem;line-height:1.5}
.nl-company-admin .cc-edit-hint,.cc-modal .cc-edit-hint{font-size:.85rem;color:#805e4a;background:#fff9f2;border:1px dashed #ead4c0;border-radius:12px;padding:10px 13px}
.cc-modal #ccFullCompanyEdit .modal-body .row>div{min-width:0}
.cc-modal #ccFullCompanyEdit label{display:block;margin:0 0 7px;font-weight:750}
</style>
</head>
<body data-nl-screen="module1-companies" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark nl-company-admin">
<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3">Administration / Companies</div><div class="nl-view-body container-fluid p-0 px-0"><main class="nl-company-admin">
<section class="cc-hero">
  <div>
    <div class="cc-eyebrow">Administration / Partner directory</div>
    <h1>Company management</h1>
    <p class="cc-desc">Manage Seller and Consumer organizations from one place. Add new partners, search records quickly, and keep company details clean for downstream modules like users, customers, vessels, bookings and audit records.</p>
  </div>
  <div class="cc-hero-art" aria-hidden="true">
  <div class="cc-hero-scene" aria-hidden="true">
  <div class="cc-visual-halo"></div>
  <div class="cc-css-crates"><span></span><span></span><span></span></div>
  <div class="cc-css-office"><div class="cc-css-office-roof"></div><div class="cc-css-windows"><i></i><i></i><i></i><i></i><i></i><i></i><i></i><i></i><i></i></div><span class="cc-css-door"></span></div>
  <div class="cc-css-contract"><span class="cc-css-contract-seal"></span><span class="cc-css-document-line"></span><span class="cc-css-document-line"></span><span class="cc-css-document-line cc-short"></span></div>
  <span class="cc-css-spark cc-spark-one"></span><span class="cc-css-spark cc-spark-two"></span>
</div>
</div>
</section>

${requestScope.nlv_Module1_companies__1}
<section class="cc-card">
  <div class="cc-toolbar">
    <div>
      <h2>Find a company</h2>
      <p class="mb-0 small">Search from the database, then optionally filter the loaded table instantly on the page.</p>
    </div>
    <div class="d-flex gap-2 flex-wrap">
      <button type="button" class="btn cc-btn cc-btn-soft" id="ccExportCsv">Export visible CSV</button>
      <button type="button" class="btn cc-btn cc-btn-primary" data-bs-toggle="modal" data-bs-target="#companyAddModal">+ Add company</button>
    </div>
  </div>
  <div class="cc-kpis" aria-label="Company quick totals">
    <div class="cc-kpi"><span>Loaded rows</span><strong>${requestScope.nlv_Module1_companies__2}</strong></div>
    <div class="cc-kpi"><span>Search keyword</span><strong>${requestScope.nlv_Module1_companies__3}</strong></div>
    <div class="cc-kpi"><span>Filtered type</span><strong>${requestScope.nlv_Module1_companies__4}</strong></div>
  </div>
  <form action="Module1Controller" method="get" class="cc-form">
    <input type="hidden" name="action" value="searchCompanies">
    <div class="cc-search-grid">
      <div>
        <label for="ccKeyword">Company name</label>
        <input id="ccKeyword" type="text" name="keyword" class="form-control" value="${requestScope.nlv_Module1_companies__5}" placeholder="Search by company name">
      </div>
      <div>
        <label for="ccType">Company type</label>
        <select id="ccType" name="companyType" class="form-select">
          <option value="" ${requestScope.nlv_Module1_companies__6}>All company types</option>
          <option value="CONSUMER" ${requestScope.nlv_Module1_companies__7}>CONSUMER</option>
          <option value="SELLER" ${requestScope.nlv_Module1_companies__8}>SELLER</option>
        </select>
      </div>
      <div>
        <label for="ccLocalSearch">Loaded table search</label>
        <input id="ccLocalSearch" type="search" class="form-control" placeholder="Filter visible rows instantly">
      </div>
      <div class="d-flex align-items-end gap-2 cc-search-actions">
        <button type="submit" class="btn cc-btn cc-btn-primary flex-grow-1">Search</button>
        <a href="Module1Controller?action=companies" class="btn cc-btn cc-btn-soft">Reset</a>
      </div>
    </div>
    <div class="cc-helper mt-2">Database search uses the form above. The “Loaded table search” box filters only the currently displayed results.</div>
  </form>
</section>

<section class="cc-card">
  <div class="cc-toolbar">
    <div>
      <h2>Registered companies</h2>
      <p class="mb-0 small">Use Update to edit the company details together. Delete remains restricted if the company is referenced elsewhere.</p>
    </div>
    <div class="small text-secondary"><span id="ccVisibleCount">${requestScope.nlv_Module1_companies__9}</span> of ${requestScope.nlv_Module1_companies__10} rows visible</div>
  </div>
  <div class="cc-table-wrap table-responsive rounded-4">
    <table class="table cc-table align-middle" id="ccCompanyTable">
      <thead>
        <tr>
          <th>Company ID</th>
          <th>Company name</th>
          <th>Type</th>
          <th>GST number</th>
          <th>IEC code</th>
          <th>City</th>
          <th>Country</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <jsp:setProperty name="nlViewSupport_Module1_companies" property="fragment" value="nlv_Module1_companies__11" /><jsp:getProperty name="nlViewSupport_Module1_companies" property="fragment" />
      </tbody>
    </table>
  </div>
</section>
</main></div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>

<div class="modal fade cc-modal" id="companyAddModal" tabindex="-1" aria-labelledby="companyAddTitle" aria-hidden="true">
  <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <form action="Module1Controller" method="post" class="cc-form" id="ccAddCompanyForm">
        <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_companies__12}">
        <input type="hidden" name="action" value="addCompany">
        <div class="modal-header">
          <div>
            <div class="cc-modal-kicker">Administration / Company registry</div>
            <h2 class="cc-modal-title" id="companyAddTitle">Add new company</h2>
            <p class="mb-0 small text-secondary">Create a Seller or Consumer company record using the same design language as the rest of the workspace.</p>
          </div>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-lg-6"><label for="ccAddName">Company name</label><input id="ccAddName" type="text" name="companyName" class="form-control" maxlength="100" required></div>
            <div class="col-lg-6"><label for="ccAddType">Company type</label><select id="ccAddType" name="companyType" class="form-select" required><option value="">Select type</option><option value="CONSUMER">CONSUMER</option><option value="SELLER">SELLER</option></select></div>
            <div class="col-lg-6"><label for="ccAddGst">GST number</label><input id="ccAddGst" type="text" name="gstNumber" class="form-control" maxlength="20" placeholder="Optional"></div>
            <div class="col-lg-6"><label for="ccAddIec">IEC code</label><input id="ccAddIec" type="text" name="iecCode" class="form-control" maxlength="20" placeholder="Optional"></div>
            <div class="col-md-6"><label for="ccAddCity">City</label><input id="ccAddCity" type="text" name="city" class="form-control" maxlength="60"></div>
            <div class="col-md-6"><label for="ccAddCountry">Country</label><div class="cc-country-chooser"><input id="ccAddCountry" type="text" name="country" class="form-control" maxlength="60" placeholder="Select or type country"><button type="button" class="btn cc-btn cc-btn-soft" data-country-target="ccAddCountry">Choose country</button></div><div class="cc-helper mt-1">The country chooser uses the same searchable experience requested for Add Port.</div></div>
            <div class="col-12"><label for="ccAddAddress">Address</label><textarea id="ccAddAddress" name="address" class="form-control" rows="4"></textarea></div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn cc-btn cc-btn-soft" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn cc-btn cc-btn-primary">Save company</button>
        </div>
      </form>
    </div>
  </div>
</div>

<div class="modal fade cc-modal" id="companyUpdateModal" tabindex="-1" aria-labelledby="companyUpdateTitle" aria-hidden="true">
 <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable"><div class="modal-content">
  <form action="Module1Controller" method="post" class="cc-form" id="ccFullCompanyEdit">
   <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_companies__13}"><input type="hidden" name="action" value="updateCompanyAll"><input type="hidden" name="recordId" id="ccUpdateRecordId">
   <div class="modal-header"><div><div class="cc-modal-kicker">Administration / Company details</div><h2 class="cc-modal-title" id="companyUpdateTitle">Edit company details</h2><p class="mb-0 small text-secondary" id="ccUpdateSubtitle">Review the saved information and change any fields you need.</p></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div>
   <div class="modal-body"><div class="cc-edit-notice">All editable details are shown together. Unchanged fields remain as they are; saving is one validated database transaction.</div>
    <div class="row g-3 mt-1">
     <div class="col-md-8"><label for="ccEditName">Company name <span class="text-danger">*</span></label><input id="ccEditName" name="companyName" class="form-control" required maxlength="150"></div>
     <div class="col-md-4"><label for="ccEditType">Company type <span class="text-danger">*</span></label><select id="ccEditType" name="companyType" class="form-select" required><option value="CONSUMER">Consumer</option><option value="SELLER">Seller</option></select></div>
     <div class="col-md-6"><label for="ccEditGst">GST number</label><input id="ccEditGst" name="gstNumber" class="form-control" maxlength="20"></div>
     <div class="col-md-6"><label for="ccEditIec">IEC code</label><input id="ccEditIec" name="iecCode" class="form-control" maxlength="15"></div>
     <div class="col-md-6"><label for="ccEditCity">City</label><input id="ccEditCity" name="city" class="form-control" maxlength="60"></div>
     <div class="col-md-6"><label for="ccEditCountry">Country</label><div class="cc-country-chooser"><input id="ccEditCountry" name="country" class="form-control" maxlength="60"><button type="button" class="btn cc-btn cc-btn-soft" data-country-target="ccEditCountry">Choose</button></div></div>
     <div class="col-12"><label for="ccEditAddress">Address</label><textarea id="ccEditAddress" name="address" class="form-control" rows="3"></textarea></div>
     <div class="col-12"><div class="cc-edit-hint">Company type changes are restricted when existing accounts or operational records are linked to the company.</div></div>
    </div>
   </div>
   <div class="modal-footer"><button type="button" class="btn cc-btn cc-btn-soft" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn cc-btn cc-btn-primary">Save company details</button></div>
  </form>
 </div></div>
</div>

<div class="modal fade cc-country-picker" id="ccCountryModal" tabindex="-1" aria-labelledby="ccCountryTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <div>
          <div class="cc-modal-kicker">Country picker</div>
          <h2 class="cc-modal-title fs-3" id="ccCountryTitle">Choose a country</h2>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <label class="form-label fw-semibold" for="ccCountrySearch">Search countries</label>
        <input id="ccCountrySearch" type="search" class="form-control mb-3" placeholder="Type a country name">
        <div class="cc-country-list" id="ccCountryList">
          ${requestScope.nlv_Module1_companies__14}
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){'use strict';
const table=document.getElementById('ccCompanyTable');
if(!table)return;
const rows=Array.from(table.querySelectorAll('tbody tr'));
const localSearch=document.getElementById('ccLocalSearch');
const visibleCount=document.getElementById('ccVisibleCount');
function filterRows(){
  const term=(localSearch.value||'').trim().toLowerCase();
  let shown=0;
  rows.forEach(row=>{
    if(row.children.length===1){row.hidden=false;return;}
    const ok=!term || (row.dataset.companySearch||'').includes(term);
    row.hidden=!ok;
    if(ok)shown++;
  });
  if(visibleCount)visibleCount.textContent=String(shown);
}
localSearch&&localSearch.addEventListener('input',filterRows);
filterRows();

document.getElementById('ccExportCsv')?.addEventListener('click',()=>{
  const quote=value=>'"'+String(value??'').replace(/"/g,'""')+'"';
  const csv=[Array.from(table.querySelectorAll('thead th')).slice(0,7).map(th=>quote(th.textContent.trim())).join(',')];
  rows.filter(row=>!row.hidden && row.children.length>1).forEach(row=>{
    const cells=Array.from(row.querySelectorAll('td')).slice(0,7).map(td=>quote(td.textContent.replace(/\s+/g,' ').trim()));
    csv.push(cells.join(','));
  });
  const blob=new Blob(['\uFEFF'+csv.join('\r\n')],{type:'text/csv;charset=utf-8'});
  const link=document.createElement('a');
  link.href=URL.createObjectURL(blob);link.download='nlogistic-companies-visible.csv';link.click();
  setTimeout(()=>URL.revokeObjectURL(link.href),1200);
});

document.querySelectorAll('[data-company-id]').forEach(button=>button.addEventListener('click',()=>{
 const data=button.dataset;
 document.getElementById('ccUpdateRecordId').value=data.companyId||'';
 document.getElementById('ccUpdateSubtitle').textContent='Editing '+(data.companyName||('Company #'+data.companyId))+'. All editable details are available below.';
 [['ccEditName','companyName'],['ccEditType','companyType'],['ccEditGst','companyGst'],['ccEditIec','companyIec'],['ccEditAddress','companyAddress'],['ccEditCity','companyCity'],['ccEditCountry','companyCountry']].forEach(pair=>{
   const el=document.getElementById(pair[0]);if(el)el.value=data[pair[1]]||'';
 });
}));

const countryModalEl=document.getElementById('ccCountryModal');
const countryModal=countryModalEl?bootstrap.Modal.getOrCreateInstance(countryModalEl):null;
let countryTargetInput=null;
function raiseCountryModal(){
  if(!countryModalEl)return;
  const open=document.querySelectorAll('.modal.show').length;
  const modalZ=1060+(open*20);
  countryModalEl.style.zIndex=String(modalZ);
  setTimeout(()=>{const backdrops=document.querySelectorAll('.modal-backdrop');if(backdrops.length)backdrops[backdrops.length-1].style.zIndex=String(modalZ-5);},20);
}
countryModalEl?.addEventListener('shown.bs.modal',()=>document.getElementById('ccCountrySearch')?.focus());
document.querySelectorAll('[data-country-target]').forEach(button=>button.addEventListener('click',()=>{countryTargetInput=document.getElementById(button.dataset.countryTarget||'');raiseCountryModal();countryModal&&countryModal.show();}));
const search=document.getElementById('ccCountrySearch');
const items=Array.from(document.querySelectorAll('#ccCountryList [data-country-value]'));
function filterCountries(){const term=(search?.value||'').trim().toLowerCase();items.forEach(item=>item.hidden=!!term && !item.dataset.countryValue.toLowerCase().includes(term));}
search&&search.addEventListener('input',filterCountries);
items.forEach(item=>item.addEventListener('click',()=>{if(countryTargetInput)countryTargetInput.value=item.dataset.countryValue||''; countryModal&&countryModal.hide();}));
})();
</script>
</body>
</html>
