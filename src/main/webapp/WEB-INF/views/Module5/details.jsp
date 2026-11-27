<jsp:useBean id="nlViewSupport_Module5_details" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module5_details" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module5_details" property="view" value="Module5/details.jsp" />
<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*,java.math.*,model.Row" %>





<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>
<style>
.nl-billing-eyebrow{font-size:.74rem;font-weight:850;letter-spacing:.12em;color:#b4511b}
.nl-delivery-options{display:grid;grid-template-columns:1fr 1fr;gap:13px}
.nl-delivery-option{border:1px solid #e8d0b8;background:linear-gradient(140deg,#fffdfb,#fff5ea);border-radius:16px;padding:21px;display:flex;flex-direction:column;gap:12px;color:#42291b;text-decoration:none;min-width:0;transition:border-color .2s,transform .2s}
.nl-delivery-option:hover{border-color:#d9722d;color:#42291b;transform:translateY(-2px)}.nl-delivery-option strong{font-size:1.08rem}.nl-delivery-option>span{font-size:.86rem;color:#7d604e}.nl-delivery-option b{margin-top:auto;font-size:.87rem;color:#b55117}
@media(max-width:740px){.nl-delivery-options{grid-template-columns:1fr}}
@media(prefers-reduced-motion:reduce){.nl-delivery-option{transition:none;transform:none!important}}

/* v17.10: payment review is viewport-centered. Do not lock body overflow:
   doing so removes sticky navigation from the scrolled billing screen. */
body.nl-themed-page[data-nl-screen="module5-details"].nl-payment-review-open {
  overflow:visible!important;
}
body.nl-themed-page[data-nl-screen="module5-details"] > #paymentConfirmDialog:not([hidden]) {
  position:fixed!important;
  inset:0!important;
  top:0!important;
  left:0!important;
  width:100vw!important;
  height:100vh!important;
  height:100dvh!important;
  min-height:0!important;
  margin:0!important;
  padding:clamp(14px,3vw,28px)!important;
  display:flex!important;
  align-items:center!important;
  justify-content:center!important;
  overflow:auto!important;
  overscroll-behavior:contain;
  z-index:99999!important;
  background:transparent!important;
  -webkit-backdrop-filter:none!important;
  backdrop-filter:none!important;
  isolation:isolate;
  transform:none!important;
}
/* Dim only the content area. The universal top bar and sidebar stay visible. */
body.nl-themed-page[data-nl-screen="module5-details"] > #paymentConfirmDialog:not([hidden])::before {
  content:"";
  position:fixed;
  top:var(--nl-ui-h,76px);
  left:var(--nl-ui-side,264px);
  right:0;
  bottom:0;
  background:rgba(39,27,18,.30);
  pointer-events:none;
  z-index:-1;
}
body.nl-themed-page[data-nl-screen="module5-details"] > #paymentConfirmDialog .payment-dialog-surface {
  position:relative;
  z-index:1;
  flex:0 1 540px;
  width:min(540px,100%)!important;
  max-height:calc(100dvh - 36px)!important;
  overflow-y:auto!important;
  margin:0!important;
  animation:none!important;
  transform:none!important;
}
@media(max-width:991.98px) {
  body.nl-themed-page[data-nl-screen="module5-details"] > #paymentConfirmDialog:not([hidden])::before {left:0;}
}
/* v17.11: actionable billing reference toast, no new asset files. */
.nl-payment-reference-required{color:#bd481c;font-weight:900;margin-left:2px;}
.nl-payment-reference-help{display:block;margin-top:5px;font-size:.80rem;color:#786250;font-weight:500;}
#nlPaymentReference.nl-reference-invalid{border-color:#c64522!important;box-shadow:0 0 0 3px rgba(198,69,34,.15)!important;}
.nl-payment-reference-toast{
  position:fixed;right:clamp(12px,2vw,28px);top:calc(var(--nl-ui-h,76px) + 14px);
  z-index:100005;max-width:min(435px,calc(100vw - 24px));
  display:flex;align-items:flex-start;gap:12px;
  padding:15px 17px;border-radius:14px;border:1px solid #ebb89e;
  border-left:5px solid #bc4c24;background:#fffaf5;color:#442d22;
  box-shadow:0 14px 40px rgba(58,31,13,.19);font-family:inherit;
  font-size:.93rem;line-height:1.4;
}
.nl-payment-reference-toast strong{display:block;margin-bottom:2px;font-size:.97rem;}
.nl-payment-reference-toast p{margin:0;color:#765440;}
.nl-payment-reference-toast>button{flex:none;margin-left:auto;background:transparent;border:0;color:#7d5846;font-size:1.25rem;line-height:1;cursor:pointer;}
.nl-payment-reference-toast[hidden]{display:none!important;}
@media(max-width:575.98px){.nl-payment-reference-toast{top:calc(var(--nl-ui-h,76px) + 8px);left:12px;right:12px;max-width:none;}}
/* v17.13: payment form layout-only correction. Do not change payment rules. */
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm {
  align-items:start;
  column-gap:clamp(12px,1.2vw,20px);
  row-gap:18px;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm > label.nl-pay-field {
  display:flex;
  flex-direction:column;
  justify-content:flex-start;
  align-items:stretch;
  align-self:start;
  gap:7px;
  min-width:0;
  width:100%;
  margin:0;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-pay-field-heading {
  display:inline-flex;
  align-items:baseline;
  justify-content:flex-start;
  flex-wrap:wrap;
  column-gap:4px;
  min-height:1.55rem;
  color:#50392d;
  font-weight:760;
  font-size:.9rem;
  line-height:1.5;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-pay-field-heading .nl-required {
  display:inline!important;
  margin:0!important;
  line-height:inherit!important;
  vertical-align:baseline!important;
  color:#bc431f!important;
  font-weight:850!important;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-pay-field :is(.form-control,.form-select) {
  height:46px;
  min-height:46px;
  width:100%;
  margin:0;
  padding-block:9px;
  border-radius:11px;
  font-size:.93rem;
  line-height:1.4;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-payment-reference-help {
  display:block;
  font-size:.78rem;
  line-height:1.45;
  margin:0;
  min-height:1.1rem;
  color:#7b6050;
  font-weight:500;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-payment-reference-required[hidden] {
  display:none!important;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-payment-modes {
  margin-bottom:2px;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-payment-live-summary {
  margin-top:2px;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-payment-submit-row {
  margin-top:2px;
  padding-top:15px;
  border-top:1px solid #efdfd0;
}
body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-payment-submit-row p {
  font-size:.82rem;
  line-height:1.5;
}
@media (max-width:1399.98px) {
  body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm {
    grid-template-columns:repeat(2,minmax(0,1fr));
  }
}
@media (max-width:640px) {
  body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm {
    grid-template-columns:minmax(0,1fr);
  }
  body.nl-themed-page[data-nl-screen="module5-details"] #recordPaymentForm .nl-payment-submit-row {
    align-items:stretch;
  }
}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-workspace,html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-balance-overview>div,html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-live-summary>div,html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-mode-option,html[data-nl-mode="dark"] body.nl-themed-page .nl-delivery-option{background:#203044!important;background-image:none!important;color:#edf4fc!important;border-color:#526b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-balance-overview>div,html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-live-summary>div,html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-mode-option{background:#2b3e52!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-balance-overview :is(span,strong),html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-live-summary :is(span,strong),html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-mode-option :is(strong,small){color:#eff6fd!important}
html[data-nl-mode="dark"] body.nl-themed-page .payment-dialog-surface,html[data-nl-mode="dark"] body.nl-themed-page .payment-amount-box,html[data-nl-mode="dark"] body.nl-themed-page .payment-warning,html[data-nl-mode="dark"] body.nl-themed-page .payment-actions{background:#203044!important;color:#edf4fc!important;border-color:#597288!important}
html[data-nl-mode="dark"] body.nl-themed-page .payment-amount-box :is(strong,span),html[data-nl-mode="dark"] body.nl-themed-page .payment-warning :is(strong,p),html[data-nl-mode="dark"] body.nl-themed-page .payment-review :is(dt,dd){color:#edf4fc!important}

/* v20.23 - payment entry grouping and visual clarity */
body[data-nl-screen="module5-details"] #recordPaymentForm{min-width:0}
body[data-nl-screen="module5-details"] #recordPaymentForm .nl-pay-field{min-width:0!important}
body[data-nl-screen="module5-details"] :is(.nl-payment-progress,.nl-invoice-summary,.nl-pay-summary){border-radius:12px!important}
body[data-nl-screen="module5-details"] #recordPaymentForm :is(button,input,select){max-width:100%}

</style></head><body data-nl-screen="module5-details" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module5_details__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">

<jsp:include page="/WEB-INF/views/shared/header.jsp">
    <jsp:param name="pageTitle" value="Invoice details"/>
    <jsp:param name="activeModule" value="billing"/>
</jsp:include>



<jsp:include page="/WEB-INF/views/shared/tabs.jsp">
    <jsp:param name="module" value="billing"/>
    <jsp:param name="activeTab" value="invoices"/>
</jsp:include>

<!-- NAVIGATION -->

<div class="d-flex align-items-center gap-3 mb-3">

    <a href="${requestScope.nlv_Module5_details__2}?action=outstanding"
       class="btn btn-warning bg-gradient">
        Outstanding report
    </a>

</div>

<!-- PAYMENT SUCCESS MESSAGE -->
${requestScope.nlv_Module5_details__3}

${requestScope.nlv_Module5_details__4}
${requestScope.nlv_Module5_details__5}
<!-- INVOICE INFORMATION -->

<section class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

    <h2 class="h4 fw-bold text-dark mb-2 nl-invoice-title">
        Invoice ${requestScope.nlv_Module5_details__6}
    </h2>

    <p>

        Shipment:
        ${requestScope.nlv_Module5_details__7}

        &nbsp;

        <span class="${requestScope.nlv_Module5_details__8}">

            ${requestScope.nlv_Module5_details__9}

        </span>

    </p>

    <p>
        Seller: ${requestScope.nlv_Module5_details__10}
        |
        Consumer: ${requestScope.nlv_Module5_details__11}
    </p>

    <p>
        Issued: ${requestScope.nlv_Module5_details__12}
        |
        Due: ${requestScope.nlv_Module5_details__13}
    </p>

    <!-- FINANCIAL SUMMARY -->

    <div class="nl-invoice-summary-grid mb-3">

        ${requestScope.nlv_Module5_details__14}

    </div>

    ${requestScope.nlv_Module5_details__15}
    <!-- PDF ACTIONS -->

    <div class="invoice-actions nl-invoice-actions d-flex flex-wrap align-items-center gap-2 mb-3">

        <a class="btn btn-warning bg-gradient"
           href="${requestScope.nlv_Module5_details__16}?action=print&amp;invoice=${requestScope.nlv_Module5_details__17}">

            Print / Save PDF

        </a>

        <a class="btn btn-warning bg-gradient"
           href="${requestScope.nlv_Module5_details__18}?action=download&amp;invoice=${requestScope.nlv_Module5_details__19}">

            Download PDF

        </a>

    </div>

    <!-- SELLER DUE DATE UPDATE -->

    ${requestScope.nlv_Module5_details__20}

</section>

<!-- INVOICE CHARGES -->

<section class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

    <h3>Invoice charges</h3>

    <div class="table-responsive rounded-3">

        <table class="table table-hover align-middle table-striped">

            <thead class="table-warning">

                <tr>
                    <th>Type</th>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Rate</th>
                    <th>Amount</th>

                    <jsp:setProperty name="nlViewSupport_Module5_details" property="fragment" value="nlv_Module5_details__21" /><jsp:getProperty name="nlViewSupport_Module5_details" property="fragment" />

                </tr>

            </thead>

            <tbody>

                <jsp:setProperty name="nlViewSupport_Module5_details" property="fragment" value="nlv_Module5_details__22" /><jsp:getProperty name="nlViewSupport_Module5_details" property="fragment" />

            </tbody>

        </table>

        ${requestScope.nlv_Module5_details__23}

    </div>

    <!-- ADD INVOICE NOTE -->

    ${requestScope.nlv_Module5_details__24}

</section>

<div class="d-flex flex-wrap gap-2 mb-4">
  <a class="btn btn-outline-dark" href="${requestScope.nlv_Module5_details__25}?action=invoices">All invoices</a>
  <a class="btn btn-outline-dark" href="${requestScope.nlv_Module5_details__26}?action=payments">Payment history</a>
  <a class="btn btn-outline-dark" href="${requestScope.nlv_Module5_details__27}?action=download&amp;invoice=${requestScope.nlv_Module5_details__28}">Download invoice</a>
</div>
<!-- PAYMENT HISTORY -->

<section class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

    <h3 id="nlPaymentHistory">Payment history</h3>
    <p class="text-secondary small">Payments shown here are recorded transactions, not online payment processing.</p>

    <div class="table-responsive rounded-3">

        <table class="table table-hover align-middle table-striped">

            <thead class="table-warning">

                <tr>
                    <th>Payment ID</th>
                    <th>Amount</th>
                    <th>Mode</th>
                    <th>Reference</th>
                    <th>Date</th>
                </tr>

            </thead>

            <tbody>

                <jsp:setProperty name="nlViewSupport_Module5_details" property="fragment" value="nlv_Module5_details__29" /><jsp:getProperty name="nlViewSupport_Module5_details" property="fragment" />

            </tbody>

        </table>

        ${requestScope.nlv_Module5_details__30}

    </div>

</section>

<!-- Full and partial payment recording only. No Pay on Delivery option. -->
<!-- CONSUMER PAYMENT FORM -->
${requestScope.nlv_Module5_details__31}

<script>
(function(){
  'use strict';
  function initInvoicePaymentReview(){
    const form=document.getElementById('recordPaymentForm');
    const dialog=document.getElementById('paymentConfirmDialog');
    if(!form||!dialog)return;
    // Keep the overlay out of animated content stacking contexts.
    if(dialog.parentElement!==document.body)document.body.appendChild(dialog);
    const amountInput=form.elements.namedItem('amount');
    const modeInput=form.elements.namedItem('mode');
    const refInput=form.elements.namedItem('reference');
    const dateInput=form.elements.namedItem('date');
    const fullInput=document.getElementById('nlPaymentFull');
    const partialInput=document.getElementById('nlPaymentPartial');
    const quick=document.getElementById('nlPartialShortcuts');
    const cancel=document.getElementById('cancelPayment');
    const confirmButton=document.getElementById('confirmPayment');
    const error=document.getElementById('nlPaymentInlineError');
    const referenceRequired=document.getElementById('nlPaymentReferenceRequired');
    const referenceHelp=document.getElementById('nlPaymentReferenceHelp');
    const balance=Number('${requestScope.nlv_Module5_details__32}');
    const paid=Number('${requestScope.nlv_Module5_details__33}');
    const total=Number('${requestScope.nlv_Module5_details__34}');
    const currency=value=>'₹ '+Number(value).toLocaleString('en-IN',{minimumFractionDigits:2,maximumFractionDigits:2});
    let previousFocus=null;
    let committing=false;
    let toastTimer=null;
    let referenceToast=null;
    function requiresReference(){return modeInput.value!=='CASH';}
    function dismissReferenceToast(){
      if(toastTimer){clearTimeout(toastTimer);toastTimer=null;}
      if(referenceToast){referenceToast.remove();referenceToast=null;}
    }
    function notifyReferenceMissing(){
      dismissReferenceToast();
      const toast=document.createElement('div');
      toast.className='nl-payment-reference-toast';
      toast.setAttribute('role','alert');
      toast.setAttribute('aria-live','assertive');
      const words=document.createElement('div');
      const title=document.createElement('strong');title.textContent='Payment reference required';
      const message=document.createElement('p');
      message.textContent='Enter the '+(modeInput.value==='UPI'?'UPI transaction ID':modeInput.value==='CHEQUE'?'cheque reference number':'bank transaction reference')+' before continuing.';
      words.append(title,message);
      const close=document.createElement('button');close.type='button';close.textContent='×';close.setAttribute('aria-label','Dismiss payment reference message');
      close.addEventListener('click',dismissReferenceToast);
      toast.append(words,close);document.body.appendChild(toast);
      referenceToast=toast;
      toastTimer=setTimeout(dismissReferenceToast,6000);
      refInput.classList.add('nl-reference-invalid');
      refInput.setAttribute('aria-invalid','true');
      // Keep the user on the form instead of submitting to the billing error page.
      refInput.scrollIntoView({block:'center',behavior:'smooth'});
      try{refInput.focus({preventScroll:true});}catch(ignore){refInput.focus();}
    }
    function updateReferenceRule(){
      const required=requiresReference();
      if(referenceRequired)referenceRequired.hidden=!required;
      if(referenceHelp)referenceHelp.textContent=required?'Required for UPI, bank transfer and cheque.':'Optional for cash payments.';
      refInput.setAttribute('aria-required',String(required));
      refInput.classList.remove('nl-reference-invalid');
      refInput.removeAttribute('aria-invalid');
      dismissReferenceToast();
      if(error && /reference/i.test(error.textContent||''))showError('');
    }
    function chosenType(){return partialInput.checked?'PARTIAL':'FULL';}
    function roundCents(value){return Math.round((value+Number.EPSILON)*100)/100;}
    function set(id,value){const el=document.getElementById(id);if(el)el.textContent=value;}
    function showError(message){error.textContent=message;error.hidden=!message;}
    function syncType(){
      const isPartial=partialInput.checked;
      amountInput.readOnly=!isPartial;
      quick.hidden=!isPartial;
      if(isPartial){
        amountInput.value='';
        amountInput.placeholder='Enter an amount below '+currency(balance);
      }else{
        amountInput.value=balance.toFixed(2);
        amountInput.placeholder='';
      }
      amountInput.setCustomValidity('');showError('');updatePreview();
    }
    function updatePreview(){
      const amount=roundCents(Number(amountInput.value)||0);
      const after=roundCents(Math.max(0,balance-amount));
      set('nlPayingNow',currency(amount));set('nlAfterPayment',currency(after));
      set('nlExpectedStatus',after===0?'Paid':paid+amount>0?'Partially paid':'Unpaid');
    }
    function validate(show){
      amountInput.setCustomValidity('');
      const amount=Number(amountInput.value);
      let message='';
      if(!Number.isFinite(balance)||balance<=0)message='This invoice has no outstanding balance.';
      else if(!Number.isFinite(amount)||amount<=0)message='Enter a positive amount.';
      else if(!/^\d+(?:\.\d{1,2})?$/.test(amountInput.value))message='Use at most two decimal places.';
      else if(amount>balance)message='Payment cannot exceed the outstanding balance.';
      else if(chosenType()==='FULL'&&Math.abs(amount-balance)>0.001)message='Full payment must equal the remaining balance.';
      else if(chosenType()==='PARTIAL'&&amount>=balance)message='Partial payment must be less than the remaining balance.';
      if(message){amountInput.setCustomValidity(message);if(show){showError(message);form.reportValidity();}return false;}
      if(requiresReference()&&!refInput.value.trim()){
        if(show){showError('Enter the payment reference number to continue.');notifyReferenceMissing();}
        return false;
      }
      if(!form.checkValidity()){if(show)form.reportValidity();return false;}
      showError('');return true;
    }
    // Position:fixed must use the viewport, not the transformed/animated page wrapper.
    function closeReview(restoreFocus=true){dialog.hidden=true;document.body.classList.remove('nl-payment-review-open');
      if(restoreFocus&&previousFocus&&previousFocus.isConnected)previousFocus.focus();}
    function openReview(){previousFocus=document.activeElement;dialog.hidden=false;document.body.classList.add('nl-payment-review-open');cancel.focus();}
    fullInput.addEventListener('change',syncType);
    partialInput.addEventListener('change',syncType);
    modeInput.addEventListener('change',updateReferenceRule);
    refInput.addEventListener('input',()=>{
      if(refInput.value.trim()){
        refInput.classList.remove('nl-reference-invalid');
        refInput.removeAttribute('aria-invalid');
        dismissReferenceToast();
        if(error&&/reference/i.test(error.textContent||''))showError('');
      }
    });
    amountInput.addEventListener('input',()=>{amountInput.setCustomValidity('');showError('');updatePreview();});
    document.querySelectorAll('[data-payment-fraction]').forEach(button=>button.addEventListener('click',()=>{
      if(!partialInput.checked)return;
      const cents=Math.round(balance*100), fraction=Number(button.dataset.paymentFraction);
      const recommended=Math.min(cents-1,Math.max(1,Math.round(cents*fraction)));
      if(recommended<=0){showError('The remaining balance is too small to split. Record a full payment.');return;}
      amountInput.value=(recommended/100).toFixed(2);
      amountInput.setCustomValidity('');showError('');updatePreview();amountInput.focus();
    }));
    form.addEventListener('submit',function(event){
      // Intercept only the review step; confirming below uses native submission
      // to avoid the shared form-lock handlers treating the review as sent.
      event.preventDefault();
      if(committing||!validate(true))return;
      const amount=Number(amountInput.value);
      set('reviewPaymentType',chosenType()==='FULL'?'Full payment':'Partial payment');
      set('reviewAmount',currency(amount));
      set('reviewMode',modeInput.selectedOptions[0]?.textContent.trim()||'Not selected');
      set('reviewReference',refInput.value.trim()||'Not required (cash)');
      set('reviewDate',dateInput.value);
      set('reviewBalance',currency(Math.max(0,roundCents(balance-amount))));
      set('reviewExpectedStatus',chosenType()==='FULL'?'Paid':'Partially paid');
      openReview();
    },true);
    cancel.addEventListener('click',closeReview);
    confirmButton.addEventListener('click',function(){
      if(committing)return;
      if(!validate(true)){closeReview(false);return;}
      committing=true;
      form.dataset.nlConfirmedByReview='true';
      confirmButton.disabled=true;
      confirmButton.textContent='Recording payment…';
      // Last-mile native submit is intentional: validation has run both here and
      // again in BillingActions, and the common QoL submit listener cannot block it.
      HTMLFormElement.prototype.submit.call(form);
    });
    dialog.addEventListener('click',event=>{if(event.target===dialog&&!committing)closeReview();});
    document.addEventListener('keydown',event=>{if(event.key==='Escape'&&!dialog.hidden&&!committing){event.preventDefault();closeReview();}});
    dialog.addEventListener('keydown',event=>{
      if(event.key!=='Tab')return;
      const controls=[cancel,confirmButton].filter(b=>!b.disabled);
      if(!controls.length)return;
      if(event.shiftKey&&document.activeElement===controls[0]){event.preventDefault();controls[controls.length-1].focus();}
      else if(!event.shiftKey&&document.activeElement===controls[controls.length-1]){event.preventDefault();controls[0].focus();}
    });
    updateReferenceRule();
    if(partialInput.checked)syncType();else updatePreview();
  }
  if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',initInvoicePaymentReview);
  else initInvoicePaymentReview();
})();
</script>
<jsp:include page="/WEB-INF/views/shared/footer.jsp"/>

</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>