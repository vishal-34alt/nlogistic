<jsp:useBean id="nlViewSupport_Module4_ledger" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module4_ledger" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module4_ledger" property="view" value="Module4/ledger.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.math.*" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Inventory ledger | N-LOGISTIC</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="../shared/_theme.jsp" %>
<style>
/* N-LOGISTIC Inventory workspace. Inline in the JSP; no separate assets. */
.nl-inv{--iv-ink:#392a21;--iv-muted:#806b5b;--iv-accent:#cf551b;--iv-line:#ecd5c1;--iv-cream:#fffaf4;max-width:1650px;margin:auto;color:var(--iv-ink);font-size:.93rem}
.nl-inv *{box-sizing:border-box}
.nl-inv .iv-crumb{font-size:.75rem;letter-spacing:.1em;text-transform:uppercase;color:#956b4d;font-weight:850;margin:0 0 15px}
.nl-inv .iv-hero.nl-ops-hero{display:grid;grid-template-columns:minmax(0,1fr) 210px;gap:20px;align-items:center;padding:21px 26px;min-height:157px;border:1px solid #edc8aa;border-radius:22px;background:linear-gradient(112deg,#fffdf9,#fff0e1 73%,#ffe4cc);box-shadow:0 12px 28px #6c401216;margin:0 0 14px;overflow:hidden;position:relative;isolation:isolate}
.nl-inv .iv-hero:before{content:"";position:absolute;right:-65px;top:-110px;width:260px;height:260px;border:1px solid #dc8b4832;border-radius:50%;box-shadow:0 0 0 31px #f6bf8a22,0 0 0 60px #f6bf8a12;pointer-events:none}
.nl-inv .iv-kicker{letter-spacing:.14em;font-weight:900;color:#a94d1a;font-size:.7rem;text-transform:uppercase}
.nl-inv .iv-hero h1{font-size:clamp(1.6rem,2.6vw,2.3rem)!important;line-height:1.13!important;color:#36271e!important;margin:7px 0 9px!important;font-weight:900!important}
.nl-inv .iv-hero p{max-width:720px;color:#796052;font-size:.87rem;margin:0;line-height:1.55}
.nl-inv .iv-art{justify-self:end;align-self:center;width:190px;height:126px;position:relative;border-radius:35px;background:radial-gradient(circle at 55% 50%,#fffdf9 8%,#ffe8d5 72%,#ffe0c2 100%);border:1px solid #edc7a8;overflow:hidden;filter:drop-shadow(0 7px 9px #a8663030);pointer-events:none}
.nl-inv .iv-art:after{content:"";position:absolute;inset:11px;border-radius:50%;border:1px solid #e19d663c}
.nl-inv .iv-art span{display:block;position:absolute;z-index:1}
.nl-inv .iv-art .iv-main{left:36px;top:34px;width:120px;height:65px;background:linear-gradient(150deg,#ffb77c,#e77a2e);border:3px solid #9d532c;border-radius:10px;box-shadow:8px 8px 0 #b65e2828;animation:ivSway 5s ease-in-out infinite}
.nl-inv .iv-art .iv-detail{left:55px;top:53px;width:78px;height:5px;background:#ffe9d3;box-shadow:0 13px #ffe9d3,0 26px #ffe9d3;border-radius:5px}
.nl-inv .iv-art .iv-mini{left:21px;bottom:22px;width:38px;height:35px;background:#fff5e8;border:3px solid #a9562b;border-radius:7px;transform:rotate(-8deg);animation:ivFloat 5.8s ease-in-out infinite}
.nl-inv .iv-art .iv-dot{right:17px;top:17px;width:12px;height:12px;background:#e89454;transform:rotate(45deg);border-radius:3px;animation:ivBlink 3.8s ease-in-out infinite}
.nl-inv .iv-art[data-art="product"] .iv-main{transform:rotate(-8deg);border-radius:15px 4px 15px 4px;background:linear-gradient(130deg,#ffcf9f,#ef9950);animation:ivFloat 5s ease-in-out infinite}
.nl-inv .iv-art[data-art="product"] .iv-main:after{content:"";position:absolute;right:14px;top:13px;width:18px;height:18px;background:#fff9f1;border:3px solid #af5c32;border-radius:50%}
.nl-inv .iv-art[data-art="add"] .iv-main{left:37px;top:42px;width:115px;height:66px;background:repeating-linear-gradient(90deg,#f4a76b 0 19px,#ef8e4a 19px 25px);animation:ivBounce 4.5s ease-in-out infinite}
.nl-inv .iv-art[data-art="add"] .iv-detail{left:77px;top:11px;width:6px;height:38px;background:#bd602c;box-shadow:none;transform:rotate(90deg)}
.nl-inv .iv-art[data-art="add"] .iv-mini{left:90px;top:12px;width:6px;height:38px;background:#bd602c;border:0;border-radius:5px;transform:none}
.nl-inv .iv-art[data-art="import"] .iv-main{left:55px;top:20px;width:85px;height:97px;border-radius:10px;background:linear-gradient(#fffefa,#ffedda);animation:ivFloat 5.2s ease-in-out infinite}
.nl-inv .iv-art[data-art="import"] .iv-detail{left:72px;top:45px;width:48px;height:4px;background:#e6a66d;box-shadow:0 12px #e6a66d,0 24px #e6a66d}
.nl-inv .iv-art[data-art="ledger"] .iv-main{left:38px;top:27px;width:114px;height:83px;border-radius:12px;background:linear-gradient(#fffdf9,#ffe9d5);animation:ivSway 5.8s ease-in-out infinite}
.nl-inv .iv-art[data-art="ledger"] .iv-detail{left:57px;top:46px;width:74px;height:4px;background:#d98950;box-shadow:0 14px #e7a96f,0 28px #e7a96f,0 42px #e7a96f}
.nl-inv .iv-art[data-art="sales"] .iv-main{left:35px;top:20px;width:119px;height:92px;background:linear-gradient(#fffcf8,#ffecda);animation:ivFloat 5.2s ease-in-out infinite}
.nl-inv .iv-art[data-art="sales"] .iv-detail{left:51px;top:68px;width:16px;height:31px;background:#e1833b;box-shadow:24px -15px #f0ab6c,48px -31px #d55b1b}
.nl-inv .iv-art[data-art="summary"] .iv-main{left:33px;top:41px;height:56px;border-radius:5px 5px 13px 13px;transform:rotate(-3deg);animation:ivSway 5.3s ease-in-out infinite}
.nl-inv .iv-art[data-art="summary"] .iv-detail{width:94px;left:48px;top:61px;background:repeating-linear-gradient(90deg,#ffeedc 0 17px,transparent 17px 22px);box-shadow:0 12px #fff0df}
.nl-inv .iv-art[data-art="result"] .iv-main{left:50px;top:25px;width:93px;height:90px;background:linear-gradient(#fffefa,#ffead4);border-radius:18px}
.nl-inv .iv-art[data-art="result"] .iv-detail{left:72px;top:63px;width:50px;height:19px;box-shadow:none;border-left:6px solid #d66822;border-bottom:6px solid #d66822;background:transparent;transform:rotate(-45deg)}
@keyframes ivSway{0%,100%{transform:translateY(0)}50%{transform:translateY(-6px)}}@keyframes ivFloat{0%,100%{transform:translateY(0) rotate(-8deg)}50%{transform:translateY(-6px) rotate(-8deg)}}@keyframes ivBounce{0%,100%{transform:translateY(0)}50%{transform:translateY(-6px)}}@keyframes ivBlink{0%,100%{opacity:.9}50%{opacity:.25}}
.nl-inv .iv-nav{display:flex;flex-wrap:wrap;gap:7px;align-items:center;background:#fffbf5;border:1px solid #ead5c1;border-radius:15px;padding:10px;margin:0 0 18px;box-shadow:0 6px 17px #753c1b0a}
.nl-inv .iv-nav a{padding:9px 13px;border-radius:10px;text-decoration:none;color:#775240;font-size:.83rem;font-weight:750;border:1px solid transparent;white-space:nowrap;transition:background .15s,transform .15s}
.nl-inv .iv-nav a:hover,.nl-inv .iv-nav a:focus-visible{background:#ffebd9;color:#a34511;transform:translateY(-2px)}
.nl-inv .iv-nav a.iv-active{background:#cf551b;color:#fff;border-color:#c24e17;box-shadow:0 5px 12px #bf5d2725}
.nl-inv .iv-panel{background:#fffdfa;border:1px solid #ecd7c4;border-radius:19px;padding:19px;margin:0 0 17px;box-shadow:0 9px 23px #563a210b}
.nl-inv .iv-section-head{display:flex;flex-wrap:wrap;justify-content:space-between;align-items:flex-start;gap:12px;margin-bottom:15px}
.nl-inv .iv-section-head h2{font-size:1.2rem;font-weight:850;margin:0 0 3px}
.nl-inv .iv-section-head p{color:var(--iv-muted);font-size:.84rem;margin:0}
.nl-inv .iv-actions{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
.nl-inv .iv-btn{display:inline-flex;justify-content:center;align-items:center;gap:7px;border-radius:10px;border:1px solid #e9c7aa;background:#fff7ef;color:#91451a;padding:9px 13px;text-decoration:none;font-weight:760;font-size:.83rem;transition:transform .16s,box-shadow .16s,background .16s;min-height:38px}
.nl-inv .iv-btn:hover{background:#ffead6;color:#a2430e;transform:translateY(-2px);box-shadow:0 6px 14px #bb60251b}
.nl-inv .iv-btn.primary{color:#fff;background:#ca5118;border-color:#bc4611;box-shadow:0 4px 10px #c94f1a20}.nl-inv .iv-btn.primary:hover{background:#b8450d;color:#fff}
.nl-inv .iv-btn.danger{border-color:#edb6ac;background:#fff7f5;color:#b1392d}.nl-inv .iv-btn.danger:hover{background:#ffeae6}
.nl-inv .iv-btn:disabled{opacity:.55;cursor:not-allowed;transform:none}
.nl-inv .iv-kpis{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px;margin-bottom:18px}
.nl-inv .iv-kpi{border:1px solid #efd6c0;border-radius:15px;background:linear-gradient(145deg,#fffdfa,#fff4e8);padding:15px;min-height:102px}
.nl-inv .iv-kpi small{display:block;color:#77594b;font-size:.76rem;font-weight:750}.nl-inv .iv-kpi strong{display:block;font-size:1.55rem;color:#b94c15;line-height:1.2;margin:9px 0 4px}.nl-inv .iv-kpi span{display:block;font-size:.75rem;color:#987360}
.nl-inv .iv-field label{display:block;font-weight:750;color:#604432;font-size:.83rem;margin-bottom:6px}
.nl-inv input,.nl-inv select,.nl-inv textarea{border:1px solid #e7cdb6;border-radius:11px;background:#fffdfa;color:#3d3027;min-height:43px;padding:9px 11px;max-width:100%;width:100%}
.nl-inv input:focus,.nl-inv select:focus,.nl-inv textarea:focus{outline:2px solid #d78c52;outline-offset:1px;border-color:#c56e33;background:#fff}
.nl-inv textarea{min-height:100px}.nl-inv input[type=file]{height:auto}
.nl-inv .iv-fields{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}.nl-inv .iv-fields .full{grid-column:1/-1}
.nl-inv .iv-field .hint{display:block;color:#927260;font-size:.75rem;margin-top:5px}.nl-inv .iv-req{color:#c74420;font-weight:900;font-size:1.03rem}
.nl-inv .iv-filter-bar{display:grid;grid-template-columns:minmax(200px,2fr) minmax(115px,.85fr) minmax(105px,.7fr) auto;gap:9px;align-items:end;background:#fff7ee;border:1px solid #efdac6;border-radius:14px;padding:12px;margin-bottom:14px}
.nl-inv .iv-filter-bar.iv-two{grid-template-columns:minmax(200px,2fr) minmax(120px,1fr) auto}
.nl-inv .iv-filter-bar .iv-field label{font-size:.72rem}.nl-inv .iv-filter-bar .iv-actions{align-self:end}
.nl-inv .iv-local-bar{display:flex;gap:9px;flex-wrap:wrap;align-items:center;justify-content:space-between;margin-bottom:12px}
.nl-inv .iv-local-bar .iv-actions{flex-wrap:wrap}.nl-inv .iv-local-bar input{min-width:180px;max-width:300px;width:260px;flex:0 1 260px}.nl-inv .iv-local-bar select{width:auto;min-width:150px}.nl-inv .iv-local-bar .iv-actions{flex:1;min-width:0}
.nl-inv .iv-table-wrap{overflow-x:auto;border:1px solid #efddca;border-radius:15px;background:#fff;scrollbar-color:#e0b590 #fff7f0}
.nl-inv .iv-table{border-collapse:collapse;width:100%;min-width:800px;margin:0}
.nl-inv .iv-table th{text-align:left;color:#974419;font-size:.7rem;letter-spacing:.06em;text-transform:uppercase;background:#fff1e4;padding:13px 12px;border-bottom:1px solid #eed6bf;white-space:nowrap}
.nl-inv .iv-table td{padding:13px 12px;vertical-align:middle;border-bottom:1px solid #f1e5d8;font-size:.85rem}
.nl-inv .iv-table tbody tr:nth-child(2n){background:#fff9f2}.nl-inv .iv-table tbody tr:hover{background:#fff0de}
.nl-inv .iv-table td strong{color:#3f2a1c}.nl-inv .iv-table td small{display:block;color:#97745e;margin-top:3px}
.nl-inv .iv-table tbody tr[hidden]{display:none!important}
.nl-inv .iv-code{display:inline-flex;border:1px solid #f0c7aa;background:#fff0df;border-radius:8px;color:#a44713;font-weight:850;padding:5px 9px;cursor:pointer}
.nl-inv .iv-code:hover{background:#ffdfc0}
.nl-inv .iv-pill{display:inline-flex;border:1px solid #e4cdb8;border-radius:999px;padding:5px 9px;font-size:.72rem;font-weight:780;background:#fff8f1;color:#825334;white-space:nowrap}
.nl-inv .iv-pill.reserved{background:#f0f4ff;border-color:#cedcf9;color:#335a88}.nl-inv .iv-pill.ok{background:#e9f6ef;border-color:#c8e7d6;color:#21744d}.nl-inv .iv-pill.warn{background:#fff0e0;color:#aa5119}
.nl-inv .iv-table-actions{display:flex;gap:6px;flex-wrap:wrap}.nl-inv .iv-table-actions .iv-btn{min-height:33px;padding:7px 10px;font-size:.77rem}
.nl-inv .iv-table-controls{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;padding-top:11px}.nl-inv .iv-table-controls .iv-pagination{display:flex;align-items:center;gap:8px;font-size:.8rem;color:#755b4a}
.nl-inv .iv-empty{padding:28px;text-align:center;color:#8b6a54}.nl-inv .iv-switches{display:flex;gap:7px;flex-wrap:wrap;margin-bottom:16px;padding:5px;background:#fff4e8;border:1px solid #eddbc8;border-radius:13px;width:max-content;max-width:100%}
.nl-inv .iv-switch{border:0;border-radius:9px;background:transparent;padding:10px 16px;font-size:.85rem;font-weight:800;color:#8e5b3c}.nl-inv .iv-switch[aria-selected=true]{background:#c95216;color:white;box-shadow:0 5px 10px #a4491d27}
.nl-inv .iv-tabs-panel[hidden]{display:none!important}
.nl-inv .iv-notice{border:1px solid #efd5b9;border-left:4px solid #da6d27;border-radius:14px;padding:13px 16px;background:#fff5e9;color:#865334;margin:0 0 16px;font-size:.85rem}
.nl-inv .iv-notice.info{border-left-color:#6895c1;background:#f4f8ff;border-color:#d9e5f4;color:#43658c}
.nl-inv .iv-notice.error{border-left-color:#ba4131;background:#fff1ed;border-color:#f0c4b9;color:#9c3929}
.nl-inv .iv-modal{position:fixed;inset:0;z-index:1800;display:grid;place-items:center;background:#21191389;padding:18px;overflow-y:auto}
.nl-inv .iv-modal[hidden]{display:none!important}.nl-inv .iv-dialog{width:min(650px,100%);background:#fffcf8;border:1px solid #e4b895;border-radius:22px;box-shadow:0 24px 60px #4f2e1950;overflow:hidden}
.nl-inv .iv-dialog-head{padding:18px 22px;background:linear-gradient(130deg,#fff4e6,#ffe8d2);border-bottom:1px solid #ecd4bf;display:flex;justify-content:space-between;gap:10px}
.nl-inv .iv-dialog-head h2{margin:3px 0 0;font-size:1.35rem;font-weight:850}.nl-inv .iv-dialog-body{padding:20px 22px}.nl-inv .iv-dialog-foot{border-top:1px solid #eddac9;padding:15px 22px;display:flex;justify-content:flex-end;gap:9px;background:#fffaf5}
.nl-inv .iv-shortcut{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px}.nl-inv .iv-shortcut a{text-decoration:none;background:#fff6ed;border:1px solid #edd3bc;padding:13px;border-radius:12px;font-weight:800;color:#965122}.nl-inv .iv-shortcut a:hover{background:#ffe7d2;transform:translateY(-2px)}
.nl-inv .iv-file-info{border:2px dashed #e6be9e;border-radius:17px;background:#fff7ed;padding:20px;text-align:center}
.nl-inv .iv-file-info input{margin:12px auto;max-width:650px}.nl-inv .iv-file-info strong{display:block;font-size:1.06rem}
.nl-inv .iv-counter{font-size:.77rem;font-weight:720;color:#8a644c}.nl-inv .iv-check-list{padding-left:20px;color:#715a49;font-size:.86rem}.nl-inv .iv-check-list li+li{margin-top:7px}
.nl-inv .iv-toast{position:fixed;top:92px;right:20px;z-index:1850;max-width:min(450px,calc(100vw - 32px));background:#fff7ed;border:1px solid #e5b892;border-left:5px solid #cc541b;border-radius:15px;padding:15px 18px;box-shadow:0 15px 37px #4b2c1333;display:flex;gap:10px;align-items:flex-start;font-weight:650}
@media(max-width:1050px){.nl-inv .iv-kpis{grid-template-columns:repeat(2,minmax(0,1fr))}.nl-inv .iv-filter-bar{grid-template-columns:repeat(2,minmax(0,1fr))}.nl-inv .iv-filter-bar .iv-actions{grid-column:1/-1}}
@media(max-width:740px){.nl-inv .iv-hero.nl-ops-hero{grid-template-columns:1fr;padding:19px;min-height:0}.nl-inv .iv-art{display:none}.nl-inv .iv-fields,.nl-inv .iv-filter-bar,.nl-inv .iv-filter-bar.iv-two{grid-template-columns:1fr}.nl-inv .iv-filter-bar .iv-actions{grid-column:auto}.nl-inv .iv-shortcut{grid-template-columns:1fr}.nl-inv .iv-panel{padding:14px}.nl-inv .iv-nav{flex-wrap:nowrap;overflow-x:auto}.nl-inv .iv-nav a{flex:none}}
@media(prefers-reduced-motion:reduce){.nl-inv *, .nl-inv *:before,.nl-inv *:after{animation:none!important;transition:none!important}}
</style>
</head>
<body data-nl-screen="module4-ledger" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-themed-page bg-body-tertiary text-dark">
<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div>
<div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 p-3 p-lg-4 p-xl-4"><div class="nl-view-body container-fluid p-0"><main class="nl-inv">
<div class="iv-crumb">Inventory / Inventory ledger</div>
<header class="iv-hero nl-ops-hero"><div><div class="iv-kicker">N-LOGISTIC / INVENTORY WORKSPACE</div><h1>Inventory ledger</h1><p>Trace how quantities changed over time with filters and a readable history.</p></div>
<div class="iv-art hero-art" data-art="ledger" aria-hidden="true"><span class="iv-main"></span><span class="iv-detail"></span><span class="iv-mini"></span><span class="iv-dot"></span></div></header>
<nav class="iv-nav" aria-label="Inventory sections"><a href="${requestScope.nlv_Module4_ledger__1}/stock" class="" >Stock overview</a><a href="${requestScope.nlv_Module4_ledger__2}/stock?action=new-product" class="" >Add product</a><a href="${requestScope.nlv_Module4_ledger__3}/stock?action=new-stock" class="" >Add stock</a><a href="${requestScope.nlv_Module4_ledger__4}/stock?action=import" class="" >Import stock</a><a href="${requestScope.nlv_Module4_ledger__5}/stock?action=ledger" class="iv-active" aria-current="page">Inventory ledger</a><a href="${requestScope.nlv_Module4_ledger__6}/stock?action=sales" class="" >Sales history</a><a href="${requestScope.nlv_Module4_ledger__7}/stock?action=summary" class="" >Shipment stock</a></nav>


<section class="iv-panel"><div class="iv-section-head"><div><h2>Stock movement history</h2><p>A read-only record of incoming, outgoing, damaged and adjusted stock. Data is retrieved from the database.</p></div><span class="iv-pill">${requestScope.nlv_Module4_ledger__8} records loaded</span></div>
<form class="iv-filter-bar" method="get" action="${requestScope.nlv_Module4_ledger__9}/stock"><input type="hidden" name="action" value="ledger"><div class="iv-field"><label for="ivLedgerProduct">Product</label><select id="ivLedgerProduct" name="productId"><option value="">All products</option><jsp:setProperty name="nlViewSupport_Module4_ledger" property="fragment" value="nlv_Module4_ledger__10" /><jsp:getProperty name="nlViewSupport_Module4_ledger" property="fragment" /></select></div><div class="iv-field"><label for="ivLedgerType">Movement type</label><select id="ivLedgerType" name="txnType"><option value="">All movements</option><jsp:setProperty name="nlViewSupport_Module4_ledger" property="fragment" value="nlv_Module4_ledger__11" /><jsp:getProperty name="nlViewSupport_Module4_ledger" property="fragment" /></select></div><div class="iv-field"><label for="ivRefType">Reference type</label><input id="ivRefType" name="referenceType" value="${requestScope.nlv_Module4_ledger__12}" placeholder="Optional"></div><div class="iv-actions"><button class="iv-btn primary" type="submit">Apply filters</button><a class="iv-btn" href="${requestScope.nlv_Module4_ledger__13}/stock?action=ledger">Reset</a></div><div class="iv-field"><label for="ivRefId">Reference ID</label><input id="ivRefId" type="number" min="1" name="referenceId" value="${requestScope.nlv_Module4_ledger__14}" placeholder="Optional"></div></form>
</section><section class="iv-panel" data-iv-table="inventory-ledger"><div class="iv-section-head"><h2>Recorded transactions</h2><span class="iv-counter">Audit-safe, read-only</span></div><div class="iv-local-bar"><div class="iv-actions"><input type="search" data-iv-search placeholder="Find SKU, product or movement" aria-label="Search loaded rows"><button type="button" class="iv-btn" data-iv-clear>Clear</button><button type="button" class="iv-btn" data-iv-csv>Export CSV</button></div><span class="iv-counter" data-iv-count></span></div>
<div class="iv-table-wrap"><table class="iv-table" data-nl-server-paged="true" data-nl-no-auto-copy="true"><thead><tr><th>Recorded at</th><th>Product</th><th>Movement</th><th>Quantity</th><th>Balance afterward</th><th>Related record</th></tr></thead><tbody>
<jsp:setProperty name="nlViewSupport_Module4_ledger" property="fragment" value="nlv_Module4_ledger__15" /><jsp:getProperty name="nlViewSupport_Module4_ledger" property="fragment" />
<jsp:setProperty name="nlViewSupport_Module4_ledger" property="fragment" value="nlv_Module4_ledger__16" /><jsp:getProperty name="nlViewSupport_Module4_ledger" property="fragment" />
</tbody></table></div><div class="iv-table-controls"><div class="iv-actions"><label class="iv-counter" for="ivRowsSelect">Rows per page</label><select id="ivRowsSelect" style="width:auto;min-height:36px" data-iv-size><option value="10">10</option><option value="20">20</option><option value="50">50</option></select></div><div class="iv-pagination"><button type="button" class="iv-btn" data-iv-prev>Previous</button><span data-iv-page>Page 1 / 1</span><button type="button" class="iv-btn" data-iv-next>Next</button></div></div></section></main></div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){'use strict';
  const root=document.querySelector('.nl-inv');if(!root)return;
  // Each data inventory table supports local search, pagination and CSV export.
  root.querySelectorAll('[data-iv-table]').forEach(block=>{
    const table=block.querySelector('table');if(!table)return;
    const rows=Array.from(table.querySelectorAll('tbody tr[data-iv-row]'));
    const search=block.querySelector('[data-iv-search]');
    const type=block.querySelector('[data-iv-type]');
    const size=block.querySelector('[data-iv-size]');
    const clear=block.querySelector('[data-iv-clear]');
    const previous=block.querySelector('[data-iv-prev]');
    const next=block.querySelector('[data-iv-next]');
    const result=block.querySelector('[data-iv-count]');
    const pageNote=block.querySelector('[data-iv-page]');
    let page=0;
    function filtered(){
      const q=(search?.value||'').toLocaleLowerCase().trim();const t=(type?.value||'').trim().toLowerCase();
      return rows.filter(row=>(!q||row.textContent.toLocaleLowerCase().includes(q))&&(!t||row.dataset.ivKind===t));
    }
    function apply(){const matches=filtered(), per=Math.max(1,parseInt(size?.value||'10',10));const pages=Math.max(1,Math.ceil(matches.length/per));page=Math.max(0,Math.min(page,pages-1));const set=new Set(matches.slice(page*per,(page+1)*per));rows.forEach(row=>{row.hidden=!set.has(row);});
      if(result)result.textContent='Showing '+(matches.length?Math.min(page*per+1,matches.length):0)+'–'+Math.min((page+1)*per,matches.length)+' of '+matches.length;
      if(pageNote)pageNote.textContent='Page '+(page+1)+' / '+pages;
      if(previous)previous.disabled=page<=0;if(next)next.disabled=page>=pages-1;}
    [search,type,size].forEach(el=>el?.addEventListener(el===search?'input':'change',()=>{page=0;apply();}));
    clear?.addEventListener('click',()=>{if(search)search.value='';if(type)type.value='';page=0;apply();});
    previous?.addEventListener('click',()=>{page--;apply();});next?.addEventListener('click',()=>{page++;apply();});
    block.querySelector('[data-iv-csv]')?.addEventListener('click',()=>{
      const quote=v=>{let s=String(v||'').replace(/\s+/g,' ').trim();if(/^[=+@-]/.test(s))s="'"+s;return '"'+s.replace(/"/g,'""')+'"';};
      const lines=[Array.from(table.querySelectorAll('thead th')).map(th=>quote(th.textContent.trim())).join(',')];
      filtered().forEach(row=>lines.push(Array.from(row.querySelectorAll('td')).map(cell=>quote(cell.dataset.ivExport||cell.innerText.replace(/\s+/g,' ').trim())).join(',')));
      const blob=new Blob(['\uFEFF'+lines.join('\r\n')],{type:'text/csv;charset=utf-8'});const url=URL.createObjectURL(blob);
      const a=document.createElement('a');a.href=url;a.download='nlogistic-'+(block.dataset.ivTable||'records')+'.csv';document.body.appendChild(a);a.click();a.remove();setTimeout(()=>URL.revokeObjectURL(url),1500);
    });apply();
  });
  // Product and stock tabs keep their own data without another server trip.
  const switches=Array.from(root.querySelectorAll('[data-iv-tab]'));
  const panels=Array.from(root.querySelectorAll('[data-iv-panel]'));
  function switchTab(which){switches.forEach(btn=>{const yes=btn.dataset.ivTab===which;btn.setAttribute('aria-selected',String(yes));});panels.forEach(panel=>{panel.hidden=panel.dataset.ivPanel!==which;});}
  switches.forEach(btn=>btn.addEventListener('click',()=>switchTab(btn.dataset.ivTab)));
  if(switches.length)switchTab(new URL(location.href).searchParams.get('view')==='catalog'?'catalog':'stock');
  // Stock adjustments are in a single compact modal; the server keeps existing one-field update rules.
  const modal=root.querySelector('#ivStockEditor');const title=root.querySelector('#ivEditorName');
  let previous=null;
  function closeEditor(){if(modal)modal.hidden=true;document.body.style.overflow='';previous?.focus();}
  root.querySelectorAll('[data-iv-edit-stock]').forEach(btn=>btn.addEventListener('click',()=>{
    if(!modal)return;previous=btn;const id=btn.dataset.id;
    root.querySelectorAll('[data-iv-stock-id]').forEach(el=>el.value=id);
    root.querySelector('#ivStockQuantity').value=btn.dataset.quantity||'0';
    root.querySelector('#ivStockDamaged').value=btn.dataset.damaged||'0';
    if(title)title.textContent=btn.dataset.name||'Stock record';
    modal.hidden=false;document.body.style.overflow='hidden';modal.querySelector('.iv-dialog')?.focus();
  }));
  root.querySelectorAll('[data-iv-close]').forEach(btn=>btn.addEventListener('click',closeEditor));
  modal?.addEventListener('click',e=>{if(e.target===modal)closeEditor();});
  document.addEventListener('keydown',e=>{if(e.key==='Escape'&&modal&&!modal.hidden)closeEditor();});
  // Copyable product SKU chips.
  root.querySelectorAll('[data-iv-copy]').forEach(btn=>btn.addEventListener('click',async()=>{
    const value=btn.dataset.ivCopy||btn.textContent.trim();try{await navigator.clipboard.writeText(value);const old=btn.textContent;btn.textContent='Copied';setTimeout(()=>btn.textContent=old,1300);}catch(e){/* Clipboard may be unavailable on http; no fake confirmation. */}
  }));
  const flash=root.querySelector('.iv-toast');if(flash){setTimeout(()=>flash.remove(),6500);flash.querySelector('button')?.addEventListener('click',()=>flash.remove());}
})();
</script>
</body></html>
