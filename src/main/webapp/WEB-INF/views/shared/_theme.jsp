<script id="nlThemeController">
(function(){'use strict';
var key='nlogistic.ui.colorMode.v1';
function read(){try{return localStorage.getItem(key)==='dark'?'dark':'light';}catch(e){return 'light';}}
function paint(mode,persist){mode=mode==='dark'?'dark':'light';document.documentElement.setAttribute('data-nl-mode',mode);document.documentElement.setAttribute('data-bs-theme',mode);if(persist){try{localStorage.setItem(key,mode);}catch(e){}}
  document.querySelectorAll('[data-nl-theme-toggle]').forEach(function(button){var night=mode==='dark';button.setAttribute('aria-pressed',String(night));button.setAttribute('aria-label',night?'Switch to light mode':'Switch to dark mode');button.setAttribute('title',night?'Switch to light mode':'Switch to dark mode');var label=button.querySelector('[data-nl-theme-label]');if(label)label.textContent=night?'Light mode':'Dark mode';var icon=button.querySelector('[data-nl-theme-symbol]');if(icon)icon.textContent=night?'\u2600':'\u263e';});
  if(window.Chart&&window.Chart.defaults){try{window.Chart.defaults.color=mode==='dark'?'#d9e1ed':'#5e493b';window.Chart.defaults.borderColor=mode==='dark'?'#354455':'#ead7c2';var instances=window.Chart.instances||{};Object.keys(instances).forEach(function(id){var chart=instances[id];if(!chart||!chart.options)return;if(chart.options.scales)Object.keys(chart.options.scales).forEach(function(axis){var s=chart.options.scales[axis];if(s.ticks)s.ticks.color=mode==='dark'?'#d9e1ed':'#5e493b';if(s.grid)s.grid.color=mode==='dark'?'#334050':'#ead7c2';});if(chart.options.plugins&&chart.options.plugins.legend&&chart.options.plugins.legend.labels)chart.options.plugins.legend.labels.color=mode==='dark'?'#d9e1ed':'#5e493b';chart.update('none');});}catch(e){}}
}
window.nlTheme={apply:paint,read:read,toggle:function(){paint(document.documentElement.getAttribute('data-nl-mode')==='dark'?'light':'dark',true);}};
paint(read(),false);
document.addEventListener('click',function(event){var trigger=event.target.closest('[data-nl-theme-toggle]');if(trigger){event.preventDefault();window.nlTheme.toggle();}});
document.addEventListener('DOMContentLoaded',function(){paint(read(),false);});
window.addEventListener('storage',function(event){if(event.key===key)paint(read(),false);});
})();
</script>
<%-- Shared inline CSS. No independent custom stylesheet file. --%>
<style>
/*
 * N-LOGISTIC Premium Orange — one custom stylesheet for all seven modules.
 * Bootstrap 5 is the UI foundation. No JSTL, .jspf, extra CSS framework, or icon font.
 * Design language: old workspace proportions + warm premium orange/cream palette.
 */
:root {
  color-scheme: light;
  --nl-ink: #302920;
  --nl-muted: #76695f;
  --nl-orange: #cf551b;
  --nl-orange-deep: #a63d10;
  --nl-amber: #ec9c52;
  --nl-brown: #482819;
  --nl-soft: #fff3e4;
  --nl-cream: #fffdf8;
  --nl-tint: #faf4eb;
  --nl-bg: #f7f3ee;
  --nl-line: #ebdfd1;
  --nl-shadow: 0 10px 28px rgba(65,38,19,.055), 0 2px 8px rgba(65,38,19,.035);
  --nl-shadow-hover: 0 16px 34px rgba(65,38,19,.105);
  --bs-primary: #cf551b;
  --bs-primary-rgb: 207,85,27;
  --bs-warning: #ef9c50;
  --bs-warning-rgb: 239,156,80;
  --bs-body-color: #302920;
  --bs-body-bg: #f7f3ee;
  --bs-border-color: #ebdfd1;
  --bs-link-color: #a63d10;
  --bs-link-hover-color: #7e2c09;
}
*, *::before,*::after { box-sizing: border-box; }
html { scroll-behavior: smooth; }
body { font-family: "Segoe UI", Inter, -apple-system, BlinkMacSystemFont, "Helvetica Neue", Arial, sans-serif; letter-spacing:-.007em; }
a { color: var(--nl-orange-deep); }
a:hover { color: #7d2b0a; }
:focus-visible { outline: 3px solid #dc792e !important; outline-offset: 3px; }
::selection { background:#f4cba9; color:#4b2817; }

/* Shared workspace scaffolding */
.nl-themed-page {
  min-height: 100vh;
  background: radial-gradient(ellipse 70% 26% at 92% 8%,rgba(249,200,152,.24),transparent 65%),
              linear-gradient(160deg,#f9f5f0 0%,#f7f3ee 52%,#f5eee5 100%) !important;
  color:var(--nl-ink) !important;
}
.nl-themed-page .bg-body-tertiary,
.nl-themed-page .bg-light { background-color:transparent !important; }
.nl-themed-page .bg-warning-subtle { background-color:#fff1df !important; }
.nl-themed-page .border-warning-subtle { border-color:var(--nl-line) !important; }
.nl-themed-page .text-warning-emphasis,
.nl-themed-page .text-warning { color:var(--nl-orange-deep) !important; }
.nl-themed-page > header.navbar,
.nl-themed-page > .nl-app-header {
  z-index: 1040;
  background: linear-gradient(112deg,#352318 0%,#593019 37%,#913c17 75%,#b84b17 100%) !important;
  border: 0 !important;
  box-shadow: 0 5px 25px rgba(56,26,9,.18) !important;
  min-height:80px;
  isolation:isolate;
}
.nl-themed-page > header.navbar::before {
  content:""; position:absolute; inset:0;pointer-events:none;z-index:-1;
  background:radial-gradient(ellipse 32% 150% at 96% 160%,rgba(255,184,99,.20),transparent 73%),
             linear-gradient(140deg,transparent 65%,rgba(255,193,118,.035) 65%,transparent 88%);
}
.nl-app-header .navbar-brand { color:#ffe3c6 !important; letter-spacing:.08em; font-size:1.02rem !important; border-color:rgba(255,188,117,.52) !important; }
.nl-app-header .navbar-brand:hover {color:white !important;}
.nl-app-header .navbar-brand img {width:22px;height:22px;}
.nl-app-header .btn-outline-warning {border-color:rgba(255,211,165,.42) !important;color:#fff4e8 !important;}
.nl-app-header .btn-outline-warning:hover {background:rgba(255,255,255,.12) !important;}
.nl-app-header form[role="search"] {
  background-color:rgba(255,247,239,.13) !important;
  border:1px solid rgba(255,224,194,.25) !important;
  box-shadow:none !important;
  max-width:620px;flex:1;min-width:240px;
}
.nl-app-header form[role="search"] input[type="search"] {
  background-color:transparent !important; color:#fff7ed !important;
  font-size:.9rem; min-width:130px; box-shadow:none;
}
.nl-app-header form[role="search"] input[type="search"]::placeholder{color:rgba(255,246,232,.79);opacity:1;}
.nl-app-header form[role="search"] img{filter:brightness(0) invert(1);opacity:.85;}
.nl-app-header form[role="search"] .btn {background:#ffd19d !important;color:#542a13 !important;border:0 !important;box-shadow:none !important;}
.nl-app-header >a[href*="viewProfile"] {color:#fff1df !important;max-width:28%;min-width:30px;overflow:hidden;}
.nl-app-header >a[href*="viewProfile"] img {flex-shrink:0;}

#nlSidebarCol {
  background: linear-gradient(168deg,#fef9f0 0%,#f8ede0 100%) !important;
  border-color:#e6d6c5 !important;
  position:relative;
  box-shadow: 4px 2px 22px rgba(83,50,27,.045) !important;
  min-height:calc(100vh - 80px);
}
#nlSidebarCol::after { content:""; position:absolute;inset:auto 0 0; height:145px;
  pointer-events:none;
  background:radial-gradient(ellipse 140% 160% at -35% 160%,rgba(231,156,90,.22),transparent 62%);
}
.nl-primary-nav {position:sticky;top:84px;padding-top:1.35rem !important;z-index:1;}
.nl-primary-nav .nl-workspace-label {color:#a56a43 !important;letter-spacing:.12em;font-size:.7rem;}
.nl-primary-nav .nav-link {
  position:relative;color:#59483b !important;
  border:1px solid transparent;border-radius:13px !important;
  font-size:.93rem;font-weight:550;min-height:51px;
  transition:background-color .15s,border-color .15s,box-shadow .15s,transform .15s;
}
.nl-primary-nav .nav-link:hover {background-color:#fff5e9 !important;border-color:#ebd9c7 !important;transform:translateX(2px);}
.nl-primary-nav .nav-link.bg-warning,
.nl-primary-nav .nav-link[aria-current="page"] {
  background: linear-gradient(105deg,#b94616,#da6523) !important;
  color:white !important; font-weight:700 !important;
  border-color:#c95720 !important;
  box-shadow:0 6px 16px rgba(178,71,21,.17) !important;
}
.nl-primary-nav img {width:21px;height:21px;flex:none;opacity:.93;}
.nl-primary-nav .nav-link.bg-warning img,
.nl-primary-nav .nav-link[aria-current="page"] img {filter:brightness(0) invert(1);}
.nl-primary-nav .nav-link .nl-nav-label {white-space:normal;overflow-wrap:break-word;}
.nl-primary-nav hr {border-color:#dcc6b1 !important;opacity:.8;}
.nl-primary-nav form button {border-color:#dac9b7;color:#6c4430;background:rgba(255,255,255,.6);font-weight:600;}
.nl-primary-nav form button:hover {background:#f7e5d4;border-color:#c98555;color:#582a12;}
#nlSidebarCol.col-lg-1 .nl-primary-nav {padding-left:.25rem !important;padding-right:.25rem !important;}
#nlSidebarCol.col-lg-1 .nl-primary-nav .nav-link {justify-content:center;padding-left:.3rem !important;padding-right:.3rem !important;min-width:0;}
#nlSidebarCol.col-lg-1 .nl-primary-nav .nav-link img{width:23px;height:23px;}
#nlMainColumn {
  background:transparent !important;
  min-width:0;
  padding-top:1.65rem !important;
  padding-bottom:3rem !important;
}
.nl-view-body {max-width:1640px;margin-inline:auto;}
.nl-view-body > .container-fluid {padding-left:0 !important;padding-right:0 !important;}
.nl-breadcrumb, #nlMainColumn > .small.text-uppercase {color:#976d4e !important;font-size:.74rem !important;letter-spacing:.1em;font-weight:700 !important;}
.nl-view-body h1,.nl-view-body .h1 {font-weight:800 !important;letter-spacing:-.035em;color:#372a20 !important;}
.nl-view-body h2,.nl-view-body h3 {letter-spacing:-.025em;color:#3a2b20;}
.nl-view-body h1:where(.text-warning-emphasis),.nl-view-body h2.text-warning-emphasis {color:var(--nl-orange-deep) !important;}
.nl-view-body p,.nl-view-body .text-secondary {line-height:1.6;}

/* Consistent information surfaces */
.nl-themed-page .card,
.nl-themed-page .nl-card,
.nl-themed-page .nl-dash-panel,
.nl-themed-page .nl-table-toolbar,
.nl-themed-page .nl-module-toolbar,
.nl-themed-page .nl-tabs,
.nl-themed-page .nl-table-pagination {
  border:1px solid var(--nl-line) !important;
  border-radius:19px !important;
  background:#fffdf9 !important;
  box-shadow:var(--nl-shadow);
}
.nl-themed-page .card {overflow:visible;}
.nl-themed-page .card-header {background:#fff9ef;border-bottom:1px solid var(--nl-line);border-radius:18px 18px 0 0;}
.nl-themed-page .card > h2:first-child,
.nl-themed-page .card > h3:first-child,
.nl-themed-page .card .card-title {font-weight:750;color:#443021;}
.nl-themed-page .nl-dash-kpi {position:relative;transition:transform .18s,box-shadow .18s;overflow:hidden;border-top:3px solid #e18a4c !important;}
.nl-themed-page .nl-dash-kpi:hover {transform:translateY(-3px);box-shadow:var(--nl-shadow-hover) !important;}
.nl-themed-page .nl-kpi-value {font-size:clamp(1.65rem,2.6vw,2.4rem);font-weight:800;line-height:1.1;color:#302820;}
.nl-themed-page .nl-dash-kpi img {width:24px;height:24px;}
.nl-themed-page .nl-dash-panel {min-height:250px;}
.nl-themed-page .list-group-item {background:transparent;border-color:#f0e5d8;}
.nl-themed-page .nl-action-link {border-radius:11px;padding-inline:.7rem !important;}
.nl-themed-page .nl-action-link:hover {background:#fff3e5;}
.nl-themed-page .nl-action-dot {background:var(--nl-orange) !important;}
.nl-themed-page section.card .section-head {display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:1rem;margin-bottom:1.1rem;}
.nl-themed-page .detail-card .details-grid {display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:1rem 1.5rem;}
.nl-themed-page .detail-card .details-grid >div {padding:1rem 1.1rem;background:#fff7ed;border:1px solid #f1e2d2;border-radius:12px;}
.nl-themed-page .detail-card .details-grid small{display:block;color:#8b6650;font-weight:600;margin-bottom:.4rem;}
.nl-themed-page .detail-card .details-grid strong{display:block;overflow-wrap:anywhere;}
.nl-themed-page .nl-stepper,.nl-themed-page .nl-booking-steps {background:#fffaf3;border:1px solid #eedcc9;border-radius:16px;padding:1rem;box-shadow:var(--nl-shadow);}
.nl-themed-page .nl-step {border-color:#f0d7be;}
.nl-themed-page .nl-step.active,.nl-themed-page .nl-booking-step.active{background:#c85518 !important;color:#fff;border-color:#c85518;}
.nl-themed-page .nl-table-toolbar {display:flex;align-items:center;justify-content:space-between;gap:.8rem;flex-wrap:wrap;padding:.8rem 1rem;margin-bottom:1rem;}
.nl-themed-page .nl-table-filters {display:flex;flex-wrap:wrap;align-items:center;gap:.7rem;flex:1;min-width:0;}
.nl-themed-page .nl-table-search {max-width:330px;min-width:155px;flex:1;}
.nl-themed-page .nl-table-status {max-width:210px;}
.nl-themed-page .nl-table-records {font-weight:650;white-space:nowrap;}
.nl-themed-page .nl-table-pagination {padding:.8rem 1rem;margin-top:.55rem !important;}
.nl-themed-page .nl-page-size {width:auto;min-width:104px;}
.nl-themed-page .table-responsive {border:1px solid #eee1d3;border-radius:13px;max-width:100%;}
.nl-themed-page .table {margin-bottom:0;color:#403326;--bs-table-color:#403326;--bs-table-border-color:#f0e6dc;--bs-table-striped-bg:#fff9f3;}
.nl-themed-page .table thead,.nl-themed-page .table .table-warning {--bs-table-bg:#f9eddf;--bs-table-color:#674a36;}
.nl-themed-page .table thead th {font-size:.74rem;letter-spacing:.035em;text-transform:uppercase;font-weight:750;color:#6c4a32;vertical-align:middle;border-bottom:1px solid #ead7c2;padding:.88rem .8rem;white-space:nowrap;}
.nl-themed-page .table tbody td {padding:.86rem .8rem;vertical-align:middle;color:#44382d;}
.nl-themed-page .table tbody tr:hover>* {--bs-table-bg-state:#fff3e7;}
.nl-themed-page .table .btn {white-space:nowrap;}
.nl-themed-page .nl-sort-head {font-size:.74rem;text-transform:uppercase;letter-spacing:.035em;color:#6c4a32 !important;}
.nl-themed-page .nl-table-empty {border-color:#ecdac9;background:#fff7ee;color:#836047;}
.nl-themed-page .nl-tabs {padding:.55rem !important;gap:.4rem !important;}
.nl-themed-page .nl-tabs .nav-link {color:#795640;border-radius:10px;font-weight:600;padding:.7rem 1rem;}
.nl-themed-page .nl-tabs .nav-link.active {background:var(--nl-orange) !important;color:#fff !important;}
.nl-themed-page .nl-tabs .nav-link:not(.active):hover {background:#fff0e0;color:var(--nl-orange-deep);}
.nl-module-toolbar {padding:.7rem 1rem;}
.nl-module-toolbar a {font-size:.9rem;font-weight:600;color:#845434;}
.nl-module-toolbar a:hover {color:#b34d16;}
.nl-themed-page .navbar.bg-white:not(.nl-app-header) {background:#fff9f0 !important;border:1px solid #eedfcf;border-radius:14px;}

/* Controls: purposefully warm, never flat Bootstrap yellow */
.nl-themed-page .btn,.nl-auth-page .btn {font-weight:650;border-radius:10px;transition:transform .12s,background-color .15s,box-shadow .15s;}
.nl-themed-page .btn:hover,.nl-auth-page .btn:hover {transform:translateY(-1px);}
.nl-themed-page .btn-primary,.nl-themed-page .btn-warning,
.nl-auth-page .btn-primary,.nl-auth-page .btn-warning,
.nl-themed-page .text-bg-warning {--bs-btn-color:#fff;--bs-btn-bg:#cd551b;--bs-btn-border-color:#cd551b;--bs-btn-hover-color:#fff;--bs-btn-hover-bg:#ac410e;--bs-btn-hover-border-color:#ac410e;--bs-btn-active-bg:#94370b;--bs-btn-active-border-color:#94370b;--bs-btn-disabled-bg:#bd8060;--bs-btn-disabled-border-color:#bd8060;}
.nl-themed-page .btn-warning.bg-gradient,.nl-auth-page .btn-warning.bg-gradient {background:linear-gradient(110deg,#b74415,#dc6b21) !important;border-color:#b74415 !important;color:white !important;}
.nl-themed-page .btn-warning.bg-gradient:hover,.nl-auth-page .btn-warning.bg-gradient:hover{background:linear-gradient(110deg,#a73d0e,#ca5719)!important;box-shadow:0 5px 14px rgba(169,70,20,.23);}
.nl-themed-page .btn-outline-dark,.nl-themed-page .btn-outline-secondary {color:#6b4630;border-color:#ddc9b6;background:#fffdf9;}
.nl-themed-page .btn-outline-dark:hover,.nl-themed-page .btn-outline-secondary:hover{color:white;border-color:#8b4422;background:#8b4422;}
.nl-themed-page .btn-outline-warning{color:#b24b16;border-color:#dda777;}
.nl-themed-page .btn-outline-warning:hover{background:#cd551b;color:white;}
.nl-themed-page .badge {font-weight:700;border-radius:30px;letter-spacing:.01em;padding:.45em .8em;}
.nl-themed-page .badge.text-bg-success {background:#e4f4e8 !important;color:#23613b !important;border:1px solid #badcc3;}
.nl-themed-page .badge.text-bg-danger {background:#fde8e3 !important;color:#a03022 !important;border:1px solid #f2c5ba;}
.nl-themed-page .badge.text-bg-warning {background:#fff0d3 !important;color:#93610d !important;border:1px solid #f0d69f;}
.nl-themed-page .badge.text-bg-info {background:#e7eef5 !important;color:#375b7b !important;border:1px solid #bfd3e4;}
.nl-themed-page .badge.bg-warning {background:#fae5c7 !important;color:#8e4113 !important;}
.nl-themed-page .form-label {font-weight:650;color:#4e3728;margin-bottom:.42rem;}
.nl-themed-page .form-control,.nl-themed-page .form-select,
.nl-auth-page .form-control,.nl-auth-page .form-select {
  background-color:#fffdf9 !important;border:1px solid #dfcdbb !important;
  border-radius:10px;color:#302920 !important;min-height:42px;
  box-shadow:none;transition:border-color .16s,box-shadow .16s;
}
.nl-themed-page .form-control:focus,.nl-themed-page .form-select:focus,
.nl-auth-page .form-control:focus,.nl-auth-page .form-select:focus {
  border-color:#d9783d !important;box-shadow:0 0 0 .22rem rgba(207,85,27,.13) !important;outline:0 !important;
}
.nl-themed-page .input-group-text,.nl-auth-page .input-group-text {background:#fff2e5 !important;border-color:#dfcdbb;color:#8a5435;}
.nl-themed-page .form-text{color:#927561;}
.nl-themed-page textarea {min-height:96px;}
.nl-themed-page input:disabled,.nl-themed-page select:disabled,.nl-themed-page button:disabled,
.nl-auth-page input:disabled {opacity:.62;cursor:not-allowed;}
.nl-themed-page .alert,.nl-auth-page .alert {border-radius:13px;padding:1rem 1.1rem;box-shadow:none;}
.nl-themed-page .alert-info {background:#eef3f8;border-color:#cadae9;color:#34546c;}
.nl-themed-page .alert-warning {background:#fff5df;border-color:#f2ddae;color:#835516;}
.nl-themed-page .alert-success {background:#eaf8ed;border-color:#c8e7cd;color:#275e3b;}
.nl-themed-page .alert-danger,.nl-auth-page .alert-danger {background:#fff0ed;border-color:#efc9c1;color:#8c3124;}
.nl-themed-page .nl-return-link {margin-top:.6rem;}
.nl-themed-page .nl-copy-id {font-size:.67rem;padding:.22rem .43rem;}
.nl-themed-page .nl-booking-steps {gap:.65rem !important;}
.nl-themed-page .nl-booking-step {background:#fff8f2 !important;color:#8b5b3a;border:1px solid #ebd3bc;}
.nl-themed-page .nl-booking-step.active {background:#cd551b !important;color:white !important;}
.nl-themed-page .nl-view-body canvas {max-width:100%;}
.nl-themed-page .payment-success{background:#e6f6e9;color:#285f3f;border:1px solid #c6e7ce;border-radius:14px;padding:1rem 1.1rem;margin-bottom:1rem;}
.nl-themed-page .payment-card {padding:1.5rem;margin-bottom:1.3rem;}
.nl-themed-page .payment-card h3 {font-size:1.18rem;font-weight:750;}
.nl-themed-page .nl-chart-card {min-height:320px;}
.nl-themed-page .nl-chart-card canvas {max-height:340px;}
.nl-themed-page .nl-chart-legend {color:var(--nl-muted);}
.nl-themed-page footer {color:#866f5e!important;border-color:#e8d8c9!important;}

/* Premium split-view authentication: no separate library or graphical dependencies */
.nl-auth-page {background:
  radial-gradient(ellipse 64% 44% at -6% -12%,rgba(235,153,89,.23),transparent 75%),
  radial-gradient(ellipse 55% 37% at 106% 109%,rgba(237,160,91,.18),transparent 71%),
  linear-gradient(145deg,#f7efe3,#fffaf2 50%,#f8eee2);
  color:#392b22;min-height:100vh;}
.nl-auth-container {max-width:1410px;}
.nl-auth-page .nl-auth-shell {max-width:1250px;margin-inline:auto;border-radius:28px !important;
  box-shadow:0 30px 85px rgba(81,48,22,.17),0 4px 15px rgba(81,48,22,.06) !important;
  border:1px solid #e9d8c3 !important;}
.nl-auth-page .nl-auth-hero {position:relative;isolation:isolate;overflow:hidden;
  min-height:590px;background:linear-gradient(153deg,#34251c 0%,#70361d 50%,#c4551b 100%) !important;}
.nl-auth-page .nl-auth-hero::before {content:"";z-index:-1;position:absolute;width:480px;height:480px;
  right:-220px;bottom:-230px;border:1px solid rgba(255,210,163,.25);border-radius:50%;
  box-shadow:0 0 0 45px rgba(255,204,148,.045),0 0 0 120px rgba(255,206,153,.035);}
.nl-auth-page .nl-auth-hero::after {content:"";position:absolute;z-index:-1;inset:auto -3rem 1rem 8%;height:155px;opacity:.24;
  background:repeating-linear-gradient(160deg,transparent 0,transparent 20px,rgba(255,221,183,.40) 21px,transparent 22px);mask-image:linear-gradient(0deg,black,transparent 95%);}
.nl-auth-page .nl-auth-hero .badge{border-color:#f0ad74!important;background:rgba(255,255,255,.055);color:#ffe3b7!important;letter-spacing:.12em;padding:.75rem 1rem !important;}
.nl-auth-page .nl-auth-hero h2{font-size:clamp(2.4rem,4.4vw,4.6rem);line-height:1.09;letter-spacing:-.055em;max-width:470px;}
.nl-auth-page .nl-auth-hero h2 .text-warning{color:#fcb86d!important;}
.nl-auth-page .nl-auth-hero p{max-width:420px;color:#f4e3d6 !important;}
.nl-auth-page .nl-auth-hero ul li{color:#fff1e3;font-weight:550;font-size:.94rem;}
.nl-auth-page .nl-auth-hero li img {width:20px;height:20px;filter:brightness(0) invert(1);opacity:.91;}
.nl-auth-page .nl-auth-hero p.mt-auto {color:#fbd3a9 !important;letter-spacing:.17em;}
.nl-auth-page .nl-auth-form {background:linear-gradient(175deg,#fffefb,#fff9f2) !important;min-width:0;}
.nl-auth-page .nl-auth-form h1{font-size:clamp(2rem,3vw,3.2rem);line-height:1.13;letter-spacing:-.045em;color:#3e2d24;font-weight:800 !important;}
.nl-auth-page .nl-auth-form .badge{background:#fff0df!important;color:#a94d1a!important;border:1px solid #f0d5b7;padding:.75rem 1rem !important;letter-spacing:.025em;}
.nl-auth-page .nl-auth-form .form-label {color:#4d3729;font-weight:700;}
.nl-auth-page .nl-auth-form .form-control,
.nl-auth-page .nl-auth-form .form-select {min-height:51px;background:#fffefd!important;}
.nl-auth-page .nl-auth-form .input-group-text{border-radius:11px 0 0 11px;}
.nl-auth-page .nl-auth-form .btn-outline-dark {background:#fff5e9;border-color:#e2ccb5;color:#69432d;}
.nl-auth-page .nl-auth-form .btn-outline-dark:hover {background:#f4e3d0;}
.nl-auth-page .nl-auth-form button[type=submit] {box-shadow:0 8px 18px rgba(186,66,18,.17) !important;}
.nl-auth-page .nl-auth-form a{color:#b84e17;text-decoration:none;font-weight:700;}
.nl-auth-page .nl-auth-form a:hover{text-decoration:underline;}
.nl-auth-page .nl-auth-form .text-secondary {color:#806a5c !important;}
.nl-auth-page .nl-auth-form .border-top {border-color:#eedfd0!important;}
.nl-auth-page .nl-auth-form .text-warning-emphasis{color:#c85820!important;}

/* Invoice PDF-friendly HTML print page */
.nl-print-page {background:#f6f1eb;color:#352b23;}
.nl-print-page .nl-print-sheet {max-width:920px;margin:2rem auto;padding:2.5rem 3rem;background:white;
  border:1px solid #e8dbcd;box-shadow:var(--nl-shadow-hover);border-radius:16px;}
.nl-print-page .nl-print-heading{color:#b84a18;font-weight:800;letter-spacing:.10em;}
.nl-print-page .nl-print-title{font-size:2rem;font-weight:800;color:#3f2d21;}
.nl-print-page .nl-print-section {border-bottom:1px solid #e9dcd0;padding-bottom:1.25rem;margin-bottom:1.25rem;}
.nl-print-page .nl-print-totals {background:#fff7eb;border:1px solid #efddca;border-radius:12px;padding:1rem;}
.nl-print-page .nl-print-totals strong {font-size:1.07rem;display:block;color:#8a3f17;}
.nl-print-page .table thead {background:#f7eade;color:#6d492e;}
@media print {
 @page {size:A4;margin:14mm;}
 html,body,.nl-print-page {background:white!important;color:#222!important;}
 .nl-print-page .nl-print-sheet {box-shadow:none!important;border:0!important;margin:0!important;max-width:none!important;padding:0!important;border-radius:0!important;}
 .nl-noprint,.nl-print-page .nl-noprint {display:none!important;}
 .nl-print-page .table {font-size:10pt;}
 .nl-print-page .nl-print-totals {break-inside:avoid;background:#fff!important;}
 .nl-print-page a {text-decoration:none;color:#222;}
}

/* Mobile and reduced-motion behavior */
#nlMobileNav {background:#fff9f1!important;}
#nlMobileNav .offcanvas-header{background:linear-gradient(105deg,#442a1c,#a44617)!important;color:#ffdfb7!important;}
#nlMobileNav .nl-primary-nav {position:static;}
#nlMobileNav .nav-link.bg-warning {background:linear-gradient(105deg,#b94616,#da6523)!important;color:white!important;}
@media (max-width:991.98px) {
 #nlSidebarCol {min-height:0;}
 #nlMainColumn {padding:1.1rem !important;}
 .nl-auth-page .nl-auth-hero {min-height:350px;border-radius:0!important;}
 .nl-auth-page .nl-auth-hero h2 {font-size:2.65rem;}
 .nl-auth-page .nl-auth-shell {border-radius:20px!important;}
 .nl-themed-page .nl-view-body h1 {font-size:clamp(1.7rem,6vw,2.3rem)!important;}
}
@media (max-width:575.98px) {
 .nl-app-header {padding:.8rem!important;min-height:68px!important;}
 .nl-app-header .navbar-brand {font-size:.87rem!important;padding:.45rem .7rem!important;}
 #nlMainColumn {padding:.8rem!important;}
 .nl-themed-page .card {border-radius:14px!important;}
 .nl-themed-page .card.p-4 {padding:1rem!important;}
 .nl-auth-page .nl-auth-container {padding:.6rem!important;}
 .nl-auth-page .nl-auth-hero {padding:1.4rem!important;min-height:300px;}
 .nl-auth-page .nl-auth-hero h2 {font-size:2.25rem;}
 .nl-auth-page .nl-auth-form {padding:1.35rem!important;}
 .nl-auth-page .nl-auth-form h1 {font-size:2rem;}
 .nl-table-toolbar {padding:.8rem!important;}
 .nl-table-search {max-width:none!important;width:100%;}
 .nl-print-page .nl-print-sheet{padding:1rem;margin:.5rem;}
}
@media (prefers-reduced-motion:reduce) {
 *,*::before,*::after {animation-duration:.01ms!important;transition-duration:.01ms!important;scroll-behavior:auto!important;}
}

/* =======================================================================
   2026 UI refinement — one authoritative stylesheet across 7 MVC2 modules
   Inspired by the approved orange / cream mockups: orderly grids, breathing
   room, useful menus, accessible form layouts and restrained motion.
   ======================================================================= */
:root {
  --nl-orange:#d95b18;
  --nl-orange-deep:#a93d0b;
  --nl-amber:#ffae4d;
  --nl-brown:#432514;
  --nl-ink:#312117;
  --nl-muted:#78685c;
  --nl-bg:#faf5ee;
  --nl-soft:#fff0df;
  --nl-line:#eedccb;
  --nl-shadow:0 10px 25px rgba(80,43,19,.065),0 2px 5px rgba(80,43,19,.035);
  --nl-shadow-hover:0 16px 35px rgba(95,51,24,.105);
}
html {scroll-padding-top:6rem;}
.nl-themed-page {background:
  radial-gradient(70% 30% at 92% 9%,rgba(255,159,74,.19),transparent 68%),
  radial-gradient(40% 28% at 7% 95%,rgba(250,191,136,.14),transparent 74%),
  linear-gradient(155deg,#fff9f2 0%,#f8f3ed 48%,#faf5ec 100%)!important;
  font-size:14px;line-height:1.48;
}
.nl-themed-page .nl-view-body {width:100%;min-width:0;}
.nl-themed-page .nl-view-body :is(main,section,article,.container,.container-fluid,.card,.card-body,.row,.col,.tab-content,.tab-pane) {min-width:0;}
.nl-themed-page .nl-view-body :is(h1,h2,h3,h4,h5,h6) {overflow-wrap:break-word;line-height:1.24;}
.nl-themed-page .nl-view-body h1 {font-size:clamp(1.75rem,2.5vw,2.42rem)!important;}
.nl-themed-page .nl-view-body h2:not(.h1) {line-height:1.28;}
.nl-themed-page .nl-view-body .text-muted {color:#7b6a60!important;}
.nl-themed-page .nl-view-body :is(.text-secondary,.text-muted) {font-size:inherit;}
.nl-themed-page .nl-view-body .small {font-size:.86em;}
.nl-themed-page .nl-view-body .nl-title-accent {color:var(--nl-orange)!important;}
.nl-themed-page .nl-view-body .eyebrow {letter-spacing:.095em;}
.nl-themed-page .nl-view-body .breadcrumb {--bs-breadcrumb-divider-color:#d18a53;gap:.14rem;flex-wrap:wrap;}
.nl-themed-page .nl-view-body .breadcrumb-item {font-size:.8rem;}
.nl-themed-page .nl-view-body > :is(.d-flex,.row,section,main) {max-width:100%;}
#nlMainColumn {position:relative;isolation:isolate;min-width:0;padding:clamp(1.1rem,2vw,2rem) clamp(1rem,2.3vw,2.6rem) 3rem!important;}
#nlMainColumn::before {content:"";position:absolute;z-index:-1;pointer-events:none;top:0;right:0;width:min(950px,100%);height:320px;
  background:radial-gradient(ellipse 55% 70% at 78% 10%,rgba(250,159,78,.11),transparent 82%),
             repeating-radial-gradient(ellipse at 110% -50%,transparent 0,transparent 64px,rgba(212,112,38,.045) 65px,transparent 66px);
}
.nl-themed-page .nl-view-body :is(.card,.nl-card,.nl-dash-panel) {background:rgba(255,253,249,.95)!important;border:1px solid #ead7c3!important;box-shadow:var(--nl-shadow)!important;border-radius:18px!important;max-width:100%;}
.nl-themed-page .nl-view-body .card.p-4 {padding:clamp(1rem,1.8vw,1.65rem)!important;}
.nl-themed-page .nl-view-body .card > :is(h2,h3,h4):first-child {margin-bottom:.9rem;}
.nl-themed-page .nl-view-body .card:where(:not(.nl-dash-kpi)) {transition:border-color .18s ease,box-shadow .18s ease;}
.nl-themed-page .nl-view-body .card:where(:not(.nl-dash-kpi)):hover {border-color:#e7c5a5!important;}
.nl-themed-page .nl-dash-kpi,.nl-themed-page .nl-kpi-card {border-top:1px solid #ead7c3!important;transition:box-shadow .2s ease,transform .2s ease,border-color .2s ease;}
.nl-themed-page .nl-dash-kpi:hover {transform:translateY(-3px);}
.nl-themed-page .nl-dash-kpi .nl-kpi-value,.nl-themed-page .nl-kpi-card .nl-kpi-value {overflow-wrap:anywhere;word-break:normal;font-variant-numeric:tabular-nums;}
.nl-themed-page .nl-dash-kpi .nl-kpi-label {min-height:2.3em;}
.nl-themed-page .nl-status-count-list {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:.65rem .8rem;margin:1.1rem 0 0;}
.nl-themed-page .nl-status-count-list li {display:flex;align-items:center;gap:.5rem;background:#fff7ed;padding:.7rem .75rem;border:1px solid #f2e2d0;border-radius:11px;min-width:0;font-size:.78rem;}
.nl-themed-page .nl-status-count-list li span:nth-child(2) {min-width:0;overflow-wrap:break-word;line-height:1.2;text-transform:capitalize;}
.nl-themed-page .nl-status-count-list li strong {margin-left:auto;font-variant-numeric:tabular-nums;font-size:.98rem;flex-shrink:0;}
.nl-themed-page .nl-status-dot {width:8px;height:8px;background:#d45d1d;border-radius:50%;flex:0 0 8px;}
.nl-themed-page .nl-status-count-list li:nth-child(3n) .nl-status-dot {background:#dfa248;}
.nl-themed-page .nl-status-count-list li:nth-child(4n) .nl-status-dot {background:#9f5c2f;}
.nl-themed-page .nl-dashboard-chart {height:245px;min-height:245px;max-height:245px;}
.nl-themed-page #nlDashboardStatusChart {width:100%!important;height:100%!important;max-height:100%!important;}

/* One polished shared topbar with actual role-authorized dropdown actions */
.nl-themed-page > .nl-app-header {min-height:76px;padding:12px clamp(1rem,2vw,2.5rem)!important;gap:clamp(.45rem,1vw,1rem)!important;
  background:linear-gradient(115deg,#3b2214 0%,#512718 36%,#89370f 68%,#bc4c0b 100%)!important;}
.nl-app-header::after {content:"";position:absolute;pointer-events:none;inset:0;z-index:-1;opacity:.13;background:
  repeating-radial-gradient(ellipse at 96% 145%,transparent 0,transparent 44px,#ffaf56 45px,transparent 46px);}
.nl-app-header .navbar-brand {white-space:nowrap;flex-shrink:0;}
.nl-app-header form[role="search"] {max-width:655px;min-width:240px;}
.nl-app-header form[role="search"] input {min-width:0!important;width:100%;}
.nl-app-header .nl-header-utilities {flex:0 0 auto;min-width:0;}
.nl-app-header .nl-header-action,.nl-app-header .nl-account-toggle {border:1px solid rgba(255,222,184,.36)!important;background:rgba(255,255,255,.055);min-height:42px;padding:.5rem .8rem;border-radius:13px;color:#fff2e6!important;box-shadow:none!important;font-weight:650;white-space:nowrap;}
.nl-app-header .nl-header-action:hover,.nl-app-header .nl-account-toggle:hover,.nl-app-header .show>.nl-account-toggle,.nl-app-header .show>.nl-header-action {background:rgba(255,255,255,.15);color:#fff!important;}
.nl-app-header .nl-account-identity {line-height:1.2;max-width:190px;min-width:0;}
.nl-app-header .nl-account-identity strong {font-size:.72rem;letter-spacing:.075em;}
.nl-app-header .nl-account-identity span {font-size:.8rem;max-width:190px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
.nl-app-header .nl-header-dropdown {min-width:245px;border-radius:16px!important;border:1px solid #ead0b9;padding:.45rem;background:#fffaf3;box-shadow:0 16px 35px rgba(61,31,14,.2)!important;max-height:min(70vh,500px);overflow:auto;z-index:1080;}
.nl-app-header .nl-header-dropdown .dropdown-header {font-size:.71rem;text-transform:uppercase;letter-spacing:.09em;color:#96613d;font-weight:750;padding:.65rem .8rem;}
.nl-app-header .nl-header-dropdown .dropdown-item {padding:.68rem .85rem;border-radius:9px;color:#4c3324;font-weight:600;}
.nl-app-header .nl-header-dropdown .dropdown-item:hover,.nl-app-header .nl-header-dropdown .dropdown-item:focus {background:#fff0dd;color:#a5410f;}
.nl-app-header .nl-header-dropdown form {margin:0;}
.nl-app-header .nl-header-dropdown .dropdown-divider {border-color:#f0e0d1;}
.nl-app-header .nl-header-dropdown .dropdown-item:focus-visible {outline:2px solid var(--nl-orange)!important;outline-offset:-2px;}
#nlSidebarCol {background:linear-gradient(170deg,#fff8f0 0%,#faebdd 100%)!important;border-right:1px solid #edd8c0!important;}
.nl-primary-nav .nav-link {padding:.85rem .95rem!important;min-height:51px;gap:.9rem!important;}
.nl-primary-nav .nav-link:hover {background:#fff1e2!important;}
.nl-primary-nav .nav-link.bg-warning,.nl-primary-nav .nav-link[aria-current="page"] {background:linear-gradient(115deg,#a83b0b 0%,#e76b17 100%)!important;color:#fff!important;}
.nl-primary-nav .nav-link img {max-width:21px;object-fit:contain;}

/* Headers / filters always line up; never force a narrow button to stretch tall */
.nl-themed-page :is(.section-head,.topbar,.toolbar,.nl-toolbar) {min-width:0;}
.nl-themed-page .section-head {display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:1rem 1.4rem!important;}
.nl-themed-page .section-head > :first-child {flex:1 1 275px;min-width:0;}
.nl-themed-page .section-head > :is(form,.nl-filter-form,.search) {flex:0 1 500px;min-width:min(100%,260px);}
.nl-themed-page .nl-filter-form,.nl-themed-page .section-head form.search {display:grid;grid-template-columns:repeat(2,minmax(0,1fr));align-items:end;gap:.65rem;}
.nl-themed-page .nl-filter-form > .form-control,.nl-themed-page .section-head form.search > .form-control {min-width:0;width:100%;}
.nl-themed-page .nl-filter-form > button,.nl-themed-page .section-head form.search > button {min-width:110px;max-width:max-content;min-height:42px;}
.nl-themed-page .nl-heading-actions {align-items:center;justify-content:flex-start;}
.nl-themed-page .nl-heading-actions .btn {min-height:42px;display:inline-flex;align-items:center;justify-content:center;}
.nl-themed-page :is(.form-control,.form-select) {max-width:100%;min-width:0;}
.nl-themed-page :is(.form-control,.form-select):not(textarea) {min-height:43px;}
.nl-themed-page label {max-width:100%;}
.nl-themed-page .form-label {font-size:.88rem;font-weight:650;}
.nl-themed-page .btn {display:inline-flex;align-items:center;justify-content:center;gap:.35rem;min-height:37px;line-height:1.3;text-align:center;vertical-align:middle;max-width:100%;}
.nl-themed-page button:not(.btn) {max-width:100%;}
.nl-themed-page .btn-warning.bg-gradient,.nl-themed-page .btn-primary.bg-gradient {background:linear-gradient(112deg,#b6400d,#e36d1a)!important;border-color:#be4910!important;color:white!important;}
.nl-themed-page .btn-warning.bg-gradient:hover {background:linear-gradient(110deg,#953006,#ce5410)!important;box-shadow:0 6px 16px rgba(181,65,15,.20)!important;}
.nl-themed-page .btn:active {transform:translateY(0);}
.nl-themed-page .btn-outline-danger {border-color:#e2bbb5;color:#a63a27;background:#fffafa;}
.nl-themed-page .btn-outline-danger:hover {background:#b83e30;color:#fff;}
.nl-themed-page .btn-link {text-decoration:none;}
.nl-themed-page .nl-module-toolbar {display:flex;align-items:center;gap:.9rem;justify-content:space-between;padding:.75rem 1rem!important;}
.nl-themed-page .nl-module-eyebrow {color:#96521f;text-transform:uppercase;letter-spacing:.11em;font-weight:750;font-size:.76rem;}
.nl-themed-page .nl-module-linkset {align-items:center;}
.nl-themed-page .nl-module-link {display:inline-flex;align-items:center;padding:.55rem .95rem;border-radius:9px;border:1px solid #ebd5be;color:#744429;text-decoration:none;font-size:.86rem;transition:background-color .15s,color .15s,border-color .15s;}
.nl-themed-page .nl-module-link:hover {background:#fff2e3;border-color:#dca775;}
.nl-themed-page .nl-module-link.active {background:linear-gradient(120deg,#b74410,#db691b);border-color:#c9561a;color:#fff;}
.nl-themed-page .subline,.nl-themed-page small.subline {display:block;margin-top:.3rem;line-height:1.4;color:#857060;font-size:.8rem;}
.nl-themed-page .nl-inline-form {display:flex;flex-wrap:wrap;align-items:flex-end;gap:.75rem;max-width:100%;min-width:0;}
.nl-themed-page .nl-inline-form > label {display:flex;flex-direction:column;gap:.35rem;margin:0;flex:0 1 280px;min-width:min(100%,170px);font-weight:650;color:#5a4232;}
.nl-themed-page .nl-inline-form > label > :is(input,select,textarea) {width:100%;}
.nl-themed-page .nl-inline-form > .btn {align-self:flex-end;min-height:43px;}
.nl-themed-page .nl-invoice-actions {justify-content:flex-start;margin-bottom:1rem;}
.nl-themed-page .nl-invoice-summary-grid {display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:.75rem;padding:0;background:transparent;border:0;}
.nl-themed-page .nl-invoice-summary-grid>div {min-width:0;border:1px solid #f0ddc8;background:#fff7ec;border-radius:13px;padding:1rem;display:flex;flex-direction:column;gap:.35rem;font-size:.83rem;text-transform:capitalize;color:#80614c;}
.nl-themed-page .nl-invoice-summary-grid strong {font-variant-numeric:tabular-nums;font-size:clamp(1.03rem,1.6vw,1.3rem);color:#57331e;overflow-wrap:anywhere;}

/* Table design: preserve every field without allowing values to overlap */
.nl-themed-page .table-responsive {overflow-x:auto;overscroll-behavior-inline:contain;border-radius:13px;scrollbar-color:#dab99e #fcf5ec;}
.nl-themed-page .table {margin:0!important;width:100%;table-layout:auto;border-collapse:separate;border-spacing:0;}
.nl-themed-page .table:has(thead th:nth-child(6)) {min-width:730px;}
.nl-themed-page .table:has(thead th:nth-child(8)) {min-width:950px;}
.nl-themed-page .table thead th {padding:.86rem .9rem!important;background:#faecdc!important;color:#653c25!important;white-space:nowrap;vertical-align:middle;font-weight:800!important;font-size:.72rem;}
.nl-themed-page .table tbody td {padding:.85rem .9rem!important;vertical-align:middle;border-color:#f1e6dc;max-width:380px;overflow-wrap:anywhere;word-break:normal;line-height:1.42;}
.nl-themed-page .table tbody td a {max-width:100%;}
.nl-themed-page .table tbody tr:nth-child(even)>* {--bs-table-bg-type:rgba(248,238,227,.38);}
.nl-themed-page .table tbody tr:hover>* {--bs-table-bg-state:rgba(246,223,204,.42);}
.nl-themed-page .table tbody td:has(> .btn) {white-space:normal;}
.nl-themed-page .table tbody td > :is(form,.d-flex,.btn-group) {max-width:100%;}
.nl-themed-page .table tbody td > form {display:flex;align-items:flex-end;flex-wrap:wrap;gap:.45rem;margin:0 0 .45rem;}
.nl-themed-page .table tbody td > form label {display:flex;flex-direction:column;gap:.3rem;min-width:min(100%,155px);flex:1 1 160px;margin:0;font-size:.78rem;}
.nl-themed-page .table tbody td > form .btn {align-self:flex-end;min-height:40px;}
.nl-themed-page .table tbody td > .nl-inline-form label {min-width:155px;flex:1 1 170px;}
.nl-themed-page .table tbody td > strong {font-weight:750;}
.nl-themed-page .table td .nl-copy-id {white-space:nowrap;margin:.2rem 0 0 .35rem!important;}
.nl-themed-page tr[hidden] {display:none!important;}
.nl-themed-page .nl-table-toolbar {margin:.9rem 0 1rem!important;gap:.7rem;padding:.78rem .85rem!important;border:1px solid #efdece!important;}
.nl-themed-page .nl-table-filters {min-width:0;display:flex;align-items:center;flex-wrap:wrap;gap:.55rem;}
.nl-themed-page .nl-table-filters .nl-table-search {flex:1 1 190px;min-width:min(100%,155px);max-width:330px;}
.nl-themed-page .nl-table-filters .nl-table-status {flex:0 1 180px;min-width:125px;max-width:220px;}
.nl-themed-page .nl-table-filters button {white-space:nowrap;}
.nl-themed-page .nl-table-records {margin-left:auto;text-align:right;white-space:normal;font-size:.78rem!important;}
.nl-themed-page .nl-table-pagination {display:flex;flex-wrap:wrap;gap:.65rem;justify-content:flex-end;padding:.7rem .8rem!important;}
.nl-themed-page .nl-page-size {min-width:100px;max-width:160px;}
.nl-themed-page .nl-sort-head {text-align:left;white-space:nowrap;}
.nl-themed-page .nl-table-empty {padding:1.5rem;border-radius:12px;}
.nl-themed-page .table .badge {white-space:normal;max-width:100%;display:inline-flex;align-items:center;overflow-wrap:anywhere;}
.nl-themed-page .table .badge:not(:last-child) {margin-right:.3rem;}
.nl-themed-page .table .btn-sm {font-size:.78rem;padding:.35rem .6rem;}
.nl-themed-page .table td .form-control {min-width:0;max-width:100%;}
.nl-themed-page .nl-stock-row-actions {position:relative;max-width:100%;}
.nl-themed-page .nl-stock-row-actions summary {display:inline-flex;align-items:center;gap:.5rem;list-style:none;cursor:pointer;border-radius:9px;background:#fff5eb;border:1px solid #debd9d;padding:.46rem .85rem;font-weight:700;color:#87400f;}
.nl-themed-page .nl-stock-row-actions summary::-webkit-details-marker {display:none;}
.nl-themed-page .nl-stock-row-actions summary::after {content:"\2304";font-size:1rem;}
.nl-themed-page .nl-stock-row-actions[open] {min-width:240px;padding:.55rem;border:1px solid #ecd4bb;border-radius:12px;background:#fff9f2;}
.nl-themed-page .nl-stock-row-actions[open] summary {margin-bottom:.8rem;}
.nl-themed-page .nl-stock-row-actions .nl-inline-edit {display:grid;grid-template-columns:minmax(0,1fr) auto;gap:.5rem;margin:.45rem 0;min-width:0;}
.nl-themed-page .nl-stock-row-actions .nl-inline-edit label {display:block;min-width:0;font-size:.77rem;}
.nl-themed-page .nl-stock-row-actions .nl-inline-edit input {width:100%;}
.nl-themed-page .nl-stock-row-actions .nl-inline-edit .btn {align-self:end;}
.nl-themed-page .nl-stock-row-actions>form:last-child {margin-top:.65rem;}
.nl-themed-page .nl-stock-workspace .summary-callout .nl-inline-form {margin-top:.8rem;}

/* JSP-compatible payment review overlay; appended to body to avoid transformed stacking contexts */
.nl-themed-page .payment-dialog[hidden] {display:none!important;}
.nl-themed-page .payment-dialog:not([hidden]) {display:grid;place-items:center;position:fixed;inset:0;margin:0;padding:18px;background:rgba(32,20,12,.64);backdrop-filter:blur(3px);z-index:2000;overflow:auto;}
.nl-themed-page .payment-dialog .payment-dialog-surface {width:min(570px,100%);max-height:calc(100dvh - 36px);overflow:auto;padding:clamp(1.2rem,3vw,2rem);border:1px solid #e8cbb0;border-radius:21px;background:#fffaf4;color:#3b281d;box-shadow:0 32px 100px rgba(45,22,9,.33);animation:nl-dialog-in .2s ease both;}
body.nl-payment-review-open {overflow:hidden;}
.nl-themed-page .payment-dialog .payment-dialog-header {display:flex;gap:1rem;align-items:center;margin-bottom:1.15rem;}
.nl-themed-page .payment-dialog .payment-dialog-icon {width:54px;height:54px;flex:0 0 54px;display:grid;place-items:center;background:#ffebd5;border-radius:16px;color:#b54b12;font-size:1.6rem;font-weight:800;}
.nl-themed-page .payment-dialog .payment-dialog-header h2 {margin:0 0 .3rem!important;color:#37251b;}
.nl-themed-page .payment-dialog .payment-dialog-header p {margin:0;color:#756153;}
.nl-themed-page .payment-dialog .payment-amount-box {display:flex;justify-content:space-between;gap:1rem;align-items:center;border-radius:13px;background:#fff0dc;border:1px solid #ead2b7;padding:.95rem 1rem;margin-bottom:1rem;}
.nl-themed-page .payment-dialog .payment-amount-box strong {font-size:1.45rem;font-variant-numeric:tabular-nums;color:#a93d0b;}
.nl-themed-page .payment-dialog .payment-review {display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1.2fr);gap:.55rem 1rem;margin-bottom:1.2rem;}
.nl-themed-page .payment-dialog .payment-review dt {font-size:.85rem;color:#7e6b59;font-weight:600;}
.nl-themed-page .payment-dialog .payment-review dd {margin:0;font-weight:750;text-align:right;overflow-wrap:anywhere;}
.nl-themed-page .payment-dialog .payment-warning {background:#fff4df;border:1px solid #ecd2a7;padding:1rem;border-radius:12px;font-size:.87rem;margin-bottom:1rem;}
.nl-themed-page .payment-dialog .payment-warning p {margin:.25rem 0 0;line-height:1.55;}
.nl-themed-page .payment-dialog .payment-actions {display:flex;gap:.65rem;justify-content:flex-end;flex-wrap:wrap;}
.nl-themed-page .payment-dialog .payment-actions button {border-radius:10px;padding:.7rem 1.1rem;min-height:42px;border:1px solid #ddc4ae;font-weight:700;}
.nl-themed-page .payment-dialog .payment-cancel {color:#66402d;background:#fffdfa;}
.nl-themed-page .payment-dialog .payment-confirm {background:linear-gradient(115deg,#ab3f0d,#e66c1c);color:white;border-color:#bd5016;}
.nl-themed-page .payment-dialog .payment-confirm:hover {filter:brightness(.95);}
.nl-themed-page #recordPaymentForm {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));align-items:end;gap:.85rem 1rem;}
.nl-themed-page #recordPaymentForm > label {min-width:0;flex:none;display:flex;flex-direction:column;gap:.34rem;font-weight:650;font-size:.85rem;}
.nl-themed-page #recordPaymentForm > label > :is(input,select) {width:100%;}
.nl-themed-page #recordPaymentForm > button {grid-column:1/-1;justify-self:start;min-height:46px;}
.nl-themed-page .payment-card .payment-balance {display:flex;flex-wrap:wrap;align-items:center;gap:.4rem .8rem;padding:.75rem 1rem;background:#fff4e8;border:1px solid #f0dcc7;border-radius:11px;margin-bottom:1.2rem;}
.nl-themed-page .payment-card .payment-balance strong {color:#ad4010;font-size:1.2rem;font-variant-numeric:tabular-nums;}
.nl-themed-page .payment-card .payment-subtitle {max-width:850px;color:#745b47;}

/* Contextual tools / timeline / collapsible sections */
.nl-themed-page details:not(.nl-stock-row-actions) > summary {cursor:pointer;outline-offset:4px;}
.nl-themed-page details[open]:not(.nl-stock-row-actions) > summary {color:#a94410;}
.nl-themed-page .nl-claims-content .nl-kpi-card {border-top:2px solid #e49a59!important;}
.nl-themed-page .nl-claims-content .nl-kpi-card .nl-kpi-label {font-weight:650;}
.nl-themed-page .nl-claims-content :is(.breadcrumb,.nl-stepper) {min-width:0;}
.nl-themed-page .nl-claims-content .nl-stepper {align-items:center;gap:.7rem;}
.nl-themed-page .nl-claims-content .nl-step {display:inline-flex;align-items:center;gap:.35rem;line-height:1.3;min-height:40px;}
.nl-themed-page .nl-claims-content .nl-step.completed {background:#e7f5e7!important;color:#326748;border:1px solid #b6d7bf!important;}
.nl-themed-page .nl-claims-content .nl-step.active {background:#dc5d18!important;color:white!important;}
.nl-themed-page .nl-claims-content .row.g-3 > [class*="col-"] {min-width:0;}
.nl-themed-page .nl-claims-content .card .row > [class*="col-"] {min-width:0;}
.nl-themed-page .nl-claims-content .card .btn {white-space:normal;}
.nl-themed-page .nl-claims-content .card .table-responsive {margin-top:.6rem;}
.nl-themed-page .nl-tabs {display:flex;align-items:center;flex-wrap:wrap;min-width:0;}
.nl-themed-page .nl-tabs .nav-link {white-space:normal;}
.nl-themed-page .nl-booking-steps {display:flex;gap:.55rem!important;align-items:center;}
.nl-themed-page .nl-booking-step {white-space:normal;}
.nl-themed-page .nl-view-body input::placeholder {color:#9b8576;opacity:1;}
.nl-themed-page .nl-view-body button:focus-visible,.nl-themed-page .nl-view-body a:focus-visible {outline:3px solid #d5651b!important;outline-offset:3px;}
.nl-themed-page footer {margin-top:2.4rem!important;}

/* Motion is decorative and never changes layout or hides content indefinitely */
@keyframes nl-page-in {from{opacity:.75;transform:translateY(7px)}to{opacity:1;transform:translateY(0)}}
@keyframes nl-dialog-in {from{opacity:0;transform:translate(-50%,-48%) scale(.985)}to{opacity:1;transform:translate(-50%,-50%) scale(1)}}
@keyframes nl-menu-in {from{opacity:0;transform:translateY(-6px)}to{opacity:1;transform:translateY(0)}}
@media (prefers-reduced-motion:no-preference) {
 .nl-themed-page .nl-view-body {animation:nl-page-in .38s ease-out both;}
 .nl-themed-page .nl-app-header .dropdown-menu.show {animation:nl-menu-in .14s ease-out both;}
 .nl-themed-page .nl-view-body .card:focus-within {transition:box-shadow .18s ease;box-shadow:0 10px 28px rgba(179,77,22,.13)!important;}
}
@media(max-width:1399.98px) {
 .nl-themed-page .nl-status-count-list {grid-template-columns:repeat(2,minmax(0,1fr));}
 .nl-themed-page #recordPaymentForm {grid-template-columns:repeat(2,minmax(0,1fr));}
 .nl-themed-page .nl-invoice-summary-grid {grid-template-columns:repeat(3,minmax(0,1fr));}
 .nl-app-header .nl-account-identity {max-width:135px;}
}
@media(max-width:1199.98px) {
 .nl-app-header .nl-header-action {font-size:0;min-width:41px;}
 .nl-app-header .nl-header-action::before {content:"+";font-size:1.35rem;line-height:1;}
 .nl-app-header .nl-header-action::after {font-size:.8rem;}
 .nl-themed-page .nl-view-body .card.p-4 {padding:1.1rem!important;}
 .nl-themed-page .nl-invoice-summary-grid {grid-template-columns:repeat(2,minmax(0,1fr));}
}
@media(max-width:991.98px) {
 .nl-themed-page > .nl-app-header {min-height:70px;}
 #nlMainColumn {padding:1.25rem 1rem 2rem!important;}
 .nl-themed-page .nl-view-body .table:has(thead th:nth-child(6)) {min-width:740px;}
 .nl-themed-page .nl-view-body .section-head form.search {flex:1 1 100%;}
 .nl-themed-page .nl-claims-content .row.g-3>.col-6 {min-width:0;}
}
@media(max-width:767.98px) {
 .nl-app-header .nl-quick-dropdown {display:none;}
 .nl-app-header .nl-account-toggle {padding:.5rem .55rem;}
 .nl-app-header .nl-account-toggle img {width:22px;}
 .nl-themed-page .nl-status-count-list {grid-template-columns:repeat(2,minmax(0,1fr));}
 .nl-themed-page .nl-filter-form,.nl-themed-page .section-head form.search {grid-template-columns:1fr 1fr;}
 .nl-themed-page .nl-table-records {flex-basis:100%;text-align:left;}
 .nl-themed-page .nl-invoice-summary-grid {grid-template-columns:repeat(2,minmax(0,1fr));}
 .nl-themed-page .nl-module-toolbar {align-items:flex-start;}
 .nl-themed-page .nl-dash-panel {min-height:0;}
 .nl-themed-page .nl-dashboard-chart {height:200px;min-height:200px;max-height:200px;}
}
@media(max-width:575.98px) {
 #nlMainColumn {padding:.8rem .7rem 1.5rem!important;}
 .nl-themed-page .nl-view-body .card.p-4,.nl-themed-page .nl-view-body .card.p-3 {padding:1rem!important;}
 .nl-themed-page .nl-view-body h1 {font-size:1.7rem!important;}
 .nl-themed-page .nl-status-count-list {grid-template-columns:1fr 1fr;gap:.4rem;}
 .nl-themed-page .nl-status-count-list li {padding:.55rem .6rem;font-size:.74rem;}
 .nl-themed-page .nl-filter-form,.nl-themed-page .section-head form.search {grid-template-columns:1fr;}
 .nl-themed-page .nl-table-filters .nl-table-search {flex:1 1 100%;max-width:100%;}
 .nl-themed-page .nl-table-filters .nl-table-status {flex:1 1 150px;max-width:100%;}
 .nl-themed-page .nl-table-pagination {justify-content:flex-start!important;}
 .nl-themed-page .nl-invoice-summary-grid {grid-template-columns:1fr 1fr;}
 .nl-themed-page .nl-invoice-summary-grid>div {padding:.8rem;}
 .nl-themed-page #recordPaymentForm {grid-template-columns:1fr;}
 .nl-themed-page #recordPaymentForm > button {width:100%;}
 .nl-themed-page .payment-dialog .payment-review {grid-template-columns:1fr 1.1fr;}
 .nl-themed-page .nl-inline-form > label {flex:1 1 100%;}
 .nl-themed-page .nl-stock-row-actions[open] {min-width:220px;}
 .nl-themed-page .nl-module-linkset {gap:.35rem!important;}
 .nl-themed-page .nl-module-link {padding:.42rem .55rem;font-size:.8rem;}
}
@media (prefers-reduced-motion:reduce) {
 .nl-themed-page .nl-view-body,.nl-themed-page .payment-dialog .payment-dialog-surface {animation:none!important;}
}


/* Boardroom presentation experience: strong but purposeful transitions in Modules 1, 3–7 */
body[data-nl-enhanced="true"] {scroll-behavior:smooth;}
body[data-nl-enhanced="true"] .nl-view-body > *,body[data-nl-enhanced="true"] .nl-view-body .card,body[data-nl-enhanced="true"] .nl-view-body .summary-card,body[data-nl-enhanced="true"] .nl-view-body .nl-card {animation: nlSceneEnter .62s cubic-bezier(.16,1,.3,1) both;}
body[data-nl-enhanced="true"] .nl-view-body .card:nth-of-type(2),body[data-nl-enhanced="true"] .nl-view-body .summary-card:nth-of-type(2) {animation-delay:.12s;}
body[data-nl-enhanced="true"] .nl-view-body .card:nth-of-type(3),body[data-nl-enhanced="true"] .nl-view-body .summary-card:nth-of-type(3) {animation-delay:.23s;}
body[data-nl-enhanced="true"] .nl-view-body .card:hover,body[data-nl-enhanced="true"] .nl-view-body .summary-card:hover {transform:translateY(-7px) scale(1.006);box-shadow:0 28px 60px rgba(95,63,23,.16)!important;transition:transform .32s cubic-bezier(.17,.67,.28,1.22),box-shadow .32s ease;}
body[data-nl-enhanced="true"] .nl-view-body .card {transition:transform .32s ease,box-shadow .32s ease;}
body[data-nl-enhanced="true"] .nl-view-body .btn-warning,body[data-nl-enhanced="true"] .nl-view-body .btn-primary {position:relative;overflow:hidden;transition:transform .25s ease,filter .25s ease,box-shadow .25s ease;}
body[data-nl-enhanced="true"] .nl-view-body .btn-warning:hover,body[data-nl-enhanced="true"] .nl-view-body .btn-primary:hover {transform:translateY(-2px) scale(1.03);box-shadow:0 11px 24px rgba(229,125,29,.27);filter:saturate(1.12);}
body[data-nl-enhanced="true"] .nl-view-body .table tbody tr {animation:nlRowRise .45s cubic-bezier(.16,1,.3,1) both;transition:background .25s ease,transform .25s ease;}
body[data-nl-enhanced="true"] .nl-view-body .table tbody tr:hover {transform:translateX(4px);}
body[data-nl-enhanced="true"] .nl-view-body .form-control:focus,body[data-nl-enhanced="true"] .nl-view-body .form-select:focus {border-color:#ee921e;box-shadow:0 0 0 .24rem rgba(239,155,37,.20);transform:translateY(-1px);transition:all .24s ease;}
body[data-nl-enhanced="true"] .nl-view-body h1,body[data-nl-enhanced="true"] .nl-view-body h2,body[data-nl-enhanced="true"] .nl-view-body h3 {letter-spacing:-.035em;}
body[data-nl-enhanced="true"] .nl-live-toolbar {background:linear-gradient(110deg,#fffbf4,#fff1d8);border:1px solid #f6d6a7;border-radius:1.2rem;padding:.85rem;display:flex;align-items:center;gap:.8rem;flex-wrap:wrap;margin:0 0 1rem;}
body[data-nl-enhanced="true"] .nl-live-toolbar input {width:min(100%,310px);}
body[data-nl-enhanced="true"] .nl-progress-track {position:fixed;top:0;left:0;height:4px;background:linear-gradient(90deg,#f5a524,#dc6b11);box-shadow:0 2px 12px #eb921c66;z-index:2500;width:0;transition:width .13s linear;pointer-events:none;}
body[data-nl-enhanced="true"] .nl-motion-reveal {opacity:0;transform:translateY(36px) scale(.975);}
body[data-nl-enhanced="true"] .nl-motion-reveal.nl-inview {opacity:1;transform:translateY(0) scale(1);transition:opacity .72s ease,transform .72s cubic-bezier(.12,.84,.24,1);}
body[data-nl-enhanced="true"] .nl-empty-row {text-align:center;padding:1.2rem;color:#775b39;}
@keyframes nlSceneEnter {from{opacity:0;transform:translateY(28px) scale(.972);filter:blur(5px);}to{opacity:1;transform:translateY(0) scale(1);filter:blur(0);}}
@keyframes nlRowRise {from{opacity:0;transform:translateX(-12px);}to{opacity:1;transform:translateX(0);}}
@keyframes nlPulseGlow {0%,100%{box-shadow:0 0 0 0 rgba(237,146,31,.20);}50%{box-shadow:0 0 0 8px rgba(237,146,31,0);}}
@media(prefers-reduced-motion:reduce){body[data-nl-enhanced="true"] *,body[data-nl-enhanced="true"] *::before,body[data-nl-enhanced="true"] *::after{animation-duration:.01ms!important;transition-duration:.01ms!important;scroll-behavior:auto!important;}body[data-nl-enhanced="true"] .nl-motion-reveal{opacity:1!important;transform:none!important;}}


/* N-LOGISTIC · unified boardroom UI — declared inside _theme.jsp, never an independent asset. */
:root{--nl-ui-deep:#321d14;--nl-ui-rust:#d6570b;--nl-ui-soft:#fff6ec;--nl-ui-surface:#fffdfa;--nl-ui-shadow:0 10px 30px rgba(76,39,18,.065),0 2px 8px rgba(76,39,18,.035);--nl-ui-h:76px;--nl-ui-side:264px}
body.nl-themed-page{background:radial-gradient(ellipse 62% 38% at 103% -10%,rgba(250,160,77,.20),transparent 70%),linear-gradient(140deg,#fcf8f4 10%,#f8f3ee 65%,#fff7ef) !important;color:#32231d;min-width:320px}
body.nl-themed-page>.nl-app-header{position:sticky;top:0;min-height:var(--nl-ui-h)!important;padding:12px clamp(12px,1.65vw,32px)!important;background:linear-gradient(107deg,#321d15 0%,#5d2a18 34%,#973b16 75%,#d45e13 115%)!important;background-size:160% 160%!important;animation:nlHeaderMove 12s ease-in-out infinite;box-shadow:0 5px 26px rgba(65,31,16,.20)!important;z-index:1040}
@keyframes nlHeaderMove{0%,100%{background-position:0 0}50%{background-position:85% 55%}}
.nl-app-header form[role="search"]{width:min(560px,42vw);flex:1 1 300px;border-radius:18px!important;background:rgba(255,255,255,.10)!important;border:1px solid rgba(255,236,215,.20)!important;box-shadow:inset 0 1px 1px rgba(255,255,255,.07)!important}
.nl-app-header form[role="search"] input{background:transparent!important;color:white!important;box-shadow:none!important;min-width:0}.nl-app-header form[role="search"] input::placeholder{color:#f6ded0!important}.nl-app-header form[role="search"]:focus-within{outline:2px solid rgba(255,204,140,.57);outline-offset:3px}.nl-app-header .navbar-brand{font-size:1.0rem!important;letter-spacing:.08em!important;min-height:43px;border-radius:100px!important;padding:.5rem .85rem!important;white-space:nowrap}
.nl-app-header .nl-header-utilities{gap:9px!important}.nl-app-header .nl-header-action,.nl-app-header .nl-account-toggle{background:rgba(255,255,255,.08)!important;min-height:43px;border-radius:13px!important;transition:background .2s ease,transform .2s ease,box-shadow .2s ease}.nl-app-header .nl-header-action:hover,.nl-app-header .nl-account-toggle:hover{background:rgba(255,255,255,.18)!important;transform:translateY(-2px);box-shadow:0 8px 22px #28120a30!important}.nl-app-header #nlMenuToggle{min-width:42px;height:43px;display:grid;place-items:center;border-radius:13px!important}
/* Both page architectures share precisely the same sidebar content. */
#nlSidebarCol{width:var(--nl-ui-side)!important;flex:0 0 var(--nl-ui-side)!important;min-width:var(--nl-ui-side);background:linear-gradient(180deg,#fffaf5 0%,#fbf0e5 100%)!important;border-color:#e8d7c7!important;box-shadow:inset -1px 0 0 #ebdbcc,3px 0 24px #71391608!important}
#nlMainColumn{width:calc(100% - var(--nl-ui-side))!important;flex:0 0 calc(100% - var(--nl-ui-side))!important;max-width:none!important;min-width:0!important;padding:clamp(20px,2.5vw,45px)!important;padding-top:clamp(22px,2.5vw,38px)!important}
.nl-universal-module2 .app-shell{display:grid;grid-template-columns:var(--nl-ui-side) minmax(0,1fr);min-height:calc(100vh - var(--nl-ui-h));align-items:stretch}
.nl-universal-module2 .app-shell>.nl-universal-sidebar{position:sticky;top:var(--nl-ui-h);align-self:start;width:var(--nl-ui-side);height:calc(100vh - var(--nl-ui-h));min-height:0;padding:0!important;margin:0;background:linear-gradient(180deg,#fffaf5 0%,#fbf0e5 100%)!important;border-right:1px solid #e8d7c7;box-shadow:3px 0 24px #71391608;overflow-x:hidden;overflow-y:auto;z-index:29;display:block;scrollbar-width:thin;transform:none}
.nl-universal-module2 .app-shell .main-area{min-width:0;width:100%;padding:clamp(20px,2.5vw,45px)!important;padding-top:clamp(22px,2.5vw,38px)!important;background:transparent!important}
.nl-universal-module2 .app-shell .content-wrap{max-width:1640px!important;margin:0 auto;width:100%;min-width:0}
.nl-universal-navigation{position:sticky;top:var(--nl-ui-h);height:calc(100vh - var(--nl-ui-h));min-height:0;overflow:auto;display:flex!important;flex-direction:column!important;gap:0!important;padding:20px 12px 18px!important;background:transparent;scrollbar-width:thin}
.nl-universal-module2 .nl-universal-navigation,.offcanvas .nl-universal-navigation{height:auto!important;max-height:none!important;position:static!important;overflow:visible}
.nl-side-heading{display:flex;align-items:center;gap:14px;padding:12px 12px 16px;margin-bottom:12px}.nl-side-heading-caption{font-weight:900;letter-spacing:.15em;font-size:.63rem;color:#aa673f}.nl-side-heading-line{height:1px;background:#ebd7c5;flex:1}
.nl-side-groups{display:grid;gap:5px;align-content:start}.nl-side-group{border-radius:15px;transition:background .2s ease}.nl-side-group.is-selected{background:#fff0e2a8}.nl-side-parent{display:flex;align-items:stretch;min-height:46px;position:relative}.nl-side-main{min-width:0;flex:1;display:flex;align-items:center;gap:12px;padding:10px 12px;text-decoration:none!important;line-height:1.2;color:#5f493b!important;font-size:.87rem;font-weight:690;border:1px solid transparent;border-radius:12px;transition:background .19s ease,transform .2s ease,color .19s ease,box-shadow .2s ease}.nl-side-main:hover{background:#fff1e6;color:#a83b09!important;transform:translateX(3px)}.nl-side-main.is-current{background:linear-gradient(115deg,#c4440c 0%,#ea670e 100%)!important;color:#fff!important;box-shadow:0 6px 17px rgba(175,67,15,.19);font-weight:770}.nl-side-main.is-current:hover{transform:translateX(1px);box-shadow:0 10px 20px rgba(175,67,15,.25)}.nl-side-icon{display:grid;place-items:center;font-family:'Segoe UI Symbol','Segoe UI',sans-serif;flex:none;width:27px;height:27px;border-radius:9px;background:#fff0e1;color:#a34716;font-weight:900;font-size:1.04rem}.nl-side-main.is-current .nl-side-icon{color:#fff;background:rgba(255,255,255,.17)}.nl-side-name{min-width:0;white-space:normal;overflow-wrap:anywhere}
.nl-side-toggle{flex:none;width:32px;align-self:center;height:36px;margin-right:3px;border:0;background:transparent;color:#865c44;border-radius:9px;font-size:1.25rem;line-height:1;cursor:pointer;transition:transform .2s,background .2s}.nl-side-toggle:hover{background:#fff2e6;color:#b54613}.nl-side-toggle[aria-expanded="true"] span{display:inline-block;transform:rotate(180deg)}.nl-side-group.is-selected .nl-side-toggle{color:#c35b1f}.nl-side-main.is-current+.nl-side-toggle{color:#a34818}
.nl-side-children{display:grid;gap:2px;padding:5px 10px 10px 36px;animation:nlSubmenuIn .29s cubic-bezier(.2,.85,.25,1) both}.nl-side-children[hidden]{display:none!important}@keyframes nlSubmenuIn{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
.nl-side-child{display:flex;align-items:center;gap:10px;min-height:34px;padding:7px 9px;color:#806453!important;font-size:.78rem;text-decoration:none!important;border-radius:8px;font-weight:590;transition:background .16s,color .16s,transform .16s}.nl-side-child:hover{background:#fff9f2!important;color:#b54917!important;transform:translateX(3px)}.nl-side-child.is-current{color:#ad4010!important;background:#ffe4cf;font-weight:750}.nl-child-marker{flex:none;width:6px;height:6px;border:1.5px solid #cc9a76;border-radius:50%;transition:background .2s}.nl-side-child.is-current .nl-child-marker{background:#c95413;border-color:#c95413}
.nl-side-footer{margin-top:auto;padding:22px 6px 0}.nl-side-signed{display:flex;gap:8px;align-items:center;margin:0 5px 13px;font-size:.68rem;color:#95745e;letter-spacing:.015em}.nl-online-pulse{width:7px;height:7px;border-radius:50%;background:#2da175;box-shadow:0 0 0 4px #2da17522;animation:nlOnline 2.3s infinite}@keyframes nlOnline{50%{box-shadow:0 0 0 8px #2da17505}}.nl-side-logout{display:block;width:100%;text-align:left;border:1px solid #e5d2be;background:#fff9f3;border-radius:12px;padding:13px 14px;color:#6b402f;font-weight:700;font-size:.85rem;transition:background .2s,transform .2s}.nl-side-logout:hover{background:#f9e0c8;transform:translateY(-2px)}
/* Harmonize card geometry and structured data without changing application logic. */
.nl-themed-page .nl-view-body,.nl-universal-module2 .content-wrap{width:100%;min-width:0}
.nl-themed-page .nl-view-body :is(.card,.nl-dash-panel,.nl-kpi-card),.nl-universal-module2 .content-wrap :is(.card,.stat,.detail-box){border:1px solid #ead7c5!important;background:linear-gradient(160deg,#fffdfa 0%,#fff9f3 100%)!important;border-radius:19px!important;box-shadow:var(--nl-ui-shadow)!important;min-width:0;transition:transform .27s cubic-bezier(.18,.84,.3,1),box-shadow .27s,border-color .27s}
.nl-themed-page .nl-view-body .card:hover,.nl-universal-module2 .content-wrap .card:hover,.nl-universal-module2 .content-wrap .stat:hover{border-color:#efb989!important;box-shadow:0 19px 37px rgba(80,36,15,.11)!important;transform:translateY(-4px)}
.nl-themed-page .nl-view-body h1,.nl-universal-module2 .content-wrap .page-heading h1{font-size:clamp(1.85rem,2.8vw,2.75rem)!important;line-height:1.12;letter-spacing:-.045em!important;font-weight:850!important}
.nl-themed-page .nl-view-body h2{letter-spacing:-.027em}
.nl-themed-page .nl-view-body .btn,.nl-universal-module2 .content-wrap .btn{border-radius:12px;min-height:37px;display:inline-flex;align-items:center;justify-content:center;gap:5px;transition:transform .20s cubic-bezier(.2,.8,.2,1),box-shadow .2s,background .2s;max-width:100%}.nl-themed-page .nl-view-body .btn:hover:not(:disabled),.nl-universal-module2 .content-wrap .btn:hover:not(:disabled){transform:translateY(-3px);box-shadow:0 7px 17px #a94d1826}.nl-themed-page .nl-view-body .btn:active:not(:disabled){transform:scale(.97)}
.nl-themed-page .nl-view-body .form-control,.nl-themed-page .nl-view-body .form-select{border:1px solid #e4cdbc;background:#fffdfa;border-radius:11px;min-height:40px;color:#392a22;box-shadow:none;max-width:100%}.nl-themed-page .nl-view-body .form-control:focus,.nl-themed-page .nl-view-body .form-select:focus{border-color:#cc702d;box-shadow:0 0 0 4px #e97b2830}
.nl-themed-page .nl-view-body .table-responsive{max-width:100%;overflow-x:auto;border:1px solid #ebd5c3;border-radius:16px!important;background:#fffdfa;box-shadow:0 5px 17px #5c341009;scrollbar-width:thin}.nl-themed-page .nl-view-body .table{margin:0;table-layout:auto;min-width:820px;border-collapse:separate;border-spacing:0;line-height:1.35}.nl-themed-page .nl-view-body .table>:not(caption)>*>*{border-color:#f0e5da;vertical-align:middle;padding:13px 12px}.nl-themed-page .nl-view-body .table thead th{background:#fbeddc!important;color:#65412d!important;font-size:.72rem;text-transform:uppercase;letter-spacing:.045em;font-weight:850;white-space:normal;vertical-align:middle;line-height:1.35}.nl-themed-page .nl-view-body .table tbody tr:nth-child(even){background:#fff9f4}.nl-themed-page .nl-view-body .table tbody td{font-size:.86rem;max-width:330px}.nl-themed-page .nl-view-body .table tbody tr{transition:background .2s ease}.nl-themed-page .nl-view-body .table tbody tr:hover{background:#fff0df!important}.nl-themed-page .nl-view-body .table tbody td a:not(.btn){overflow-wrap:anywhere}.nl-themed-page .nl-view-body .table .badge{max-width:100%;font-size:.72rem;line-height:1.4;white-space:normal;padding:.35em .65em;border-radius:100px!important}.nl-themed-page .nl-view-body .table td.text-end,.nl-themed-page .nl-view-body .table th.text-end{text-align:right!important;white-space:nowrap;font-variant-numeric:tabular-nums}.nl-themed-page .nl-view-body .table td:last-child{min-width:120px}.nl-themed-page .nl-view-body .table td:last-child .btn{font-size:.75rem;padding:.38rem .65rem;margin:.1rem;white-space:nowrap;max-width:100%}
.nl-themed-page .nl-view-body #claimTable{min-width:1020px}.nl-themed-page .nl-view-body #claimTable td:first-child{max-width:180px}.nl-themed-page .nl-view-body #claimTable th:nth-child(4),.nl-themed-page .nl-view-body #claimTable th:nth-child(5){min-width:130px}.nl-themed-page .nl-view-body #claimTable th:last-child{min-width:164px}.nl-themed-page .nl-view-body #claimTable td:last-child .btn{display:inline-flex;margin:3px 0;min-width:110px;justify-content:center}.nl-themed-page .nl-view-body #claimTable td .badge.font-monospace{max-width:160px;overflow-wrap:anywhere;font-size:.67rem}
.nl-themed-page .nl-view-body .nl-table-toolbar{padding:12px 14px!important;gap:12px!important;align-items:center;flex-wrap:wrap;background:#fff7ec;border:1px solid #efdbc7;border-radius:14px;margin-bottom:14px}.nl-table-search{min-width:170px;max-width:280px}.nl-table-toolbar .nl-table-filters{display:flex;gap:8px;flex-wrap:wrap;align-items:center;flex:1 1 520px}.nl-table-toolbar .nl-table-records{margin-left:auto;font-size:.7rem!important}.nl-table-toolbar :is(.form-control,.form-select){font-size:.8rem!important;min-height:38px}.nl-table-toolbar .btn{font-size:.75rem!important;min-height:36px!important}.nl-table-pagination{flex-wrap:wrap;padding:5px 3px}.nl-sort-head{text-align:left!important;line-height:1.3!important;font-size:inherit!important;display:inline-flex!important;align-items:center;white-space:normal!important;max-width:100%}
.nl-copy-id{display:inline-grid!important;place-items:center!important;width:27px!important;height:26px!important;min-width:0!important;min-height:0!important;margin-left:7px!important;padding:0!important;font-size:.8rem!important;border-radius:7px!important;vertical-align:middle!important;opacity:.15;transition:opacity .2s,background .2s;line-height:1}.nl-copy-id:hover,.nl-copy-id:focus-visible,tr:hover .nl-copy-id{opacity:1!important;background:#ffe7d1}.nl-kpi-card{position:relative;overflow:hidden}.nl-kpi-card:before{content:"";position:absolute;top:0;left:0;width:100%;height:4px;background:linear-gradient(90deg,#e87726,#ffc28c);transform-origin:left;animation:nlMetricLine .8s ease both}@keyframes nlMetricLine{from{transform:scaleX(0)}to{transform:scaleX(1)}}
.nl-themed-page .nl-view-body .nl-tabs,.nl-themed-page .nl-view-body .nl-module-toolbar{background:rgba(255,248,240,.83)!important;border:1px solid #ead8c5!important;border-radius:16px;padding:10px!important;box-shadow:0 4px 17px #6536190b}.nl-themed-page .nl-view-body .nl-tabs .nav-link{border-radius:10px!important;transition:transform .18s,background .18s}.nl-themed-page .nl-view-body .nl-tabs .nav-link:hover{transform:translateY(-2px);background:#ffe6cd}.nl-themed-page .nl-view-body .alert{border-radius:13px;border-left-width:4px}
/* Animated information entrance with explicit reduced-motion accessibility. */
@keyframes nlBoardroomArrival{from{opacity:0;transform:translateY(28px) scale(.981);filter:blur(4px)}to{opacity:1;transform:translateY(0) scale(1);filter:blur(0)}}
.nl-themed-page .nl-view-body>section,.nl-themed-page .nl-view-body>.row,.nl-themed-page .nl-view-body>main,.nl-themed-page .nl-view-body>.card,.nl-universal-module2 .content-wrap>.page-heading{animation:nlBoardroomArrival .66s cubic-bezier(.17,.76,.26,1) both}.nl-themed-page .nl-view-body>.row:nth-of-type(2),.nl-themed-page .nl-view-body>section:nth-of-type(2){animation-delay:.11s}.nl-themed-page .nl-view-body>.row:nth-of-type(3),.nl-themed-page .nl-view-body>section:nth-of-type(3){animation-delay:.2s}
.nl-themed-page .nl-view-body .nl-kpi-value,.nl-universal-module2 .stat-value{font-variant-numeric:tabular-nums;letter-spacing:-.035em}
.nl-themed-page .nl-view-body .badge[class*=status],.nl-themed-page .nl-view-body .badge.text-bg-success{font-weight:750}
/* Distinct desktop and mobile layouts; never permit offscreen sidebar content. */
@media(max-width:1199px){:root{--nl-ui-side:238px}.nl-app-header .nl-account-identity{display:none!important}.nl-app-header form[role="search"]{max-width:480px}}
@media(max-width:991.98px){:root{--nl-ui-side:0px}#nlSidebarCol{display:none!important}#nlMainColumn{flex:0 0 100%!important;width:100%!important;max-width:100%!important;padding:22px 18px 32px!important}.nl-universal-module2 .app-shell{display:block!important}.nl-universal-module2 .app-shell>.nl-universal-sidebar{display:none!important}.nl-universal-module2 .app-shell .main-area{padding:22px 18px 32px!important}.nl-universal-navigation{height:auto!important;position:static!important;overflow:visible!important}.nl-app-header form[role="search"]{max-width:380px}.nl-table-toolbar .nl-table-search{min-width:140px}}
@media(max-width:679px){body.nl-themed-page>.nl-app-header{min-height:64px!important;gap:7px!important;padding:8px 10px!important}.nl-app-header .navbar-brand{font-size:.79rem!important;padding:.4rem .55rem!important}.nl-app-header #nlMenuToggle{width:37px!important;height:38px!important;min-width:37px}.nl-app-header .nl-quick-dropdown{display:none!important}.nl-app-header .nl-account-toggle{padding:.4rem!important;min-height:38px!important}.nl-app-header .nl-header-utilities{gap:2px!important}#nlMainColumn{padding:19px 12px 30px!important}.nl-universal-module2 .app-shell .main-area{padding:19px 12px 30px!important}.nl-themed-page .nl-view-body h1{font-size:1.9rem!important}.nl-themed-page .nl-view-body .table{min-width:760px}.nl-themed-page .nl-view-body .nl-table-toolbar{padding:10px!important}.nl-table-search{flex:1 1 100%!important;max-width:none!important}.nl-table-toolbar .nl-table-filters{flex-basis:100%!important}.nl-side-child{font-size:.86rem}.nl-copy-id{opacity:1!important}}
@media(prefers-reduced-motion:reduce){body.nl-themed-page>.nl-app-header,.nl-themed-page .nl-view-body>section,.nl-themed-page .nl-view-body>.row,.nl-themed-page .nl-view-body>main,.nl-themed-page .nl-view-body>.card,.nl-universal-module2 .content-wrap>.page-heading,.nl-kpi-card:before,.nl-online-pulse{animation:none!important;filter:none!important;transform:none!important}*{scroll-behavior:auto!important}}
@media print{.nl-app-header,#nlSidebarCol,.nl-universal-sidebar,#nlMobileNav,.nl-side-groups,.nl-side-footer{display:none!important}#nlMainColumn{width:100%!important;max-width:100%!important;flex-basis:100%!important}.nl-universal-module2 .app-shell{display:block!important} .nl-universal-module2 .main-area{width:100%!important;padding:0!important}body.nl-themed-page{background:#fff!important}.nl-themed-page .nl-view-body :is(.card,.nl-kpi-card){box-shadow:none!important;transform:none!important}.nl-themed-page .nl-view-body .table{min-width:0!important}}


/* Executive overview: differentiated information architecture, same trusted live values. */
.nl-themed-page .nl-view-body .nl-dash-kpi{position:relative;overflow:hidden;min-height:175px;display:flex!important;flex-direction:column;justify-content:space-between;gap:3px;padding:clamp(16px,1.65vw,25px)!important;background:radial-gradient(ellipse 100% 90% at 110% 110%,rgba(244,153,75,.15),transparent 70%),linear-gradient(140deg,#fffdfa,#fff8f0)!important;isolation:isolate}
.nl-themed-page .nl-view-body .nl-dash-kpi:before{content:"";position:absolute;top:0;left:0;width:100%;height:4px;background:linear-gradient(90deg,#cb4b0a,#f2a55c);transform:scaleX(0);transform-origin:left;animation:nlMetricLine .9s ease forwards}
.nl-themed-page .nl-view-body .nl-dash-kpi:after{content:'\2197';position:absolute;right:18px;top:16px;font-size:1.15rem;font-weight:750;color:#d47c43;opacity:0;transform:translate(-6px,6px);transition:transform .2s,opacity .2s}
.nl-themed-page .nl-view-body .nl-dash-kpi:hover:after,.nl-themed-page .nl-view-body .nl-dash-kpi:focus-visible:after{opacity:1;transform:translate(0,0)}
.nl-themed-page .nl-view-body .nl-dash-kpi .bg-warning-subtle{background:#fff0db!important;border-radius:12px!important;max-width:max-content}.nl-themed-page .nl-view-body .nl-dash-kpi .fs-2{font-size:clamp(1.85rem,2.45vw,2.5rem)!important;font-variant-numeric:tabular-nums;letter-spacing:-.055em}.nl-themed-page .nl-view-body .nl-dash-kpi img{width:25px;height:25px}
.nl-themed-page .nl-view-body .nl-action-link{border:1px solid transparent!important;border-radius:11px!important;margin-bottom:5px;padding:13px 12px!important;transition:background .2s,transform .2s,box-shadow .2s}.nl-themed-page .nl-view-body .nl-action-link:hover,.nl-themed-page .nl-view-body .nl-action-link:focus-visible{background:#fff0e2;border-color:#f1dec7!important;transform:translateX(6px);box-shadow:0 5px 15px #87451f12}.nl-themed-page .nl-view-body .nl-action-link>span:last-child{font-size:1.35rem;color:#be5718}.nl-themed-page .nl-view-body section[aria-label="Items needing attention"]{border-left:4px solid #e27927!important;background:linear-gradient(110deg,#fffdf9,#fff0df)!important}.nl-themed-page .nl-view-body section[aria-label="Items needing attention"] a{display:inline-flex;align-items:center;gap:5px;border-radius:9px;background:#fff;padding:8px 12px;border:1px solid #efddcd;text-decoration:none!important;color:#7e411f!important}.nl-themed-page .nl-view-body section[aria-label="Items needing attention"] a:hover{border-color:#e4a06e;background:#fff6e9}.nl-themed-page .nl-view-body .nl-dash-panel{overflow:hidden}.nl-themed-page .nl-view-body .nl-dashboard-chart{min-height:240px}.nl-themed-page .nl-view-body .nl-status-count-list{display:grid;grid-template-columns:repeat(auto-fit,minmax(110px,1fr));gap:7px 15px}.nl-themed-page .nl-view-body .nl-status-count-list li{display:flex;align-items:center;gap:7px;font-size:.78rem}.nl-themed-page .nl-view-body .nl-status-count-list li strong{margin-left:auto;font-variant-numeric:tabular-nums}@media(max-width:680px){.nl-themed-page .nl-view-body .nl-dash-kpi{min-height:154px}.nl-themed-page .nl-view-body .nl-status-count-list{grid-template-columns:repeat(2,minmax(0,1fr))}}


/* Compact navigation is a first-class state rather than the older Bootstrap column toggle. */
@media(min-width:992px){body.nl-sidebar-collapsed{--nl-ui-side:83px}body.nl-sidebar-collapsed .nl-side-heading-caption,body.nl-sidebar-collapsed .nl-side-heading-line,body.nl-sidebar-collapsed .nl-side-name,body.nl-sidebar-collapsed .nl-side-toggle,body.nl-sidebar-collapsed .nl-side-children,body.nl-sidebar-collapsed .nl-side-group .nl-side-parent .nl-side-main~*{display:none!important}body.nl-sidebar-collapsed .nl-universal-navigation{padding:19px 9px!important}body.nl-sidebar-collapsed .nl-side-heading{justify-content:center;margin:0 0 8px;padding:9px 0}body.nl-sidebar-collapsed .nl-side-parent{min-height:50px}body.nl-sidebar-collapsed .nl-side-main{justify-content:center;padding:8px 4px;min-height:47px}body.nl-sidebar-collapsed .nl-side-icon{width:34px;height:34px;background:rgba(255,240,226,.90)}body.nl-sidebar-collapsed .nl-side-main.is-current .nl-side-icon{color:#fff;background:rgba(255,255,255,.14)}}

/* Universal page tool controls */

.nl-boardroom-tools{display:flex;flex-wrap:wrap;gap:7px;align-items:center;justify-content:flex-end;min-height:30px;margin:0 0 14px;padding:0;animation:nlBoardroomArrival .5s ease both}.nl-boardroom-caption{margin-right:auto;font-size:.62rem;color:#aa785a;letter-spacing:.13em;font-weight:850}.nl-boardroom-action{border:1px solid #eed6bf;background:rgba(255,251,246,.87);color:#91502d;border-radius:9px;font-size:.73rem;font-weight:700;padding:6px 11px;line-height:1.2;cursor:pointer;transition:background .18s,transform .2s,box-shadow .2s}.nl-boardroom-action:hover{background:#ffe9d5;color:#a34716;transform:translateY(-2px);box-shadow:0 5px 14px #a64c1a22}.nl-boardroom-action:focus-visible{outline:2px solid #db6d1c;outline-offset:2px}.nl-numeric-cell{text-align:right!important;font-variant-numeric:tabular-nums;white-space:nowrap}.nl-universal-backtop{position:fixed;right:19px;bottom:20px;width:43px;height:43px;border:1px solid #cc5418;border-radius:13px;color:white;background:linear-gradient(130deg,#ba4007,#e96c14);font-size:1.25rem;box-shadow:0 10px 22px #81431a33;opacity:0;pointer-events:none;transform:translateY(12px);z-index:1030;transition:opacity .2s,transform .2s;cursor:pointer}.nl-universal-backtop.is-visible{opacity:1;pointer-events:auto;transform:translateY(0)}.nl-universal-backtop:hover{transform:translateY(-4px)}.nl-universal-module2 .nl-boardroom-tools{margin-bottom:12px}.nl-universal-module2 .nl-boardroom-tools+.bread{margin-top:4px}@media(prefers-reduced-motion:reduce){.nl-boardroom-tools,.nl-boardroom-action,.nl-universal-backtop{animation:none!important;transition:none!important;transform:none!important}}@media print{.nl-boardroom-tools,.nl-universal-backtop{display:none!important}}


/* Tablet header: protect the central search from wrapping into an extra row. */
@media(min-width:680px) and (max-width:1050px){.nl-app-header .nl-quick-dropdown{display:none!important}.nl-app-header form[role="search"]{max-width:430px;min-width:0!important;width:auto!important;flex-basis:230px!important}.nl-app-header .nl-header-utilities{margin-left:auto!important}}

/* Boardroom release: a layered, functional design system. This stylesheet is
   embedded inside _theme.jsp, never served as a standalone application asset. */
:root{
  --nl-ink:#281c18;--nl-brown:#34221c;--nl-muted:#715e54;
  --nl-orange:#dc5814;--nl-orange-deep:#b73f0c;--nl-amber:#f69d49;
  --nl-bg:#f8f6f2;--nl-cream:#fffdfa;--nl-line:#eaded2;
  --nl-shadow:0 14px 36px rgba(62,37,21,.07),0 2px 7px rgba(62,37,21,.035);
}
html{scroll-behavior:smooth;scroll-padding-top:98px}
body.nl-themed-page{font-family:Inter,'Segoe UI Variable','Segoe UI',system-ui,sans-serif!important;color:var(--nl-ink)!important;background:#f8f6f2!important;letter-spacing:-.009em}
body.nl-themed-page::before{content:'';position:fixed;pointer-events:none;z-index:0;inset:70px 0 auto 240px;height:360px;background:radial-gradient(ellipse 35% 65% at 90% 1%,rgba(250,153,74,.16),transparent),radial-gradient(ellipse 26% 60% at 23% 0,rgba(236,201,152,.09),transparent)}
#nlMainColumn,.nl-universal-module2 .main-area{position:relative;isolation:isolate}
.nl-app-header{border-bottom:1px solid #ffa96233!important;box-shadow:0 8px 24px #331f1830!important}
.nl-app-header .navbar-brand{border:1px solid #ffbb733d!important;box-shadow:0 0 0 1px #ffcc7a0a inset;font-weight:850!important}
.nl-app-header form[role=search]{min-height:44px;padding:5px 6px 5px 13px!important}
.nl-app-header input[type=search]{font-size:.86rem!important;font-weight:450}
.nl-app-header .nl-account-toggle{border:1px solid #ffffff35!important}
#nlMainColumn{padding:clamp(22px,2.35vw,40px)!important}
.nl-themed-page .nl-view-body,.nl-universal-module2 .content-wrap{max-width:1630px;margin:0 auto;min-width:0}
.nl-themed-page .nl-view-body h1,.nl-universal-module2 .content-wrap h1{font-weight:840!important;letter-spacing:-.05em!important;color:#30211c!important}
.nl-themed-page .nl-view-body h2,.nl-universal-module2 .content-wrap h2{letter-spacing:-.025em;font-weight:760}
.nl-themed-page .nl-view-body p,.nl-universal-module2 .content-wrap p{line-height:1.55}
.nl-themed-page .nl-view-body .card,.nl-universal-module2 .content-wrap .card{border:1px solid #ebdaca!important;border-radius:20px!important;box-shadow:var(--nl-shadow)!important;background:linear-gradient(142deg,#fffdfb 0%,#fffaf5 100%)!important;overflow:visible}
.nl-themed-page .nl-view-body .card:hover{border-color:#eac9ad!important}
.nl-themed-page .nl-view-body .card-body{min-width:0}
.nl-themed-page .nl-view-body :is(.btn,.form-control,.form-select),.nl-universal-module2 .content-wrap :is(.btn,.input,.select){border-radius:11px!important}
.nl-themed-page .nl-view-body :is(.btn,.form-control,.form-select),.nl-universal-module2 .content-wrap :is(.btn,.input,.select){min-height:42px}
.nl-themed-page .nl-view-body :is(input,select,textarea):focus,.nl-universal-module2 .content-wrap :is(input,select,textarea):focus{border-color:#dc7b3f!important;box-shadow:0 0 0 4px rgba(218,100,39,.12)!important}
.nl-themed-page .nl-view-body :is(.btn-warning,.btn-primary),.nl-universal-module2 .btn.primary{background:linear-gradient(115deg,#bd410e,#e86715)!important;color:#fff!important;border-color:#c34a11!important;font-weight:740!important;box-shadow:0 6px 14px #b7471630;transition:transform .22s,box-shadow .22s,background .22s}
.nl-themed-page .nl-view-body :is(.btn-warning,.btn-primary):hover,.nl-universal-module2 .btn.primary:hover{transform:translateY(-2px);box-shadow:0 11px 20px #b7471633}
.nl-themed-page .nl-view-body .btn-outline-secondary,.nl-themed-page .nl-view-body .btn-outline-dark{background:#fffaf5!important;border-color:#e4c6ac!important;color:#754027!important}
.nl-themed-page .nl-view-body .btn-outline-secondary:hover,.nl-themed-page .nl-view-body .btn-outline-dark:hover{background:#fff0e1!important;border-color:#df925c!important}
.nl-themed-page .nl-view-body label.form-label{color:#584238;font-size:.81rem;font-weight:700}
.nl-themed-page .nl-view-body .form-text{font-size:.76rem;color:#90766a}
.nl-themed-page .nl-view-body .table-responsive{border:1px solid #e9daca;border-radius:16px!important;overflow-x:auto}
.nl-themed-page .nl-view-body table.table{margin:0;background:#fffdf9;border-color:#eee0d6;font-size:clamp(.79rem,.77vw,.87rem)}
.nl-themed-page .nl-view-body table.table thead th{background:#f9eee3!important;color:#74442e!important;letter-spacing:.055em;text-transform:uppercase;font-weight:800;font-size:.7rem;vertical-align:middle;padding:14px 15px!important;white-space:normal}
.nl-themed-page .nl-view-body table.table tbody td{padding:13px 15px!important;vertical-align:middle;border-color:#eee4da!important;line-height:1.46}
.nl-themed-page .nl-view-body table.table tbody tr{transition:background-color .18s}
.nl-themed-page .nl-view-body table.table tbody tr:nth-child(even){background:#fbf6f0!important}
.nl-themed-page .nl-view-body table.table tbody tr:hover{background:#fff1e3!important}
.nl-themed-page .nl-view-body table.table tbody tr[hidden]{display:none!important}
.nl-themed-page .nl-view-body table.table td a:not(.btn){font-weight:660;text-underline-offset:3px;text-decoration-thickness:1px;overflow-wrap:anywhere}
.nl-sort-head{text-transform:uppercase!important;letter-spacing:.055em!important;font-size:.7rem!important;color:#6e452f!important;text-align:left!important;line-height:1.4!important}
.nl-sort-head::after{content:'\21C5';margin-left:8px;font-weight:500;opacity:.5;font-size:.9rem}
th.nl-sorted .nl-sort-head::after{opacity:1;color:#c14c14}
th[aria-sort=ascending] .nl-sort-head::after{content:'\2191'}
th[aria-sort=descending] .nl-sort-head::after{content:'\2193'}
.nl-table-toolbar{padding:13px 14px!important;background:linear-gradient(110deg,#fffaf5,#fff6ed)!important;border:1px solid #ead8c5!important;box-shadow:0 4px 16px rgba(80,42,18,.035)!important;border-radius:15px!important}
.nl-table-toolbar .nl-table-filters{flex:1;gap:9px!important;min-width:0}
.nl-table-toolbar .nl-table-search{max-width:420px!important;min-width:180px!important;flex:1 1 260px!important}
.nl-table-toolbar .nl-table-status{max-width:210px!important;min-width:145px}
.nl-table-toolbar .nl-table-records{font-weight:640;color:#786357!important;white-space:normal}
.nl-table-toolbar .btn,.nl-table-pagination .btn{font-weight:690!important}
.nl-table-pagination{background:#fffaf5;padding:12px 14px!important;border:1px solid #eedfce;border-radius:14px;justify-content:flex-end!important}
.nl-table-pagination .nl-page-size{min-width:106px;max-width:130px}
.nl-copy-id{min-height:25px!important;padding:3px 8px!important;font-size:.66rem!important;display:inline-flex!important;align-items:center!important;border-radius:8px!important;color:#a0522f!important;background:transparent!important;border-color:#ead3bf!important;opacity:.45;transition:opacity .2s,background .2s}
tr:hover .nl-copy-id,.nl-copy-id:focus-visible{opacity:1!important;background:#fff4e8!important}
.nl-totals-strip{display:flex;flex-wrap:wrap;gap:12px}
.nl-themed-page .nl-view-body .nl-dash-kpi{position:relative;padding:24px 24px 22px!important;border-radius:20px!important;min-height:198px!important;box-shadow:0 12px 30px rgba(75,41,23,.07)!important;transition:transform .32s cubic-bezier(.15,.85,.3,1),box-shadow .32s!important;isolation:isolate}
.nl-themed-page .nl-view-body .nl-dash-kpi:hover{transform:translateY(-7px)!important;box-shadow:0 22px 42px rgba(97,50,24,.15)!important}
.nl-themed-page .nl-view-body .nl-dash-kpi::before{height:5px!important;background:linear-gradient(90deg,#e96517,#ffc071)!important}
.nl-themed-page .nl-view-body .nl-dash-kpi::after{content:'\2197'!important;top:22px!important;right:23px!important;opacity:.8!important;transform:none!important;font-size:1.28rem!important}
.nl-themed-page .nl-view-body .nl-dash-kpi:nth-child(2){background:linear-gradient(135deg,#fffdf8,#fcf1df)!important}
.nl-themed-page .nl-view-body .nl-dash-kpi .nl-kpi-value{font-size:clamp(1.75rem,2.15vw,2.35rem)!important;letter-spacing:-.048em}
.nl-themed-page .nl-view-body .nl-dash-kpi .nl-kpi-label{font-weight:650;color:#775f51!important}
.nl-themed-page .nl-view-body .nl-dash-kpi .nl-kpi-link{font-size:.77rem;font-weight:800!important;display:inline-flex!important;align-items:center;gap:6px}
.nl-themed-page .nl-view-body .nl-dash-kpi .nl-kpi-link::after{content:'View details';font-weight:500;display:none}
.nl-themed-page .nl-view-body .nl-dash-panel{border-radius:22px!important}
.nl-themed-page .nl-view-body .nl-action-link{min-height:53px;padding:13px 16px!important;border:1px solid #f2e2d2!important;margin-bottom:8px;background:#fffdf9;border-radius:13px!important;font-weight:680;display:flex!important}
.nl-themed-page .nl-view-body .nl-action-link:hover{background:#fff0e3!important;border-color:#ecbd9d!important;transform:translateX(5px)!important}
.nl-themed-page .nl-view-body .nl-action-link>span:last-child{font-weight:800;color:#c85d18!important}
.nl-boardroom-tools{margin-bottom:18px!important;position:relative;z-index:5}
.nl-boardroom-caption{font-size:.63rem!important;letter-spacing:.17em!important;color:#a36d4e!important}
.nl-page-tools{position:relative;margin-left:auto}
.nl-page-tools>summary{list-style:none;cursor:pointer;display:flex;align-items:center;gap:12px;font-size:.76rem;font-weight:800;border:1px solid #ead1bc;background:#fffdf9;border-radius:11px;color:#8c431f;padding:9px 13px;min-height:38px;transition:background .18s,box-shadow .18s}
.nl-page-tools>summary::after{content:'';width:8px;height:8px;border-right:2px solid currentColor;border-bottom:2px solid currentColor;transform:rotate(45deg);margin-top:-3px;transition:transform .18s}.nl-page-tools[open]>summary::after{transform:rotate(225deg);margin-top:4px}.nl-page-tools>summary::-webkit-details-marker{display:none}
.nl-page-tools[open]>summary,.nl-page-tools>summary:hover{background:#fff0e0;box-shadow:0 6px 18px #9d521621}
.nl-page-tools-panel{position:absolute;top:calc(100% + 8px);right:0;min-width:210px;padding:7px;background:#fffdf9;border:1px solid #ead5c3;border-radius:13px;box-shadow:0 14px 36px #61371d25;z-index:15;animation:nlBoardroomArrival .23s ease both}
.nl-page-tools-panel button{display:block;width:100%;border:0;border-radius:9px;padding:10px 11px;text-align:left;background:transparent;color:#68422f;font-size:.82rem;font-weight:680}
.nl-page-tools-panel button:hover{background:#fff0df}
.nl-universal-backtop{width:47px!important;height:47px!important;font-size:.72rem!important;font-weight:850!important;text-transform:uppercase;letter-spacing:.04em}
.nl-search-host{position:relative;isolation:isolate}
.nl-search-suggestions{position:absolute;top:calc(100% + 8px);left:0;right:0;z-index:1080;background:#fffdfb;color:#33251e;border:1px solid #ead0ba;border-radius:15px;padding:7px;box-shadow:0 20px 44px rgba(41,22,13,.3);max-height:330px;overflow:auto}
.nl-search-suggestions[hidden]{display:none!important}
.nl-search-suggestion{display:flex;justify-content:space-between;align-items:center;gap:15px;padding:11px 12px;border-radius:10px;text-decoration:none!important;color:#483126!important;font-size:.82rem;font-weight:760}
.nl-search-suggestion:hover,.nl-search-suggestion:focus-visible{color:#a44515!important;background:#fff0e2}
.nl-search-suggestion small{color:#997d6c;font-weight:540;white-space:nowrap}
.nl-search-hint{padding:10px 12px 7px;border-top:1px solid #f0e3d6;color:#8d7565;font-size:.72rem}
.nl-side-icon{width:29px!important;height:29px!important;font-family:inherit!important;font-size:.63rem!important;font-weight:900!important;letter-spacing:.035em!important}
.nl-side-child{font-size:.8rem!important;min-height:39px;display:flex;align-items:center}
.nl-side-children[hidden]{display:none!important}
.nl-themed-page .nl-page-hero{padding:9px 0 26px;margin:0 0 10px}
.nl-eyebrow{font-size:.66rem;font-weight:900;letter-spacing:.18em;text-transform:uppercase;color:#a85830}
.nl-page-hero-row{display:flex;flex-wrap:wrap;justify-content:space-between;gap:20px;align-items:center}
.nl-page-hero h1{font-size:clamp(2rem,3vw,3.1rem)!important;margin:6px 0 8px!important;font-weight:860}
.nl-page-hero p{font-size:.94rem;color:#786153;max-width:720px;margin:0}
.nl-page-hero-badge{font-size:.7rem;color:#a55422;font-weight:760;background:#fff0e2;border:1px solid #e9c5a7;padding:9px 13px;border-radius:999px}
.nl-audit-stats{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin:0 0 25px}
.nl-audit-stat{background:linear-gradient(132deg,#fffdf9,#fff2e5);border:1px solid #ebd7c3;border-radius:18px;padding:18px 19px;box-shadow:0 8px 22px rgba(78,45,20,.05);min-height:126px;transition:transform .2s}
.nl-audit-stat:hover{transform:translateY(-4px)}
.nl-audit-stat span,.nl-audit-stat small{display:block;font-size:.77rem;color:#795f50}
.nl-audit-stat strong{display:block;font-size:2rem;line-height:1.35;letter-spacing:-.055em;color:#a64815;font-variant-numeric:tabular-nums}
.nl-audit-stat small{font-size:.7rem}
.nl-event-count{white-space:nowrap;border:1px solid #f2d1ae;color:#975426;background:#fff2e2;padding:8px 12px;border-radius:999px;font-weight:760;font-size:.75rem}
.nl-audit-table{min-width:920px!important}
.nl-audit-table td:nth-child(1),.nl-audit-table td:nth-child(2){white-space:nowrap}
.nl-audit-table td:nth-child(4){min-width:128px}
.nl-audit-table td:nth-child(5),.nl-audit-table td:nth-child(6){min-width:180px;max-width:340px}
.nl-audit-action{display:inline-flex;align-items:center;gap:6px;padding:5px 9px;border-radius:999px;border:1px solid transparent;font-size:.67rem;letter-spacing:.015em;font-weight:850;white-space:nowrap}
.nl-audit-create{color:#236448;background:#e5f4e9;border-color:#c8e8d3}
.nl-audit-update{color:#99520e;background:#fff2de;border-color:#f1d7b9}
.nl-audit-delete{color:#a0342f;background:#ffebe6;border-color:#f1c8bf}
.nl-audit-neutral{color:#496586;background:#eaf0f9;border-color:#ccddf0}
.nl-audit-id{font-weight:790;color:#a34b1e}
.nl-audit-details{max-width:100%;line-height:1.5}
.nl-audit-details>summary{font-size:.77rem;color:#6f5a4d;overflow:hidden;text-overflow:ellipsis;max-width:285px;white-space:nowrap;cursor:pointer}
.nl-audit-details[open]>summary{white-space:normal;color:#ae4916;font-weight:750}
.nl-audit-json{white-space:pre-wrap;word-break:break-word;color:#593a2c;background:#fff6eb;border:1px solid #edd8c2;border-radius:11px;padding:11px;margin:8px 0 0;max-height:240px;overflow:auto;font-size:.72rem;line-height:1.55}
.nl-audit-empty{font-size:.76rem;color:#9c8b81}
.nl-audit-ip{font-size:.76rem;color:#674839;background:#fff1e4;padding:5px 7px;border-radius:7px}
.nl-audit-footnote{padding:14px 4px 2px;color:#88756a;font-size:.74rem}
.nl-account-modal{z-index:1060!important}
.nl-account-modal .modal-content{border:1px solid #edcfb6;border-radius:22px;overflow:hidden;box-shadow:0 28px 70px #301b1440}
.nl-account-modal .nl-account-modal-head{background:linear-gradient(105deg,#fff9f1,#fff2e3);padding:22px 26px;border-color:#f0dac5}
.nl-account-modal .modal-footer{background:#fffaf5;border-color:#f0e1d0}
.nl-account-modal .modal-body{background:#fffdfa}
.nl-modal-advice{background:#fff4e7;border-left:4px solid #d96b26;padding:15px 18px;border-radius:10px;font-size:.81rem;line-height:1.7;color:#735647}
.nl-modal-advice strong{display:block;font-size:.85rem;color:#aa451a;margin-bottom:4px}
body.modal-open .nl-view-body{transform:none!important;filter:none!important}
.nl-themed-page .nl-view-body .nl-enhanced-table tbody td:last-child .btn{margin:2px}
.nl-themed-page .nl-view-body .nl-enhanced-table tbody td:last-child form{display:inline-flex!important;margin:2px;align-items:center}
.nl-themed-page .nl-view-body .nl-enhanced-table tbody td:last-child button{white-space:nowrap}
.nl-themed-page .nl-view-body .badge{font-size:.68rem;line-height:1.35;letter-spacing:.015em;padding:6px 9px;font-weight:770;white-space:normal}
.nl-themed-page .nl-view-body .nl-audit-log-card .table .badge{white-space:nowrap}
.nl-themed-page .nl-view-body .nl-table-empty{border-radius:12px}
.nl-scroll-anchor{scroll-margin-top:106px}
/* Modern presentation finish for profile without changing any form action. */
.nl-universal-module2 .profile-hero{background:radial-gradient(ellipse 48% 100% at 100% 0,rgba(255,160,78,.32),transparent),linear-gradient(115deg,#321b16 0%,#723015 55%,#db5b14 100%)!important;border-radius:22px!important;padding:clamp(24px,3vw,42px)!important;box-shadow:0 17px 35px #50270e28!important}
.nl-universal-module2 .profile-avatar{border:2px solid #ffca8d!important;box-shadow:0 12px 35px rgba(0,0,0,.2);width:86px!important;height:86px!important;font-size:2.5rem!important}
.nl-universal-module2 .profile-identity h2{font-size:clamp(1.5rem,2.6vw,2.5rem)!important;letter-spacing:-.04em!important}
.nl-universal-module2 .profile-overview{gap:15px!important}
.nl-universal-module2 .profile-fact{border:1px solid #ebd9c7!important;background:#fffdfa!important;padding:22px!important;border-radius:17px!important;box-shadow:0 7px 22px #60351f0d}
.nl-universal-module2 .profile-panel{padding:clamp(22px,2.8vw,34px)!important}
.nl-universal-module2 .profile-form{border-bottom:1px solid #efe2d7;padding:18px 0!important}
.nl-universal-module2 .profile-form:first-of-type{padding-top:12px!important}
.nl-universal-module2 .profile-form .input{border-color:#e6cbb8!important;background:#fffdf9!important}
.nl-universal-module2 .profile-security{border:1px solid #ecd7c4;border-radius:14px;background:#fff8ef;padding:10px 15px}
.nl-universal-module2 .profile-security>summary{padding:9px 3px}
.nl-universal-module2 .profile-side>.card{padding:27px!important}
.nl-universal-module2 .profile-permissions li{padding:15px 0!important;border-bottom:1px solid #f0e3d5}
.nl-universal-module2 .profile-badges span{background:#ffffff19!important;border:1px solid #ffcc8b66!important;color:#ffebd5!important}
.nl-universal-module2 .profile-hero-actions .btn{background:#fff0df!important;color:#954014!important;border:1px solid #ffe4ba!important}
.nl-universal-module2 .nl-profile-quicknav{display:flex;flex-wrap:wrap;gap:9px;margin:0 0 19px}
.nl-universal-module2 .nl-profile-quicknav a{font-size:.81rem;font-weight:750;padding:10px 15px;border-radius:11px;border:1px solid #edcbb0;color:#994b21;background:#fffaf5;transition:background .18s,transform .18s;text-decoration:none}
.nl-universal-module2 .nl-profile-quicknav a:hover{background:#ffe6cd;transform:translateY(-2px)}
.nl-profile-panel-outline{scroll-margin-top:110px}
@media(max-width:1300px){.nl-audit-stats{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:992px){#nlMainColumn{padding:22px 17px 34px!important}.nl-audit-stats{gap:11px}.nl-themed-page .nl-view-body .nl-dash-kpi{min-height:185px!important}}
@media(max-width:620px){.nl-audit-stats{grid-template-columns:repeat(2,minmax(0,1fr))}.nl-audit-stat{padding:14px}.nl-audit-stat strong{font-size:1.55rem}.nl-page-hero h1{font-size:1.9rem!important}.nl-table-toolbar .nl-table-search{max-width:none!important;flex:1 1 100%!important}.nl-page-tools>summary{padding:8px 11px}.nl-universal-module2 .profile-hero{padding:23px!important}.nl-universal-module2 .nl-profile-quicknav a{flex:1 1 auto;text-align:center}}
@media(prefers-reduced-motion:reduce){.nl-themed-page .nl-view-body .nl-dash-kpi,.nl-side-main,.nl-audit-stat,.nl-page-tools-panel,.nl-search-suggestions,.nl-profile-quicknav a{animation:none!important;transition:none!important;transform:none!important}}
@media print{.nl-boardroom-tools,.nl-search-suggestions,.nl-profile-quicknav,.nl-table-toolbar,.nl-table-pagination{display:none!important}.nl-audit-details>summary{white-space:normal!important}.nl-themed-page .nl-view-body table.table tbody td{padding:8px!important}}


/* Targeted flow improvements to action-heavy records. */
.nl-shortcut-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}
.nl-themed-page .nl-view-body .nl-shortcut-grid .nl-action-link{display:flex!important;min-height:66px;align-items:center;padding:14px!important;margin:0!important;border-radius:14px!important;background:linear-gradient(130deg,#fffdfa,#fff4e8)!important;font-size:.84rem!important}
.nl-themed-page .nl-view-body .nl-shortcut-grid .nl-action-link .nl-action-dot{display:inline-grid;width:10px;height:10px;padding:0!important;vertical-align:middle;margin-right:7px!important}
.nl-themed-page .nl-view-body .nl-shortcut-grid .nl-action-link>span:first-child{flex:1}
.nl-themed-page .nl-view-body .nl-shortcut-grid .nl-action-link:hover{box-shadow:0 10px 22px rgba(163,68,23,.12)!important}
.nl-themed-page .nl-view-body .nl-claim-actions{display:flex;flex-direction:column;align-items:stretch;gap:7px;min-width:112px}
.nl-themed-page .nl-view-body .nl-claim-actions .btn{min-height:36px!important;display:inline-flex!important;justify-content:center;align-items:center;gap:6px;width:100%;font-size:.73rem!important;padding:6px 10px!important;margin:0!important;line-height:1.2!important;white-space:nowrap}
.nl-themed-page .nl-view-body #claimTable td:nth-child(1){min-width:158px}
.nl-themed-page .nl-view-body #claimTable td:nth-child(2){min-width:154px}
.nl-themed-page .nl-view-body #claimTable td:nth-child(4),.nl-themed-page .nl-view-body #claimTable td:nth-child(5){white-space:nowrap;font-variant-numeric:tabular-nums}
.nl-themed-page .nl-view-body #claimTable td:last-child{min-width:145px}
.nl-themed-page .nl-view-body #claimTable .claim-link{overflow-wrap:anywhere;word-break:break-word}
.nl-themed-page .nl-view-body .nl-dashboard-chart canvas{max-height:300px}
.nl-themed-page .nl-view-body .nl-status-count-list{grid-template-columns:repeat(auto-fit,minmax(116px,1fr));gap:10px!important;margin:18px 0 0}
.nl-themed-page .nl-view-body .nl-status-count-list li{background:#fff7ef;border:1px solid #f0e0cd;padding:9px 11px;border-radius:10px;font-size:.75rem}
.nl-themed-page .nl-view-body .nl-status-count-list li strong{color:#9e4b20}
@media(max-width:1300px){.nl-shortcut-grid{grid-template-columns:1fr}}
@media(min-width:1500px){.nl-shortcut-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}


/* Universal search results: page destinations and data matches are distinct. */
.nl-universal-module2 h2[id^="profile"]{scroll-margin-top:110px}
.nl-search-result-heading{display:flex;flex-wrap:wrap;align-items:start;justify-content:space-between;gap:16px;margin-bottom:20px}
.nl-search-page-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(245px,1fr));gap:12px}
.nl-search-page-tile{display:flex;flex-direction:column;gap:7px;padding:20px;background:linear-gradient(135deg,#fffdfa,#fff2e6);border:1px solid #edd7c4;border-radius:16px;color:#38251d!important;text-decoration:none!important;min-height:173px;box-shadow:0 7px 15px #8144190c;transition:transform .2s,border .2s,box-shadow .2s}
.nl-search-page-tile:hover{transform:translateY(-4px);border-color:#e5a777;box-shadow:0 12px 28px #81441926}
.nl-search-page-label{font-size:.62rem;font-weight:860;letter-spacing:.14em;color:#b46437}
.nl-search-page-tile strong{font-size:1.08rem;font-weight:840;line-height:1.3}
.nl-search-page-tile small{font-size:.78rem;color:#806a5e;line-height:1.5;flex:1}
.nl-search-page-open{font-size:.76rem;color:#b54f14;font-weight:820}
.nl-scroll-anchor{scroll-margin-top:115px!important}

/* N-LOGISTIC v3 / Every list is a modern, legible data surface. */
:root{--nl-surface-v3:#ffffff;--nl-line-v3:#eadfd6;--nl-ink-v3:#30251f;--nl-warm-v3:#fff4eb;--nl-active-v3:#d85716}
.nl-themed-page .nl-view-body :is(.table-responsive,.table-wrap), .nl-universal-module2 .content-wrap .table-wrap {border-radius:18px!important;border:1px solid #eadad0;background:#fff!important;box-shadow:0 10px 32px rgba(55,31,20,.06);overflow-x:auto;}
.nl-themed-page .nl-view-body table.table,.nl-universal-module2 .content-wrap :is(table.data-table,table.table){width:100%;border-collapse:separate!important;border-spacing:0;font-size:.86rem!important;background:#fff!important;color:var(--nl-ink-v3);margin-bottom:0!important;}
.nl-themed-page .nl-view-body table.table thead th,.nl-universal-module2 .content-wrap :is(table.data-table,table.table) thead th {position:relative;background:#fff5ec!important;color:#7f4631!important;font-weight:800!important;letter-spacing:.035em!important;font-size:.69rem!important;padding:17px 15px!important;line-height:1.3!important;white-space:normal!important;border-bottom:1px solid #e9d7c8!important;text-align:left;}
.nl-themed-page .nl-view-body table.table tbody td,.nl-universal-module2 .content-wrap :is(table.data-table,table.table) tbody td{padding:16px 15px!important;border-bottom:1px solid #f1e7df!important;vertical-align:middle!important;color:#47332a!important;line-height:1.5;max-width:470px;overflow-wrap:anywhere;}
.nl-themed-page .nl-view-body table.table tbody tr:last-child td,.nl-universal-module2 .content-wrap :is(table.data-table,table.table) tbody tr:last-child td{border-bottom:0!important}
.nl-themed-page .nl-view-body table.table tbody tr:nth-child(even),.nl-universal-module2 .content-wrap :is(table.data-table,table.table) tbody tr:nth-child(even){background:#fbf7f3!important}
.nl-themed-page .nl-view-body table.table tbody tr:hover,.nl-universal-module2 .content-wrap :is(table.data-table,table.table) tbody tr:hover{background:#fff0e3!important;box-shadow:inset 3px 0 0 #d65a19}
.nl-themed-page .nl-view-body table.table :is(.badge,.pill,.tag),.nl-universal-module2 :is(.data-table,.table) :is(.badge,.pill,.tag){font-weight:750;letter-spacing:0;text-transform:none;font-size:.73rem;border-radius:999px!important;padding:.43rem .65rem;white-space:normal;text-align:center;max-width:100%;}
.nl-themed-page .nl-view-body table.table td .btn,.nl-universal-module2 .content-wrap table :is(.btn,button){min-height:33px;font-size:.75rem;font-weight:720;border-radius:9px;white-space:normal;line-height:1.2;display:inline-flex;align-items:center;justify-content:center;gap:5px;}
.nl-themed-page .nl-view-body table.table td form{margin:0;}
.nl-themed-page .nl-view-body table.table td .d-flex{align-items:center;gap:8px;}
.nl-themed-page .nl-view-body .nl-table-toolbar{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;padding:12px 14px;background:linear-gradient(140deg,#fff,#fff9f3);border:1px solid #eee0d4;border-radius:14px;margin:8px 0 12px;box-shadow:0 4px 14px rgba(65,30,11,.03)}
.nl-themed-page .nl-view-body .nl-table-filters{display:flex;align-items:center;flex:1;gap:9px;flex-wrap:wrap}
.nl-themed-page .nl-view-body .nl-table-search{flex:1;min-width:210px;max-width:none;border-radius:11px!important;min-height:38px}
.nl-themed-page .nl-view-body .nl-table-status{min-width:150px;width:auto;border-radius:11px}
.nl-themed-page .nl-view-body .nl-table-toolbar :is(.btn,.form-select){min-height:38px}
.nl-themed-page .nl-view-body .nl-table-records{color:#8c6f5c!important;font-size:.72rem;font-weight:700}
.nl-themed-page .nl-view-body .nl-table-pagination{background:#fffdfb;border:1px solid #efdfd1;padding:11px 14px;border-radius:13px;box-shadow:0 3px 13px #2d191007}
.nl-themed-page .nl-view-body .nl-sort-head{font-size:inherit;color:inherit!important;text-decoration:none!important;text-align:left;display:inline-flex;align-items:center;gap:6px}
.nl-themed-page .nl-view-body .nl-sort-head:after{content:'\2195';font-weight:700;font-size:.88rem;color:#a77c62}
.nl-themed-page .nl-view-body [aria-sort=ascending] .nl-sort-head:after{content:'\2191';color:#b64d16}
.nl-themed-page .nl-view-body [aria-sort=descending] .nl-sort-head:after{content:'\2193';color:#b64d16}
.nl-themed-page .nl-view-body .nl-copy-id{opacity:1!important;width:auto!important;height:auto!important;min-height:27px!important;min-width:27px!important;padding:3px 7px!important;font-size:.67rem!important;display:inline-flex!important;align-items:center;justify-content:center;border:1px solid #eed7c7;background:#fff9f5;white-space:nowrap;color:#935537}
.nl-themed-page .nl-view-body .nl-copy-id:hover{background:#ffe6d1;color:#a54116}
.nl-themed-page .nl-view-body .nl-section-heading{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:16px}
.nl-themed-page .nl-view-body .nl-section-note{border:1px solid #f2d1b3;border-radius:999px;background:#fff3e6;color:#9c4d1f;font-weight:750;font-size:.7rem;padding:7px 12px}
.nl-themed-page .nl-view-body .nl-inline-filter{display:flex;align-items:flex-end;gap:12px;flex-wrap:wrap;max-width:100%}
.nl-themed-page .nl-view-body .nl-inline-filter .nl-filter-field{flex:1 1 310px;min-width:200px}
.nl-themed-page .nl-view-body .nl-inline-filter :is(input,select){width:100%;min-height:45px;border-radius:12px}
.nl-themed-page .nl-view-body .nl-content-hero{border-left:4px solid #e36c2b;background:linear-gradient(130deg,#fff,#fff5ee);border-radius:14px;padding:26px 30px;margin-bottom:22px;box-shadow:0 8px 24px #3d220c0b}
.nl-themed-page .nl-view-body .nl-content-hero h1{font-size:clamp(1.7rem,2.4vw,2.45rem);margin:.3em 0 .2em;font-weight:850;letter-spacing:-.045em}
.nl-themed-page .nl-view-body .nl-content-hero p{color:#795f4c;margin:0;max-width:700px}
.nl-themed-page .nl-view-body .nl-summary-stats{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:15px;margin-bottom:20px}
.nl-themed-page .nl-view-body .nl-metric-tile{background:linear-gradient(145deg,#fff,#fff5e9);border:1px solid #ebd6c6;border-top:3px solid #e3742c;border-radius:16px;padding:21px;box-shadow:0 7px 21px #48240d0d}
.nl-themed-page .nl-view-body .nl-metric-tile small{color:#7a5b4a;display:block;font-weight:710;margin-bottom:9px}
.nl-themed-page .nl-view-body .nl-metric-tile strong{font-size:clamp(1.25rem,2vw,1.9rem);font-variant-numeric:tabular-nums;overflow-wrap:anywhere}
.nl-themed-page .nl-view-body .nl-empty-selection{text-align:center;padding:42px 22px;background:#fffaf5;border:1px dashed #e4bb97;border-radius:18px;margin:18px 0}
.nl-themed-page .nl-view-body .nl-empty-selection strong{display:block;font-size:1.1rem}.nl-themed-page .nl-view-body .nl-empty-selection p{color:#7e6254;margin:8px auto 0}
.nl-booking-success{display:flex;align-items:center;gap:24px;margin:0 0 25px;padding:26px;background:linear-gradient(112deg,#174e39,#1e7656);color:#fff;border-radius:22px;box-shadow:0 16px 34px rgba(16,84,53,.22);animation:nlBookingArrival .55s cubic-bezier(.2,.8,.2,1) both}
.nl-booking-success h2{color:#fff;font-weight:850}.nl-booking-success p,.nl-booking-success .nl-eyebrow{color:#daf0e2}.nl-confirm-mark{flex:none;display:grid;place-items:center;border:2px solid #d1f4df;background:#ffffff18;border-radius:50%;height:68px;width:68px;font-size:2rem}
@keyframes nlBookingArrival{from{opacity:0;transform:translateY(18px) scale(.97)}to{opacity:1;transform:translateY(0) scale(1)}}
/* Navigation stays visible and follows scrolled analytics content. */
@media(min-width:992px){#nlSidebarCol{position:sticky;top:var(--nl-ui-h);align-self:start;height:calc(100vh - var(--nl-ui-h));overflow:hidden}#nlSidebarCol>.nl-universal-navigation{top:0;height:100%;overscroll-behavior:contain;scroll-behavior:smooth}.nl-universal-module2 .app-shell>.nl-universal-sidebar{overscroll-behavior:contain;scroll-behavior:smooth}}
.nl-side-icon img{display:block;width:21px;height:21px;object-fit:contain;filter:none}
.nl-side-main.is-current .nl-side-icon img{filter:brightness(0) invert(1)}
.nl-themed-page .nl-view-body :is(.card,.nl-dash-panel,.nl-dash-kpi,.nl-kpi-card):hover{box-shadow:0 18px 48px #53351b1b!important;}
/* Keep motion smooth but never animate modal/backdrop stacking contexts. */
.nl-themed-page .nl-view-body .modal,.nl-themed-page .nl-view-body .modal-dialog{animation:none!important;transform:none}
@media(max-width:800px){.nl-themed-page .nl-view-body .nl-summary-stats{grid-template-columns:1fr}.nl-themed-page .nl-view-body .nl-table-toolbar{align-items:stretch}.nl-themed-page .nl-view-body .nl-table-filters{width:100%}.nl-themed-page .nl-view-body .nl-table-search{min-width:100%}.nl-booking-success{align-items:flex-start;flex-direction:column;padding:23px}.nl-themed-page .nl-view-body .nl-content-hero{padding:20px}}
@media(max-width:700px){.nl-themed-page .nl-view-body .nl-smart-table{min-width:0!important}.nl-themed-page .nl-view-body .nl-smart-table thead{display:none}.nl-themed-page .nl-view-body .nl-smart-table tbody tr{display:block;background:#fff!important;margin:10px 5px;border:1px solid #edd8c7;border-radius:14px;overflow:hidden;padding:4px 0}.nl-themed-page .nl-view-body .nl-smart-table tbody td{display:flex;align-items:center;justify-content:space-between;gap:15px;padding:9px 14px!important;max-width:none!important;text-align:right!important;border:0!important}.nl-themed-page .nl-view-body .nl-smart-table tbody td:before{content:attr(data-label);font-size:.72rem;font-weight:800;text-align:left;color:#806452;white-space:normal}.nl-themed-page .nl-view-body .nl-smart-table td[colspan]:before{display:none}}
@media(prefers-reduced-motion:reduce){.nl-booking-success{animation:none}.nl-themed-page .nl-view-body *{scroll-behavior:auto!important}}


/* v3: Form and section alignment even in older individual module pages. */
.nl-themed-page .nl-view-body .section-head{display:flex!important;align-items:flex-start;justify-content:space-between;gap:18px;flex-wrap:wrap;margin-bottom:19px}
.nl-themed-page .nl-view-body .section-head>div{min-width:260px;flex:1 1 300px}
.nl-themed-page .nl-view-body form.search.nl-filter-form,.nl-themed-page .nl-view-body .section-head>form.search{display:flex!important;gap:10px;align-items:flex-end;flex-wrap:wrap;flex:1 1 350px;justify-content:flex-end;max-width:100%}
.nl-themed-page .nl-view-body .section-head>form.search :is(input,select){flex:1 1 150px;min-width:150px;max-width:300px;height:43px}
.nl-themed-page .nl-view-body .section-head>form.search .btn{height:43px;white-space:nowrap}
.nl-themed-page .nl-view-body .nl-inventory-nav{border:1px solid #eadacc;background:linear-gradient(135deg,#fffdfb,#fff1e4);padding:15px 18px;border-radius:17px;box-shadow:0 8px 24px #48240f0b}
.nl-themed-page .nl-view-body .nl-inventory-nav .nl-module-linkset{gap:9px}
.nl-themed-page .nl-view-body .nl-inventory-nav .btn,.nl-themed-page .nl-view-body .nl-inventory-nav a{min-height:39px}
.nl-themed-page .nl-view-body :is(.card,.nl-dash-panel) h2,.nl-themed-page .nl-view-body :is(.card,.nl-dash-panel) h3{letter-spacing:-.025em}
.nl-themed-page .nl-view-body table.table :is(td,th).nl-numeric-cell{text-align:right!important;font-variant-numeric:tabular-nums;white-space:nowrap}
.nl-themed-page .nl-view-body .nl-stock-row-actions[open]{border-radius:13px;box-shadow:0 8px 20px #41260f0e;}
.nl-themed-page .nl-view-body .nl-stock-row-actions summary{background:#fff4e7;min-height:35px}
@media(max-width:780px){.nl-themed-page .nl-view-body .section-head>form.search{flex-basis:100%;justify-content:flex-start}.nl-themed-page .nl-view-body .section-head>form.search :is(input,select){max-width:none}}

/* Boardroom v5: consistent list, filter, and form interaction design across all seven modules. */
.nl-themed-page[data-nl-screen] .nl-view-body {min-width:0;}
.nl-themed-page :is(.card,.section-card,.panel,.summary-callout) {scroll-margin-top:106px;}
.nl-themed-page .nl-view-body :is(.card,.section-card,.panel,.summary-callout) {border-radius:18px;}
.nl-themed-page .nl-view-body :is(.card,.section-card) {transition:box-shadow .25s ease,border-color .25s ease;}
.nl-themed-page .nl-view-body :is(.card,.section-card):hover {box-shadow:0 13px 32px rgba(84,49,22,.10);}
.nl-themed-page :is(button,.btn,a,select,input,textarea):focus-visible {outline:3px solid rgba(236,127,51,.60);outline-offset:2px;}
.nl-themed-page .table-responsive {position:relative;max-width:100%;overflow-x:auto;overscroll-behavior-inline:contain;scrollbar-width:thin;}
.nl-themed-page .table {font-variant-numeric:tabular-nums;}
.nl-themed-page .table thead th {position:sticky;top:0;z-index:1;border-bottom:2px solid #ecd3bb!important;}
.nl-themed-page .table tbody tr {transition:background-color .18s ease,box-shadow .18s ease;}
.nl-themed-page .table tbody tr:hover>* {--bs-table-bg-state:#fff0df!important;}
.nl-themed-page .table td :is(.btn,button) {max-width:100%;}
.nl-themed-page .nl-table-toolbar {background:linear-gradient(116deg,#fffbf7,#fff1e4)!important;border:1px solid #f0d8c0!important;border-radius:15px!important;}
.nl-themed-page .nl-table-search {min-width:175px;max-width:none;}
.nl-themed-page .nl-table-pagination {background:#fffdfa!important;border:1px solid #efdfd1;border-radius:14px;}
.nl-themed-page .nl-table-pagination :is(button,select) {min-height:39px;}
.nl-themed-page .nl-table-empty {border-radius:13px;padding:1.2rem 1.4rem;}
.nl-themed-page .nl-view-body .form-label {font-weight:700;letter-spacing:-.008em;}
.nl-themed-page .nl-view-body input:not([type=hidden]),.nl-themed-page .nl-view-body select,.nl-themed-page .nl-view-body textarea {transition:border-color .2s ease,box-shadow .2s ease,background-color .2s ease;}
.nl-themed-page .nl-view-body input:not([type=hidden]):focus,.nl-themed-page .nl-view-body select:focus,.nl-themed-page .nl-view-body textarea:focus {box-shadow:0 0 0 4px rgba(244,145,71,.15)!important;}
.nl-themed-page .nl-view-body .btn:not(.nl-sort-head) {transition:transform .17s ease,box-shadow .17s ease,background-color .17s ease;}
.nl-themed-page .nl-view-body .btn:not(.nl-sort-head):hover:not(:disabled) {transform:translateY(-1px);box-shadow:0 6px 14px rgba(95,46,15,.11);}
.nl-themed-page .nl-field-feedback {font-size:.73rem;color:#8b624a;min-height:1rem;display:block;margin-top:.35rem;}
.nl-themed-page .nl-form-wait {opacity:.77;cursor:progress!important;}
.nl-themed-page .nl-form-note {border-left:3px solid #d96422;background:#fff1e3;border-radius:8px;padding:.65rem .85rem;color:#70432c;margin-top:.75rem;}
.nl-themed-page .nl-section-index {display:flex;flex-wrap:wrap;gap:8px;margin-bottom:18px;}
.nl-themed-page .nl-section-index a {font-size:.78rem;border:1px solid #efd2b5;border-radius:100px;padding:7px 12px;background:#fff7ef;color:#874115;text-decoration:none;font-weight:700;}
.nl-themed-page .nl-section-index a:hover {background:#fbdfc2;}
@media (max-width:760px) {.nl-themed-page .nl-table-toolbar {align-items:stretch;}.nl-themed-page .nl-table-filters {width:100%;}.nl-themed-page .nl-table-search {width:100%;}.nl-themed-page .table-responsive {scrollbar-width:auto;}}
@media (prefers-reduced-motion:reduce) {.nl-themed-page .nl-view-body :is(.card,.btn,.section-card),.nl-themed-page .table tbody tr {transition:none!important;transform:none!important;}}


/* Module 5 — full / partial payment workspace and confirm-review QoL */
.nl-themed-page .nl-payment-workspace {border:1px solid #ecd6bd!important;overflow:hidden;}
.nl-themed-page .nl-payment-heading{display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;margin-bottom:1.25rem;}
.nl-themed-page .nl-payment-heading h3{font-size:clamp(1.35rem,2vw,1.8rem);margin:.25rem 0 .45rem;font-weight:800;letter-spacing:-.025em;}
.nl-themed-page .nl-payment-eyebrow{font-size:.69rem;font-weight:850;letter-spacing:.16em;color:#b34d18;}
.nl-themed-page .nl-payment-invoice-pill{background:#fff2e3;border:1px solid #ebcfb1;border-radius:999px;padding:.42rem .85rem;color:#8d3b16;font-weight:750;font-size:.77rem;overflow-wrap:anywhere;max-width:100%;}
.nl-themed-page .nl-payment-balance-overview{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:.7rem;margin-bottom:.55rem;}
.nl-themed-page .nl-payment-balance-overview>div{display:flex;flex-direction:column;gap:.35rem;background:#fdf8f3;border:1px solid #f0dfce;border-radius:13px;padding:1rem;min-width:0;}
.nl-themed-page .nl-payment-balance-overview span{font-size:.78rem;color:#796758;}
.nl-themed-page .nl-payment-balance-overview strong{font-size:clamp(1rem,2vw,1.4rem);color:#3e2d23;font-variant-numeric:tabular-nums;overflow-wrap:anywhere;}
.nl-themed-page .nl-payment-balance-overview .nl-payment-due{background:#fff0dd;border-color:#efcaa9;}
.nl-themed-page .nl-payment-balance-overview .nl-payment-due strong{color:#a84315;}
.nl-themed-page .nl-payment-progress{height:7px;border-radius:999px;background:#f0e5d7;overflow:hidden;margin:0 0 1.45rem;}
.nl-themed-page .nl-payment-progress-fill{height:100%;border-radius:999px;background:linear-gradient(90deg,#b94719,#ea8e47);transition:width .3s ease;}
.nl-themed-page #recordPaymentForm .nl-payment-modes{grid-column:1/-1;border:0;margin:0;padding:0;min-width:0;}
.nl-themed-page #recordPaymentForm .nl-payment-modes legend{font-size:.89rem;font-weight:780;margin-bottom:.65rem;float:none;}
.nl-themed-page .nl-payment-mode-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:.85rem;}
.nl-themed-page .nl-payment-mode-option{display:flex;align-items:center;gap:.75rem;padding:1rem;border:2px solid #e8d9c8;border-radius:15px;cursor:pointer;background:#fffdfb;transition:background .18s,border-color .18s,box-shadow .18s,transform .18s;min-width:0;}
.nl-themed-page .nl-payment-mode-option:hover{border-color:#e7a471;transform:translateY(-2px);}
.nl-themed-page .nl-payment-mode-option span:last-child{display:flex;flex-direction:column;gap:.2rem;min-width:0;}
.nl-themed-page .nl-payment-mode-option strong{font-size:.96rem;color:#382c23;}
.nl-themed-page .nl-payment-mode-option small{font-size:.77rem;color:#736355;font-weight:450;line-height:1.4;}
.nl-themed-page .nl-payment-mode-mark{width:20px;height:20px;border:2px solid #cbb6a2;border-radius:50%;flex:0 0 auto;position:relative;}
.nl-themed-page .nl-payment-mode-grid input:checked+.nl-payment-mode-option{background:linear-gradient(120deg,#fff6ea,#ffecda);border-color:#cc6126;box-shadow:0 7px 18px rgba(155,70,23,.09);}
.nl-themed-page .nl-payment-mode-grid input:checked+.nl-payment-mode-option .nl-payment-mode-mark{border-color:#bd4b17;}
.nl-themed-page .nl-payment-mode-grid input:checked+.nl-payment-mode-option .nl-payment-mode-mark::after{content:"";position:absolute;inset:4px;border-radius:50%;background:#bd4b17;}
.nl-themed-page .nl-payment-mode-grid input:focus-visible+.nl-payment-mode-option{outline:3px solid #de833f;outline-offset:3px;}
.nl-themed-page #recordPaymentForm input[readonly]{background:#faf1e7;color:#703915;font-weight:750;}
.nl-themed-page #recordPaymentForm .nl-partial-shortcuts{grid-column:1/-1;display:flex;align-items:center;flex-wrap:wrap;gap:.45rem .65rem;padding:.65rem .75rem;background:#fffaf4;border:1px dashed #dfbea0;border-radius:12px;font-size:.81rem;}
.nl-themed-page #recordPaymentForm .nl-partial-shortcuts[hidden]{display:none!important;}
.nl-themed-page .nl-amount-chip{background:#fff;border:1px solid #d9b798;border-radius:999px;padding:.3rem .7rem;color:#a0471b;font-weight:770;transition:background .15s;}
.nl-themed-page .nl-amount-chip:hover{background:#ffe6d0;}
.nl-themed-page .nl-payment-help{color:#736558;font-size:.77rem;}
.nl-themed-page #recordPaymentForm .nl-payment-live-summary{grid-column:1/-1;display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:.6rem;}
.nl-themed-page .nl-payment-live-summary>div{display:flex;flex-direction:column;gap:.3rem;padding:.8rem 1rem;border-radius:12px;background:#fff7ed;border:1px solid #eadac9;min-width:0;}
.nl-themed-page .nl-payment-live-summary span{font-size:.75rem;color:#79675b;}
.nl-themed-page .nl-payment-live-summary strong{font-variant-numeric:tabular-nums;font-size:1.05rem;overflow-wrap:anywhere;}
.nl-themed-page .nl-payment-inline-error{grid-column:1/-1;background:#fff1ee;color:#8a2012;border:1px solid #edbeb3;border-radius:9px;margin:0;padding:.7rem 1rem;font-weight:650;}
.nl-themed-page .nl-payment-inline-error[hidden]{display:none!important;}
.nl-themed-page #recordPaymentForm .nl-payment-submit-row{grid-column:1/-1;display:flex;justify-content:space-between;align-items:center;gap:1.1rem;flex-wrap:wrap;margin-top:.35rem;}
.nl-themed-page .nl-payment-submit-row p{margin:0;max-width:650px;font-size:.79rem;color:#77685f;}
.nl-themed-page #recordPaymentForm .nl-payment-submit-row button{min-height:46px;padding:.65rem 1.4rem;font-weight:780;}
.nl-themed-page .nl-payment-receipt{border-left:5px solid #3f9b68;}
.nl-themed-page .nl-payment-receipt a{font-weight:700;}
@media(max-width:900px){.nl-themed-page #recordPaymentForm .nl-payment-mode-grid{grid-template-columns:1fr;}}
@media(max-width:650px){.nl-themed-page .nl-payment-balance-overview,.nl-themed-page #recordPaymentForm .nl-payment-live-summary{grid-template-columns:1fr;}.nl-themed-page #recordPaymentForm .nl-payment-submit-row button{width:100%;}}
@media(prefers-reduced-motion:reduce){.nl-themed-page .nl-payment-mode-option,.nl-themed-page .nl-payment-progress-fill{transition:none!important;}}


/* V11: consistent dropdown cues, desktop collapse and gentle navigation. */
body.nl-themed-page select:not([multiple]):not([size]),body.nl-auth-page select:not([multiple]):not([size]){appearance:none;-webkit-appearance:none;padding-right:2.5rem!important;background-color:#fffdfa!important;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='20' height='20' fill='none' stroke='%23aa4a16' stroke-width='2.2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='m5 8 5 5 5-5'/%3E%3C/svg%3E")!important;background-size:18px 18px!important;background-position:right 12px center!important;background-repeat:no-repeat!important}
.nl-themed-page .nl-view-body details>summary{cursor:pointer;list-style:none;display:flex;align-items:center;gap:8px}
.nl-themed-page .nl-view-body details>summary::-webkit-details-marker{display:none}
.nl-themed-page .nl-view-body details>summary::after{content:'';display:inline-block;flex:none;width:8px;height:8px;border-right:2px solid #ad510f;border-bottom:2px solid #ad510f;transform:rotate(45deg);margin-left:auto;margin-right:4px;margin-top:-4px;transition:transform .2s ease}
.nl-themed-page .nl-view-body details[open]>summary::after{transform:rotate(225deg);margin-top:4px}
@media(min-width:992px){body.nl-sidebar-collapsed .nl-side-footer{display:block!important;padding:12px 0 0!important}body.nl-sidebar-collapsed .nl-side-signed{display:none!important}body.nl-sidebar-collapsed .nl-side-logout{font-size:.68rem;text-align:center;padding:9px 3px;min-height:40px;line-height:1.1;border-radius:9px}}
@keyframes nlViewV11{from{opacity:.75;transform:translateY(7px)}to{opacity:1;transform:translateY(0)}}
body.nl-themed-page .nl-view-body{animation:nlViewV11 .28s ease-out both}
@media(prefers-reduced-motion:reduce){body.nl-themed-page .nl-view-body{animation:none!important}}


/* Subtle original cargo-and-wave motion on booking confirmation; no network assets. */
.nl-themed-page .nl-booking-success{position:relative;isolation:isolate;overflow:hidden}
.nl-themed-page .nl-booking-success::before{content:"";position:absolute;right:0;bottom:-18px;width:180px;height:90px;z-index:-1;opacity:.32;background:repeating-radial-gradient(ellipse at 70% 120%,transparent 0 13px,#fbd4a6 14px 16px,transparent 17px 26px);animation:nlCargoWave 15s linear infinite;pointer-events:none}
.nl-themed-page .nl-booking-success::after{content:"";position:absolute;right:60px;bottom:24px;width:80px;height:34px;z-index:-1;opacity:.5;background:linear-gradient(#ffdba9 0 0) 35px 0/30px 17px no-repeat,linear-gradient(#f7bd72 0 0) 11px 12px/55px 10px no-repeat,linear-gradient(#ffebca 0 0) 0 19px/80px 15px no-repeat;clip-path:polygon(32% 0,65% 0,65% 35%,82% 35%,100% 58%,88% 100%,14% 100%,0 58%,10% 43%,32% 43%);animation:nlCargoBoat 8s ease-in-out infinite;pointer-events:none}
@keyframes nlCargoWave{from{background-position:0 0}to{background-position:130px 0}}
@keyframes nlCargoBoat{0%,100%{transform:translateX(0) rotate(-1deg)}50%{transform:translateX(-20px) rotate(2deg)}}
@media(prefers-reduced-motion:reduce){.nl-themed-page .nl-booking-success::before,.nl-themed-page .nl-booking-success::after{animation:none!important}}

/* V12 account editor and desktop navigation: no dark overlay when sidebar collapses. */
@media(min-width:992px){body.nl-sidebar-collapsed .offcanvas-backdrop{display:none!important}body.nl-sidebar-collapsed #nlMobileNav{display:none!important}}
.nl-account-modal .modal-dialog{max-width:780px}
.nl-account-modal .modal-content{border:1px solid #e8cdb4;border-radius:22px;overflow:hidden;box-shadow:0 28px 90px #2f1b113b}
.nl-account-modal .modal-body .form-control,.nl-account-modal .modal-body .form-select{min-height:46px}
.nl-account-modal .modal-header{background:linear-gradient(115deg,#fff1df,#fff9f3)}

/* Desktop nav collapse should never create an offcanvas scrim. */
@media(min-width:992px){.offcanvas-backdrop{display:none!important}#nlMobileNav{display:none!important}body.menu-open:before,body.menu-open:after{pointer-events:none!important}body.nl-sidebar-collapsed .nl-side-logout{display:block!important}}

/* v17 administration/operations-wide polish, in existing JSP only */
:root{--nl-label-required:#bd381e}
.nl-themed-page h1,.nl-themed-page h2,.nl-themed-page .panel-title{letter-spacing:-.035em;font-weight:850}
.nl-themed-page a,.nl-themed-page button,.nl-themed-page .btn,.nl-themed-page summary{transition:transform .17s ease,box-shadow .17s ease,background-color .17s ease,border-color .17s ease}
.nl-themed-page .btn:hover:not(:disabled),.nl-themed-page button:hover:not(:disabled){box-shadow:0 6px 19px rgba(174,75,26,.16)}
.nl-themed-page .card:hover{border-color:#e9b28c!important}
.nl-themed-page input,.nl-themed-page select,.nl-themed-page textarea{max-width:100%;min-width:0}
.nl-themed-page .form-label:has(+[required]),.nl-themed-page label:has(>input[required]){font-weight:760}
.nl-required,.nl-required-top{float:none!important;display:inline!important;color:var(--nl-label-required)!important;background:none!important;border:0!important;border-radius:0!important;padding:0!important;font-weight:900!important;margin:0 0 0 3px!important;white-space:nowrap;vertical-align:baseline!important;line-height:inherit!important}
.nl-field-invalid{border-color:#be3e27!important;box-shadow:0 0 0 3px rgba(190,62,39,.12)!important}
.nl-field-warning{position:fixed;top:100px;right:18px;max-width:min(400px,calc(100vw - 28px));z-index:2001;border-radius:18px;border:1px solid #e8b59a;border-left:5px solid #c95318;background:#fff9f3;color:#422d1f;padding:16px;box-shadow:0 16px 44px #421d0d35;animation:nlWarningIn .24s ease both}
.nl-field-warning strong{display:block;font-weight:900;color:#a34317}.nl-field-warning p{margin:.35rem 0;color:#795647}.nl-field-warning button{background:#cb5317;border:0;color:#fff;font-weight:800;padding:7px 16px;border-radius:10px}
@keyframes nlWarningIn{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
.nl-auto-hero.d-flex{display:grid!important}.nl-auto-hero{margin:0 0 18px;padding:21px 24px;border:1px solid #eed0b5;border-radius:22px;background:linear-gradient(117deg,#fffdf9,#fff2e5 72%,#ffe4ca);box-shadow:0 15px 32px #613d2114;display:grid;grid-template-columns:minmax(0,1fr) 215px;gap:16px;align-items:center;min-height:142px;position:relative;overflow:hidden}
.nl-auto-hero .nl-auto-copy{position:relative;z-index:2}.nl-auto-hero small{font-size:.71rem;text-transform:uppercase;letter-spacing:.16em;color:#a95124;font-weight:850}.nl-auto-hero h1{margin:5px 0 7px;font-size:clamp(1.55rem,2.5vw,2.2rem);font-weight:900;color:#35251e}.nl-auto-hero p{margin:0;color:#735849;line-height:1.4;font-size:.9rem;max-width:660px}
.nl-auto-art{position:relative;width:198px;height:132px;justify-self:end;isolation:isolate;overflow:hidden;border-radius:55px;background:radial-gradient(circle,#fff9f4 3%,#ffe8d2 71%,transparent 74%);border:1px solid #f5d8bd;display:grid;place-items:center}
.nl-auto-art:before{content:"";position:absolute;width:120px;height:72px;border:4px solid #c2672b;border-radius:14px;background:repeating-linear-gradient(90deg,#ffc18c 0 19px,#f19d58 19px 27px);box-shadow:9px 11px 0 #b861271f;animation:nlCargoFloat 5s ease-in-out infinite}
.nl-auto-art:after{content:"";position:absolute;top:17px;right:20px;width:34px;height:34px;border:4px solid #c2672b;border-radius:50%;background:conic-gradient(#dc7023 0 44%,#fff0dc 44% 100%);animation:nlCargoSpin 12s linear infinite}
.nl-auto-hero[data-family="stock"] .nl-auto-art:before{border-radius:5px;transform:rotate(-5deg)}
.nl-auto-hero[data-family="billing"] .nl-auto-art:before{width:90px;height:110px;background:linear-gradient(#fffefa,#fff0de);border-radius:10px;box-shadow:9px 10px 0 #b861271f}
.nl-auto-hero[data-family="claims"] .nl-auto-art:before{width:88px;height:104px;background:repeating-linear-gradient(#fffefa 0 17px,#f9e3ca 17px 20px);border-radius:13px}
.nl-auto-hero[data-family="analytics"] .nl-auto-art:before{background:repeating-linear-gradient(90deg,#ffc18c 0 14px,#ef984f 14px 24px);border-radius:9px 9px 2px 2px}
@keyframes nlCargoFloat{0%,100%{translate:0 0}50%{translate:0 -6px}}
@keyframes nlCargoSpin{from{rotate:0deg}to{rotate:360deg}}
@media(max-width:1100px){.nl-auto-hero{grid-template-columns:minmax(0,1fr) 145px;gap:10px}.nl-auto-art{width:135px;height:112px}}
@media(max-width:740px){.nl-auto-hero{grid-template-columns:1fr;padding:18px;min-height:0}.nl-auto-hero .nl-auto-art{display:none}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{scroll-behavior:auto!important}.nl-auto-hero *{animation:none!important}.nl-auto-art:before,.nl-auto-art:after{animation:none!important}}


.nl-pay-reminder{display:inline-flex;align-items:center;gap:8px;padding:9px 13px;border:1px solid #ffbf77;border-radius:999px;background:linear-gradient(115deg,#fff7df,#ffbe79);color:#702f0d;text-decoration:none;font-size:.79rem;box-shadow:0 4px 12px #5a230a36;animation:nlPayAttention 5.5s ease-in-out infinite;white-space:nowrap;transition:transform .2s,box-shadow .2s}
.nl-pay-reminder:hover{transform:translateY(-2px);box-shadow:0 9px 24px #e7934538;color:#702f0d}
.nl-pay-reminder-dot{width:9px;height:9px;flex:none;border-radius:50%;background:#c74912;box-shadow:0 0 0 4px #ffe5c1}
.nl-pay-reminder small{font-size:.72rem;color:#81512c}
@keyframes nlPayAttention{0%,86%,100%{box-shadow:0 4px 12px #5a230a36}90%{box-shadow:0 0 0 6px #fff0cb77,0 4px 12px #5a230a36}}
@media(max-width:1240px){.nl-pay-reminder small{display:none}}
@media(max-width:680px){.nl-pay-reminder{padding:8px 10px;font-size:.72rem;white-space:normal;text-align:center;max-width:145px}.nl-pay-reminder-dot{display:none}}
@media(prefers-reduced-motion:reduce){.nl-pay-reminder{animation:none!important;transition:none!important}}


/* v19.4: theme isolation/contrast follow-up. All selectors here are explicitly DARK-only.
 * The v19.3 module-specific comma lists were independently repaired so no dark
 * component rule can affect Light Mode. Keep this block intentionally small. */
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details[open] > summary {
  background:#263c53!important;
  background-image:none!important;
  color:#f5f8fd!important;
  border-color:#63809a!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:focus-visible {
  background:#34516b!important;
  color:#fff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu {
  background:#23374b!important;
  color:#f0f5fb!important;
  border-color:#607a91!important;
  box-shadow:0 18px 40px rgba(1,9,21,.4)!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label {
  color:#e9f1fa!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label:hover {
  background:#36516b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu input[type="checkbox"]{
  accent-color:#ff964f;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-status-chip,.nl-dash-panel .badge,.nl-dash-panel .nl-status-count) {
  background:#2b4057!important;
  color:#f0f5fc!important;
  border-color:#59738b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip :is(span,strong,b) {
  color:#f0f5fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger {
  background:#442d32!important;
  color:#ffd9d8!important;
  border-color:#bd7774!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger:hover {
  background:#583338!important;
  color:#fff0ed!important;
  border-color:#ed9c94!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:disabled {
  background:#334053!important;
  color:#b8c5d3!important;
  border-color:#53657b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons .nl18-table-status{
  color:#bbcbdb!important;
}
</style>

<style>
/* Accessible N-LOGISTIC confirmation dialog, independent of browser theme and Bootstrap. */
.nl-safe-confirm[hidden]{display:none!important}.nl-safe-confirm{position:fixed;inset:0;z-index:22000;background:rgba(27,17,12,.54);display:flex;align-items:center;justify-content:center;padding:16px;backdrop-filter:blur(3px)}
.nl-safe-confirm-card{width:min(100%,490px);background:#fffaf4;border:1px solid #ecc5a7;border-radius:20px;box-shadow:0 30px 90px #24151065;padding:28px;color:#38271e;animation:nl-confirm-in .2s ease both}
.nl-confirm-label{color:#b44b13;letter-spacing:.13em;font-size:.69rem;font-weight:850}.nl-safe-confirm-card h2{font-weight:850;font-size:1.35rem;margin:12px 0}.nl-safe-confirm-card p{color:#715645;font-size:.97rem;line-height:1.55}
.nl-safe-confirm-actions{display:flex;justify-content:flex-end;gap:9px;margin-top:24px}.nl-safe-confirm-actions button{border-radius:10px;padding:11px 17px;font-weight:750;border:1px solid #e7c6af;background:#fff4e9;color:#804221}.nl-safe-confirm-actions button:last-child{background:#c44b0d;color:white;border-color:#c44b0d}
.nl-safe-confirm-actions button:focus-visible{outline:3px solid #e68b51;outline-offset:2px}
@keyframes nl-confirm-in{from{opacity:0;transform:translateY(10px) scale(.98)}to{opacity:1;transform:none}}
@media(max-width:520px){.nl-safe-confirm-card{padding:21px}.nl-safe-confirm-actions{flex-wrap:wrap}.nl-safe-confirm-actions button{flex:1}}
@media(prefers-reduced-motion:reduce){.nl-safe-confirm-card{animation:none}}
/* N-LOGISTIC v17.3: single-header policy and page-specific illustrated scenes. No asset files. */
.nl-themed-page .nl-screen-hero{display:grid;grid-template-columns:minmax(0,1fr) 218px;grid-template-rows:auto auto;gap:8px 18px;align-items:center;padding:21px 25px!important;margin:0 0 18px!important;border:1px solid #eecdb1!important;border-radius:22px!important;background:linear-gradient(116deg,#fffdf9 0%,#fff4e8 67%,#ffe7d0 100%)!important;box-shadow:0 14px 32px #68412715!important;position:relative;overflow:hidden!important;isolation:isolate;max-width:100%}
.nl-themed-page .nl-screen-hero:before{content:"";position:absolute;right:-52px;top:-80px;width:240px;height:240px;border:1px solid #eba96946;border-radius:50%;box-shadow:0 0 0 26px #f3bb8f26,0 0 0 55px #f7c9a721;z-index:0;pointer-events:none}
.nl-themed-page .nl-screen-hero>div:not(.nl-scene-art),.nl-themed-page .nl-screen-hero>h1,.nl-themed-page .nl-screen-hero>p,.nl-themed-page .nl-screen-hero>small{position:relative;z-index:1}
.nl-themed-page .nl-screen-hero h1{font-size:clamp(1.65rem,2.55vw,2.32rem)!important;line-height:1.15;font-weight:900;letter-spacing:-.04em;margin:5px 0 9px!important;color:#35261f!important}
.nl-themed-page .nl-screen-hero p{font-size:.89rem;line-height:1.55;color:#73594a!important;max-width:670px;margin-bottom:0}
.nl-themed-page .nl-screen-hero .heading-actions{display:flex!important;gap:9px!important;flex-wrap:wrap;align-items:center;justify-content:flex-start!important;grid-column:1;grid-row:2;position:relative;z-index:3;margin:6px 0 0!important}
.nl-themed-page .nl-screen-hero .heading-actions a,.nl-themed-page .nl-screen-hero .heading-actions button{min-height:38px;display:inline-flex;justify-content:center;align-items:center;white-space:nowrap}
.nl-themed-page .nl-screen-hero.page-heading>div:first-child{grid-column:1;grid-row:1}
.nl-themed-page .nl-screen-hero.page-heading>.nl-scene-art{grid-column:2;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero.nl-shared-page-header>h1{grid-column:1;grid-row:1;align-self:end}
.nl-themed-page .nl-screen-hero.nl-shared-page-header>p{grid-column:1;grid-row:2;align-self:start}
.nl-themed-page .nl-screen-hero.nl-shared-page-header>.nl-scene-art{grid-column:2;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero.a-hero>.a-hero-copy,.nl-themed-page .nl-screen-hero.nl-user-hero>div:first-child{grid-column:1;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero.a-hero>.nl-scene-art{grid-column:2;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero .nl-scene-art{grid-column:2;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero.nl-auto-hero>.nl-auto-copy{grid-column:1;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero:not(.nl-shared-page-header):not(.page-heading):not(.nl-auto-hero)>h1{grid-column:1;grid-row:1}
.nl-themed-page .nl-screen-hero:not(.nl-shared-page-header):not(.page-heading):not(.nl-auto-hero)>p{grid-column:1;grid-row:2}
.nl-themed-page .nl-screen-hero a:focus-visible{outline:3px solid #c85a19;outline-offset:3px}
.nl-themed-page .nl-screen-hero .btn:hover:not(:disabled),.nl-themed-page .nl-screen-hero button:hover:not(:disabled){transform:translateY(-2px);box-shadow:0 8px 22px #bf551f24}
.nl-themed-page .nl-screen-hero~.card:first-of-type{scroll-margin-top:92px}

.nl-scene-art{width:206px;height:148px;position:relative;justify-self:end;align-self:center;pointer-events:none;overflow:hidden;isolation:isolate;border-radius:44px;border:1px solid #efcdad;background:radial-gradient(circle at 54% 47%,#fffef9 5%,#ffe4ce 69%,#ffd8b8 100%);filter:drop-shadow(0 9px 14px #8b43131b);--scene-ink:#9c4a23;--scene-fill:#f2a062;--scene-paper:#fff9ee;--scene-time:5.2s}
.nl-scene-art:after{content:"";position:absolute;inset:12px;border-radius:50%;border:1px solid #d88d4c32;box-shadow:0 0 0 18px #ffcda21d}
.nl-scene-art>span{display:block;position:absolute;box-sizing:border-box;z-index:2}
.nl-scene-art .nl-scene-plate{left:42px;top:32px;width:125px;height:86px;border-radius:13px;border:3px solid var(--scene-ink);background:var(--scene-fill);box-shadow:8px 9px 0 #ae683526;animation:nlSceneFloat var(--scene-time) ease-in-out infinite}
.nl-scene-art .nl-scene-shape{left:68px;top:48px;width:70px;height:51px;border-radius:8px;background:var(--scene-paper);border:2px solid #b56837}
.nl-scene-art .nl-scene-detail{left:52px;top:59px;width:104px;height:3px;background:#fff4e3;box-shadow:0 10px #fff4e3,0 20px #fff4e3}
.nl-scene-art .nl-scene-spark{left:25px;top:26px;width:12px;height:12px;border-radius:4px;background:#ea985c;transform:rotate(45deg);animation:nlSceneTwinkle 4s ease-in-out infinite}
.nl-scene-art .nl-scene-line{right:23px;bottom:17px;width:48px;height:6px;border-radius:99px;background:#c26c32;box-shadow:0 8px 0 #ebae80}
@keyframes nlSceneFloat{0%,100%{transform:translate(0,0)}50%{transform:translate(0,-7px)}}
@keyframes nlSceneTwinkle{0%,100%{opacity:.85;transform:rotate(45deg) scale(1)}50%{opacity:.4;transform:rotate(45deg) scale(.6)}}
@keyframes nlSceneSail{0%,100%{transform:translateX(-4px) rotate(-2deg)}50%{transform:translateX(12px) rotate(2deg)}}
@keyframes nlScenePulse{0%,100%{transform:scale(1)}50%{transform:scale(1.08)}}
@keyframes nlSceneSlide{0%,100%{transform:translateX(-4px)}50%{transform:translateX(9px)}}
@keyframes nlSceneTilt{0%,100%{transform:rotate(-6deg)}50%{transform:rotate(5deg)}}
@keyframes nlSceneRise{0%,100%{transform:scaleY(.82);transform-origin:bottom}50%{transform:scaleY(1);transform-origin:bottom}}
@keyframes nlSceneOrbit{from{transform:rotate(0deg)}to{transform:rotate(360deg)}}
@keyframes nlSceneCheck{0%,100%{transform:scale(1) rotate(-2deg)}50%{transform:scale(1.09) rotate(3deg)}}
@keyframes nlSceneBounce{0%,100%{transform:translateY(0) rotate(-4deg)}50%{transform:translateY(-9px) rotate(-4deg)}}
@keyframes nlSceneSwipe{0%,100%{transform:translateX(0) rotate(-4deg)}50%{transform:translateX(9px) rotate(4deg)}}

/* People: distinct avatar + ID card for Users and Customers */
.nl-scene-art[data-nl-motif="people"] .nl-scene-plate{left:44px;top:27px;width:124px;height:95px;background:linear-gradient(145deg,#fffdf7,#ffe0c1);border-radius:14px;transform:rotate(-4deg);animation:nlSceneBounce var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="people"] .nl-scene-shape{left:60px;top:44px;width:36px;height:36px;border-radius:50%;background:#e58a47;border:2px solid #a54b22;box-shadow:0 31px 0 3px #e58a47}
.nl-scene-art[data-nl-motif="people"] .nl-scene-detail{left:108px;top:51px;width:41px;height:4px;background:#cd925e;box-shadow:0 11px #e6bb8f,0 22px #e6bb8f}
.nl-scene-art[data-nl-motif="people"] .nl-scene-line{right:24px;bottom:22px;width:25px;height:25px;border-radius:50%;background:#fff5ea;border:3px solid #bd5c2b;box-shadow:0 0 0 5px #ffe0c2}
/* Company skyscraper and warehouse */
.nl-scene-art[data-nl-motif="building"] .nl-scene-plate{left:65px;top:29px;width:96px;height:100px;border-radius:6px 6px 1px 1px;background:repeating-linear-gradient(90deg,#f0a267 0 18px,#ffd7ad 18px 25px);animation:nlSceneRise var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="building"] .nl-scene-shape{left:25px;top:70px;width:51px;height:58px;border-radius:4px;background:repeating-linear-gradient(0deg,#f0ae73 0 13px,#ffd2a6 13px 18px)}
.nl-scene-art[data-nl-motif="building"] .nl-scene-detail{left:83px;top:101px;width:15px;height:28px;background:#9b4923;box-shadow:0 0 #fff}
/* Magnifying glass, audit or inspection */
.nl-scene-art[data-nl-motif="audit"] .nl-scene-plate{left:41px;top:29px;width:116px;height:102px;background:repeating-linear-gradient(#fffefa 0 17px,#f5d8b7 17px 21px);transform:rotate(-6deg);animation:nlSceneTilt var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="audit"] .nl-scene-shape{left:111px;top:53px;width:49px;height:49px;border-radius:50%;border:7px solid #b65b2a;background:#fffaf2;box-shadow:0 0 0 5px #ffe0c0}
.nl-scene-art[data-nl-motif="audit"] .nl-scene-line{right:19px;bottom:17px;width:53px;height:11px;background:#9d4821;transform:rotate(46deg)}
/* Maritime: hull, cabin and moving waves */
.nl-scene-art[data-nl-motif="ship"] .nl-scene-plate{left:35px;top:80px;width:144px;height:39px;border-radius:8px 8px 30px 30px;clip-path:polygon(0 8%,100% 0,87% 100%,15% 100%);background:linear-gradient(#f1a66c,#d5691e);animation:nlSceneSail var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="ship"] .nl-scene-shape{left:78px;top:54px;width:78px;height:28px;background:repeating-linear-gradient(90deg,#ffd3a5 0 18px,#e69b60 18px 24px);border-radius:4px}
.nl-scene-art[data-nl-motif="ship"] .nl-scene-detail{left:50px;top:121px;width:137px;height:5px;border-radius:99px;background:repeating-linear-gradient(90deg,#d79053 0 9px,transparent 9px 18px);box-shadow:0 0}
/* Ports: quay crane lifting a cargo box */
.nl-scene-art[data-nl-motif="port"] .nl-scene-plate{left:45px;top:35px;width:8px;height:98px;border:0;background:#a6562a;box-shadow:94px 0 #a6562a;animation:none}
.nl-scene-art[data-nl-motif="port"] .nl-scene-shape{left:38px;top:30px;width:126px;height:7px;border:0;background:#b46535;box-shadow:0 0}
.nl-scene-art[data-nl-motif="port"] .nl-scene-detail{left:113px;top:39px;width:4px;height:52px;background:#be865f;box-shadow:0 0}
.nl-scene-art[data-nl-motif="port"] .nl-scene-line{left:92px;top:87px;width:50px;height:37px;border:3px solid #a35427;border-radius:4px;background:repeating-linear-gradient(90deg,#f5b477 0 7px,#e89756 7px 15px);animation:nlSceneFloat var(--scene-time) ease-in-out infinite}
/* Route tracking: dotted journey and waypoints */
.nl-scene-art[data-nl-motif="route"] .nl-scene-plate{left:29px;top:75px;width:145px;height:7px;border:0;border-radius:0;background:repeating-linear-gradient(90deg,#b76a38 0 12px,transparent 12px 22px);box-shadow:none;animation:none}
.nl-scene-art[data-nl-motif="route"] .nl-scene-shape{left:33px;top:65px;width:27px;height:27px;border-radius:50%;background:#fffaf2;border:5px solid #c46932;box-shadow:110px 0 0 -1px #fffaf2,110px 0 0 4px #c46932}
.nl-scene-art[data-nl-motif="route"] .nl-scene-detail{left:88px;top:43px;width:31px;height:36px;background:linear-gradient(#ecaa71,#ca601e);clip-path:polygon(0 0,100% 0,100% 60%,50% 100%,0 60%);box-shadow:none;animation:nlSceneSlide var(--scene-time) ease-in-out infinite}
/* Finance/analytics: rising columns */
.nl-scene-art[data-nl-motif="report"] .nl-scene-plate,.nl-scene-art[data-nl-motif="finance"] .nl-scene-plate{left:35px;top:29px;width:144px;height:104px;background:linear-gradient(#fffdf7,#fff0df);border-radius:12px;animation:nlSceneFloat var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="report"] .nl-scene-shape,.nl-scene-art[data-nl-motif="finance"] .nl-scene-shape{left:58px;top:72px;width:21px;height:45px;border:0;border-radius:6px 6px 0 0;background:#e18a48;box-shadow:32px -19px #f4b474,64px -34px #cc5c22;animation:nlSceneRise var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="report"] .nl-scene-detail,.nl-scene-art[data-nl-motif="finance"] .nl-scene-detail{left:52px;top:51px;width:102px;height:4px;background:#e8bb91;box-shadow:0 0}
.nl-scene-art[data-nl-motif="finance"] .nl-scene-line{right:18px;bottom:10px;width:42px;height:42px;border-radius:50%;background:#fbd49b;border:3px solid #b86730;box-shadow:0 0;animation:nlScenePulse var(--scene-time) ease-in-out infinite}
/* Containers/stock: stacked cargo blocks */
.nl-scene-art[data-nl-motif="cargo"] .nl-scene-plate{left:45px;top:55px;width:90px;height:57px;background:repeating-linear-gradient(90deg,#efa364 0 13px,#f9c08a 13px 20px);border-radius:5px;animation:nlSceneSlide var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="cargo"] .nl-scene-shape{left:96px;top:35px;width:77px;height:48px;border-radius:4px;background:repeating-linear-gradient(90deg,#e79459 0 11px,#ffcd9b 11px 18px);box-shadow:5px 8px 0 #ad62272a;animation:nlSceneFloat calc(var(--scene-time) * 1.2) ease-in-out infinite}
.nl-scene-art[data-nl-motif="cargo"] .nl-scene-detail{left:31px;top:124px;width:154px;height:6px;border-radius:99px;background:#c77b45;box-shadow:0 0}
/* Paper: document, invoice, ledger or product label */
.nl-scene-art[data-nl-motif="invoice"] .nl-scene-plate,.nl-scene-art[data-nl-motif="ledger"] .nl-scene-plate,.nl-scene-art[data-nl-motif="product"] .nl-scene-plate,.nl-scene-art[data-nl-motif="import"] .nl-scene-plate,.nl-scene-art[data-nl-motif="price"] .nl-scene-plate{left:58px;top:18px;width:92px;height:122px;border-radius:6px 6px 13px 13px;background:repeating-linear-gradient(#fffdf6 0 17px,#f8e3c9 17px 21px);animation:nlSceneBounce var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="invoice"] .nl-scene-shape,.nl-scene-art[data-nl-motif="ledger"] .nl-scene-shape,.nl-scene-art[data-nl-motif="product"] .nl-scene-shape,.nl-scene-art[data-nl-motif="import"] .nl-scene-shape,.nl-scene-art[data-nl-motif="price"] .nl-scene-shape{left:118px;top:78px;width:57px;height:41px;border-radius:9px;background:#f1ab6b;transform:rotate(9deg);box-shadow:6px 7px 0 #b2672b22}
.nl-scene-art[data-nl-motif="invoice"] .nl-scene-detail,.nl-scene-art[data-nl-motif="ledger"] .nl-scene-detail,.nl-scene-art[data-nl-motif="product"] .nl-scene-detail,.nl-scene-art[data-nl-motif="import"] .nl-scene-detail,.nl-scene-art[data-nl-motif="price"] .nl-scene-detail{left:71px;top:46px;width:56px;height:5px;background:#dda777;box-shadow:0 13px #dda777,0 26px #dda777}
.nl-scene-art[data-nl-motif="price"] .nl-scene-line{right:23px;bottom:27px;width:46px;height:32px;border-radius:7px 7px 13px 13px;transform:rotate(-14deg);background:#db7d38;box-shadow:0 0;animation:nlSceneTilt var(--scene-time) ease-in-out infinite}
/* Payments/sales: card transaction */
.nl-scene-art[data-nl-motif="payment"] .nl-scene-plate,.nl-scene-art[data-nl-motif="sales"] .nl-scene-plate{left:32px;top:45px;width:148px;height:86px;border-radius:13px;background:linear-gradient(130deg,#eb9559,#bd5225);animation:nlSceneSwipe var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="payment"] .nl-scene-shape,.nl-scene-art[data-nl-motif="sales"] .nl-scene-shape{left:47px;top:71px;width:119px;height:16px;border:0;border-radius:0;background:linear-gradient(#8b461f,#b96439);box-shadow:0 0}
.nl-scene-art[data-nl-motif="payment"] .nl-scene-detail,.nl-scene-art[data-nl-motif="sales"] .nl-scene-detail{left:52px;top:100px;width:54px;height:5px;background:#ffdeae;box-shadow:0 0}
/* Claims: shield and document */
.nl-scene-art[data-nl-motif="claim"] .nl-scene-plate{left:40px;top:26px;width:92px;height:105px;border-radius:8px;background:repeating-linear-gradient(#fffdf7 0 16px,#f3dbc4 16px 21px);animation:nlSceneFloat var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="claim"] .nl-scene-shape{left:108px;top:59px;width:67px;height:70px;border-radius:16px 16px 30px 30px;background:linear-gradient(145deg,#eaa466,#c65d20);clip-path:polygon(50% 0,100% 17%,87% 78%,50% 100%,13% 78%,0 17%);border:3px solid #9d4b26;animation:nlSceneCheck var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="claim"] .nl-scene-detail{left:131px;top:89px;width:24px;height:11px;border-bottom:5px solid #fff4df;border-left:5px solid #fff4df;background:transparent;transform:rotate(-45deg);box-shadow:none}
/* Security: lock and key */
.nl-scene-art[data-nl-motif="security"] .nl-scene-plate{left:63px;top:68px;width:90px;height:66px;border-radius:13px;background:linear-gradient(#f3ab71,#ce6422);animation:nlScenePulse var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="security"] .nl-scene-shape{left:86px;top:30px;width:45px;height:62px;border-radius:24px 24px 7px 7px;background:transparent;border:9px solid #ac5a2f;box-shadow:none}
.nl-scene-art[data-nl-motif="security"] .nl-scene-detail{left:107px;top:95px;width:10px;height:24px;border-radius:8px;background:#fff3dd;box-shadow:none}
/* Search: lens and index cards */
.nl-scene-art[data-nl-motif="search"] .nl-scene-plate{left:40px;top:47px;width:110px;height:79px;border-radius:12px;background:#fff9ed;animation:nlSceneFloat var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="search"] .nl-scene-shape{left:104px;top:42px;width:53px;height:53px;border-radius:50%;border:7px solid #bd672e;background:#fff7ec;animation:nlScenePulse var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="search"] .nl-scene-line{right:23px;bottom:17px;width:61px;height:12px;transform:rotate(46deg);background:#ad5a2c;box-shadow:0 0}
/* Simple completion/checkpoint */
.nl-scene-art[data-nl-motif="check"] .nl-scene-plate{left:42px;top:37px;width:130px;height:91px;border-radius:15px;background:#fff5e6;animation:nlSceneFloat var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="check"] .nl-scene-shape{left:88px;top:55px;width:57px;height:58px;border-radius:50%;background:#d9742a;border:5px solid #b55421;animation:nlSceneCheck var(--scene-time) ease-in-out infinite}
.nl-scene-art[data-nl-motif="check"] .nl-scene-detail{left:99px;top:76px;width:36px;height:20px;border-left:6px solid #fff7ed;border-bottom:6px solid #fff7ed;background:none;transform:rotate(-45deg);box-shadow:none}
/* Unique variations: different motion, color, emphasis and composition for each subtab. */
.nl-scene-art[data-nl-scene="users"]{--scene-ink:#af4d21;--scene-time:3.7s;}
.nl-scene-art[data-nl-scene="users"] .nl-scene-spark{animation-delay:-0.0s;opacity:0.60;}
.nl-scene-art[data-nl-scene="users"] .nl-scene-shape{animation:nlSceneFloat 4.80s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="companies"]{--scene-ink:#b75b31;--scene-time:4.09s;}
.nl-scene-art[data-nl-scene="companies"] .nl-scene-spark{animation-delay:-0.28s;opacity:0.67;}
.nl-scene-art[data-nl-scene="companies"] .nl-scene-line{animation:nlSceneTilt 5.39s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="customers"]{--scene-ink:#be6027;--scene-time:4.48s;}
.nl-scene-art[data-nl-scene="customers"] .nl-scene-spark{animation-delay:-0.56s;opacity:0.74;}
.nl-scene-art[data-nl-scene="customers"] .nl-scene-plate{animation:nlSceneBounce 4.48s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="admin"]{--scene-ink:#a6532d;--scene-time:4.87s;}
.nl-scene-art[data-nl-scene="admin"] .nl-scene-spark{animation-delay:-0.84s;opacity:0.81;}
.nl-scene-art[data-nl-scene="admin"] .nl-scene-shape{animation:nlSceneRise 5.97s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="audit"]{--scene-ink:#b75628;--scene-time:5.26s;}
.nl-scene-art[data-nl-scene="audit"] .nl-scene-spark{animation-delay:-1.12s;opacity:0.88;}
.nl-scene-art[data-nl-scene="audit"] .nl-scene-line{animation:nlScenePulse 6.56s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="ports"]{--scene-ink:#aa5d34;--scene-time:5.65s;}
.nl-scene-art[data-nl-scene="ports"] .nl-scene-spark{animation-delay:-1.4s;opacity:0.60;}
.nl-scene-art[data-nl-scene="ports"] .nl-scene-plate{animation:nlSceneSail 5.65s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="vessels"]{--scene-ink:#9d4e25;--scene-time:6.04s;}
.nl-scene-art[data-nl-scene="vessels"] .nl-scene-spark{animation-delay:-1.68s;opacity:0.67;}
.nl-scene-art[data-nl-scene="vessels"] .nl-scene-shape{animation:nlSceneSwipe 7.14s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="profile"]{--scene-ink:#bd6c38;--scene-time:6.43s;}
.nl-scene-art[data-nl-scene="profile"] .nl-scene-spark{animation-delay:-0.0s;opacity:0.74;}
.nl-scene-art[data-nl-scene="profile"] .nl-scene-line{animation:nlSceneCheck 7.73s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="search"]{--scene-ink:#b66d39;--scene-time:6.82s;}
.nl-scene-art[data-nl-scene="search"] .nl-scene-spark{animation-delay:-0.28s;opacity:0.81;}
.nl-scene-art[data-nl-scene="search"] .nl-scene-plate{animation:nlSceneOrbit 6.82s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="shipments"]{--scene-ink:#a64c21;--scene-time:3.7s;}
.nl-scene-art[data-nl-scene="shipments"] .nl-scene-spark{animation-delay:-0.56s;opacity:0.88;}
.nl-scene-art[data-nl-scene="shipments"] .nl-scene-shape{animation:nlSceneSail 4.80s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="route"]{--scene-ink:#a9612e;--scene-time:4.09s;}
.nl-scene-art[data-nl-scene="route"] .nl-scene-spark{animation-delay:-0.84s;opacity:0.60;}
.nl-scene-art[data-nl-scene="route"] .nl-scene-line{animation:nlSceneSlide 5.39s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="checkpoint"]{--scene-ink:#b84b1f;--scene-time:4.48s;}
.nl-scene-art[data-nl-scene="checkpoint"] .nl-scene-spark{animation-delay:-1.12s;opacity:0.67;}
.nl-scene-art[data-nl-scene="checkpoint"] .nl-scene-plate{animation:nlSceneCheck 4.48s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="finance"]{--scene-ink:#a84b2a;--scene-time:4.87s;}
.nl-scene-art[data-nl-scene="finance"] .nl-scene-spark{animation-delay:-1.4s;opacity:0.74;}
.nl-scene-art[data-nl-scene="finance"] .nl-scene-shape{animation:nlSceneRise 5.97s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="booking"]{--scene-ink:#aa652e;--scene-time:5.26s;}
.nl-scene-art[data-nl-scene="booking"] .nl-scene-spark{animation-delay:-1.68s;opacity:0.81;}
.nl-scene-art[data-nl-scene="booking"] .nl-scene-line{animation:nlSceneSlide 6.56s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="confirmation"]{--scene-ink:#b4531c;--scene-time:5.65s;}
.nl-scene-art[data-nl-scene="confirmation"] .nl-scene-spark{animation-delay:-0.0s;opacity:0.88;}
.nl-scene-art[data-nl-scene="confirmation"] .nl-scene-plate{animation:nlSceneCheck 5.65s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="containers"]{--scene-ink:#ad5728;--scene-time:6.04s;}
.nl-scene-art[data-nl-scene="containers"] .nl-scene-spark{animation-delay:-0.28s;opacity:0.60;}
.nl-scene-art[data-nl-scene="containers"] .nl-scene-shape{animation:nlSceneSwipe 7.14s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="pricing"]{--scene-ink:#b9672d;--scene-time:6.43s;}
.nl-scene-art[data-nl-scene="pricing"] .nl-scene-spark{animation-delay:-0.56s;opacity:0.67;}
.nl-scene-art[data-nl-scene="pricing"] .nl-scene-line{animation:nlSceneTilt 7.73s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="priceaudit"]{--scene-ink:#aa592f;--scene-time:6.82s;}
.nl-scene-art[data-nl-scene="priceaudit"] .nl-scene-spark{animation-delay:-0.84s;opacity:0.74;}
.nl-scene-art[data-nl-scene="priceaudit"] .nl-scene-plate{animation:nlSceneFloat 6.82s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="stock"]{--scene-ink:#ba5f23;--scene-time:3.7s;}
.nl-scene-art[data-nl-scene="stock"] .nl-scene-spark{animation-delay:-1.12s;opacity:0.81;}
.nl-scene-art[data-nl-scene="stock"] .nl-scene-shape{animation:nlSceneRise 4.80s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="import"]{--scene-ink:#b65721;--scene-time:4.09s;}
.nl-scene-art[data-nl-scene="import"] .nl-scene-spark{animation-delay:-1.4s;opacity:0.88;}
.nl-scene-art[data-nl-scene="import"] .nl-scene-line{animation:nlSceneBounce 5.39s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="importresult"]{--scene-ink:#bd763a;--scene-time:4.48s;}
.nl-scene-art[data-nl-scene="importresult"] .nl-scene-spark{animation-delay:-1.68s;opacity:0.60;}
.nl-scene-art[data-nl-scene="importresult"] .nl-scene-plate{animation:nlSceneCheck 4.48s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="ledger"]{--scene-ink:#b35324;--scene-time:4.87s;}
.nl-scene-art[data-nl-scene="ledger"] .nl-scene-spark{animation-delay:-0.0s;opacity:0.67;}
.nl-scene-art[data-nl-scene="ledger"] .nl-scene-shape{animation:nlSceneSwipe 5.97s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="product"]{--scene-ink:#9f5930;--scene-time:5.26s;}
.nl-scene-art[data-nl-scene="product"] .nl-scene-spark{animation-delay:-0.28s;opacity:0.74;}
.nl-scene-art[data-nl-scene="product"] .nl-scene-line{animation:nlSceneFloat 6.56s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="sales"]{--scene-ink:#c26427;--scene-time:5.65s;}
.nl-scene-art[data-nl-scene="sales"] .nl-scene-spark{animation-delay:-0.56s;opacity:0.81;}
.nl-scene-art[data-nl-scene="sales"] .nl-scene-plate{animation:nlSceneSlide 5.65s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="stockadd"]{--scene-ink:#ac5c24;--scene-time:6.04s;}
.nl-scene-art[data-nl-scene="stockadd"] .nl-scene-spark{animation-delay:-0.84s;opacity:0.88;}
.nl-scene-art[data-nl-scene="stockadd"] .nl-scene-shape{animation:nlSceneBounce 7.14s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="stocksummary"]{--scene-ink:#ad7141;--scene-time:6.43s;}
.nl-scene-art[data-nl-scene="stocksummary"] .nl-scene-spark{animation-delay:-1.12s;opacity:0.60;}
.nl-scene-art[data-nl-scene="stocksummary"] .nl-scene-line{animation:nlScenePulse 7.73s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="invoicecreate"]{--scene-ink:#b04f23;--scene-time:6.82s;}
.nl-scene-art[data-nl-scene="invoicecreate"] .nl-scene-spark{animation-delay:-1.4s;opacity:0.67;}
.nl-scene-art[data-nl-scene="invoicecreate"] .nl-scene-plate{animation:nlSceneFloat 6.82s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="invoice"]{--scene-ink:#b75b25;--scene-time:3.7s;}
.nl-scene-art[data-nl-scene="invoice"] .nl-scene-spark{animation-delay:-1.68s;opacity:0.74;}
.nl-scene-art[data-nl-scene="invoice"] .nl-scene-shape{animation:nlSceneTilt 4.80s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="invoices"]{--scene-ink:#b96531;--scene-time:4.09s;}
.nl-scene-art[data-nl-scene="invoices"] .nl-scene-spark{animation-delay:-0.0s;opacity:0.81;}
.nl-scene-art[data-nl-scene="invoices"] .nl-scene-line{animation:nlSceneSwipe 5.39s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="payments"]{--scene-ink:#bd5027;--scene-time:4.48s;}
.nl-scene-art[data-nl-scene="payments"] .nl-scene-spark{animation-delay:-0.28s;opacity:0.88;}
.nl-scene-art[data-nl-scene="payments"] .nl-scene-plate{animation:nlSceneSlide 4.48s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="analytics"]{--scene-ink:#ad5731;--scene-time:4.87s;}
.nl-scene-art[data-nl-scene="analytics"] .nl-scene-spark{animation-delay:-0.56s;opacity:0.60;}
.nl-scene-art[data-nl-scene="analytics"] .nl-scene-shape{animation:nlSceneRise 5.97s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="claims"]{--scene-ink:#af6327;--scene-time:5.26s;}
.nl-scene-art[data-nl-scene="claims"] .nl-scene-spark{animation-delay:-0.84s;opacity:0.67;}
.nl-scene-art[data-nl-scene="claims"] .nl-scene-line{animation:nlSceneCheck 6.56s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="claimdetail"]{--scene-ink:#c36b34;--scene-time:5.65s;}
.nl-scene-art[data-nl-scene="claimdetail"] .nl-scene-spark{animation-delay:-1.12s;opacity:0.74;}
.nl-scene-art[data-nl-scene="claimdetail"] .nl-scene-plate{animation:nlSceneTilt 5.65s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="claimfile"]{--scene-ink:#aa5428;--scene-time:6.04s;}
.nl-scene-art[data-nl-scene="claimfile"] .nl-scene-spark{animation-delay:-1.4s;opacity:0.81;}
.nl-scene-art[data-nl-scene="claimfile"] .nl-scene-shape{animation:nlSceneBounce 7.14s ease-in-out infinite;}
.nl-scene-art[data-nl-scene="workspace"]{--scene-ink:#ad4f25;--scene-time:6.43s;}
.nl-scene-art[data-nl-scene="workspace"] .nl-scene-spark{animation-delay:-1.68s;opacity:0.88;}
.nl-scene-art[data-nl-scene="workspace"] .nl-scene-line{animation:nlSceneFloat 7.73s ease-in-out infinite;}

.nl-scene-art[data-nl-scene="checkpoint"] .nl-scene-line{left:21px;bottom:21px;width:50px;height:12px;background:#d58b4b;box-shadow:0 0}
.nl-scene-art[data-nl-scene="booking"] .nl-scene-shape{transform:rotate(8deg);box-shadow:0 11px 0 #a64d2618}
.nl-scene-art[data-nl-scene="confirmation"] .nl-scene-spark{width:16px;height:16px;left:26px;top:48px}
.nl-scene-art[data-nl-scene="containers"] .nl-scene-shape{top:29px;left:90px}
.nl-scene-art[data-nl-scene="pricing"] .nl-scene-shape{transform:rotate(-9deg)}
.nl-scene-art[data-nl-scene="priceaudit"] .nl-scene-plate{transform:rotate(5deg)}
.nl-scene-art[data-nl-scene="stockadd"] .nl-scene-shape{left:112px;top:24px;transform:rotate(8deg)}
.nl-scene-art[data-nl-scene="import"] .nl-scene-line{width:52px;height:14px;background:#e39755;clip-path:polygon(0 25%,70% 25%,70% 0,100% 50%,70% 100%,70% 75%,0 75%)}
.nl-scene-art[data-nl-scene="importresult"] .nl-scene-spark{left:176px;top:20px;background:#d4792f}
.nl-scene-art[data-nl-scene="ledger"] .nl-scene-detail{height:4px;box-shadow:0 10px #dda777,0 20px #dda777,0 30px #dda777}
.nl-scene-art[data-nl-scene="product"] .nl-scene-shape{clip-path:polygon(0 0,100% 0,100% 100%,0 100%,0 40%)}
.nl-scene-art[data-nl-scene="sales"] .nl-scene-line{background:#ffe2b9;border-radius:10px;right:43px;bottom:40px}
.nl-scene-art[data-nl-scene="stocksummary"] .nl-scene-shape{box-shadow:29px -7px #eaa96f,58px -30px #c25a1c}
.nl-scene-art[data-nl-scene="invoicecreate"] .nl-scene-shape{transform:rotate(-8deg)}
.nl-scene-art[data-nl-scene="invoice"] .nl-scene-line{background:#e7a567;width:66px;right:18px;bottom:20px}
.nl-scene-art[data-nl-scene="invoices"] .nl-scene-plate{box-shadow:13px 10px 0 #d9ab86,22px 17px 0 #b86b3a24}
.nl-scene-art[data-nl-scene="payments"] .nl-scene-line{width:50px;height:19px;background:#fff3df;right:26px;bottom:34px;box-shadow:none;border-radius:3px}
.nl-scene-art[data-nl-scene="claims"] .nl-scene-shape{transform:rotate(6deg)}
.nl-scene-art[data-nl-scene="claimdetail"] .nl-scene-shape{left:115px;top:49px;transform:rotate(-6deg)}
.nl-scene-art[data-nl-scene="claimfile"] .nl-scene-line{right:12px;bottom:24px;width:55px;height:7px;background:#a45525;transform:rotate(-35deg)}
.nl-scene-art[data-nl-scene="profile"] .nl-scene-detail{background:#fff0d8;width:18px;border-radius:50%;height:18px;left:101px;top:96px;box-shadow:0 0}
/* Within Analytics, every individual report has a different animated motif, not a copy of the hero art. */
.analytics-dashboard .nl-scene-report-heading{display:flex;align-items:center;justify-content:space-between;gap:12px;min-width:0}
.analytics-dashboard .nl-report-scene{width:95px;height:57px;flex:none;border:1px solid #ebc9af;border-radius:13px;position:relative;overflow:hidden;background:linear-gradient(125deg,#fffaf4,#ffebd9)}
.analytics-dashboard .nl-report-scene i{position:absolute;display:block;background:#d46a29;bottom:8px;width:14px;border-radius:4px 4px 2px 2px;animation:nlSceneRise 4s ease-in-out infinite}
.analytics-dashboard .nl-report-scene .nl-mini-bar-a{left:19px;height:19px}
.analytics-dashboard .nl-report-scene .nl-mini-bar-b{left:41px;height:34px;animation-delay:.3s;background:#f3af74}
.analytics-dashboard .nl-report-scene .nl-mini-bar-c{left:63px;height:42px;animation-delay:.7s;background:#b44c21}
.analytics-dashboard .nl-report-scene .nl-mini-mark{right:8px;top:5px;width:8px;height:8px;border-radius:50%;background:#f2a56b;animation:nlScenePulse 3s ease-in-out infinite}
.analytics-dashboard .nl-report-scene[data-nl-scene="abc"] .nl-mini-bar-a{left:29px;top:7px;width:39px;height:39px;border-radius:50%;background:conic-gradient(#c35a22 0 44%,#efab70 44% 67%,#a8623f 67% 100%);animation:nlSceneOrbit 13s linear infinite}
.analytics-dashboard .nl-report-scene[data-nl-scene="abc"] .nl-mini-bar-b{left:42px;top:20px;width:13px;height:13px;border-radius:50%;background:#fff9ee;animation:none}
.analytics-dashboard .nl-report-scene[data-nl-scene="abc"] .nl-mini-bar-c{display:none}
.analytics-dashboard .nl-report-scene[data-nl-scene="turnover"] .nl-mini-bar-a{width:43px;height:28px;left:12px;background:repeating-linear-gradient(90deg,#ec9861 0 9px,#ffd1a7 9px 14px);animation:nlSceneSlide 4.4s ease-in-out infinite}
.analytics-dashboard .nl-report-scene[data-nl-scene="turnover"] .nl-mini-bar-b{width:43px;height:28px;left:44px;bottom:20px;background:repeating-linear-gradient(90deg,#c75e2c 0 9px,#f6b880 9px 14px);animation:nlSceneFloat 5s ease-in-out infinite}
.analytics-dashboard .nl-report-scene[data-nl-scene="turnover"] .nl-mini-bar-c{display:none}
.analytics-dashboard .nl-report-scene[data-nl-scene="forecast"] .nl-mini-bar-a{height:4px;width:64px;left:15px;bottom:23px;transform:rotate(-21deg);animation:nlSceneFloat 6s ease-in-out infinite}
.analytics-dashboard .nl-report-scene[data-nl-scene="forecast"] .nl-mini-bar-b{width:13px;height:13px;left:59px;bottom:35px;border-radius:50%}
.analytics-dashboard .nl-report-scene[data-nl-scene="forecast"] .nl-mini-bar-c{width:13px;height:13px;left:21px;bottom:17px;border-radius:50%}
.analytics-dashboard .nl-report-scene[data-nl-scene="productprofit"] .nl-mini-bar-a{background:#c65b23;height:31px}.analytics-dashboard .nl-report-scene[data-nl-scene="productprofit"] .nl-mini-bar-b{background:#efb07b;height:25px}.analytics-dashboard .nl-report-scene[data-nl-scene="productprofit"] .nl-mini-bar-c{background:#5f916c;height:45px}
.analytics-dashboard .nl-report-scene[data-nl-scene="pandl"] .nl-mini-bar-a{background:#edaa70;height:43px}.analytics-dashboard .nl-report-scene[data-nl-scene="pandl"] .nl-mini-bar-b{background:#b45b36;height:30px}.analytics-dashboard .nl-report-scene[data-nl-scene="pandl"] .nl-mini-bar-c{background:#5d986e;height:27px}
/* Existing bespoke shipment/movement scenes: align buttons in-card; keep animation inside the card boundary. */
.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(185px,238px)!important;grid-template-areas:"text art" "actions art"!important;align-items:center!important;gap:9px 20px!important;padding:22px 26px!important;overflow:hidden!important}
.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero .hero-copy,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero .hero-copy{grid-area:text!important}
.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero .hero-actions,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero .hero-actions{grid-area:actions!important;justify-content:flex-start!important;align-items:center!important;margin:4px 0 0!important;gap:10px!important}
.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero .hero-art,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero .hero-art{grid-area:art!important;overflow:hidden!important;max-width:100%;width:100%;min-width:0;min-height:135px!important;display:flex;align-items:center;justify-content:center}
.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero .ship-scene,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero .mv-scene{max-width:100%;transform:scale(.85);transform-origin:center!important}
@media(max-width:840px){.nl-themed-page .nl-screen-hero{grid-template-columns:minmax(0,1fr) 160px;gap:10px;padding:18px!important}.nl-scene-art{width:155px;height:128px;transform:scale(.88);transform-origin:right center}.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero{grid-template-columns:minmax(0,1fr) 160px!important}}
@media(max-width:640px){.nl-themed-page .nl-screen-hero{grid-template-columns:1fr!important;grid-template-rows:auto!important;min-height:0;padding:17px!important}.nl-themed-page .nl-screen-hero .nl-scene-art{display:none!important}.nl-themed-page .nl-screen-hero .heading-actions{grid-column:1;grid-row:auto}.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero{grid-template-columns:1fr!important;grid-template-areas:"text" "actions"!important}.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] .page-hero .hero-art,.nl-themed-page[data-nl-screen="module2-movementtracking"] .page-hero .hero-art{display:none!important}.analytics-dashboard .nl-report-scene{width:72px;height:50px}}
@media(prefers-reduced-motion:reduce){.nl-themed-page .nl-scene-art *,.nl-themed-page .nl-scene-art .nl-scene-plate,.nl-themed-page .nl-report-scene i{animation:none!important}.nl-themed-page .nl-screen-hero a,.nl-themed-page .nl-screen-hero button{transition:none!important}}
/* Existing primary page heading styles and responsive actions. */
.nl-themed-page .nl-screen-hero[hidden]{display:none!important}
.nl-themed-page .nl-screen-hero.nl-bill-hero{grid-template-columns:minmax(0,1fr) 220px;grid-template-rows:auto auto;background:linear-gradient(116deg,#fffdf9,#fff4e8 67%,#ffe7d0)!important}
.nl-themed-page .nl-screen-hero.nl-bill-hero>div:first-child{grid-column:1;grid-row:1}
.nl-themed-page .nl-screen-hero.nl-bill-hero>a{grid-column:1;grid-row:2;justify-self:start}
.nl-themed-page .nl-screen-hero.nl-bill-hero>.nl-scene-art{grid-column:2;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero.nl-claim-top{grid-template-columns:minmax(0,1fr) 220px;grid-template-rows:auto auto;gap:10px 18px}
.nl-themed-page .nl-screen-hero.nl-claim-top>div:first-child{grid-column:1;grid-row:1}
.nl-themed-page .nl-screen-hero.nl-claim-top>a{grid-column:1;grid-row:2;justify-self:start}
.nl-themed-page .nl-screen-hero.nl-claim-top>.nl-scene-art{grid-column:2;grid-row:1 / span 2}
.nl-themed-page .nl-screen-hero.a-hero>.a-hero-actions{grid-column:1;grid-row:2;justify-self:start}
.nl-themed-page .nl-screen-hero.nl-user-hero>.nl-scene-art{grid-column:2;grid-row:1 / span 2}
@media(max-width:640px){.nl-themed-page .nl-screen-hero.nl-bill-hero,.nl-themed-page .nl-screen-hero.nl-claim-top{grid-template-columns:1fr!important}.nl-themed-page .nl-screen-hero.nl-bill-hero>a,.nl-themed-page .nl-screen-hero.nl-claim-top>a{grid-column:1;grid-row:2}}
/* Common QOL: clearer hover/focus states on reports without changing business logic. */
.nl-themed-page .nl-view-body a:focus-visible,.nl-themed-page .nl-view-body button:focus-visible,.nl-themed-page .content-wrap a:focus-visible,.nl-themed-page .content-wrap button:focus-visible{outline:3px solid #d35f1c;outline-offset:3px}
.nl-themed-page .nl-view-body .table tbody tr,.nl-themed-page .content-wrap .data-table tbody tr{transition:background-color .15s ease}
.nl-themed-page .nl-view-body .table tbody tr:hover,.nl-themed-page .content-wrap .data-table tbody tr:hover{background-color:#fff1e4}

.nl-themed-page .nl-screen-hero.d-flex{display:grid!important;grid-template-columns:minmax(0,1fr) 210px!important;grid-template-rows:auto auto!important}
.nl-themed-page .nl-screen-hero.d-flex>div:first-child{grid-column:1;grid-row:1}
.nl-themed-page .nl-screen-hero.d-flex>div:nth-child(2):not(.nl-scene-art){grid-column:1;grid-row:2;justify-self:start}
.nl-themed-page .nl-screen-hero.d-flex>.nl-scene-art{grid-column:2;grid-row:1 / span 2}
@media(max-width:640px){.nl-themed-page .nl-screen-hero.d-flex{grid-template-columns:1fr!important}}

.nl-scene-art[data-nl-scene="outstanding"]{--scene-ink:#b55021;--scene-time:4.6s}
.nl-scene-art[data-nl-scene="outstanding"] .nl-scene-plate{animation:nlScenePulse 4.6s ease-in-out infinite}
.nl-scene-art[data-nl-scene="outstanding"] .nl-scene-spark{width:16px;height:16px;background:#e75d21;animation:nlSceneTwinkle 2.9s ease-in-out infinite}
.nl-infra .i-hero[data-nl-scene="ports"] .i-crane{animation:iCraneShift 6s ease-in-out infinite}
.nl-infra .i-hero[data-nl-scene="ports"] .i-ship{animation:none}
.nl-infra .i-hero[data-nl-scene="vessels"] .i-ship{animation:iShipSway 4s ease-in-out infinite}
.nl-infra .i-hero[data-nl-scene="vessels"] .i-crane{animation:none}

/* N-LOGISTIC v17.4 — responsive legibility, fixed heading, payment review, and safe footer */
html,body{max-width:100%;overflow-x:clip}
.nl-themed-page .nl-view-body,.nl-themed-page #nlMainColumn{min-width:0;max-width:100%}
.nl-themed-page .nl-view-body :is(h1,h2,h3,.nl-auto-hero h1,.nl-screen-hero h1){overflow-wrap:anywhere;line-height:1.22}
.nl-themed-page .nl-view-body :is(input,select,textarea){font-size:clamp(.9rem,1vw,1rem)!important}
.nl-themed-page .nl-view-body table.table tbody td{font-size:.9rem!important;line-height:1.5!important}
.nl-themed-page .nl-view-body table.table thead th{font-size:.8rem!important;line-height:1.45!important}
.nl-themed-page .nl-view-body table.table .btn{font-size:.83rem!important;min-height:36px}
.nl-themed-page .nl-view-body .table-responsive{max-width:100%!important;min-width:0!important}
.nl-themed-page .nl-view-body .table-responsive th,.nl-themed-page .nl-view-body .table-responsive td{overflow-wrap:anywhere;word-break:normal}
.nl-themed-page .nl-app-header{gap:10px;min-width:0;flex-wrap:nowrap}
.nl-themed-page .nl-app-header .navbar-brand{white-space:nowrap;flex-shrink:0}
.nl-themed-page .nl-app-header form[role="search"]{min-width:0;flex:1 1 320px;max-width:650px;margin-left:auto!important;margin-right:auto!important}
.nl-themed-page .nl-app-header form[role="search"] input{min-width:0;width:100%}
.nl-themed-page .nl-app-header .nl-header-utilities{flex:none;min-width:0}
.nl-themed-page .nl-app-header .nl-account-toggle{max-width:220px;min-width:0}
.nl-themed-page .nl-app-header .nl-account-identity{max-width:145px;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.nl-themed-page .nl-app-header .nl-account-identity span{overflow:hidden;text-overflow:ellipsis;white-space:nowrap;max-width:100%}
.nl-pay-reminder{font-size:.89rem!important;font-weight:850!important;border:2px solid #ffda8f!important;padding:10px 15px!important;box-shadow:0 5px 16px #3f170b4a!important;background:linear-gradient(115deg,#fff5d8,#ffc17c)!important;flex-shrink:0}
.nl-pay-reminder strong{font-size:1em;letter-spacing:.005em}
.nl-pay-reminder small{font-size:.75em}
.nl-themed-page .payment-dialog:not([hidden]){align-items:center!important;justify-items:center!important;z-index:21000!important;padding:clamp(12px,3vw,26px)!important}
.nl-themed-page .payment-dialog .payment-dialog-surface{width:min(610px,100%)!important;margin:auto!important;border-radius:20px!important;padding:clamp(20px,3vw,32px)!important}
.nl-themed-page .payment-dialog .payment-review{grid-template-columns:minmax(0,1fr) minmax(0,1.2fr)!important;align-items:baseline;column-gap:18px;row-gap:10px}
.nl-themed-page .payment-dialog .payment-review dd{text-align:right;overflow-wrap:anywhere}
.nl-themed-page .payment-dialog .payment-actions{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(0,1.25fr);gap:10px!important;justify-content:stretch!important}
.nl-themed-page .payment-dialog .payment-actions button{min-width:0;min-height:45px;width:100%}
.nl-themed-page .nl-universal-backtop,.nl-themed-page .nl-backtop{right:20px!important;bottom:74px!important}
.nl-themed-page footer,.nl-themed-page .nl-footer{padding-right:72px!important;padding-bottom:22px!important}
@media(max-width:1280px){.nl-pay-reminder small{display:none!important}.nl-themed-page .nl-app-header .navbar-brand{font-size:.92rem!important;padding:7px 10px!important}}
@media(max-width:1060px){.nl-pay-reminder{font-size:.78rem!important;padding:8px 10px!important}.nl-themed-page .nl-app-header .nl-header-utilities{gap:5px!important}}
@media(max-width:800px){.nl-pay-reminder{max-width:165px;white-space:normal!important;line-height:1.22}.nl-themed-page .payment-dialog .payment-review{grid-template-columns:1fr 1fr!important}}
@media(max-width:520px){.nl-themed-page .payment-dialog .payment-actions{grid-template-columns:1fr!important}.nl-themed-page .nl-universal-backtop,.nl-themed-page .nl-backtop{right:12px!important;bottom:75px!important}}
/* Pricing rules are cards at normal desktop widths; no tiny text or side-scrolling. */
@media(max-width:1750px){
 .nl-themed-page[data-nl-screen="module3-pricing"] .table-responsive{overflow:visible!important;border:0!important;box-shadow:none!important;background:transparent!important}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table{display:block!important;width:100%!important;min-width:0!important;background:transparent!important}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table thead{display:none!important}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody{display:grid!important;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px;width:100%}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody tr{display:grid!important;grid-template-columns:repeat(2,minmax(0,1fr));gap:0;padding:12px!important;min-width:0;border:1px solid #e8d4bf;border-radius:16px;background:#fffaf5!important;box-shadow:0 5px 16px #6a321210}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody td{display:block!important;padding:9px 11px!important;max-width:100%!important;min-width:0!important;border:0!important;text-align:left!important;font-size:.93rem!important;white-space:normal!important}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody td:before{content:attr(data-label);display:block;margin-bottom:4px;font-size:.73rem;font-weight:850;text-transform:uppercase;color:#a15e36;letter-spacing:.045em}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody td:last-child{grid-column:1/-1;border-top:1px dashed #e8d4c2!important;padding-top:12px!important;display:flex!important;align-items:center;gap:8px;flex-wrap:wrap}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody td:last-child:before{flex-basis:100%}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody td[colspan]{grid-column:1/-1}
 .nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody td[colspan]:before{display:none}
}
@media(max-width:1160px){.nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody{grid-template-columns:minmax(0,1fr)}}
@media(max-width:520px){.nl-themed-page[data-nl-screen="module3-pricing"] table.table tbody tr{grid-template-columns:minmax(0,1fr)}}

/* v19.4: theme isolation/contrast follow-up. All selectors here are explicitly DARK-only.
 * The v19.3 module-specific comma lists were independently repaired so no dark
 * component rule can affect Light Mode. Keep this block intentionally small. */
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details[open] > summary {
  background:#263c53!important;
  background-image:none!important;
  color:#f5f8fd!important;
  border-color:#63809a!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:focus-visible {
  background:#34516b!important;
  color:#fff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu {
  background:#23374b!important;
  color:#f0f5fb!important;
  border-color:#607a91!important;
  box-shadow:0 18px 40px rgba(1,9,21,.4)!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label {
  color:#e9f1fa!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label:hover {
  background:#36516b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu input[type="checkbox"]{
  accent-color:#ff964f;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-status-chip,.nl-dash-panel .badge,.nl-dash-panel .nl-status-count) {
  background:#2b4057!important;
  color:#f0f5fc!important;
  border-color:#59738b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip :is(span,strong,b) {
  color:#f0f5fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger {
  background:#442d32!important;
  color:#ffd9d8!important;
  border-color:#bd7774!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger:hover {
  background:#583338!important;
  color:#fff0ed!important;
  border-color:#ed9c94!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:disabled {
  background:#334053!important;
  color:#b8c5d3!important;
  border-color:#53657b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons .nl18-table-status{
  color:#bbcbdb!important;
}
</style>

<style>
/* Unified final polish: prevent duplicate workspace captions and keep content aligned. */
.nl-boardroom-caption{display:none!important}
.nl-role-dashboard-hero{display:flex!important;flex-direction:row;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:18px;padding:clamp(22px,3vw,35px)!important;margin-top:4px!important;border:1px solid #eecdb2!important;background:linear-gradient(115deg,#fffdf9 0%,#fff3e4 75%,#ffe5c9 100%)!important;box-shadow:0 14px 34px #753c1910!important}
.nl-role-dashboard-hero-copy{min-width:0;flex:1 1 350px}.nl-role-dashboard-hero h1{font-size:clamp(1.85rem,3vw,2.65rem)!important;margin:9px 0 8px!important;line-height:1.1}.nl-role-dashboard-hero p{font-size:.98rem;color:#795e4a;margin:0!important}.nl-role-dashboard-eyebrow{font-weight:850;font-size:.7rem;color:#ac5b2b;letter-spacing:.12em}.nl-role-dashboard-hero-actions{display:flex;justify-content:flex-end;align-items:center;flex:0 0 auto}.nl-role-dashboard-hero-actions .btn{min-height:45px;white-space:nowrap}
.nl-themed-page .nl-view-body,.nl-themed-page .nl-view-body>*,.nl-themed-page .container-fluid{min-width:0}
.nl-required,.nl-required-top{display:inline-block!important;vertical-align:baseline!important;margin-left:4px!important;line-height:1!important;position:static!important}
.nl-themed-page .payment-dialog:not([hidden]){position:fixed!important;inset:0!important;z-index:99999!important;display:grid!important;place-items:center!important;padding:20px!important;transform:none!important}
.nl-themed-page .payment-dialog .payment-dialog-surface{width:min(600px,100%)!important;max-height:calc(100dvh - 40px)!important;overflow-y:auto!important;margin:auto!important}
.nl-themed-page .nl-role-dashboard-hero+.card{margin-top:0!important}
.nl-boardroom-tools{justify-content:flex-end!important;margin-bottom:6px!important;min-height:26px!important;padding:0!important}
@media(max-width:640px){.nl-role-dashboard-hero{align-items:stretch!important}.nl-role-dashboard-hero-actions{width:100%}.nl-role-dashboard-hero-actions .btn{width:100%}}

/* v17.5: single breadcrumb/Page-tools row across the seven-module workspace. */
.nl-page-meta-row{display:flex!important;align-items:center!important;justify-content:space-between!important;gap:14px;flex-wrap:wrap;min-height:42px;margin:0 0 14px!important;padding:0 0 8px!important;border-bottom:1px solid rgba(223,201,180,.65)}
#nlMainColumn>.nl-page-meta-row{max-width:1640px;margin-inline:auto!important}
.nl-page-meta-row>[aria-label="Breadcrumb"],.nl-page-meta-row>.bread,.nl-page-meta-row>.nl-breadcrumb,.nl-page-meta-row>.small.text-uppercase{min-width:0;margin:0!important;padding:0!important;flex:1 1 210px;font-size:.83rem!important;font-weight:800!important;letter-spacing:.075em!important;line-height:1.45;align-self:center}
.nl-page-meta-row>.nl-boardroom-tools{margin:0!important;padding:0!important;min-height:0!important;flex:0 0 auto;animation:none!important;position:relative;z-index:30}
.nl-page-meta-row .nl-page-tools>summary{min-height:40px;font-size:.87rem;padding:9px 14px}
.nl-page-meta-row+.nl-view-body,.nl-page-meta-row+.page-heading,.nl-page-meta-row+.nl-screen-hero{margin-top:0!important}
@media(max-width:560px){.nl-page-meta-row{gap:8px;margin-bottom:12px!important}.nl-page-meta-row>[aria-label="Breadcrumb"],.nl-page-meta-row>.bread{flex-basis:0;font-size:.77rem!important}.nl-page-meta-row .nl-page-tools>summary{min-height:38px;padding:8px 11px;font-size:.82rem}}

/* Readable movement history: larger labels and clear cards without page overflow. */
body[data-nl-screen="module2-movementtracking"] .content-wrap{font-size:1rem;line-height:1.58}
body[data-nl-screen="module2-movementtracking"] .movement-viewbar{padding:17px 20px;background:linear-gradient(110deg,#fffaf5,#fff2e3);border:1px solid #efd3b7;border-radius:16px;gap:16px;margin-bottom:18px}
body[data-nl-screen="module2-movementtracking"] .movement-viewbar>div:first-child>strong{font-size:1.08rem;color:#432b1f}
body[data-nl-screen="module2-movementtracking"] .movement-viewbar .muted{font-size:.94rem;color:#715743}
body[data-nl-screen="module2-movementtracking"] .movement-viewbar .sub{font-size:.96rem;color:#72513b}
body[data-nl-screen="module2-movementtracking"] .movement-viewactions{flex-wrap:wrap;gap:5px}
body[data-nl-screen="module2-movementtracking"] .view-switch{font-size:.94rem;min-height:44px;padding:11px 16px}
body[data-nl-screen="module2-movementtracking"] .group-utility{font-size:.96rem;gap:12px}
body[data-nl-screen="module2-movementtracking"] .group-utility .small{font-size:.93rem;color:#705540}
body[data-nl-screen="module2-movementtracking"] .movement-groups{gap:17px}
body[data-nl-screen="module2-movementtracking"] .movement-group{border-radius:18px;border-color:#e8c7a8;box-shadow:0 5px 17px rgba(105,59,29,.06)}
body[data-nl-screen="module2-movementtracking"] .movement-group[open]{border-color:#d89052;box-shadow:0 10px 25px rgba(113,61,25,.1)}
body[data-nl-screen="module2-movementtracking"] .movement-group>summary{min-height:88px;padding:18px 22px;gap:18px;background:linear-gradient(110deg,#fff8ef,#fff4e9)}
body[data-nl-screen="module2-movementtracking"] .movement-group[open]>summary{border-bottom:1px solid #f0d9c3}
body[data-nl-screen="module2-movementtracking"] .group-symbol{width:47px;height:47px;font-size:1.22rem;border-radius:13px;background:#ffdfc3}
body[data-nl-screen="module2-movementtracking"] .group-identity strong{font-size:1.1rem;line-height:1.33;font-weight:850}
body[data-nl-screen="module2-movementtracking"] .group-identity small{font-size:.91rem;line-height:1.5;margin-top:4px;color:#705541}
body[data-nl-screen="module2-movementtracking"] .group-aside .pill{font-size:.82rem;min-height:31px;padding:5px 11px}
body[data-nl-screen="module2-movementtracking"] .group-aside .small{font-size:.88rem;color:#68513e;white-space:nowrap}
body[data-nl-screen="module2-movementtracking"] .group-body{padding:21px 25px 20px}
body[data-nl-screen="module2-movementtracking"] .group-event{grid-template-columns:36px minmax(0,1fr);gap:14px}
body[data-nl-screen="module2-movementtracking"] .event-bullet{width:30px;height:30px;font-size:.85rem}
body[data-nl-screen="module2-movementtracking"] .group-event-step:after{top:26px}
body[data-nl-screen="module2-movementtracking"] .event-topline strong{font-size:1.04rem;line-height:1.4;color:#3d291d}
body[data-nl-screen="module2-movementtracking"] .event-topline time{font-size:.91rem;font-weight:600;color:#70543f}
body[data-nl-screen="module2-movementtracking"] .event-location{font-size:1rem;color:#49352a;line-height:1.52;margin-top:5px}
body[data-nl-screen="module2-movementtracking"] .event-comment{font-size:.96rem;padding:11px 13px;line-height:1.5;margin-top:9px;border-left-width:4px}
body[data-nl-screen="module2-movementtracking"] .event-actor{font-size:.87rem;color:#7c5b43;margin-top:8px}
body[data-nl-screen="module2-movementtracking"] .event-details{padding-bottom:23px}
body[data-nl-screen="module2-movementtracking"] .group-footer{padding-top:17px;gap:11px}
body[data-nl-screen="module2-movementtracking"] .group-footer .btn,body[data-nl-screen="module2-movementtracking"] .group-footer .mini-copy,body[data-nl-screen="module2-movementtracking"] .group-utility .btn{font-size:.91rem;min-height:41px;padding:9px 14px;font-weight:750;border-radius:10px}
body[data-nl-screen="module2-movementtracking"] .card-head h2{font-size:clamp(1.4rem,2.1vw,1.7rem);line-height:1.28}
body[data-nl-screen="module2-movementtracking"] .card-head .sub{font-size:.96rem;line-height:1.5;color:#72533e}
body[data-nl-screen="module2-movementtracking"] .card-head .pill{font-size:.8rem;vertical-align:middle}
@media(max-width:800px){body[data-nl-screen="module2-movementtracking"] .movement-group>summary{padding:15px 13px;align-items:flex-start;flex-wrap:wrap}body[data-nl-screen="module2-movementtracking"] .group-aside{justify-content:flex-start;width:100%;padding-left:59px}body[data-nl-screen="module2-movementtracking"] .group-body{padding:16px 13px}body[data-nl-screen="module2-movementtracking"] .movement-viewbar{padding:15px}}
@media(max-width:530px){body[data-nl-screen="module2-movementtracking"] .group-aside{padding-left:0}body[data-nl-screen="module2-movementtracking"] .group-aside .small{display:inline;font-size:.82rem}body[data-nl-screen="module2-movementtracking"] .event-topline{flex-direction:column;gap:3px}body[data-nl-screen="module2-movementtracking"] .view-switch{flex:1 1 130px}body[data-nl-screen="module2-movementtracking"] .movement-viewbar{padding:12px}body[data-nl-screen="module2-movementtracking"] .group-footer{justify-content:stretch}body[data-nl-screen="module2-movementtracking"] .group-footer .btn{flex:1 1 auto}}

/* v19.4: theme isolation/contrast follow-up. All selectors here are explicitly DARK-only.
 * The v19.3 module-specific comma lists were independently repaired so no dark
 * component rule can affect Light Mode. Keep this block intentionally small. */
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details[open] > summary {
  background:#263c53!important;
  background-image:none!important;
  color:#f5f8fd!important;
  border-color:#63809a!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:focus-visible {
  background:#34516b!important;
  color:#fff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu {
  background:#23374b!important;
  color:#f0f5fb!important;
  border-color:#607a91!important;
  box-shadow:0 18px 40px rgba(1,9,21,.4)!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label {
  color:#e9f1fa!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label:hover {
  background:#36516b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu input[type="checkbox"]{
  accent-color:#ff964f;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-status-chip,.nl-dash-panel .badge,.nl-dash-panel .nl-status-count) {
  background:#2b4057!important;
  color:#f0f5fc!important;
  border-color:#59738b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip :is(span,strong,b) {
  color:#f0f5fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger {
  background:#442d32!important;
  color:#ffd9d8!important;
  border-color:#bd7774!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger:hover {
  background:#583338!important;
  color:#fff0ed!important;
  border-color:#ed9c94!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:disabled {
  background:#334053!important;
  color:#b8c5d3!important;
  border-color:#53657b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons .nl18-table-status{
  color:#bbcbdb!important;
}
</style>

<%-- N-LOGISTIC v18.0: five additive UI phases. All styles remain inside existing JSP source. --%>
<style id="nlV18Styles">
/* Phase 1: consistent typography, focus, spacing and motion. Scoped to existing workspaces. */
body.nl-themed-page,body.nl-universal-module2{--nl18-ink:#352419;--nl18-secondary:#755d4b;--nl18-orange:#c65116;--nl18-canvas:#fffdfa;--nl18-border:#ead7c7;--nl18-shadow:0 8px 26px rgba(86,42,18,.075)}
body.nl-themed-page :is(.nl-view-body,.content-wrap),body.nl-universal-module2 .content-wrap{font-size:clamp(.9rem,.29vw + .82rem,1rem);color:var(--nl18-ink)}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(p,li,dd),body.nl-universal-module2 .content-wrap :is(p,li,dd){line-height:1.62}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.form-text,small,.text-muted,.text-secondary),body.nl-universal-module2 .content-wrap :is(small,.muted,.meta){font-size:clamp(.8rem,.24vw + .73rem,.93rem);line-height:1.55}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(h2,h3,h4,h5),body.nl-universal-module2 .content-wrap :is(h2,h3,h4,h5){text-wrap:pretty;line-height:1.24}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,select,textarea,button),body.nl-universal-module2 .content-wrap :is(input,select,textarea,button){font-size:clamp(.87rem,.26vw + .76rem,1rem)}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(a,button,input,select,textarea,summary):focus-visible,body.nl-universal-module2 .content-wrap :is(a,button,input,select,textarea,summary):focus-visible,.nl18-overlay :is(a,button,input):focus-visible{outline:3px solid #d6753b!important;outline-offset:3px}
body.nl-themed-page :is(.nl-view-body,.content-wrap) .card,body.nl-universal-module2 .content-wrap :is(.card,.panel,.shipment-row){transition:box-shadow .2s ease,border-color .2s ease}
body.nl-themed-page :is(.nl-view-body,.content-wrap) .card:hover,body.nl-universal-module2 .content-wrap :is(.card,.panel,.shipment-row):hover{box-shadow:0 13px 34px rgba(86,42,18,.095)}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge,.pill,.tag),body.nl-universal-module2 .content-wrap :is(.badge,.pill,.tag){font-size:.77rem;font-weight:760;letter-spacing:.01em}
body.nl-themed-page :is(.nl-view-body,.content-wrap) [id],body.nl-universal-module2 .content-wrap [id]{scroll-margin-top:110px}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.table,.nl-smart-table) td,body.nl-universal-module2 .content-wrap table td{vertical-align:middle;line-height:1.48}
body.nl-themed-page :is(.nl-view-body,.content-wrap) table thead th,body.nl-universal-module2 .content-wrap table thead th{font-weight:800;letter-spacing:.015em}
body.nl-themed-page :is(.nl-view-body,.content-wrap) table tbody tr:hover,body.nl-universal-module2 .content-wrap table tbody tr:hover{background-color:#fff5eb}
body.nl-themed-page .nl-view-body .nl-required,body.nl-themed-page .nl-view-body .nl-required-top{display:inline!important;margin-left:3px!important;margin-right:0!important;vertical-align:baseline!important;white-space:nowrap}
.nl18-stamp{display:inline-flex;align-items:center;gap:5px;flex-wrap:wrap;background:#fff2e4;color:#844322;border:1px solid #ebd0b7;border-radius:99px;font-size:.75rem;font-weight:750;padding:4px 9px;line-height:1.25}
.nl18-stamp .nl18-dot{width:7px;height:7px;border-radius:50%;background:#c75a1e}
.nl18-muted{font-size:.8rem;color:var(--nl18-secondary)}
.nl18-divider{height:1px;background:linear-gradient(90deg,#e8c8af,transparent);margin:16px 0}
.nl18-page-welcome,.nl18-workspace-panel,.nl18-booking-glance,.nl18-progress-panel,.nl18-feature-panel{border:1px solid var(--nl18-border,#ecd4c0);border-radius:18px;background:linear-gradient(125deg,#fffdf9,#fff6ec);padding:15px 19px;margin:12px 0 19px;box-shadow:var(--nl18-shadow)}
.nl18-page-welcome{display:flex;justify-content:space-between;gap:14px;align-items:center;flex-wrap:wrap}
.nl18-page-welcome .nl18-eyebrow,.nl18-booking-glance .nl18-eyebrow,.nl18-feature-panel .nl18-eyebrow{font-weight:850;font-size:.7rem;text-transform:uppercase;letter-spacing:.12em;color:#af4c18}
.nl18-page-welcome h2{font-size:clamp(1.06rem,1.4vw,1.35rem);margin:5px 0 1px;font-weight:840;color:#402819}
.nl18-page-welcome p{margin:0;color:#775b47;font-size:.83rem}
.nl18-mini-actions{display:flex;gap:8px;flex-wrap:wrap;align-items:center}
.nl18-mini-btn,.nl18-toolbar button,.nl18-toolbar select,.nl18-action{background:#fffaf5;border:1px solid #e9c9b0;border-radius:9px;color:#85421f;cursor:pointer;padding:8px 11px;font-size:.79rem;font-weight:720;line-height:1.3}
.nl18-mini-btn:hover,.nl18-toolbar button:hover,.nl18-action:hover{background:#ffe9d7;border-color:#ce8856}
.nl18-mini-btn:disabled{opacity:.5;cursor:not-allowed}
.nl18-toolbar{display:flex;align-items:center;gap:9px;flex-wrap:wrap;margin:10px 0;padding:10px 13px;background:#fffaf3;border:1px solid #eddbc9;border-radius:12px}
.nl18-toolbar-label{font-size:.76rem;font-weight:750;color:#6d4d3c}
.nl18-table-addons{margin:7px 0 10px;justify-content:flex-end}
.nl18-table-addons details{position:relative}
.nl18-table-addons details>summary{list-style:none;cursor:pointer;border-radius:9px;padding:8px 11px;border:1px solid #e9c9b0;background:#fffaf5;color:#85421f;font-size:.79rem;font-weight:750}
.nl18-table-addons details>summary::-webkit-details-marker{display:none}
.nl18-column-menu{position:absolute;z-index:60;right:0;top:calc(100% + 6px);min-width:210px;max-width:min(340px,calc(100vw - 35px));max-height:275px;overflow:auto;border:1px solid #e9c9b0;background:#fffefa;border-radius:12px;box-shadow:0 13px 30px #4f240a23;padding:10px}
.nl18-column-menu label{display:flex;align-items:start;gap:8px;padding:6px 7px;font-size:.8rem;font-weight:550;color:#5e3928;cursor:pointer}
.nl18-column-menu label:hover{background:#fff1e5;border-radius:7px}
.nl18-column-menu input{margin-top:3px}
.nl18-table-status{font-size:.75rem;color:#765947;margin-right:auto}
.nl18-preview-button{font-size:.7rem!important;padding:3px 7px!important;border:1px solid #e0bea5!important;background:#fff9f2!important;color:#8b4724!important;border-radius:7px!important;white-space:nowrap;margin-left:7px!important;min-height:25px!important}
.nl18-tablemark{background:#ffe19f!important;color:#402307!important;padding:0 1px;border-radius:3px}
.nl18-dense-compact :is(.nl-view-body,.content-wrap) :is(.card,.panel){--bs-card-spacer-y:1rem;--bs-card-spacer-x:1.05rem}
.nl18-dense-compact .nl-view-body table td,.nl18-dense-compact .nl-view-body table th,.nl18-dense-compact .content-wrap table td,.nl18-dense-compact .content-wrap table th{padding:.44rem .6rem!important}
.nl18-dense-spacious .nl-view-body table td,.nl18-dense-spacious .nl-view-body table th,.nl18-dense-spacious .content-wrap table td,.nl18-dense-spacious .content-wrap table th{padding:1rem 1.05rem!important}
.nl18-field-counter{display:block;text-align:right;color:#816653;font-size:.74rem;margin-top:4px}
.nl18-field-error{display:block;color:#ac351f;font-size:.81rem;font-weight:700;margin:5px 0 2px}
.nl18-has-error{border-color:#d14a30!important;box-shadow:0 0 0 3px #cb5b2220!important}
.nl18-section-jumps{display:flex;gap:7px;flex-wrap:wrap;margin:11px 0 18px;align-items:center}
.nl18-section-jumps a{text-decoration:none;color:#864420;background:#fff8f0;border:1px solid #ead2bc;border-radius:99px;font-size:.8rem;padding:7px 11px;font-weight:700}
.nl18-section-jumps a:hover,.nl18-section-jumps a:focus-visible{background:#ffead6}
.nl18-section-jumps span{color:#91745e;font-weight:720;font-size:.77rem;margin-right:3px}
.nl18-overlay{position:fixed;inset:0;z-index:2600;display:grid;place-items:center;background:rgba(36,22,14,.46);padding:16px;backdrop-filter:blur(3px)}
.nl18-overlay[hidden]{display:none!important}
.nl18-modal{width:min(610px,100%);max-height:min(86vh,760px);overflow:auto;background:linear-gradient(138deg,#fffefd,#fff5eb);border-radius:23px;border:1px solid #ebc9ac;box-shadow:0 25px 75px rgba(51,25,9,.26);padding:clamp(18px,3vw,28px);color:#38251c}
.nl18-modal-head{display:flex;align-items:start;justify-content:space-between;gap:14px}
.nl18-modal h2{font-size:1.3rem;line-height:1.25;margin:7px 0 8px;font-weight:850}
.nl18-modal p{font-size:.88rem;color:#795a48}
.nl18-modal-close{background:#fff4e8;border:1px solid #efd2ba;border-radius:10px;font-weight:800;color:#864222;width:38px;height:38px;flex:0 0 38px}
.nl18-modal-list{display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1.4fr);gap:0 10px;margin:14px 0;border:1px solid #ecd6c3;border-radius:13px;overflow:hidden}
.nl18-modal-list dt,.nl18-modal-list dd{padding:10px 12px;border-bottom:1px solid #f1e1d4;margin:0;overflow-wrap:anywhere;font-size:.85rem}
.nl18-modal-list dt{font-weight:650;color:#876955;background:#fff8ee}
.nl18-modal-list dd{font-weight:750;color:#493124}
.nl18-modal-list :is(dt,dd):nth-last-child(-n+2){border-bottom:0}
.nl18-modal-actions{display:flex;justify-content:flex-end;gap:9px;flex-wrap:wrap;margin-top:17px}
.nl18-command-search{width:100%;border:1px solid #ddab84;border-radius:12px;padding:12px 14px;min-height:47px;background:#fff;outline-offset:3px;color:#38251c}
.nl18-command-items{display:grid;gap:5px;max-height:320px;overflow-y:auto;margin-top:12px}
.nl18-command-items a{display:flex;justify-content:space-between;gap:12px;padding:12px 14px;color:#543323;text-decoration:none;border:1px solid transparent;border-radius:11px;font-weight:670}
.nl18-command-items a:hover,.nl18-command-items a:focus-visible{background:#fff0e1;border-color:#efdbcc}
.nl18-command-items small{color:#947056;font-size:.76rem}
.nl18-booking-glance{position:relative;display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:10px;margin-bottom:16px}
.nl18-booking-facts{display:flex;flex:1;gap:10px;flex-wrap:wrap;min-width:200px}
.nl18-booking-facts>div{background:#fff;border:1px solid #efdfd0;border-radius:10px;padding:8px 11px;min-width:130px;flex:1 1 135px}
.nl18-booking-facts small{display:block;color:#80634d;font-size:.72rem}
.nl18-booking-facts strong{display:block;font-size:.87rem;color:#4c311f;overflow-wrap:anywhere;margin-top:3px}
.nl18-quote-chart{margin-top:16px;border:1px solid #efd9c6;border-radius:12px;background:#fffaf5;padding:13px 15px}
.nl18-quote-bar{display:flex;min-height:18px;overflow:hidden;border-radius:99px;background:#efe1d4;gap:1px;margin:10px 0}
.nl18-quote-bar span{display:block;min-width:0}
.nl18-quote-key{display:flex;gap:15px;flex-wrap:wrap;font-size:.77rem;color:#76543c}
.nl18-quote-key i{width:10px;height:10px;display:inline-block;border-radius:50%;margin-right:5px}
.nl18-progress-track{height:10px;overflow:hidden;border-radius:99px;background:#ecdacc;box-shadow:inset 0 1px 3px #9b61321d}
.nl18-progress-track>span{display:block;height:100%;background:linear-gradient(90deg,#bb5519,#f39e4a);border-radius:99px;min-width:0;max-width:100%;transition:width .2s}
.nl18-progress-panel{padding:14px 16px}
.nl18-progress-panel .nl18-progress-legend{display:flex;justify-content:space-between;gap:10px;flex-wrap:wrap;color:#75523b;font-size:.8rem;margin-bottom:8px}
.nl18-timeline-pill{display:inline-flex;gap:6px;align-items:center;padding:5px 9px;background:#fff1e1;border:1px solid #edd2ba;border-radius:999px;font-size:.76rem;color:#845029;font-weight:700}
.nl18-feature-panel>summary{list-style:none;cursor:pointer;display:flex;align-items:center;justify-content:space-between;font-weight:800;color:#65371e}
.nl18-feature-panel>summary::-webkit-details-marker{display:none}
.nl18-feature-panel>summary::after{content:'+';font-weight:900;font-size:1.15rem;margin-left:7px;color:#bb5b23}
.nl18-feature-panel[open]>summary::after{content:'−'}
.nl18-feature-panel-content{margin-top:12px}
.nl18-summary-tiles{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:11px;margin-top:10px}
.nl18-summary-tile{border:1px solid #ecd5c1;background:#fff;border-radius:12px;padding:12px 14px}
.nl18-summary-tile small{display:block;color:#8b6c57;font-size:.74rem}
.nl18-summary-tile strong{display:block;color:#452a1a;font-size:1rem;margin-top:4px;overflow-wrap:anywhere}
.nl18-file-card{border:1px solid #e9d6c7;background:#fffaf5;padding:9px 13px;border-radius:10px;margin-top:9px;font-size:.81rem;color:#70442f;overflow-wrap:anywhere}
.nl18-attention{border-left:4px solid #d36626!important}
body.nl-themed-page .nl18-print-only{display:none}
@media(max-width:820px){.nl18-page-welcome{align-items:start}.nl18-table-addons{justify-content:flex-start}.nl18-booking-facts>div{flex-basis:145px}.nl18-modal{max-height:90dvh}}
@media(max-width:550px){.nl18-modal-list{grid-template-columns:1fr}.nl18-modal-list dt{padding-bottom:2px;border-bottom:0}.nl18-modal-list dd{padding-top:2px}.nl18-booking-glance{display:block}.nl18-booking-facts{margin-top:12px}.nl18-mini-actions{margin-top:9px}.nl18-table-addons .nl18-table-status{flex-basis:100%}}
@media(prefers-reduced-motion:reduce){.nl18-overlay,.nl18-modal,.nl18-progress-track>span{animation:none!important;transition:none!important;transform:none!important}}
@media print{.nl-app-header,#nlSidebarCol,.nl18-toolbar,.nl18-page-welcome,.nl18-section-jumps,.nl18-overlay,.nl18-table-addons,.nl18-mini-actions,.nl18-preview-button,.nl-page-meta-row,.nl-page-tools{display:none!important}body.nl-themed-page .nl18-print-only{display:block}body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,.panel){box-shadow:none!important;break-inside:avoid;border-color:#ddd!important}.nl-view-body,.content-wrap{max-width:none!important;width:100%!important;margin:0!important;padding:0!important}#nlMainColumn{width:100%!important;max-width:none!important;padding:0!important}}

/* v18.1: a readable structured shipment snapshot and encoding-safe UI icons. */
.nl18-snapshot-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px;margin:18px 0 10px}
.nl18-snapshot-field{margin:0;min-width:0;padding:13px 15px;background:#fffaf5;border:1px solid #ebd8c5;border-radius:12px}
.nl18-snapshot-field dt{font-size:.73rem;color:#896751;font-weight:720;text-transform:uppercase;letter-spacing:.04em;margin:0 0 5px}
.nl18-snapshot-field dd{font-size:.95rem;color:#3e281b;font-weight:800;margin:0;overflow-wrap:anywhere;line-height:1.4}
.nl18-snapshot-field:nth-child(2),.nl18-snapshot-field:nth-child(5){grid-column:auto}
.nl18-modal-close{font-family:Arial,sans-serif!important;font-size:1.6rem!important;font-weight:400!important;line-height:1!important}
.nl18-preview-primary{background:#c85216!important;color:white!important;border-color:#c85216!important}
.nl18-modal{overflow-x:hidden}
@media(max-width:520px){.nl18-snapshot-grid{grid-template-columns:minmax(0,1fr)}}

/* v19.4: theme isolation/contrast follow-up. All selectors here are explicitly DARK-only.
 * The v19.3 module-specific comma lists were independently repaired so no dark
 * component rule can affect Light Mode. Keep this block intentionally small. */
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details[open] > summary {
  background:#263c53!important;
  background-image:none!important;
  color:#f5f8fd!important;
  border-color:#63809a!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:focus-visible {
  background:#34516b!important;
  color:#fff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu {
  background:#23374b!important;
  color:#f0f5fb!important;
  border-color:#607a91!important;
  box-shadow:0 18px 40px rgba(1,9,21,.4)!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label {
  color:#e9f1fa!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label:hover {
  background:#36516b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu input[type="checkbox"]{
  accent-color:#ff964f;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-status-chip,.nl-dash-panel .badge,.nl-dash-panel .nl-status-count) {
  background:#2b4057!important;
  color:#f0f5fc!important;
  border-color:#59738b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip :is(span,strong,b) {
  color:#f0f5fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger {
  background:#442d32!important;
  color:#ffd9d8!important;
  border-color:#bd7774!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger:hover {
  background:#583338!important;
  color:#fff0ed!important;
  border-color:#ed9c94!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:disabled {
  background:#334053!important;
  color:#b8c5d3!important;
  border-color:#53657b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons .nl18-table-status{
  color:#bbcbdb!important;
}
</style>
<%-- v18 follow-up: optional table density preserves every cell and action. --%>
<style>
.nl18-table-compact :is(thead th,tbody td){padding:6px 9px!important}
.nl18-table-spacious :is(thead th,tbody td){padding:15px 17px!important}
.nl18-feature-panel .nl18-mini-actions{margin-top:10px}
.nl18-table-addons :is(select,button,summary){min-height:34px!important}
.nl18-column-menu input[type=checkbox]{accent-color:#c7551e}
.nl18-booking-glance p{margin:5px 0 0!important}
.nl18-page-welcome .nl18-eyebrow,.nl18-modal .nl18-eyebrow{font-size:.71rem;letter-spacing:.12em;font-weight:820;text-transform:uppercase;color:#ba5b25}

/* v19.4: theme isolation/contrast follow-up. All selectors here are explicitly DARK-only.
 * The v19.3 module-specific comma lists were independently repaired so no dark
 * component rule can affect Light Mode. Keep this block intentionally small. */
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details[open] > summary {
  background:#263c53!important;
  background-image:none!important;
  color:#f5f8fd!important;
  border-color:#63809a!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:focus-visible {
  background:#34516b!important;
  color:#fff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu {
  background:#23374b!important;
  color:#f0f5fb!important;
  border-color:#607a91!important;
  box-shadow:0 18px 40px rgba(1,9,21,.4)!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label {
  color:#e9f1fa!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label:hover {
  background:#36516b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu input[type="checkbox"]{
  accent-color:#ff964f;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-status-chip,.nl-dash-panel .badge,.nl-dash-panel .nl-status-count) {
  background:#2b4057!important;
  color:#f0f5fc!important;
  border-color:#59738b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip :is(span,strong,b) {
  color:#f0f5fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger {
  background:#442d32!important;
  color:#ffd9d8!important;
  border-color:#bd7774!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger:hover {
  background:#583338!important;
  color:#fff0ed!important;
  border-color:#ed9c94!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:disabled {
  background:#334053!important;
  color:#b8c5d3!important;
  border-color:#53657b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons .nl18-table-status{
  color:#bbcbdb!important;
}
</style>
<%-- v18.0 additive record labels and optional previews. --%>
<style>
.nl18-container-type{color:#87411d;font-weight:780!important;text-decoration:underline dotted #e8b48c;text-underline-offset:4px}
.nl18-ledger-type{font-weight:820!important;color:#894a28;text-decoration:underline dotted #e2ad83;text-underline-offset:3px}
.nl18-card-preview{align-self:center;white-space:nowrap;min-height:30px!important}
.nl18-progress-panel+.nl18-progress-panel{margin-top:9px}
.nl18-section-jumps :is(a,span){white-space:normal;overflow-wrap:anywhere}
@media(prefers-reduced-motion:no-preference){.nl18-page-welcome,.nl18-booking-glance,.nl18-quote-chart,.nl18-feature-panel{animation:nl18SoftEnter .36s ease-out both}@keyframes nl18SoftEnter{from{opacity:.4;transform:translateY(6px)}to{opacity:1;transform:translateY(0)}}}

/* v18.1: secondary verified action toast, never an optimistic success. */
.nl18-action-toast{position:fixed;right:18px;bottom:25px;z-index:2500;max-width:min(480px,calc(100vw - 36px));padding:14px 17px;background:#fff8ef;border:1px solid #eac19b;border-left:5px solid #c85216;border-radius:13px;box-shadow:0 15px 40px #351e1533;color:#4b301d;font-weight:690;font-size:.86rem;display:flex;gap:12px;align-items:center;overflow-wrap:anywhere}
.nl18-action-toast button{border:1px solid #dfb796;padding:6px 10px;border-radius:8px;background:white;color:#97461a;font-weight:740;flex-shrink:0}

/* v19.4: theme isolation/contrast follow-up. All selectors here are explicitly DARK-only.
 * The v19.3 module-specific comma lists were independently repaired so no dark
 * component rule can affect Light Mode. Keep this block intentionally small. */
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details[open] > summary {
  background:#263c53!important;
  background-image:none!important;
  color:#f5f8fd!important;
  border-color:#63809a!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:focus-visible {
  background:#34516b!important;
  color:#fff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu {
  background:#23374b!important;
  color:#f0f5fb!important;
  border-color:#607a91!important;
  box-shadow:0 18px 40px rgba(1,9,21,.4)!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label {
  color:#e9f1fa!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label:hover {
  background:#36516b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu input[type="checkbox"]{
  accent-color:#ff964f;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-status-chip,.nl-dash-panel .badge,.nl-dash-panel .nl-status-count) {
  background:#2b4057!important;
  color:#f0f5fc!important;
  border-color:#59738b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip :is(span,strong,b) {
  color:#f0f5fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger {
  background:#442d32!important;
  color:#ffd9d8!important;
  border-color:#bd7774!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger:hover {
  background:#583338!important;
  color:#fff0ed!important;
  border-color:#ed9c94!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:disabled {
  background:#334053!important;
  color:#b8c5d3!important;
  border-color:#53657b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons .nl18-table-status{
  color:#bbcbdb!important;
}
</style>

<style id="nlColorModeStyles">
/* v18.7: N-LOGISTIC semantic dark palette; intentionally scoped to the explicit switch. */
html[data-nl-mode="dark"] {color-scheme:dark;
 --nl-ink:#eff2f8;--nl-muted:#bbc7d6;--nl-orange:#ff9d58;--nl-orange-deep:#ffb17d;--nl-amber:#ffc179;
 --nl-brown:#e7cfc3;--nl-soft:#283242;--nl-cream:#1e2734;--nl-tint:#222d3a;--nl-bg:#131b27;--nl-line:#3a485a;
 --nl-shadow:0 12px 28px #050b1461,0 3px 10px #050b1440;
 --nl-shadow-hover:0 18px 36px #030a166e;
 --bs-body-bg:#131b27;--bs-body-color:#eaf0f7;--bs-border-color:#3a485a;
 --bs-primary:#ff9951;--bs-primary-rgb:255,153,81;--bs-warning:#f6a55e;--bs-warning-rgb:246,165,94;
 --bs-link-color:#ffb783;--bs-link-hover-color:#ffd4ae;
 --bs-secondary-color:#b7c2d1;--bs-tertiary-bg:#202b38;--bs-secondary-bg:#273443;
}
html[data-nl-mode="dark"] body.nl-themed-page{color:var(--nl-ink)!important;background:radial-gradient(ellipse 90% 34% at 90% 2%,#2a2830 0,transparent 72%),linear-gradient(145deg,#111824,#172130 60%,#121a25)!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(#nlMainColumn,:is(.nl-view-body,.content-wrap),.container-fluid.bg-body-tertiary,.bg-body-tertiary,.bg-light,.bg-white){background-color:transparent!important;color:var(--nl-ink)!important}
html[data-nl-mode="dark"] body.nl-themed-page #nlSidebarCol{background:linear-gradient(180deg,#1d2836,#161f2d)!important;border-color:#3c4c5c!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.sidebar,.nl-sidebar,.offcanvas){background-color:#1c2735!important;color:#e8edf5!important;border-color:#344454!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-sidebar a,.nav-link,.list-group-item){color:#dce6f2!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-sidebar a:hover,.nav-link:hover,.list-group-item:hover){background-color:#2e3d4c!important;color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-app-header{background:linear-gradient(100deg,#101923,#282333 62%,#62381e)!important;border-color:#4e3e34!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,.nl-card,.nl-dash-panel,.nl-kpi-card,.summary-card),
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-table-toolbar,.nl-table-pagination,.nl18-page-welcome,.nl18-feature-panel,.nl18-booking-glance,.nl18-quote-chart,.nl18-summary-tile,.nl18-file-card,.nl18-progress-panel,.nl18-modal,.nl18-action-toast){background:#202b39!important;color:#eaf0f7!important;border-color:#39495a!important;box-shadow:var(--nl-shadow)!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card-body,.card-header,.card-footer,.modal-content,.modal-header,.modal-body,.modal-footer,.dropdown-menu,.accordion-item,.accordion-body,.accordion-button,.list-group-item,.alert-light,.bg-white,.bg-light,.bg-warning-subtle,.bg-body-secondary),
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl18-modal-header,.nl18-modal-footer,.nl18-modal-list,.nl18-table-addons,.nl18-column-menu,.nl18-modal-grid,.nl18-modal-row){background:#222d3b!important;color:#eaf0f7!important;border-color:#3b4b5b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(:is(.nl-view-body,.content-wrap) h1,:is(.nl-view-body,.content-wrap) h2,:is(.nl-view-body,.content-wrap) h3,:is(.nl-view-body,.content-wrap) h4,:is(.nl-view-body,.content-wrap) h5,:is(.nl-view-body,.content-wrap) h6,.card-title,.nl18-summary-tile strong,.nl18-modal strong,.section-title){color:#f4f6fb!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.text-dark,.text-body,.text-body-emphasis,.text-black,.text-muted,.text-secondary,.small,.form-text,.text-body-secondary,.card .sub,.nl18-summary-tile small){color:#b8c5d5!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(label,.form-label,.field>label,.field>span,legend,dt,dd,p,li,td,th,summary,small){color:#dce5f0}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.form-control,.form-select,.form-check-input,textarea,input:not([type=checkbox]):not([type=radio]),select),
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl18-table-addons select,.nl18-table-addons button,.nl18-column-menu){background:#172332!important;color:#f4f6fb!important;border-color:#4c5c6c!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(input,textarea)::placeholder{color:#a7b6c5!important;opacity:1}
html[data-nl-mode="dark"] body.nl-themed-page :is(.form-control,.form-select):focus{border-color:#ffae70!important;box-shadow:0 0 0 .23rem #ff9c4a28!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.btn-light,.btn-outline-secondary,.btn-outline-dark,.nl18-action-toast button,.btn-outline-warning){background:#293849!important;color:#ffe0c4!important;border-color:#8c644b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.btn-light,.btn-outline-secondary,.btn-outline-dark):hover{background:#35475a!important;color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.btn-primary,.btn-warning,.btn-danger):not(:disabled){color:#241711!important}
html[data-nl-mode="dark"] body.nl-themed-page .table{--bs-table-bg:#202b39;--bs-table-color:#e8edf6;--bs-table-border-color:#3b4b5b;--bs-table-striped-bg:#253342;--bs-table-striped-color:#ecf1f6;--bs-table-hover-bg:#314256;--bs-table-hover-color:#fff;background:#202b39!important;color:#e8edf6!important;border-color:#3b4b5b!important}
html[data-nl-mode="dark"] body.nl-themed-page .table-responsive{background:#202b39!important;border-color:#3b4b5b!important;scrollbar-color:#677b90 #1a2634}
html[data-nl-mode="dark"] body.nl-themed-page .table :is(thead,thead th,.table-warning,thead tr){--bs-table-bg:#303344!important;--bs-table-color:#ffd7b1!important;background:#303344!important;color:#ffd7b1!important;border-color:#445365!important}
html[data-nl-mode="dark"] body.nl-themed-page .table tbody :is(td,th){color:#e4ebf5!important;border-color:#394959!important;background-color:transparent}
html[data-nl-mode="dark"] body.nl-themed-page .table tbody tr:nth-child(even)>*{--bs-table-bg-type:#263241!important}
html[data-nl-mode="dark"] body.nl-themed-page .table tbody tr:hover>*{--bs-table-bg-state:#324358!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.badge.bg-warning-subtle,.pill,.nl-pill,.nl18-tag){background:#3d302d!important;color:#ffd4ad!important;border-color:#77563f!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.badge.bg-success-subtle,.pill.good){background:#173c35!important;color:#9bedd0!important;border-color:#316c59!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.badge.bg-danger-subtle,.pill.bad){background:#4b2834!important;color:#ffb2b9!important;border-color:#7d4853!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.alert,.nl-alert,.toast,.nl18-action-toast){background:#293647!important;color:#edf3fa!important;border-color:#53657a!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.modal-backdrop,.nl18-overlay){background-color:#070e16!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.dropdown-menu,.dropdown-item,.offcanvas,.popover,.tooltip-inner){background:#243243!important;color:#eaf0f7!important;border-color:#3c4d60!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.dropdown-item:hover,.dropdown-item:focus){background:#3a4b60!important;color:white!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.border,.border-top,.border-bottom,.border-end,.border-start,hr){border-color:#3c4a5a!important}
html[data-nl-mode="dark"] body.nl-themed-page a:not(.btn):not(.nav-link):not(.dropdown-item){color:#ffbd8b}
html[data-nl-mode="dark"] body.nl-themed-page .text-warning-emphasis{color:#ffb47b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-stat,.stat,.stat-card,.nl-info-tile,.nl18-tile,.nl18-card,.info-card,[class*="-tile"]){background:#243242!important;color:#e8eef6!important;border-color:#405268!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is([style*="background:#fff"],[style*="background: #fff"]):not(canvas):not(.btn){background:#263444!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-table-addons,.nl18-feature-panel,.nl18-preview-dialog,.nl18-preview-box){color:#eff3fa!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-theme-switch{background:#293747!important;color:#ffcd9d!important;border-color:#75583f!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-theme-switch:hover{background:#344558!important}
html[data-nl-mode="dark"] body.nl-auth-page{background:radial-gradient(ellipse at 3% 7%,#49301d55,transparent 48%),linear-gradient(135deg,#0f1722,#1a2635 55%,#101925)!important;color:#edf1f9}
html[data-nl-mode="dark"] body.nl-auth-page :is(.bg-white,.card,.nl-auth-form,.nl-auth-panel){background:#202b39!important;color:#eaf0f7!important;border-color:#3d4d5e!important}
html[data-nl-mode="dark"] body.nl-auth-page :is(h1,h2,h3,.text-dark,.text-body-emphasis){color:#f4f7fa!important}
html[data-nl-mode="dark"] body.nl-auth-page :is(.text-secondary,.text-muted,.form-text){color:#b9c5d4!important}
html[data-nl-mode="dark"] body.nl-auth-page :is(.form-control,.form-select){background:#152232!important;color:#f4f7fb!important;border-color:#536176!important}
html[data-nl-mode="dark"] body.nl-auth-page :is(.form-control,.form-select)::placeholder{color:#a5b2c1}

html[data-nl-mode="dark"] body.nl-themed-page .table tbody tr:nth-child(even)>*{background:#263545!important;color:#eaf0f7!important}
html[data-nl-mode="dark"] body.nl-themed-page .table tbody tr:nth-child(odd)>*{background:#202b39!important;color:#eaf0f7!important}
html[data-nl-mode="dark"] body.nl-themed-page .table tbody tr:hover>*{background:#33465a!important;color:#fff!important}
/* Theme switch: always available on desktop and mobile without changing existing navigation. */
.nl-theme-switch{display:inline-flex;align-items:center;justify-content:center;gap:7px;padding:7px 11px;border:1px solid #e5bc98;border-radius:11px;background:#fff3e8;color:#7d3f19;font-size:.79rem;font-weight:800;line-height:1.3;white-space:nowrap;min-height:36px;cursor:pointer;transition:background .15s ease,border-color .15s ease}
.nl-theme-switch:hover{background:#ffe4c7;border-color:#ce8652}
.nl-theme-switch:focus-visible{outline:3px solid #e98f47;outline-offset:2px}
.nl-theme-switch [data-nl-theme-symbol]{font-size:1.1rem;line-height:1}
.nl-theme-switch.nl-theme-header{color:#ffe5ce;background:#ffffff16;border:1px solid #ffd5a04d}
.nl-theme-switch.nl-theme-header:hover{background:#ffffff2a}
@media(max-width:720px){.nl-theme-switch.nl-theme-header{padding:8px 10px}.nl-theme-switch.nl-theme-header [data-nl-theme-label]{display:none}}
@media print{html[data-nl-mode="dark"]{color-scheme:light}html[data-nl-mode="dark"] body.nl-themed-page{background:white!important;color:black!important}body .nl-theme-switch{display:none!important}}
/* v18.7 module-specific dark surfaces: keep current layout, buttons, permissions and data untouched. */
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .i-hero,.i-work-card,.i-record-section,.i-toolbar,.i-table,.i-modal-content,.i-modal-note,.i-toast,
 .cc-hero,.cc-card,.cc-kpi,.cc-table-wrap,.cc-table,.cc-modal .modal-content,
 .cu-hero,.cu-card,.cu-kpi,.cu-table-wrap,.cu-table,.cu-modal .modal-content,
 .a-hero,.a-stat,.a-card,.a-toolbar,.a-table,.a-pager,.a-detail-json,
 .na-hero,.na-kpi,.na-panel,.na-shortcuts,.na-advisory,.na-recent,.na-board,.na-cardlet,
 .iv-hero,.iv-panel,.iv-nav,.iv-content,.iv-surface,.iv-card,.iv-table,
 .nl-booking-guidance,.nl-booking-metrics,.nl-guidance-lanes,.nl-booking-routes,.nl-route-card,.nl-route-empty,.nl-product-query,.nl-product-suggestions,
 .nl-editor-card,.nl-editor-assist,.nl-final-confirm,.nl-quote-guide,.nl-nextstep-panel,.nl-next-choice,.nl-payment-modal,
 .nl-bill-stat,.nl-bill-tab,.nl-bill-record,.nl-bill-search,.nl-bill-empty,
 .nl-claim-policy,.nl-claim-step,.nl-claim-note,.nl-claim-upload,.nl-claim-kpi,.nl-claim-preview-card,.nl-claim-preview-fact,.nl-claim-preview-document,.nl-evidence-rename-editor,
 .nl-report-shortcuts,.nl-report-shortcut,.nl-analytics-report,.nl-report-chart,.nl-chart-empty,.nl-chart-fallback,.nl-report-table-pane,.nl-report-table-heading,.nl-action-drawer,.nl-ops-card,.nl-ops-kpi,
 .stat,.detail-box,.expander,.card.soft,.nl18-preview-box,.nl18-preview-dialog,
 .payment-dialog-surface,.nl18-modal,.nl18-modal-list,.nl18-summary-tile,.nl18-quote-chart,.nl18-booking-glance
){background:#202d3c!important;background-image:none!important;color:#e7eef6!important;border-color:#3c4e61!important;box-shadow:0 7px 24px #050c1645!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .i-modal .modal-header,.i-modal .modal-footer,.cc-modal .modal-header,.cc-modal .modal-footer,.cu-modal .modal-header,.cu-modal .modal-footer,
 .iv-panel>.card-header,.nl-bill-record .card-header,.analytics-dashboard .nl-report-table-heading
){background:#2a3949!important;color:#edf3fa!important;border-color:#415164!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .i-hero h1,.i-work-card h2,.i-record-section h2,.cc-hero h1,.cc-card h2,.cu-hero h1,.cu-card h2,.a-hero h1,.a-card h2,
 .na-hero h1,.na-panel h2,.iv-hero h1,.iv-panel h2,.nl-route-card h3,.nl-analytics-report h2,.nl-report-chart h3,
 .nl-bill-record h2,.nl-claim-preview-card h3,.nl-claim-step h3,.nl18-summary-tile strong
){color:#f4f7fb!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .nl-infra,.nl-company-admin,.nl-customer-admin,.nl-audit-v16,.nl-admin-v16,.nl-inv,.analytics-dashboard,.nl-claim-page,.nl-universal-module2
){color:#e4ecf5!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .nl-infra input:not([type=checkbox]):not([type=radio]):not([type=hidden]),.nl-infra select,.nl-infra textarea,
 .nl-company-admin input:not([type=hidden]),.nl-company-admin select,.nl-company-admin textarea,
 .nl-customer-admin input:not([type=hidden]),.nl-customer-admin select,.nl-customer-admin textarea,
 .nl-inv input:not([type=hidden]),.nl-inv select,.nl-inv textarea,
 .nl-universal-module2 input:not([type=hidden]),.nl-universal-module2 select,.nl-universal-module2 textarea,
 .nl-booking-routes input,.nl-product-query,.nl-claim-page input:not([type=hidden]),.nl-claim-page select,.nl-claim-page textarea,
 .analytics-dashboard input:not([type=hidden]),.analytics-dashboard select,
 .nl-bill-search input
){background:#172433!important;color:#f3f7fd!important;border-color:#526379!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .i-secondary,.i-tab,.i-seller-pill,.cc-btn-soft,.cu-btn-soft,.nl-guidance-tag,.nl-qty-chip,.nl-booking-secondary-action,
 .nl-chart-type,.iv-btn:not(.primary),.nl-bill-tab,.nl-report-shortcut
){background:#2a3c4e!important;color:#ffd7b2!important;border-color:#735d4e!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-table,.cc-table,.cu-table,.a-table,.iv-table,.nl-report-table-pane,.nl-bill-record table){background:#202d3c!important;color:#eef4fb!important;border-color:#3f4c5e!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-table th,.cc-table th,.cu-table th,.a-table th,.iv-table th,.nl-report-table-pane th){background:#30394a!important;color:#ffd3a7!important;border-color:#4d596b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-table td,.cc-table td,.cu-table td,.a-table td,.iv-table td,.nl-report-table-pane td){background:#202d3c!important;color:#e9eef6!important;border-color:#405063!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-table tr:nth-child(even) td,.cc-table tr:nth-child(even) td,.cu-table tr:nth-child(even) td,.a-table tr:nth-child(even) td,.iv-table tr:nth-child(even) td){background:#273547!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-modal,.cc-modal,.cu-modal,.nl18-overlay,.nl-claim-preview-overlay){color:#ecf2f8}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-modal .modal-content,.cc-modal .modal-content,.cu-modal .modal-content,.payment-dialog-surface,.nl18-modal,.nl18-preview-dialog){background:#202c3b!important;color:#eaf0f7!important;border-color:#526073!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-modal-note,.cc-modal .modal-note,.cu-modal .modal-note){background:#263747!important;color:#d9e5f3!important;border-color:#445b6b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.i-table .text-secondary,.cc-table .text-muted,.cu-table .text-muted,.a-table .text-muted,.iv-panel .text-muted,.nl-report-chart .text-muted){color:#b4c6d8!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.form-check-label,.form-floating>label,.form-label){color:#e0e8f3!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-app-header .nl-theme-switch{background:#ffffff17!important;color:#ffe0be!important;border-color:#ffd8b164!important}
/* Do not darken artwork/icon chips or published status markers through global filters. */
html[data-nl-mode="dark"] body.nl-themed-page img,html[data-nl-mode="dark"] body.nl-themed-page canvas{filter:none}

/* v18.8: semantic dark contrast audit.  Prevent light cards + pale text on
   Admin, Seller, Consumer, booking, finance, inventory, claims, and analytics. */
html[data-nl-mode="dark"]{
 --bs-body-color:#e5edf7;--bs-body-bg:#141e2b;--bs-secondary-color:#b7c7d9;
 --bs-tertiary-bg:#223244;--bs-secondary-bg:#253548;--bs-emphasis-color:#f4f7fb;
 --nl-ink:#edf3fb;--nl-muted:#bfccdc;--nl-cream:#202d3d;--nl-soft:#2a3849;
 --nl-tint:#253448;--nl-bg:#141e2b;--nl-line:#43576b;--nl-orange:#fb9147;
 --nl-orange-deep:#ffb67e;--bs-link-color:#ffc18e;--bs-link-hover-color:#ffe1c0;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .nl-role-dashboard-hero,.nl-dash-panel,.nl-analytics-hero,.analytics-panel,.nl-chart-card,
 .profile-hero,.profile-panel,.nl-profile-panel-outline,.nl-inventory-nav,.nl-user-hero,.nl-user-half-layout>.card,
 .nl-editor-assist>div,.nl-invoice-summary-grid>div,.nl-booking-metrics>div,.nl-guidance-lanes>div,
 .nl-route-card,.nl-report-shortcuts,.nl-report-shortcut,.nl-ops-card,.nl-ops-kpi,
 .nl-final-confirm,.nl-quote-guide,.nl-payment-modal,.nl-bill-stat,.nl-bill-record,
 .nl-claim-preview-card,.nl-claim-note,.nl-claim-step,.nl-record-info-grid>div,
 .nl-container-info,.nl-wide-info,.shipment-summary,.shipment-summary>div,.ship-boxes>div,
 .role-stats>div,.nl18-booking-facts>div,.nl18-booking-glance,.nl18-file-card,
 .nl18-modal,.nl18-summary-tile,.nl18-feature-panel,.nl18-progress-panel,
 .card,.card-body,.card-header,.card-footer,.modal-content,.modal-header,.modal-footer
 ){background:#233244!important;background-image:none!important;border-color:#405469!important;color:#eaf1fa!important;box-shadow:0 8px 24px #050d1855!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-role-dashboard-hero,.nl-analytics-hero,.nl-dash-panel,.profile-panel,.nl-profile-panel-outline,
 .nl-inventory-nav,.nl-user-hero,.nl-user-half-layout>.card,.nl-ops-card,.nl-bill-record,
 .nl-final-confirm,.nl-booking-guidance,.nl-claim-step,.card,.nl-report-chart,.nl-analytics-report
 ) :is(h1,h2,h3,h4,h5,h6,p,small,.form-text,.text-muted,.text-secondary,.sub,.description){color:#e0e9f4!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-role-dashboard-hero,.nl-analytics-hero,.nl-dash-panel,.profile-panel,.nl-user-hero,
 .nl-ops-card,.nl-bill-record,.nl-analytics-report,.card
 ) :is(strong,b,.stat-value,.nl-kpi-value){color:#f4f7fc!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-report-shortcut,.nl-action-link,.nl-module-linkset a,.nl-role-dashboard-hero-actions a,.nl18-mini-btn,.btn-light,.btn-outline-warning){color:#ffd4a8!important;background:#2a3a4e!important;border-color:#715a4d!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-report-shortcut:hover,.nl-action-link:hover,.nl-module-linkset a:hover){color:#fff5e8!important;background:#354b60!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-bill-stat,.nl18-booking-facts>div,.nl-booking-metrics>div,.nl-invoice-summary-grid>div) :is(small,span,p){color:#b9cbe0!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-bill-stat,.nl18-booking-facts>div,.nl-booking-metrics>div,.nl-invoice-summary-grid>div) :is(strong,b){color:#fff0df!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(:is(.nl-view-body,.content-wrap),.content-wrap) :is(.alert-light,.bg-warning-subtle,.bg-info-subtle,.bg-success-subtle,.bg-body-tertiary,.bg-light){background:#29384b!important;color:#e2ecf7!important;border-color:#46586b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is([style*="background:#fff"],[style*="background: #fff"]):not(button):not(a):not(span):not(.badge){background:#29394b!important;color:#e8eff9!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.form-control,.form-select,.input,.select,.textarea){background-color:#142233!important;color:#f1f7fd!important;border-color:#506579!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,textarea)::placeholder{color:#a4b6ca!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.table,.data-table,.i-table,.iv-table,.nl-report-table-pane) :is(td,th){border-color:#405367!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.table,.data-table,.i-table,.iv-table) tbody tr:nth-child(odd) td{background:#223143!important;color:#e7eff9!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.table,.data-table,.i-table,.iv-table) tbody tr:nth-child(even) td{background:#293a4d!important;color:#e7eff9!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.data-table,.table) thead th{background:#354356!important;color:#ffe0c1!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl18-modal,.nl18-modal-list,.nl18-preview-box,.nl18-booking-glance,.nl18-booking-facts>div) :is(dt,dd,small,strong,p,span){color:#e7eff8!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-app-header,.nl-inventory-nav,.nl-role-dashboard-hero){background-image:none}
html[data-nl-mode="dark"] body.nl-themed-page :is(.badge,.pill,.status-badge,[class*="status-chip"]){color:inherit}

/* Sidebar uses nl-side-* rather than Bootstrap nav-link classes. */
html[data-nl-mode="dark"] body.nl-themed-page :is(#nlSidebarCol,.nl-universal-sidebar,#nlMobileNav,.nl-primary-nav,.nl-side-groups,.nl-side-footer){background:#192738!important;color:#dfe9f5!important;border-color:#3d5267!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-side-group.is-selected{background:#293d52!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-main,.nl-side-child,.nl-side-name,.nl-side-toggle,.nl-side-heading-caption,.nl-side-signed,.nl-side-logout){color:#c6d6e8!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-main:hover,.nl-side-child:hover,.nl-side-toggle:hover){background:#304459!important;color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-main.is-current,.nl-side-main[aria-current="page"]){background:linear-gradient(105deg,#be4711,#f07b26)!important;color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-side-heading-line{background:#465c70!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-side-footer button{background:#24374a!important;color:#f4dac7!important;border-color:#586e7e!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-dash-kpi,.nl-stat,.nl-ops-kpi,.stat-card,.nl-chart-card,.nl-card,.nl-card-surface,.nl-report-chart-info){background:#253648!important;color:#eaf2fb!important;border-color:#455a70!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-dash-kpi,.nl-stat,.nl-ops-kpi,.stat-card,.nl-chart-card,.nl-card,.nl-card-surface,.nl-report-chart-info) :is(h1,h2,h3,h4,h5,small,p,strong){color:#eaf2fb!important}

/* Inputs must stay dark even where Bootstrap theme variables or page styles force light controls. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) input.form-control,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) input.input,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) select.form-select,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) textarea.form-control,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) textarea.textarea{
 background:#142333!important;color:#f5f8fc!important;-webkit-text-fill-color:#f5f8fc!important;border:1px solid #52687b!important;box-shadow:none;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input.form-control,input.input,textarea.form-control,textarea.textarea)::placeholder{-webkit-text-fill-color:#a7b8cc!important;color:#a7b8cc!important;opacity:1}

/* N-LOGISTIC v18.9 - one coordinated dark palette based on the reviewed mockup.
   Dark rules only.  Existing light theme, business logic and DOM remain unchanged. */
html[data-nl-mode="dark"]{
 color-scheme:dark;
 --nl-ink:#edf4fc;--nl-muted:#b8c9d9;--nl-orange:#ff9b51;
 --nl-orange-deep:#ffc18b;--nl-amber:#ffb575;--nl-brown:#ffca9b;
 --nl-bg:#111b28;--nl-cream:#1e2e40;--nl-soft:#283a4d;
 --nl-tint:#233448;--nl-line:#40556a;
 --nl-shadow:0 10px 28px #080e195c;--nl-shadow-hover:0 16px 32px #050a1466;
 --bs-body-bg:#111b28;--bs-body-color:#edf4fc;
 --bs-emphasis-color:#f7faff;--bs-secondary-color:#b8c9d9;
 --bs-primary:#e8752b;--bs-primary-rgb:232,117,43;
 --bs-warning:#f9a15a;--bs-warning-rgb:249,161,90;
 --bs-secondary-bg:#253648;--bs-tertiary-bg:#223143;
 --bs-border-color:#40556a;--bs-link-color:#ffb885;--bs-link-hover-color:#ffd8b6;
 --nl-dark-base:#111b28;--nl-dark-sidebar:#182536;
 --nl-dark-panel:#1e2e40;--nl-dark-raised:#283a4d;
 --nl-dark-head:#2b3a50;--nl-dark-input:#142435;
 --nl-dark-border:#40556a;--nl-dark-text:#edf4fc;
 --nl-dark-muted:#b8c9d9;--nl-dark-accent:#ff9b51;
 --nl-dark-highlight:#ffd0a1;
}
/* App shell, sidebar and navigation remain dark at every depth. */
html[data-nl-mode="dark"] body.nl-themed-page,
html[data-nl-mode="dark"] body.nl-themed-page #nlMainColumn,
html[data-nl-mode="dark"] body.nl-themed-page #nlMainColumn.bg-body-tertiary{
 background:#111b28!important;color:#edf4fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page #nlSidebarCol,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-universal-sidebar,.nl-primary-nav,.nl-side-groups,.nl-side-footer,#nlMobileNav,.offcanvas-body){
 background:#182536!important;color:#dce8f4!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-app-header{
 background:linear-gradient(112deg,#101c2a,#222536 60%,#4b291f)!important;
 border-color:#5d4a43!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-app-header form[role="search"],
html[data-nl-mode="dark"] body.nl-themed-page .nl-app-header form[role="search"] input{
 background:#142435!important;color:#edf4fc!important;border-color:#50677d!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-main,.nl-side-child,.nl-side-name,.nl-side-heading-caption,.nl-side-toggle,.nl-side-signed){color:#d6e4f1!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-main.is-current,.nl-side-main[aria-current="page"],.nl-side-child.is-current){background:#d75e1d!important;color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-side-group.is-selected{background:#223447!important;border-color:#395169!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-theme-switch{background:#283a4d!important;color:#ffd0a1!important;border-color:#8a684e!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-breadcrumb,.nl-crumb,.iv-crumb,.i-eyebrow){color:#ffad76!important}
/* Dark surfaces: shared cards and all module-specific cards, including true standalone sections. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .card,.nl-card,.nl-dash-panel,.nl-dash-kpi,.nl-kpi-card,.nl-chart-card,.summary-card,
 .nl-role-dashboard-hero,.nl-analytics-hero,.nl-analytics-report,.nl-report-chart,
 .nl-admin-panel,.na-panel,.na-kpi,.na-recent>div,.na-advisory,
 .nl-user-half-layout>.card,.nl-user-hero,.nl-user-company-list,
 .cc-card,.cc-kpi,.cc-mini,.cu-card,.cu-kpi,.cu-mini,
 .i-work-card,.i-panel,.i-stat,.i-selected-summary,.i-record-header,.i-activity-row,.i-visual-card,
 .a-card,.a-stat,.a-toolbar,.a-preview,.a-readonly,
 .iv-panel,.iv-kpi,.iv-filter-bar,.iv-nav,.iv-table-wrap,.iv-fields,.iv-file-info,.iv-dialog,
 .nl-booking-metrics>div,.nl-guidance-lanes>div,.nl-booking-routes,.nl-route-card,.nl-route-empty,
 .nl-resumed-booking,.nl-quote-guide,.nl-final-confirm,.nl-nextstep-panel,.nl-next-choice,
 .nl18-booking-glance,.nl18-booking-facts>div,.nl18-quote-chart,.nl18-summary-tile,
 .nl18-feature-panel,.nl18-progress-panel,.nl18-modal,.nl18-preview-dialog,.nl18-file-card,
 .nl-bill-record,.nl-bill-stat,.nl-bill-search,.nl-bill-hero,.nl-invoice-summary-grid>div,
 .nl-payment-live-summary,.nl-payment-modal,.nl-delivery-option,
 .nl-claim-surface,.nl-claim-policy,.nl-claim-step,.nl-claim-note,.nl-claim-kpi,.nl-claim-empty,
 .nl-claim-preview-card,.nl-claim-preview-fact,.nl-claim-preview-document,.nl-claim-upload,
 .nl-report-table-pane,.nl-report-chart-info,.nl-report-shortcut,.nl-ops-card,.nl-ops-kpi,
 .nl-analytics-report,.nl-chart-empty,.nl-action-drawer,.nl18-page-welcome,
 .detail-card .details-grid>div,.shipment-summary,.shipment-summary>div,.ship-boxes>div,
 .stat,.stat-card,.status-card,.info-card,.summary-tile,.detail-tile,.nl-info-tile,
 .nl-report-chart,.nl-report-bottom,.nl-table-toolbar,.nl-table-pagination
 ){
 background:#1e2e40!important;background-image:none!important;
 border-color:#40556a!important;color:#edf4fc!important;
 box-shadow:0 10px 28px #080e1952!important;
}
/* Light-mode card wrappers and nested panels were the main cause of white-on-white. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .card-header,.card-body,.card-footer,.accordion-item,.accordion-header,.accordion-button,.accordion-body,
 .list-group-item,.dropdown-menu,.dropdown-item,.modal-content,.modal-header,.modal-body,.modal-footer,
 .nl18-modal-header,.nl18-modal-footer,.nl18-modal-row,.nl18-modal-grid,.nl18-table-addons,
 .nl18-column-menu,.nl-report-table-heading,.nl-report-chart,.nl-report-chart-body,
 .nl-claim-aside,.nl-claim-aside-body,.nl-claim-review,.nl-claim-context-line,
 .i-toolbar,.i-picker-modal,.i-seller-select,.i-country-results,.i-seller-suggest,.i-panel-summary,
 .iv-table-controls,.iv-modal,.iv-dialog-body,.iv-dialog-head,.iv-dialog-foot,.iv-local-bar,
 .nl-stepper,.nl-booking-steps,.nl-table-filters,.nl-table-toolbar,.nl-table-pagination,
 .nl18-preview-box,.nl18-modal-list,.nl-table-actions,.nl-action-bar,.nl-ops-actions,
 .nl-payment-review,.nl-invoice-summary,.nl-guidance-lanes>div
 ){
 background:#233448!important;background-image:none!important;
 border-color:#40556a!important;color:#edf4fc!important;
}
/* Inventory and Admin each define their own theme variables in local JSP styles. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-inv,.nl-infra,.nl-company-admin,.nl-customer-admin,.nl-audit-v16,.nl-admin-v16,.nl-claim-page,.analytics-dashboard){
 --iv-ink:#edf4fc;--iv-muted:#b8c9d9;--iv-accent:#ff9b51;--iv-line:#40556a;--iv-cream:#1e2e40;
 color:#edf4fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-inv :is(.iv-hero,.iv-nav,.iv-panel,.iv-kpi,.iv-filter-bar,.iv-table-wrap,.iv-dialog,.iv-fields,.iv-notice,.iv-local-bar,.iv-tabs-panel){
 background:#1e2e40!important;background-image:none!important;color:#edf4fc!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-infra :is(.i-hero,.i-work-card,.i-stat,.i-tabbar,.i-toolbar,.i-visual-card,.i-picker-modal,.i-panel,.i-country-results,.i-seller-suggest,.i-seller-select){
 background:#1e2e40!important;background-image:none!important;color:#edf4fc!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-company-admin,.nl-customer-admin,.nl-audit-v16) :is(.cc-hero,.cc-card,.cc-kpi,.cc-mini,.cc-modal,.cu-hero,.cu-card,.cu-kpi,.cu-mini,.cu-modal,.a-hero,.a-card,.a-stat,.a-toolbar){
 background:#1e2e40!important;background-image:none!important;color:#edf4fc!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-admin-v16,.analytics-dashboard) :is(.na-kpi,.na-panel,.na-recent>div,.nl-analytics-report,.nl-report-chart,.nl-report-table-pane,.nl-report-shortcut,.nl-report-layout-bar,.nl-ops-card,.nl-ops-kpi,.nl-ops-actions,.nl-chart-context){
 background:#1e2e40!important;background-image:none!important;color:#edf4fc!important;border-color:#40556a!important;
}
/* Form controls: all modules, including native controls and custom widgets. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 input:not([type="hidden"]):not([type="checkbox"]):not([type="radio"]):not([type="submit"]):not([type="button"]):not([type="file"]),
 select,textarea,.form-control,.form-select,.nl-product-query,.nl18-table-addons select
 ),
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-product-suggestions,.nl-user-company-list,.i-seller-suggest,.i-country-results){
 background:#142435!important;color:#edf4fc!important;-webkit-text-fill-color:#edf4fc!important;
 border:1px solid #50677d!important;box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,textarea)::placeholder{color:#aebfd0!important;-webkit-text-fill-color:#aebfd0!important;opacity:1!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,select,textarea,.form-control,.form-select):focus{
 border-color:#ffac69!important;box-shadow:0 0 0 .2rem #ff9b513b!important;outline-color:#ffac69!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.form-check-input,[type="checkbox"],[type="radio"]){background:#142435!important;border-color:#72879b!important;accent-color:#ec7b31}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.form-check-input:checked,[type="checkbox"]:checked,[type="radio"]:checked){background-color:#e8752b!important;border-color:#e8752b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-product-choice,.nl-user-company-option,.i-seller-option,.i-country-option){background:transparent!important;color:#edf4fc!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-product-choice:hover,.nl-product-choice.is-active,.nl-user-company-option:hover,.i-seller-option:hover,.i-country-option:hover){background:#35475b!important;color:#fff!important}
/* No low-contrast labels on dark or mixed surfaces. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(h1,h2,h3,h4,h5,h6,.h1,.h2,.h3,.h4,.h5,.h6,.card-title,.section-title,.stat-value,.nl-kpi-value,.iv-kpi strong,.i-stat strong,.cc-kpi strong,.cu-kpi strong){color:#f4f8ff!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(label,.form-label,legend,dt,dd,summary,.nl-form-label,.iv-field label,.i-field label){color:#e1ebf5!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.text-muted,.text-secondary,.text-body-secondary,.small,.form-text,.hint,.help,.sub,.description,.muted,.iv-counter,.i-help,.nl-claim-muted,.nl-report-guide){color:#b8c9d9!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(p,small,li,span,strong,td,th){border-color:#40556a}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.iv-kpi,.i-stat,.cc-kpi,.cu-kpi,.nl-dash-kpi,.nl-ops-kpi,.nl-booking-metrics>div,.nl-bill-stat,.nl18-summary-tile) :is(span,small,p,div){color:#bdcfde!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.iv-kpi,.i-stat,.cc-kpi,.cu-kpi,.nl-dash-kpi,.nl-ops-kpi,.nl-booking-metrics>div,.nl-bill-stat,.nl18-summary-tile) :is(strong,b,.value){color:#f4f8ff!important}
/* Dark table rendering for native + Bootstrap + domain-specific tables. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 table,.table,.data-table,.i-table,.cc-table,.cu-table,.a-table,.iv-table,.nl-report-table-pane table,.nl-bill-record table
 ){
 --bs-table-bg:#1e2e40;--bs-table-color:#edf4fc;
 --bs-table-striped-bg:#253649;--bs-table-striped-color:#edf4fc;
 --bs-table-hover-bg:#31445b;--bs-table-hover-color:#fff;
 --bs-table-border-color:#40556a;
 background:#1e2e40!important;color:#edf4fc!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.i-table,.cc-table,.cu-table,.a-table,.iv-table) thead,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.i-table,.cc-table,.cu-table,.a-table,.iv-table) thead :is(th,td){
 background:#2b3a50!important;color:#ffd1a8!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.i-table,.cc-table,.cu-table,.a-table,.iv-table) tbody :is(td,th){
 background:#1e2e40!important;color:#edf4fc!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.i-table,.cc-table,.cu-table,.a-table,.iv-table) tbody tr:nth-child(even) :is(td,th){background:#253649!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.i-table,.cc-table,.cu-table,.a-table,.iv-table) tbody tr:hover :is(td,th){background:#32465b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.table-responsive,.cc-table-wrap,.cu-table-wrap,.i-table-wrap,.iv-table-wrap){background:#1e2e40!important;border-color:#40556a!important}
/* Button palette - keep destructive and success semantics distinct. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn-light,.btn-outline-secondary,.btn-outline-dark,.btn-outline-warning,.btn-outline-primary,.nl-report-shortcut,.iv-btn:not(.primary),.i-secondary,.cc-btn-soft,.cu-btn-soft,.nl-qty-chip,.nl18-mini-btn,.nl-route-card,.nl-next-choice){
 background:#283a4d!important;color:#ffd0a1!important;border-color:#795e4b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn-light,.btn-outline-secondary,.btn-outline-dark,.btn-outline-warning,.nl-report-shortcut,.iv-btn:not(.primary),.i-secondary,.cc-btn-soft,.cu-btn-soft):hover{background:#354a60!important;color:#fff5e9!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn-primary,.btn-warning,.btn-success,.btn-danger,.i-primary,.iv-btn.primary){color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-booking-step.active,.nl-route-card[aria-pressed="true"],.nl18-tag.active){background:#764023!important;color:#fff2e4!important;border-color:#f3a464!important}
/* Informational states use purpose-built dark status surfaces. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.alert-light,.alert-warning,.bg-warning-subtle,.nl-claim-policy,.iv-notice,.i-banner,.nl-quote-guide,.nl-claim-note,.nl18-action-toast){background:#353f40!important;color:#f2dfc7!important;border-color:#746c51!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.alert-danger,.bg-danger-subtle,.nl-booking-error){background:#492c38!important;color:#ffd3d4!important;border-color:#895161!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.alert-success,.bg-success-subtle,.nl-resumed-booking){background:#223c37!important;color:#c0f3d9!important;border-color:#457b68!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge,.pill,.nl-pill,.nl-bill-status){border-color:#64788a}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge.bg-warning-subtle,.pill.blue,.nl-bill-status.archived){background:#40352d!important;color:#ffdda9!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge.bg-success-subtle,.pill.good){background:#24463e!important;color:#b3efce!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge.bg-danger-subtle,.pill.bad){background:#532d39!important;color:#ffc1c9!important}
/* Readable dialogs, tooltips, action menus and toasts on every route. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.modal-content,.nl18-modal,.nl18-preview-dialog,.i-modal .modal-content,.cc-modal .modal-content,.cu-modal .modal-content,.iv-dialog,.payment-dialog-surface,.nl-payment-modal,.nl-claim-preview-card,.nl18-action-toast,.nl-login-toast,.nl-modal-card){
 background:#1e2e40!important;background-image:none!important;color:#edf4fc!important;border-color:#52677b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.modal-header,.modal-body,.modal-footer,.nl18-modal-header,.nl18-modal-footer,.nl18-modal-row,.nl18-preview-box,.i-modal-note,.cc-modal-note,.cu-modal-note){
 background:#233448!important;color:#edf4fc!important;border-color:#52677b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.dropdown-menu,.dropdown-item,.popover,.tooltip-inner,.nl-header-dropdown){background:#233448!important;color:#edf4fc!important;border-color:#52677b!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.dropdown-item:hover,.dropdown-item:focus){background:#34495d!important;color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl18-modal,.nl18-preview-dialog,.i-modal,.cc-modal,.cu-modal,.iv-dialog) :is(h1,h2,h3,h4,h5,small,strong,label,p){color:#e6eff8!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-product-suggestions,.nl-user-company-list,.i-seller-suggest,.i-country-results,.dropdown-menu) :is(.dropdown-item,button,a){color:#edf4fc!important}
/* Dark outline links must remain legible on dark surfaces. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) a:not(.btn):not(.nav-link):not(.nl-side-child):not(.nl-side-main){color:#ffc18b}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn-close,.modal .btn-close){filter:invert(1) grayscale(1);opacity:.75}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.border,.border-top,.border-bottom,.border-start,.border-end,hr){border-color:#40556a!important}
/* Help text in shipment steps, source labels, and form values stays readable. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-role-dashboard-hero,.nl-booking-routes,.nl-final-confirm,.nl-claim-surface,.nl-inv,.analytics-dashboard) :is(.text-dark,.text-body,.text-muted,.text-secondary,.text-body-secondary){color:#bfd0e1!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-role-dashboard-hero,.nl-booking-routes,.nl-final-confirm,.nl-claim-surface,.nl-inv,.analytics-dashboard) :is(.fw-bold,strong,b){color:#f5f9ff!important}
/* Responsive nav, print, and reduced-motion. */
@media(max-width:767px){html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,.iv-panel,.nl18-preview-dialog){border-color:#41566b!important}}
@media print{html[data-nl-mode="dark"] body.nl-themed-page,html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,.iv-panel,.nl-analytics-report,.nl-bill-record){background:white!important;color:black!important;box-shadow:none!important}html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(h1,h2,h3,h4,h5,h6,td,th,p,span){color:black!important}}
/* Additional standalone surfaces revealed by all-55-JSP class audit. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .na-hero,.na-cardlet,.na-shortcuts,.na-status-chip,
 .cc-edit-notice,.cc-table-wrap,.cu-table-wrap,
 .i-record-section,.i-form-steps,.i-panel-summary,.i-modal-note,
 .profile-hero,.profile-badges,.detail-box,.account-panel-header,.account-panel-role,
 .page-hero,.journey-panel,.mv-card,.group-event-step,.nl-review-dialog,.nl-pl-toolbar,
 .nl-cancel-dialog,.nl-cancel-panel,.nl-container-info,.nl-record-section,
 .nl-record-info-grid,.nl-record-info-grid>div,.nl-record-archive-note,
 .shipment-records,.shipment-toolbar,.nl-progress-track,
 .nl-editor-card,.nl-chart-zoom-panel,.nl-zoom-filter-panel,
 .correction-preview,.nl-cargo-table,.nl-report-shortcuts,
 .nl-nextstep-panel,.nl-payment-modal,.nl-quote-step-current,
 .nl-claim-preview-actions,.nl-claim-preview-document,.nl-claim-preview-yes
 ){
 background:#1e2e40!important;background-image:none!important;
 color:#edf4fc!important;border-color:#40556a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .na-shortcuts a,.na-hero-links a,.na-status-chip,.nl18-nav-item,
 .nl-form-steps a,.i-form-steps a,.nl-report-shortcut,
 .nl-cancel-dialog button:not(.btn-danger),.nl-review-dialog button:not(.btn-danger)
 ){
 border-color:#795e4b!important;color:#ffd0a1!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-progress-count,.nl-record-section-icon,.step-dot,.stat-icon,.na-kpi-icon
 ){color:#ffbb86!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-progress-track,.nl-cargo-table,.data-table){border-color:#40556a!important}
/* Keep intentionally highlighted interactive selections recognizable. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.i-tab[aria-selected="true"],.iv-nav .iv-active,.nl-bill-tab[aria-current="page"],.nl-booking-step.active){background:#d65e1a!important;color:#fff!important;border-color:#f49f63!important}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-booking-step.active,.i-tab[aria-selected="true"],.iv-nav .iv-active) :is(span,b,strong){color:#fff!important}
/* Keep application illustrations intact instead of flattening images or drawing assets. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-halo,.i-hero-art,.iv-art,.nl-css-art,.nl-decorative-art){background-image:revert-layer}


/* v19.1 CONSOLIDATED DARK VISUAL SYSTEM. Existing light-mode presentation is unchanged. */
html[data-nl-mode="dark"]{
 --nl-ds-bg:#101722;--nl-ds-sidebar:#172536;--nl-ds-panel:#202e40;
 --nl-ds-panel-alt:#26384c;--nl-ds-panel-deep:#152333;--nl-ds-border:#455b70;
 --nl-ds-text:#f0f5fb;--nl-ds-muted:#bdcddd;--nl-ds-accent:#ffad6e;
 --nl-ds-input:#142538;--nl-ds-good:#a3f0c5;--nl-ds-bad:#ffc3c8;
 --bs-body-color:#f0f5fb;--bs-emphasis-color:#f8fbff;--bs-secondary-color:#bdcddd;
 --bs-body-bg:#101722;--bs-tertiary-bg:#202e40;--bs-secondary-bg:#26384c;
 --bs-border-color:#455b70;--bs-card-bg:#202e40;--bs-card-cap-bg:#26384c;
 --bs-table-bg:#202e40;--bs-table-color:#f0f5fb;
 --bs-table-striped-bg:#26384c;--bs-table-hover-bg:#31475c;
 --bs-form-control-bg:#142538;--bs-list-group-bg:#202e40;
 --bs-accordion-bg:#202e40;--bs-accordion-color:#f0f5fb;
}
/* Preserve existing sections while normalizing module-specific hard-coded light backgrounds. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .bg-white,.bg-light,.bg-body,.bg-body-secondary,.bg-body-tertiary,.bg-warning-subtle,
 .bg-info-subtle,.bg-primary-subtle,.border-light,
 .card,.card-body,.card-header,.card-footer,.card-group,.card-deck,
 .rounded-4.shadow-sm,.rounded-3.shadow-sm,.rounded-4.border,.rounded-3.border,
 .nl-panel,.nl-panel-soft,.nl-section,.nl-section-card,.nl-section-body,
 .section,.section-card,.section-body,.section-head,.section-header,
 .form-card,.form-panel,.form-section,.search-panel,.search-card,
 .summary,.summary-box,.summary-card,.summary-tile,.stat-tile,
 .metric,.metric-card,.kpi,.kpi-card,.metric-tile,.hero-card,.data-card,
 .alert-light,.alert-secondary,.alert-info,
 .form-shell,.card-shell,.content-card,.inner-card,.soft-card,.soft-panel,
 .nl-dashboard-summary,.nl-dashboard-strip,.nl-dashboard-actions,.nl-summary-strip,
 .nl-record-card,.nl-record-row,.nl-record-panel,.nl-record-detail,.nl-info-row,
 .page-content,.page-section,.page-header,.workspace-section,.workspace-panel,
 .nl-claim-timeline,.nl-claim-event,.nl-claim-evidence,.nl-claim-evidence-card,
 .nl-claim-form,.nl-claim-form-section,.nl-claim-steps,.nl-claim-detail,
 .nl-quote-row,.nl-quote-total,.nl-quote-summary,.nl-quote-card,.nl-quote-section,
 .nl-bill-metric,.nl-bill-summary,.nl-bill-card,.nl-bill-panel,.nl-bill-detail,
 .nl-invoice-card,.nl-invoice-row,.nl-invoice-detail,.nl-invoice-line,
 .nl-ops-overview,.nl-ops-hero,.nl-ops-section,.nl-ops-summary,.nl-analytics-card,
 .nl-report-card,.nl-report-panel,.nl-report-filter,.nl-report-metric,
 .nl-chart-box,.nl-chart-panel,.nl-chart-frame,.nl-chart-legend,.nl-chart-wrapper,
 .nl-record-info,.nl-record-info-grid>div,.nl-record-details,.nl-record-overview,
 .shipment-card,.shipment-summary,.shipment-row,.shipment-filters,.shipment-toolbar,
 .shipment-records,.shipment-details,.shipment-progress,.shipment-route,
 .movement-card,.movement-step,.movement-event,.movement-group,.movement-timeline,
 .detail-box,.detail-card,.detail-value,.details-grid>div,.detail-tile,
 .profile-fact,.profile-panel,.profile-layout,.profile-section-intro,.profile-security,
 .profile-permissions,.profile-quicktip,.profile-peek,.profile-note,.profile-hero,
 .account-panel,.account-panel-header,.account-panel-role,.profile-side,
 .nl-user-half-layout,.nl-user-half-layout>div,.nl-company-form,.nl-customer-form,
 .cc-table-wrap,.cu-table-wrap,.i-form-steps,.i-fields,.i-modal-note,
 .iv-summary,.iv-table-controls,.iv-tabs-panel,.iv-local-bar,.iv-notice,
 .nl-analytics-report,.nl-report-workspace,.nl-report-layout-bar,.nl-report-table-pane,
 .nl-report-chart-frame,.nl-chart-tools,.nl-shortcut-row,.nl-action-links,
 .nl18-feature-panel,.nl18-mini-panel,.nl18-summary-tile,.nl18-summary-card,
 .nl18-preview-content,.nl18-preview-header,.nl18-preview-actions
){background-color:var(--nl-ds-panel)!important;background-image:none!important;color:var(--nl-ds-text)!important;border-color:var(--nl-ds-border)!important;}
/* Distinct second-level surfaces to avoid an undifferentiated flat UI. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .card-header,.card-footer,.accordion-button,.accordion-header,.accordion-body,
 .list-group-item,.nl-table-toolbar,.nl-table-pagination,.nl18-table-addons,
 .nl-claim-note,.nl-claim-policy,.nl-claim-step,.nl-route-card,
 .nl-bill-stat,.nl-payment-live-summary,.nl-payment-review,
 .nl-booking-metrics>div,.nl-guidance-lanes>div,.nl18-booking-facts>div,
 .nl18-booking-glance,.nl18-quote-chart,.nl18-progress-panel,
 .nl-user-company-list,.i-seller-suggest,.i-country-results,.i-picker-modal,
 .profile-fact,.profile-quicktip,.profile-password-field,
 .nl-analytics-shortcuts,.nl-report-shortcut,.nl-report-chart-info,
 .nl-report-chart-meta,.nl-chart-context,.nl-report-table-heading,
 .nl-record-info-grid>div,.detail-box,.detail-tile
){background-color:var(--nl-ds-panel-alt)!important;color:var(--nl-ds-text)!important;border-color:var(--nl-ds-border)!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 h1,h2,h3,h4,h5,h6,.h1,.h2,.h3,.h4,.h5,.h6,
 .page-title,.panel-title,.section-title,.card-title,.profile-title,
 .nl-page-title,.nl-hero-title,.nl-report-title,.nl-claim-title,
 .nl-kpi-value,.stat-value,.metric-value,.value,.price-total,
 .text-dark,.text-body,.text-black,.text-warning-emphasis,.text-primary
){color:var(--nl-ds-text)!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 p,small,.small,.lead,.text-secondary,.text-muted,.text-body-secondary,
 .caption,.hint,.help,.help-text,.field-note,.form-text,.form-help,.muted,
 .sub,.subtitle,.description,.section-caption,.panel-caption,
 .kicker,.eyebrow,.iv-counter,.i-help,.profile-field-help,
 .profile-section-intro,.nl-report-guide,.nl-report-description,
 .nl-claim-muted,.nl-booking-note,.nl-booking-hint,
 .nl-quote-description,.nl-route-desc,.nl-route-footnote
){color:var(--nl-ds-muted)!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 label,legend,dt,summary,.form-label,.field-label,.nl-form-label,
 .nl-pay-field-heading,.nl-label,.nl-required-label,.iv-field label,.i-field label
){color:#e6f0fa!important;}
/* Fields, focus states, native controls, readonly/disabled, suggestions and autofill. */
html[data-nl-mode="dark"] body.nl-themed-page :is(input,select,textarea,.form-control,.form-select,.input-group-text) {color-scheme:dark;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 input:not([type=hidden]):not([type=checkbox]):not([type=radio]):not([type=button]):not([type=submit]),
 textarea,select,.form-control,.form-select,.input-group-text,.nl18-search-input,.nl-search-input
){background:var(--nl-ds-input)!important;color:var(--nl-ds-text)!important;
 -webkit-text-fill-color:var(--nl-ds-text)!important;border-color:#50677d!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,select,textarea,.form-control,.form-select):disabled,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,select,textarea,.form-control,.form-select)[readonly]{
 background:#243244!important;color:#c3d0df!important;-webkit-text-fill-color:#c3d0df!important;opacity:1!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,select,textarea)::placeholder{color:#b4c2d3!important;-webkit-text-fill-color:#b4c2d3!important;opacity:1;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,textarea,.form-control):-webkit-autofill,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,textarea,.form-control):-webkit-autofill:hover{
 -webkit-box-shadow:0 0 0 50px #142538 inset!important;-webkit-text-fill-color:#f0f5fb!important;caret-color:#f0f5fb!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,textarea,.form-control,select,.form-select):focus-visible{
 border-color:#ffb27b!important;outline-color:#ffb27b!important;box-shadow:0 0 0 3px rgba(255,174,102,.28)!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-user-company-list,.nl-product-suggestions,.i-seller-suggest,.i-country-results,[role=listbox],datalist){background:#1f3043!important;color:#f0f5fb!important;border-color:#526c84!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(option,.dropdown-item,.nl-product-choice,.i-seller-option,.i-country-option){background-color:#1f3043;color:#f0f5fb;}
/* Table and financial reports: striping, table-warning, scroll areas, toolbars, sticky headings. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.nl-report-table-pane table,.nl-pl-table,.data-table,.iv-table,.i-table,.cc-table,.cu-table,.a-table){
 --bs-table-bg:#202e40!important;--bs-table-color:#f0f5fb!important;
 --bs-table-striped-bg:#26384c!important;--bs-table-striped-color:#f0f5fb!important;
 --bs-table-hover-bg:#32475c!important;--bs-table-hover-color:#fff!important;
 --bs-table-border-color:#455b70!important;color:#f0f5fb!important;
 background:#202e40!important;border-color:#455b70!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.nl-pl-table,.data-table,.iv-table,.i-table,.cc-table,.cu-table,.a-table) :is(thead,thead th,thead td){background:#293b50!important;color:#ffca9e!important;border-color:#455b70!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.nl-pl-table,.data-table,.iv-table,.i-table,.cc-table,.cu-table,.a-table) tbody tr> :is(td,th){background:#202e40!important;color:#f0f5fb!important;border-color:#455b70!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.nl-pl-table,.data-table,.iv-table,.i-table,.cc-table,.cu-table,.a-table) tbody tr:nth-child(even)>:is(td,th){background:#26384c!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.nl-pl-table,.data-table,.iv-table,.i-table,.cc-table,.cu-table,.a-table) tbody tr:hover>:is(td,th){background:#32475c!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(table,.table,.nl-pl-table,.data-table,.iv-table,.i-table,.cc-table,.cu-table,.a-table) :is(.table-warning,.table-light,.table-secondary){background:#39445a!important;color:#ffcfaa!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.table-responsive,.nl-report-table-pane,.iv-table-wrap,.i-table-wrap,.cc-table-wrap,.cu-table-wrap,.nl-pl-table-wrap){background:#202e40!important;border-color:#455b70!important;scrollbar-color:#627a90 #192637;}
/* Existing data graphics should remain readable; legend controls and chart frames. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-chart-zoom-panel,.nl-chart-legend,.nl-report-chart-frame,.nl-report-chart,.nl-chart-wrapper,.nl-chart-tools,.nl-zoom-filter-panel,.nl-analytics-report,.nl-chart-context){background-color:#202e40!important;color:#f0f5fb!important;border-color:#455b70!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.nl-chart-meta,.nl-shortcut-title,.nl-chart-type-label,.nl-shortcut-desc,.nl-report-chart-meta,.nl-report-guide){color:#d1dfec!important;}
/* Semantic statuses preserve distinctive meaning in both themes. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.alert-warning,.alert-info,.nl-claim-policy,.nl-quote-guide,.iv-notice){background:#37404a!important;color:#ffdfb9!important;border-color:#776852!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.alert-danger,.invalid-feedback,.nl-error,.error-text,.nl-booking-error){color:#ffc3c8!important;border-color:#a56473!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.alert-danger,.nl-booking-error){background:#4a2f39!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.alert-success,.nl-success){background:#1e473a!important;color:#b6f4d4!important;border-color:#4c8e75!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge.bg-warning,.badge.bg-warning-subtle){color:#3b2618!important;background:#ffbf82!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge.bg-success,.badge.bg-success-subtle){color:#072a21!important;background:#94e7bb!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.badge.bg-danger,.badge.bg-danger-subtle){color:#3d111b!important;background:#ffb9c5!important;}
/* Modal surfaces also render correctly when moved under document.body. */
html[data-nl-mode="dark"] body.nl-themed-page :is(
 dialog,.modal-content,.modal-dialog .modal-content,[role=dialog],
 .nl-review-dialog,.nl-cancel-dialog,.nl-payment-modal,.payment-dialog-surface,
 .nl18-preview-dialog,.nl18-modal,.nl-modal-card,.cc-modal,.cu-modal,
 .i-modal,.i-picker-modal,.iv-dialog,.nl-claim-preview-card,.nl-claim-preview-document
){background:#202e40!important;color:#f0f5fb!important;border-color:#50677c!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .modal-header,.modal-body,.modal-footer,.nl18-modal-header,.nl18-modal-footer,
 .nl18-preview-box,.nl18-modal-row,.nl-review-head,.nl-review-body,
 .nl-review-actions,.nl-cancel-header,.nl-cancel-body,.nl-cancel-footer
){background:#26384c!important;color:#f0f5fb!important;border-color:#50677c!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(dialog,.modal-content,[role=dialog],.nl18-preview-dialog,.nl18-modal) :is(h1,h2,h3,h4,h5,h6,strong,label,p,small){color:#f0f5fb!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.modal-content,[role=dialog],dialog) :is(input,select,textarea){background:#142538!important;color:#f0f5fb!important;border-color:#50677c!important;}
/* Links, toolbar and secondary buttons, without obscuring primary, destructive or disabled states. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn-light,.btn-outline-secondary,.btn-outline-dark,.btn-outline-warning,.btn-outline-primary,.nl18-mini-btn,.nl-report-shortcut,.i-secondary,.iv-btn:not(.primary)){
 background:#2b3f54!important;color:#ffca9c!important;border-color:#8c6d5a!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn-light,.btn-outline-secondary,.btn-outline-dark,.btn-outline-warning,.btn-outline-primary,.nl18-mini-btn,.nl-report-shortcut):hover{background:#3b5269!important;color:#fff!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(button,a.btn,[role=button]):disabled{opacity:.62!important;cursor:not-allowed;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(a:not(.btn):not(.nav-link):not(.nl-side-main):not(.nl-side-child)){color:#ffbf8b;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn-primary,.btn-warning,.i-primary,.iv-btn.primary){color:#fff!important;}
/* Authenticated sidebar and mobile offcanvas don't inherit light Bootstrap utility styles. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-groups,.nl-side-group,.nl-side-footer,.nl-side-submenu,.nl-side-bottom,.nl-side-section,#nlSidebarCol,#nlMobileNav,.offcanvas-body,.nl-primary-nav){background:#172536!important;color:#dce6f0!important;border-color:#455b70!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-main,.nl-side-child,.nl-side-name,.nl-side-caption,.nl-side-label,.nl-side-toggle){color:#e0eaf4!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-side-main.is-current,.nl-side-child.is-current,.nl-side-main[aria-current=page],.nl-side-child[aria-current=page]){background:#d56522!important;color:#fff!important;}
/* Keep user-chosen accent contrast consistent in native scrollbars, date and select controls. */
html[data-nl-mode="dark"] body.nl-themed-page{scrollbar-color:#6b8197 #132032;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.dropdown-menu,.popover,.tooltip-inner){background:#25384c!important;color:#f0f5fb!important;border-color:#51677c!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.dropdown-menu,.popover) .dropdown-item:hover{background:#3a4f64!important;color:#fff!important;}
/* A dropdown moved to body bypasses parent overflow and remains above any page sections. */
.nl-header-menu-portal{position:fixed!important;display:block!important;z-index:2147483000!important;
 min-width:245px;padding:.5rem;border-radius:15px;border:1px solid #e4c7a8;
 background:#fff8f0;color:#4c3324;box-shadow:0 18px 44px rgba(24,13,6,.3);
 overflow-x:hidden;overflow-y:auto;}
.nl-header-menu-portal .dropdown-header{color:#926039;font-size:.75rem;font-weight:700;}
.nl-header-menu-portal .dropdown-item{color:#493122;padding:.67rem .85rem;border-radius:8px;font-weight:600;}
.nl-header-menu-portal .dropdown-item:hover,.nl-header-menu-portal .dropdown-item:focus{background:#fff0dd;color:#8e3510;}
.nl-header-menu-portal .dropdown-item:focus-visible{outline:2px solid #dd702d;outline-offset:-2px;}
.nl-header-menu-portal .dropdown-divider{border-color:#e5d3c3;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-header-menu-portal{background:#26384c!important;color:#f0f5fb!important;border-color:#536b83!important;box-shadow:0 20px 48px rgba(0,0,0,.55)!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-header-menu-portal :is(.dropdown-header,.dropdown-item){color:#eef5fc!important;background:transparent!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-header-menu-portal .dropdown-header{color:#ffbe8a!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-header-menu-portal .dropdown-item:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-header-menu-portal .dropdown-item:focus{background:#3a5066!important;color:#fff!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-header-menu-portal .dropdown-divider{border-color:#51677c!important;}
@media(max-width:767.98px){.nl-header-menu-portal{max-width:calc(100vw - 16px)!important;}}
@media(prefers-reduced-motion:reduce){.nl-header-menu-portal{animation:none!important;transition:none!important;}}
@media print{html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,.report-card,.nl-analytics-report,table,td,th){background:#fff!important;color:#111!important;box-shadow:none!important;} .nl-header-menu-portal{display:none!important;}}


/* N-LOGISTIC v19.2 — dark appearance repairs from the role-by-role screenshots.
   Additive presentation only; keep original light colors and all form behavior. */
html[data-nl-mode="dark"] body.nl-themed-page {
 --nl-ds-bg:#111b28;--nl-ds-sidebar:#172536;--nl-ds-panel:#202f42;
 --nl-ds-panel-alt:#2b3e52;--nl-ds-panel-deep:#172638;--nl-ds-border:#455d74;
 --nl-ds-text:#f2f6fc;--nl-ds-muted:#bfcedd;--nl-ds-accent:#ffb57d;
 --nl-ds-input:#132334;--nl-ds-good:#a8f0ce;--nl-ds-bad:#ffd0d5;
 --ink:#f2f6fc;--text:#e8f0f8;--muted:#bfcedd;--line:#455d74;
 --paper:#202f42;--cream:#2b3e52;--bg:#111b28;
 color-scheme:dark;
}
/* Unified dark panels. A deliberately restrained second-level surface keeps the hierarchy. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .page-hero,.nl-auto-hero,.nl-screen-hero,.nl-page-hero,.nl-hero,.hero,.hero-card,
 .na-quick-actions,.na-panel,.na-status-chip,.na-shortcuts a,.na-recent>div,.na-advisory,
 .nl18-page-welcome,.nl18-feature-panel,.nl18-booking-glance,.nl18-booking-facts>div,
 .nl-dash-panel,.nl-dash-kpi,.nl-action-link,.nl-ops-kpi,.nl-ops-panel,
 .shipment-records,.shipment-toolbar,.shipment-row,.shipment-row:nth-child(even),
 .shipment-record,.shipment-reference,.shipment-route,.shipment-insight,
 .nl-container-info,.shipment-summary .row-facts>span,.nl-progress-count,.nl-cancel-inline,
 .movement-group,.movement-group>summary,.movement-viewactions,.movement-viewbar,
 .group-body,.group-footer,.group-utility,.group-event,.group-event-row,.group-summary,
 .journey-panel,.journey-scroll,.journey-cancel-note,.journey-dot,
 .timeline-item,.timeline-marker,.timeline-entry,.timeline-card,.progress-step,
 .nl-payment-balance-overview>div,.nl-payment-due,.nl-payment-mode-option,
 .nl-payment-live-summary>div,.nl-payment-workspace,.nl-payment-heading,
 .nl-payment-invoice-pill,.nl-delivery-option,.nl-delivery-option:hover,
 .profile-fact,.profile-note,.profile-quicktip,.profile-bulk-actions,.profile-peek,
 .profile-security-toggle,.profile-links,.profile-panel,.profile-permissions,
 .nl18-section-jumps a,.nl18-section-jumps a:hover,.nl18-section-jumps a:focus,
 .nl-section-index a,.nl-section-index a:hover,.nl-section-index a:focus,
 .nl-page-tools,.nl-page-tools-menu,.nl-page-meta-row,
 .nl-review-fact,.nl18-preview-box,.nl18-preview-content,.nl18-summary-card,
 .nl-record-section,.nl-record-info-grid>div,.nl-record-info,.nl-record-overview,
 .nl-claim-surface,.nl-claim-form,.nl-claim-note,.nl-claim-evidence,.nl-claim-policy,
 .nl-report-layout-bar,.nl-analytics-report,.nl-report-shortcut,.nl-chart-zoom-panel,
 .nl-bill-stat,.nl-bill-summary,.nl-bill-detail,.nl-invoice-card,
 .i-work-card,.i-work-card .i-panel,.i-table-wrap,.i-toolbar,.i-selected-summary,
 .iv-panel,.iv-kpi,.iv-tabs-panel,.iv-table-wrap
){background-color:var(--nl-ds-panel)!important;background-image:none!important;color:var(--nl-ds-text)!important;
 border-color:var(--nl-ds-border)!important;box-shadow:none!important;}
/* Preserve hierarchy: sub-cards slightly lighter than their parent. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .shipment-summary .row-facts>span,.nl-container-info,.nl-progress-count,
 .nl-payment-balance-overview>div,.nl-payment-live-summary>div,.nl-payment-mode-option,
 .profile-fact,.profile-note,.profile-bulk-actions,.nl18-booking-facts>div,
 .na-shortcuts a,.na-recent>div,.nl18-section-jumps a,.nl-section-index a,
 .journey-dot,.nl-record-info-grid>div,.nl18-preview-box,.nl-report-shortcut,
 .nl-bill-stat,.nl-bill-summary,.nl-invoice-row,.nl-claim-note,.nl-claim-policy
){background-color:var(--nl-ds-panel-alt)!important;color:var(--nl-ds-text)!important;}
/* Fix light backgrounds imposed by component-scoped backgrounds, gradients and Bootstrap utilities. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .bg-white,.bg-light,.bg-body,.bg-body-tertiary,.bg-body-secondary,.bg-warning-subtle,
 .bg-info-subtle,.bg-gradient:not(.btn):not(.badge),.bg-primary-subtle,
 .border-warning-subtle,.alert-light,.alert-warning,.alert-info,
 .rounded-4.shadow-sm,.rounded-3.shadow-sm,.card,.card-body,.card-header,.card-footer,
 .btn-light,.btn-outline-dark,.btn-outline-secondary,.btn-outline-warning,
 .btn-outline-primary,.btn-outline-info,.btn-outline-light,
 .nl18-table-addons,.nl18-toolbar,.nl18-table-controls,.nl18-summary-tile,
 .nl18-section-jumps,.nl18-mini-btn,.nl18-preview-button,
 .nl18-modal,.nl18-modal-head,.nl18-modal-body,.nl18-modal-actions,
 .nl18-progress-panel,.nl18-quote-chart,.nl18-file-card,.nl18-mini-panel,
 .nl-quote-total,.nl-quote-row,.nl-quote-guide,.nl-route-card
){background-color:var(--nl-ds-panel)!important;background-image:none!important;
 border-color:var(--nl-ds-border)!important;color:var(--nl-ds-text)!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl18-feature-panel,.nl18-preview-dialog,.nl18-booking-glance,.nl18-quote-chart,
 .shipment-row,.na-quick-actions,.nl-payment-workspace,.journey-panel
){box-shadow:0 12px 28px rgba(0,0,0,.16)!important;}
/* White-on-white / pale-on-pale failures: text inside formerly light cards. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .na-quick-actions,.na-shortcuts,.shipment-records,.shipment-row,
 .movement-group,.journey-panel,.nl-payment-workspace,.profile-overview,
 .profile-panel,.profile-layout,.nl-auto-hero,.nl-page-hero,
 .nl18-feature-panel,.nl18-booking-glance,.nl-record-overview
) :is(h1,h2,h3,h4,h5,h6,strong,b,dt,dd,.value,.stat-value,.nl-kpi-value,
 .nl-section-title,.nl-card-heading,.nl-card-heading strong,.nl-route-stop strong,
 .nl-reference-value .mono,.nl-container-value,.nl-container-value .mono,
 .row-facts b,.row-facts strong,.reference-line .mono,.mono,.route-pair>span,
 .route-pair>span:first-child,.route-pair>span:last-child,
 .nl-status-head,.nl-payment-live-summary strong,.nl-payment-balance-overview strong,
 .journey-stage-label,.payment-review dd
){color:var(--nl-ds-text)!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .na-quick-actions,.shipment-records,.shipment-row,.movement-group,.journey-panel,
 .nl-payment-workspace,.profile-overview,.profile-panel,.profile-layout,
 .nl-auto-hero,.nl-page-hero,.nl18-feature-panel,.nl18-booking-glance,
 .nl-record-overview
) :is(p,small,span,li,.small,.muted,.sub,.row-kicker,.nl-label,
 .nl-section-title,.nl-status-description,.nl-help,.stat-sub,.nl-route-connector,
 .journey-head p,.journey-stage-caption,.nl-payment-reference-help,
 .profile-section-intro,.profile-field-help,.fact-caption,.fact-note,
 .nl-payment-mode-option small,.nl-payment-balance-overview span,.nl-payment-live-summary span
){color:var(--nl-ds-muted)!important;}
/* Labels on button/card accents should not inherit pale blue from a distant container. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-section-title,.nl-card-heading,.row-kicker,.nl-label,.caps,.nl-payment-eyebrow,
 .na-eyebrow,.section-mark,.i-eyebrow,.nl18-eyebrow,.nl-claim-eyebrow
){color:var(--nl-ds-accent)!important;}
/* Status and important UI colors that must stand out against navy. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-route-dot,.journey-dot,.nl-card-id-mark,.na-kpi-icon,.stat-icon
){border-color:#d98245!important;color:#ffbb86!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-progress-track span,.journey-rail
){background-color:#43576b!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-progress-track span.is-complete,.journey-fill
){background-color:#df772d!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-progress-track span.is-current,.journey-stage.current .journey-dot,
 .journey-stage.done .journey-dot
){background:#cc611e!important;color:#fff!important;border-color:#ffb781!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .journey-stage.current .journey-stage-label,.journey-stage.current .journey-stage-caption,
 .shipment-actions .status-action,.mini-copy,.nl18-section-jumps a:hover
){color:#ffc18b!important;}
/* Buttons and links: no cream fill and no pale label on pale background. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .btn.light,.btn.ghost,.btn-outline-warning,.btn-outline-secondary,.btn-outline-dark,
 .nl18-mini-btn,.nl18-preview-button,.mini-copy,.nl-amount-chip,
 .na-quick-actions-grid a,.nl-action-link,.nl-quick-action,.nl-profile-quicknav a,
 .profile-hero-actions .btn,.shipment-actions .btn.light,.nl-page-tools,.nl-page-tools-button
){background:#294059!important;background-image:none!important;color:#ffe1c6!important;
 border-color:#61738a!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .btn.light,.btn.ghost,.btn-outline-warning,.btn-outline-secondary,.btn-outline-dark,
 .nl18-mini-btn,.nl18-preview-button,.mini-copy,.na-quick-actions-grid a,
 .nl-action-link,.nl-profile-quicknav a
):hover{background:#36516b!important;color:#fff!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .btn.primary,.btn-warning,.btn-primary,.i-primary,.iv-btn.primary,
 .shipment-actions .btn.primary,.nl-payment-submit-row button
){background:#d6611a!important;background-image:none!important;color:#fff!important;
 border-color:#e88746!important;}
/* Workflows: shipment rows must have no light strip or hidden labels. */
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] :is(.nl-view-body,.content-wrap) .shipment-row> :is(.shipment-reference,.shipment-route,.shipment-insight),
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] :is(.nl-view-body,.content-wrap) .shipment-row .shipment-summary,
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] :is(.nl-view-body,.content-wrap) .shipment-row .nl-status-head,
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] :is(.nl-view-body,.content-wrap) .shipment-row .row-facts,
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] :is(.nl-view-body,.content-wrap) .shipment-row:nth-child(even),
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"] :is(.nl-view-body,.content-wrap) .shipment-row:nth-child(odd){
 background:#202f42!important;color:#f2f6fc!important;border-color:#455d74!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) .shipment-row .nl-container-info,
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) .shipment-row .row-facts>span{
 background:#2b3e52!important;color:#dce8f4!important;border:1px solid #50667b!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-route-connector,.shipment-insight,.shipment-route,.shipment-actions,.container-sub,
 .records-pagination,.shipment-row>.shipment-route,.shipment-row>.shipment-insight
){border-color:#50667b!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .shipment-toolbar,.status-tabs,.records-tools,.nl-record-section,.nl-record-section-heading
){color:#dce8f4!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) .status-tab:not(.is-active){color:#d4e2ee!important;background:#26384b!important;}
/* Movement history: all grouped rows, event blocks and expanded history. */
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-movementtracking"] :is(.nl-view-body,.content-wrap) :is(
 .movement-group,.movement-group>summary,.group-heading,.group-header,
 .group-body,.group-footer,.group-event,.group-event-row,.group-utility,
 .group-event-detail,.group-detail,.group-remarks,.group-note,
 .group-event-note,.group-event-remark,.group-aside,.group-controls,
 .movement-viewactions,.movement-viewbar,.movement-viewbar .view-switch,
 .date-chip,.movement-list,.movement-item,.timeline-item,.timeline-head,
 .timeline-body,.nl-event-card,.nl-timeline-card
){background:#202f42!important;color:#eaf2fa!important;border-color:#465d73!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module2-movementtracking"] :is(.nl-view-body,.content-wrap) :is(
 .group-note,.group-remarks,.group-event-remark,.group-event-note,.group-detail,
 .group-event-body,.group-event-remarks,.group-text
){background:#2b3e52!important;color:#dce8f4!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .movement-group,.group-body,.group-footer,.group-heading,.journey-panel,
 .journey-scroll,.journey-stage,.journey-stage-label,.journey-stage-caption
) :is(p,small,span,small,strong,b){color:inherit;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) .journey-stage :is(.journey-stage-label,.journey-stage-caption){color:#d6e3ef!important;}
/* Dark booking + tracking hero: retain CSS cargo illustration, not cream header panels. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .page-hero,.nl-page-hero,.nl-screen-hero,.nl-auto-hero,.nl-analytics-hero
){background:#202f42!important;background-image:none!important;color:#f2f6fc!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .page-hero,.nl-page-hero,.nl-screen-hero,.nl-auto-hero,.nl-analytics-hero
) :is(h1,h2,h3,h4,h5,h6,p,small,.sub,.subtitle){color:#eaf2fa!important;}
/* Payments: explicitly style each figure, selector and footer in addition to the modal. */
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module5-details"] :is(.nl-view-body,.content-wrap) :is(
 .nl-payment-balance-overview>div,.nl-payment-due,.nl-payment-mode-option,
 .nl-payment-live-summary>div,.nl-payment-invoice-pill,.nl-payment-help,
 .nl-payment-heading,.nl-payment-mode-grid,.nl-payment-reference-help,
 .nl-partial-shortcuts,.nl-amount-chip
){background:#2b3e52!important;color:#eff5fc!important;border-color:#50667b!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module5-details"] :is(.nl-view-body,.content-wrap) :is(
 .nl-payment-balance-overview>div,.nl-payment-mode-option,.nl-payment-live-summary>div
) :is(span,small,strong,b,p){color:#eff5fc!important;}
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module5-details"] :is(.nl-view-body,.content-wrap) .nl-payment-mode-option small,
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module5-details"] :is(.nl-view-body,.content-wrap) :is(.nl-payment-help,.nl-payment-reference-help,.payment-subtitle){color:#c3d1e1!important;}
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module5-details"] :is(.nl-view-body,.content-wrap) .nl-payment-mode-grid input:checked + .nl-payment-mode-option{
 background:#384357!important;border-color:#ffac6d!important;box-shadow:inset 4px 0 #e77734!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-payment-progress{background:#35495e!important;border-color:#526a80!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-payment-progress-fill{background:linear-gradient(90deg,#cc5c16,#ffb166)!important;}
/* All payment confirmation elements (dialog is appended directly under <body>). */
html[data-nl-mode="dark"] body.nl-themed-page :is(
 #paymentConfirmDialog .payment-dialog-surface,.payment-dialog-surface,.payment-dialog-header,
 .payment-dialog-icon,.payment-amount-box,.payment-review,.payment-warning,
 .payment-actions,.payment-cancel,.nl-payment-reference-toast
){background:#202f42!important;background-image:none!important;color:#f2f6fc!important;
 border-color:#526a80!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 #paymentConfirmDialog .payment-amount-box,#paymentConfirmDialog .payment-warning,
 .nl-payment-reference-toast
){background:#2b3e52!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 #paymentConfirmDialog .payment-dialog-surface,#paymentConfirmDialog .payment-warning,
 #paymentConfirmDialog .payment-amount-box,#paymentConfirmDialog .payment-review,
 .nl-payment-reference-toast
) :is(h1,h2,h3,h4,h5,h6,strong,b,span,p,dt,dd,small){color:#f2f6fc!important;}
html[data-nl-mode="dark"] body.nl-themed-page #paymentConfirmDialog .payment-review dt{color:#c5d2e0!important;}
html[data-nl-mode="dark"] body.nl-themed-page #paymentConfirmDialog .payment-amount-box strong{color:#ffbd83!important;}
html[data-nl-mode="dark"] body.nl-themed-page #paymentConfirmDialog .payment-confirm{background:#d6611a!important;color:#fff!important;border-color:#fa9c60!important;}
html[data-nl-mode="dark"] body.nl-themed-page #paymentConfirmDialog .payment-cancel{background:#2b3e52!important;color:#f2f6fc!important;border-color:#526a80!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-reference-toast>button{color:#eff5fc!important;}
/* Other modal / preview/confirmation families used by modules and common UI. */
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .modal-content,.modal-header,.modal-body,.modal-footer,
 .nl18-overlay .nl18-modal,.nl18-modal,.nl18-modal-head,.nl18-modal-body,
 .nl18-modal-footer,.nl18-modal-actions,.nl18-preview-dialog,
 .nl-review-dialog,.nl-review-head,.nl-review-body,.nl-review-actions,
 .nl-cancel-dialog,.nl-cancel-panel,.nl-cancel-top,.nl-cancel-impact,
 .nl-cancel-note,.nl-cancel-explainer,.nl-cancel-footer,
 .i-picker-modal,.cc-modal .modal-content,.cu-modal .modal-content,
 .iv-dialog,.nl-claim-preview-card,.nl-claim-review-dialog,
 .payment-dialog-surface,[role="dialog"].nl-modal-card
){background:#202f42!important;background-image:none!important;color:#f2f6fc!important;
 border-color:#50677e!important;box-shadow:0 16px 42px rgba(0,0,0,.3)!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .nl-review-head,.nl-cancel-top,.nl18-modal-head,.modal-header,
 .nl-review-fact,.nl-cancel-impact,.nl-cancel-note,.nl18-preview-box,
 .i-modal-note,.cc-modal-note,.cu-modal-note
){background:#2b3e52!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .modal-content,.nl18-modal,.nl18-preview-dialog,.nl-review-dialog,
 .nl-cancel-dialog,.nl-claim-preview-card,[role="dialog"]
) :is(h1,h2,h3,h4,h5,h6,strong,b,p,small,span,label,dt,dd,summary){color:#eff5fc!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .modal-content,.nl18-modal,.nl18-preview-dialog,.nl-review-dialog,
 .nl-cancel-dialog,.nl-claim-preview-card,[role="dialog"]
) :is(input:not([type="checkbox"]):not([type="radio"]),select,textarea,.form-control,.form-select){
 background:#132638!important;color:#eff5fc!important;-webkit-text-fill-color:#eff5fc!important;border-color:#5c7184!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .nl-review-actions,.nl-cancel-footer,.modal-footer,.nl18-modal-footer
) :is(.btn-light,.btn-outline-secondary,button:not(.primary):not(.btn-primary):not(.btn-warning):not(.btn-danger)){
 background:#2d4258!important;color:#f2f6fc!important;border-color:#61768a!important;}
/* Profile and account settings: remove all white fact cards and pale note strips. */
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module1-profile"] :is(.nl-view-body,.content-wrap) :is(
 .profile-fact,.profile-note,.profile-quicktip,.profile-bulk-actions,
 .profile-panel,.profile-peek,.profile-security-content,.profile-security-toggle,
 .profile-permissions,.profile-overview>div,.profile-links a,
 .profile-hero-actions .btn,.nl-profile-quicknav a,
 .card,.card.soft
){background:#202f42!important;background-image:none!important;color:#eff5fc!important;
 border-color:#455d74!important;}
html[data-nl-mode="dark"] body.nl-themed-page[data-nl-screen="module1-profile"] :is(.nl-view-body,.content-wrap) :is(
 .profile-fact,.profile-note,.profile-quicktip,.profile-bulk-actions,
 .profile-overview>div,.profile-permissions li
) :is(p,small,span,strong,b){color:#eaf2fa!important;}
/* Refine page-tools and on-page shortcuts; no remaining white navigation chips. */
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .nl-page-tools,.nl-page-tools button,.nl-page-tools-menu,
 .nl18-section-jumps a,.nl-section-index a,.nl18-page-welcome button,
 .nl18-page-welcome a,.nl18-mini-actions button
){background:#293f55!important;background-image:none!important;color:#f3f7fc!important;
 border-color:#5a7187!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .nl18-section-jumps a,.nl-section-index a,.nl-page-tools button,.nl18-mini-actions button
):hover{background:#38516b!important;color:#fff!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-section-jumps span{color:#c8d7e5!important;}
/* Colour contrast on generic inline light chip/pill patterns and buttons. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .pill:not(.good):not(.bad):not(.blue),.badge.bg-light,.badge.bg-white,
 .nl18-tag,.nl18-mini-btn,.nl-shortcut-pill,.nl-page-index-chip
){background:#2b3e52!important;color:#ffd1a6!important;border-color:#5a7187!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .alert-warning,.alert-info,.iv-notice,.nl-claim-policy,.i-banner,
 .nl-quote-guide,.nl-claim-note,.nl-payment-inline-error
){background:#374353!important;color:#ffddb9!important;border-color:#877153!important;}
/* Screen-specific fixed hues: do not globally hide or remove content. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .text-white-50,.text-black-50,.text-body-tertiary,.text-warning-emphasis,
 .text-info-emphasis,.text-primary-emphasis
){color:#c9d8e7!important;}
@media (max-width:767px){
 html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .shipment-row,.shipment-toolbar,.movement-group,.nl-payment-workspace,
 .nl-payment-balance-overview>div,.na-quick-actions,.profile-fact
 ){border-color:#526b80!important;}
}
@media print{
 html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .card,.nl-card,.shipment-row,.payment-card,.invoice-print,.nl-invoice-print,
 .nl-report-card,.nl-analytics-report,table,td,th
 ){background:white!important;color:black!important;box-shadow:none!important;}
}


/* Remaining component families use the same dark surface system. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .iv-nav,.iv-pill,.iv-filter-bar,.iv-file-info,.iv-form,
 .iv-hero,.iv-hero-content,.iv-card,.iv-toolbar,.iv-empty,
 .nl-ops-hero,.nl-ops-card,.nl-ops-summary,.nl-ops-shortcuts,
 .nl-user-hero,.nl-user-card,.nl-editor-card,.nl-editor-toolbar,
 .a-hero,.a-card,.a-toolbar,.a-chip,.a-row-btn,
 .cc-hero,.cc-card,.cc-kpi,.cc-form,.cc-edit-notice,.cc-edit-hint,
 .cu-hero,.cu-card,.cu-kpi,.cu-form,
 .i-hero,.i-record-section,.i-form-steps,.i-panel-summary,.i-selected-summary,
 .i-row-btn,.i-pill,.i-picker-action,.i-picker-modal,.i-empty,
 .nl-bill-hero,.nl-bill-record,.nl-bill-status,.nl-bill-toolbar,
 .nl-chart-card,.nl-zoom-filter-panel,.nl-report-shortcuts,
 .nl-report-table-pane,.nl-report-table-heading,.nl-report-chart,.nl-chart-tools,
 .nl-chart-empty,.nl-chart-context,.nl-nextstep-panel,.nl-next-choice,
 .nl-claim-aside-heading,.nl-claim-preview-card,.nl-claim-preview-actions,
 .nl-claim-pill,.nl-claim-kpi,.nl-claim-history,.nl-claim-timeline,
 .nl-record-archive-note,.nl-cancel-form,.nl-cancel-feedback,.nl-cancel-explainer,
 .nl-grouped-card,.date-chip,.group-symbol,.group-event-step
){background:#202f42!important;background-image:none!important;color:#edf5fc!important;
 border-color:#455d74!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .iv-pill,.i-pill,.nl-claim-pill,.nl-bill-status,.a-chip,.date-chip,
 .cc-edit-hint,.cu-edit-hint,.i-panel-summary,.nl-next-choice,
 .nl-record-archive-note,.nl-claim-kpi,.nl-ops-kpi
){background:#2b3e52!important;color:#ffd1ac!important;border-color:#556b80!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .iv-hero,.nl-ops-hero,.nl-user-hero,.a-hero,.cc-hero,.cu-hero,.i-hero,.nl-bill-hero
) :is(h1,h2,h3,p,.sub,.subtitle,small){color:#f1f5fc!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .iv-nav,.iv-filter-bar,.i-form-steps,.nl-report-shortcuts,.nl-chart-tools,
 .a-toolbar,.i-toolbar,.cc-form,.cu-form,.nl-bill-toolbar
) :is(a,button,span,label){color:#eaf3fc!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .iv-nav .iv-active,.i-tab[aria-selected="true"],.nl-bill-tab[aria-current="page"],
 .nl-booking-step.active,.status-tab.is-active
){background:#cf5a19!important;color:#fff!important;border-color:#f0a36b!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-chart-empty,.nl-report-chart,.nl-report-chart-frame,.nl-chart-zoom-panel,
 .nl-zoom-filter-panel,.nl-chart-context
){background:#202f42!important;color:#eaf3fc!important;border-color:#455d74!important;}
/* Error/success banners keep semantic colors while remaining dark, not cream. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-booking-error,.error,.error-banner,.alert-danger,.nl-claim-error
){background:#4c2d38!important;color:#ffd0d5!important;border-color:#ad6574!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .success,.success-banner,.alert-success,.nl-claim-success
){background:#21443a!important;color:#b9f6d9!important;border-color:#599b7e!important;}
/* Universal scrollbar and focus line in the two available themes. */
html[data-nl-mode="dark"] body.nl-themed-page :is(
 :is(.nl-view-body,.content-wrap),.nl-report-table-pane,.table-responsive,.journey-scroll,.movement-groups
){scrollbar-color:#7891a5 #1b2a3a;}
html[data-nl-mode="dark"] body.nl-themed-page :is(a,button,input,select,textarea,summary):focus-visible{
 outline-color:#ffb781!important;outline-offset:2px;}


/* v19.3 UNIVERSAL DARK CANVAS: targets both native MVC2 .content-wrap and JSP .nl-view-body. */
html[data-nl-mode="dark"] body.nl-themed-page{
 --ink:#f1f6fd;--text:#e2ebf6;--muted:#bccddd;--line:#465e76;
 --paper:#203044;--cream:#2a3d52;--bg:#111b28;--shadow:0 6px 17px rgba(0,0,0,.14);
 --nl-ink:#f1f6fd;--nl-muted:#c0cedd;--nl-soft:#27384c;--nl-cream:#203044;
 --nl-tint:#26394e;--nl-bg:#111b28;--nl-line:#465e76;--nl-orange:#f17c39;
 --nl-orange-deep:#ffaf76;--bs-body-color:#edf4fb;--bs-body-bg:#111b28;
 --bs-secondary-color:#bccddd;--bs-tertiary-color:#b2c5d7;--bs-border-color:#465e76;
 --bs-secondary-bg:#2a3d52;--bs-tertiary-bg:#203044;--bs-emphasis-color:#f2f7ff;
 color:#f1f6fd!important;color-scheme:dark;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) {
 color:#eef4fc!important;--bs-body-bg:#111b28;--bs-body-color:#eef4fc;
}
/* Primary and secondary surfaces; no light-colored cards remain within actual application content. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .card,.card-body,.card-header,.card-footer,.stat,.detail-box,.expander,.empty,
 .page-hero,.page-heading.page-hero,.nl-screen-hero,.nl-auto-hero,.nl-page-hero,
 .nl18-page-welcome,.nl18-feature-panel,.nl18-booking-glance,.nl18-quote-chart,
 .nl18-summary-tile,.nl18-progress-panel,.nl18-mini-panel,.nl18-modal,
 .shipment-row,.shipment-row:nth-child(even),.shipment-row:nth-child(odd),
 .shipment-records,.shipment-toolbar,.shipment-summary,.shipment-reference,
 .shipment-route,.shipment-insight,.shipment-actions,.nl-record-section,
 .nl-record-section>.card,.nl-record-overview,.nl-record-info-grid>div,.nl-cargo-table,
 .movement-group,.movement-group>summary,.group-body,.group-event,.group-footer,
 .timeline-item,.journey-panel,.journey-head,.journey-scroll,.journey-stage,
 .na-quick-actions,.na-shortcuts,.na-panel,.na-hero,.na-status-row,.na-kpi,
 .profile-fact,.profile-note,.profile-bulk-actions,.profile-panel,.profile-overview,
 .profile-security,.profile-security-content,.profile-quicktip,.profile-links,
 .nl-payment-workspace,.nl-payment-balance-overview>div,.nl-payment-live-summary>div,
 .nl-payment-mode-option,.nl-claim-surface,.nl-claim-note,.nl-claim-policy,
 .nl-bill-stat,.nl-bill-record,.nl-bill-summary,.nl-invoice-card,.nl-invoice-row,
 .nl-report-chart,.nl-report-shortcut,.nl-chart-card,.nl-analytics-report,
 .nl-report-table-pane,.nl-ops-panel,.nl-ops-kpi,.nl-ops-card,
 .nl-nextstep-panel,.nl-next-choice,.nl-final-confirm,.nl-quote-guide,
 .iv-panel,.iv-kpi,.iv-table-wrap,.iv-filter-bar,.iv-dialog,.iv-dialog-head,.iv-dialog-foot,
 .i-work-card,.i-panel,.i-record-section,.i-selected-summary,.cc-card,.cu-card,.a-card,
 .nl18-section-jumps,.nl18-section-jumps a,.nl-section-index a,
 .nl18-table-controls,.nl18-table-addons,.nl18-toolbar,.nl18-preview-dialog,
 .bg-white,.bg-light,.bg-body,.bg-body-secondary,.bg-body-tertiary,.bg-warning-subtle,
 .alert-light,.alert-warning,.alert-info
 ){
 background-color:#203044!important;background-image:none!important;
 color:#edf4fc!important;border-color:#465e76!important;
 box-shadow:none!important;
}
/* Raised/inner data surfaces have a consistent second dark level, without pale rectangles. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .shipment-summary .row-facts>span,.shipment-row .nl-container-info,
 .nl-record-info-grid>div,.nl-record-section .nl-record-info-grid>div,
 .nl-payment-balance-overview>div,.nl-payment-live-summary>div,
 .nl-payment-mode-option,.profile-fact,.na-shortcuts a,.na-quick-actions-grid a,
 .nl18-booking-facts>div,.nl18-summary-tile,.nl-ops-kpi,
 .nl-cancel-impact>div,.nl-claim-kpi,.nl-claim-history,.iv-mini,.iv-detail,
 .nl-payment-recap-row,.nl-quote-row,.nl-route-card,.nl-bill-stat,
 .group-event .event-comment,.group-event .event-location
 ){
 background:#2b3e52!important;color:#edf5fc!important;border-color:#526d85!important;
 box-shadow:none!important;
}
/* Main issue shown on screenshots: deeply nested text inherits light-mode brown or pale-blue. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .shipment-row,.movement-group,.timeline-item,.journey-panel,.nl-record-section,
 .profile-panel,.profile-fact,.profile-note,.na-quick-actions,.na-status-row,
 .nl-claim-surface,.nl-payment-workspace,.nl-analytics-report,.card,
 .nl18-section-jumps,.nl18-booking-glance
 ) :is(h1,h2,h3,h4,h5,h6,strong,b,dt,dd,.mono,.nl-container-value,
 .nl-reference-value,.row-facts b,.row-facts strong,.nl-route-stop strong,
 .nl-card-heading,.nl-status-head,.stat-value,.value,.fact-caption,
 .journey-stage-label,.payment-review dd,.group-identity strong,
 .nl-record-info-grid strong,.profile-section-title){color:#f1f6fd!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .shipment-row,.movement-group,.timeline-item,.journey-panel,.nl-record-section,
 .profile-panel,.profile-fact,.profile-note,.na-quick-actions,.na-status-row,
 .nl-claim-surface,.nl-payment-workspace,.nl-analytics-report,.card,
 .nl18-section-jumps,.nl18-booking-glance
 ) :is(p,small,.small,.muted,.sub,.subtitle,.stat-sub,.nl-help,.fact-note,
 .nl-status-description,.row-kicker,.journey-stage-caption,.event-comment,
 .event-location,.event-actor,.group-identity small,.nl-section-description,
 .nl-label,.nl-payment-mode-option small,.profile-field-help){color:#c5d3e2!important;}
/* Subheadings and top-of-section metadata should not be light-on-light or brown-on-navy. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-section-title,.caps,.nl-label,.row-kicker,.na-eyebrow,.nl-card-id-mark,
 .nl-route-label,.profile-fact .fact-caption,.nl-payment-eyebrow,.i-kicker,
 .nl-claim-eyebrow,.nl18-eyebrow,.nl-report-intro small
 ){color:#ffb984!important;}
/* Default controls and optional light buttons use dark surfaces, and remain clickable. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .btn.light,.btn.ghost,.btn-outline-secondary,.btn-outline-warning,.btn-outline-dark,
 .btn-light,.nl18-mini-btn,.nl18-preview-button,.nl-page-tools,.nl-page-tools-button,
 .nl18-section-jumps a,.nl-section-index a,.mini-copy,.shipment-actions .btn.light,
 .nl-profile-quicknav a,.nl-amount-chip,.date-chip
 ){background:#29415a!important;background-image:none!important;color:#ffe4cb!important;
 border-color:#667f97!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .input,.select,.textarea,.form-control,.form-select,input:not([type=radio]):not([type=checkbox]):not([type=hidden]),textarea,select
 ){background-color:#142536!important;background-image:none!important;
 color:#edf4fc!important;border-color:#587087!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .input,.select,.textarea,.form-control,.form-select,input,textarea
 )::placeholder{color:#a9bdd0!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 label,.field>label,.form-label,.nl-pay-field-heading,.nl-pay-field-label
 ){color:#e8f1fc!important;}
/* Table body, including shipment cargo, report tables and read-only ledgers. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 table,.table,.data-table,.nl-cargo-table,.iv-table,.nl-smart-table,
 .table-wrap,.table-responsive,.nl18-table-addons,
 thead,tbody,tr,th,td,caption
 ){background-color:#203044!important;background-image:none!important;
 color:#edf4fc!important;border-color:#456079!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(thead tr,th,.table thead th){background-color:#2c4259!important;color:#ffe0bb!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(tbody tr:nth-child(even),.table-striped>tbody>tr:nth-of-type(odd)){
 background:#24364b!important;}
/* Badge and status treatments preserve semantic color rather than becoming bright white. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .pill,.badge,.status-tab:not(.is-active),.nl-status-badge,.na-status-chip,
 .nl18-status-chip,.nl18-filter-chip
 ){background:#304458!important;color:#ffd4b1!important;border-color:#61778c!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .pill.good,.badge.bg-success,.nl-status-delivered,.is-success
 ){background:#1e493d!important;color:#b5f0d4!important;border-color:#5eac87!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .btn.primary,.btn-primary,.btn-warning,.i-primary,.iv-btn.primary,.nl-booking-primary-action
 ){background:#cd5718!important;color:#fff!important;border-color:#ee9455!important;}
/* Overlay dialogs: zero cream/pale panels, including when the dialog has been moved to body. */
html[data-nl-mode="dark"] body.nl-themed-page :is(
 .modal-content,.modal-header,.modal-body,.modal-footer,.nl18-modal,.nl18-preview-dialog,
 .nl-cancel-dialog,.nl-cancel-panel,.nl-review-dialog,
 .payment-dialog-surface,.payment-dialog-header,.payment-amount-box,
 .payment-warning,.payment-actions,.payment-review,.nl-payment-modal,
 .iv-dialog,.i-picker-modal,.cc-modal,.cu-modal,.nl-chart-zoom-panel
 ){background:#213247!important;background-image:none!important;color:#edf4fc!important;
 border-color:#526a82!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.payment-amount-box,.payment-warning,.nl-cancel-impact>div){background:#30465d!important;color:#edf4fc!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.payment-dialog-surface,.nl-cancel-dialog,.modal-content) :is(h1,h2,h3,h4,p,small,span,strong,b,dt,dd){color:#f1f6fd!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.payment-dialog-surface,.nl-cancel-dialog,.modal-content) :is(.small,.muted,.text-muted,.help,small){color:#c1d1e1!important;}
/* Exclude print media from dark styling; PDFs/printed receipts remain standard white. */
@media print{
 html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,table,thead,tbody,tr,th,td,.nl-record-section,.nl-payment-workspace,.nl-bill-record){background:#fff!important;color:#111!important;border-color:#ddd!important;}
}


/* v19.3: Header and page tools live outside the page-body wrapper on several screens. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-pay-reminder,
html[data-nl-mode="dark"] body.nl-themed-page .nl-page-tools>summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl-page-tools-panel,
html[data-nl-mode="dark"] body.nl-themed-page .nl-page-tools-panel button,
html[data-nl-mode="dark"] body.nl-themed-page .nl-page-meta-row .nl-page-tools>summary{
 background:#29415a!important;background-image:none!important;color:#f3f7ff!important;
 border-color:#70839a!important;box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pay-reminder :is(span,small,strong,b),
html[data-nl-mode="dark"] body.nl-themed-page .nl-page-tools>summary :is(span,small,strong),
html[data-nl-mode="dark"] body.nl-themed-page .nl-page-tools-panel button{color:#f3f7ff!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-section-jumps :is(a,span),
html[data-nl-mode="dark"] body.nl-themed-page .nl-section-index :is(a,span){color:#d9e7f4!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-page-tools-panel button:hover{background:#36526e!important;}
/* Still no white/cream in general-purpose widgets attached directly to the body. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl18-action-toast,.nl18-preview-dialog,.nl18-modal,.nl18-modal-head,.nl18-modal-actions,.nl18-modal-body,.nl18-preview-box){
 background:#203044!important;color:#eaf2fb!important;border-color:#536d83!important;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl18-action-toast,.nl18-preview-dialog,.nl18-modal) :is(h2,h3,p,span,small,strong){color:#eaf2fb!important;}


/* v19.3 source-driven audit: previously overlooked secondary surfaces. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-compact-route,.nl-raise-claim,.nl-review-note,.nl-cancel-close,
 .iv-code,.iv-switches,.iv-toast,.nl-claim-aside-heading,
 .nl-claim-preview-document,.nl-evidence-rename-editor
 ){background:#2b3e52!important;background-image:none!important;color:#edf4fc!important;
 border-color:#586f87!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .nl-compact-route,.nl-raise-claim,.nl-review-note,.iv-switches,.iv-toast
 ) :is(span,strong,b,small,p){color:#edf4fc!important;}


/* v19.3 expanded per-JSP surface scan: infrastructure counters, lookup triggers and P&L export. */
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .i-assigned-count,.i-code,.i-count-link,.i-css-bridge,.i-detail,.i-seller-count,
 .i-seller-toggle,.report-download
 ){background:#2a3f54!important;background-image:none!important;color:#f1f6fd!important;
 border-color:#5a738c!important;box-shadow:none!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
 .i-assigned-count,.i-code,.i-count-link,.i-detail,.i-seller-count,.i-seller-toggle,.report-download
 ) :is(span,small,strong,b){color:#f1f6fd!important;}


/* v19.4: theme isolation/contrast follow-up. All selectors here are explicitly DARK-only.
 * The v19.3 module-specific comma lists were independently repaired so no dark
 * component rule can affect Light Mode. Keep this block intentionally small. */
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details[open] > summary {
  background:#263c53!important;
  background-image:none!important;
  color:#f5f8fd!important;
  border-color:#63809a!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details > summary:focus-visible {
  background:#34516b!important;
  color:#fff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu {
  background:#23374b!important;
  color:#f0f5fb!important;
  border-color:#607a91!important;
  box-shadow:0 18px 40px rgba(1,9,21,.4)!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label {
  color:#e9f1fa!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu label:hover {
  background:#36516b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-column-menu input[type="checkbox"]{
  accent-color:#ff964f;
}
html[data-nl-mode="dark"] body.nl-themed-page :is(.na-status-chip,.nl-dash-panel .badge,.nl-dash-panel .nl-status-count) {
  background:#2b4057!important;
  color:#f0f5fc!important;
  border-color:#59738b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .na-status-chip :is(span,strong,b) {
  color:#f0f5fc!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger {
  background:#442d32!important;
  color:#ffd9d8!important;
  border-color:#bd7774!important;
  box-shadow:none!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:hover,
html[data-nl-mode="dark"] body.nl-themed-page .nl-detail-cancel-action .nl-cancel-trigger:hover {
  background:#583338!important;
  color:#fff0ed!important;
  border-color:#ed9c94!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-cancel-trigger:disabled {
  background:#334053!important;
  color:#b8c5d3!important;
  border-color:#53657b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons .nl18-table-status{
  color:#bbcbdb!important;
}
</style>

<style id="nl-v195-universal-action-buttons">
/* The v19.5 primary/secondary split is retired in v19.6. The payment
   reminder animation is retained below; universal actions are defined in
   nl-v196-single-action-style to avoid conflicting visual styles. */
/* Keep the outstanding-balance CTA visually recognizable in BOTH modes. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-app-header .nl-pay-reminder{
 background:linear-gradient(112deg,#ffe3a9,#ffa954)!important;
 background-image:linear-gradient(112deg,#ffe3a9,#ffa954)!important;
 color:#552608!important;border-color:#ffd49a!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-app-header .nl-pay-reminder :is(strong,small,span,b){
 color:#552608!important;-webkit-text-fill-color:#552608!important;
}
/* Payment reminder: animated dot/rim, no page shifting or distracting permanent pulsing. */
.nl-themed-page .nl-pay-reminder{
 position:relative;isolation:isolate;overflow:hidden;
 transition:transform .22s ease,box-shadow .22s ease,filter .22s ease;
 animation:nlPayReminderBreathe 6s ease-in-out infinite!important;
}
.nl-themed-page .nl-pay-reminder::after{
 content:"";pointer-events:none;position:absolute;inset:0;
 background:linear-gradient(110deg,transparent 0%,transparent 39%,rgba(255,255,255,.38) 51%,transparent 62%,transparent 100%);
 transform:translateX(-160%);
 animation:nlPayReminderSweep 6s ease-in-out infinite;
}
.nl-themed-page .nl-pay-reminder-dot{animation:nlPayDotGlow 3s ease-in-out infinite;}
.nl-themed-page .nl-pay-reminder:hover,.nl-themed-page .nl-pay-reminder:focus-visible{
 transform:translateY(-2px) scale(1.015)!important;
 box-shadow:0 8px 22px rgba(205,94,24,.3)!important;
}
@keyframes nlPayReminderSweep{0%,72%{transform:translateX(-160%);}88%,100%{transform:translateX(160%);}}
@keyframes nlPayReminderBreathe{0%,100%{filter:saturate(1);}50%{filter:saturate(1.12);}}
@keyframes nlPayDotGlow{0%,100%{box-shadow:0 0 0 4px rgba(255,220,174,.55);}50%{box-shadow:0 0 0 7px rgba(255,193,119,.15);}}
@media(prefers-reduced-motion:reduce){
 .nl-themed-page .nl-pay-reminder,.nl-themed-page .nl-pay-reminder::after,.nl-themed-page .nl-pay-reminder-dot{animation:none!important;transition:none!important;}
}
</style>


<style id="nl-v196-single-action-style">
/* v19.6: Teacher-requested single action appearance.
   All normal action controls use the same Track shipment primary treatment.
   These selectors cover native/JSP/Bootstrap, inventory, admin and table QOL
   buttons without recolouring tabs, status chips, drop-down options or icons.
   Destructive operations remain distinguishable; disabled means unavailable. */
:root{
  --nl-action-gradient:linear-gradient(112deg,#bf430d 0%,#e76a15 100%);
  --nl-action-hover:linear-gradient(112deg,#a73507 0%,#d4560e 100%);
  --nl-action-radius:12px;
}
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
  a.btn,button.btn,a[class*="btn"],button[class*="btn"],
  input[type="submit"],input[type="button"],button[type="submit"],
  .nl18-action,.nl18-toolbar button,.nl18-table-addons button,
  .nl-chart-zoom-btn,.nl18-preview-button
):not(:disabled):not([disabled]):not([aria-disabled="true"]):not(.disabled):not(.btn-close):not(.btn-danger):not(.btn-outline-danger):not(.nl-danger):not(.danger):not(.i-danger):not(.cc-danger):not(.cu-danger):not(.nl-cancel-trigger):not(.nl-cancel-confirm):not(.nl-cancel-close):not(.payment-cancel):not(.icon-only):not([data-close-modal]){
  background:var(--nl-action-gradient)!important;
  background-image:var(--nl-action-gradient)!important;
  background-color:#ce510e!important;
  color:#fff!important;
  -webkit-text-fill-color:#fff!important;
  border:1px solid #ba430f!important;
  border-radius:var(--nl-action-radius)!important;
  box-shadow:0 5px 13px rgba(170,60,11,.16)!important;
  font-weight:750!important;
  min-height:40px!important;
  text-decoration:none!important;
  opacity:1!important;
  transition:transform .18s ease,box-shadow .18s ease,filter .18s ease!important;
}
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
  a.btn,button.btn,a[class*="btn"],button[class*="btn"],
  input[type="submit"],input[type="button"],button[type="submit"],
  .nl18-action,.nl18-toolbar button,.nl18-table-addons button,
  .nl-chart-zoom-btn,.nl18-preview-button
):not(:disabled):not([disabled]):not([aria-disabled="true"]):not(.disabled):not(.btn-close):not(.btn-danger):not(.btn-outline-danger):not(.nl-danger):not(.danger):not(.i-danger):not(.cc-danger):not(.cu-danger):not(.nl-cancel-trigger):not(.nl-cancel-confirm):not(.nl-cancel-close):not(.payment-cancel):not(.icon-only):not([data-close-modal]):is(:hover,:focus-visible){
  background:var(--nl-action-hover)!important;
  background-image:var(--nl-action-hover)!important;
  color:#fff!important;
  -webkit-text-fill-color:#fff!important;
  box-shadow:0 8px 18px rgba(170,60,11,.27)!important;
  transform:translateY(-1px);
}
/* Text and icons inside the new universal action must inherit white, even
   where an older module sets a span/icon colour on outlined buttons. */
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
  a.btn,button.btn,a[class*="btn"],button[class*="btn"],
  .nl18-action,.nl18-toolbar button,.nl18-table-addons button,
  .nl-chart-zoom-btn,.nl18-preview-button
):not(:disabled):not([disabled]):not(.disabled):not(.btn-close):not(.btn-danger):not(.btn-outline-danger):not(.nl-danger):not(.danger):not(.i-danger):not(.cc-danger):not(.cu-danger):not(.nl-cancel-trigger):not(.nl-cancel-confirm):not(.nl-cancel-close):not(.payment-cancel):not(.icon-only):not([data-close-modal]) :is(span,strong,small,b,i){
  color:inherit!important;-webkit-text-fill-color:inherit!important;
}
/* Module CSS sometimes repeats high-specificity colour overrides after the
   shared theme is included. Repeat our rule with the dark mode root state. */
html[data-nl-mode="dark"] body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) :is(
  a.btn,button.btn,a[class*="btn"],button[class*="btn"],
  input[type="submit"],input[type="button"],button[type="submit"],
  .nl18-action,.nl18-toolbar button,.nl18-table-addons button,
  .nl-chart-zoom-btn,.nl18-preview-button
):not(:disabled):not([disabled]):not([aria-disabled="true"]):not(.disabled):not(.btn-close):not(.btn-danger):not(.btn-outline-danger):not(.nl-danger):not(.danger):not(.i-danger):not(.cc-danger):not(.cu-danger):not(.nl-cancel-trigger):not(.nl-cancel-confirm):not(.nl-cancel-close):not(.payment-cancel):not(.icon-only):not([data-close-modal]){
  background:var(--nl-action-gradient)!important;
  background-image:var(--nl-action-gradient)!important;
  color:#fff!important;-webkit-text-fill-color:#fff!important;
  border-color:#d56522!important;
  box-shadow:0 6px 16px rgba(0,0,0,.26)!important;
}
/* Icon-only and compact copy controls retain their accessible click area, while
   normal labelled compact buttons use the same palette as larger actions. */
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn.small,.btn.btn-sm,.nl18-preview-button,.nl18-mini-btn,.iv-btn,.i-row-btn):not(:disabled):not([disabled]):not(.disabled):not(.danger):not(.i-danger):not(.btn-danger):not(.btn-outline-danger):not(.nl-cancel-trigger){
  padding:7px 11px!important;
}
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn,.nl18-preview-button,.nl18-mini-btn,.iv-btn,.i-row-btn):disabled,
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn,.nl18-preview-button,.nl18-mini-btn,.iv-btn,.i-row-btn)[aria-disabled="true"]{
  opacity:.52!important;cursor:not-allowed!important;box-shadow:none!important;
}
@media (prefers-reduced-motion:reduce){
  body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(a.btn,button.btn,a[class*="btn"],button[class*="btn"],input[type="submit"],input[type="button"],button[type="submit"]){
    transition:none!important;transform:none!important;
  }
}

/* v19.7 sidebar alignment: icon, label and expand control share a single row. */
.nl-primary-nav .nl-side-groups{gap:6px;}
.nl-primary-nav .nl-side-parent{position:relative;display:flex;align-items:center;min-height:49px;}
.nl-primary-nav .nl-side-main{width:100%;min-height:49px;flex:1;display:flex;align-items:center;gap:11px;padding:9px 43px 9px 12px;}
.nl-primary-nav .nl-side-icon{width:29px;height:29px;flex:0 0 29px;display:grid;place-items:center;}
.nl-primary-nav .nl-side-name{flex:1;line-height:1.3;}
.nl-primary-nav .nl-side-toggle{position:absolute;right:6px;top:50%;transform:translateY(-50%);z-index:2;width:32px;height:34px;margin:0;display:grid;place-items:center;}
.nl-primary-nav .nl-side-toggle[aria-expanded="true"] span{transform:rotate(180deg);}
.nl-primary-nav .nl-side-main.is-current + .nl-side-toggle{color:#fff!important;}
.nl-primary-nav .nl-side-children{padding:5px 8px 10px 43px;}
.nl-primary-nav .nl-side-child{min-height:36px;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-primary-nav .nl-side-main.is-current + .nl-side-toggle{color:#fff!important;}
@media(min-width:992px){
 body.nl-sidebar-collapsed .nl-primary-nav .nl-side-main{padding:8px 4px;justify-content:center;}
 body.nl-sidebar-collapsed .nl-primary-nav .nl-side-toggle{display:none!important;}
}
@media(prefers-reduced-motion:reduce){.nl-primary-nav .nl-side-main,.nl-primary-nav .nl-side-toggle{transition:none!important;}}
</style>


<style id="nl-v200-ui-refinement">
/* N-LOGISTIC v20.0. Visual-only UI repairs: both modes, no new assets.
   Billing actions: two equally tall links in one horizontal action cell.
   Wide tables remain horizontally scrollable; no CRUD or payment changes. */
body.nl-themed-page .nl-invoice-table{min-width:1050px;width:100%;}
body.nl-themed-page .nl-invoice-table .nl-invoice-action-cell{min-width:335px;width:1%;vertical-align:middle;}
body.nl-themed-page .nl-invoice-action-group{display:flex;flex-flow:row nowrap;align-items:center;justify-content:flex-start;gap:9px;width:max-content;max-width:none;}
body.nl-themed-page .nl-invoice-action-group :is(a,button){display:inline-flex!important;align-items:center;justify-content:center;flex:0 0 auto;min-height:42px;white-space:nowrap;margin:0!important;}
body.nl-themed-page .nl-bill-actions{align-items:center;gap:9px;}
body.nl-themed-page .nl-bill-actions :is(a,button){min-height:42px;white-space:nowrap;}
@media(max-width:700px){body.nl-themed-page .nl-invoice-table{min-width:980px;}body.nl-themed-page .nl-bill-actions{flex-wrap:wrap;justify-content:flex-start;}}

/* All copy actions take the teacher-approved single orange action treatment. */
body.nl-themed-page :is(.nl-view-body,.content-wrap) button.mini-copy:not(:disabled),
body.nl-themed-page :is(.nl-view-body,.content-wrap) button[data-copy]:not(:disabled),
body.nl-themed-page :is(.nl-view-body,.content-wrap) button[data-nl-copy]:not(:disabled){
 background:linear-gradient(112deg,#bf430d,#e76a15)!important;
 background-image:linear-gradient(112deg,#bf430d,#e76a15)!important;
 color:#fff!important;-webkit-text-fill-color:#fff!important;
 border:1px solid #b7440c!important;border-radius:10px!important;
 box-shadow:0 5px 12px rgba(163,64,18,.16)!important;
 font-weight:750!important;min-height:32px;
 display:inline-flex;align-items:center;justify-content:center;gap:5px;
 opacity:1!important;max-width:100%;vertical-align:middle;
}
body.nl-themed-page :is(.nl-view-body,.content-wrap) button.mini-copy.icon-only{min-width:33px;padding:5px 8px!important;}
body.nl-themed-page :is(.nl-view-body,.content-wrap) button.mini-copy:not(:disabled):hover,
body.nl-themed-page :is(.nl-view-body,.content-wrap) button[data-copy]:not(:disabled):hover{filter:brightness(1.08);transform:translateY(-1px);}
body.nl-themed-page :is(.nl-view-body,.content-wrap) button.mini-copy:focus-visible{outline:3px solid #ffd29e!important;outline-offset:2px;}

/* Sortable header cells form one consistent table heading, not separate orange pills. */
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) table thead th :is(button,[role="button"]):not(.btn-close){
 background:transparent!important;background-image:none!important;box-shadow:none!important;
 border:0!important;border-radius:5px!important;color:inherit!important;
 -webkit-text-fill-color:currentColor!important;
 font-size:inherit!important;letter-spacing:inherit!important;font-weight:inherit!important;
 display:inline-flex;align-items:center;gap:5px;white-space:normal;text-align:left;
 min-width:0!important;min-height:32px!important;padding:2px 3px!important;
}
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) table thead th :is(button,[role="button"]):hover{background:rgba(214,102,25,.13)!important;transform:none!important;}
body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) table thead th :is(button,[role="button"]):focus-visible{outline:2px solid #d97023!important;outline-offset:1px;}

/* Dashboard attention cards and status-count legend: improve dark/light contrast. */
body.nl-themed-page .nl-view-body section[aria-label="Items needing attention"] a{
 min-height:39px;display:inline-flex;align-items:center;gap:7px;line-height:1.25;
}
body.nl-themed-page .nl-view-body .nl-status-count-list{display:grid;grid-template-columns:repeat(auto-fit,minmax(115px,1fr));gap:9px;margin-top:16px;}
body.nl-themed-page .nl-view-body .nl-status-count-list li{display:flex;align-items:center;gap:7px;min-width:0;border-radius:11px;padding:10px 11px;line-height:1.25;}
body.nl-themed-page .nl-view-body .nl-status-count-list li :is(span,strong){font-weight:750;overflow-wrap:anywhere;}
body.nl-themed-page .nl-view-body .nl-status-count-list li strong{margin-left:auto;font-variant-numeric:tabular-nums;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body section[aria-label="Items needing attention"] a{
 background:#293e52!important;color:#f5f8ff!important;border-color:#50677f!important;
 -webkit-text-fill-color:#f5f8ff!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body section[aria-label="Items needing attention"] a :is(strong,span){color:#fff!important;-webkit-text-fill-color:#fff!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-status-count-list li{
 background:#2a3d52!important;border:1px solid #536a83!important;color:#edf4fd!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-status-count-list li :is(span,strong){color:#edf4fd!important;-webkit-text-fill-color:#edf4fd!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-status-count-list li .nl-status-dot{flex:0 0 9px;}

/* Breadcrumbs and support text stay visible in dark mode. */
html[data-nl-mode="dark"] body.nl-themed-page :is([aria-label="Breadcrumb"],.nl-page-meta-row,.nl-breadcrumb,.breadcrumbs) {color:#e2eaf5!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is([aria-label="Breadcrumb"],.nl-page-meta-row,.nl-breadcrumb,.breadcrumbs) :is(a,span,small){color:#f7ba81!important;-webkit-text-fill-color:#f7ba81!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is([aria-label="Breadcrumb"],.nl-page-meta-row,.nl-breadcrumb,.breadcrumbs) :is(.current,[aria-current="page"]){color:#fff!important;-webkit-text-fill-color:#fff!important;}

/* Permissions / access list: crisp icon blocks and consistent row alignment. */
body.nl-themed-page .profile-permissions li{display:flex;align-items:flex-start;gap:11px;padding:12px 0;min-width:0;}
body.nl-themed-page .profile-permissions .perm-icon{width:25px;height:25px;flex:0 0 25px;display:inline-flex;align-items:center;justify-content:center;line-height:1;overflow:visible;}
html[data-nl-mode="dark"] body.nl-themed-page .profile-permissions li{border-color:#4b647c!important;}
html[data-nl-mode="dark"] body.nl-themed-page .profile-permissions .perm-icon{background:#ffe6cc!important;color:#a33e09!important;-webkit-text-fill-color:#a33e09!important;}
html[data-nl-mode="dark"] body.nl-themed-page .profile-permissions :is(strong,small){color:#edf3fc!important;-webkit-text-fill-color:#edf3fc!important;}

/* Native and generated table utility controls: keep Columns and density readable. */
body.nl-themed-page .nl18-table-addons details>summary{display:inline-flex;align-items:center;min-height:38px;padding:8px 12px;}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons details>summary{
 background:#293f56!important;color:#f6f8ff!important;
 -webkit-text-fill-color:#f6f8ff!important;border-color:#58718b!important;
}
html[data-nl-mode="dark"] body.nl-themed-page .nl18-table-addons :is(.nl18-mini-btn,select){background:#1a2b3c!important;color:#f6f8ff!important;border-color:#58718b!important;}

/* Analytics shortcuts: number badges and report titles must not fade out. */
body.nl-themed-page .nl-report-shortcut{display:flex;align-items:center;gap:9px;min-height:51px;min-width:0;}
body.nl-themed-page .nl-report-shortcut .nl-shortcut-count{flex:0 0 auto;min-width:25px;height:25px;display:inline-flex;align-items:center;justify-content:center;border-radius:99px;font-weight:850;}
body.nl-themed-page .nl-report-shortcut .flex-grow-1{min-width:0;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-report-shortcut{background:#283e53!important;border-color:#566e86!important;color:#f7faff!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-report-shortcut :is(.nl-shortcut-title,.nl-shortcut-desc){color:#eaf3ff!important;-webkit-text-fill-color:#eaf3ff!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-report-shortcut .nl-shortcut-count{background:#f8dcc3!important;color:#76360d!important;-webkit-text-fill-color:#76360d!important;}

/* Analytics shortcuts receive the same standard orange button appearance. */
body.nl-themed-page .nl-ops-links{display:flex;align-items:center;gap:9px;flex-wrap:wrap;}
body.nl-themed-page .nl-ops-links a{display:inline-flex;align-items:center;justify-content:center;min-height:40px;padding:9px 14px;
 background:linear-gradient(112deg,#bf430d,#e76a15)!important;color:#fff!important;-webkit-text-fill-color:#fff!important;
 border:1px solid #b7440c!important;border-radius:11px!important;text-decoration:none!important;font-weight:750!important;
}
body.nl-themed-page .nl-ops-links .badge{text-shadow:none!important;font-size:.79rem!important;line-height:1.3!important;padding:11px 13px!important;border-radius:11px!important;}
html[data-nl-mode="dark"] body.nl-themed-page .nl-ops-links .badge{background:#30475b!important;color:#f4e6d2!important;-webkit-text-fill-color:#f4e6d2!important;border:1px solid #647187!important;}
@media(prefers-reduced-motion:reduce){body.nl-themed-page :is(.mini-copy,.nl-ops-links a){transition:none!important;transform:none!important;}}

/* Strong dark-mode specificity for copy controls: legacy movement CSS otherwise wins. */
html[data-nl-mode="dark"] body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) button.mini-copy:not(:disabled),
html[data-nl-mode="dark"] body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) button[data-copy]:not(:disabled),
html[data-nl-mode="dark"] body.nl-themed-page.nl-themed-page :is(.nl-view-body,.content-wrap) button[data-nl-copy]:not(:disabled){
 background:linear-gradient(112deg,#bf430d,#e76a15)!important;
 background-image:linear-gradient(112deg,#bf430d,#e76a15)!important;
 background-color:#ce510e!important;color:#fff!important;-webkit-text-fill-color:#fff!important;
 border-color:#b7440c!important;box-shadow:0 5px 12px rgba(0,0,0,.22)!important;
}
</style>

<style id="nl-v201-table-head-and-copy-text">
/* v20.1: Table headings are labels, never orange action buttons. */
body.nl-themed-page .nl-view-body table thead th,
body.nl-themed-page .content-wrap table thead th{vertical-align:middle!important;}
body.nl-themed-page .nl-view-body table thead th .nl-sort-head,
body.nl-themed-page .content-wrap table thead th .nl-sort-head{
  all:unset!important;display:inline-flex!important;align-items:center!important;
  gap:5px!important;min-height:32px!important;cursor:pointer!important;
  font:inherit!important;font-weight:inherit!important;letter-spacing:inherit!important;
  color:inherit!important;-webkit-text-fill-color:currentColor!important;
  background:none!important;background-image:none!important;box-shadow:none!important;
  border:0!important;border-radius:3px!important;padding:2px 0!important;
  text-transform:inherit!important;text-align:left!important;white-space:normal!important;
}
body.nl-themed-page table thead th .nl-sort-head:hover{text-decoration:underline!important;text-underline-offset:3px!important;}
body.nl-themed-page table thead th .nl-sort-head:focus-visible{outline:2px solid #ed853e!important;outline-offset:3px!important;}
/* Copy the value itself, with no separate orange button or chip. */
body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-inline-copy{
  display:inline!important;cursor:copy!important;font:inherit!important;
  font-weight:inherit!important;color:inherit!important;-webkit-text-fill-color:currentColor!important;
  background:transparent!important;background-image:none!important;
  border:0!important;border-radius:0!important;box-shadow:none!important;
  padding:0!important;margin:0!important;min-height:0!important;max-width:100%;
  text-decoration:underline dotted transparent!important;text-underline-offset:3px!important;
  transition:text-decoration-color .18s ease!important;white-space:normal;overflow-wrap:anywhere;
}
body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-inline-copy:hover,
body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-inline-copy:focus-visible{
  text-decoration-color:currentColor!important;
}
body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-inline-copy:focus-visible{outline:2px solid #e77b2e!important;outline-offset:3px!important;}
body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-inline-copy.is-copied{text-decoration-color:#218d63!important;}
html[data-nl-mode="dark"] body.nl-themed-page :is(.nl-view-body,.content-wrap) .nl-inline-copy{color:inherit!important;-webkit-text-fill-color:currentColor!important;}
.nl-copy-announcement{position:fixed;right:17px;bottom:72px;z-index:2200;max-width:min(360px,calc(100vw - 34px));
  padding:12px 16px;background:#1f483a;color:#fff;border:1px solid #51b991;
  border-radius:12px;box-shadow:0 8px 24px #0004;font-size:.88rem;font-weight:700;
  opacity:0;pointer-events:none;transform:translateY(8px);transition:opacity .18s,transform .18s;}
.nl-copy-announcement.is-visible{opacity:1;transform:translateY(0);}
/* Invoice actions stay together for Consumers; other roles remain read-only. */
body.nl-themed-page .nl-invoice-table{min-width:1290px!important;}
body.nl-themed-page .nl-invoice-table .nl-invoice-action-cell{min-width:360px!important;width:360px!important;}
body.nl-themed-page .nl-invoice-action-group{display:inline-flex!important;flex-direction:row!important;align-items:center!important;flex-wrap:nowrap!important;gap:10px!important;width:max-content!important;}
body.nl-themed-page .nl-invoice-action-group>a{flex:none!important;white-space:nowrap!important;min-width:0!important;}
@media(prefers-reduced-motion:reduce){.nl-copy-announcement,.nl-inline-copy{transition:none!important;}}

/* v20.23 - Universal visual polish. Existing files only, no data alterations. */
body.nl-themed-page{--nl23-line:#ecd7c5;--nl23-subtle:#fff9f2;--nl23-ink:#35261e;--nl23-muted:#765f52;--nl23-accent:#d65a15;--nl23-focus:#ed8a49}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,.nl-card,.iv-panel,.nl-ops-card){scroll-margin-top:95px}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.card,.nl-card,.iv-panel):not(.nl-pricing-table *){min-width:0}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(h1,h2,h3,h4){overflow-wrap:break-word;text-wrap:balance}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(p,.sub,.text-secondary,.form-text){overflow-wrap:break-word}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.form-control,.form-select,.iv-input,input[type="date"],input[type="file"]){max-width:100%;min-width:0}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(input,select,textarea,button,a):focus-visible{outline:3px solid var(--nl23-focus)!important;outline-offset:2px}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.form-label,label):has(+ :is(input,select,textarea)){font-weight:700}
body.nl-themed-page :is(.nl-view-body,.content-wrap) :is(.btn,.iv-btn,.nl18-mini-btn):not(:disabled){transition:box-shadow .16s ease, transform .16s ease, border-color .16s ease}
body.nl-themed-page .nl23-action-busy{opacity:.8;cursor:progress!important}
body.nl-themed-page .nl23-action-busy:before{content:"";width:12px;height:12px;display:inline-block;vertical-align:-1px;margin-right:7px;border:2px solid currentColor;border-right-color:transparent;border-radius:50%;animation:nl23Spin .65s linear infinite}
@keyframes nl23Spin{to{transform:rotate(360deg)}}
body.nl-themed-page .nl23-file-panel{margin:10px 0;padding:12px 14px;border-radius:12px;border:1px solid #ecd2ba;background:#fff7ed;color:#65432e;font-size:.83rem;line-height:1.5;overflow-wrap:anywhere}
body.nl-themed-page .nl23-file-panel .nl23-file-title{display:block;font-size:.88rem;font-weight:850;margin-bottom:4px;color:#743c18}
body.nl-themed-page .nl23-file-panel.is-error{border-color:#d86f57;background:#fff1ec;color:#9e3020}
body.nl-themed-page .nl23-file-table{width:100%;border-collapse:separate;border-spacing:0;margin-top:8px;font-size:.76rem}
body.nl-themed-page .nl23-file-table th,body.nl-themed-page .nl23-file-table td{padding:7px 9px;text-align:left;overflow-wrap:anywhere;border-bottom:1px solid #e9d8c9;max-width:250px}
body.nl-themed-page .nl23-file-table th{font-size:.71rem;color:#95531d;text-transform:uppercase;letter-spacing:.04em}
body.nl-themed-page .nl23-file-overflow{max-width:100%;overflow-x:auto}
body.nl-themed-page .nl23-empty{padding:18px 20px;border:1px dashed #debfa3;background:#fff9f2;border-radius:14px;color:#7c5c48;text-align:center;font-size:.87rem;margin:12px 0}
body.nl-themed-page .nl23-info-tiles{display:flex;gap:8px;flex-wrap:wrap;margin:12px 0}
body.nl-themed-page .nl23-info-chip{display:inline-flex;align-items:center;gap:5px;padding:6px 10px;border:1px solid #ead2bc;border-radius:10px;background:#fff5e8;color:#834318;font-size:.78rem;font-weight:720}
body.nl-themed-page .nl23-inline-hint{font-size:.77rem;color:#856954;margin-top:6px}
body.nl-themed-page .nl23-skiplink{position:fixed;top:-80px;left:12px;z-index:40000;background:#fff;color:#743819;padding:11px 17px;border-radius:10px;border:2px solid #df6b26;font-weight:800;box-shadow:0 8px 20px #0003}
body.nl-themed-page .nl23-skiplink:focus{top:10px}
html[data-nl-mode="dark"] body.nl-themed-page{--nl23-line:#4e657c;--nl23-subtle:#25394c;--nl23-ink:#f2f7fc;--nl23-muted:#c7d7e5;--nl23-focus:#ffb46e}
html[data-nl-mode="dark"] body.nl-themed-page .nl23-file-panel,html[data-nl-mode="dark"] body.nl-themed-page .nl23-empty{background:#26384b;color:#e6eff9;border-color:#506985}
html[data-nl-mode="dark"] body.nl-themed-page .nl23-file-panel .nl23-file-title{color:#ffca96}
html[data-nl-mode="dark"] body.nl-themed-page .nl23-file-panel.is-error{background:#42333a;color:#ffd5cf;border-color:#c57165}
html[data-nl-mode="dark"] body.nl-themed-page .nl23-file-table :is(th,td){color:#e9f1fb;border-color:#50637c}
html[data-nl-mode="dark"] body.nl-themed-page .nl23-file-table th{color:#f5bd92}
html[data-nl-mode="dark"] body.nl-themed-page .nl23-info-chip{background:#2a3e51;color:#ffd1a4;border-color:#577088}
html[data-nl-mode="dark"] body.nl-themed-page .nl23-inline-hint{color:#c9d8e9}
@media(max-width:700px){body.nl-themed-page .nl23-file-table{min-width:470px}}
@media(prefers-reduced-motion:reduce){body.nl-themed-page .nl23-action-busy:before{animation:none!important}}

</style>


<style id="nl-v2038-global-table-grid">
/* v20.38 - one visual alignment contract for data tables in every module.
   Invoice printouts, responsive pricing cards and form/summary tables are unchanged. */
body.nl-themed-page.nl-themed-page .nl-global-grid-scroll {
  max-width:100%!important;min-width:0!important;
  overflow-x:auto!important;overscroll-behavior-x:contain;
  -webkit-overflow-scrolling:touch;scrollbar-width:thin;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] {
  box-sizing:border-box!important;width:100%!important;
  min-width:max(100%,var(--nl-grid-min,640px))!important;
  table-layout:auto!important;border-collapse:separate;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] :is(thead th,tbody td) {
  box-sizing:border-box!important;min-width:0;
  vertical-align:middle!important;word-break:normal!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] thead th {
  text-align:left!important;white-space:nowrap!important;
  overflow-wrap:normal!important;line-height:1.35!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] tbody td[data-nl-col-type="text"] {
  text-align:left!important;white-space:normal!important;
  overflow-wrap:break-word!important;hyphens:none!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] :is(th,td)[data-nl-col-type="date"] {
  text-align:left!important;white-space:nowrap!important;
  font-variant-numeric:tabular-nums!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] :is(th,td)[data-nl-col-type="numeric"] {
  text-align:right!important;white-space:nowrap!important;
  font-variant-numeric:tabular-nums!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] :is(th,td)[data-nl-col-type="action"] {
  text-align:center!important;white-space:nowrap!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] thead th .nl-sort-head {
  display:inline-flex!important;align-items:center!important;
  justify-content:flex-start!important;gap:6px!important;
  width:auto!important;min-width:0!important;max-width:100%!important;
  text-align:inherit!important;white-space:nowrap!important;
  overflow-wrap:normal!important;word-break:normal!important;
  vertical-align:middle!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] thead th[data-nl-col-type="numeric"] .nl-sort-head {
  justify-content:flex-end!important;text-align:right!important;
}
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] thead th[data-nl-col-type="action"] .nl-sort-head {
  justify-content:center!important;text-align:center!important;
}
/* Keep the strongest legacy analytics table-layout selectors from re-compressing columns. */
body.nl-themed-page.nl-themed-page[data-nl-screen="module6-analytics"]
  .nl-report-table-pane table[data-nl-grid="1"],
body.nl-themed-page.nl-themed-page[data-nl-screen="module2-profitlossdashboard"]
  table[data-nl-grid="1"] {
  min-width:max(100%,var(--nl-grid-min,640px))!important;
  table-layout:auto!important;
}
/* Align table density, column chooser, and preview controls without crushing search fields. */
body.nl-themed-page.nl-themed-page .nl18-table-addons {
  display:flex!important;flex-wrap:wrap!important;
  align-items:center!important;justify-content:flex-end!important;
  gap:9px!important;min-width:0!important;max-width:100%!important;
}
body.nl-themed-page.nl-themed-page .nl18-table-addons .nl18-table-status {
  flex:1 1 155px!important;min-width:0!important;
  margin-right:auto!important;white-space:normal!important;
}
body.nl-themed-page.nl-themed-page .nl18-table-addons :is(select,details,button) {
  flex:0 0 auto;max-width:100%;
}
body.nl-themed-page.nl-themed-page .nl18-table-addons select.nl18-mini-btn {min-width:120px;}
body.nl-themed-page.nl-themed-page .nl-table-toolbar {
  align-items:center!important;gap:10px!important;min-width:0!important;
}
body.nl-themed-page.nl-themed-page .nl-table-toolbar .nl-table-filters {
  display:flex!important;align-items:center!important;flex-wrap:wrap!important;
  gap:8px!important;min-width:0!important;
}
@media(max-width:640px){
  body.nl-themed-page.nl-themed-page .nl18-table-addons{justify-content:flex-start!important;}
  body.nl-themed-page.nl-themed-page .nl18-table-addons .nl18-table-status{flex:1 1 100%!important;}
}
/* Sort controls are not action buttons (retain existing light/dark header palettes). */
body.nl-themed-page.nl-themed-page table[data-nl-grid="1"] thead th :is(button,[role="button"]) {
  background:transparent!important;box-shadow:none!important;border:0!important;
  color:inherit!important;-webkit-text-fill-color:currentColor!important;
}
@media print {
  body.nl-themed-page.nl-themed-page .nl-global-grid-scroll{overflow:visible!important;}
  body.nl-themed-page.nl-themed-page table[data-nl-grid="1"]{min-width:0!important;}
}
</style>
