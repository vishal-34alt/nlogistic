<jsp:useBean id="nlViewSupport_Module1_dashboard" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_dashboard" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_dashboard" property="view" value="Module1/dashboard.jsp" />
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,model.DashboardSummary" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Dashboard | N-LOGISTIC</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"><%@ include file="../shared/_theme.jsp" %>
<style>
.nl-admin-v16{--na-text:#3b271d;--na-orange:#b8450c;color:var(--na-text)}
.nl-admin-v16 .na-hero{border:1px solid #eec6aa;background:linear-gradient(113deg,#fffdf9,#ffe7ce);border-radius:22px;padding:clamp(19px,2.5vw,32px);display:flex;justify-content:space-between;align-items:center;gap:22px;flex-wrap:wrap;box-shadow:0 12px 36px #5b39120d}
.nl-admin-v16 .na-eyebrow{color:#af4b1b;text-transform:uppercase;font-size:.72rem;letter-spacing:.13em;font-weight:820}
.nl-admin-v16 h1{font-weight:880;font-size:clamp(1.9rem,3vw,2.7rem);margin:7px 0 9px}
.nl-admin-v16 .na-hero p{font-size:.95rem;max-width:640px;color:#6f5649}.nl-admin-v16 .na-date{font-size:.74rem;color:#9c7259}
.nl-admin-v16 .na-hero-links{display:flex;gap:8px;flex-wrap:wrap}.nl-admin-v16 .na-hero-links a{border-radius:11px;padding:10px 13px;color:#954112;background:#fffaf5;border:1px solid #edc9ac;text-decoration:none;font-weight:750;font-size:.82rem}
.nl-admin-v16 .na-kpi-area{margin:21px 0}.nl-admin-v16 .na-kpi-head{display:flex;gap:12px;align-items:center;justify-content:space-between;flex-wrap:wrap;margin-bottom:11px}
.nl-admin-v16 h2{font-weight:840;font-size:1.24rem;margin:0}.nl-admin-v16 .na-kpi-head span{font-size:.75rem;color:#876c5e}
.nl-admin-v16 .na-kpi-row{display:flex;flex-wrap:nowrap;gap:10px;overflow-x:auto;padding:2px 1px 12px;scrollbar-width:thin;scroll-snap-type:x proximity}
.nl-admin-v16 .na-kpi{flex:1 0 155px;min-width:155px;border:1px solid #ecd3be;background:#fffdf9;border-radius:16px;text-decoration:none;color:#3e2b22;padding:17px 14px;display:flex;flex-direction:column;gap:8px;scroll-snap-align:start;transition:box-shadow .18s,transform .18s}
.nl-admin-v16 .na-kpi:hover{box-shadow:0 12px 25px #a5632528;transform:translateY(-3px)}
.nl-admin-v16 .na-kpi-icon{font-size:.62rem;font-weight:850;color:#ba4a18;letter-spacing:.09em;border:1px solid #efd1b7;background:#fff0de;border-radius:9px;width:35px;height:32px;display:grid;place-items:center}
.nl-admin-v16 .na-kpi strong{font-size:1.7rem;font-weight:870;line-height:1.15}.nl-admin-v16 .na-kpi>span:nth-of-type(2){font-size:.79rem;font-weight:800}
.nl-admin-v16 .na-kpi small{font-size:.72rem;color:#9a5d3a}
.nl-admin-v16 .na-panel{border:1px solid #ebd4c1;border-radius:18px;background:#fffdfa;padding:clamp(16px,2.1vw,26px);box-shadow:0 11px 30px #6e3a130c}
.nl-admin-v16 .na-panel-header{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:13px;margin-bottom:18px}
.nl-admin-v16 .na-panel-header a{text-decoration:none;color:#ab4d1f;font-size:.78rem;font-weight:750;border:1px solid #eac8a9;border-radius:9px;padding:8px}
.nl-admin-v16 .na-chart{height:280px;position:relative}.nl-admin-v16 .na-status-row{display:flex;gap:7px;flex-wrap:wrap;margin-top:16px}
.nl-admin-v16 .na-status-chip{border:1px solid #e9cdb5;background:#fff4e8;border-radius:8px;padding:6px 9px;display:flex;gap:6px;align-items:center;font-size:.69rem;color:#7e563c}
.nl-admin-v16 .na-status-chip strong{color:#ad471a;font-size:.85rem}
.nl-admin-v16 .na-shortcuts{display:grid;grid-template-columns:1fr;gap:8px;margin-top:16px}
.nl-admin-v16 .na-shortcuts a{display:flex;justify-content:space-between;gap:15px;border:1px solid #efddcb;background:#fff7ee;border-radius:11px;padding:12px 13px;color:#423026;text-decoration:none;font-size:.84rem;font-weight:720}
.nl-admin-v16 .na-shortcuts a:hover{background:#ffebd6}.nl-admin-v16 .na-shortcuts strong{color:#ba4b17;font-size:.75rem}
.nl-admin-v16 .na-advisory{margin-top:17px;background:#fff0dc;border:1px solid #ecc7a4;border-radius:13px;padding:14px;font-size:.82rem}
.nl-admin-v16 .na-recent{display:grid;grid-template-columns:repeat(auto-fit,minmax(175px,1fr));gap:9px}.nl-admin-v16 .na-recent>div{background:#fff5eb;border:1px solid #f0d9c4;border-radius:10px;padding:10px;display:flex;gap:8px;align-items:center;font-size:.82rem}
.nl-admin-v16 .na-recent-mark{width:8px;height:8px;border-radius:50%;background:#d45b1b;flex:none}
@media(max-width:750px){.nl-admin-v16 .na-kpi{flex:0 0 185px}.nl-admin-v16 .na-hero-links a{flex:1;text-align:center}}
@media(prefers-reduced-motion:reduce){.nl-admin-v16 .na-kpi{transition:none;transform:none!important}}

/* v16.7 administration hero refresh */
.nl-admin-v16 .na-hero{display:grid;grid-template-columns:minmax(0,1.55fr) minmax(230px,.72fr);align-items:center;gap:18px;padding:22px 26px;overflow:hidden;position:relative}
.nl-admin-v16 .na-hero:after{content:"";position:absolute;right:-75px;top:-84px;width:240px;height:240px;border-radius:50%;border:1px solid rgba(212,91,23,.13);box-shadow:0 0 0 26px rgba(212,91,23,.05),0 0 0 56px rgba(212,91,23,.025)}
.nl-admin-v16 .na-hero-content{position:relative;z-index:1}
.nl-admin-v16 .na-hero-links{display:none}
.nl-admin-v16 .na-hero-art{position:relative;z-index:1;display:flex;justify-content:flex-end;align-items:center;min-height:150px;overflow:visible}
.nl-admin-v16 .na-scene{position:relative;width:320px;height:170px;transform:scale(.95);transform-origin:100% 50%;filter:drop-shadow(0 14px 18px rgba(133,72,36,.14))}
.nl-admin-v16 .na-halo{position:absolute;inset:6px 8px 0 70px;border-radius:50%;border:1px solid rgba(205,100,41,.16);background:radial-gradient(circle at 56% 46%,rgba(255,255,255,.82),rgba(255,216,181,.14) 74%,transparent 75%)}
.nl-admin-v16 .na-board{position:absolute;right:22px;top:22px;width:168px;height:112px;border:3px solid #985128;border-radius:18px;background:linear-gradient(145deg,#fffef8,#ffdcb7);box-shadow:10px 13px 0 rgba(148,74,33,.12);animation:naBoardFloat 5.8s ease-in-out infinite}
.nl-admin-v16 .na-board:before,.nl-admin-v16 .na-board:after{content:"";position:absolute;left:18px;right:18px;height:10px;border-radius:10px;background:#efc39e}
.nl-admin-v16 .na-board:before{top:20px;box-shadow:0 22px 0 #efc39e,0 44px 0 #efc39e}
.nl-admin-v16 .na-board:after{top:72px;right:48px}
.nl-admin-v16 .na-bars{position:absolute;left:16px;bottom:17px;display:flex;align-items:flex-end;gap:10px}
.nl-admin-v16 .na-bars i{display:block;width:22px;border-radius:10px 10px 4px 4px;background:linear-gradient(180deg,#ffb77a,#d86a1d);border:2px solid #9c522a;animation:naBarPulse 4.8s ease-in-out infinite}
.nl-admin-v16 .na-bars i:nth-child(1){height:36px;animation-delay:0s}.nl-admin-v16 .na-bars i:nth-child(2){height:56px;animation-delay:.2s}.nl-admin-v16 .na-bars i:nth-child(3){height:76px;animation-delay:.4s}
.nl-admin-v16 .na-gear{position:absolute;left:22px;top:34px;width:72px;height:72px;border-radius:50%;border:6px solid #a45125;background:radial-gradient(circle,#ffd9b1 0 34%,transparent 35%),repeating-conic-gradient(from 0deg,#f3a15e 0 14deg,#ffc68d 14deg 28deg);box-shadow:0 10px 0 rgba(152,78,35,.12);animation:naSpin 18s linear infinite}
.nl-admin-v16 .na-gear:before{content:"";position:absolute;inset:17px;border-radius:50%;border:4px solid #a45125;background:#fff7ef}
.nl-admin-v16 .na-cardlet{position:absolute;left:78px;bottom:12px;width:82px;height:56px;border:2px solid #9e5730;border-radius:12px;background:linear-gradient(145deg,#fffef9,#fff0df);box-shadow:8px 10px 0 rgba(152,78,35,.13);transform:rotate(-8deg);animation:naCardFloat 5.4s ease-in-out infinite}
.nl-admin-v16 .na-cardlet:before,.nl-admin-v16 .na-cardlet:after{content:"";position:absolute;left:12px;right:12px;height:6px;border-radius:6px;background:#e6b68d}
.nl-admin-v16 .na-cardlet:before{top:16px;box-shadow:0 12px 0 #e6b68d}.nl-admin-v16 .na-cardlet:after{top:40px;right:28px}
.nl-admin-v16 .na-quick-actions{margin-top:14px;border:1px solid #ebd4c1;border-radius:18px;background:#fffdfa;padding:16px 18px;box-shadow:0 11px 30px #6e3a130c}
.nl-admin-v16 .na-quick-actions-head{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px;margin-bottom:13px}
.nl-admin-v16 .na-quick-actions h2{font-size:1.05rem}
.nl-admin-v16 .na-quick-actions-grid{display:flex;gap:10px;flex-wrap:wrap}
.nl-admin-v16 .na-quick-actions-grid a{display:inline-flex;align-items:center;gap:8px;border:1px solid #ebc8ad;background:#fff7ef;border-radius:12px;padding:10px 14px;color:#8c4317;text-decoration:none;font-weight:760}
.nl-admin-v16 .na-quick-actions-grid a:hover{background:#ffecd8;transform:translateY(-1px)}
@keyframes naBoardFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-7px)}}
@keyframes naCardFloat{0%,100%{transform:translateY(0) rotate(-8deg)}50%{transform:translateY(-6px) rotate(-8deg)}}
@keyframes naBarPulse{0%,100%{transform:translateY(0)}50%{transform:translateY(-4px)}}
@keyframes naSpin{from{transform:rotate(0)}to{transform:rotate(360deg)}}
@media(max-width:900px){.nl-admin-v16 .na-hero{grid-template-columns:1fr;padding:20px}.nl-admin-v16 .na-hero-art{display:none}}
@media(prefers-reduced-motion:reduce){.nl-admin-v16 .na-scene *{animation:none!important}}


/* v16.8 Eclipse JSP-safe dashboard icons: regular HTML elements and inline CSS only. */
.nl-admin-v16 .na-kpi-icon{font-size:initial;letter-spacing:normal}
.nl-admin-v16 .na-css-icon{position:relative;width:21px;height:21px;display:block;color:#b54a18}
.nl-admin-v16 .na-css-icon::before,.nl-admin-v16 .na-css-icon::after,.nl-admin-v16 .na-css-icon i{content:"";position:absolute;display:block;box-sizing:border-box}
.nl-admin-v16 .na-css-ship::before,.nl-admin-v16 .na-css-vessel::before{left:1px;right:1px;bottom:2px;height:9px;border:2px solid currentColor;border-top-width:2px;border-radius:1px 1px 7px 7px;transform:skewX(-9deg)}
.nl-admin-v16 .na-css-ship::after,.nl-admin-v16 .na-css-vessel::after{left:5px;top:3px;width:12px;height:9px;border:2px solid currentColor;border-bottom:0;border-radius:2px 2px 0 0}
.nl-admin-v16 .na-css-ship i,.nl-admin-v16 .na-css-vessel i{left:7px;top:0;width:7px;height:4px;border:2px solid currentColor;border-bottom:0;border-radius:2px 2px 0 0}
.nl-admin-v16 .na-css-users::before,.nl-admin-v16 .na-css-customer::before{left:7px;top:1px;width:8px;height:8px;border:2px solid currentColor;border-radius:50%}
.nl-admin-v16 .na-css-users::after,.nl-admin-v16 .na-css-customer::after{left:4px;bottom:1px;width:14px;height:10px;border:2px solid currentColor;border-radius:10px 10px 2px 2px}
.nl-admin-v16 .na-css-users i{right:0;top:7px;width:6px;height:6px;border-right:2px solid currentColor;border-bottom:2px solid currentColor}
.nl-admin-v16 .na-css-company::before{left:2px;top:6px;width:17px;height:14px;border:2px solid currentColor;border-radius:3px}
.nl-admin-v16 .na-css-company::after{left:7px;top:2px;width:7px;height:5px;border:2px solid currentColor;border-bottom:0;border-radius:3px 3px 0 0}
.nl-admin-v16 .na-css-company i{left:7px;top:12px;width:7px;height:5px;border:2px solid currentColor;border-top:0}
.nl-admin-v16 .na-css-port::before{left:4px;top:1px;width:14px;height:14px;border:2px solid currentColor;border-radius:55% 55% 55% 0;transform:rotate(-45deg)}
.nl-admin-v16 .na-css-port::after{left:9px;top:6px;width:4px;height:4px;border-radius:50%;background:currentColor}
.nl-admin-v16 .na-css-port i{left:8px;bottom:0;width:7px;height:2px;background:currentColor;border-radius:50%}
.nl-admin-v16 .na-css-audit::before{left:4px;top:1px;width:14px;height:19px;border:2px solid currentColor;border-radius:3px}
.nl-admin-v16 .na-css-audit::after{left:7px;top:7px;width:8px;height:2px;background:currentColor;box-shadow:0 5px 0 currentColor}
.nl-admin-v16 .na-css-audit i{left:7px;top:3px;width:5px;height:2px;background:currentColor}


/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .na-quick-actions,html[data-nl-mode="dark"] body.nl-themed-page .na-quick-actions-grid,html[data-nl-mode="dark"] body.nl-themed-page .na-shortcuts,html[data-nl-mode="dark"] body.nl-themed-page .na-panel,html[data-nl-mode="dark"] body.nl-themed-page .na-kpi,html[data-nl-mode="dark"] body.nl-themed-page .na-recent,html[data-nl-mode="dark"] body.nl-themed-page .na-hero,html[data-nl-mode="dark"] body.nl-themed-page .na-status-row{background:#203044!important;color:#edf4fc!important;border-color:#475e76!important}
html[data-nl-mode="dark"] body.nl-themed-page .na-quick-actions a,html[data-nl-mode="dark"] body.nl-themed-page .na-shortcuts a,html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip,html[data-nl-mode="dark"] body.nl-themed-page .na-quick-actions-grid a{background:#2b3e52!important;color:#ffe4c9!important;border-color:#536e86!important}
html[data-nl-mode="dark"] body.nl-themed-page .na-quick-actions :is(h1,h2,h3,p,small),html[data-nl-mode="dark"] body.nl-themed-page .na-status-row :is(h1,h2,h3,p,span){color:#edf4fc!important}

/* v20.23 - overview KPI balance and focus clarity */
body[data-nl-screen="module1-dashboard"] :is(.nl-dash-kpi,.nl-hero-stat,.nl-dashboard-card){min-width:0!important;border-radius:16px!important}
body[data-nl-screen="module1-dashboard"] :is(.nl-dash-kpi,.nl-hero-stat) :is(strong,.fs-2){font-variant-numeric:tabular-nums;overflow-wrap:anywhere}
body[data-nl-screen="module1-dashboard"] :is(.nl-ops-links,.nl-quick-actions){align-items:center;gap:10px;flex-wrap:wrap}

</style>
</head>
<body data-nl-screen="module1-dashboard" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-themed-page bg-body-tertiary text-dark"><%@ include file="../shared/_shell_start.jsp" %><div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3">Overview / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">
${requestScope.nlv_Module1_dashboard__1}
</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
${requestScope.nlv_Module1_dashboard__2}
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
