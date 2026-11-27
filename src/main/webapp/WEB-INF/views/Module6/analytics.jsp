<jsp:useBean id="nlViewSupport_Module6_analytics" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module6_analytics" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module6_analytics" property="view" value="Module6/analytics.jsp" />
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>





<%-- Start the common N-LOGISTIC header and sidebar --%>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>

<style>
/* N-LOGISTIC analytics v10: local styles only; keep the shared orange theme. */
.analytics-dashboard .nl-report-shortcuts{background:#fffaf5;border:1px solid #ead4c2;border-radius:18px;padding:18px 20px;margin:0 0 20px;box-shadow:0 10px 30px rgba(100,58,22,.065)}
.analytics-dashboard .nl-report-shortcut-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin-top:12px}
.analytics-dashboard .nl-report-shortcut{display:flex;align-items:center;gap:12px;text-decoration:none!important;background:#fff;border:1px solid #eddfd2;border-radius:13px;padding:12px 14px;min-width:0;transition:border-color .15s,transform .15s,box-shadow .15s}
.analytics-dashboard .nl-report-shortcut:hover,.analytics-dashboard .nl-report-shortcut:focus-visible{border-color:#d65a12;transform:translateY(-2px);box-shadow:0 7px 18px #8f431a1c;outline-offset:2px}
.analytics-dashboard .nl-report-shortcut svg{flex:none;color:#ba4c0e;width:22px;height:22px}
.analytics-dashboard .nl-shortcut-title{font-weight:760;font-size:.91rem;color:#482e22;line-height:1.25}
.analytics-dashboard .nl-shortcut-desc{font-size:.75rem;color:#886b59;line-height:1.2;margin-top:3px}
.analytics-dashboard .nl-shortcut-count{margin-left:auto;flex:none;font-size:.73rem;color:#9e470e;background:#fff0e1;padding:4px 8px;border-radius:99px;font-weight:800}
.analytics-dashboard .nl-report-shortcut > .nl-shortcut-count:first-child{margin-left:0;min-width:33px;text-align:center}
.analytics-dashboard .nl-report-intro{color:#7a6052;font-size:.87rem;margin:2px 0 0}
.analytics-dashboard .nl-analytics-report{scroll-margin-top:122px;border:1px solid #ecd9c8;border-radius:18px;background:#fffaf6;padding:22px 22px 20px;margin-bottom:28px;box-shadow:0 12px 29px rgba(77,49,27,.055);overflow:hidden}
.analytics-dashboard .nl-analytics-report:target{outline:2px solid #e77a32;outline-offset:3px}
.analytics-dashboard .nl-analytics-report .panel-heading{margin-bottom:16px}
.analytics-dashboard .nl-report-chart{border:1px solid #eddfd1;background:#fff;border-radius:15px;padding:16px 16px 10px;margin:0 0 20px}
.analytics-dashboard .nl-report-chart-meta{display:flex;align-items:center;justify-content:space-between;gap:10px;margin-bottom:12px;flex-wrap:wrap}
.analytics-dashboard .nl-report-chart-info strong{display:block;color:#4f3020;font-size:.95rem}
.analytics-dashboard .nl-report-chart-info span{display:block;color:#886f5e;font-size:.77rem;margin-top:2px}
.analytics-dashboard .nl-chart-tools{display:flex;gap:7px;align-items:center;flex-wrap:wrap}
.analytics-dashboard .nl-chart-tools .btn{font-size:.78rem;padding:6px 10px;border-radius:9px}
.analytics-dashboard .nl-report-chart-frame{height:310px;position:relative;width:100%;overflow:hidden}
.analytics-dashboard .nl-report-chart-frame canvas{display:block;width:100%!important;height:100%!important;max-height:100%!important}
.analytics-dashboard .nl-report-chart-frame.nl-donut-frame{height:295px}
.analytics-dashboard .nl-chart-empty{border:1px dashed #e8cbb7;background:#fff9f2;color:#846652;border-radius:12px;padding:17px 18px;margin-bottom:16px;font-size:.9rem}
.analytics-dashboard .nl-chart-fallback{border-radius:10px;background:#fff0e0;color:#81512d;font-size:.86rem;padding:12px;margin-top:6px}
.analytics-dashboard .nl-chart-fallback[hidden]{display:none!important}
.analytics-dashboard .nl-analytics-report .table-responsive{scroll-margin-top:120px}
.analytics-dashboard .nl-report-bottom{display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;margin-top:13px;color:#8d6f59;font-size:.78rem}
.analytics-dashboard .nl-report-bottom a{color:#ab480d;text-decoration:none;font-weight:750}
.analytics-dashboard .nl-report-bottom a:hover{text-decoration:underline}
.analytics-dashboard #nlAnalyticsQuickAccess{scroll-margin-top:120px}
@media(max-width:1000px){.analytics-dashboard .nl-report-shortcut-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:600px){.analytics-dashboard .nl-report-shortcut-grid{grid-template-columns:1fr}.analytics-dashboard .nl-analytics-report{padding:14px}.analytics-dashboard .nl-report-shortcuts{padding:14px}.analytics-dashboard .nl-report-chart{padding:12px}.analytics-dashboard .nl-report-chart-frame{height:270px}.analytics-dashboard .nl-report-chart-frame.nl-donut-frame{height:265px}}
@media(prefers-reduced-motion:reduce){.analytics-dashboard .nl-report-shortcut{transition:none!important}.analytics-dashboard .nl-report-shortcut:hover{transform:none!important}}
@media print{.analytics-dashboard .nl-report-shortcuts,.analytics-dashboard .nl-chart-tools,.analytics-dashboard .nl-report-bottom{display:none!important}.analytics-dashboard .nl-analytics-report{box-shadow:none;break-inside:avoid}}

/* v10: readable report-first layout; no external stylesheet and no schema changes. */
.analytics-dashboard .nl-analytics-report{overflow:visible;scroll-margin-top:115px}
.analytics-dashboard .nl-analytics-report .panel-heading{margin-bottom:11px}
.analytics-dashboard .nl-report-layout-bar{display:flex;align-items:center;justify-content:space-between;gap:9px;flex-wrap:wrap;margin:0 0 14px;border-bottom:1px solid #eadbd0;padding-bottom:12px}
.analytics-dashboard .nl-report-layout-bar .nl-report-guide{color:#826b59;font-size:.79rem;line-height:1.45}
.analytics-dashboard .nl-report-layout-bar .nl-layout-choice{display:flex;align-items:center;gap:9px}
.analytics-dashboard .nl-layout-choice label{font-weight:700;color:#725342;font-size:.78rem;margin:0}
.analytics-dashboard .nl-layout-choice select,.analytics-dashboard .nl-chart-type{border:1px solid #e7ccb9;border-radius:9px;background:#fffaf6;color:#583928;font-size:.82rem;padding:7px 24px 7px 9px;min-height:36px;max-width:100%}
.analytics-dashboard .nl-report-workspace{display:grid;grid-template-columns:minmax(0,58fr) minmax(350px,42fr);align-items:stretch;gap:14px;min-width:0}
.analytics-dashboard .nl-report-table-pane{min-width:0;max-width:100%;display:flex;flex-direction:column;background:#fff;border:1px solid #ead8c7;border-radius:15px;overflow:hidden}
.analytics-dashboard .nl-report-table-heading{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:8px;background:#fff9f3;padding:13px 14px 10px;border-bottom:1px solid #f1e4d6}
.analytics-dashboard .nl-report-table-heading strong{color:#543c2c;font-size:.89rem}
.analytics-dashboard .nl-report-table-heading span{font-size:.74rem;color:#886b57}
.analytics-dashboard .nl-report-table-pane .table-responsive{max-height:440px;overflow-y:auto;overflow-x:auto;flex:1;min-height:160px;border-radius:0!important;scroll-margin-top:130px}
.analytics-dashboard .nl-report-table-pane table{min-width:460px}
.analytics-dashboard .nl-report-table-pane table:has(th:nth-child(6)){min-width:780px}
.analytics-dashboard .nl-report-table-pane table:has(th:nth-child(8)){min-width:1000px}
.analytics-dashboard .nl-report-table-pane .table thead th{position:sticky;top:0;z-index:2;font-size:.69rem!important;line-height:1.3;padding:.8rem .66rem!important}
.analytics-dashboard .nl-report-table-pane .table tbody td{font-size:.79rem!important;padding:.75rem .65rem!important;vertical-align:middle}
.analytics-dashboard .nl-report-chart{margin:0;min-width:0;display:flex;flex-direction:column;box-shadow:none;padding:15px!important}
.analytics-dashboard .nl-report-chart-meta{align-items:flex-start;flex-direction:column;margin-bottom:6px}
.analytics-dashboard .nl-chart-tools{width:100%;justify-content:flex-start;gap:7px}
.analytics-dashboard .nl-chart-tools .btn{min-height:36px}
.analytics-dashboard .nl-chart-type-label{font-weight:750;color:#7b5139;font-size:.76rem}
.analytics-dashboard .nl-chart-type{flex:1;max-width:195px}
.analytics-dashboard .nl-report-chart-frame,.analytics-dashboard .nl-report-chart-frame.nl-donut-frame{height:345px;min-height:285px;flex:1;max-height:540px}
.analytics-dashboard .nl-chart-context{font-size:.76rem;line-height:1.48;color:#806c5d;padding-top:9px;border-top:1px solid #f0e4d8;margin-top:9px}
.analytics-dashboard .nl-report-insight{display:block;border-top:1px dashed #eed8c4;margin-top:12px;padding:12px 2px 0;color:#795d4a;font-size:.82rem;line-height:1.55}
.analytics-dashboard .nl-report-insight strong{color:#573d2b}
.analytics-dashboard .nl-analytics-report[data-nl-layout="wide"] .nl-report-workspace{grid-template-columns:minmax(0,1fr)}
.analytics-dashboard .nl-analytics-report[data-nl-layout="wide"] .nl-report-chart{max-width:none}
.analytics-dashboard .nl-analytics-report[data-nl-layout="wide"] .nl-report-chart-frame{height:285px;min-height:230px}
.analytics-dashboard .nl-analytics-report[data-nl-layout="wide"] .nl-report-table-pane .table-responsive{max-height:570px}
.analytics-dashboard .nl-action-drawer{border:1px solid #eed8c6;background:#fffaf5;border-radius:14px;padding:0;margin:0 0 17px}
.analytics-dashboard .nl-action-drawer>summary{padding:13px 16px;cursor:pointer;font-weight:760;color:#754526;list-style:none;display:flex;align-items:center;justify-content:space-between;gap:12px}
.analytics-dashboard .nl-action-drawer>summary::-webkit-details-marker{display:none}
.analytics-dashboard .nl-action-drawer>summary::after{content:'+';font-size:1.25rem;color:#b54a10}
.analytics-dashboard .nl-action-drawer[open]>summary::after{content:'−'}
.analytics-dashboard .nl-action-drawer .nl-action-drawer-inner{padding:2px 17px 17px}
.analytics-dashboard .nl-ops-card{background:#fffaf5;border:1px solid #ead5c3;border-radius:18px;padding:21px;margin:0 0 20px}
.analytics-dashboard .nl-ops-title{display:flex;flex-wrap:wrap;align-items:center;gap:9px;justify-content:space-between}
.analytics-dashboard .nl-ops-kpis{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:11px;margin:17px 0}
.analytics-dashboard .nl-ops-kpi{border:1px solid #ecddcf;background:#fff;border-radius:13px;padding:13px 15px;min-width:0}
.analytics-dashboard .nl-ops-kpi small{font-size:.77rem;color:#816858;display:block;font-weight:700}
.analytics-dashboard .nl-ops-kpi strong{font-size:clamp(1.25rem,2vw,1.7rem);font-weight:800;color:#542f18;display:block;margin-top:5px;overflow-wrap:anywhere;font-variant-numeric:tabular-nums}
.analytics-dashboard .nl-ops-links{display:flex;align-items:center;gap:9px;flex-wrap:wrap;margin:8px 0 14px;font-size:.82rem}
.analytics-dashboard .nl-ops-links a{color:#a9430b;text-decoration:none;border:1px solid #ead0bc;border-radius:9px;padding:7px 10px;background:#fff}
.analytics-dashboard .nl-ops-links a:hover{background:#fff1e5}
.analytics-dashboard .nl-simple-intro{font-size:.84rem;color:#775846;max-width:850px}
.analytics-dashboard .nl-filter-advanced{border:0;border-top:1px solid #eddbca;margin-top:8px;padding-top:11px}
.analytics-dashboard .nl-filter-advanced summary{font-size:.84rem;color:#b04e16;font-weight:750;cursor:pointer;list-style:none}
.analytics-dashboard .nl-filter-advanced summary::-webkit-details-marker{display:none}
.analytics-dashboard .nl-filter-advanced summary::after{content:' ▾'}
.analytics-dashboard .nl-filter-advanced[open] summary::after{content:' ▴'}
.analytics-dashboard .nl-report-shortcut-grid{grid-template-columns:repeat(3,minmax(0,1fr))}
.analytics-dashboard .nl-report-shortcut{min-height:78px}
.analytics-dashboard .nl-chart-fallback{margin-top:10px}
.analytics-dashboard .nl-chart-expanded .nl-report-workspace{grid-template-columns:minmax(0,1fr)}
.analytics-dashboard .nl-chart-expanded .nl-report-chart-frame,.analytics-dashboard .nl-chart-expanded .nl-report-chart-frame.nl-donut-frame{height:490px;min-height:490px;flex:none}
.analytics-dashboard .nl-report-chart:focus-within,.analytics-dashboard .nl-report-table-pane:focus-within{outline:2px solid #e4a06e;outline-offset:1px}
@media(max-width:1480px){.analytics-dashboard .nl-report-workspace{grid-template-columns:minmax(0,53fr) minmax(300px,47fr)}}
@media(max-width:1199px){.analytics-dashboard .nl-report-workspace{grid-template-columns:minmax(0,1fr)}.analytics-dashboard .nl-report-chart-frame,.analytics-dashboard .nl-report-chart-frame.nl-donut-frame{height:300px;flex:none}.analytics-dashboard .nl-report-shortcut-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:640px){.analytics-dashboard .nl-ops-kpis{grid-template-columns:repeat(2,minmax(0,1fr))}.analytics-dashboard .nl-report-shortcut-grid{grid-template-columns:1fr}.analytics-dashboard .nl-report-chart-frame,.analytics-dashboard .nl-report-chart-frame.nl-donut-frame{height:260px;min-height:230px}.analytics-dashboard .nl-report-table-pane .table-responsive{max-height:450px}.analytics-dashboard .nl-report-table-pane .nl-smart-table{min-width:0}.analytics-dashboard .nl-report-workspace{gap:10px}}
@media print{.analytics-dashboard .nl-report-workspace{display:block}.analytics-dashboard .nl-report-chart{margin-top:14px}.analytics-dashboard .nl-report-layout-bar,.analytics-dashboard .nl-action-drawer{display:none}.analytics-dashboard .nl-report-table-pane .table-responsive{max-height:none;overflow:visible}}

/* v16.6 compact, readable Analytics; six shortcuts use one horizontal line. */
body[data-nl-screen="module6-analytics"] .nl-view-body > .bg-white.rounded-4{padding:12px 19px!important;margin-bottom:12px!important;min-height:0!important;border-radius:15px!important}
body[data-nl-screen="module6-analytics"] .nl-view-body > .bg-white.rounded-4 h1{font-size:clamp(1.35rem,2.2vw,1.9rem)!important;line-height:1.2;margin:0!important;letter-spacing:-.025em!important}
.analytics-dashboard .nl-report-shortcuts{padding:12px 14px!important;margin-bottom:13px!important;border-radius:15px!important}
.analytics-dashboard .nl-report-shortcuts h2{font-size:1.04rem!important;margin-bottom:2px!important}
.analytics-dashboard .nl-report-intro{font-size:.76rem!important;margin-top:0!important}
.analytics-dashboard .nl-report-shortcut-grid{display:flex!important;grid-template-columns:none!important;gap:7px!important;overflow-x:auto;overflow-y:hidden;padding:2px 2px 8px;scrollbar-width:thin;scroll-snap-type:x proximity;margin-top:8px!important}
.analytics-dashboard .nl-report-shortcut{flex:1 0 162px;max-width:none;min-width:162px;min-height:46px!important;padding:8px 10px!important;gap:8px!important;border-radius:10px!important;scroll-snap-align:start;transform:none!important}
.analytics-dashboard .nl-report-shortcut:hover{transform:none!important;box-shadow:0 3px 9px rgba(108,55,18,.12)!important}
.analytics-dashboard .nl-shortcut-title{font-size:.78rem!important;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.analytics-dashboard .nl-shortcut-desc{display:none!important}
.analytics-dashboard .nl-report-shortcut .nl-shortcut-count{font-size:.69rem!important;padding:3px 6px!important}
.analytics-dashboard .nl-report-shortcut > .nl-shortcut-count:first-child{min-width:23px!important}
.analytics-dashboard .nl-report-shortcuts > p.small{margin-top:4px!important;font-size:.72rem!important}
.analytics-dashboard #nlAnalyticsFilters{padding:12px 15px!important;margin-bottom:13px!important}
.analytics-dashboard .nl-filter-advanced{margin-top:6px!important;padding-top:8px!important}
body[data-nl-screen="module6-analytics"] .nl-side-group[data-u-menu="analytics"] .nl-side-children{animation:none!important;transform:none!important}
body[data-nl-screen="module6-analytics"] .nl-side-group[data-u-menu="analytics"] .nl-side-child{transform:none!important;transition:background-color .14s ease,color .14s ease!important}
body[data-nl-screen="module6-analytics"] .nl-side-group[data-u-menu="analytics"] .nl-side-child:hover:not(.is-current){background:transparent!important;color:#806453!important}
body[data-nl-screen="module6-analytics"] .nl-side-group[data-u-menu="analytics"] .nl-side-child.is-current{background:#ffe3ce!important;color:#a64111!important}
@media(max-width:660px){.analytics-dashboard .nl-report-shortcut{flex:0 0 168px;min-width:168px}.analytics-dashboard .nl-report-shortcuts{padding:10px!important}}
@media(prefers-reduced-motion:reduce){.analytics-dashboard .nl-report-shortcut-grid{scroll-behavior:auto!important}}

/* v16.7 analytics hero */
.analytics-dashboard .nl-analytics-hero{position:relative;display:grid;grid-template-columns:minmax(0,1.5fr) minmax(220px,.7fr);gap:18px;align-items:center;padding:20px 22px;border:1px solid #ecd3bf;border-radius:22px;background:linear-gradient(126deg,#fffdfa,#fff1e1 72%,#ffe5cb);box-shadow:0 16px 34px rgba(87,53,23,.07);margin-bottom:14px;overflow:hidden}
.analytics-dashboard .nl-analytics-hero:after{content:"";position:absolute;right:-80px;top:-84px;width:240px;height:240px;border-radius:50%;border:1px solid rgba(212,91,23,.13);box-shadow:0 0 0 26px rgba(212,91,23,.05),0 0 0 56px rgba(212,91,23,.025)}
.analytics-dashboard .nl-analytics-hero-copy,.analytics-dashboard .nl-analytics-hero-actions,.analytics-dashboard .nl-analytics-art{position:relative;z-index:1}
.analytics-dashboard .nl-analytics-hero .hero-kicker{font-size:.76rem;font-weight:850;letter-spacing:.14em;text-transform:uppercase;color:#ae4a1b}
.analytics-dashboard .nl-analytics-hero h1{font-size:clamp(1.6rem,2.6vw,2.25rem);font-weight:900;margin:.3rem 0 .45rem;color:#3b281f}
.analytics-dashboard .nl-analytics-hero p{max-width:690px;color:#7a6456;line-height:1.5;margin:0}
.analytics-dashboard .nl-analytics-art{display:flex;justify-content:flex-end;align-items:center;min-height:138px}
.analytics-dashboard .nl-analytics-scene{position:relative;width:290px;height:154px;transform:scale(.97);transform-origin:100% 50%;filter:drop-shadow(0 14px 18px rgba(133,72,36,.13))}
.analytics-dashboard .nl-analytics-halo{position:absolute;inset:6px 16px 0 52px;border-radius:50%;border:1px solid rgba(205,100,41,.16);background:radial-gradient(circle at 55% 44%,rgba(255,255,255,.85),rgba(255,216,181,.16) 74%,transparent 75%)}
.analytics-dashboard .nl-chart-card{position:absolute;right:18px;top:24px;width:164px;height:108px;border:3px solid #9e532c;border-radius:18px;background:linear-gradient(145deg,#fffef8,#ffdfbc);box-shadow:9px 12px 0 rgba(148,74,33,.12);animation:anCard 5.8s ease-in-out infinite}
.analytics-dashboard .nl-chart-bars{position:absolute;left:18px;right:18px;bottom:18px;display:flex;align-items:flex-end;gap:11px}
.analytics-dashboard .nl-chart-bars i{display:block;flex:1;border-radius:10px 10px 4px 4px;background:linear-gradient(180deg,#ffb77a,#d86a1d);border:2px solid #9c522a;animation:anBar 4.6s ease-in-out infinite}
.analytics-dashboard .nl-chart-bars i:nth-child(1){height:36px;animation-delay:0s}.analytics-dashboard .nl-chart-bars i:nth-child(2){height:58px;animation-delay:.18s}.analytics-dashboard .nl-chart-bars i:nth-child(3){height:72px;animation-delay:.36s}
.analytics-dashboard .nl-chart-line{position:absolute;left:18px;right:18px;top:28px;height:36px}
.analytics-dashboard .nl-chart-line:before{content:"";position:absolute;left:0;right:0;top:18px;height:0;border-top:3px solid #ca6120;border-radius:20px;clip-path:polygon(0 68%,18% 44%,38% 56%,58% 14%,78% 26%,100% 0,100% 100%,0 100%)}
.analytics-dashboard .nl-chart-line:after{content:"";position:absolute;left:0;right:0;top:18px;height:0;border-top:3px solid #f0b17c;transform:translateY(10px);clip-path:polygon(0 88%,20% 64%,40% 76%,62% 34%,82% 44%,100% 12%,100% 100%,0 100%)}
.analytics-dashboard .nl-chart-pie{position:absolute;left:24px;top:36px;width:68px;height:68px;border-radius:50%;border:4px solid #9e532c;background:conic-gradient(#ea7b28 0 118deg,#ffd39f 118deg 270deg,#f5b376 270deg 360deg);box-shadow:0 9px 0 rgba(148,74,33,.12);animation:anPie 9s linear infinite}
@keyframes anCard{0%,100%{transform:translateY(0)}50%{transform:translateY(-6px)}}
@keyframes anBar{0%,100%{transform:translateY(0)}50%{transform:translateY(-4px)}}
@keyframes anPie{from{transform:rotate(0)}to{transform:rotate(360deg)}}
@media(max-width:760px){.analytics-dashboard .nl-analytics-hero{grid-template-columns:1fr;padding:18px 20px}.analytics-dashboard .nl-analytics-art{display:none}}
@media(prefers-reduced-motion:reduce){.analytics-dashboard .nl-analytics-scene *{animation:none!important}}


/* v16.9 | keep the analytics illustration inside a real, scoped header card */
.analytics-dashboard .nl-analytics-hero{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(220px,286px)!important;min-height:190px;margin-bottom:16px;padding:20px 24px;isolation:isolate;overflow:hidden!important;align-items:center}
.analytics-dashboard .nl-analytics-hero-copy{position:relative;z-index:1;min-width:0}
.analytics-dashboard .nl-analytics-art{position:relative;z-index:1;display:block!important;justify-self:end;width:100%;max-width:286px;height:158px;min-height:158px;overflow:hidden!important;border-radius:16px}
.analytics-dashboard .nl-analytics-scene{position:absolute;left:2px;top:4px;width:290px;height:154px;transform:scale(.94)!important;transform-origin:top left!important;filter:none!important}
@media(max-width:850px){.analytics-dashboard .nl-analytics-hero{grid-template-columns:1fr!important;min-height:0;padding:18px 20px}.analytics-dashboard .nl-analytics-art{display:none!important}}
@media(prefers-reduced-motion:reduce){.analytics-dashboard .nl-analytics-scene *{animation:none!important}}

/* Zoomable analytics graphs: the actual canvas and controls move into the themed overlay. */
.analytics-dashboard .nl-chart-zoom-overlay{position:fixed;inset:0;z-index:1600;background:#21140fd4;backdrop-filter:blur(5px);padding:clamp(12px,2.5vw,30px);display:flex;align-items:center;justify-content:center;overflow-y:auto;overscroll-behavior:contain;box-sizing:border-box}
.analytics-dashboard .nl-chart-zoom-overlay[hidden]{display:none!important}
.analytics-dashboard .nl-chart-zoom-panel{width:min(1200px,100%);max-height:calc(100dvh - clamp(24px,5vw,60px));overflow-y:auto;overscroll-behavior:contain;box-sizing:border-box;background:#fffaf5;border-radius:24px;border:1px solid #e4bea3;padding:clamp(14px,2.4vw,26px);box-shadow:0 35px 100px #21140f55;margin:auto;scrollbar-gutter:stable}
.analytics-dashboard .nl-chart-zoom-head{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;margin-bottom:16px;border-bottom:1px solid #f0ddcc;padding-bottom:12px}
.analytics-dashboard .nl-chart-zoom-head h2{font-size:1.4rem;font-weight:900;margin:0;color:#48291c}
.analytics-dashboard .nl-chart-zoom-head p{margin:3px 0 0;color:#836956;font-size:.82rem}
.analytics-dashboard .nl-chart-zoom-actions{display:flex;gap:8px;flex-wrap:wrap}
.analytics-dashboard .nl-zoom-filter-panel{margin-top:13px;background:#fff7ef;border:1px solid #ecd3bb;border-radius:13px;padding:12px 15px}.analytics-dashboard .nl-zoom-filter-panel summary{font-weight:850;color:#984418;cursor:pointer}.analytics-dashboard .nl-zoom-filter-panel #nlAnalyticsFilters{background:transparent!important;box-shadow:none!important}
.analytics-dashboard .nl-chart-zoom-panel .nl-report-chart{border:1px solid #ead4c1;border-radius:16px;padding:14px;box-shadow:none;display:block!important;width:100%;height:auto}
.analytics-dashboard .nl-chart-zoom-panel .nl-report-chart-frame{height:min(60vh,580px)!important;min-height:340px!important}
.analytics-dashboard .nl-chart-zoom-panel .nl-report-chart-frame canvas{cursor:crosshair}
.analytics-dashboard .nl-chart-zoom-panel [data-nl-inline-open],.analytics-dashboard .nl-chart-zoom-panel [data-nl-inline-expand]{display:none!important}
@media(max-width:650px){.analytics-dashboard .nl-chart-zoom-overlay{padding:10px}.analytics-dashboard .nl-chart-zoom-panel{max-height:calc(100dvh - 20px);padding:14px;border-radius:16px}.analytics-dashboard .nl-chart-zoom-panel .nl-report-chart-frame{height:min(48dvh,420px)!important;min-height:245px!important}}
.analytics-dashboard .nl-report-chart-frame canvas{cursor:zoom-in}
.analytics-dashboard .nl-chart-zoom-btn{border-radius:9px;background:#fff5ec;color:#9f4614;border:1px solid #e8bd9d;padding:6px 12px;font-weight:800;font-size:.8rem}
@media(prefers-reduced-motion:reduce){.analytics-dashboard .nl-chart-zoom-overlay{backdrop-filter:none}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-analytics-report,html[data-nl-mode="dark"] body.nl-themed-page .nl-analytics-hero,html[data-nl-mode="dark"] body.nl-themed-page .nl-ops-card,html[data-nl-mode="dark"] body.nl-themed-page .nl-ops-kpi,html[data-nl-mode="dark"] body.nl-themed-page .nl-report-shortcuts,html[data-nl-mode="dark"] body.nl-themed-page .nl-report-shortcut,html[data-nl-mode="dark"] body.nl-themed-page .nl-report-table-pane,html[data-nl-mode="dark"] body.nl-themed-page .nl-report-chart,html[data-nl-mode="dark"] body.nl-themed-page .nl-chart-card,html[data-nl-mode="dark"] body.nl-themed-page .nl-chart-zoom-panel,html[data-nl-mode="dark"] body.nl-themed-page .nl-chart-empty,html[data-nl-mode="dark"] body.nl-themed-page .nl-chart-fallback{background:#203044!important;background-image:none!important;color:#edf4fc!important;border-color:#526b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-report-shortcut,html[data-nl-mode="dark"] body.nl-themed-page .nl-ops-kpi,html[data-nl-mode="dark"] body.nl-themed-page .nl-chart-type{background:#2b3e52!important;color:#edf4fc!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-analytics-report :is(h2,h3,p,small,strong),html[data-nl-mode="dark"] body.nl-themed-page .nl-ops-card :is(h2,h3,p,small,strong){color:#edf4fc!important}

/* v20.23 - stable analytics controls and report scanability */
body[data-nl-screen="module6-analytics"] .nl-report-layout-bar{gap:10px!important;flex-wrap:wrap!important}
body[data-nl-screen="module6-analytics"] .nl-report-chart-meta{gap:10px;flex-wrap:wrap}
body[data-nl-screen="module6-analytics"] .nl-report-chart{border-radius:16px!important}
body[data-nl-screen="module6-analytics"] .nl-report-table-heading{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:9px}
body[data-nl-screen="module6-analytics"] .nl-report-shortcut:focus-visible{outline:3px solid #f39d5a!important;outline-offset:3px}
@media(max-width:820px){body[data-nl-screen="module6-analytics"] .nl-report-layout-bar>*{min-width:0!important}}


/* v20.30: analytics controls must not shrink native select text or clip menus. */
body[data-nl-screen="module6-analytics"] .nl-chart-tools{
 display:flex!important;align-items:center!important;flex-wrap:wrap!important;
 gap:9px!important;min-width:0!important;width:100%!important;
}
body[data-nl-screen="module6-analytics"] .nl-chart-tools .nl-chart-select-group{
 display:inline-flex!important;align-items:center;gap:9px;
 flex:1 1 270px;min-width:min(100%,270px);max-width:100%;
}
body[data-nl-screen="module6-analytics"] .nl-chart-tools .nl-chart-type-label{
 flex:0 0 auto;white-space:nowrap;margin:0;
}
body[data-nl-screen="module6-analytics"] .nl-chart-tools select.nl-chart-type{
 display:block!important;flex:1 1 180px!important;width:auto!important;
 min-width:175px!important;max-width:100%!important;
 padding:8px 36px 8px 12px!important;line-height:1.35;
 color:#56331e;appearance:auto;box-sizing:border-box;
}
body[data-nl-screen="module6-analytics"] .nl-chart-tools :is(button,.btn){
 flex:0 0 auto;max-width:100%;white-space:normal;line-height:1.3;
}
/* The Columns menu is absolutely positioned; clipping the whole card hides it. */
body[data-nl-screen="module6-analytics"] .nl-report-table-pane{
 overflow:visible!important;position:relative;min-width:0;
}
body[data-nl-screen="module6-analytics"] .nl-report-table-heading{
 border-radius:14px 14px 0 0;
}
body[data-nl-screen="module6-analytics"] .nl-report-table-pane .nl18-table-addons{
 position:relative;z-index:10;gap:10px;min-width:0;
}
body[data-nl-screen="module6-analytics"] .nl-report-table-pane .nl18-table-addons details[open]{
 z-index:100;
}
body[data-nl-screen="module6-analytics"] .nl-report-table-pane .nl18-table-addons select.nl18-mini-btn{
 flex:0 0 auto;width:135px!important;min-width:135px!important;
 padding:8px 32px 8px 12px!important;text-overflow:clip;
}
body[data-nl-screen="module6-analytics"] .nl-report-table-pane .table-responsive{
 border-radius:0 0 14px 14px!important;
}
/* Align numeric values with their own numeric headings, not the preceding column. */
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table{
 table-layout:fixed;width:100%!important;min-width:555px;
 font-variant-numeric:tabular-nums;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td){
 box-sizing:border-box;white-space:nowrap;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(1){
 width:24%;text-align:left!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(2){
 width:31%;text-align:right!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(3){
 width:25%;text-align:right!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(4){
 width:20%;text-align:right!important;
}
body[data-nl-screen="module6-analytics"] .nl-growth-unavailable{
 color:#8b7768;font-weight:650;cursor:help;
}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] .nl-chart-tools select.nl-chart-type{
 background-color:#283c50!important;color:#f0f4fa!important;border-color:#627b94!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] .nl-growth-unavailable{
 color:#b9c9d8!important;
}
@media(max-width:680px){
 body[data-nl-screen="module6-analytics"] .nl-report-table-pane .nl18-table-addons{justify-content:flex-start!important}
 body[data-nl-screen="module6-analytics"] .nl-chart-tools .nl-chart-select-group{flex:1 1 100%;min-width:0}
 body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table{min-width:0!important;table-layout:auto!important}
 body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table td{width:100%!important;white-space:normal!important}
}

/* v20.31 FR6.2: three analysis dimensions and stable six-column layout */
body[data-nl-screen="module6-analytics"] .nl-trend-view-picker{display:flex;align-items:center;flex-wrap:wrap;gap:8px;min-width:0}
body[data-nl-screen="module6-analytics"] .nl-trend-view-picker label{font-size:.85rem;font-weight:800;color:#784b31;margin:0}
body[data-nl-screen="module6-analytics"] .nl-trend-view-picker select{min-width:180px;max-width:100%;height:39px;border-radius:11px;border:1px solid #dbb69b;background:#fffaf6;color:#573928;padding:7px 30px 7px 12px;font-weight:700}
body[data-nl-screen="module6-analytics"] .nl-trend-view-picker>span{font-size:.72rem;color:#8a6c5a;flex-basis:100%}
body[data-nl-screen="module6-analytics"] #nlSalesMetric{min-width:132px;width:148px!important;max-width:195px!important;flex:0 1 auto}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table{width:100%!important;min-width:830px!important;table-layout:fixed!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td){white-space:normal!important;overflow-wrap:anywhere!important;vertical-align:middle!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(1){width:13%!important;text-align:left!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(2){width:22%!important;text-align:left!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(3){width:27%!important;text-align:left!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(4){width:16%!important;text-align:right!important;white-space:nowrap!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(5){width:11%!important;text-align:right!important;white-space:nowrap!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(6){width:11%!important;text-align:right!important;white-space:nowrap!important}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] .nl-trend-view-picker label{color:#f3e1d4!important}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] .nl-trend-view-picker select{color:#eff5fc!important;background:#2b3e52!important;border-color:#607b96!important}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] .nl-trend-view-picker>span{color:#ccdbe8!important}
@media(max-width:950px){body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table{min-width:790px!important}}


/* v20.32: FR6.2 sales trend — a readable financial table, not six squeezed columns.
   Keep the globally shared sortable headers and column selector functional. */
body[data-nl-screen="module6-analytics"] #sales-trends .nl-report-workspace{gap:18px!important}
body[data-nl-screen="module6-analytics"] #sales-trends .nl-report-table-pane{min-width:0!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table.table-responsive{
  max-width:100%!important;overflow-x:auto!important;overflow-y:auto!important;
  scrollbar-gutter:stable;overscroll-behavior-x:contain;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table{
  width:100%!important;min-width:1060px!important;table-layout:fixed!important;
  font-variant-numeric:tabular-nums;border-collapse:separate;border-spacing:0;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td){
  box-sizing:border-box!important;word-break:normal!important;
  overflow-wrap:normal!important;hyphens:none!important;
  vertical-align:middle!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table thead th{
  font-size:.76rem!important;letter-spacing:.015em!important;
  line-height:1.4!important;white-space:nowrap!important;
  padding:14px 12px!important;border-bottom:1px solid #e9d0b9!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table tbody td{
  font-size:.84rem!important;line-height:1.5!important;
  padding:15px 12px!important;white-space:nowrap!important;
  border-bottom:1px solid #f0e8e1!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table tbody tr:hover td{
  background-color:rgba(219,103,26,.055)!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(1){width:13%!important;text-align:left!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(2){width:23%!important;text-align:left!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(3){width:24%!important;text-align:left!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(4){width:17%!important;text-align:right!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(5){width:12%!important;text-align:right!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table :is(th,td):nth-child(6){width:11%!important;text-align:right!important}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table tbody :is(td:nth-child(2),td:nth-child(3)){
  white-space:normal!important;overflow-wrap:break-word!important;line-height:1.5!important;
}
/* The universal table sorter wraps each heading in a button. Keep words and arrows together. */
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table thead th .nl-sort-head{
  display:inline-flex!important;width:100%!important;max-width:100%!important;
  min-width:0!important;align-items:center!important;
  gap:6px!important;white-space:nowrap!important;word-break:keep-all!important;
  overflow-wrap:normal!important;justify-content:flex-start!important;
  text-align:inherit!important;line-height:1.3!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table thead th:nth-child(n+4) .nl-sort-head{
  justify-content:flex-end!important;
}
body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table thead th .nl-sort-head::after{
  flex:0 0 auto!important;margin-left:4px!important;
}
/* On small screens, the table scrolls inside its card rather than breaking labels. */
@media(max-width:760px){
  body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table{min-width:1060px!important}
}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table tbody td{
  border-bottom-color:#435569!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table thead th{
  border-bottom-color:#607589!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table tbody tr:hover td{
  background-color:rgba(217,120,51,.11)!important;
}


/* v20.33: Consistent left-aligned headings across every Analytics report.
   The section-mark remains on the right; data columns keep their own alignment. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-analytics-report > .panel-heading {
  display: grid !important;
  grid-template-columns: minmax(0, 1fr) auto !important;
  align-items: center !important;
  justify-items: stretch !important;
  column-gap: 16px !important;
  width: 100% !important;
  margin: 0 0 18px !important;
  text-align: left !important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-analytics-report > .panel-heading > div:not(.section-mark) {
  grid-column: 1 !important;
  grid-row: 1 !important;
  width: 100% !important;
  min-width: 0 !important;
  margin: 0 !important;
  justify-self: start !important;
  text-align: left !important;
}
/* v20.34: The animated illustration is injected into the heading as
   span.nl-report-scene by the existing shared UI enhancement. Place THAT
   element in the right grid cell. The legacy empty section-mark must not
   consume a grid cell or push the animation below the report title. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-analytics-report > .panel-heading > .section-mark {
  display: none !important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-analytics-report > .panel-heading > .nl-report-scene {
  display: block !important;
  grid-column: 2 !important;
  grid-row: 1 !important;
  justify-self: end !important;
  align-self: center !important;
  margin: 0 0 0 auto !important;
  width: 95px !important;
  height: 57px !important;
  min-width: 95px !important;
  flex: none !important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-analytics-report > .panel-heading :is(.panel-title, .panel-caption) {
  display: block !important;
  width: 100% !important;
  max-width: none !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
  padding-left: 0 !important;
  text-align: left !important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-analytics-report > .panel-heading .panel-title {
  margin-top: 0 !important;
  margin-bottom: 5px !important;
}
/* Apply the same title alignment to dashboard overview, charts and record cards. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard :is(.nl-analytics-hero-copy, .nl-report-shortcuts h2, .nl-ops-title h2, .nl-report-chart-info, .nl-report-table-heading strong) {
  text-align: left !important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-chart-info {
  align-self: stretch;
  min-width: 0;
}
@media (max-width: 600px) {
  body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-analytics-report > .panel-heading {
    column-gap: 10px !important;
    margin-bottom: 14px !important;
  }
}

 
/* v20.35 - All analytics reports: consistent financial-grid geometry.
   Scope to this view so pricing, booking and other module tables are unaffected.
   Sales Trend retains its existing six-column treatment from v20.32. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane
  :is(#abc-classification-table,#inventory-turnover-table,#profitability-table,#demand-forecast-table,#profit-loss-table) {
  max-width:100%!important;
  min-width:0!important;
  overflow-x:auto!important;
  overflow-y:auto!important;
  scrollbar-gutter:stable;
  overscroll-behavior-x:contain;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane
  :is(#abc-classification-table,#inventory-turnover-table,#profitability-table,#demand-forecast-table,#profit-loss-table) .analytics-table {
  width:100%!important;
  table-layout:fixed!important;
  border-collapse:separate!important;
  border-spacing:0!important;
  font-variant-numeric:tabular-nums;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane
  :is(#abc-classification-table,#inventory-turnover-table,#profitability-table,#demand-forecast-table,#profit-loss-table) .analytics-table :is(th,td) {
  box-sizing:border-box!important;
  text-align:left!important;
  vertical-align:middle!important;
  word-break:normal!important;
  overflow-wrap:normal!important;
  hyphens:none!important;
  line-height:1.45!important;
  padding:13px 11px!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane
  :is(#abc-classification-table,#inventory-turnover-table,#profitability-table,#demand-forecast-table,#profit-loss-table) .analytics-table thead th {
  white-space:normal!important;
  font-size:.73rem!important;
  letter-spacing:.015em!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane
  :is(#abc-classification-table,#inventory-turnover-table,#profitability-table,#demand-forecast-table,#profit-loss-table) .analytics-table tbody td {
  white-space:nowrap!important;
  min-width:0!important; /* Overrule global "last column = actions" assumption. */
  max-width:none!important;
  font-size:.83rem!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane
  :is(#abc-classification-table,#inventory-turnover-table,#profitability-table,#demand-forecast-table,#profit-loss-table) .analytics-table thead th .nl-sort-head {
  display:inline-flex!important;
  align-items:center!important;
  justify-content:flex-start!important;
  text-align:inherit!important;
  white-space:normal!important;
  width:100%!important;
  max-width:100%!important;
  gap:5px!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane
  :is(#abc-classification-table,#inventory-turnover-table,#profitability-table,#demand-forecast-table,#profit-loss-table) .analytics-table thead th .nl-sort-head::after {
  flex:none!important;
  margin-left:3px!important;
}
/* First columns identify a product, date, route or shipment; later columns are metrics. */
body[data-nl-screen="module6-analytics"] #abc-classification-table .analytics-table {min-width:600px!important}
body[data-nl-screen="module6-analytics"] #inventory-turnover-table .analytics-table {min-width:660px!important}
body[data-nl-screen="module6-analytics"] #profitability-table .analytics-table {min-width:665px!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table {min-width:1000px!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table {min-width:1190px!important}
/* Explicit column widths keep heading and cell on the same vertical grid line. */
body[data-nl-screen="module6-analytics"] #abc-classification-table .analytics-table :is(th,td):nth-child(1){width:26%!important}
body[data-nl-screen="module6-analytics"] #abc-classification-table .analytics-table :is(th,td):nth-child(2){width:29%!important}
body[data-nl-screen="module6-analytics"] #abc-classification-table .analytics-table :is(th,td):nth-child(3){width:25%!important}
body[data-nl-screen="module6-analytics"] #abc-classification-table .analytics-table :is(th,td):nth-child(4){width:20%!important}
body[data-nl-screen="module6-analytics"] #inventory-turnover-table .analytics-table :is(th,td):nth-child(1){width:23%!important}
body[data-nl-screen="module6-analytics"] #inventory-turnover-table .analytics-table :is(th,td):nth-child(2){width:28%!important}
body[data-nl-screen="module6-analytics"] #inventory-turnover-table .analytics-table :is(th,td):nth-child(3){width:29%!important}
body[data-nl-screen="module6-analytics"] #inventory-turnover-table .analytics-table :is(th,td):nth-child(4){width:20%!important}
body[data-nl-screen="module6-analytics"] #profitability-table .analytics-table :is(th,td):nth-child(1){width:18%!important}
body[data-nl-screen="module6-analytics"] #profitability-table .analytics-table :is(th,td):nth-child(2){width:18%!important}
body[data-nl-screen="module6-analytics"] #profitability-table .analytics-table :is(th,td):nth-child(3){width:24%!important}
body[data-nl-screen="module6-analytics"] #profitability-table .analytics-table :is(th,td):nth-child(4){width:19%!important}
body[data-nl-screen="module6-analytics"] #profitability-table .analytics-table :is(th,td):nth-child(5){width:21%!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table :is(th,td):nth-child(1){width:17%!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table :is(th,td):nth-child(2){width:17%!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table :is(th,td):nth-child(3){width:13%!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table :is(th,td):nth-child(4){width:14%!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table :is(th,td):nth-child(5){width:15%!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table :is(th,td):nth-child(6){width:13%!important}
body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table :is(th,td):nth-child(7){width:11%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(1){width:11%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(2){width:10%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(3){width:15%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(4){width:14%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(5){width:11%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(6){width:14%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(7){width:12%!important}
body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table :is(th,td):nth-child(8){width:13%!important}
/* All monetary values, quantities, percentages and ratios: header and value use
   the SAME right edge (including the universal sort-button wrapper). */
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane :is(
  #abc-classification-table .analytics-table :is(th,td):nth-child(2),
  #abc-classification-table .analytics-table :is(th,td):nth-child(3),
  #inventory-turnover-table .analytics-table :is(th,td):nth-child(n+2),
  #profitability-table .analytics-table :is(th,td):nth-child(n+3),
  #demand-forecast-table .analytics-table :is(th,td):nth-child(n+5),
  #profit-loss-table .analytics-table :is(th,td):nth-child(n+3)
) {text-align:right!important;font-variant-numeric:tabular-nums!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane :is(
  #abc-classification-table .analytics-table th:nth-child(2),
  #abc-classification-table .analytics-table th:nth-child(3),
  #inventory-turnover-table .analytics-table th:nth-child(n+2),
  #profitability-table .analytics-table th:nth-child(n+3),
  #demand-forecast-table .analytics-table th:nth-child(n+5),
  #profit-loss-table .analytics-table th:nth-child(n+3)
) .nl-sort-head {justify-content:flex-end!important;text-align:right!important}
/* ABC class is categorical, not a financial amount. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane #abc-classification-table .analytics-table :is(th,td):nth-child(4){text-align:center!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane #abc-classification-table .analytics-table th:nth-child(4) .nl-sort-head{justify-content:center!important;text-align:center!important}
/* Keep the same table on small screens rather than switching data cells to card
   display: the user needs to compare monetary columns vertically. */
@media(max-width:700px){
  body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .analytics-table.nl-smart-table{min-width:inherit!important}
  body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .analytics-table.nl-smart-table thead{display:table-header-group!important}
  body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .analytics-table.nl-smart-table tbody{display:table-row-group!important}
  body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .analytics-table.nl-smart-table tbody tr{display:table-row!important;margin:0!important;border:0!important;padding:0!important}
  body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .analytics-table.nl-smart-table tbody td{display:table-cell!important;min-width:0!important;max-width:none!important;justify-content:initial!important;white-space:nowrap!important;border-bottom:1px solid #ebdfd3!important}
  body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .analytics-table.nl-smart-table tbody td::before{display:none!important;content:none!important}
  body[data-nl-screen="module6-analytics"] #abc-classification-table .analytics-table{min-width:600px!important}
  body[data-nl-screen="module6-analytics"] #inventory-turnover-table .analytics-table{min-width:680px!important}
  body[data-nl-screen="module6-analytics"] #profitability-table .analytics-table{min-width:755px!important}
  body[data-nl-screen="module6-analytics"] #demand-forecast-table .analytics-table{min-width:1000px!important}
  body[data-nl-screen="module6-analytics"] #profit-loss-table .analytics-table{min-width:1190px!important}
  body[data-nl-screen="module6-analytics"] #sales-trends-table .analytics-table{min-width:1060px!important}
}
html[data-nl-mode="dark"] body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .analytics-table tbody td{border-bottom-color:#435569!important}

/* v20.36 | Readable long route names in Demand Forecast and financial reports.
   The table must scroll inside its card instead of drawing text over neighbours. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table {
  width:100%!important;
  min-width:1250px!important;
  table-layout:fixed!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td):nth-child(1) {width:20%!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td):nth-child(2) {width:22%!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td):nth-child(3) {width:12%!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td):nth-child(4) {width:12%!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td):nth-child(5) {width:13%!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td):nth-child(6) {width:11%!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td):nth-child(7) {width:10%!important}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table tbody td:nth-child(-n+3) {
  white-space:normal!important;
  overflow-wrap:break-word!important;
  word-break:normal!important;
  hyphens:none!important;
  line-height:1.5!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table tbody td:nth-child(n+4) {
  white-space:nowrap!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table :is(th,td),
body[data-nl-screen="module6-analytics"] .analytics-dashboard #profit-loss-table .analytics-table :is(th,td) {
  overflow:hidden;
  text-overflow:clip;
}
/* The P&L report needs room for eight distinct currency/ID columns. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard #profit-loss-table .analytics-table {
  min-width:1280px!important;
}
/* Preserve the same true table columns in split and responsive views. */
@media(max-width:700px){
 body[data-nl-screen="module6-analytics"] .analytics-dashboard #demand-forecast-table .analytics-table {min-width:1250px!important}
 body[data-nl-screen="module6-analytics"] .analytics-dashboard #profit-loss-table .analytics-table {min-width:1280px!important}
}
/* Keep the search and universal table controls usable inside a split report pane.
   Width is measured per table card, not from the overall browser viewport. */
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane {
  container-type:inline-size;
  container-name:nlog-analytics-table;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .nl-table-toolbar {
  display:flex!important;flex-wrap:wrap!important;align-items:center!important;
  gap:9px!important;min-width:0!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .nl-table-filters {
  display:flex!important;flex:1 1 360px!important;min-width:0!important;
  flex-wrap:wrap!important;align-items:center!important;gap:8px!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .nl-table-search {
  flex:1 1 230px!important;min-width:min(100%,200px)!important;
  max-width:none!important;
}
body[data-nl-screen="module6-analytics"] .analytics-dashboard .nl-report-table-pane .nl18-table-addons {
  display:flex!important;flex-wrap:wrap!important;align-items:center!important;gap:8px!important;
}
@container nlog-analytics-table (max-width: 700px){
  .nl-table-toolbar .nl-table-filters {flex:1 1 100%!important;}
  .nl-table-toolbar .nl-table-records {flex:1 1 100%!important;margin-left:0!important;}
  .nl18-table-addons {justify-content:flex-start!important;}
  .nl18-table-addons .nl18-table-status {flex:1 1 100%!important;margin:0!important;}
}
@container nlog-analytics-table (max-width: 440px){
  .nl18-table-addons select.nl18-mini-btn {width:120px!important;min-width:120px!important;}
  .nl-table-toolbar .nl-table-search {flex-basis:100%!important;}
}
</style>
</head><body data-nl-screen="module6-analytics" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module6_analytics__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">





<div class="analytics-dashboard">
<section class="nl-analytics-hero" aria-label="Analytics dashboard overview"><div class="nl-analytics-hero-copy"><div class="hero-kicker">REPORTING CENTER</div><h1>Analytics Dashboard</h1><p>Explore the main business reports, switch chart views, and work from the same compact header style used across the workspace.</p></div><div class="nl-analytics-art" aria-hidden="true"><div class="nl-analytics-scene"><div class="nl-analytics-halo"></div><div class="nl-chart-pie"></div><div class="nl-chart-card"><div class="nl-chart-line"></div><div class="nl-chart-bars"><i></i><i></i><i></i></div></div></div></div></section>




<section id="nlAnalyticsQuickAccess" class="nl-report-shortcuts" aria-labelledby="nlQuickHeading">
 <div class="d-flex align-items-center justify-content-between gap-2 flex-wrap"><div><h2 id="nlQuickHeading" class="h5 fw-bold mb-1">Explore analytics reports</h2><p class="nl-report-intro">Choose a report, explore the numbers in its table, and change the chart view whenever you like.</p></div><a class="btn btn-sm btn-outline-warning" href="#nlAnalyticsFilters">Change report filters</a></div>
 <nav class="nl-report-shortcut-grid" aria-label="Jump to an analytics report">
  <a class="nl-report-shortcut" href="#sales-trends" title="Go to Sales trend"><span aria-hidden="true" class="nl-shortcut-count">01</span><span class="flex-grow-1"><span class="nl-shortcut-title d-block">Sales trend</span><span class="nl-shortcut-desc d-block">Route · Product · Customer</span></span><span class="nl-shortcut-count">${requestScope.nlv_Module6_analytics__2}</span></a>
  <a class="nl-report-shortcut" href="#abc-classification" title="Go to ABC classification"><span aria-hidden="true" class="nl-shortcut-count">02</span><span class="flex-grow-1"><span class="nl-shortcut-title d-block">ABC classification</span><span class="nl-shortcut-desc d-block">Product value groups</span></span><span class="nl-shortcut-count">${requestScope.nlv_Module6_analytics__3}</span></a>
  <a class="nl-report-shortcut" href="#inventory-turnover" title="Go to Inventory turnover"><span aria-hidden="true" class="nl-shortcut-count">03</span><span class="flex-grow-1"><span class="nl-shortcut-title d-block">Inventory turnover</span><span class="nl-shortcut-desc d-block">Stock movement and usage</span></span><span class="nl-shortcut-count">${requestScope.nlv_Module6_analytics__4}</span></a>
  <a class="nl-report-shortcut" href="#profitability" title="Go to Product profitability"><span aria-hidden="true" class="nl-shortcut-count">04</span><span class="flex-grow-1"><span class="nl-shortcut-title d-block">Product profitability</span><span class="nl-shortcut-desc d-block">Revenue, cost and margin</span></span><span class="nl-shortcut-count">${requestScope.nlv_Module6_analytics__5}</span></a>
  <a class="nl-report-shortcut" href="#demand-forecast" title="Go to Demand forecast"><span aria-hidden="true" class="nl-shortcut-count">05</span><span class="flex-grow-1"><span class="nl-shortcut-title d-block">Demand forecast</span><span class="nl-shortcut-desc d-block">Estimated future bookings</span></span><span class="nl-shortcut-count">${requestScope.nlv_Module6_analytics__6}</span></a>
  <a class="nl-report-shortcut" href="#profit-loss" title="Go to Profit &amp; loss"><span aria-hidden="true" class="nl-shortcut-count">06</span><span class="flex-grow-1"><span class="nl-shortcut-title d-block">Profit &amp; loss</span><span class="nl-shortcut-desc d-block">Shipment financial results</span></span><span class="nl-shortcut-count">${requestScope.nlv_Module6_analytics__7}</span></a>
 </nav>
 <p class="small text-secondary mb-0 mt-3">Tip: Use Chart style to switch formats. Choose Wider table when you need more room for detailed records.</p>
</section>

       <form id="nlAnalyticsFilters" method="get" action="${requestScope.nlv_Module6_analytics__8}/analytics" class="card p-3 mb-4 border-0 shadow-sm rounded-4 border-warning-subtle" aria-label="Analytics date filters">
          <div class="row g-2 align-items-end">
            <div class="col-sm-5 col-lg-3"><label for="analyticsFrom" class="form-label">From date</label><input class="form-control" type="date" id="analyticsFrom" name="from" value="${requestScope.nlv_Module6_analytics__9}"></div>
            <div class="col-sm-5 col-lg-3"><label for="analyticsTo" class="form-label">To date</label><input class="form-control" type="date" id="analyticsTo" name="to" value="${requestScope.nlv_Module6_analytics__10}"></div>
            <div class="col-sm-auto"><button class="btn btn-warning bg-gradient" type="submit">Apply filters</button></div>
            <div class="col-sm-auto"><a class="btn btn-outline-secondary" href="${requestScope.nlv_Module6_analytics__11}/analytics">Clear</a></div>
          </div>
          <details class="nl-filter-advanced"${requestScope.nlv_Module6_analytics__12}><summary>More filters — route and seller</summary><div class="row g-2 mt-2">
            <div class="col-md-3"><label class="form-label">Origin port</label><select class="form-select" name="origin"><option value="">All origins</option><jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__13" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" /></select></div>
            <div class="col-md-3"><label class="form-label">Destination port</label><select class="form-select" name="dest"><option value="">All destinations</option><jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__14" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" /></select></div>
            ${requestScope.nlv_Module6_analytics__15}
          </div></details>
          <p class="text-secondary small mt-2 mb-0">Choose dates and select Apply filters. Open More filters to narrow by route or seller. Some product-level reports are calculated independently of route filters.</p>
       </form>
       ${requestScope.nlv_Module6_analytics__16}
       <section class="nl-ops-card" aria-label="Business overview">
        <div class="nl-ops-title"><h2 class="h5 fw-bold m-0">Business overview</h2><span class="small text-muted">Summary from accessible records</span></div>
        ${requestScope.nlv_Module6_analytics__17}
        ${requestScope.nlv_Module6_analytics__18}
       </section>
       ${requestScope.nlv_Module6_analytics__19}
       <section class="analytics-panel nl-analytics-report" id="sales-trends" data-nl-layout="wide" data-nl-chart-default="bars">

           <div class="panel-heading">

               <div class="section-mark"

                   ></div>

               <div>

                   <h2 class="panel-title">Sales Trend</h2>

                   <div class="panel-caption">

                       FR6.2 · Monthly revenue and sales volume by route, product or customer

                   </div>

               </div>

           </div>

<div class="nl-report-layout-bar">
 <div class="nl-trend-view-picker"><label for="nlTrendBreakdown">Sales trend by</label>
 <select id="nlTrendBreakdown" name="trendBy" form="nlAnalyticsFilters" aria-label="Break down sales trend by route, product or customer">
  <option value="route" ${requestScope.salesTrendRouteSelected}>Route-wise</option>
  <option value="product" ${requestScope.salesTrendProductSelected}>Product-wise</option>
  <option value="customer" ${requestScope.salesTrendCustomerSelected}>Customer-wise</option>
 </select><span>Groups compared with their own previous month</span></div>
 <div class="nl-layout-choice"><label for="nlLayout-sales-trends">Viewing layout</label><select id="nlLayout-sales-trends" data-nl-report-layout="sales-trends" aria-label="Choose table and chart layout"><option value="wide" selected="selected">Wide table + chart below</option><option value="split">Side-by-side</option></select></div></div>
<div class="nl-report-workspace">
<div class="nl-report-table-pane"><div class="nl-report-table-heading"><strong>Detailed records</strong><span>Search and sort rows below • scroll for more</span></div><div id="sales-trends-table" class="table-responsive rounded-3">

               <table class="table table-hover align-middle table-striped analytics-table">

                   <thead class="table-warning">

                       <tr>

                           <th>Month</th>

                           <th>${requestScope.salesTrendFirstLabel}</th>

                           <th>${requestScope.salesTrendSecondLabel}</th>

                           <th>Total Sales (₹)</th>

                           <th title="Total number of product units sold">Units Sold</th>

                           <th title="Percentage change versus the preceding calendar month; a dash means no comparable previous month">Growth (%)</th>

                       </tr>

                   </thead>

                   <tbody>

                       <jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__20" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" />

                   </tbody>

               </table>

           </div></div>
<div class="nl-report-chart" aria-label="Sales by month graph">
 <div class="nl-report-chart-meta"><div class="nl-report-chart-info"><strong>${requestScope.salesTrendTitle} sales trend</strong><span>Revenue and sales quantity month-by-month for the selected categories; Growth compares each category with its preceding month.</span></div><div class="nl-chart-tools"><span class="nl-chart-select-group"><label class="nl-chart-type-label" for="nlSalesMetric">Show metric</label><select id="nlSalesMetric" class="nl-chart-type" data-nl-sales-metric aria-label="Show revenue or sold quantity"><option value="revenue">Revenue (₹)</option><option value="units">Quantity (units)</option></select></span><span class="nl-chart-select-group"><label class="nl-chart-type-label" for="nlStyle-sales-trends">Chart style</label><select class="nl-chart-type" id="nlStyle-sales-trends" data-nl-chart-style="nlAnalyticsSales" aria-label="Choose chart style for Sales Trend"><option value="recommended">Recommended</option><option value="bar">Bars</option><option value="horizontal">Horizontal bars</option><option value="line">Line</option><option value="area">Area</option><option value="pie">Pie</option><option value="doughnut">Doughnut</option></select></span><button type="button" class="btn btn-outline-warning" ${requestScope.nlv_Module6_analytics__21} data-nl-export-chart="nlAnalyticsSales" data-nl-chart-file="nlogistic-sales-trends.png" aria-label="Save Sales by month chart as PNG">Save chart PNG</button></div></div>
 ${requestScope.nlv_Module6_analytics__22}
<p class="nl-chart-context" id="nlChartNote-sales-trends">Pie and doughnut show each category’s share for the selected date range. Charts display the largest six categories plus Other; the table includes all category rows.</p></div>
</div>
<div class="nl-report-bottom"><span>Chart groups the top six categories and Other. Every selected category and its own month-over-month growth remains in the table.</span><a href="#nlAnalyticsQuickAccess">↑ Back to reports</a></div>

       </section>
           <!-- ABC CLASSIFICATION -->

       <section class="analytics-panel nl-analytics-report" id="abc-classification" data-nl-layout="split" data-nl-chart-default="pie">

           <div class="panel-heading">

               <div class="section-mark"

                   ></div>

               <div>

                   <h2 class="panel-title">ABC Classification</h2>

                   <div class="panel-caption">

                       Which products contribute most to stock value

                   </div>

               </div>

           </div>

<div class="nl-report-layout-bar"><span class="nl-report-guide">Compare product value with the cumulative percentage.</span><div class="nl-layout-choice"><label for="nlLayout-abc-classification">Viewing layout</label><select id="nlLayout-abc-classification" data-nl-report-layout="abc-classification" aria-label="Choose table and chart layout"><option value="split" selected="selected">Table + chart</option><option value="wide">Wider table</option></select></div></div>
<div class="nl-report-workspace">
<div class="nl-report-table-pane"><div class="nl-report-table-heading"><strong>Detailed records</strong><span>Search and sort rows below • scroll for more</span></div><div id="abc-classification-table" class="table-responsive rounded-3">

               <table class="table table-hover align-middle table-striped analytics-table">

                   <thead class="table-warning">

                       <tr>

                           <th>Product</th>

                           <th>Annual Value</th>

                           <th>Cumulative (%)</th>

                           <th>ABC Class</th>

                       </tr>

                   </thead>

                   <tbody>

                       <jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__23" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" />

                   </tbody>

               </table>

           </div></div>
<div class="nl-report-chart" aria-label="ABC product mix graph">
 <div class="nl-report-chart-meta"><div class="nl-report-chart-info"><strong>ABC classification — products by class</strong><span>By default, the Pie chart shows the share of products in classes A, B and C.</span></div><div class="nl-chart-tools"><span class="nl-chart-select-group"><label class="nl-chart-type-label" for="nlStyle-abc-classification">Chart style</label><select class="nl-chart-type" id="nlStyle-abc-classification" data-nl-chart-style="nlAnalyticsABC" aria-label="Choose chart style for ABC Classification"><option value="recommended">Recommended</option><option value="bar">Bars</option><option value="horizontal">Horizontal bars</option><option value="line">Line</option><option value="area">Area</option><option value="pie">Pie</option><option value="doughnut">Doughnut</option></select></span><button type="button" class="btn btn-outline-warning" ${requestScope.nlv_Module6_analytics__24} data-nl-export-chart="nlAnalyticsABC" data-nl-chart-file="nlogistic-abc-classification.png" aria-label="Save ABC product mix chart as PNG">Save chart PNG</button></div></div>
 ${requestScope.nlv_Module6_analytics__25}
<p class="nl-chart-context" id="nlChartNote-abc-classification">Default Pie chart shows the number of products in A, B and C. Choose Bars or Line to compare individual product values.</p></div>
</div>
<div class="nl-report-bottom"><span>Charts summarize the same records shown in the table. The table retains all loaded rows.</span><a href="#nlAnalyticsQuickAccess">↑ Back to reports</a></div>

       </section>
           <!-- INVENTORY TURNOVER -->

       <section class="analytics-panel nl-analytics-report" id="inventory-turnover" data-nl-layout="split" data-nl-chart-default="combo">

           <div class="panel-heading">

               <div class="section-mark"

                   ></div>

               <div>

                   <h2 class="panel-title">Inventory Turnover</h2>

                   <div class="panel-caption">

                       How quickly stocked products sell

                   </div>

               </div>

           </div>

<div class="nl-report-layout-bar"><span class="nl-report-guide">How stock cost, average inventory and turnover relate.</span><div class="nl-layout-choice"><label for="nlLayout-inventory-turnover">Viewing layout</label><select id="nlLayout-inventory-turnover" data-nl-report-layout="inventory-turnover" aria-label="Choose table and chart layout"><option value="split" selected="selected">Table + chart</option><option value="wide">Wider table</option></select></div></div>
<div class="nl-report-workspace">
<div class="nl-report-table-pane"><div class="nl-report-table-heading"><strong>Detailed records</strong><span>Search and sort rows below • scroll for more</span></div><div id="inventory-turnover-table" class="table-responsive rounded-3">

               <table class="table table-hover align-middle table-striped analytics-table">

                   <thead class="table-warning">

                       <tr>

                           <th>Product</th>

                           <th>Cost of goods sold</th>

                           <th>Average Inventory</th>

                           <th>Turnover Ratio</th>

                       </tr>

                   </thead>

                   <tbody>

                       <jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__26" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" />

                   </tbody>

               </table>

           </div></div>
<div class="nl-report-chart" aria-label="Stock usage &amp; turnover graph">
 <div class="nl-report-chart-meta"><div class="nl-report-chart-info"><strong>Stock usage &amp; turnover</strong><span>Cost and average inventory; turnover ratio uses the right-hand scale. The chart previews up to 12 records.</span></div><div class="nl-chart-tools"><span class="nl-chart-select-group"><label class="nl-chart-type-label" for="nlStyle-inventory-turnover">Chart style</label><select class="nl-chart-type" id="nlStyle-inventory-turnover" data-nl-chart-style="nlAnalyticsInventory" aria-label="Choose chart style for Inventory Turnover"><option value="recommended">Recommended</option><option value="bar">Bars</option><option value="horizontal">Horizontal bars</option><option value="line">Line</option><option value="area">Area</option><option value="pie">Pie</option><option value="doughnut">Doughnut</option></select></span><button type="button" class="btn btn-outline-warning" ${requestScope.nlv_Module6_analytics__27} data-nl-export-chart="nlAnalyticsInventory" data-nl-chart-file="nlogistic-inventory-turnover.png" aria-label="Save Stock usage &amp; turnover chart as PNG">Save chart PNG</button></div></div>
 ${requestScope.nlv_Module6_analytics__28}
<p class="nl-chart-context" id="nlChartNote-inventory-turnover">Pie and doughnut show average inventory by product only; they cannot represent turnover ratios.</p></div>
</div>
<div class="nl-report-bottom"><span>Charts summarize the same records shown in the table. The table retains all loaded rows.</span><a href="#nlAnalyticsQuickAccess">↑ Back to reports</a></div>

       </section>

       <!-- PROFITABILITY -->

       <section class="analytics-panel nl-analytics-report" id="profitability" data-nl-layout="split" data-nl-chart-default="horizontal">

           <div class="panel-heading">

               <div class="section-mark"

                   ></div>

               <div>

                   <h2 class="panel-title">Profitability</h2>

                   <div class="panel-caption">

                       Which products contribute most profit

                   </div>

               </div>

           </div>

<div class="nl-report-layout-bar"><span class="nl-report-guide">Compare product profit (revenue minus cost).</span><div class="nl-layout-choice"><label for="nlLayout-profitability">Viewing layout</label><select id="nlLayout-profitability" data-nl-report-layout="profitability" aria-label="Choose table and chart layout"><option value="split" selected="selected">Table + chart</option><option value="wide">Wider table</option></select></div></div>
<div class="nl-report-workspace">
<div class="nl-report-table-pane"><div class="nl-report-table-heading"><strong>Detailed records</strong><span>Search and sort rows below • scroll for more</span></div><div id="profitability-table" class="table-responsive rounded-3">

               <table class="table table-hover align-middle table-striped analytics-table">

                   <thead class="table-warning">

                       <tr>

                           <th>Product</th>

                           <th>Month</th>

                           <th>Revenue</th>

                           <th>Cost</th>

                           <th>Margin (%)</th>

                       </tr>

                   </thead>

                   <tbody>

                       <jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__29" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" />

                   </tbody>

               </table>

           </div></div>
<div class="nl-report-chart" aria-label="Revenue, cost &amp; margin graph">
 <div class="nl-report-chart-meta"><div class="nl-report-chart-info"><strong>Profit by product</strong><span>Products ordered as recorded; recommended chart compares revenue minus cost. Up to 12 records.</span></div><div class="nl-chart-tools"><span class="nl-chart-select-group"><label class="nl-chart-type-label" for="nlStyle-profitability">Chart style</label><select class="nl-chart-type" id="nlStyle-profitability" data-nl-chart-style="nlAnalyticsProductProfit" aria-label="Choose chart style for Product Profitability"><option value="recommended">Recommended</option><option value="bar">Bars</option><option value="horizontal">Horizontal bars</option><option value="line">Line</option><option value="area">Area</option><option value="pie">Pie</option><option value="doughnut">Doughnut</option></select></span><button type="button" class="btn btn-outline-warning" ${requestScope.nlv_Module6_analytics__30} data-nl-export-chart="nlAnalyticsProductProfit" data-nl-chart-file="nlogistic-profitability.png" aria-label="Save Revenue, cost &amp; margin chart as PNG">Save chart PNG</button></div></div>
 ${requestScope.nlv_Module6_analytics__31}
<p class="nl-chart-context" id="nlChartNote-profitability">The recommended view shows profit per product. Pie and doughnut show revenue only, not margins.</p></div>
</div>
<div class="nl-report-bottom"><span>Charts summarize the same records shown in the table. The table retains all loaded rows.</span><a href="#nlAnalyticsQuickAccess">↑ Back to reports</a></div>

       </section>

       <!-- DEMAND FORECAST -->

       <section class="analytics-panel nl-analytics-report" id="demand-forecast" data-nl-layout="wide" data-nl-chart-default="bars">

           <div class="panel-heading">

               <div class="section-mark"

                   ></div>

               <div>

                   <h2 class="panel-title">Demand Forecast</h2>

                   <div class="panel-caption">

                       Predicted bookings and suggested pricing multiplier

                   </div>

               </div>

           </div>

<div class="nl-report-layout-bar"><span class="nl-report-guide">Estimated bookings by route and month.</span><div class="nl-layout-choice"><label for="nlLayout-demand-forecast">Viewing layout</label><select id="nlLayout-demand-forecast" data-nl-report-layout="demand-forecast" aria-label="Choose table and chart layout"><option value="split">Table + chart</option><option value="wide" selected="selected">Wider table</option></select></div></div>
<div class="nl-report-workspace">
<div class="nl-report-table-pane"><div class="nl-report-table-heading"><strong>Detailed records</strong><span>Search and sort rows below • scroll for more</span></div><div id="demand-forecast-table" class="table-responsive rounded-3">

               <table class="table table-hover align-middle table-striped analytics-table">

                   <thead class="table-warning">

                       <tr>

                           <th>From port</th>

                           <th>To port</th>

                           <th>Container</th>

                           <th>Month</th>

                           <th>Predicted Bookings</th>

                           <th>Confidence (%)</th>

                           <th>Multiplier</th>

                       </tr>

                   </thead>

                   <tbody>

                       <jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__32" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" />

                   </tbody>

               </table>

           </div></div>
<div class="nl-report-chart" aria-label="Expected bookings by route graph">
 <div class="nl-report-chart-meta"><div class="nl-report-chart-info"><strong>Expected bookings by route</strong><span>Forecast records, not guaranteed bookings. The chart previews up to 12 records.</span></div><div class="nl-chart-tools"><span class="nl-chart-select-group"><label class="nl-chart-type-label" for="nlStyle-demand-forecast">Chart style</label><select class="nl-chart-type" id="nlStyle-demand-forecast" data-nl-chart-style="nlAnalyticsForecast" aria-label="Choose chart style for Demand Forecast"><option value="recommended">Recommended</option><option value="bar">Bars</option><option value="horizontal">Horizontal bars</option><option value="line">Line</option><option value="area">Area</option><option value="pie">Pie</option><option value="doughnut">Doughnut</option></select></span><button type="button" class="btn btn-outline-warning" ${requestScope.nlv_Module6_analytics__33} data-nl-export-chart="nlAnalyticsForecast" data-nl-chart-file="nlogistic-demand-forecast.png" aria-label="Save Expected bookings by route chart as PNG">Save chart PNG</button></div></div>
 ${requestScope.nlv_Module6_analytics__34}
<p class="nl-chart-context" id="nlChartNote-demand-forecast">Pie and doughnut show each forecast record’s share of estimated bookings. Forecasts are not guaranteed demand.</p></div>
</div>
<div class="nl-report-bottom"><span>Charts summarize the same records shown in the table. The table retains all loaded rows.</span><a href="#nlAnalyticsQuickAccess">↑ Back to reports</a></div>

       </section>

       <!-- PROFIT AND LOSS -->

       <section class="analytics-panel nl-analytics-report" id="profit-loss" data-nl-layout="wide" data-nl-chart-default="combo">

           <div class="panel-heading">

               <div class="section-mark"

                   ></div>

               <div>

                   <h2 class="panel-title">Profit &amp; Loss</h2>

                   <div class="panel-caption">

                       Shipment-wise financial performance

                   </div>

               </div>

           </div>

<div class="nl-report-layout-bar"><span class="nl-report-guide">Compare revenue, costs and remaining profit.</span><div class="nl-layout-choice"><label for="nlLayout-profit-loss">Viewing layout</label><select id="nlLayout-profit-loss" data-nl-report-layout="profit-loss" aria-label="Choose table and chart layout"><option value="split">Table + chart</option><option value="wide" selected="selected">Wider table</option></select></div></div>
<div class="nl-report-workspace">
<div class="nl-report-table-pane"><div class="nl-report-table-heading"><strong>Detailed records</strong><span>Search and sort rows below • scroll for more</span></div><div id="profit-loss-table" class="table-responsive rounded-3">

               <table class="table table-hover align-middle table-striped analytics-table">

                   <thead class="table-warning">

                       <tr>

                           <th>Shipment ID</th>

                           <th>Seller ID</th>

                           <th>Revenue</th>

                           <th>Freight Cost</th>

                           <th>Port Cost</th>

                           <th>Handling Cost</th>

                           <th>Claim Loss</th>

                           <th>Net Profit</th>

                       </tr>

                   </thead>

                   <tbody>

                       <jsp:setProperty name="nlViewSupport_Module6_analytics" property="fragment" value="nlv_Module6_analytics__35" /><jsp:getProperty name="nlViewSupport_Module6_analytics" property="fragment" />

                   </tbody>

               </table>

           </div></div>
<div class="nl-report-chart" aria-label="Monthly revenue, costs &amp; profit graph">
 <div class="nl-report-chart-meta"><div class="nl-report-chart-info"><strong>Monthly revenue, costs &amp; profit</strong><span>Monthly revenue, costs and net profit. The table includes the shipment details.</span></div><div class="nl-chart-tools"><span class="nl-chart-select-group"><label class="nl-chart-type-label" for="nlStyle-profit-loss">Chart style</label><select class="nl-chart-type" id="nlStyle-profit-loss" data-nl-chart-style="nlAnalyticsProfit" aria-label="Choose chart style for Profit & Loss"><option value="recommended">Recommended</option><option value="bar">Bars</option><option value="horizontal">Horizontal bars</option><option value="line">Line</option><option value="area">Area</option><option value="pie">Pie</option><option value="doughnut">Doughnut</option></select></span><button type="button" class="btn btn-outline-warning" ${requestScope.nlv_Module6_analytics__36} data-nl-export-chart="nlAnalyticsProfit" data-nl-chart-file="nlogistic-profit-loss.png" aria-label="Save Monthly revenue, costs &amp; profit chart as PNG">Save chart PNG</button></div></div>
 ${requestScope.nlv_Module6_analytics__37}
<p class="nl-chart-context" id="nlChartNote-profit-loss">Pie and doughnut show positive revenue by month only; costs and losses are excluded from those views.</p></div>
</div>
<div class="nl-report-bottom"><span>Charts summarize the same records shown in the table. The table retains all loaded rows.</span><a href="#nlAnalyticsQuickAccess">↑ Back to reports</a></div>

       </section>

       <!-- FOOTER -->

       <footer class="page-footer">

           <span>N-LOGISTIC &nbsp; • &nbsp; Business Analytics</span>

           <span>Analytics Dashboard</span>

       </footer>

</div>

<!-- Six format-switching Chart.js visualizations use the same authorized report data as their tables. -->





<%-- End the common N-LOGISTIC layout --%>

<jsp:include page="/WEB-INF/views/shared/footer.jsp"/>

</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>

<script type="application/json" id="nlSalesChartData">${requestScope.nlv_Module6_analytics__38}</script>
<script type="application/json" id="nlABCChartData">${requestScope.nlv_Module6_analytics__39}</script>
<script type="application/json" id="nlProfitChartData">${requestScope.nlv_Module6_analytics__40}</script>
<script type="application/json" id="nlInventoryChartData">${requestScope.nlv_Module6_analytics__41}</script>
<script type="application/json" id="nlProductProfitChartData">${requestScope.nlv_Module6_analytics__42}</script>
<script type="application/json" id="nlForecastChartData">${requestScope.nlv_Module6_analytics__43}</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
<script>
(function(){
 'use strict';
 var orange='#c94c0b',amber='#efa15a',brown='#804521',sage='#5f8d73',blue='#6794a1',grid='#f2e6dc';
 var charts={},notes={};
 var defs=[
   {id:'nlAnalyticsSales',section:'sales-trends',dataId:'nlSalesChartData',kind:'sales',recommended:'bar'},
   {id:'nlAnalyticsABC',section:'abc-classification',dataId:'nlABCChartData',kind:'abc',recommended:'pie'},
   {id:'nlAnalyticsInventory',section:'inventory-turnover',dataId:'nlInventoryChartData',kind:'inventory',recommended:'combo'},
   {id:'nlAnalyticsProductProfit',section:'profitability',dataId:'nlProductProfitChartData',kind:'product',recommended:'horizontal'},
   {id:'nlAnalyticsForecast',section:'demand-forecast',dataId:'nlForecastChartData',kind:'forecast',recommended:'bar'},
   {id:'nlAnalyticsProfit',section:'profit-loss',dataId:'nlProfitChartData',kind:'profit',recommended:'combo'}
 ];
 function one(s,root){return (root||document).querySelector(s);}
 function all(s,root){return Array.prototype.slice.call((root||document).querySelectorAll(s));}
 function readData(id){var el=document.getElementById(id);if(!el)return null;try{return JSON.parse(el.textContent);}catch(ex){return null;}}
 function number(v){return Number.isFinite(Number(v))?Number(v):0;}
 function money(v){return '₹'+new Intl.NumberFormat('en-IN',{maximumFractionDigits:2}).format(number(v));}
 function num(v){return new Intl.NumberFormat('en-IN',{maximumFractionDigits:2}).format(number(v));}
 function compact(v){var n=number(v),abs=Math.abs(n);if(abs>=10000000)return '₹'+(n/10000000).toFixed(1)+'Cr';if(abs>=100000)return '₹'+(n/100000).toFixed(1)+'L';if(abs>=1000)return '₹'+(n/1000).toFixed(0)+'k';return money(n);}
 function trimLabel(value){var s=String(value==null?'':value);return s.length>21?s.slice(0,20)+'…':s;}
 function base(monetary){return {responsive:true,maintainAspectRatio:false,animation:{duration:window.matchMedia('(prefers-reduced-motion: reduce)').matches?0:300},interaction:{mode:'index',intersect:false},plugins:{legend:{position:'bottom',labels:{boxWidth:11,color:'#674b39',font:{size:11}}},tooltip:{callbacks:{label:function(ctx){var v=ctx.chart.options.indexAxis==='y'?ctx.parsed.x:ctx.parsed.y;return ctx.dataset.label+': '+(monetary?money(v):num(v));}}}},scales:{x:{grid:{display:false},ticks:{color:'#775a49',callback:function(i){return trimLabel(this.getLabelForValue(i));},maxRotation:35}},y:{beginAtZero:true,grid:{color:grid},ticks:{color:'#775a49',callback:monetary?compact:undefined}}}};}
 function barSet(label,values,color){return {label:label,data:values,backgroundColor:color,borderColor:color,borderRadius:5,maxBarThickness:40};}
 function lineSet(label,values,color){return {label:label,data:values,borderColor:color,backgroundColor:color,borderWidth:2.6,pointRadius:3,pointHoverRadius:5,tension:.24,fill:false};}
 function note(def,msg){var el=one('#nlChartNote-'+def.section);if(el)el.textContent=msg;}
 function status(def,msg){var fb=one('[data-nl-fallback-for="'+def.id+'"]');if(fb){fb.textContent=msg;fb.hidden=false;}var canvas=document.getElementById(def.id);if(canvas)canvas.style.display='none';}
 function readChoice(def){var el=one('[data-nl-chart-style="'+def.id+'"]');return el?el.value:'recommended';}
 function chartHelp(mode,def){
   var how={recommended:'Recommended for this report: compare the bars and lines using the legend and hover over a point for exact values.',bar:'Bars compare different items or months. Taller bars mean a larger value.',horizontal:'Horizontal bars compare categories; longer bars mean a larger value, and long product names are easier to read.',line:'Lines connect values in table order. Use this to see a trend; gaps do not necessarily represent missing dates.',area:'Filled lines show a trend and emphasize magnitude. Compare the legend; areas are not necessarily additive.',pie:'Pie slices show parts of one positive total only. Larger slices contribute more; costs, negative profits and ratios may be excluded.',doughnut:'Doughnut slices show each category’s share of one positive total. Use the table for other financial measures.'};
   var unit=def.kind==='forecast'?'Bookings are estimates, not guaranteed demand.':def.kind==='abc'?'The ABC table shows the individual annual values and cumulative percent.':def.kind==='profit'?'Always compare revenue, cost and profit in the table.':def.kind==='inventory'?'Turnover ratio is not a currency value.':def.kind==='product'?'Profit may be negative; circle formats display revenue instead.':'Values come from the existing report, not sample data.';
   return 'How to read: '+(how[mode]||how.recommended)+' '+unit;
 }

 function prefKey(def,kind){return 'nl.analytics.'+(def.section==='sales-trends'&&kind==='layout'?'v2032':'v10')+'.'+kind+'.'+def.section;}
 function getPrefs(def,kind){try{return window.sessionStorage.getItem(prefKey(def,kind));}catch(e){return null;}}
 function setPrefs(def,kind,value){try{window.sessionStorage.setItem(prefKey(def,kind),value);}catch(e){/* persistence is optional */}}
 function values(arr){return (arr||[]).map(number);}
 function mainConfig(def,mode){
   var data=readData(def.dataId);
   if(!data||!Array.isArray(data.labels)||!data.labels.length)return null;
   var labels=data.labels.slice(),items=[],primary=[],name='',baseMoney=true,options=base(true),special=false;
   if(def.kind==='sales'){
     var metricEl=document.getElementById('nlSalesMetric');
     var metric=metricEl&&metricEl.value==='units'?'units':'revenue';
     var byUnits=metric==='units',groups=Array.isArray(data.groups)?data.groups:[];
     baseMoney=!byUnits;options=base(!byUnits);
     name=byUnits?'Sold quantity (units)':'Recorded sales (₹)';
     primary=values(byUnits?data.volumes:data.values);
     var colours=[orange,amber,brown,sage,blue,'#a9678d','#8a785e'];
     items=groups.map(function(group,i){return barSet(group.label,values(byUnits?group.units:group.revenue),colours[i%colours.length]);});
     if(!items.length)items=[barSet(name,primary,orange)];
     if(mode==='pie'||mode==='doughnut'){
       var totalGroups=groups.map(function(group,i){return {label:group.label,value:values(byUnits?group.units:group.revenue).reduce(function(a,b){return a+b;},0),color:colours[i%colours.length]};}).filter(function(x){return x.value>0;});
       if(!totalGroups.length)return {error:'No positive sales data is available for this chart.'};
       return {config:{type:mode,data:{labels:totalGroups.map(function(x){return x.label;}),datasets:[{label:name,data:totalGroups.map(function(x){return x.value;}),backgroundColor:totalGroups.map(function(x){return x.color;}),borderColor:'#fff',borderWidth:2,hoverOffset:6}]},options:{responsive:true,maintainAspectRatio:false,plugins:{legend:{position:'bottom',labels:{boxWidth:11}},tooltip:{callbacks:{label:function(c){return c.label+': '+(byUnits?num(c.parsed)+' units':money(c.parsed));}}}}}},description:'Share of '+(byUnits?'sold quantity':'recorded revenue')+' by category across the selected months. The table includes all categories.'};
     }
     if(mode==='recommended'||mode==='bar'){
       options.scales.x.stacked=true;options.scales.y.stacked=true;
     }
   }else if(def.kind==='abc'){
     var classValues=values(data.values),classNames=(data.labels||[]).map(function(k){return 'Class '+k;});
     if(mode==='pie'||mode==='doughnut'){
       var filtered=classValues.map(function(v,i){return {name:classNames[i],value:v};}).filter(function(x){return x.value>0;});
       if(!filtered.length)return {error:'No class counts available for a pie chart. Choose Recommended instead.'};
       return {config:{type:mode,data:{labels:filtered.map(function(x){return x.name;}),datasets:[{label:'Products',data:filtered.map(function(x){return x.value;}),backgroundColor:[orange,amber,brown],borderColor:'#fff',borderWidth:3,hoverOffset:9}]},options:{responsive:true,maintainAspectRatio:false,cutout:mode==='doughnut'?'59%':0,plugins:{legend:{position:'bottom',labels:{boxWidth:12}},tooltip:{callbacks:{label:function(c){return c.label+': '+num(c.parsed)+' products';}}}}}},description:'Showing the number of products classified A, B and C. The table explains each product.'};
     }
     labels=data.products||[];primary=values(data.annualValues);baseMoney=true;name='Annual product value';
     if(!labels.length)return null;
     var cls=data.classes||[];
     items=[barSet(name,primary,cls.map(function(k){return k==='A'?orange:k==='B'?amber:brown;}))];
     if(mode==='recommended'){
       var cumulative=values(data.cumulative);
       options.scales.yPct={type:'linear',position:'right',min:0,max:100,grid:{drawOnChartArea:false},ticks:{callback:function(v){return v+'%';}}};
       var pareto=lineSet('Cumulative share (%)',cumulative,sage);pareto.type='line';pareto.yAxisID='yPct';items.push(pareto);special=true;
       options.plugins.tooltip={callbacks:{label:function(c){return c.dataset.label+': '+(c.dataset.yAxisID==='yPct'?num(c.parsed.y)+'%':money(c.parsed.y));}}};
     }
   }else if(def.kind==='inventory'){
     labels=data.labels;primary=values(data.cogs);name='Cost of goods';items=[barSet(name,primary,orange),barSet('Average stock value',values(data.average),amber)];
     if(mode==='recommended'){
       options.scales.yRatio={type:'linear',position:'right',beginAtZero:true,grid:{drawOnChartArea:false},ticks:{callback:function(v){return num(v)+'×';}}};
       var ratio=lineSet('Turnover ratio',values(data.ratio),brown);ratio.type='line';ratio.yAxisID='yRatio';items.push(ratio);special=true;
       options.plugins.tooltip={callbacks:{label:function(c){return c.dataset.label+': '+(c.dataset.yAxisID==='yRatio'?num(c.parsed.y)+'×':money(c.parsed.y));}}};
     }
   }else if(def.kind==='product'){
     labels=data.labels;var rev=values(data.revenue),cost=values(data.cost),net=rev.map(function(v,i){return v-cost[i];});
     primary=net;name='Profit';items=[barSet('Revenue',rev,orange),barSet('Cost',cost,amber),barSet('Profit',net,sage)];
     if(mode==='recommended'){items=[barSet('Profit (revenue − cost)',net,net.map(function(v){return v>=0?orange:'#bd6d66';}))];}
   }else if(def.kind==='forecast'){
     labels=data.labels;primary=values(data.bookings);name='Expected bookings';baseMoney=false;options=base(false);items=[barSet(name,primary,orange)];
     options.plugins.tooltip={callbacks:{label:function(c){return 'Estimated bookings: '+num(c.parsed.y);},afterLabel:function(c){var parts=[],i=c.dataIndex;if(data.confidence&&data.confidence[i]!==null&&data.confidence[i]!==undefined)parts.push('Recorded confidence: '+num(data.confidence[i])+'%');if(data.multiplier&&data.multiplier[i]!==null&&data.multiplier[i]!==undefined)parts.push('Suggested rate factor: '+num(data.multiplier[i])+'×');return parts.join(' · ');}}};
   }else if(def.kind==='profit'){
     labels=data.labels;primary=values(data.revenue);name='Revenue';items=[barSet('Revenue',primary,orange),barSet('Costs and settled claims',values(data.cost),amber),barSet('Net profit',values(data.profit),sage)];
     if(mode==='recommended'){items[2].type='line';items[2].borderWidth=3;items[2].pointRadius=4;items[2].tension=.23;special=true;}
   }
   if(mode==='pie'||mode==='doughnut'){
     // A circle represents ONE nonnegative measure, never mixed units or negative profit.
     var circleValues=def.kind==='inventory'?values(data.average):def.kind==='product'?values(data.revenue):def.kind==='profit'?values(data.revenue):primary;
     var circleLabel=def.kind==='inventory'?'Average stock value':def.kind==='product'?'Revenue':def.kind==='profit'?'Revenue':name;
     var points=labels.map(function(x,i){return {label:x,value:circleValues[i]};}).filter(function(x){return Number.isFinite(x.value)&&x.value>0;});
     if(!points.length)return {error:'A pie/doughnut needs positive values. Choose Bars, Line or Recommended instead.'};
     var palette=[orange,amber,brown,sage,blue,'#cb8568','#cda954','#836651','#e3b083','#a86437'];
     return {config:{type:mode,data:{labels:points.map(function(x){return x.label;}),datasets:[{label:circleLabel,data:points.map(function(x){return x.value;}),backgroundColor:points.map(function(_,i){return palette[i%palette.length];}),borderColor:'#fff',borderWidth:2,hoverOffset:5}]},options:{responsive:true,maintainAspectRatio:false,cutout:mode==='doughnut'?'57%':0,plugins:{legend:{position:'bottom',labels:{boxWidth:10,font:{size:10},generateLabels:function(chart){var defaults=Chart.defaults.plugins.legend.labels.generateLabels(chart);return defaults.map(function(x){x.text=trimLabel(x.text);return x;});}}},tooltip:{callbacks:{label:function(c){return c.label+': '+(baseMoney?money(c.parsed):num(c.parsed));}}}}}},description:'Showing '+circleLabel.toLowerCase()+' only (positive values). Other measures remain in the table.'};
   }
   var type='bar';
   if(mode==='horizontal'){
     type='bar';options.indexAxis='y';options.scales.x.ticks.callback=baseMoney?compact:undefined;options.scales.y.grid.display=false;
     options.scales.x.grid.color=grid;options.scales.y.ticks.callback=function(v){return trimLabel(this.getLabelForValue(v));};
     if(def.kind==='abc')items[0].backgroundColor=(data.classes||[]).map(function(k){return k==='A'?orange:k==='B'?amber:brown;});
   }else if(mode==='line'||mode==='area'){
     type='line';items=items.map(function(item,i){var ln=lineSet(item.label,item.data,item.borderColor||[orange,amber,sage][i%3]);ln.fill=mode==='area';if(mode==='area')ln.backgroundColor=[orange+'33',amber+'33',sage+'33'][i%3];return ln;});
   }else if(mode==='bar'||mode==='recommended'){
     type='bar';
   }
   if(mode==='recommended'&&def.kind==='product'){options.indexAxis='y';options.scales.x.ticks.callback=compact;options.scales.y.ticks.callback=function(v){return trimLabel(this.getLabelForValue(v));};}
   // Alternate common-axis views drop incompatible ratio and percentage measures.
   var description='Chart shows actual report values. Hover over a point to see its exact number.';
   if(def.kind==='abc')description=mode==='recommended'?'Recommended Pareto view: bars show annual product value, line shows cumulative share (%) on the right axis.':'Shows annual value for each product; A, B and C classes are colour-coded.';
   if(def.kind==='inventory'&&mode!=='recommended')description='Showing inventory monetary values; turnover ratios remain visible in the table and the Recommended combo chart.';
   if(def.kind==='product'&&mode==='recommended')description='Profit is calculated as displayed revenue minus displayed cost. Negative values indicate a loss.';
   if(def.kind==='forecast')description='These are recorded demand estimates, not confirmed bookings or guaranteed ML predictions.';
   if(def.kind==='profit'&&mode==='recommended')description='Orange bars: revenue; amber bars: costs; green line: net profit.';
   if(def.kind==='sales')description='Each series represents the selected route, product or customer. The six largest categories are shown individually; Other combines the rest. Switch the metric to view sold quantity.';
   return {config:{type:type,data:{labels:labels,datasets:items},options:options},description:description};
 }
 function updateChart(def){
   var el=document.getElementById(def.id),choice=one('[data-nl-chart-style="'+def.id+'"]'),mode=readChoice(def);if(def.kind==='abc'&&mode==='recommended')mode='pie';var spec=mainConfig(def,mode);
   if(charts[def.id]){charts[def.id].destroy();delete charts[def.id];}
   if(!el)return;
   var fallback=one('[data-nl-fallback-for="'+def.id+'"]');if(fallback)fallback.hidden=true;
   el.style.display='block';
   if(typeof Chart==='undefined'){status(def,'Charts need Chart.js to load. The original data table still works.');return;}
   if(!spec){status(def,'No chartable records for this report. You can still read its table.');return;}
   if(spec.error){status(def,spec.error);note(def,spec.error);return;}
   note(def,spec.description+"  "+chartHelp(mode,def));
   try{charts[def.id]=new Chart(el,spec.config);}catch(e){status(def,'This chart format could not be shown. Choose Recommended or read the report table.');}
   if(choice){choice.setAttribute('aria-description',spec.description);}
 }
 function restore(){
   var metric=document.getElementById('nlSalesMetric');
   if(metric){var savedMetric;try{savedMetric=window.sessionStorage.getItem('nl.analytics.v2031.salesMetric');}catch(e){}
     if(savedMetric==='units'||savedMetric==='revenue')metric.value=savedMetric;
     metric.addEventListener('change',function(){try{window.sessionStorage.setItem('nl.analytics.v2031.salesMetric',metric.value);}catch(e){}updateChart(defs[0]);});
   }
   var breakdown=document.getElementById('nlTrendBreakdown');
   if(breakdown)breakdown.addEventListener('change',function(){var f=document.getElementById('nlAnalyticsFilters');if(f){f.action=f.action.split('#')[0]+'#sales-trends';if(f.requestSubmit)f.requestSubmit();else f.submit();}});
   defs.forEach(function(def){var style=one('[data-nl-chart-style="'+def.id+'"]');if(style){var saved=getPrefs(def,'style');if(saved&&all('option',style).some(function(o){return o.value===saved;}))style.value=saved;style.addEventListener('change',function(){setPrefs(def,'style',style.value);updateChart(def);});}
   var layout=one('[data-nl-report-layout="'+def.section+'"]'),section=document.getElementById(def.section);
   if(layout&&section){var savedLayout=getPrefs(def,'layout');if(savedLayout==='wide'||savedLayout==='split'){layout.value=savedLayout;section.dataset.nlLayout=savedLayout;}
     layout.addEventListener('change',function(){section.dataset.nlLayout=layout.value;setPrefs(def,'layout',layout.value);if(charts[def.id])requestAnimationFrame(function(){charts[def.id].resize();});});}
   updateChart(def);
   var toolbar=one('.nl-chart-tools',section);
   if(toolbar&&section){var expand=document.createElement('button');expand.type='button';expand.className='btn btn-outline-secondary';expand.setAttribute('data-nl-inline-expand','true');expand.textContent='Expand chart';expand.setAttribute('aria-pressed','false');expand.setAttribute('aria-label','Expand chart for '+section.querySelector('.panel-title').textContent.trim());toolbar.appendChild(expand);
     expand.addEventListener('click',function(){var active=section.classList.toggle('nl-chart-expanded');expand.textContent=active?'Normal view':'Expand chart';expand.setAttribute('aria-pressed',String(active));if(charts[def.id])setTimeout(function(){charts[def.id].resize();},10);});}
 });}
 // PNG export uses a fresh, fixed-size Chart.js canvas: no clipped modal viewport,
 // transparent background, CSS stretching or low-resolution on-screen scaling.
 // Export a print-ready business report image, including a chart plus useful report context.
 function exportChartPng(def,fileName,button){
   if(typeof Chart==='undefined')return false;
   var mode=readChoice(def);if(def.kind==='abc'&&mode==='recommended')mode='pie';
   var spec=mainConfig(def,mode);if(!spec||spec.error)return false;
   var section=document.getElementById(def.section);
   var title=section?.querySelector('.nl-report-chart-info strong')?.textContent.trim()||'N-LOGISTIC Analytics';
   var subtitle=section?.querySelector('.nl-report-chart-info span')?.textContent.trim()||'Business performance report';
   var width=2200,height=1640;
   var finalCanvas=document.createElement('canvas');finalCanvas.width=width;finalCanvas.height=height;
   var out=finalCanvas.getContext('2d');if(!out)return false;
   function text(str,x,y,sz,color,weight,align){out.fillStyle=color||'#3b2b23';out.font=(weight||'500')+' '+sz+'px Arial, sans-serif';out.textAlign=align||'left';out.fillText(String(str==null?'':str),x,y);out.textAlign='left';}
   function paragraph(value,x,y,maxWidth,lineHeight,maxLines,sz,color){
     out.font='500 '+sz+'px Arial, sans-serif';
     var words=String(value||'').split(/\s+/),line='',count=0;
     words.forEach(function(word){
       var next=line?line+' '+word:word;
       if(out.measureText(next).width>maxWidth && line){
         if(count<maxLines)text(line,x,y+(count*lineHeight),sz,color,'500');
         count++;line=word;
       }else line=next;
     });
     if(count<maxLines&&line)text(line,x,y+(count*lineHeight),sz,color,'500');
   }
   function roundedCard(x,y,w,h){out.fillStyle='#fff8f1';out.strokeStyle='#edd4bf';out.lineWidth=2;out.beginPath();out.roundRect(x,y,w,h,16);out.fill();out.stroke();}
   function statCard(x,label,value){roundedCard(x,1174,620,129);text(label.toUpperCase(),x+25,1214,19,'#906a51','700');text(String(value).slice(0,32),x+25,1264,32,'#ad4a18','800');}
   function readableNumber(n){return typeof n==='number'&&isFinite(n)?new Intl.NumberFormat('en-IN',{maximumFractionDigits:2}).format(n):'—';}
   out.fillStyle='#ffffff';out.fillRect(0,0,width,height);
   out.fillStyle='#fff2e7';out.fillRect(0,0,width,196);
   out.fillStyle='#ce5818';out.fillRect(0,0,width,13);
   text('N-LOGISTIC  /  ANALYTICS REPORT',105,61,24,'#b84d17','800');
   text(title.slice(0,77),105,120,45,'#35261e','800');
   paragraph(subtitle,105,158,1900,31,1,24,'#755a49');
   text('Generated '+new Date().toLocaleString('en-IN',{dateStyle:'medium',timeStyle:'short'}),2092,59,21,'#9a623f','600','right');
   var exportCanvas=document.createElement('canvas');exportCanvas.width=1985;exportCanvas.height=890;
   exportCanvas.style.cssText='position:fixed;left:-10000px;top:0;width:1985px;height:890px;pointer-events:none;';
   document.body.appendChild(exportCanvas);
   var render=null;
   try{
     var cfg=spec.config,options=cfg.options||{};
     var sourcePlugins=options.plugins||{},sourceLegend=sourcePlugins.legend||{};
     var exportLegend=Object.assign({},sourceLegend,{labels:Object.assign({},sourceLegend.labels||{},{font:{size:18,weight:'600'},color:'#574131',boxWidth:19,padding:20})});
     var exportOptions=Object.assign({},options,{
       responsive:false,maintainAspectRatio:false,animation:false,devicePixelRatio:1,
       layout:{padding:{top:28,bottom:18,left:25,right:28}},
       plugins:Object.assign({},sourcePlugins,{legend:exportLegend})
     });
     if(options.scales){
       exportOptions.scales={};
       Object.keys(options.scales).forEach(function(key){
         var axis=options.scales[key],ticks=axis.ticks||{};
         exportOptions.scales[key]=Object.assign({},axis,{ticks:Object.assign({},ticks,{font:{size:16},color:'#654b3a',padding:8})});
       });
     }
     render=new Chart(exportCanvas.getContext('2d'),{type:cfg.type,data:cfg.data,options:exportOptions});
     render.update('none');
     out.drawImage(exportCanvas,105,227,1985,890);
     out.fillStyle='#ecd8c4';out.fillRect(105,1130,1985,2);
     var labels=Array.isArray(cfg.data.labels)?cfg.data.labels:[],datasets=Array.isArray(cfg.data.datasets)?cfg.data.datasets:[];
     var first=datasets[0],numeric=[];
     if(first&&Array.isArray(first.data))first.data.forEach(function(value,index){
       var n=typeof value==='number'?value:(value&&typeof value==='object'?Number(value.y==null?value.x:value.y):Number(value));
       if(isFinite(n))numeric.push({value:n,label:String(labels[index]||('Record '+(index+1)))});
     });
     var high=numeric.length?numeric.reduce(function(a,b){return a.value>=b.value?a:b;}):null;
     var chartName=(mode==='recommended'?'Recommended':mode.charAt(0).toUpperCase()+mode.slice(1));
     statCard(105,'Records shown',labels.length+' categories');
     statCard(789,'Chart series',datasets.length+' series');
     statCard(1473,'Highest value in first series',high?readableNumber(high.value):'No numerical data');
     text('REPORT CONTEXT',105,1364,21,'#b24c1c','800');
     var params=new URLSearchParams(location.search),filters=[];
     [['From','fromDate','startDate'],['To','toDate','endDate'],['Seller','sellerId','companyId'],['Origin','originPortId','origin_port_id'],['Destination','destPortId','destinationPortId']].forEach(function(group){
       var value=params.get(group[1])||params.get(group[2]);
       if(!value){var name=group[1];var field=document.querySelector('[name="'+name+'"]');if(field&&field.value)value=field.value;}
       if(value)filters.push(group[0]+': '+value);
     });
     var coverage=filters.length?filters.join('     |     '):'All currently loaded records (no explicit report filters)';
     paragraph('Filters: '+coverage,105,1402,1940,31,2,23,'#634a3b');
     var names=datasets.map(function(x){return x.label||'Unnamed series';}).slice(0,7).join('  /  ');
     paragraph('Series: '+(names||'No series available'),105,1470,1940,29,2,22,'#725848');
     if(high)paragraph('Peak first-series category: '+high.label+' ('+readableNumber(high.value)+'). This summary is based on the displayed records.',105,1534,1940,27,1,21,'#795f51');
     text('Chart: '+chartName+'    •    N-LOGISTIC Import & Export Management',105,1606,20,'#a45b33','650');
     text('Export reflects the loaded report and selected view; figures are not a payment receipt.',2090,1606,19,'#856858','500','right');
     var link=document.createElement('a');link.href=finalCanvas.toDataURL('image/png');link.download=fileName||'nlogistic-analytics.png';
     document.body.appendChild(link);link.click();link.remove();
     return true;
   }finally{if(render)render.destroy();exportCanvas.remove();}
 }
 document.addEventListener('click',function(ev){var btn=ev.target.closest('[data-nl-export-chart]');if(!btn)return;
   var id=btn.getAttribute('data-nl-export-chart'),def=defs.find(function(x){return x.id===id;});
   if(!def||!charts[id]){if(def)status(def,'The chart is unavailable for export; the report table can still be exported as CSV.');return;}
   if(btn.disabled)return;
   btn.disabled=true;
   try{if(!exportChartPng(def,btn.getAttribute('data-nl-chart-file'),btn))status(def,'No chartable data was available for image export.');}
   catch(e){status(def,'Could not save the high-resolution PNG. Try Recommended chart style, then save again.');}
   finally{btn.disabled=false;}
 });
 restore();
 (function initChartZoom(){
   var dashboard=document.querySelector('.analytics-dashboard');if(!dashboard)return;
   var overlay=document.createElement('div');overlay.className='nl-chart-zoom-overlay';overlay.hidden=true;
   overlay.innerHTML='<div class="nl-chart-zoom-panel" role="dialog" aria-modal="true" aria-labelledby="nlZoomTitle" tabindex="-1"><div class="nl-chart-zoom-head"><div><span class="nl-billing-eyebrow">INTERACTIVE REPORT</span><h2 id="nlZoomTitle">Expanded chart</h2><p>Change the chart format, hover for precise values, or save as PNG.</p></div><div class="nl-chart-zoom-actions"><button type="button" class="nl-chart-zoom-btn" data-nl-chart-filters>Change report filters</button><button type="button" class="nl-chart-zoom-btn" data-nl-chart-back>Back to report</button></div></div><div id="nlZoomContent"></div><details class="nl-zoom-filter-panel"><summary>Filter chart by date, route or seller</summary><div id="nlZoomFilters" class="mt-3"></div></details></div>';
   // Fixed-position descendants of transformed/scrolled containers can be positioned
   // relative to the page instead of the visible viewport. Portal directly under body.
   var portal=document.createElement('div');portal.className='analytics-dashboard nl-chart-zoom-portal';
   document.body.appendChild(portal);portal.appendChild(overlay);
   var originalParent=null,originalNext=null,activePane=null,activeDef=null,previousFocus=null,priorBodyOverflow='';
   var filtersParent=null,filtersNext=null,activeFilters=null;
   function resize(){if(activeDef&&charts[activeDef.id])requestAnimationFrame(function(){charts[activeDef.id].resize();});}
   function close(){if(!activePane)return;var pane=activePane,def=activeDef;activePane=null;activeDef=null;
     if(originalParent){if(originalNext&&originalNext.parentNode===originalParent)originalParent.insertBefore(pane,originalNext);else originalParent.appendChild(pane);}
     originalParent=null;originalNext=null;
     if(activeFilters&&filtersParent){if(filtersNext&&filtersNext.parentNode===filtersParent)filtersParent.insertBefore(activeFilters,filtersNext);else filtersParent.appendChild(activeFilters);}
     activeFilters=null;filtersParent=null;filtersNext=null;
     overlay.querySelector('.nl-zoom-filter-panel').open=false;
     overlay.hidden=true;document.body.style.overflow=priorBodyOverflow;
     if(def&&charts[def.id])requestAnimationFrame(function(){charts[def.id].resize();});
     if(previousFocus&&previousFocus.isConnected)previousFocus.focus();previousFocus=null;
   }
   function open(def){var section=document.getElementById(def.section);if(!section)return;var pane=section.querySelector('.nl-report-chart');if(!pane)return;
     if(activePane)close();activePane=pane;activeDef=def;originalParent=pane.parentNode;originalNext=pane.nextSibling;previousFocus=document.activeElement;
     overlay.querySelector('#nlZoomTitle').textContent=section.querySelector('.panel-title')?.textContent.trim()||'Expanded chart';
     overlay.querySelector('#nlZoomContent').appendChild(pane);
     var filters=document.getElementById('nlAnalyticsFilters');if(filters){activeFilters=filters;filtersParent=filters.parentNode;filtersNext=filters.nextSibling;overlay.querySelector('#nlZoomFilters').appendChild(filters);}
     priorBodyOverflow=document.body.style.overflow;
     overlay.hidden=false;overlay.scrollTop=0;overlay.querySelector('.nl-chart-zoom-panel').scrollTop=0;
     document.body.style.overflow='hidden';overlay.querySelector('[data-nl-chart-back]').focus();setTimeout(resize,50);
   }
   overlay.querySelector('[data-nl-chart-back]').addEventListener('click',close);
   overlay.querySelector('[data-nl-chart-filters]').addEventListener('click',function(){
     var details=overlay.querySelector('.nl-zoom-filter-panel');details.open=true;
     details.scrollIntoView({behavior:matchMedia('(prefers-reduced-motion: reduce)').matches?'auto':'smooth',block:'nearest'});
     details.querySelector('input,select')?.focus();
   });
   overlay.addEventListener('click',function(e){if(e.target===overlay)close();});
   document.addEventListener('keydown',function(e){if(!activePane)return;if(e.key==='Escape'){e.preventDefault();close();}else if(e.key==='Tab'){
     var list=Array.from(overlay.querySelectorAll('button:not([disabled]),select:not([disabled]),a[href],input:not([disabled])')).filter(el=>el.getClientRects().length);
     if(list.length){var first=list[0],last=list[list.length-1];if(e.shiftKey&&document.activeElement===first){e.preventDefault();last.focus();}else if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first.focus();}}
   }});
   defs.forEach(function(def){var section=document.getElementById(def.section);if(!section)return;
     var frame=section.querySelector('.nl-report-chart-frame');if(frame){frame.title='Click anywhere on the chart to expand and explore';frame.addEventListener('click',function(){if(!activePane)open(def);});
       var canvas=frame.querySelector('canvas');if(canvas){canvas.tabIndex=0;canvas.setAttribute('role','button');canvas.setAttribute('aria-label','Open interactive '+(section.querySelector('.panel-title')?.textContent.trim()||'report')+' chart');canvas.addEventListener('keydown',function(e){if(e.key==='Enter'||e.key===' '){e.preventDefault();open(def);}});}}
     var toolbar=section.querySelector('.nl-chart-tools');if(toolbar){var b=document.createElement('button');b.type='button';b.className='nl-chart-zoom-btn';b.setAttribute('data-nl-inline-open','true');b.textContent='Open interactive chart';b.addEventListener('click',function(){open(def);});toolbar.prepend(b);}
   });
 })();
})();

</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
