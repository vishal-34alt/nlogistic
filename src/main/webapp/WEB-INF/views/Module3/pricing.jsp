<jsp:useBean id="nlViewSupport_Module3_pricing" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module3_pricing" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module3_pricing" property="view" value="Module3/pricing.jsp" />
<%@ page pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>



<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>
<style>
/* v20.21: No sideways scrolling. Display every field in two organized tiers
   while retaining the semantic table DOM used by existing search, filters and actions. */
body.nl-themed-page .nl-view-body .nl-pricing-table-wrap{overflow:visible!important;max-width:100%!important;border:0!important;background:transparent!important;box-shadow:none!important}
body.nl-themed-page .nl-view-body table.nl-pricing-table{display:block!important;width:100%!important;min-width:0!important;max-width:100%!important;table-layout:auto!important;border:0!important;margin:0!important;background:transparent!important}
body.nl-themed-page .nl-view-body .nl-pricing-table thead{position:absolute!important;width:1px!important;height:1px!important;padding:0!important;margin:-1px!important;overflow:hidden!important;clip:rect(0,0,0,0)!important;white-space:nowrap!important;border:0!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody{display:grid!important;grid-template-columns:minmax(0,1fr);gap:13px!important;width:100%!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr{--bs-table-bg:transparent;--bs-table-striped-bg:transparent;--bs-table-hover-bg:transparent;display:grid!important;grid-template-columns:repeat(12,minmax(0,1fr));gap:10px 12px;width:100%;min-width:0;align-items:center;padding:15px 17px;background:#fffdfb!important;border:1px solid #edd9c9!important;border-left:4px solid #e96922!important;border-radius:15px!important;box-shadow:0 4px 14px #7448270a;transition:border-color .2s,box-shadow .2s}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr:hover{background:#fff8f0!important;border-color:#e6b992!important;box-shadow:0 8px 22px #8f52121c}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr[hidden],body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr[style*="display: none"]{display:none!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td{display:flex!important;flex-direction:column;align-items:flex-start;justify-content:center;gap:4px;min-width:0!important;width:auto!important;max-width:none!important;margin:0!important;padding:5px 7px!important;border:0!important;background:transparent!important;color:#39291f!important;box-shadow:none!important;overflow-wrap:anywhere;word-break:normal!important;white-space:normal!important;line-height:1.42!important;font-size:.84rem!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:before{display:block;content:"DETAILS";font-size:.65rem;font-weight:850;text-transform:uppercase;letter-spacing:.09em;line-height:1.25;color:#936b52;white-space:nowrap}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1){grid-column:1/2;grid-row:1;color:#b74a12!important;font-weight:850}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1):before{content:"RULE ID"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2){grid-column:2/5;grid-row:1;font-size:.89rem!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2):before{content:"SHIPPING ROUTE"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2) small{font-size:.78rem!important;line-height:1.35!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(3){grid-column:5/7;grid-row:1}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(3):before{content:"CONTAINER"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(4){grid-column:1/3;grid-row:2}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(4):before{content:"BASE RATE"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(5){grid-column:3/5;grid-row:2}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(5):before{content:"PER KG"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(6){grid-column:5/7;grid-row:2}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(6):before{content:"PER CBM"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(7){grid-column:7/9;grid-row:2}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(7):before{content:"SEASON"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(8){grid-column:9/11;grid-row:2}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(8):before{content:"DEMAND"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9){grid-column:11/13;grid-row:2}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9):before{content:"VALID DATES"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9) small{line-height:1.35!important;overflow-wrap:normal}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(10){grid-column:7/9;grid-row:1}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(10):before{content:"STATUS"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11){grid-column:9/13;grid-row:1}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11):before{content:"ACTIONS"}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9){border-top:1px solid #f1e3d5!important;padding-top:12px!important;font-variant-numeric:tabular-nums;font-weight:700}
.nl-pricing-table .nl-pricing-actions{display:flex!important;align-items:center;justify-content:flex-start;flex-wrap:nowrap!important;gap:7px!important;width:100%;min-width:0!important}
.nl-pricing-table .nl-pricing-actions>form{display:inline-flex!important;flex:0 0 auto;margin:0!important}
body.nl-themed-page .nl-view-body .nl-pricing-table .nl-pricing-actions .btn{display:inline-flex!important;align-items:center;justify-content:center;gap:5px;min-height:37px;white-space:nowrap!important;padding:8px 11px!important;margin:0!important;border-radius:10px!important;font-size:.78rem!important;font-weight:750;line-height:1.2}
.nl-pricing-table .nl-pricing-actions .btn-warning.bg-gradient{background:linear-gradient(110deg,#bd410c,#ef741b)!important;border-color:#c84e10!important;color:#fff!important}
.nl-pricing-table .nl-pricing-actions .btn-warning.bg-gradient:hover{background:linear-gradient(110deg,#a73507,#d95d0e)!important;color:#fff!important}
.nl-pricing-table .nl-pricing-actions img{flex:none}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr:has(td[colspan]){display:block!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr td[colspan]{display:block!important;text-align:center!important;padding:20px!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr td[colspan]:before{display:none!important}
.nl-pricing-table tbody td:nth-child(3) .badge,.nl-pricing-table tbody td:nth-child(10) .badge{font-size:.74rem!important;padding:6px 10px!important}
@media(max-width:1290px){
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr{grid-template-columns:repeat(6,minmax(0,1fr));gap:9px 10px}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1){grid-column:1/2;grid-row:1}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2){grid-column:2/5;grid-row:1}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(3){grid-column:5/6;grid-row:1}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(10){grid-column:6/7;grid-row:1}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(4){grid-column:1/2;grid-row:2}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(5){grid-column:2/3;grid-row:2}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(6){grid-column:3/4;grid-row:2}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(7){grid-column:4/5;grid-row:2}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(8){grid-column:5/6;grid-row:2}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9){grid-column:6/7;grid-row:2}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11){grid-column:1/-1;grid-row:3;display:flex!important;flex-direction:row;align-items:center;gap:14px;padding-top:11px!important;border-top:1px solid #f1e3d5!important}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11):before{flex:none}
}
@media(max-width:740px){
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr{grid-template-columns:repeat(2,minmax(0,1fr));gap:7px 8px;padding:13px 12px}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1){grid-column:1/2;grid-row:1}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(10){grid-column:2/3;grid-row:1;align-items:flex-end}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2){grid-column:1/-1;grid-row:2}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(3){grid-column:1/-1;grid-row:3}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(4){grid-column:1/2;grid-row:4}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(5){grid-column:2/3;grid-row:4}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(6){grid-column:1/2;grid-row:5}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(7){grid-column:2/3;grid-row:5}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(8){grid-column:1/2;grid-row:6}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9){grid-column:2/3;grid-row:6}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11){grid-column:1/-1;grid-row:7;flex-wrap:wrap!important;align-items:flex-start}
 body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11):before{width:100%}
 .nl-pricing-table .nl-pricing-actions{flex-wrap:wrap!important}
}
/* Pricing workspace header, navigation and search: scoped to this page only. */
.nl-pricing-workspace{position:relative;background:linear-gradient(135deg,#fffdfb,#fff3e6);border:1px solid #eed5bd;border-radius:20px;padding:22px 24px;margin-bottom:20px;box-shadow:0 11px 30px rgba(105,57,22,.07)}
.nl-pricing-head{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px 28px;margin-bottom:20px}
.nl-pricing-kicker{display:block;color:#b4511f;text-transform:uppercase;letter-spacing:.13em;font-size:.69rem;font-weight:850;margin-bottom:8px}
.nl-pricing-head h1{color:#39261d;font-size:clamp(1.75rem,2.6vw,2.6rem);font-weight:850;letter-spacing:-.045em;line-height:1.18;margin:0 0 5px}
.nl-pricing-head p{color:#806858;margin:0;line-height:1.5;font-size:.9rem}
.nl-pricing-head .nl-pricing-main-actions{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
.nl-pricing-head .nl-pricing-head-chip{display:inline-flex;align-items:center;padding:7px 12px;border-radius:999px;background:#ffead7;border:1px solid #ebc6a5;font-size:.72rem;font-weight:750;color:#a44b17}
.nl-pricing-head .btn{padding:11px 17px!important;border-radius:11px!important;white-space:nowrap;font-weight:750}
.nl-pricing-workspace .nl-tabs{display:flex!important;align-items:center;flex-wrap:wrap;gap:8px!important;padding:6px!important;margin-bottom:15px!important;background:#fffaf5!important;border:1px solid #ead4bf!important;border-radius:13px!important;box-shadow:none!important}
.nl-pricing-workspace .nl-tabs .nl-tab{display:inline-flex!important;align-items:center;justify-content:center;gap:8px;padding:11px 17px!important;border:1px solid transparent!important;border-radius:10px!important;color:#6d5547!important;font-size:.9rem!important;font-weight:750!important;min-height:44px}
.nl-pricing-workspace .nl-tabs .nl-tab[aria-current=page]{background:linear-gradient(110deg,#bb430e,#ed721c)!important;color:#fff!important;border-color:#d55b18!important;box-shadow:0 5px 13px #b54e192c}
.nl-pricing-workspace .nl-tabs .nl-tab:not([aria-current=page]):hover{background:#fff0df!important;color:#a74512!important}
.nl-pricing-search{display:grid;gap:7px;margin:0!important;padding:14px 16px!important;background:#fffdfa!important;border:1px solid #ebd5be!important;border-radius:13px!important;box-shadow:none!important}
.nl-pricing-search .nl-pricing-search-label{font-size:.77rem;font-weight:800;color:#684532;margin:0}
.nl-pricing-search .nl-pricing-search-fields{display:grid;grid-template-columns:minmax(0,1fr) auto auto;gap:9px;align-items:stretch}
.nl-pricing-search .form-control{min-width:0;height:46px;border:1px solid #e0c5ad;border-radius:10px!important;background:#fff!important;padding:10px 14px!important;box-shadow:none!important}
.nl-pricing-search .form-control:focus{border-color:#d76c29!important;box-shadow:0 0 0 3px rgba(232,126,54,.17)!important}
.nl-pricing-search .btn,.nl-pricing-search .nl-pricing-search-reset{display:inline-flex;align-items:center;justify-content:center;min-height:46px;border-radius:10px!important;padding:10px 18px!important;font-weight:750!important;white-space:nowrap}
.nl-pricing-search .btn{background:linear-gradient(110deg,#b9400c,#e96d19)!important;border-color:#ce5010!important;color:#fff!important}
.nl-pricing-search .nl-pricing-search-reset{background:#fff6ec;border:1px solid #e6c9ae;color:#995028;text-decoration:none}
.nl-pricing-search .nl-pricing-search-reset:hover{background:#fbe8d5;color:#743917}
.nl-pricing-search .nl-pricing-search-help{font-size:.72rem;color:#957664;margin:0}
.nl-pricing-directory-header{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;padding:0!important;margin-bottom:14px!important}
.nl-pricing-directory-header h5{font-size:1.2rem!important;letter-spacing:-.02em}
.nl-pricing-directory-header .badge{padding:9px 13px!important;border-radius:999px!important;font-weight:800}
.nl-pricing-directory-note{margin:14px 2px 2px;color:#94765c;font-size:.77rem}
@media(max-width:690px){.nl-pricing-workspace{padding:15px;border-radius:16px}.nl-pricing-head{align-items:flex-start}.nl-pricing-head .nl-pricing-main-actions{width:100%}.nl-pricing-search .nl-pricing-search-fields{grid-template-columns:1fr 1fr}.nl-pricing-search .nl-pricing-search-fields input{grid-column:1/-1}.nl-pricing-workspace .nl-tabs .nl-tab{flex:1;text-align:center;white-space:normal!important}.nl-pricing-head .btn{flex:1}}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-workspace{background:linear-gradient(135deg,#1f2f41,#23374b)!important;border-color:#496079!important;box-shadow:0 13px 35px #08122050!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-head h1{color:#f4f8fc!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-kicker{color:#ffb67e!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-head p{color:#cbd9e7!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-head .nl-pricing-head-chip{background:#3b3734!important;border-color:#735941!important;color:#ffd3ab!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-workspace .nl-tabs,html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-search{background:#26384d!important;border-color:#48617b!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-workspace .nl-tabs .nl-tab{color:#e5eef9!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-workspace .nl-tabs .nl-tab[aria-current=page]{color:#fff!important;background:linear-gradient(110deg,#b9430d,#ed731b)!important;border-color:#e77725!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-workspace .nl-tabs .nl-tab:not([aria-current=page]):hover{background:#38516a!important;color:#fff!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-search .nl-pricing-search-label{color:#ecf3fb!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-search .form-control{background:#16283a!important;color:#f3f8fd!important;border-color:#536b80!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-search .form-control::placeholder{color:#b4c5d7!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-search .nl-pricing-search-reset{background:#31455b!important;color:#edf4fc!important;border-color:#607990!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-search .nl-pricing-search-help{color:#bdd0e2!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr{background:#223449!important;color:#f1f7fe!important;border-color:#475d74!important;border-left-color:#ed7b2f!important;box-shadow:0 8px 25px #06122044!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr:hover{background:#293d54!important;border-color:#70849b!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td{background:transparent!important;color:#eaf2fb!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:before{color:#ffbd90!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1){color:#ffac70!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9),html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11){border-top-color:#41566d!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-directory-note{color:#bfd0e0!important}
/* Override older global input/background rules which otherwise wash out dark search controls. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-workspace .nl-pricing-search .nl-pricing-search-fields input.form-control[type="search"]{background-color:#15263a!important;background-image:none!important;color:#eef6fe!important;border-color:#56708a!important;-webkit-text-fill-color:#eef6fe!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-workspace .nl-pricing-search .nl-pricing-search-fields input.form-control[type="search"]::placeholder{color:#aebfd1!important;-webkit-text-fill-color:#aebfd1!important;opacity:1}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-workspace .nl-pricing-search a.nl-pricing-search-reset{background-color:#304358!important;background-image:none!important;color:#e6f1fc!important;border-color:#60788f!important}
 .nl-pricing-advanced{background:#fffdfa;border:1px solid #ead5c0;border-radius:15px;padding:0 14px;box-shadow:0 5px 14px #4c30120a}
.nl-pricing-advanced .nl-pricing-advanced-trigger{width:100%;background:transparent!important;border:0!important;padding:15px 10px!important;font-weight:800!important;color:#7b3b18!important;display:flex;align-items:center;text-align:left;justify-content:space-between;gap:10px;flex-wrap:wrap;box-shadow:none!important}
.nl-pricing-advanced .nl-pricing-advanced-trigger span{font-size:.77rem;color:#8f7967;font-weight:550}
.nl-pricing-advanced .nl-pricing-advanced-chevron{margin-left:auto;font-size:1.15rem!important;transition:transform .2s}
.nl-pricing-advanced .nl-pricing-advanced-trigger[aria-expanded="true"] .nl-pricing-advanced-chevron{transform:rotate(180deg)}
.nl-pricing-advanced .collapse .card{margin-top:12px!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-advanced{background:#23364b!important;border-color:#4e6278!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-advanced .nl-pricing-advanced-trigger{color:#ffbb88!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-advanced .nl-pricing-advanced-trigger span{color:#cbd9e8!important}
.nl-pricing-editor{border-radius:17px;overflow:hidden;border:1px solid #e3c5a9;background:#fffaf5;color:#3d2c23}
.nl-pricing-editor .modal-header,.nl-pricing-editor .modal-footer{border-color:#ecd5c1}
.nl-pricing-editor .nl-pricing-route-info{padding:12px 14px;background:#fff1e1;border:1px solid #e9cbb0;border-radius:11px;font-weight:650;overflow-wrap:anywhere}
.nl-pricing-editor .form-label{font-weight:650;color:inherit}
.nl-pricing-editor .form-control{background:#fff;border:1px solid #d7bfa9;color:#3d2c23;min-height:44px;border-radius:10px}
.nl-pricing-editor .form-control:focus{border-color:#de792c;box-shadow:0 0 0 3px #f1a36d40}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-editor{background:#1e2d40!important;color:#edf4fc!important;border-color:#496178!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-editor :is(.modal-header,.modal-footer){border-color:#496178!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-editor .nl-pricing-route-info{background:#283b50!important;color:#edf4fc!important;border-color:#516c86!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-editor .form-label{color:#edf4fc!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-editor .form-control{background:#132234!important;color:#f4f8fc!important;border-color:#55708b!important}

/* v20.20: ordinary div overlay. Avoids Eclipse's unsupported native dialog element. */
.nl-pricing-dialog{display:none;position:fixed;inset:0;width:100%;height:100%;padding:clamp(12px,3vw,26px);margin:0;background:rgba(16,23,34,.68);backdrop-filter:blur(3px);z-index:20000;align-items:center;justify-content:center;overflow:auto;overscroll-behavior:contain}
.nl-pricing-dialog.is-open{display:flex!important}
.nl-pricing-dialog .nl-pricing-editor{width:min(760px,100%);max-height:calc(100vh - 42px);overflow-y:auto;overscroll-behavior:contain;margin:auto;border:1px solid #e0bfa2;border-radius:18px;background:#fffaf5;color:#3d2c23;box-shadow:0 26px 90px rgba(30,20,12,.4)}
.nl-pricing-dialog .modal-header,.nl-pricing-dialog .modal-footer{display:flex;align-items:center;gap:12px;padding:16px 20px;justify-content:space-between}
.nl-pricing-dialog .modal-body{padding:20px}
.nl-pricing-dialog .modal-footer{justify-content:flex-end;flex-wrap:wrap}
.nl-pricing-dialog .modal-header .btn-close{flex:none}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-dialog .nl-pricing-editor{background:#1e2d40!important;color:#edf4fc!important;border-color:#4c637b!important;box-shadow:0 28px 95px rgba(0,0,0,.65)!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-pricing-editor .btn-close{filter:invert(1)}
@media(max-width:575px){.nl-pricing-dialog{padding:10px}.nl-pricing-dialog .nl-pricing-editor{max-height:calc(100vh - 20px)}.nl-pricing-dialog .modal-header,.nl-pricing-dialog .modal-footer{padding:14px}.nl-pricing-dialog .modal-body{padding:14px}}

/* v20.22: richer pricing cards with clearer visual grouping, stronger route emphasis,
   and stat-style value tiles while preserving the same data and actions. */
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr{position:relative;padding:18px 19px 16px;background:linear-gradient(180deg,#fffefd 0%,#fffaf5 100%)!important;border:1px solid #ecd6c4!important;border-left:5px solid #ea6b21!important;border-radius:18px!important;box-shadow:0 8px 20px rgba(119,72,27,.08)!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr::after{content:"";position:absolute;inset:0 auto 0 0;width:72px;border-radius:17px 0 0 17px;background:linear-gradient(180deg,rgba(234,107,33,.07),rgba(234,107,33,0));pointer-events:none}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr:hover{background:linear-gradient(180deg,#fffaf5 0%,#fff6ee 100%)!important;border-color:#e6ba96!important;box-shadow:0 14px 30px rgba(167,93,36,.14)!important;transform:translateY(-1px)}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td{position:relative;z-index:1;padding:6px 9px!important;border-radius:12px}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:before{font-size:.63rem;letter-spacing:.12em;color:#9b6b47}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1){background:transparent!important;justify-content:flex-start;font-size:1rem!important;color:#d05b1b!important;font-weight:900;letter-spacing:-.02em}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1):after{content:"Pricing rule";display:block;font-size:.74rem;font-weight:600;letter-spacing:0;color:#8f725d}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2){padding:8px 12px!important;background:linear-gradient(180deg,#fff7ef 0%,#fff4ea 100%)!important;border:1px solid #f0dcc9}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2) strong,body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2) b{font-size:1rem!important;color:#2f261f}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2) small{color:#7f6554!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(3),body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(10){justify-content:flex-start}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(3) .badge,body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(10) .badge{padding:8px 12px!important;border-radius:999px!important;font-size:.76rem!important;font-weight:800;box-shadow:inset 0 0 0 1px rgba(0,0,0,.03)}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11){padding:8px 10px!important;background:linear-gradient(180deg,#fffaf4 0%,#fff4ea 100%)!important;border:1px solid #f0dcc9}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11):before{margin-bottom:2px}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9){background:linear-gradient(180deg,#fffaf5 0%,#fff4eb 100%)!important;border:1px solid #efddcd!important;border-top:1px solid #efddcd!important;min-height:76px;justify-content:flex-start;box-shadow:inset 0 1px 0 rgba(255,255,255,.5)}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9) > *:last-child,body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9){font-size:1.02rem!important;font-weight:850!important;color:#2d241e!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9){background:linear-gradient(180deg,#fff6ee 0%,#ffefe2 100%)!important}
body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9) small,body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9){line-height:1.48!important}
.nl-pricing-table .nl-pricing-actions{gap:9px!important;justify-content:flex-start}
body.nl-themed-page .nl-view-body .nl-pricing-table .nl-pricing-actions .btn{min-height:38px;box-shadow:0 7px 16px rgba(182,85,18,.16)}
body.nl-themed-page .nl-view-body .nl-pricing-table .nl-pricing-actions .btn:hover{transform:translateY(-1px)}
body.nl-themed-page .nl-view-body .nl-pricing-directory-note{margin-top:10px!important;padding:11px 14px;border-radius:12px;background:#fff7ef;color:#7a5c49;border:1px solid #efdcc9}
@media(max-width:1290px){
  body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11){padding-top:12px!important}
}
@media(max-width:740px){
  body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr{padding:14px 13px 13px}
  body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr::after{width:100%;height:46px;inset:0 0 auto 0;border-radius:17px 17px 0 0;background:linear-gradient(180deg,rgba(234,107,33,.08),rgba(234,107,33,0))}
  body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2),body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11),body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9){min-height:auto}
  .nl-pricing-table .nl-pricing-actions{gap:8px!important}
  body.nl-themed-page .nl-view-body .nl-pricing-table .nl-pricing-actions .btn{flex:1 1 auto;min-width:0}
}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr{background:linear-gradient(180deg,#223246 0%,#1d2b3d 100%)!important;border-color:#4b6179!important;border-left-color:#f07a2c!important;box-shadow:0 10px 26px rgba(0,0,0,.28)!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr::after{background:linear-gradient(180deg,rgba(240,122,44,.12),rgba(240,122,44,0))}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody tr:hover{background:linear-gradient(180deg,#26384d 0%,#202f42 100%)!important;border-color:#617893!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td{color:#edf4fb!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:before{color:#f2bb89!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1){color:#ffb270!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(1):after{color:#b9cadc}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2),html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(11),html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9){background:linear-gradient(180deg,#293b51 0%,#233448 100%)!important;border-color:#50667d!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2) strong,html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2) b,html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(n+4):nth-child(-n+9){color:#f5f9fd!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(2) small,html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-table tbody td:nth-child(9) small{color:#c8d5e3!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-view-body .nl-pricing-directory-note{background:#243549!important;color:#dce8f4!important;border-color:#4c647c!important}


/* v20.29: visible overlap warning in both supported themes. */
#nlPricingOverlapNotice{border-left:4px solid #e66d1f;background:#fff5e9;color:#68401e;border-radius:12px}
html[data-nl-mode="dark"] #nlPricingOverlapNotice{background:#382b23;color:#ffe0bc;border-color:#ff9a52}
#nlPricingOverlapNotice .btn{white-space:normal}

/* v20.23 - pricing card action rhythm and accessible focus */
body[data-nl-screen="module3-pricing"] .nl-pricing-actions .btn:focus-visible{outline:3px solid #f39b57!important;outline-offset:3px}
body[data-nl-screen="module3-pricing"] .nl-pricing-table tbody tr{scroll-margin-top:100px}
body[data-nl-screen="module3-pricing"] .nl-pricing-directory-header{gap:12px;flex-wrap:wrap}

</style>
</head><body data-nl-screen="module3-pricing" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module3_pricing__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">

<!-- A single, focused pricing workspace header (UI only). -->
<section class="nl-pricing-workspace" aria-label="Pricing workspace tools">
  <div class="nl-pricing-head">
    <div>
      <span class="nl-pricing-kicker">CONTAINERS &amp; PRICING / RATE MANAGEMENT</span>
      <h1>Pricing rules</h1>
      <p>Manage freight rates, seasonal adjustments and container pricing from one workspace.</p>
    </div>
    <div class="nl-pricing-main-actions">
      <span class="nl-pricing-head-chip">Seller rate directory</span>
      <button type="button" class="btn btn-warning bg-gradient" data-bs-toggle="collapse" data-bs-target="#addPricingForm" aria-controls="addPricingForm" aria-expanded="false">+ Add pricing rule</button>
    </div>
  </div>
  <jsp:include page="/WEB-INF/views/shared/tabs.jsp">
      <jsp:param name="module" value="inventory" />
      <jsp:param name="activeTab" value="pricing" />
      <jsp:param name="tab1Key" value="directory" />
      <jsp:param name="tab1Label" value="Container directory" />
      <jsp:param name="tab1Url" value="/ContainerAllocationPricingController?module=container" />
      <jsp:param name="tab1Roles" value="SELLER" />
      <jsp:param name="tab2Key" value="pricing" />
      <jsp:param name="tab2Label" value="Pricing rules" />
      <jsp:param name="tab2Url" value="/ContainerAllocationPricingController?module=pricing" />
      <jsp:param name="tab2Roles" value="SELLER" />
  </jsp:include>
  <form method="get" action="${requestScope.nlv_Module3_pricing__2}/ContainerAllocationPricingController" class="nl-pricing-search">
    <input type="hidden" name="module" value="pricing"><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module3_pricing__3}">
    <label for="nlPricingDatabaseSearch" class="nl-pricing-search-label">Search pricing directory</label>
    <div class="nl-pricing-search-fields">
      <input id="nlPricingDatabaseSearch" type="search" class="form-control" name="q" value="${requestScope.nlv_Module3_pricing__4}" placeholder="Rule #, port ID, or container type" autocomplete="off">
      <button type="submit" class="btn btn-warning bg-gradient">Search database</button>
      <a class="nl-pricing-search-reset" href="${requestScope.nlv_Module3_pricing__2}/ContainerAllocationPricingController?module=pricing">Clear search</a>
    </div>
    <p class="nl-pricing-search-help">Searches your saved rules. Rule ID, origin/destination port ID and container type are supported.</p>
  </form>
</section>

            <!-- MESSAGES -->
            ${requestScope.nlv_Module3_pricing__5}

            ${requestScope.nlv_Module3_pricing__6}

            <!-- ADD PRICING RULE -->
            <div class="collapse mb-4" id="addPricingForm">

                <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

                    <div class="card-body p-4">

                        <h5 class="fw-bold mb-1">
                            Create Pricing Rule
                        </h5>

                        <p class="text-secondary small mb-4">
                            Define the route, container type and pricing structure.
                        </p>

                        <form id="nlPricingCreateForm" data-pricing-retry="${requestScope.pricingCreateFailed}"
                              data-nl-retry-origin-port-id="${requestScope.nlv_Module3_pricing_retry_originPortId}"
                              data-nl-retry-dest-port-id="${requestScope.nlv_Module3_pricing_retry_destPortId}"
                              data-nl-retry-container-type="${requestScope.nlv_Module3_pricing_retry_containerType}"
                              data-nl-retry-base-rate="${requestScope.nlv_Module3_pricing_retry_baseRate}"
                              data-nl-retry-rate-per-kg="${requestScope.nlv_Module3_pricing_retry_ratePerKg}"
                              data-nl-retry-rate-per-cbm="${requestScope.nlv_Module3_pricing_retry_ratePerCbm}"
                              data-nl-retry-season-multiplier="${requestScope.nlv_Module3_pricing_retry_seasonMultiplier}"
                              data-nl-retry-demand-multiplier="${requestScope.nlv_Module3_pricing_retry_demandMultiplier}"
                              data-nl-retry-valid-from="${requestScope.nlv_Module3_pricing_retry_validFrom}"
                              data-nl-retry-valid-to="${requestScope.nlv_Module3_pricing_retry_validTo}"
                              action="${requestScope.nlv_Module3_pricing__7}/ContainerAllocationPricingController"
                              method="post">

                            <input type="hidden" name="module" value="pricing"><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module3_pricing__8}">
                            <input type="hidden" name="action" value="insert">

                            <div class="row g-3">

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Origin Port ID
                                    </label>

                                    <select name="originPortId" class="form-select" required><option value="">Choose port</option><jsp:setProperty name="nlViewSupport_Module3_pricing" property="fragment" value="nlv_Module3_pricing__9" /><jsp:getProperty name="nlViewSupport_Module3_pricing" property="fragment" /></select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Destination Port ID
                                    </label>

                                    <select name="destPortId" class="form-select" required><option value="">Choose port</option><jsp:setProperty name="nlViewSupport_Module3_pricing" property="fragment" value="nlv_Module3_pricing__10" /><jsp:getProperty name="nlViewSupport_Module3_pricing" property="fragment" /></select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Container Type
                                    </label>

                                    <select name="containerType"
                                            class="form-select" required>

                                        <option value="">Select Type</option>
                                        <option value="DRY">DRY</option>
                                        <option value="REEFER">REEFER</option>
                                        <option value="OPEN_TOP">OPEN TOP</option>
                                        <option value="TANK">TANK</option>

                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Base Rate
                                    </label>

                                    <input type="number"
                                           name="baseRate"
                                           class="form-control"
                                           min="0"
                                           step="0.01"
                                           placeholder="Enter base rate"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Rate Per KG
                                    </label>

                                    <input type="number"
                                           name="ratePerKg"
                                           class="form-control"
                                           min="0"
                                           step="0.0001"
                                           placeholder="Enter rate per KG"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Rate Per CBM
                                    </label>

                                    <input type="number"
                                           name="ratePerCbm"
                                           class="form-control"
                                           min="0"
                                           step="0.01"
                                           placeholder="Enter rate per CBM"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Season Multiplier
                                    </label>

                                    <input type="number"
                                           name="seasonMultiplier"
                                           class="form-control"
                                           min="0.01"
                                           step="0.01"
                                           value="1.00"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Demand Multiplier
                                    </label>

                                    <input type="number"
                                           name="demandMultiplier"
                                           class="form-control"
                                           min="0.01"
                                           step="0.01"
                                           value="1.00"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Valid From
                                    </label>

                                    <input type="date"
                                           name="validFrom"
                                           class="form-control"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Valid Until
                                    </label>

                                    <input type="date"
                                           name="validTo"
                                           class="form-control">
                                    <small class="text-secondary">
                                        Optional, if no end date is specified.
                                    </small>
                                </div>

                            </div>

                            <p class="small text-secondary mt-3 mb-0">Only one active pricing rule may cover the same Seller, origin, destination, container type and date range. To change an existing rate, use its Edit action.</p>
                            <div id="nlPricingOverlapNotice" class="alert alert-warning mt-3 mb-0 d-none" role="status" aria-live="polite"></div>
                            <div class="mt-4 d-flex gap-2">

                                <button type="submit"
                                        class="btn btn-warning bg-gradient fw-semibold px-4"
                                       >

                                    
                                    Save Pricing Rule

                                </button>

                                <button type="reset"
                                        class="btn btn-light border px-4">
                                    Reset
                                </button>

                            </div>

                        </form>

                    </div>
                </div>
            </div>

            <!-- PRICING RULES TABLE -->
            <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 mb-4 border-warning-subtle">

                <div class="card-body p-3 p-lg-4">

                    <div class="nl-pricing-directory-header">

                        <div>
                            <h5 class="fw-bold mb-1">
                                All Pricing Rules
                            </h5>

                            <p class="text-secondary small mb-0">
                                Review your configured shipping rates.
                            </p>
                        </div>

                        <span class="badge bg-warning-subtle text-dark px-3 py-2">
                            
                            ${requestScope.nlv_Module3_pricing__11}
                            Rules
                        </span>

                    </div>

                    <div class="rounded-3 nl-pricing-table-wrap">

                        <table id="nlPricingRulesList" class="table table-hover align-middle table-striped nl-pricing-table">

                            <thead class="table-warning">
                                <tr>
                                    <th>Rule</th>
                                    <th>Route</th>
                                    <th>Container</th>
                                    <th>Base Rate</th>
                                    <th>Rate / KG</th>
                                    <th>Rate / CBM</th>
                                    <th>Season</th>
                                    <th>Demand</th>
                                    <th>Validity</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>

                            <tbody>

                                <jsp:setProperty name="nlViewSupport_Module3_pricing" property="fragment" value="nlv_Module3_pricing__12" /><jsp:getProperty name="nlViewSupport_Module3_pricing" property="fragment" />

                            </tbody>

                        </table>

                    </div>
                    <p class="nl-pricing-directory-note mb-0">Each rule shows its route, pricing breakdown, validity, and actions together. No sideways scrolling needed.</p>

                </div>
            </div>


<!-- Existing-file, scriptlet-free edit overlay with Eclipse-compatible HTML. -->
<div id="nlPricingEditDialog" class="nl-pricing-dialog">
    <form class="nl-pricing-editor" method="post" action="${requestScope.nlv_Module3_pricing__13}/ContainerAllocationPricingController" id="nlPricingEditForm">
      <div class="modal-header"><div><h5 class="modal-title fw-bold" id="nlPricingEditTitle">Edit pricing rule</h5><div class="small opacity-75">Update rates and validity without changing the route or container type.</div></div><button type="button" class="btn-close" data-nl-pricing-close aria-label="Close"></button></div>
      <div class="modal-body">
        <input type="hidden" name="module" value="pricing">
        <input type="hidden" name="action" value="edit">
        <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module3_pricing__14}">
        <input type="hidden" name="ruleId" id="nlEditRuleId">
        <div class="nl-pricing-route-info mb-3" id="nlEditRouteInfo"></div>
        <div class="row g-3">
          <div class="col-12 col-sm-6"><label for="nlEditBaseRate" class="form-label">Base rate (₹) <span class="text-danger">*</span></label><input id="nlEditBaseRate" class="form-control" name="baseRate" type="number" min="0" step="0.01" required></div>
          <div class="col-12 col-sm-6"><label for="nlEditRateKg" class="form-label">Rate per KG (₹) <span class="text-danger">*</span></label><input id="nlEditRateKg" class="form-control" name="ratePerKg" type="number" min="0" step="0.0001" required></div>
          <div class="col-12 col-sm-6"><label for="nlEditRateCbm" class="form-label">Rate per CBM (₹) <span class="text-danger">*</span></label><input id="nlEditRateCbm" class="form-control" name="ratePerCbm" type="number" min="0" step="0.01" required></div>
          <div class="col-12 col-sm-6"><label for="nlEditSeason" class="form-label">Season multiplier <span class="text-danger">*</span></label><input id="nlEditSeason" class="form-control" name="seasonMultiplier" type="number" min="0.01" step="0.01" required></div>
          <div class="col-12 col-sm-6"><label for="nlEditDemand" class="form-label">Demand multiplier <span class="text-danger">*</span></label><input id="nlEditDemand" class="form-control" name="demandMultiplier" type="number" min="0.01" step="0.01" required></div>
          <div class="col-12 col-sm-6"><label for="nlEditFrom" class="form-label">Valid from <span class="text-danger">*</span></label><input id="nlEditFrom" class="form-control" name="validFrom" type="date" required></div>
          <div class="col-12 col-sm-6"><label for="nlEditTo" class="form-label">Valid until</label><input id="nlEditTo" class="form-control" name="validTo" type="date"><div class="form-text">Leave blank for no expiry.</div></div>
        </div>
        <p class="small text-secondary mt-3 mb-0">Saved edits are recorded in your pricing audit history.</p>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-warning bg-gradient" data-nl-pricing-close>Cancel</button><button type="submit" class="btn btn-warning bg-gradient fw-bold">Save changes</button></div>
    </form>
</div>

            <!-- Existing advanced single-field update stays available, initially collapsed. -->
            <div class="nl-pricing-advanced mb-3">
                <button type="button" class="nl-pricing-advanced-trigger" data-bs-toggle="collapse" data-bs-target="#nlPricingAdvancedBody" aria-expanded="false" aria-controls="nlPricingAdvancedBody">Advanced options <span>Update a single field by rule ID</span><span class="nl-pricing-advanced-chevron" aria-hidden="true">▾</span></button>
                <div class="collapse" id="nlPricingAdvancedBody">
            <!-- UPDATE PRICING RULE -->
            <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

                <div class="card-body p-4">

                    <h5 class="fw-bold mb-1">
                        Update Pricing Rule
                    </h5>

                    <p class="text-secondary small mb-4">
                        Update one pricing attribute at a time.
                    </p>

                    <form action="${requestScope.nlv_Module3_pricing__13}/ContainerAllocationPricingController"
                          method="post">

                        <input type="hidden" name="module" value="pricing"><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module3_pricing__14}">
                        <input type="hidden" name="action" value="update">

                        <div class="row g-3">

                            <div class="col-md-4">

                                <label class="form-label fw-semibold">
                                    Pricing Rule ID
                                </label>

                                <input type="number"
                                       name="ruleId"
                                       class="form-control"
                                       min="1"
                                       placeholder="Enter rule ID"
                                       required>

                            </div>

                            <div class="col-md-4">

                                <label class="form-label fw-semibold">
                                    Field to Update
                                </label>

                                <select name="fieldName"
                                        class="form-select"
                                        required>

                                    <option value="">Select Field</option>
                                    <option value="base_rate">Base Rate</option>
                                    <option value="rate_per_kg">Rate Per KG</option>
                                    <option value="rate_per_cbm">Rate Per CBM</option>
                                    <option value="season_multiplier">Season Multiplier</option>
                                    <option value="demand_multiplier">Demand Multiplier</option>
                                    <option value="valid_from">Valid From</option>
                                    <option value="valid_to">Valid Until</option>

                                </select>

                            </div>

                            <div class="col-md-4">

                                <label class="form-label fw-semibold">
                                    New Value
                                </label>

                                <input type="text"
                                       name="newValue"
                                       class="form-control"
                                       placeholder="Enter new value"
                                       required>

                            </div>

                        </div>

                        <div class="mt-4">

                            <button type="submit"
                                    class="btn btn-warning bg-gradient fw-semibold px-4"
                                   >

                                
                                Update Pricing Rule

                            </button>

                        </div>

                    </form>

                </div>
            </div>

                </div>
            </div>

            <!-- FOOTER -->
            <footer class="text-center text-secondary small mt-5 mb-3">
                N-LOGISTIC | Logistics Management System
            </footer>



</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){'use strict';
 const form=document.getElementById('nlPricingCreateForm');
 const note=document.getElementById('nlPricingOverlapNotice');
 const list=document.getElementById('nlPricingRulesList');
 if(!form||!note||!list)return;
 const submit=form.querySelector('button[type="submit"]');
 const field=(name)=>form.elements.namedItem(name);
 function check(){
   const from=field('validFrom'),to=field('validTo');
   const validStart=from&&from.value||'',validEnd=to&&to.value||'';
   if(to)to.setCustomValidity(validStart&&validEnd&&validEnd<validStart?'End date cannot precede start date.':'');
   const origin=field('originPortId')?.value||'',dest=field('destPortId')?.value||'',type=field('containerType')?.value||'';
   let clash=null;
   if(origin&&dest&&type&&validStart&&(!validEnd||validEnd>=validStart)){
     clash=Array.from(list.querySelectorAll('tbody tr[data-nl-pricing-origin-id]')).find(function(row){
       const d=row.dataset;
       if(d.nlPricingActive!=='true'&&d.nlPricingActive!=='1')return false;
       if(d.nlPricingOriginId!==origin||d.nlPricingDestId!==dest||d.nlPricingContainerType!==type)return false;
       const oldFrom=d.nlPricingValidFrom||'',oldTo=d.nlPricingValidTo||'';
       // Null dates are open-ended in the approved SQL trigger.
       return (!validEnd||!oldFrom||validEnd>=oldFrom)&&(!oldTo||validStart<=oldTo);
     })||null;
   }
   note.replaceChildren();
   if(clash){
     const id=clash.dataset.nlPricingRuleId;
     const label=document.createElement('span');
     label.textContent='Active pricing rule #'+id+' already covers these dates. Edit that rule or choose a non-overlapping period. ';
     note.appendChild(label);
     const edit=clash.querySelector('.nl-pricing-edit');
     if(edit){
       const button=document.createElement('button');
       button.type='button';button.className='btn btn-warning btn-sm fw-semibold ms-2';
       button.textContent='Edit rule #'+id;
       button.addEventListener('click',()=>edit.click());
       note.appendChild(button);
     }
     note.classList.remove('d-none');
   }else note.classList.add('d-none');
   if(submit)submit.disabled=!!clash||!!(to&&to.validationMessage);
   return !clash&&!(to&&to.validationMessage);
 }
 for(const name of ['originPortId','destPortId','containerType','validFrom','validTo']){
   const input=field(name);if(input){input.addEventListener('change',check);input.addEventListener('input',check);}
 }
 form.addEventListener('submit',function(e){if(!check()){e.preventDefault();form.reportValidity();}});
 if(form.dataset.pricingRetry==='true'){
   for(const name of ['originPortId','destPortId','containerType','baseRate','ratePerKg','ratePerCbm','seasonMultiplier','demandMultiplier','validFrom','validTo']){
     const control=field(name);
     const key='nlRetry'+name.charAt(0).toUpperCase()+name.slice(1);
     if(control&&Object.prototype.hasOwnProperty.call(form.dataset,key))control.value=form.dataset[key];
   }
   const panel=document.getElementById('addPricingForm');
   if(panel&&window.bootstrap?.Collapse){window.bootstrap.Collapse.getOrCreateInstance(panel,{toggle:false}).show();}
 }
 check();
})();
(function(){'use strict';
 const dialog=document.getElementById('nlPricingEditDialog');
 const form=document.getElementById('nlPricingEditForm');
 if(!dialog||!form)return;
 // The overlay must be under body to escape animated layout stacking contexts.
 document.body.appendChild(dialog);
 // Each rule is fully displayed without horizontal scrolling; no scroll-focus trap needed.
 dialog.setAttribute('role','dialog');
 dialog.setAttribute('aria-modal','true');
 dialog.setAttribute('aria-labelledby','nlPricingEditTitle');
 const required=['ruleId','baseRate','ratePerKg','ratePerCbm','seasonMultiplier','demandMultiplier','validFrom','validTo'];
 let previousFocus=null,previousOverflow='';
 const isOpen=()=>dialog.classList.contains('is-open');
 function checkRange(){
   const from=form.elements.namedItem('validFrom'),to=form.elements.namedItem('validTo');
   if(from&&to)to.setCustomValidity(to.value&&from.value&&to.value<from.value?'End date cannot precede start date.':'');
 }
 function closeEditor(){
   if(!isOpen())return;
   dialog.classList.remove('is-open');
   document.body.style.overflow=previousOverflow;
   if(previousFocus&&previousFocus.isConnected)previousFocus.focus({preventScroll:true});
 }
 function openEditor(button){
   const d=button.dataset;
   if(!d.ruleId)return;
   const values={ruleId:d.ruleId,baseRate:d.baseRate,ratePerKg:d.ratePerKg,ratePerCbm:d.ratePerCbm,seasonMultiplier:d.seasonMultiplier,demandMultiplier:d.demandMultiplier,validFrom:d.validFrom,validTo:d.validTo};
   for(const key of required){const field=form.elements.namedItem(key);if(field)field.value=values[key]||'';}
   const title=document.getElementById('nlPricingEditTitle');if(title)title.textContent='Edit pricing rule #'+d.ruleId;
   const route=document.getElementById('nlEditRouteInfo');if(route)route.textContent=(d.origin||'Origin')+' → '+(d.destination||'Destination')+' · '+(d.container||'Container');
   form.querySelectorAll('.is-invalid').forEach(function(el){el.classList.remove('is-invalid');el.removeAttribute('aria-invalid');el.setCustomValidity('');});
   checkRange();
   previousFocus=button;
   previousOverflow=document.body.style.overflow;
   document.body.style.overflow='hidden';
   dialog.classList.add('is-open');
   const input=form.elements.namedItem('baseRate');if(input)input.focus({preventScroll:true});
 }
 // Delegated events support table sorting and filtering without reconnecting listeners.
 document.addEventListener('click',function(event){
   const edit=event.target.closest('.nl-pricing-edit');
   if(edit){event.preventDefault();openEditor(edit);return;}
   if(event.target.closest('[data-nl-pricing-close]')&&dialog.contains(event.target)){event.preventDefault();closeEditor();}
 });
 dialog.addEventListener('click',function(event){if(event.target===dialog)closeEditor();});
 document.addEventListener('keydown',function(event){
   if(!isOpen())return;
   if(event.key==='Escape'){event.preventDefault();closeEditor();return;}
   if(event.key!=='Tab')return;
   const items=Array.from(dialog.querySelectorAll('button:not([disabled]),input:not([disabled]),select:not([disabled]),textarea:not([disabled]),a[href]')).filter(el=>el.getClientRects().length);
   if(!items.length){event.preventDefault();return;}
   const first=items[0],last=items[items.length-1];
   if(event.shiftKey&&document.activeElement===first){event.preventDefault();last.focus();}
   else if(!event.shiftKey&&document.activeElement===last){event.preventDefault();first.focus();}
 });
 for(const key of ['validFrom','validTo']){const field=form.elements.namedItem(key);if(field)field.addEventListener('change',checkRange);}
 form.addEventListener('submit',function(event){
   checkRange();
   if(!form.checkValidity()){event.preventDefault();form.reportValidity();return;}
   const submit=form.querySelector('button[type="submit"]');if(submit){submit.disabled=true;submit.textContent='Saving changes…';}
 });
})();
</script></body></html>
