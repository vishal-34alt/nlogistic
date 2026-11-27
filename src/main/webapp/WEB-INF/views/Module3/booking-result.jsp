<jsp:useBean id="nlViewSupport_Module3_booking_result" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module3_booking_result" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module3_booking_result" property="view" value="Module3/booking-result.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>



<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>
<style>
.nl-nextstep-panel{background:linear-gradient(125deg,#fffaf3,#fff,#f9ebdd);border:1px solid #e8c6a9;border-radius:23px;padding:clamp(18px,2.8vw,30px);box-shadow:0 18px 40px rgba(89,53,23,.09)}
.nl-next-eyebrow{font-size:.73rem;letter-spacing:.14em;font-weight:800;color:#b35b20}
.nl-next-total{padding:17px 20px;border-radius:14px;background:#412519;color:#fff;display:flex;align-items:center;gap:10px;flex-wrap:wrap}
.nl-next-total span{opacity:.82;font-size:.85rem}.nl-next-total strong{margin-left:auto;font-size:clamp(1.2rem,2vw,1.65rem)}.nl-next-total small{width:100%;opacity:.75}
.nl-next-options{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
.nl-next-choice{padding:22px 19px;border:1px solid #eed7c3;border-radius:18px;background:#fff;color:#513221;display:flex;align-items:flex-start;flex-direction:column;gap:10px;text-decoration:none;transition:transform .2s,border-color .2s,box-shadow .2s;min-height:215px}
.nl-next-choice:hover,.nl-next-choice:focus-visible{transform:translateY(-4px);border-color:#df782f;box-shadow:0 16px 26px rgba(158,80,29,.15);color:#432516}
.nl-next-choice strong{font-size:1.11rem}.nl-next-choice span:not(.nl-next-icon){font-size:.85rem;color:#745a49;line-height:1.5}
.nl-next-choice b{margin-top:auto;color:#b64e13;font-size:.83rem}.nl-next-icon{display:grid;place-items:center;width:40px;height:40px;background:#ffeddb;color:#a84815;border-radius:12px;font-weight:900}
@media(max-width:860px){.nl-next-options{grid-template-columns:1fr}.nl-next-choice{min-height:0}}
@media(prefers-reduced-motion:reduce){.nl-next-choice{transition:none}.nl-next-choice:hover{transform:none}}

/* Payment-choice modal: keep styles inside the HTML head for Eclipse JSP validation. */
.nl-payment-backdrop{position:fixed;inset:0;z-index:1095;background:rgba(29,19,13,.62);backdrop-filter:blur(3px)}
#payment-options.nl-payment-modal{position:fixed;z-index:1100;top:50%;left:50%;transform:translate(-50%,-50%);width:min(96vw,920px);max-height:calc(100vh - 36px);overflow:auto;margin:0!important;background:#fffaf5;box-shadow:0 28px 100px #1c0d086e}
#payment-options.nl-payment-modal[hidden]{display:none!important}
@media(max-width:650px){#payment-options.nl-payment-modal{top:auto;bottom:0;left:0;width:100%;max-height:92dvh;transform:none;border-radius:21px 21px 0 0}}

/* v17.4 layout and usability corrections */

.nl-booking-primary-action,.nl-booking-secondary-action{min-height:49px!important;padding:12px 21px!important;font-size:.99rem!important;font-weight:800!important;border-radius:12px!important;margin-top:12px;line-height:1.25;white-space:normal;text-align:center}
.nl-booking-primary-action{box-shadow:0 9px 21px #bb4d172c}.nl-booking-primary-action span{font-size:1.1rem}
.nl-booking-secondary-action{border:1px solid #e7bb9f!important;background:#fffaf5!important;color:#814326!important}
@media(max-width:600px){.nl-booking-primary-action,.nl-booking-secondary-action{width:100%;margin-left:0!important}}


/* v17.9 | Quote review: legible statistics, compact card spacing, clear actions. */
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card{border:1px solid #edd6c2!important;border-radius:20px!important;box-shadow:0 11px 27px rgba(98,52,23,.065)!important;padding:12px 14px!important;margin-bottom:16px!important;background:#fffdfa!important}
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card>.card-body{padding:18px 20px!important}
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card h5{font-size:1.14rem!important;color:#3b2a20!important}
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card .row>div small{display:block;font-size:.8rem;color:#8b6751!important;margin:0 0 7px}
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card .row>div h6,body[data-nl-screen="module3-booking-result"] .nl-view-body>.card .row>div .fw-semibold{font-size:1.08rem!important;line-height:1.4!important;color:#3d261b!important;overflow-wrap:anywhere}
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card .row>div{min-width:0}
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card table{font-size:.95rem}
body[data-nl-screen="module3-booking-result"] .nl-view-body>.card table td{padding:13px 16px}
.nl-quote-guide{display:flex;align-items:center;flex-wrap:wrap;gap:10px 13px;background:linear-gradient(112deg,#fff2e3,#fffaf4);border:1px solid #edcfb6;border-radius:15px;padding:14px 19px;margin:12px 0 17px;color:#7a604e;font-size:.88rem;font-weight:700}
.nl-quote-step-done{color:#447145}.nl-quote-step-current{color:#a84917;font-weight:850}.nl-quote-guide-arrow{opacity:.5;font-weight:900}
.nl-final-confirm{border:1px solid #e7b88f!important;background:linear-gradient(118deg,#fffaf5,#fff0e3)!important}
.nl-final-confirm form:not(#nlEditBooking){display:flex;flex-wrap:wrap;align-items:center;gap:11px}
.nl-final-confirm .nl-booking-primary-action,.nl-final-confirm .nl-booking-secondary-action{margin:6px 0 0!important;min-height:47px!important}
.nl-final-confirm .nl-booking-primary-action{background:linear-gradient(110deg,#b83a06,#ed6a13)!important;color:#fff!important;border:none!important}
.nl-final-confirm p{max-width:810px;line-height:1.55;color:#755d4e}
@media(max-width:640px){.nl-quote-guide-arrow{display:none}.nl-quote-guide{flex-direction:column;align-items:flex-start}.nl-final-confirm form:not(#nlEditBooking)>button{width:100%}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-final-confirm,html[data-nl-mode="dark"] body.nl-themed-page .nl-nextstep-panel,html[data-nl-mode="dark"] body.nl-themed-page .nl-next-choice,html[data-nl-mode="dark"] body.nl-themed-page .nl-quote-guide,html[data-nl-mode="dark"] body.nl-themed-page .nl-payment-modal,html[data-nl-mode="dark"] body.nl-themed-page .nl-quote-step-current,html[data-nl-mode="dark"] body.nl-themed-page .nl-quote-step-done{background:#203044!important;background-image:none!important;color:#edf4fc!important;border-color:#516b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-final-confirm :is(h2,h3,p,strong,span),html[data-nl-mode="dark"] body.nl-themed-page .nl-nextstep-panel :is(h2,h3,p,strong,span){color:#edf4fc!important}

/* v20.26: Freight includes purchased goods. The total is the payable invoice amount. */
body[data-nl-screen="module3-booking-result"] .nl-quote-component-row td{background:#fff7ed!important;border-color:#eed7c2!important;color:#795742!important;font-size:.85rem}
body[data-nl-screen="module3-booking-result"] .nl-quote-logistics-row td{background:#fff1e0!important;color:#4b2e1d!important;font-weight:850!important}
body[data-nl-screen="module3-booking-result"] .nl-quote-note{margin:13px 0 0!important;padding:12px 14px;background:#fff9f1;border:1px solid #ecd6c1;border-radius:12px;color:#735440!important;font-size:.83rem;line-height:1.55}
body[data-nl-screen="module3-booking-result"] .nl-quote-note strong{color:#92511e}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking-result"] :is(.nl-quote-component-row,.nl-quote-logistics-row) td{background:#293b4d!important;color:#eaf1f9!important;border-color:#4d6478!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking-result"] .nl-quote-note{background:#26384b!important;color:#cfdbe8!important;border-color:#496175!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking-result"] .nl-quote-note strong{color:#ffc18a!important}
</style></head><body data-nl-screen="module3-booking-result" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module3_booking_result__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">

<jsp:include page="/WEB-INF/views/shared/header.jsp">
    <jsp:param name="pageTitle" value="Booking Result" />
    <jsp:param name="pageSubtitle" value="Review your booking quotation and shipment details." />
    <jsp:param name="activeModule" value="bookings" />
    <jsp:param name="navBookingsUrl" value="/ContainerAllocationPricingController?module=booking" />
</jsp:include>

<jsp:include page="/WEB-INF/views/shared/tabs.jsp">
    <jsp:param name="module" value="bookings" />
    <jsp:param name="activeTab" value="create" />
    <jsp:param name="tab1Key" value="create" />
    <jsp:param name="tab1Label" value="New booking" />
    <jsp:param name="tab1Url" value="/ContainerAllocationPricingController?module=booking" />
    <jsp:param name="tab1Roles" value="CONSUMER" />
    <jsp:param name="tab2Key" value="containers" />
    <jsp:param name="tab2Label" value="Containers" />
    <jsp:param name="tab2Url" value="/ContainerAllocationPricingController?module=container" />
    <jsp:param name="tab2Roles" value="SELLER" />
    <jsp:param name="tab3Key" value="pricing" />
    <jsp:param name="tab3Label" value="Pricing rules" />
    <jsp:param name="tab3Url" value="/ContainerAllocationPricingController?module=pricing" />
    <jsp:param name="tab3Roles" value="SELLER" />
</jsp:include>

${requestScope.nlv_Module3_booking_result__2}

${requestScope.nlv_Module3_booking_result__3}
<nav class="nl-booking-steps d-flex flex-wrap gap-2 mb-4" aria-label="Booking progress">
  <span class="nl-booking-step active badge bg-warning-subtle border text-dark p-2 rounded-pill">✓ 1. Goods</span>
  <span class="nl-booking-step active badge bg-warning-subtle border text-dark p-2 rounded-pill">✓ 2. Route</span>
  <span class="nl-booking-step active badge bg-warning-subtle border text-dark p-2 rounded-pill">✓ 3. Availability</span>
  <span class="nl-booking-step active badge bg-warning-subtle border text-dark p-2 rounded-pill">✓ 4. Pricing</span>
  <span class="nl-booking-step badge bg-warning-subtle border text-dark p-2 rounded-pill ${requestScope.nlv_Module3_booking_result__4}">${requestScope.nlv_Module3_booking_result__5} Confirmation</span>
</nav>
<div class="mb-4">
                <h4 class="fw-bold text-dark mb-1">Booking Result</h4>
                <p class="text-secondary mb-0">
                    Review your booking quotation and shipment details.
                </p>
            </div>

            ${requestScope.nlv_Module3_booking_result__6}
            <span id="nlQuoteGoodsMeta" hidden="hidden" data-goods-value="${requestScope.bookingResult.goodsValue}" data-shipping-value="${requestScope.bookingResult.shippingFreightOnly}" data-gst-rate="${requestScope.bookingResult.taxRatePercent}"></span>

            ${requestScope.nlv_Module3_booking_result__7}

            ${requestScope.nlv_Module3_booking_result__8}

</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>


<script>
(function(){'use strict';
 var pane=document.getElementById('payment-options'),openBtn=document.getElementById('nlReopenPayment'),closeBtn=document.getElementById('nlDismissPayment');
 if(!pane||!openBtn||!closeBtn)return;
 var overlay=document.createElement('div');overlay.className='nl-payment-backdrop';overlay.hidden=true;overlay.setAttribute('aria-hidden','true');
 var origin=pane.parentNode,after=pane.nextSibling,focusBefore=null;
 function show(){focusBefore=document.activeElement;document.body.appendChild(pane);document.body.appendChild(overlay);pane.classList.add('nl-payment-modal');pane.hidden=false;overlay.hidden=false;document.body.style.overflow='hidden';closeBtn.focus();}
 function hide(){pane.hidden=true;overlay.hidden=true;document.body.style.overflow='';origin.insertBefore(pane,after);pane.classList.remove('nl-payment-modal');(focusBefore&&focusBefore.isConnected?focusBefore:openBtn).focus();}
 openBtn.addEventListener('click',show);closeBtn.addEventListener('click',hide);overlay.addEventListener('click',hide);
 document.addEventListener('keydown',function(e){if(pane.hidden)return;if(e.key==='Escape'){e.preventDefault();hide();}if(e.key==='Tab'){var choices=Array.from(pane.querySelectorAll('a[href],button:not([disabled])'));if(!choices.length)return;var first=choices[0],last=choices[choices.length-1];if(e.shiftKey&&document.activeElement===first){e.preventDefault();last.focus();}else if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first.focus();}}});
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',show,{once:true});else show();
})();
</script>


<script>
/* The approved Model includes goods in Freight Amount and persists invoice totals.
   This UI only explains the components; it never changes a payable amount. */
(function(){'use strict';
 function decorateQuotation(){
  var meta=document.getElementById('nlQuoteGoodsMeta');
  if(!meta)return;
  var goods=Number(meta.getAttribute('data-goods-value'));
  var shipping=Number(meta.getAttribute('data-shipping-value'));
  var gstRate=Number(meta.getAttribute('data-gst-rate'));
  if(!Number.isFinite(goods)||!Number.isFinite(shipping)||!Number.isFinite(gstRate)||gstRate<0||gstRate>100||goods<0||shipping<0||
     !meta.getAttribute('data-goods-value')||!meta.getAttribute('data-shipping-value'))return;
  var card=Array.from(document.querySelectorAll('.nl-view-body .card')).find(function(el){
   var heading=el.querySelector('h5,h2');return heading&&heading.textContent.trim().toLowerCase()==='your quotation';
  });
  if(!card)return;
  var table=card.querySelector('table tbody');if(!table||table.querySelector('.nl-quote-component-row'))return;
  var freightRow=Array.from(table.querySelectorAll('tr')).find(function(tr){
   return /^freight amount$/i.test(tr.querySelector('td')?.textContent.trim()||'');
  });
  var totalRow=Array.from(table.querySelectorAll('tr')).find(function(tr){
   return /^quotation total$/i.test(tr.querySelector('td')?.textContent.trim()||'');
  });
  if(!freightRow||!totalRow)return;
  var formatter=new Intl.NumberFormat('en-IN',{minimumFractionDigits:2,maximumFractionDigits:2});
  function detail(label,amount){
   var tr=document.createElement('tr');tr.className='nl-quote-component-row';
   var text=document.createElement('td');text.textContent=label;
   var value=document.createElement('td');value.className='text-end';value.textContent='Rs. '+formatter.format(amount);
   tr.append(text,value);return tr;
  }
  freightRow.querySelector('td').textContent='Freight Amount (goods + shipping)';
  freightRow.insertAdjacentElement('afterend',detail('  ↳ Goods value included',goods));
  freightRow.nextElementSibling.insertAdjacentElement('afterend',detail('  ↳ Shipping charges included',shipping));
  totalRow.classList.add('nl-quote-logistics-row');
  totalRow.querySelector('td').textContent='Quotation Total / Invoice Payable';
  var taxRow=Array.from(table.querySelectorAll('tr')).find(function(tr){
   return /^tax amount$/i.test(tr.querySelector('td')?.textContent.trim()||'');
  });
  if(taxRow){taxRow.querySelector('td').textContent='Tax Amount ('+gstRate.toLocaleString('en-IN',{maximumFractionDigits:2})+'% of goods + shipping + handling)';}
  var note=document.createElement('p');note.className='nl-quote-note';
  var label=document.createElement('strong');label.textContent='Billing breakdown: ';
  note.append(label,document.createTextNode('Purchased goods and shipping are included once in Freight Amount. The '+gstRate.toLocaleString('en-IN',{maximumFractionDigits:2})+'% GST rate is retrieved from the database and applied to goods, shipping and handling. The quotation total is the invoice payable amount. Actual GST treatment may vary by product HSN and export status.'));
  table.closest('.table-responsive')?.insertAdjacentElement('afterend',note);
 }
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',decorateQuotation,{once:true});else decorateQuotation();
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
