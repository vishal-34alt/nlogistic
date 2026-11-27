<jsp:useBean id="nlViewSupport_Module7_submit_claim" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module7_submit_claim" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module7_submit_claim" property="view" value="Module7/submit_claim.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,java.math.BigDecimal,java.time.LocalDate,model.*" %>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>File a Claim | N-LOGISTIC</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<%@ include file="../shared/_theme.jsp" %>
<style>
/* Component-scoped UI. Custom styles must remain inside JSP per faculty rules. */
.nl-claim-page { --claim-ink:#30241e; --claim-soft:#776c63; --claim-stroke:#eadccc; --claim-orange:#d75a16; color:var(--claim-ink); }
.nl-claim-top {display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap;margin-bottom:1.25rem}
.nl-claim-kicker {color:#a94c1c;text-transform:uppercase;font-size:.71rem;font-weight:850;letter-spacing:.14em;margin-bottom:.3rem}
.nl-claim-title {font-size:clamp(1.7rem,2.6vw,2.5rem);font-weight:850;letter-spacing:-.045em;line-height:1.14;margin:0}
.nl-claim-sub {color:var(--claim-soft);margin:.55rem 0 0;max-width:720px}
.nl-claim-surface {background:rgba(255,255,255,.92);border:1px solid var(--claim-stroke);border-radius:21px;box-shadow:0 12px 34px rgba(73,41,19,.065)}
.nl-claim-policy {background:linear-gradient(110deg,#fff7ed,#fffefb);border:1px solid #f4dfc6;border-radius:15px;padding:1rem 1.2rem;display:flex;gap:.8rem;align-items:flex-start;margin-bottom:1.25rem}
.nl-claim-policy-mark {width:34px;height:34px;flex:none;border-radius:11px;background:#ffedd9;display:grid;place-items:center;color:#b44b15;font-weight:850}
.nl-claim-policy p {color:#675b52;font-size:.88rem;margin:.2rem 0 0}
.nl-claim-form-grid {display:grid;grid-template-columns:minmax(0,1.55fr) minmax(280px,.85fr);gap:1.25rem;align-items:start}
.nl-claim-main {padding:1.5rem}
.nl-claim-aside {position:sticky;top:88px;overflow:hidden}
.nl-claim-aside-heading {padding:1.4rem 1.45rem 1rem;border-bottom:1px solid #f0e5da;background:linear-gradient(130deg,#fff9f3,#fff)}
.nl-claim-aside-body {padding:1.3rem 1.45rem}
.nl-claim-section-head {display:flex;align-items:center;gap:.8rem;margin-bottom:1.1rem}
.nl-claim-step {width:34px;height:34px;flex:none;background:#fff0e1;color:#b94813;border:1px solid #ffd6b1;border-radius:11px;display:grid;place-items:center;font-weight:900}
.nl-claim-section-title {font-weight:800;letter-spacing:-.025em;font-size:1.12rem;margin:0}
.nl-claim-section-sub {font-size:.81rem;color:#7e7065;margin:.2rem 0 0}
.nl-claim-rule {border:0;border-top:1px solid #efe3d7;margin:1.45rem 0}
.nl-claim-page .form-label {font-size:.83rem;font-weight:750;margin-bottom:.45rem}
.nl-claim-page .form-select,.nl-claim-page .form-control {min-height:46px;border-radius:12px;border:1px solid #decdbd;background-color:#fffdfb;color:var(--claim-ink)}
.nl-claim-page textarea.form-control{min-height:130px;resize:vertical}
.nl-claim-page .form-control:focus,.nl-claim-page .form-select:focus {border-color:#d65c1b;box-shadow:0 0 0 3px rgba(223,102,29,.12)}
.nl-claim-help {font-size:.77rem;color:#807268;margin-top:.4rem;line-height:1.5}
.nl-claim-pills {display:flex;gap:.45rem;flex-wrap:wrap;margin-top:.65rem}
.nl-claim-pill {font-size:.76rem;font-weight:700;border:1px solid #ecc9ac;background:#fff9f4;color:#98451b;border-radius:9px;padding:.4rem .65rem;transition:background .16s,transform .16s}
.nl-claim-pill:hover:not(:disabled) {background:#ffe9d7;transform:translateY(-2px)}
.nl-claim-pill:disabled {opacity:.45;cursor:not-allowed}
.nl-claim-note {padding:.75rem .88rem;background:#f5f9fc;border:1px solid #dce9f1;border-radius:11px;font-size:.79rem;color:#43596b;margin-top:.7rem}
.nl-claim-upload {border:1.5px dashed #e9b98d;border-radius:15px;background:#fff9f3;padding:1rem;transition:background .18s,border-color .18s}
.nl-claim-upload.is-dragging{background:#ffe8d5;border-color:#c95717}
.nl-claim-file-meta {font-size:.81rem;color:#65584f;margin:.7rem 0 0;word-break:break-word}
.nl-claim-kpi-grid {display:grid;grid-template-columns:1fr 1fr;gap:.7rem}
.nl-claim-kpi {border:1px solid #eee1d4;border-radius:13px;padding:.85rem;background:#fffaf6;min-width:0}
.nl-claim-kpi.main {grid-column:1/-1;background:linear-gradient(125deg,#3e231b,#813710);color:#fff;border-color:#813710;padding:1.1rem}
.nl-claim-kpi-label {font-size:.73rem;font-weight:650;color:#7a6e63;line-height:1.4}
.nl-claim-kpi.main .nl-claim-kpi-label {color:#f4d6bf}
.nl-claim-kpi-value {font-size:1.06rem;font-weight:850;margin-top:.3rem;font-variant-numeric:tabular-nums;overflow-wrap:anywhere}
.nl-claim-kpi.main .nl-claim-kpi-value {font-size:clamp(1.6rem,2vw,2.15rem);letter-spacing:-.03em}
.nl-claim-context-line {display:flex;justify-content:space-between;align-items:flex-start;gap:.8rem;padding:.8rem 0;border-bottom:1px solid #f1e7df;font-size:.84rem}
.nl-claim-context-line .key {color:#85776b;flex:none}
.nl-claim-context-line .value {font-weight:700;text-align:right;overflow-wrap:anywhere}
.nl-claim-review {margin-top:1.15rem;border-top:1px solid #ecdfd1;padding-top:1.05rem}
.nl-claim-review strong {font-weight:800}
.nl-claim-submit {border:none;border-radius:12px;background:linear-gradient(112deg,#b84210,#f36e14);color:white;padding:.8rem 1.25rem;font-weight:800;box-shadow:0 8px 18px rgba(207,76,17,.21);transition:transform .2s,box-shadow .2s}
.nl-claim-submit:hover:not(:disabled) {transform:translateY(-2px);box-shadow:0 11px 24px rgba(207,76,17,.27)}
.nl-claim-submit:disabled {opacity:.5;box-shadow:none}
.nl-claim-muted {color:#76695e;font-size:.8rem}
.nl-claim-tag {display:inline-flex;align-items:center;gap:.4rem;background:#eef8f1;color:#217348;border:1px solid #c9e9d5;padding:.25rem .55rem;font-size:.73rem;font-weight:800;border-radius:999px}
.nl-claim-tag::before {content:"";height:6px;width:6px;border-radius:50%;background:currentColor}
.nl-claim-empty {color:#796c62;background:#faf6f1;border:1px dashed #e5d7c9;border-radius:12px;padding:1rem;font-size:.86rem}
.nl-claim-form-footer {display:flex;justify-content:space-between;align-items:center;gap:1rem;flex-wrap:wrap;margin-top:1.5rem}
.nl-claim-mini-list {margin:.85rem 0 0;padding-left:1.05rem;color:#6f6259;font-size:.81rem;line-height:1.7}
@media(max-width:1050px){.nl-claim-form-grid{grid-template-columns:1fr}.nl-claim-aside{position:static;order:-1}}
@media(max-width:600px){.nl-claim-main{padding:1.05rem}.nl-claim-kpi-grid{grid-template-columns:1fr 1fr}.nl-claim-form-footer .nl-claim-submit{width:100%}.nl-claim-form-footer{flex-direction:column-reverse;align-items:stretch}.nl-claim-aside-heading,.nl-claim-aside-body{padding:1rem}.nl-claim-kpi.main .nl-claim-kpi-value{font-size:1.5rem}}
@media(prefers-reduced-motion:reduce){.nl-claim-page *{transition:none!important;animation:none!important}}

.nl-claim-preview-overlay{position:fixed;inset:0;z-index:1570;padding:18px;background:#261810ae;backdrop-filter:blur(4px);display:grid;place-items:center}
.nl-claim-preview-overlay[hidden]{display:none!important}
.nl-claim-preview-card{width:min(770px,100%);max-height:94dvh;overflow:auto;background:linear-gradient(160deg,#fffdfa,#fff4e9);border:1px solid #e5c7a9;border-radius:24px;box-shadow:0 30px 80px #2d180e55;padding:clamp(18px,3vw,30px)}
.nl-claim-preview-card h2{font-size:1.6rem;font-weight:900;color:#3d2a20;margin:5px 0 12px}
.nl-claim-preview-facts{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}
.nl-claim-preview-fact{background:white;border:1px solid #ead4c0;border-radius:12px;padding:12px;min-width:0}
.nl-claim-preview-fact span{display:block;color:#795b48;font-size:.77rem}.nl-claim-preview-fact strong{display:block;overflow-wrap:anywhere;font-size:.91rem;margin-top:3px}
.nl-claim-preview-document{border:1px dashed #d6a77e;background:#fff8ef;border-radius:12px;margin:14px 0;padding:12px;display:flex;flex-wrap:wrap;align-items:center;gap:10px}
.nl-claim-preview-actions{display:flex;gap:10px;flex-wrap:wrap;justify-content:center;margin-top:18px}
.nl-claim-preview-actions button{border-radius:12px;font-weight:850;padding:10px 18px;border:1px solid #e4b999;background:#fff7ed;color:#9d4a1a}
.nl-claim-preview-actions .nl-claim-preview-yes{background:linear-gradient(110deg,#b84210,#ef7019);color:white;border-color:#bb4d14}
@media(max-width:560px){.nl-claim-preview-facts{grid-template-columns:1fr}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-surface,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-note,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-policy,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-upload,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-preview-card,html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-step{background:#203044!important;color:#edf4fc!important;border-color:#526b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-surface :is(h2,h3,p,small,strong),html[data-nl-mode="dark"] body.nl-themed-page .nl-claim-step :is(h2,h3,p,span){color:#edf4fc!important}
</style>
</head>
<body data-nl-screen="module7-submit_claim" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-body nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">Claims / File a claim</div><div class="nl-view-body container-fluid p-0 px-0">
<main class="nl-claim-page">
<div class="nl-claim-top">
  <div><div class="nl-claim-kicker">Claims &amp; resolution / New claim</div><h1 class="nl-claim-title">File a shipment claim</h1><p class="nl-claim-sub">Choose a delivered shipment, review its recorded value and describe the incident. Your submitted claim will be sent to the Seller for review.</p></div>
  <a class="btn btn-outline-secondary rounded-3" href="${requestScope.nlv_Module7_submit_claim__1}?action=list">Back to claims</a>
</div>
${requestScope.nlv_Module7_submit_claim__2}
<div class="nl-claim-policy"><span class="nl-claim-policy-mark" aria-hidden="true">i</span><div><strong>Eligibility &amp; evidence</strong><p>Only your shipments marked ARRIVED or DELIVERED with a recorded actual arrival in the last <strong>${requestScope.nlv_Module7_submit_claim__3} days</strong> can be claimed. Claims may be approved in full, partially approved or rejected after Seller review. Attach a clear PDF, JPG or PNG (up to 10 MB); more evidence can be added from claim details after submission.</p></div></div>
${requestScope.nlv_Module7_submit_claim__4}
<form id="nlClaimForm" action="${requestScope.nlv_Module7_submit_claim__5}" method="post" enctype="multipart/form-data">
<input type="hidden" name="action" value="submit"><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module7_submit_claim__6}">
<div class="nl-claim-form-grid">
<section class="nl-claim-surface nl-claim-main" aria-label="New claim details">
  <div class="nl-claim-section-head"><div class="nl-claim-step" aria-hidden="true">1</div><div><h2 class="nl-claim-section-title">Shipment &amp; incident</h2><p class="nl-claim-section-sub">Use existing shipment records to avoid entering internal IDs.</p></div></div>
  <div class="row g-3">
    <div class="col-12">
      <label class="form-label" for="shipmentId">Eligible shipment <span class="text-danger">*</span></label>
      <select id="shipmentId" name="shipment_id" class="form-select" required="required" data-nl-no-eligible="${not empty requestScope.nlv_Module7_submit_claim__7}">
        <option value="">Choose an arrived or delivered shipment</option>
        <jsp:setProperty name="nlViewSupport_Module7_submit_claim" property="fragment" value="nlv_Module7_submit_claim__8" /><jsp:getProperty name="nlViewSupport_Module7_submit_claim" property="fragment" />
      </select>
      <div class="nl-claim-help">Only shipments owned by your signed-in Consumer account are listed. Selecting a shipment displays its recorded financial details.</div>
    </div>
    <div class="col-md-6">
      <label class="form-label" for="claimType">Claim type <span class="text-danger">*</span></label>
      <select id="claimType" name="claim_type" class="form-select" required>
        <option value="DAMAGE" ${requestScope.nlv_Module7_submit_claim__9}>Damaged cargo</option>
        <option value="LOSS" ${requestScope.nlv_Module7_submit_claim__10}>Lost cargo</option>
        <option value="SHORTAGE" ${requestScope.nlv_Module7_submit_claim__11}>Missing units / shortage</option>
        <option value="DELAY" ${requestScope.nlv_Module7_submit_claim__12}>Delivery delay</option>
      </select>
    </div>
    <div class="col-md-6">
      <label class="form-label" for="claimedAmount">Requested compensation (INR) <span class="text-danger">*</span></label>
      <div class="input-group"><span class="input-group-text bg-light">₹</span><input id="claimedAmount" name="claimed_amount" class="form-control" type="number" step="0.01" min="0.01" max="9999999999.99" required placeholder="Enter a fair estimate" value="${requestScope.nlv_Module7_submit_claim__13}"></div>
      <div class="nl-claim-pills" id="nlClaimAmountShortcuts"><button type="button" class="nl-claim-pill" data-claim-share="0.25" disabled>25% of cargo value</button><button type="button" class="nl-claim-pill" data-claim-share="0.5" disabled>50%</button><button type="button" class="nl-claim-pill" data-claim-share="1" disabled>Full cargo value</button></div>
      <p id="nlClaimAmountHelp" class="nl-claim-help" aria-live="polite">Cargo value is a reference, not an automatic compensation entitlement. Enter the amount supported by your evidence.</p>
    </div>
    <div class="col-12">
      <label class="form-label" for="description">Description of the incident <span class="text-danger">*</span></label>
      <textarea id="description" name="description" class="form-control" rows="5" maxlength="3000" required placeholder="Describe what happened, which items were affected, quantities, when you discovered the issue and what evidence you have.">${requestScope.nlv_Module7_submit_claim__14}</textarea>
      <div class="d-flex justify-content-between gap-3"><div id="nlClaimDescriptionHelp" class="nl-claim-help">Include the affected quantity, condition and date where known.</div><div class="nl-claim-help"><span id="nlClaimCharCount">0</span>/3000</div></div>
    </div>
  </div>
  <hr class="nl-claim-rule">
  <div class="nl-claim-section-head"><div class="nl-claim-step" aria-hidden="true">2</div><div><h2 class="nl-claim-section-title">Supporting evidence</h2><p class="nl-claim-section-sub">Attach a photograph, inspection report, receipt or other proof.</p></div></div>
  <div id="nlClaimDrop" class="nl-claim-upload">
    <label class="form-label" for="evidenceFile">Upload a document (optional, recommended)</label>
    <input id="evidenceFile" class="form-control" type="file" name="evidence_file" accept=".pdf,.jpg,.jpeg,.png,application/pdf,image/jpeg,image/png">
    <p class="nl-claim-help mb-0">PDF, JPG or PNG · maximum 10 MB · one file for this submission. You can add more evidence after the claim is created.</p>
    <p id="nlClaimFileMeta" class="nl-claim-file-meta" aria-live="polite">No evidence selected</p>
    <div id="nlClaimFileError" class="text-danger small fw-semibold d-none" role="alert"></div>
    <button type="button" id="nlClaimFileClear" class="btn btn-sm btn-outline-secondary rounded-3 d-none">Remove selected file</button>
  </div>
  <div class="nl-claim-form-footer"><a href="${requestScope.nlv_Module7_submit_claim__15}?action=list" class="btn btn-outline-secondary rounded-3 px-4">Cancel</a><button id="nlClaimSubmit" type="submit" class="nl-claim-submit" data-nl-no-eligible="${not empty requestScope.nlv_Module7_submit_claim__16}">Submit claim for Seller review</button></div>
  <p class="nl-claim-help mb-0 mt-2">Submitting creates a claim record; it does not automatically approve or pay compensation.</p>
</section>
<aside id="nlClaimAside" class="nl-claim-surface nl-claim-aside" aria-label="Selected shipment valuation">
  <div class="nl-claim-aside-heading"><div class="nl-claim-kicker">Live shipment context</div><h2 class="nl-claim-section-title" style="font-size:1.3rem">What was this shipment worth?</h2><p class="nl-claim-section-sub">Based on authorized records in your existing database.</p></div>
  <div class="nl-claim-aside-body">
    <div id="nlClaimNoSelection" class="nl-claim-empty">Choose an eligible shipment to view its recorded cargo value, booking quote, invoice and route.</div>
    <div id="nlClaimSelection" class="d-none">
      <div class="d-flex align-items-center justify-content-between gap-2 mb-3 flex-wrap"><strong id="nlClaimShipmentNumber" class="text-break"></strong><span class="nl-claim-tag" id="nlClaimShipmentStatus"></span></div>
      <div class="nl-claim-kpi-grid">
        <div class="nl-claim-kpi main"><div class="nl-claim-kpi-label">Recorded cargo value · shipment items</div><div id="nlClaimCargoValue" class="nl-claim-kpi-value">Not recorded</div></div>
        <div class="nl-claim-kpi"><div class="nl-claim-kpi-label">Booking quotation</div><div id="nlClaimQuoteValue" class="nl-claim-kpi-value">—</div></div>
        <div class="nl-claim-kpi"><div class="nl-claim-kpi-label">Total invoiced</div><div id="nlClaimInvoiceValue" class="nl-claim-kpi-value">—</div></div>
      </div>
      <div class="nl-claim-context-line"><span class="key">Seller</span><span id="nlClaimSeller" class="value">—</span></div>
      <div class="nl-claim-context-line"><span class="key">Route</span><span id="nlClaimRoute" class="value">—</span></div>
      <div class="nl-claim-context-line"><span class="key">Container</span><span id="nlClaimContainer" class="value">—</span></div>
      <div class="nl-claim-context-line"><span class="key">Cargo units</span><span id="nlClaimUnits" class="value">—</span></div>
      <div class="nl-claim-context-line"><span class="key">Recorded arrival</span><span id="nlClaimArrival" class="value">—</span></div>
      <div class="nl-claim-context-line"><span class="key">Last filing date</span><span id="nlClaimDeadline" class="value">—</span></div>
      <div class="nl-claim-note"><strong>How this value is calculated:</strong> Cargo value is the sum of <code>shipment_items.amount</code> for this shipment. The booking quote and invoice include different charges and should not be treated as cargo compensation. Missing financial records are shown as “Not recorded”.</div>
      <div class="nl-claim-review"><div class="nl-claim-kicker">Your request preview</div><div class="nl-claim-context-line"><span class="key">Claim type</span><span id="nlClaimReviewType" class="value">Damaged cargo</span></div><div class="nl-claim-context-line"><span class="key">Requested amount</span><strong id="nlClaimReviewAmount">Not entered</strong></div><p id="nlClaimOverCargo" class="nl-claim-note d-none" role="status">This amount exceeds the recorded cargo value. That may be valid for some claims, but attach supporting documents and explain the difference.</p></div>
    </div>
    <h3 class="mt-4 mb-2" style="font-weight:800;font-size:.91rem">Before you submit</h3><ul class="nl-claim-mini-list"><li>Verify the shipment and incident type.</li><li>Enter a justified amount; suggestions are optional.</li><li>Describe affected goods or delivery impact.</li><li>Attach clear evidence when available.</li></ul>
  </div>
</aside>
</div></form></main>
<script>
(function(){
  'use strict';
  var form=document.getElementById('nlClaimForm');
  if(!form)return;
  var shipment=document.getElementById('shipmentId');
  // Preserve disabled state without injecting malformed attributes into JSP tags.
  shipment.disabled=shipment.getAttribute('data-nl-no-eligible')==='true';
  var submitAction=document.getElementById('nlClaimSubmit');
  if(submitAction)submitAction.disabled=submitAction.getAttribute('data-nl-no-eligible')==='true';
  var type=document.getElementById('claimType');
  var amount=document.getElementById('claimedAmount');
  var description=document.getElementById('description');
  var file=document.getElementById('evidenceFile');
  var drop=document.getElementById('nlClaimDrop');
  var currently=null;
  var currency=new Intl.NumberFormat('en-IN',{style:'currency',currency:'INR',minimumFractionDigits:2,maximumFractionDigits:2});
  function node(id){return document.getElementById(id);}
  function put(id,value){node(id).textContent=value;}
  function valueToMoney(raw){if(raw===undefined||raw===null||raw==='')return 'Not recorded';var n=Number(raw);return Number.isFinite(n)?currency.format(n):'Not recorded';}
  function asText(raw){return raw&&raw.trim()?raw:'Not recorded';}
  function selectedOption(){return shipment&&shipment.selectedIndex>0?shipment.options[shipment.selectedIndex]:null;}
  function refreshShipment(){
    currently=selectedOption();
    var show=!!currently;
    node('nlClaimNoSelection').classList.toggle('d-none',show);
    node('nlClaimSelection').classList.toggle('d-none',!show);
    var hasValue=show&&currently.dataset.cargo!==''&&Number(currently.dataset.cargo)>0;
    Array.prototype.forEach.call(document.querySelectorAll('[data-claim-share]'),function(btn){btn.disabled=!hasValue||type.value==='DELAY';});
    if(show){
      var d=currently.dataset;
      put('nlClaimShipmentNumber',asText(d.number)); put('nlClaimShipmentStatus',asText(d.status));
      put('nlClaimCargoValue',valueToMoney(d.cargo)); put('nlClaimQuoteValue',valueToMoney(d.quote)); put('nlClaimInvoiceValue',valueToMoney(d.invoice));
      put('nlClaimSeller',asText(d.seller));put('nlClaimRoute',asText(d.origin)+' → '+asText(d.destination));
      put('nlClaimContainer',asText(d.container));put('nlClaimUnits',asText(d.units));
      put('nlClaimArrival',asText(d.arrived));put('nlClaimDeadline',asText(d.deadline));
    }
    refreshAmount();
  }
  function refreshAmount(){
    put('nlClaimReviewType',type.options[type.selectedIndex].text);
    var n=Number(amount.value);
    put('nlClaimReviewAmount',amount.value!==''&&Number.isFinite(n)&&n>0?currency.format(n):'Not entered');
    var cargo=currently?Number(currently.dataset.cargo):0;
    var warn=!!currently&&currently.dataset.cargo!==''&&cargo>0&&n>cargo&&amount.value!=='';
    node('nlClaimOverCargo').classList.toggle('d-none',!warn);
    put('nlClaimAmountHelp',type.value==='DELAY'?'For a delay, explain the financial loss and use evidence supporting the requested amount. Cargo value is not a delay compensation rate.':'Use the recorded cargo value only as a reference. Enter the loss or damage value supported by your evidence.');
  }
  function refreshDescription(){put('nlClaimCharCount',String(description.value.length));}
  function displayEvidence(){
    var picked=file.files&&file.files[0];
    var issue='';
    if(picked){
      var suffix=picked.name.slice(picked.name.lastIndexOf('.')+1).toLowerCase();
      if(['pdf','jpg','jpeg','png'].indexOf(suffix)<0)issue='Select a PDF, JPG or PNG file.';
      else if(picked.size>10*1024*1024)issue='The file exceeds the 10 MB upload limit.';
      put('nlClaimFileMeta',picked.name+' · '+(picked.size/1024/1024).toFixed(2)+' MB');
    }else put('nlClaimFileMeta','No evidence selected');
    node('nlClaimFileError').textContent=issue;
    node('nlClaimFileError').classList.toggle('d-none',!issue);
    node('nlClaimFileClear').classList.toggle('d-none',!picked);
    return !issue;
  }
  shipment.addEventListener('change',refreshShipment);
  type.addEventListener('change',function(){refreshShipment();refreshAmount();});
  amount.addEventListener('input',refreshAmount);
  description.addEventListener('input',refreshDescription);
  Array.prototype.forEach.call(document.querySelectorAll('[data-claim-share]'),function(btn){
    btn.addEventListener('click',function(){
      if(!currently||currently.dataset.cargo==='')return;
      var result=Math.round(Number(currently.dataset.cargo)*Number(btn.getAttribute('data-claim-share'))*100)/100;
      if(result<=0)return;
      amount.value=result.toFixed(2); amount.dispatchEvent(new Event('input',{bubbles:true}));amount.focus();
    });
  });
  file.addEventListener('change',displayEvidence);
  node('nlClaimFileClear').addEventListener('click',function(){file.value='';displayEvidence();});
  ['dragenter','dragover'].forEach(function(ev){drop.addEventListener(ev,function(e){e.preventDefault();drop.classList.add('is-dragging');});});
  ['dragleave','drop'].forEach(function(ev){drop.addEventListener(ev,function(e){e.preventDefault();drop.classList.remove('is-dragging');});});
  drop.addEventListener('drop',function(e){if(e.dataTransfer&&e.dataTransfer.files.length){try{file.files=e.dataTransfer.files;}catch(err){return;}displayEvidence();}});
  var preview=null,previewDocumentUrl=null,confirmed=false;
  function ensurePreview(){if(preview)return preview;
    preview=document.createElement('div');preview.className='nl-claim-preview-overlay';preview.hidden=true;
    preview.innerHTML='<div class="nl-claim-preview-card" role="dialog" aria-modal="true" aria-labelledby="nlClaimPreviewTitle" tabindex="-1"><span class="nl-claim-kicker">REVIEW YOUR CLAIM</span><h2 id="nlClaimPreviewTitle">Confirm claim information</h2><p class="nl-claim-muted">Make sure the shipment, amount, reason and evidence are correct before sending this claim to the Seller.</p><div class="nl-claim-preview-facts" id="nlClaimPreviewFacts"></div><div class="nl-claim-preview-document"><strong>Supporting document:</strong><span id="nlClaimPreviewFile"></span><a class="btn btn-sm btn-outline-warning" id="nlClaimPreviewView" target="_blank" rel="noopener noreferrer" hidden="hidden">View document</a></div><div class="nl-claim-preview-actions"><button type="button" data-nl-claim-back>Back to edit</button><button type="button" class="nl-claim-preview-yes" data-nl-claim-confirm>Confirm &amp; submit claim</button></div></div>';
    document.body.appendChild(preview);
    preview.querySelector('[data-nl-claim-back]').addEventListener('click',closePreview);
    preview.querySelector('[data-nl-claim-confirm]').addEventListener('click',function(){if(confirmed)return;confirmed=true;this.disabled=true;this.textContent='Submitting claim…';closePreview();HTMLFormElement.prototype.submit.call(form);});
    preview.addEventListener('click',function(e){if(e.target===preview)closePreview();});
    document.addEventListener('keydown',function(e){if(!preview.hidden&&e.key==='Escape'){e.preventDefault();closePreview();}});
    return preview;
  }
  function closePreview(){if(preview)preview.hidden=true;document.body.style.overflow='';}
  function addFact(host,label,value){var box=document.createElement('div');box.className='nl-claim-preview-fact';var k=document.createElement('span');k.textContent=label;var v=document.createElement('strong');v.textContent=value||'Not provided';box.append(k,v);host.appendChild(box);}
  form.addEventListener('submit',function(e){
    if(confirmed)return;
    e.preventDefault();if(!form.checkValidity()){form.reportValidity();return;}
    if(!displayEvidence()){file.focus();return;}
    if(!shipment.value){shipment.focus();return;}
    var modal=ensurePreview(),facts=modal.querySelector('#nlClaimPreviewFacts');facts.replaceChildren();
    addFact(facts,'Shipment',shipment.options[shipment.selectedIndex]?.textContent.trim());
    addFact(facts,'Claim reason',type.options[type.selectedIndex]?.textContent.trim());
    addFact(facts,'Requested compensation','INR '+amount.value);
    addFact(facts,'Contact email',form.querySelector('[name="contact_email"]')?.value||'Not supplied');
    addFact(facts,'Incident explanation',description.value.trim());
    var chosen=file.files&&file.files[0];modal.querySelector('#nlClaimPreviewFile').textContent=chosen?chosen.name:'No document selected';
    if(previewDocumentUrl){URL.revokeObjectURL(previewDocumentUrl);previewDocumentUrl=null;}
    var view=modal.querySelector('#nlClaimPreviewView');view.hidden=!chosen;
    if(chosen){previewDocumentUrl=URL.createObjectURL(chosen);view.href=previewDocumentUrl;}
    modal.hidden=false;document.body.style.overflow='hidden';modal.querySelector('[data-nl-claim-back]').focus();
  });
  refreshShipment();refreshDescription();displayEvidence();
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
</body></html>
