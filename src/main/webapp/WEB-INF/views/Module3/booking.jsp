<jsp:useBean id="nlViewSupport_Module3_booking" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module3_booking" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module3_booking" property="view" value="Module3/booking.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>



<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>

<style>
/* Module 3: booking planning assistance. Kept inside this JSP by faculty requirement. */
.nl-booking-guidance{padding:clamp(16px,2vw,25px);border:1px solid #e9d3bf;border-radius:19px;background:linear-gradient(140deg,#fff8ee,#fffdf8);box-shadow:0 8px 27px #6638160a}
.nl-booking-guidance h6{color:#562d1c}.nl-guidance-tag{display:inline-flex;align-items:center;gap:5px;min-height:32px;padding:6px 11px;border-radius:50px;background:#fff0de;border:1px solid #edcba9;color:#914517;font-size:.75rem;font-weight:750}
.nl-booking-metrics{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px}
.nl-booking-metrics>div{background:#fff;border:1px solid #eadaca;border-radius:13px;padding:17px 19px;min-width:0;transition:transform .2s,border-color .2s}
.nl-booking-metrics>div:hover{transform:translateY(-3px);border-color:#e6b78e}
.nl-booking-metrics span{display:block;font-size:.76rem;color:#896d5c;margin-bottom:5px}
.nl-booking-metrics strong{font-size:clamp(1.03rem,1.6vw,1.3rem);color:#44291d;font-variant-numeric:tabular-nums}
.nl-guidance-lanes{display:grid;grid-template-columns:1fr 1fr;gap:15px}
.nl-guidance-lanes>div{border-radius:12px;border:1px solid #f1e0ce;background:#ffffffb8;padding:14px 16px;min-width:0}
.nl-qty-chip{border-radius:999px!important;border:1px solid #dbae88!important;background:#fff!important;color:#934518!important;padding:7px 14px!important;font-weight:700!important;font-size:.78rem!important}
.nl-qty-chip:hover,.nl-qty-chip:focus-visible{background:#c4541f!important;color:#fff!important;transform:translateY(-2px)}
.nl-guidance-foot{font-size:.75rem;color:#8e6550}
.nl-booking-routes{background:linear-gradient(140deg,#fffdfa,#fff3e5)!important}
.nl-route-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(235px,1fr));gap:12px}
.nl-route-card{display:flex;flex-direction:column;gap:10px;text-align:left;border:1px solid #ecd6be;background:#fff;border-radius:15px;padding:16px;min-height:156px;transition:transform .2s,border-color .2s,box-shadow .2s}
.nl-route-card:hover,.nl-route-card:focus-visible{border-color:#d96b30;transform:translateY(-3px);box-shadow:0 10px 20px #c96b2424}
.nl-route-card[aria-pressed=true]{border:2px solid #d65f1e;background:#fff8ef;box-shadow:0 0 0 3px #efbb8a3a}
.nl-route-card strong{color:#4e2e1b;font-size:.9rem}.nl-route-card small{font-size:.77rem;color:#846b5b;line-height:1.55}
.nl-route-path{display:flex;align-items:center;gap:8px;font-weight:800;color:#b64c1e}
.nl-route-arrow{color:#e06e24;font-weight:900}
.nl-route-empty{border:1px dashed #dfbfa7;border-radius:13px;padding:19px;color:#80614e;background:#fffbf6;font-size:.88rem}
@media(max-width:760px){.nl-booking-metrics{grid-template-columns:1fr}.nl-guidance-lanes{grid-template-columns:1fr}}
@media(prefers-reduced-motion:reduce){.nl-route-card,.nl-booking-metrics>div{transition:none;transform:none!important}}

.nl-product-picker{position:relative;isolation:isolate}.nl-product-query{min-height:48px!important;border-radius:12px!important;background:#fffdf9!important;border:1px solid #dcaa83!important;padding:11px 14px!important;font-size:.96rem!important}
.nl-product-query:focus{border-color:#c95416!important;box-shadow:0 0 0 3px #e8732630!important}
.nl-product-suggestions{position:absolute;inset:auto 0 auto 0;top:calc(100% + 5px);z-index:1010;max-height:310px;overflow-y:auto;overscroll-behavior:contain;background:#fffefa;border:1px solid #e7c4a7;border-radius:13px;padding:6px;box-shadow:0 18px 37px rgba(81,36,13,.18)}
.nl-product-suggestions[hidden]{display:none!important}
.nl-product-choice{display:block;width:100%;border:0;background:transparent;text-align:left;border-radius:9px;color:#493023;padding:11px 12px;font-size:.9rem;line-height:1.35;overflow-wrap:anywhere}
.nl-product-choice:hover,.nl-product-choice.is-active,.nl-product-choice[aria-selected=true]{background:#ffead7;color:#873812}.nl-product-empty{padding:13px;color:#795f4a;font-size:.86rem}


/* v17.9 | Booking planner consistency and readable route selection. */
.nl-resumed-booking{display:flex;align-items:center;gap:13px;margin:14px 0 21px;padding:15px 18px;border:1px solid #c6ddb9;border-radius:13px;background:#f5faef;color:#385b31;font-size:.94rem}
.nl-resumed-booking p{color:#59734f;font-size:.84rem;line-height:1.4}
.nl-resumed-dot{display:grid;place-items:center;flex:0 0 34px;height:34px;border-radius:50%;background:#e0edda;color:#3c7138;font-size:1.15rem;font-weight:900}
body[data-nl-screen="module3-booking"] .nl-view-body>.card{border:1px solid #e9d4c4!important;border-radius:18px!important;background:#fffdfa!important;box-shadow:0 10px 26px rgba(81,40,14,.06)!important}
body[data-nl-screen="module3-booking"] .nl-view-body .form-label{font-size:.91rem;color:#4b3426}
body[data-nl-screen="module3-booking"] .nl-view-body .form-control,body[data-nl-screen="module3-booking"] .nl-view-body .form-select{min-height:46px!important;border-color:#dfc4af;border-radius:11px!important;font-size:.95rem}
body[data-nl-screen="module3-booking"] .nl-view-body .form-control:focus,body[data-nl-screen="module3-booking"] .nl-view-body .form-select:focus{border-color:#de6d27;box-shadow:0 0 0 3px #e274252e}
.nl-route-grid{grid-template-columns:repeat(auto-fit,minmax(255px,1fr));gap:13px}
.nl-route-card{min-height:178px!important;padding:17px 16px!important;border-radius:14px!important;gap:9px!important}
.nl-route-path{gap:7px!important;flex-wrap:wrap;font-size:.93rem!important;line-height:1.35}
.nl-route-card strong{font-size:.91rem!important}
.nl-route-card small{font-size:.82rem!important}
.nl-route-card[aria-pressed="true"]{border-color:#db6925!important;box-shadow:0 6px 18px #b8602624!important;background:#fff7ef!important}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-booking-guidance,html[data-nl-mode="dark"] body.nl-themed-page .nl-booking-metrics,html[data-nl-mode="dark"] body.nl-themed-page .nl-booking-routes,html[data-nl-mode="dark"] body.nl-themed-page .nl-route-card,html[data-nl-mode="dark"] body.nl-themed-page .nl-product-suggestions,html[data-nl-mode="dark"] body.nl-themed-page .nl-guidance-lanes,html[data-nl-mode="dark"] body.nl-themed-page .nl-resumed-booking{background:#203044!important;background-image:none!important;color:#edf4fc!important;border-color:#516b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-product-choice,html[data-nl-mode="dark"] body.nl-themed-page .nl-guidance-tag,html[data-nl-mode="dark"] body.nl-themed-page .nl-qty-chip{background:#2b3e52!important;color:#f1f6fd!important;border-color:#59738b!important}

/* v19.8 — Booking page: remove redundant single-tab nav and give the actual workflow priority. */
body[data-nl-screen="module3-booking"] .nl-booking-workflow-head{display:flex;align-items:center;justify-content:space-between;gap:18px;flex-wrap:wrap;background:linear-gradient(120deg,#fffdfa,#fff1e2);border:1px solid #e9ceb9;border-radius:18px;padding:22px 26px;margin:0 0 16px;box-shadow:0 9px 26px rgba(77,39,12,.055)}
body[data-nl-screen="module3-booking"] .nl-booking-workflow-copy{flex:1;min-width:225px}
body[data-nl-screen="module3-booking"] .nl-booking-eyebrow{font-size:.71rem;font-weight:850;letter-spacing:.14em;color:#a44b16;margin-bottom:7px}
body[data-nl-screen="module3-booking"] .nl-booking-workflow-copy h2{font-size:clamp(1.45rem,2.4vw,2rem);margin:0 0 7px;font-weight:850;letter-spacing:-.025em;color:#30241f}
body[data-nl-screen="module3-booking"] .nl-booking-workflow-copy p{margin:0;color:#735b4f;max-width:650px;line-height:1.5;font-size:.91rem}
body[data-nl-screen="module3-booking"] .nl-booking-workflow-note{display:flex;gap:11px;align-items:center;max-width:270px;border:1px solid #edd3b9;background:#fffaf4;border-radius:13px;padding:13px 15px}
body[data-nl-screen="module3-booking"] .nl-booking-workflow-mark{display:grid;place-items:center;flex:0 0 32px;height:32px;border-radius:10px;background:#e8f4e6;color:#397145;font-weight:900}
body[data-nl-screen="module3-booking"] .nl-booking-workflow-note strong{display:block;font-size:.81rem;color:#543324;line-height:1.25}
body[data-nl-screen="module3-booking"] .nl-booking-workflow-note small{display:block;color:#806959;line-height:1.4;margin-top:3px}
body[data-nl-screen="module3-booking"] .nl-booking-steps{display:grid!important;grid-template-columns:repeat(5,minmax(0,1fr));gap:9px!important;background:#fffaf5;border:1px solid #efd7c2;border-radius:17px;padding:13px!important;box-shadow:0 6px 15px rgba(90,45,17,.04);margin:0 0 11px!important}
body[data-nl-screen="module3-booking"] .nl-booking-step{display:flex;align-items:center;justify-content:center;min-width:0;min-height:37px;white-space:normal;text-align:center;line-height:1.25;border:1px solid #e9d4c2!important;border-radius:10px!important;background:#fffdfb!important;color:#7c5a46!important;font-size:.78rem!important;padding:8px 4px!important;font-weight:750}
body[data-nl-screen="module3-booking"] .nl-booking-step.active{background:linear-gradient(110deg,#c3460c,#e96f13)!important;color:#fff!important;border-color:#cd5218!important;box-shadow:0 4px 12px rgba(173,65,11,.18)}
body[data-nl-screen="module3-booking"] .nl-booking-help{background:transparent;border:1px solid #e9d5c1;border-radius:13px;padding:0 15px;color:#624736;margin-bottom:17px!important}
body[data-nl-screen="module3-booking"] .nl-booking-help summary{list-style:none;display:flex;align-items:center;justify-content:space-between;min-height:42px;gap:12px;font-weight:750;font-size:.82rem;color:#814017}
body[data-nl-screen="module3-booking"] .nl-booking-help summary::-webkit-details-marker{display:none}
body[data-nl-screen="module3-booking"] .nl-booking-help p{font-size:.86rem;line-height:1.6;border-top:1px solid #edd9c6;padding:12px 0 14px;margin:0;color:#725a4a}
body[data-nl-screen="module3-booking"] .nl-booking-help-chevron{font-size:1.14rem;transition:transform .18s}
body[data-nl-screen="module3-booking"] .nl-booking-help[open] .nl-booking-help-chevron{transform:rotate(180deg)}
body[data-nl-screen="module3-booking"] .nl-view-body>.card{box-shadow:0 7px 24px rgba(77,38,14,.045)!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-booking-workflow-head,.nl-booking-steps,.nl-booking-help,.nl-booking-workflow-note){background:#203044!important;background-image:none!important;border-color:#476178!important;box-shadow:none!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-booking-workflow-copy h2,.nl-booking-workflow-note strong){color:#f2f6fc!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-booking-workflow-copy p,.nl-booking-workflow-note small,.nl-booking-help p){color:#c6d4e4!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-booking-step:not(.active){background:#293c51!important;color:#dce7f2!important;border-color:#51697f!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-booking-help summary{color:#f0b07e!important}
@media(max-width:700px){body[data-nl-screen="module3-booking"] .nl-booking-workflow-head{padding:17px}body[data-nl-screen="module3-booking"] .nl-booking-workflow-note{max-width:none;width:100%}body[data-nl-screen="module3-booking"] .nl-booking-steps{grid-template-columns:repeat(3,minmax(0,1fr))}}
@media(max-width:410px){body[data-nl-screen="module3-booking"] .nl-booking-steps{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(prefers-reduced-motion:reduce){body[data-nl-screen="module3-booking"] .nl-booking-help-chevron{transition:none}}

/* v20.2: Searchable origin/destination port comboboxes. Existing select values submit unchanged port IDs. */
body[data-nl-screen="module3-booking"] .nl-port-picker{position:relative;min-width:0}
body[data-nl-screen="module3-booking"] .nl-port-query{padding-right:44px!important;background:#fffdf9!important;color:#3f2b22!important}
body[data-nl-screen="module3-booking"] .nl-port-query::-webkit-search-cancel-button{cursor:pointer}
body[data-nl-screen="module3-booking"] .nl-port-mark{position:absolute;right:15px;top:13px;pointer-events:none;color:#b34b14;font-size:1.03rem;font-weight:900}
body[data-nl-screen="module3-booking"] .nl-port-options{position:absolute;top:calc(100% + 6px);left:0;right:0;z-index:1080;max-height:288px;overflow:auto;overscroll-behavior:contain;background:#fffdf9;border:1px solid #e0b795;border-radius:13px;box-shadow:0 18px 38px #4c290b35;padding:6px}
body[data-nl-screen="module3-booking"] .nl-port-options[hidden]{display:none!important}
body[data-nl-screen="module3-booking"] .nl-port-choice{display:block;width:100%;text-align:left;border:0;border-radius:9px;padding:10px 12px;background:transparent;color:#3b291e;font-weight:600;font-size:.87rem;line-height:1.35;overflow-wrap:anywhere}
body[data-nl-screen="module3-booking"] .nl-port-choice:hover,body[data-nl-screen="module3-booking"] .nl-port-choice.is-active{background:#fff0e1;color:#a3430b}
body[data-nl-screen="module3-booking"] .nl-port-empty{padding:12px;color:#74594b;font-size:.86rem}
body[data-nl-screen="module3-booking"] .nl-port-help{font-size:.76rem;margin-top:6px;color:#795f50}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-query{background:#172637!important;color:#edf4ff!important;border-color:#557087!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-options{background:#24364a!important;border-color:#58718a!important;box-shadow:0 18px 38px #07101ca8!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-choice{color:#edf4ff!important;background:transparent!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-choice:hover,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-choice.is-active{background:#354c65!important;color:#fff2df!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-help,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-empty{color:#c7d5e6!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-port-mark{color:#f6a96f!important}

/* v20.3: Enhanced booking-date calendar. The original date inputs remain intact without JavaScript. */
body[data-nl-screen="module3-booking"] .nl-booking-date-wrap{position:relative;min-width:0}
body[data-nl-screen="module3-booking"] .nl-booking-date-wrap>.nl-cal-trigger{
  display:flex!important;align-items:center!important;justify-content:space-between!important;gap:12px;
  width:100%!important;min-height:54px!important;text-align:left!important;padding:8px 13px!important;
  border:1px solid #dcbfa6!important;border-radius:12px!important;background:#fffefa!important;
  color:#3b2b23!important;box-shadow:none!important;transform:none!important;
  font-size:.92rem!important;letter-spacing:0!important;font-weight:650!important;
}
body[data-nl-screen="module3-booking"] .nl-cal-trigger:hover{border-color:#cb7a42!important;background:#fffaf3!important}
body[data-nl-screen="module3-booking"] .nl-cal-trigger:focus-visible,body[data-nl-screen="module3-booking"] .nl-cal-trigger[aria-expanded="true"]{outline:0!important;border-color:#dc6720!important;box-shadow:0 0 0 3px #e76a2630!important}
body[data-nl-screen="module3-booking"] .nl-cal-trigger.nl-cal-invalid{border-color:#b42318!important;box-shadow:0 0 0 3px #f0443825!important}
body[data-nl-screen="module3-booking"] .nl-cal-label{display:grid;gap:2px;min-width:0;line-height:1.2}
body[data-nl-screen="module3-booking"] .nl-cal-label strong{font-size:.94rem;font-weight:760;color:inherit;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
body[data-nl-screen="module3-booking"] .nl-cal-label small{font-size:.72rem;color:#8a6b58;font-weight:550}
body[data-nl-screen="module3-booking"] .nl-cal-trigger.nl-cal-empty .nl-cal-label strong{color:#977d6c;font-weight:550}
body[data-nl-screen="module3-booking"] .nl-cal-icon{flex:0 0 35px;display:grid;place-items:center;width:35px;height:35px;border-radius:10px;background:#fff0e2;border:1px solid #f0cdae;color:#bc4b0c;font-size:1.15rem;line-height:1}
body[data-nl-screen="module3-booking"] .nl-cal-validation{display:none;margin-top:5px;color:#a52d1d;font-size:.78rem;font-weight:650}
body[data-nl-screen="module3-booking"] .nl-cal-validation:not(:empty){display:block}

/* The calendar floats under document.body: it cannot be clipped by booking cards or the fixed header. */
body[data-nl-screen="module3-booking"] .nl-booking-calendar{position:fixed;z-index:11050;width:min(356px,calc(100vw - 20px));max-height:min(540px,calc(100dvh - 16px));overflow:auto;overscroll-behavior:contain;
  background:#fffdf9!important;color:#37291e!important;border:1px solid #e7bea0!important;border-radius:19px!important;
  padding:16px!important;box-shadow:0 20px 60px #3e210c3d,0 3px 12px #6b341c16!important;
  font-family:inherit;}
body[data-nl-screen="module3-booking"] .nl-booking-calendar[hidden]{display:none!important}
body[data-nl-screen="module3-booking"] .nl-booking-calendar::before{content:"";position:absolute;left:16px;right:16px;top:0;height:3px;border-radius:0 0 6px 6px;background:linear-gradient(90deg,#c3420d,#f59c4a)}
body[data-nl-screen="module3-booking"] .nl-cal-top{display:flex;align-items:center;justify-content:space-between;gap:8px;margin:1px 0 11px}
body[data-nl-screen="module3-booking"] .nl-cal-heading{font-size:.78rem;font-weight:850;letter-spacing:.055em;text-transform:uppercase;color:#a64b20;line-height:1.3}
body[data-nl-screen="module3-booking"] .nl-cal-subheading{display:block;margin-top:3px;font-size:.72rem;font-weight:500;letter-spacing:0;text-transform:none;color:#8e7463}
body[data-nl-screen="module3-booking"] .nl-cal-close{display:grid!important;place-items:center!important;width:30px!important;height:30px!important;min-height:30px!important;padding:0!important;border:1px solid #efd4c0!important;border-radius:9px!important;background:#fff5ec!important;color:#8d482a!important;font-size:1.1rem!important;box-shadow:none!important;transform:none!important}
body[data-nl-screen="module3-booking"] .nl-cal-monthbar{display:grid;grid-template-columns:34px minmax(0,1fr) 34px;gap:8px;align-items:center;margin:8px 0 15px}
body[data-nl-screen="module3-booking"] .nl-cal-selectors{display:grid;grid-template-columns: minmax(0,1.2fr) minmax(0,.8fr);gap:6px;min-width:0}
body[data-nl-screen="module3-booking"] .nl-cal-selectors select{width:100%;min-width:0;height:37px;border:1px solid #ead0b9;border-radius:10px;background:#fff7ec;color:#40291e;font-size:.86rem;font-weight:780;padding:0 6px;cursor:pointer}
body[data-nl-screen="module3-booking"] .nl-cal-selectors select:focus-visible{outline:2px solid #db7629;outline-offset:1px}
body[data-nl-screen="module3-booking"] .nl-cal-nav{display:grid!important;place-items:center!important;width:34px!important;min-height:36px!important;padding:0!important;background:#fff4e7!important;border:1px solid #ebcbb2!important;border-radius:10px!important;color:#a3481c!important;font-size:1.45rem!important;line-height:1!important;box-shadow:none!important;transform:none!important}
body[data-nl-screen="module3-booking"] .nl-cal-nav:hover,body[data-nl-screen="module3-booking"] .nl-cal-close:hover{background:#ffe7d3!important}
body[data-nl-screen="module3-booking"] .nl-cal-weekdays,body[data-nl-screen="module3-booking"] .nl-cal-grid{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));gap:4px}
body[data-nl-screen="module3-booking"] .nl-cal-weekdays{border-bottom:1px solid #f0e1d4;padding-bottom:9px;margin-bottom:8px}
body[data-nl-screen="module3-booking"] .nl-cal-weekdays span{text-align:center;font-size:.68rem;font-weight:800;color:#997b65}
body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day{display:grid!important;place-items:center!important;width:100%!important;height:39px!important;aspect-ratio:auto!important;min-height:0!important;padding:0!important;border:1px solid transparent!important;border-radius:11px!important;background:transparent!important;color:#3c2d22!important;font-size:.85rem!important;font-weight:650!important;line-height:1!important;box-shadow:none!important;transform:none!important}
body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day:not(:disabled):hover,body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-keyfocus{background:#ffe9d5!important;color:#8c330f!important;border-color:#e4b38c!important}
body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-outside{color:#ac9a8b!important}
body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-today{border:1px solid #e9a567!important;color:#a74313!important;font-weight:850!important}
body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-selected{background:linear-gradient(135deg,#c4460d,#ec761e)!important;color:#fff!important;border-color:#d55d15!important;font-weight:850!important;box-shadow:0 4px 12px #d65a1b45!important}
body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day:disabled{color:#b1a8a0!important;background:#f5f1ed!important;opacity:.62!important;cursor:not-allowed!important}
body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day:focus-visible{outline:2px solid #d76622!important;outline-offset:1px!important}
body[data-nl-screen="module3-booking"] .nl-cal-footer{display:flex;align-items:center;justify-content:space-between;gap:8px;border-top:1px solid #f0e1d4;margin-top:12px;padding-top:12px}
body[data-nl-screen="module3-booking"] .nl-cal-tip{font-size:.69rem;color:#8a7362;line-height:1.3;max-width:180px}
body[data-nl-screen="module3-booking"] .nl-cal-actions{display:flex;align-items:center;gap:6px}
body[data-nl-screen="module3-booking"] .nl-cal-actions button{min-height:32px!important;padding:6px 11px!important;border-radius:9px!important;font-size:.75rem!important;line-height:1.2!important;font-weight:750!important;box-shadow:none!important;transform:none!important}
body[data-nl-screen="module3-booking"] .nl-cal-actions .nl-cal-clear{background:transparent!important;border:1px solid #ecc7aa!important;color:#a74c20!important}
body[data-nl-screen="module3-booking"] .nl-cal-actions .nl-cal-today{background:#d85a16!important;border:1px solid #cb5010!important;color:#fff!important}
body[data-nl-screen="module3-booking"] .nl-cal-actions .nl-cal-today:disabled{opacity:.5!important;cursor:not-allowed}

html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-trigger{background:#19293b!important;color:#f0f5fb!important;border-color:#536d83!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-trigger:hover{background:#24394d!important;border-color:#e2945d!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-label small{color:#b9c9d9!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-trigger.nl-cal-empty .nl-cal-label strong{color:#afc0d2!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-icon{background:#374a5c!important;color:#ffbd82!important;border-color:#587185!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-validation{color:#ffbcb1!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-booking-calendar{background:#203044!important;color:#f1f6fd!important;border-color:#5b7286!important;box-shadow:0 22px 60px #050c16a8!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-heading{color:#ffb781!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-subheading,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-tip{color:#c3d1df!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-cal-selectors select,.nl-cal-nav,.nl-cal-close){background:#2b4055!important;color:#f0f6ff!important;border-color:#60768d!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-cal-nav,.nl-cal-close):hover{background:#3a5269!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-cal-weekdays,.nl-cal-footer){border-color:#41576a!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-weekdays span{color:#b7c9da!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day{color:#f0f6ff!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-outside{color:#97abc0!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-today{color:#ffbe85!important;border-color:#ab7a53!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day:not(:disabled):hover,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-keyfocus{background:#40546a!important;border-color:#d28b59!important;color:#fff4e8!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day.nl-cal-selected{background:linear-gradient(130deg,#c54d11,#e67926)!important;color:#fff!important;border-color:#ed955d!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-grid button.nl-cal-day:disabled{background:#273647!important;color:#8aa0b3!important;opacity:.7!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-cal-actions .nl-cal-clear{background:#2b4055!important;color:#ffe1c6!important;border-color:#71869b!important}
@media(max-width:450px){body[data-nl-screen="module3-booking"] .nl-booking-calendar{padding:13px!important;border-radius:16px!important}body[data-nl-screen="module3-booking"] .nl-cal-tip{max-width:145px}}
@media(prefers-reduced-motion:reduce){body[data-nl-screen="module3-booking"] .nl-cal-trigger,body[data-nl-screen="module3-booking"] .nl-booking-calendar *{transition:none!important;animation:none!important}}


/* v20.4 — Full route directory above the Route Details form. */
body[data-nl-screen="module3-booking"] .nl-booking-routes{scroll-margin-top:112px}
body[data-nl-screen="module3-booking"] .nl-routes-intro{display:flex;justify-content:space-between;align-items:flex-start;gap:16px;flex-wrap:wrap;margin-bottom:17px}
body[data-nl-screen="module3-booking"] .nl-routes-eyebrow{display:block;font-weight:850;font-size:.69rem;letter-spacing:.13em;color:#b74e17;margin-bottom:5px}
body[data-nl-screen="module3-booking"] .nl-route-count{display:inline-flex;vertical-align:middle;padding:4px 9px;border-radius:999px;border:1px solid #e7c5a6;background:#fff0e0;font-size:.76rem;color:#90401a}
body[data-nl-screen="module3-booking"] .nl-route-tools{display:grid;grid-template-columns:minmax(200px,1fr) minmax(190px,240px);gap:11px;margin-bottom:12px}
body[data-nl-screen="module3-booking"] .nl-route-tool-search,body[data-nl-screen="module3-booking"] .nl-route-tool-sort{min-width:0}
body[data-nl-screen="module3-booking"] .nl-route-tools :is(input,select){width:100%;background:#fffdfa!important;color:#38271d!important;border:1px solid #e5c7ac!important;border-radius:11px!important;min-height:44px}
body[data-nl-screen="module3-booking"] .nl-route-headings{display:grid;grid-template-columns:minmax(0,2fr) minmax(108px,1fr) minmax(105px,1fr) minmax(155px,1.15fr) minmax(95px,.8fr);gap:12px;align-items:center;padding:10px 16px;border-radius:12px 12px 0 0;background:#f9e7d7;color:#7b4124;font-size:.73rem;font-weight:800;letter-spacing:.015em}
body[data-nl-screen="module3-booking"] .nl-route-grid{display:flex!important;flex-direction:column!important;gap:8px!important;max-height:510px;overflow:auto;overscroll-behavior:contain;padding:6px 2px 9px}
body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry{display:grid!important;grid-template-columns:minmax(0,2fr) minmax(108px,1fr) minmax(105px,1fr) minmax(155px,1.15fr) minmax(95px,.8fr)!important;gap:12px!important;align-items:center!important;min-height:78px!important;padding:13px 15px!important;border:1px solid #e7ccb4!important;border-radius:12px!important;background:#fffdfb!important;text-align:left;box-shadow:none!important;width:100%;color:#442f21!important;transition:border-color .15s,background .15s,transform .15s}
body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry:hover,body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry:focus-visible{transform:translateY(-1px);border-color:#d66a29!important;background:#fff5ed!important}
body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry[aria-pressed="true"]{border:2px solid #d75a16!important;background:#fff0e2!important}
body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-path{font-size:.84rem!important;gap:6px!important;display:flex;align-items:center;flex-wrap:wrap;color:#a74819!important}
body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-metric{display:block;font-size:.88rem;font-weight:800;color:#432d21}
body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-sub{display:block;font-size:.73rem!important;line-height:1.4;color:#816554!important;margin-top:4px}
body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-pick{display:inline-flex;align-items:center;justify-content:center;border-radius:9px;padding:10px 12px;background:linear-gradient(110deg,#bc450d,#e86b14);color:#fff!important;font-size:.8rem;font-weight:800;white-space:nowrap}
body[data-nl-screen="module3-booking"] .nl-route-disclaimer{border-top:1px solid #ebd7c4;padding-top:13px;color:#795c49}
body[data-nl-screen="module3-booking"] .nl-route-empty{margin:5px 0}
body[data-nl-screen="module3-booking"] #nlRouteDetails{scroll-margin-top:112px}
@media(max-width:970px){body[data-nl-screen="module3-booking"] .nl-route-headings{display:none}body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry{grid-template-columns:minmax(0,1.65fr) repeat(2,minmax(95px,.7fr))!important}body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-transit{grid-column:1 / span 2}body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-pick{grid-column:3;grid-row:2}}
@media(max-width:590px){body[data-nl-screen="module3-booking"] .nl-route-tools{grid-template-columns:1fr}body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry{grid-template-columns:repeat(2,minmax(0,1fr))!important;gap:11px!important}body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-path{grid-column:1/-1}body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-transit{grid-column:1}body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-pick{grid-column:2;grid-row:auto}body[data-nl-screen="module3-booking"] .nl-route-grid{max-height:535px}}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-route-tools input,.nl-route-tools select){background:#18283a!important;color:#eaf1fc!important;border-color:#506985!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] :is(.nl-route-headings,.nl-route-count){background:#2b3d50!important;color:#f3bb8f!important;border-color:#557089!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry{background:#233549!important;color:#f3f7fc!important;border-color:#4c6980!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry:hover,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-card.nl-route-entry[aria-pressed="true"]{background:#304257!important;border-color:#ef9046!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-entry :is(.nl-route-metric,.nl-route-path){color:#f5f7fc!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-entry .nl-route-sub{color:#c7d5e7!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-disclaimer{color:#c9d6e8!important;border-color:#50677c!important}

/* v20.5: Route Details first, scalable directory second, all inside one card. */
html body[data-nl-screen="module3-booking"] .nl-view-body section#nlRouteWorkspace.nl-route-workspace{overflow:visible!important;background:#fffdfa!important;border:1px solid #ead2be!important;box-shadow:0 12px 28px rgba(83,40,13,.065)!important}
body[data-nl-screen="module3-booking"] .nl-route-fields{padding:clamp(17px,2.5vw,29px);scroll-margin-top:115px}
body[data-nl-screen="module3-booking"] .nl-route-fields-inner{padding:0}
body[data-nl-screen="module3-booking"] .nl-route-fields h5{font-size:1.23rem;color:#30251e}
body[data-nl-screen="module3-booking"] .nl-route-directory{border:0!important;border-top:1px solid #ead6c5!important;border-radius:0 0 17px 17px!important;margin:0!important;padding:0!important;background:#fff8f0!important;background-image:none!important;box-shadow:none!important}
body[data-nl-screen="module3-booking"] .nl-route-directory-inner{padding:clamp(17px,2.5vw,29px)}
body[data-nl-screen="module3-booking"] .nl-route-tools{display:grid;grid-template-columns:minmax(200px,1fr) minmax(180px,240px) minmax(120px,155px);gap:12px;margin-bottom:11px}
body[data-nl-screen="module3-booking"] .nl-route-tool-label{display:block;font-size:.76rem;font-weight:750;color:#72503c;margin-bottom:6px}
body[data-nl-screen="module3-booking"] .nl-route-filterline{display:flex;align-items:center;gap:15px;flex-wrap:wrap;margin-bottom:14px}
body[data-nl-screen="module3-booking"] .nl-route-check{display:inline-flex;align-items:center;gap:9px;color:#53392a;font-size:.82rem;font-weight:650;cursor:pointer}
body[data-nl-screen="module3-booking"] .nl-route-check input{width:17px;height:17px;accent-color:#d65512;cursor:pointer}
body[data-nl-screen="module3-booking"] .nl-route-clear{background:transparent!important;background-image:none!important;color:#a64518!important;border:1px solid #e5c6aa!important;border-radius:9px;min-height:35px;padding:6px 13px;font-size:.78rem;font-weight:800;box-shadow:none!important}
body[data-nl-screen="module3-booking"] .nl-route-filterline #nlRouteResultsMessage{font-size:.79rem;color:#775b49;margin-left:auto}
body[data-nl-screen="module3-booking"] .nl-route-grid{max-height:none!important;overflow:visible!important;padding:5px 0 9px}
body[data-nl-screen="module3-booking"] .nl-route-pager{display:flex;align-items:center;justify-content:space-between;gap:10px;flex-wrap:wrap;border-top:1px solid #ebd7c6;padding:13px 0 6px;color:#664638;font-size:.8rem}
body[data-nl-screen="module3-booking"] .nl-route-pager[hidden],body[data-nl-screen="module3-booking"] .nl-route-selection[hidden]{display:none!important}
body[data-nl-screen="module3-booking"] .nl-route-page-controls{display:flex;gap:11px;align-items:center;flex-wrap:wrap}
body[data-nl-screen="module3-booking"] .nl-route-page-btn{display:inline-flex;align-items:center;justify-content:center;min-height:36px;padding:7px 12px;border:1px solid #e1bf9f;background:#fffaf4;background-image:none;border-radius:9px;color:#914117;font-weight:800;font-size:.8rem;box-shadow:none}
body[data-nl-screen="module3-booking"] .nl-route-page-btn:disabled{opacity:.45;cursor:not-allowed}
body[data-nl-screen="module3-booking"] .nl-route-page-btn:not(:disabled):hover{background:#fbe7d6}
body[data-nl-screen="module3-booking"] .nl-route-selection{display:flex;align-items:center;gap:10px;padding:11px 13px;margin-bottom:15px;border-radius:11px;border:1px solid #c6dcbd;background:#f2faef;color:#315c31;font-size:.83rem}
body[data-nl-screen="module3-booking"] .nl-route-selection-icon{flex:none;display:grid;place-items:center;width:26px;height:26px;border-radius:50%;background:#d9efd4;color:#2e6d35;font-weight:900}
body[data-nl-screen="module3-booking"] .nl-route-selection strong{display:block}body[data-nl-screen="module3-booking"] .nl-route-selection #nlRouteSelectedText{display:block;overflow-wrap:anywhere}
body[data-nl-screen="module3-booking"] .nl-route-pick{min-width:110px}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-view-body section#nlRouteWorkspace.nl-route-workspace,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-directory{background:#203044!important;background-image:none!important;border-color:#506780!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-fields h5{color:#f0f5fc!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-tool-label,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-check,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-filterline #nlRouteResultsMessage,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-pager{color:#dce8f6!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-pager{border-color:#506780!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-page-btn,html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-clear{background:#2a4056!important;color:#ffe2cd!important;border-color:#66809b!important;box-shadow:none!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-selection{background:#233b38!important;color:#d8f7dd!important;border-color:#4e8365!important}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl-route-selection-icon{background:#315e47!important;color:#c9f5d1!important}
@media(max-width:900px){body[data-nl-screen="module3-booking"] .nl-route-tools{grid-template-columns:minmax(160px,1fr) minmax(145px,1fr)}body[data-nl-screen="module3-booking"] .nl-route-tool-size{grid-column:1/-1;max-width:220px}}
@media(max-width:560px){body[data-nl-screen="module3-booking"] .nl-route-tools{grid-template-columns:1fr}body[data-nl-screen="module3-booking"] .nl-route-tool-size{grid-column:auto;max-width:none}body[data-nl-screen="module3-booking"] .nl-route-filterline #nlRouteResultsMessage{margin-left:0;width:100%}body[data-nl-screen="module3-booking"] .nl-route-pager{justify-content:center;text-align:center}body[data-nl-screen="module3-booking"] .nl-route-page-controls{justify-content:center}}


/* v20.23 - booking flow emphasis, calendar fields and route results */
body[data-nl-screen="module3-booking"] :is(.nl-route-workspace,.nl-booking-guidance,.nl-booking-workflow-head){border-radius:18px!important}
body[data-nl-screen="module3-booking"] .nl-booking-steps{gap:8px!important;flex-wrap:wrap!important}
body[data-nl-screen="module3-booking"] .nl-route-directory :is(.btn,button){min-height:38px}
body[data-nl-screen="module3-booking"] .nl23-route-hint{margin:7px 0 12px;color:#875b40}
html[data-nl-mode="dark"] body[data-nl-screen="module3-booking"] .nl23-route-hint{color:#edc5a3}
@media(max-width:650px){body[data-nl-screen="module3-booking"] .nl-booking-workflow-head{padding:17px!important}body[data-nl-screen="module3-booking"] .nl-booking-steps{position:static!important}}

</style>
</head><body data-nl-screen="module3-booking" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module3_booking__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">

<jsp:include page="/WEB-INF/views/shared/header.jsp">
    <jsp:param name="pageTitle" value="Create Booking" />
    <jsp:param name="pageSubtitle" value="Create a shipment booking and calculate or confirm its quotation." />
    <jsp:param name="activeModule" value="bookings" />
    <jsp:param name="navBookingsUrl" value="/ContainerAllocationPricingController?module=booking" />
</jsp:include>

<!-- Single-tab Bookings navigation removed: this screen is already Create booking.
     The main sidebar and all five booking steps remain available. -->

<section class="nl-booking-workflow-head" aria-label="Your booking workflow">
    <div class="nl-booking-workflow-copy">
        <div class="nl-booking-eyebrow">YOUR SHIPMENT · STEP 1 OF 5</div>
        <h2>Build your shipment</h2>
        <p>Choose goods and a route. You can review the live quotation before confirming anything.</p>
    </div>
    <div class="nl-booking-workflow-note"><span class="nl-booking-workflow-mark" aria-hidden="true">✓</span><div><strong>Review before you book</strong><small>No booking is created until you confirm the quote.</small></div></div>
</section>

${requestScope.nlv_Module3_booking__2}
            ${requestScope.nlv_Module3_booking__3}
            <nav class="nl-booking-steps d-flex flex-wrap gap-2 mb-3" aria-label="Booking progress"><span class="nl-booking-step active badge bg-warning-subtle border text-dark p-2 rounded-pill">1. Goods</span><span class="nl-booking-step badge bg-warning-subtle border text-dark p-2 rounded-pill">2. Route</span><span class="nl-booking-step badge bg-warning-subtle border text-dark p-2 rounded-pill">3. Availability</span><span class="nl-booking-step badge bg-warning-subtle border text-dark p-2 rounded-pill">4. Pricing</span><span class="nl-booking-step badge bg-warning-subtle border text-dark p-2 rounded-pill">5. Confirmation</span></nav>
            <form id="nlSmartBooking" data-route-hints-url="${requestScope.nlv_Module3_booking__4}/ContainerAllocationPricingController?module=booking_hints" action="${requestScope.nlv_Module3_booking__5}/ContainerAllocationPricingController"
                  method="post">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                <input type="hidden" name="module" value="booking">

                <details class="nl-booking-help mb-3">
                    <summary>How your booking works <span class="nl-booking-help-chevron" aria-hidden="true">⌄</span></summary>
                    <p>Choose goods and quantity, select the route and date, then review container availability and the price. Confirm the booking only after reviewing the quotation. You can then record a full or partial invoice payment.</p>
                </details>
                <!-- PRODUCT DETAILS -->
                <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 mb-4 border-warning-subtle">
                    <div class="card-body p-4">

                        <h5 class="fw-bold mb-1">
                            
                            Choose your goods
                        </h5>

                        <p class="text-secondary small mb-4">
                            Pick goods from the catalogue. Available stock, weight and volume guidance will appear automatically.
                        </p>

                        <div class="row g-3">

                            <div class="col-md-4">
                                <label class="form-label fw-semibold" for="nlBookingProductSearch">Product catalogue <span class="nl-required-top" aria-hidden="true">*</span></label>
                                <div class="nl-product-picker" id="nlProductPicker">
                                  <input type="search" class="form-control nl-product-query" id="nlBookingProductSearch"
                                         placeholder="Type a product name or SKU…" autocomplete="off"
                                         role="combobox" aria-expanded="false" aria-autocomplete="list"
                                         aria-controls="nlBookingProductSuggestions" aria-describedby="nlStockHint"
                                         required="required" spellcheck="false">
                                  <div class="nl-product-suggestions" id="nlBookingProductSuggestions" role="listbox"
                                       aria-label="Matching available products" hidden="hidden"></div>
                                </div>
                                <select class="form-select nl-product-native-select" id="nlBookingProduct" name="productId"
                                        aria-hidden="true" tabindex="-1" style="display:none"><option value="">Choose an available product</option><jsp:setProperty name="nlViewSupport_Module3_booking" property="fragment" value="nlv_Module3_booking__6" /><jsp:getProperty name="nlViewSupport_Module3_booking" property="fragment" /></select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">
                                    Quantity
                                </label>

                                <input type="number" id="nlBookingQuantity" inputmode="numeric"
                                       name="quantity" value="${requestScope.nlv_Module3_booking__7}"
                                       class="form-control"
                                       min="1"
                                       placeholder="Enter quantity"
                                       required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">
                                    Unit Volume (CBM)
                                </label>

                                <input type="number" id="nlBookingUnitCbm" inputmode="decimal"
                                       name="unitCbm" value="${requestScope.nlv_Module3_booking__8}"
                                       class="form-control"
                                       min="0.001"
                                       step="0.001"
                                       placeholder="e.g. 0.500"
                                       required>
                            </div>

                        </div>

                        <section class="nl-booking-guidance mt-4" aria-labelledby="nlGoodsAdviceTitle">
                            <div class="d-flex align-items-center justify-content-between gap-2 flex-wrap mb-3">
                                <div><h6 class="fw-bold mb-1" id="nlGoodsAdviceTitle">Live cargo planner</h6><p class="mb-0 small text-secondary">Suggestions use available stock and recorded shipments, never fabricated product dimensions.</p></div>
                                <span class="nl-guidance-tag" id="nlStockHint" aria-live="polite">Choose a product to begin</span>
                            </div>
                            <div class="nl-booking-metrics">
                                <div><span>Selected units</span><strong id="nlSelectedUnits">—</strong></div>
                                <div><span>Estimated cargo weight</span><strong id="nlEstimatedWeight">—</strong></div>
                                <div><span>Entered cargo volume</span><strong id="nlEstimatedCbm">—</strong></div>
                            </div>
                            <div class="nl-guidance-lanes mt-3">
                                <div><div class="fw-bold small mb-2">Quick quantity suggestions</div><div id="nlQtySuggestions" class="d-flex flex-wrap gap-2"><span class="text-secondary small">Select a product to view available quantities.</span></div></div>
                                <div><div class="fw-bold small mb-2">Unit-volume guidance</div><div id="nlVolumeGuidance" class="text-secondary small">Enter the measured volume of one package or unit (CBM).</div></div>
                            </div>
                            <p class="nl-guidance-foot mb-0 mt-3">Suggestions are planning aids only. Quotation and confirmation recheck actual container capacity, stock, and pricing.</p>
                        </section>

                    </div>
                </div>

                <!-- Route fields first; route directory below within one booking step card. -->
                <section id="nlRouteWorkspace" class="card nl-route-workspace shadow-sm border-0 rounded-4 mb-4">
                <div id="nlRouteDetails" class="nl-route-fields">
                    <div class="nl-route-fields-inner">

                        <span class="nl-routes-eyebrow">STEP 2 · PLAN YOUR JOURNEY</span>
                        <h5 class="fw-bold mb-1">Route Details</h5>

                        <p class="text-secondary small mb-4">
                            Choose the ports and dates, or select a serviceable route from the searchable directory directly below.
                        </p>

                        <div class="row g-3">

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">
                                    Origin port
                                </label>

                                <div class="nl-port-picker" id="nlOriginPortPicker">
                                    <input class="form-control nl-port-query" type="search" id="nlOriginPortSearch"
                                           placeholder="Type port name, city or code..." autocomplete="off" spellcheck="false"
                                           aria-label="Search and choose origin port" role="combobox" aria-autocomplete="list"
                                           aria-expanded="false" aria-controls="nlOriginPortChoices" required>
                                    <span class="nl-port-mark" aria-hidden="true">⌄</span>
                                    <div class="nl-port-options" id="nlOriginPortChoices" role="listbox"
                                         aria-label="Matching origin ports" hidden="hidden"></div>
                                    <select id="nlBookingOrigin" name="originPortId" aria-hidden="true" tabindex="-1" style="display:none">
                                        <option value="">Choose origin port</option><jsp:setProperty name="nlViewSupport_Module3_booking" property="fragment" value="nlv_Module3_booking__9" /><jsp:getProperty name="nlViewSupport_Module3_booking" property="fragment" />
                                    </select>
                                </div>
                                <div class="nl-port-help">Start typing to find an existing port; select a suggestion.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">
                                    Destination port
                                </label>

                                <div class="nl-port-picker" id="nlDestinationPortPicker">
                                    <input class="form-control nl-port-query" type="search" id="nlDestinationPortSearch"
                                           placeholder="Type port name, city or code..." autocomplete="off" spellcheck="false"
                                           aria-label="Search and choose destination port" role="combobox" aria-autocomplete="list"
                                           aria-expanded="false" aria-controls="nlDestinationPortChoices" required>
                                    <span class="nl-port-mark" aria-hidden="true">⌄</span>
                                    <div class="nl-port-options" id="nlDestinationPortChoices" role="listbox"
                                         aria-label="Matching destination ports" hidden="hidden"></div>
                                    <select id="nlBookingDestination" name="destPortId" aria-hidden="true" tabindex="-1" style="display:none">
                                        <option value="">Choose destination port</option><jsp:setProperty name="nlViewSupport_Module3_booking" property="fragment" value="nlv_Module3_booking__10" /><jsp:getProperty name="nlViewSupport_Module3_booking" property="fragment" />
                                    </select>
                                </div>
                                <div class="nl-port-help">Search using the port code, name or country.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">
                                    Booking Date
                                </label>

                                <input type="date" id="nlBookingDate"
                                       name="bookingDate"
                                       class="form-control"
                                       value="${requestScope.nlv_Module3_booking__11}"
                                       required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">
                                    Expected Due Date
                                </label>

                                <input type="date" id="nlBookingDueDate"
                                       name="dueDate" value="${requestScope.nlv_Module3_booking__12}"
                                       class="form-control" required>
                                <small class="text-secondary">
                                    Required to review the quote and confirm the booking.
                                </small>
                            </div>

                        </div>
                    </div>
                </div>
                <section class="nl-booking-routes nl-route-directory" aria-labelledby="nlRoutesTitle" id="nlAvailableRoutes">
                    <div class="nl-route-directory-inner">
                        <div class="nl-routes-intro">
                            <div>
                                <span class="nl-routes-eyebrow">AVAILABLE LANES · LIVE DIRECTORY</span>
                                <h5 class="fw-bold mb-1" id="nlRoutesTitle"><span id="nlRoutesTitleText">Available routes</span> <span id="nlAvailableRouteCount" class="nl-route-count" aria-live="polite">—</span></h5>
                                <p class="small text-secondary mb-0">Search all serviceable routes for this product and booking date. Selecting a route fills the port fields above.</p>
                            </div>
                            <span class="nl-guidance-tag">Verified pricing · available containers</span>
                        </div>
                        <div class="nl-route-selection" id="nlRouteSelected" hidden="hidden" aria-live="polite">
                            <span class="nl-route-selection-icon" aria-hidden="true">✓</span>
                            <span><strong>Your selected route</strong><span id="nlRouteSelectedText"></span></span>
                        </div>
                        <div class="nl-route-tools">
                            <label class="nl-route-tool-search" for="nlRouteFilter"><span class="nl-route-tool-label">Search any port or code</span><input id="nlRouteFilter" type="search" class="form-control" placeholder="e.g. Mumbai, INBOM, Rotterdam…" autocomplete="off" aria-controls="nlRouteSuggestions"></label>
                            <label class="nl-route-tool-sort" for="nlRouteSort"><span class="nl-route-tool-label">Sort routes</span><select id="nlRouteSort" class="form-select" aria-controls="nlRouteSuggestions"><option value="containers">Most available containers</option><option value="shipments">Most active shipments</option><option value="alpha">Origin port A–Z</option><option value="transit">Fastest recorded transit</option></select></label>
                            <label class="nl-route-tool-size" for="nlRoutePageSize"><span class="nl-route-tool-label">Rows per page</span><select id="nlRoutePageSize" class="form-select" aria-controls="nlRouteSuggestions"><option value="10" selected>10 routes</option><option value="20">20 routes</option><option value="50">50 routes</option></select></label>
                        </div>
                        <div class="nl-route-filterline">
                            <label class="nl-route-check"><input type="checkbox" id="nlRouteActiveOnly" /> Only routes with active shipments</label>
                            <button type="button" class="nl-route-clear" id="nlRouteClear">Clear filters</button>
                            <button type="button" class="nl-route-clear" id="nlRouteClearPorts" hidden="hidden" title="Clear the selected route ports to show every available route">Show all routes</button>
                            <span id="nlRouteResultsMessage" role="status" aria-live="polite">Choose goods above to browse routes.</span>
                        </div>
                        <div class="nl-route-headings" aria-hidden="true"><span>Origin → Destination</span><span>Available containers</span><span>Active shipments</span><span>Recorded transit</span><span>Action</span></div>
                        <div id="nlRouteSuggestions" class="nl-route-grid" role="group" aria-label="Available routes">
                            <p class="small text-secondary mb-0">Choose a product above to show available routes.</p>
                        </div>
                        <nav id="nlRoutePager" class="nl-route-pager" aria-label="Route results pages" hidden="hidden">
                            <span id="nlRouteRange" class="nl-route-range">—</span>
                            <div class="nl-route-page-controls">
                                <button id="nlRoutePrev" type="button" class="nl-route-page-btn" aria-label="Previous route results page">← Previous</button>
                                <span id="nlRoutePageLabel" aria-live="polite">Page 1 of 1</span>
                                <button id="nlRouteNext" type="button" class="nl-route-page-btn" aria-label="Next route results page">Next →</button>
                            </div>
                        </nav>
                        <p id="nlRouteSelectionNote" class="small mt-3 mb-0 nl-route-disclaimer" aria-live="polite">Available containers are for new bookings. Active shipments are existing movements on the lane, not additional capacity. Final capacity and price are checked when requesting a quotation.</p>
                    </div>
                </section>
            </section>

                <!-- ACTIONS -->
                <div class="d-flex flex-wrap justify-content-end gap-2 mb-4">

                    <button type="submit"
                            name="action"
                            value="quote"
                            class="btn btn-warning btn-lg fw-bold px-5 py-3 shadow-sm">
                        
                        Continue to Book — View My Price
                    </button>

                </div>



            </form>



</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>

<script>
(function(){
  'use strict';
  const f=document.getElementById('nlSmartBooking');if(!f)return;
  const product=document.getElementById('nlBookingProduct'),quantity=document.getElementById('nlBookingQuantity');
  const productInput=document.getElementById('nlBookingProductSearch');
  const productSuggestions=document.getElementById('nlBookingProductSuggestions');
  const productOptions=Array.from(product.options).filter(o=>o.value);
  let highlightedOption=0;
  function setOptionsVisible(visible){productSuggestions.hidden=!visible;productInput.setAttribute('aria-expanded',String(visible));}
  function selectProduct(option){
    product.value=option.value;productInput.value=option.textContent.trim();
    productInput.setCustomValidity('');setOptionsVisible(false);
    product.dispatchEvent(new Event('change',{bubbles:true}));
  }
  function showProductMatches(){
    const term=productInput.value.trim().toLocaleLowerCase();
    const matching=productOptions.filter(o=>o.textContent.toLocaleLowerCase().includes(term)).slice(0,10);
    productSuggestions.replaceChildren();highlightedOption=0;
    if(!matching.length){const empty=el('div','nl-product-empty','No matching available products. Try a different name or SKU.');productSuggestions.appendChild(empty);}
    else matching.forEach((opt,i)=>{
      const b=el('button','nl-product-choice',opt.textContent.trim());b.type='button';
      b.setAttribute('role','option');b.dataset.option=opt.value;b.setAttribute('aria-selected',String(i===0));
      b.addEventListener('pointerdown',e=>e.preventDefault());
      b.addEventListener('click',()=>selectProduct(opt));productSuggestions.appendChild(b);
    });
    setOptionsVisible(true);
  }
  function focusMatch(delta){
    const list=Array.from(productSuggestions.querySelectorAll('[role="option"]'));if(!list.length)return;
    highlightedOption=(highlightedOption+delta+list.length)%list.length;
    list.forEach((b,i)=>{b.classList.toggle('is-active',i===highlightedOption);b.setAttribute('aria-selected',String(i===highlightedOption));});
    list[highlightedOption].scrollIntoView({block:'nearest'});
  }
  if(product.value){const option=productOptions.find(o=>o.value===product.value);if(option)productInput.value=option.textContent.trim();}
  productInput.addEventListener('focus',showProductMatches);
  productInput.addEventListener('input',()=>{
    product.value='';productInput.setCustomValidity('Select a listed product, not just typed text.');
    showProductMatches();
    // Clear stale quantities/routes immediately; a quote cannot use an unselected product.
    renderProduct();loadRoutes();
  });
  productInput.addEventListener('keydown',e=>{
    if(e.key==='ArrowDown'||e.key==='ArrowUp'){
      e.preventDefault();if(productSuggestions.hidden)showProductMatches();focusMatch(e.key==='ArrowDown'?1:-1);
    }else if(e.key==='Escape'){setOptionsVisible(false);}
    else if(e.key==='Enter'&&!productSuggestions.hidden){
      const list=Array.from(productSuggestions.querySelectorAll('[role="option"]'));
      if(list.length){e.preventDefault();const chosen=productOptions.find(o=>o.value===list[highlightedOption].dataset.option);if(chosen)selectProduct(chosen);}
    }
  });
  document.addEventListener('pointerdown',e=>{if(!document.getElementById('nlProductPicker').contains(e.target))setOptionsVisible(false);});
  f.addEventListener('submit',e=>{
    if(!product.value){e.preventDefault();productInput.setCustomValidity('Select a product from the suggestions before continuing.');productInput.reportValidity();productInput.focus();}
  },true);

  const unit=document.getElementById('nlBookingUnitCbm'),origin=document.getElementById('nlBookingOrigin');
  const dest=document.getElementById('nlBookingDestination'),bookingDate=document.getElementById('nlBookingDate');
  const due=document.getElementById('nlBookingDueDate');
  const stock=document.getElementById('nlStockHint'),qtySuggestions=document.getElementById('nlQtySuggestions');
  const volumeGuidance=document.getElementById('nlVolumeGuidance'),routeHost=document.getElementById('nlRouteSuggestions');
  const routeNote=document.getElementById('nlRouteSelectionNote');
  const routeFilter=document.getElementById('nlRouteFilter'),routeSort=document.getElementById('nlRouteSort'),routeCount=document.getElementById('nlAvailableRouteCount');
  const routePageSize=document.getElementById('nlRoutePageSize'),routeActiveOnly=document.getElementById('nlRouteActiveOnly');
  const routeClear=document.getElementById('nlRouteClear'),routeClearPorts=document.getElementById('nlRouteClearPorts');
  const routesTitleText=document.getElementById('nlRoutesTitleText'),routeResultsMessage=document.getElementById('nlRouteResultsMessage');
  const routePager=document.getElementById('nlRoutePager'),routeRange=document.getElementById('nlRouteRange');
  const routePrev=document.getElementById('nlRoutePrev'),routeNext=document.getElementById('nlRouteNext'),routePageLabel=document.getElementById('nlRoutePageLabel');
  const selectedBox=document.getElementById('nlRouteSelected'),selectedText=document.getElementById('nlRouteSelectedText');
  let seq=0,controller=null,lastSuggested='',routeData=[],routePage=1,routePages=1,routeTotal=0,routeTimer=null;
  let changingRouteFromCard=false,previousOriginValue=origin.value;
  // Port names are editable for searching, but only an existing database port ID is submitted.
  // Keep the original select fields so quote review, draft restore and route cards continue to work.
  function initPortSearch(selectId,inputId,listId,pickerId){
    const native=document.getElementById(selectId),input=document.getElementById(inputId);
    const list=document.getElementById(listId),picker=document.getElementById(pickerId);
    const choices=Array.from(native.options).filter(o=>o.value);
    let active=0;
    function visible(show){list.hidden=!show;input.setAttribute('aria-expanded',String(show));}
    function sync(){
      const opt=choices.find(o=>o.value===native.value);
      input.value=opt?opt.textContent.trim():'';
      input.setCustomValidity('');visible(false);
    }
    function choose(opt){
      native.value=opt.value;sync();
      native.dispatchEvent(new Event('change',{bubbles:true}));
    }
    function matches(){
      const text=input.value.trim().toLocaleLowerCase();
      return choices.filter(o=>o.textContent.toLocaleLowerCase().includes(text)).slice(0,30);
    }
    function render(){
      const result=matches();active=0;list.replaceChildren();
      if(!result.length){
        const empty=document.createElement('div');empty.className='nl-port-empty';
        empty.textContent='No matching ports. Try a port code, city or country.';list.appendChild(empty);
      }else result.forEach((opt,i)=>{
        const b=document.createElement('button');b.type='button';b.className='nl-port-choice';
        b.setAttribute('role','option');b.setAttribute('aria-selected',String(i===0));
        b.dataset.value=opt.value;b.textContent=opt.textContent.trim();
        b.addEventListener('pointerdown',e=>e.preventDefault());
        b.addEventListener('click',()=>choose(opt));list.appendChild(b);
      });
      visible(true);
    }
    function move(delta){
      const buttons=Array.from(list.querySelectorAll('[role="option"]'));
      if(!buttons.length)return;
      active=(active+delta+buttons.length)%buttons.length;
      buttons.forEach((b,i)=>{b.classList.toggle('is-active',i===active);b.setAttribute('aria-selected',String(i===active));});
      buttons[active].scrollIntoView({block:'nearest'});
    }
    input.addEventListener('focus',render);
    input.addEventListener('input',()=>{
      const previousValue=native.value;
      native.value='';input.setCustomValidity('Choose an existing port from the suggestions.');
      // Typing is not a selected port; drop its old ID from route filters immediately.
      if(selectId==='nlBookingOrigin'){
        previousOriginValue='';
        if(previousValue && dest.value){dest.value='';destPort.sync();}
      }
      routeStatus();updateSelectedRoute();render();scheduleRoutes();
    });
    input.addEventListener('keydown',e=>{
      if(e.key==='ArrowDown'||e.key==='ArrowUp'){
        e.preventDefault();if(list.hidden)render();else move(e.key==='ArrowDown'?1:-1);
      }else if(e.key==='Escape'){visible(false);}
      else if(e.key==='Tab'){visible(false);}
      else if(e.key==='Enter'&&!list.hidden){
        const buttons=Array.from(list.querySelectorAll('[role="option"]'));
        if(buttons.length){e.preventDefault();const option=choices.find(o=>o.value===buttons[active].dataset.value);if(option)choose(option);}
      }
    });
    native.addEventListener('change',sync);
    document.addEventListener('pointerdown',e=>{if(!picker.contains(e.target))visible(false);});
    window.addEventListener('pageshow',sync);
    sync();
    return {input,native,sync};
  }
  const originPort=initPortSearch('nlBookingOrigin','nlOriginPortSearch','nlOriginPortChoices','nlOriginPortPicker');
  const destPort=initPortSearch('nlBookingDestination','nlDestinationPortSearch','nlDestinationPortChoices','nlDestinationPortPicker');
  function chosenPortName(select){
    if(!select.value)return '';
    const option=select.options[select.selectedIndex];
    if(!option)return '';
    const parts=option.textContent.trim().split(/\s*·\s*/);
    return (parts.length>1?parts[1]:option.textContent).trim();
  }
  function updateRouteScope(){
    const o=chosenPortName(origin),d=chosenPortName(dest);
    routesTitleText.textContent=o&&d?'Routes from '+o+' to '+d:o?'Available routes from '+o:d?'Available routes to '+d:'Available routes';
    routeClearPorts.hidden=!(origin.value||dest.value);
  }
  function el(tag,cls,txt){const n=document.createElement(tag);if(cls)n.className=cls;if(txt!==undefined)n.textContent=txt;return n;}
  function current(){return product.options[product.selectedIndex];}
  function available(){const n=Number(current()?.dataset.stock);return Number.isFinite(n)&&n>0?Math.floor(n):0;}
  function renderMetrics(){
    const q=Number(quantity.value),c=Number(unit.value),w=Number(current()?.dataset.weight);
    document.getElementById('nlSelectedUnits').textContent=q>0?Intl.NumberFormat().format(q):'—';
    document.getElementById('nlEstimatedWeight').textContent=q>0&&w>0?(q*w).toLocaleString(undefined,{maximumFractionDigits:2})+' kg':'Not recorded';
    document.getElementById('nlEstimatedCbm').textContent=q>0&&c>0?(q*c).toLocaleString(undefined,{maximumFractionDigits:3})+' CBM':'Enter unit CBM';
    if(quantity.value&&available()>0&&q>available()){quantity.setCustomValidity('Quantity exceeds currently available unreserved stock.');stock.textContent='Only '+available()+' units currently available';}
    else {quantity.setCustomValidity('');}
  }
  function renderProduct(){
    const opt=current(),max=available();stock.textContent=max?max.toLocaleString()+' units available':'Choose an available product';
    qtySuggestions.replaceChildren();volumeGuidance.replaceChildren();
    if(!max){qtySuggestions.appendChild(el('span','text-secondary small','Select a product to view stock-aware quantities.'));volumeGuidance.textContent='Enter the volume of one packaged unit in CBM.';quantity.removeAttribute('max');renderMetrics();return;}
    quantity.max=String(max);
    const suggestions=[1,Math.max(1,Math.floor(max*.25)),Math.max(1,Math.floor(max*.5)),max];
    Array.from(new Set(suggestions)).forEach(n=>{const b=el('button','btn nl-qty-chip',n===max?'All '+n.toLocaleString():n.toLocaleString()+' units');b.type='button';b.addEventListener('click',()=>{quantity.value=String(n);renderMetrics();quantity.focus();});qtySuggestions.appendChild(b);});
    const hint=Number(opt.dataset.unitCbm),samples=Number(opt.dataset.samples);
    if(hint>0&&samples>0){
      const note=el('p','mb-2','Historical estimate: '+hint.toFixed(3)+' CBM per unit ('+samples+' shipment line'+(samples===1?'':'s')+'). Confirm against packaging measurements.');
      const use=el('button','btn btn-outline-warning btn-sm','Use historical estimate');use.type='button';
      use.addEventListener('click',()=>{unit.value=hint.toFixed(3);lastSuggested=unit.value;renderMetrics();unit.focus();});volumeGuidance.append(note,use);
    }else volumeGuidance.append(el('p','mb-0','No previous measured unit volume is recorded for this product. Enter the real packed-unit volume; no value has been guessed.'));
    renderMetrics();
  }
  function routeStatus(){
    if(origin.value && dest.value && origin.value===dest.value){routeNote.textContent='Origin and destination must be different.';destPort.input.setCustomValidity('Choose a different destination port.');}
    else {if(dest.value)destPort.input.setCustomValidity('');routeNote.textContent='Active shipments are existing movements, not bookable space. Availability and price are rechecked at quotation.';}
  }
  function updateSelectedRoute(){
    const o=origin.options[origin.selectedIndex],d=dest.options[dest.selectedIndex];
    const ready=Boolean(origin.value&&dest.value&&origin.value!==dest.value);
    selectedBox.hidden=!ready;
    if(ready)selectedText.textContent=o.textContent.trim()+' → '+d.textContent.trim();
  }
  function setRoute(r){
    // Set both IDs as one operation so the origin-change handler cannot erase the destination.
    changingRouteFromCard=true;
    try{
      origin.value=String(r.originPortId);dest.value=String(r.destPortId);
      origin.dispatchEvent(new Event('change',{bubbles:true}));
      dest.dispatchEvent(new Event('change',{bubbles:true}));
    }finally{changingRouteFromCard=false;previousOriginValue=origin.value;}
    routeStatus();updateSelectedRoute();loadRoutes();
    if(r.historySamples>=3 && Number.isInteger(r.historicalTransitDays) && r.historicalTransitDays>0 && bookingDate.value){
      const d=new Date(bookingDate.value+'T12:00:00');d.setDate(d.getDate()+r.historicalTransitDays);
      const suggested=[d.getFullYear(),String(d.getMonth()+1).padStart(2,'0'),String(d.getDate()).padStart(2,'0')].join('-');
      if(!due.value || due.dataset.autoSuggested==='true'){due.value=suggested;due.dataset.autoSuggested='true';window.nlBookingCalendarSync?.();}
      routeNote.textContent='Selected route. Historical transit estimate: '+r.historicalTransitDays+' days from '+r.historySamples+' previous shipments. Please review your due date.';
    }else routeNote.textContent='Selected route. Enter your expected due date; historical transit data is not sufficient for a reliable estimate.';
    document.getElementById('nlRouteDetails').scrollIntoView({block:'start',behavior:window.matchMedia('(prefers-reduced-motion: reduce)').matches?'auto':'smooth'});
  }
  function renderRoutes(){
    routeHost.replaceChildren();
    updateRouteScope();
    routeCount.textContent=routeTotal.toLocaleString()+' match'+(routeTotal===1?'':'es');
    routePager.hidden=routeTotal===0;
    const start=(routePage-1)*Number(routePageSize.value);
    const end=Math.min(start+routeData.length,routeTotal);
    routeRange.textContent=routeTotal?'Showing '+(start+1).toLocaleString()+'–'+end.toLocaleString()+' of '+routeTotal.toLocaleString()+' routes':'';
    routePages=Math.max(1,Math.ceil(routeTotal/Number(routePageSize.value)));
    routePageLabel.textContent='Page '+routePage.toLocaleString()+' of '+routePages.toLocaleString();
    routePrev.disabled=routePage<=1;routeNext.disabled=routePage>=routePages;
    if(!routeData.length){
      const originName=chosenPortName(origin);
      routeHost.append(el('div','nl-route-empty',!product.value?'Choose a product to view currently serviceable routes.':originName?'No serviceable routes currently match departures from '+originName+'. Try clearing the destination, search, or other filters.':'No routes match these filters. Clear filters or try a different product or date.'));
      routeResultsMessage.textContent=routeTotal?'No routes on this page.':'No matching routes.';return;
    }
    routeResultsMessage.textContent=routeTotal.toLocaleString()+' matching route'+(routeTotal===1?'':'s')+' · page '+routePage+' of '+routePages;
    routeData.forEach(r=>{
      const b=el('button','nl-route-card nl-route-entry');b.type='button';b.dataset.o=String(r.originPortId);b.dataset.d=String(r.destPortId);
      const chosen=origin.value===b.dataset.o&&dest.value===b.dataset.d;
      b.setAttribute('aria-pressed',String(chosen));
      b.setAttribute('aria-label',(chosen?'Selected: ':'Choose ')+r.origin+' to '+r.destination+', '+r.availableContainers+' available containers, '+(r.activeShipments||0)+' active shipments');
      const path=el('span','nl-route-path');path.append(el('span','',r.origin),el('span','nl-route-arrow','→'),el('span','',r.destination));
      const containers=el('span','');containers.append(el('span','nl-route-metric',String(r.availableContainers)),el('span','nl-route-sub','available container'+(r.availableContainers===1?'':'s')));
      const movements=el('span','');movements.append(el('span','nl-route-metric',String(r.activeShipments||0)),el('span','nl-route-sub','existing active shipment'+(r.activeShipments===1?'':'s')));
      const transit=el('span','nl-route-transit');
      if(r.historySamples>=3&&r.historicalTransitDays>0)transit.append(el('span','nl-route-metric',r.historicalTransitDays+' days'),el('span','nl-route-sub','Average · '+r.historySamples+' historical records'));
      else transit.append(el('span','nl-route-metric','Not established'),el('span','nl-route-sub','Choose a due date manually'));
      const choose=el('span','nl-route-pick',chosen?'Selected ✓':'Select route');
      b.append(path,containers,movements,transit,choose);
      b.addEventListener('click',()=>setRoute(r));routeHost.append(b);
    });
  }
  function scheduleRoutes(){clearTimeout(routeTimer);routePage=1;routeTimer=setTimeout(loadRoutes,280);}
  routeFilter.addEventListener('input',scheduleRoutes);
  routeSort.addEventListener('change',()=>{routePage=1;loadRoutes();});
  routePageSize.addEventListener('change',()=>{routePage=1;loadRoutes();});
  routeActiveOnly.addEventListener('change',()=>{routePage=1;loadRoutes();});
  routeClear.addEventListener('click',()=>{routeFilter.value='';routeSort.value='containers';routeActiveOnly.checked=false;routePageSize.value='10';routePage=1;loadRoutes();});
  routeClearPorts.addEventListener('click',()=>{
    origin.value='';dest.value='';previousOriginValue='';
    originPort.sync();destPort.sync();routeStatus();updateSelectedRoute();routePage=1;loadRoutes();
  });
  routePrev.addEventListener('click',()=>{if(routePage>1){routePage--;loadRoutes();}});
  routeNext.addEventListener('click',()=>{if(routePage<routePages){routePage++;loadRoutes();}});
  async function loadRoutes(){
    clearTimeout(routeTimer);updateRouteScope();
    const id=product.value,token=++seq;
    if(controller)controller.abort();controller=window.AbortController?new AbortController():null;
    routeData=[];routeTotal=0;routeCount.textContent='—';routePager.hidden=true;routeHost.replaceChildren();
    if(!id){routeResultsMessage.textContent='Choose goods above to browse routes.';routeHost.append(el('div','nl-route-empty','Choose goods first to see available routes.'));return;}
    routeResultsMessage.textContent='Loading route results…';routeHost.append(el('p','small text-secondary mb-0','Checking active pricing and available containers…'));
    try{
      const query=new URLSearchParams({productId:id,bookingDate:bookingDate.value||'',q:routeFilter.value.trim(),sort:routeSort.value,page:String(routePage),pageSize:routePageSize.value,activeOnly:routeActiveOnly.checked?'1':'0',originPortId:origin.value||'',destPortId:dest.value||''});
      const response=await fetch(f.dataset.routeHintsUrl+'&'+query.toString(),{credentials:'same-origin',signal:controller?.signal,headers:{'Accept':'application/json'}});
      if(!response.ok)throw new Error('Route directory could not load');const data=await response.json();if(token!==seq)return;
      routeData=Array.isArray(data.routes)?data.routes:[];routeTotal=Math.max(0,Number(data.total)||0);
      routePage=Math.max(1,Number(data.page)||routePage);
      if(routeTotal>0&&!routeData.length&&routePage>1){routePage=1;loadRoutes();return;}
      updateSelectedRoute();renderRoutes();
    }catch(e){if(e.name==='AbortError')return;if(token!==seq)return;routeResultsMessage.textContent='Could not load routes.';routeData=[];routeCount.textContent='—';routeHost.replaceChildren(el('div','nl-route-empty','Route directory is unavailable. You can still choose ports above and request a server-validated quotation.'));}
  }
  product.addEventListener('change',()=>{if(unit.value===lastSuggested&&lastSuggested){unit.value='';lastSuggested='';}renderProduct();loadRoutes();});
  quantity.addEventListener('input',renderMetrics);unit.addEventListener('input',renderMetrics);
  origin.addEventListener('change',()=>{
    if(changingRouteFromCard)return;
    // A new origin should expose ALL its destinations, not be stuck with a stale destination.
    if(origin.value!==previousOriginValue && dest.value){dest.value='';destPort.sync();}
    previousOriginValue=origin.value;
    routeStatus();updateSelectedRoute();routePage=1;loadRoutes();
  });
  dest.addEventListener('change',()=>{
    if(changingRouteFromCard)return;
    routeStatus();updateSelectedRoute();routePage=1;loadRoutes();
  });
  bookingDate.addEventListener('change',()=>{due.min=bookingDate.value;if(due.value&&due.value<bookingDate.value)due.value='';window.nlBookingCalendarSync?.();loadRoutes();});
  due.addEventListener('change',()=>{due.dataset.autoSuggested='false';window.nlBookingCalendarSync?.();});
  f.addEventListener('submit',e=>{
    if(!origin.value)originPort.input.setCustomValidity('Choose an existing origin port from the suggestions.');
    if(!dest.value)destPort.input.setCustomValidity('Choose an existing destination port from the suggestions.');
    routeStatus();if(!f.reportValidity()){e.preventDefault();return;}
  }
  );
  if(bookingDate.value)due.min=bookingDate.value;
  renderProduct();routeStatus();updateSelectedRoute();updateRouteScope();if(product.value)loadRoutes();
})();
</script>
<script>
/* v20.3: Accessible, theme-aware calendars for booking dates. Original server field names remain unchanged. */
(function(){
  'use strict';
  const form=document.getElementById('nlSmartBooking');
  if(!form)return;
  const dateFields=[
    {input:document.getElementById('nlBookingDate'),name:'Booking date',placeholder:'Choose booking date'},
    {input:document.getElementById('nlBookingDueDate'),name:'Expected due date',placeholder:'Choose expected due date'}
  ];
  if(dateFields.some(d=>!d.input))return;
  const monthNames=['January','February','March','April','May','June','July','August','September','October','November','December'];
  const weekdays=['Su','Mo','Tu','We','Th','Fr','Sa'];
  const pop=document.createElement('div');
  pop.className='nl-booking-calendar';pop.id='nlBookingCalendarPopover';
  pop.setAttribute('role','dialog');pop.setAttribute('aria-label','Select a date');pop.hidden=true;
  document.body.appendChild(pop);
  let active=null,viewYear=0,viewMonth=0,focusedIso='';
  function localIso(d){return d.getFullYear()+'-'+String(d.getMonth()+1).padStart(2,'0')+'-'+String(d.getDate()).padStart(2,'0');}
  function parseIso(s){if(!/^\d{4}-\d\d-\d\d$/.test(s||''))return null;const p=s.split('-').map(Number);const d=new Date(p[0],p[1]-1,p[2]);return localIso(d)===s?d:null;}
  function addDays(iso,n){const d=parseIso(iso);if(!d)return '';d.setDate(d.getDate()+n);return localIso(d);}
  function cap(s){const d=parseIso(s);return d?d.toLocaleDateString('en-IN',{day:'numeric',month:'short',year:'numeric'}):'';}
  function elem(tag,cls,txt){const el=document.createElement(tag);if(cls)el.className=cls;if(txt!==undefined)el.textContent=txt;return el;}
  function btn(cls,label){const b=elem('button',cls,label);b.type='button';return b;}
  function update(field){
    const value=parseIso(field.input.value)?field.input.value:'';
    field.trigger.classList.toggle('nl-cal-empty',!value);
    field.main.textContent=value?cap(value):field.placeholder;
    field.sub.textContent=value?parseIso(value).toLocaleDateString('en-IN',{weekday:'long'}):'Select a day from the calendar';
    field.trigger.setAttribute('aria-label',field.name+': '+(value?cap(value):'Not selected')+'. Open calendar');
    if(value)field.error.textContent='';
    field.trigger.classList.toggle('nl-cal-invalid',!!field.error.textContent);
  }
  function sync(){dateFields.forEach(update);if(active&&!pop.hidden)render();}
  window.nlBookingCalendarSync=sync;
  function reposition(){
    if(!active||pop.hidden)return;
    const r=active.trigger.getBoundingClientRect();
    const pw=Math.min(356,window.innerWidth-20);
    const gap=7,ph=pop.scrollHeight||420;
    const below=window.innerHeight-r.bottom-gap-8;
    const above=r.top-gap-8;
    const openAbove=below<Math.min(ph,360)&&above>below;
    const available=Math.max(140,openAbove?above:below);
    pop.style.maxHeight=Math.min(540,available)+'px';
    // Keep the popup clear of its own date field; shorten/scroll it rather than overlay the input.
    const actualHeight=pop.offsetHeight;
    const top=openAbove?r.top-gap-actualHeight:r.bottom+gap;
    const left=Math.max(10,Math.min(r.left,window.innerWidth-pw-10));
    pop.style.left=left+'px';pop.style.top=Math.max(8,top)+'px';
  }
  function close(restoreFocus){if(!active)return;const prev=active;pop.hidden=true;prev.trigger.setAttribute('aria-expanded','false');active=null;if(restoreFocus)prev.trigger.focus();}
  function open(field){
    if(active===field&&!pop.hidden){close(true);return;}
    if(active)close(false);
    active=field;
    const earliest=field.input.min||'';
    const starting=field.input.value||((earliest&&earliest>localIso(new Date()))?earliest:localIso(new Date()));
    const d=parseIso(starting)||new Date();
    viewYear=d.getFullYear();viewMonth=d.getMonth();focusedIso=localIso(d);
    field.trigger.setAttribute('aria-expanded','true');pop.setAttribute('aria-label','Choose '+field.name.toLowerCase());pop.hidden=false;
    render();reposition();
    const focused=pop.querySelector('.nl-cal-day.nl-cal-keyfocus:not(:disabled)')||pop.querySelector('.nl-cal-day:not(:disabled)');
    if(focused)focused.focus({preventScroll:true});
  }
  function choose(iso){
    if(!active)return;
    const field=active;
    if(field.input.min&&iso<field.input.min)return;
    field.input.value=iso;field.error.textContent='';update(field);
    close(true);
    field.input.dispatchEvent(new Event('input',{bubbles:true}));
    field.input.dispatchEvent(new Event('change',{bubbles:true}));
    sync();
  }
  function monthShift(delta,focusDay){
    const d=new Date(viewYear,viewMonth+delta,1);viewYear=d.getFullYear();viewMonth=d.getMonth();
    if(focusDay){const f=parseIso(focusedIso)||d;focusedIso=localIso(new Date(viewYear,viewMonth,Math.min(f.getDate(),new Date(viewYear,viewMonth+1,0).getDate())));}
    render();
    if(focusDay){const k=pop.querySelector('.nl-cal-keyfocus:not(:disabled)');if(k)k.focus({preventScroll:true});}
  }
  function keyboardDay(e){
    let n=0;
    if(e.key==='ArrowRight')n=1;else if(e.key==='ArrowLeft')n=-1;
    else if(e.key==='ArrowDown')n=7;else if(e.key==='ArrowUp')n=-7;
    else if(e.key==='Home')n=-(parseIso(focusedIso)?.getDay()||0);
    else if(e.key==='End')n=6-(parseIso(focusedIso)?.getDay()||0);
    else if(e.key==='PageUp'||e.key==='PageDown'){
      e.preventDefault();monthShift(e.key==='PageUp'?-1:1,true);reposition();return;
    }
    else return;
    e.preventDefault();
    let target=addDays(focusedIso,n);if(!target)return;
    if(active.input.min&&target<active.input.min)target=active.input.min;
    const d=parseIso(target);viewYear=d.getFullYear();viewMonth=d.getMonth();focusedIso=target;
    render();reposition();
    const k=pop.querySelector('.nl-cal-keyfocus:not(:disabled)');if(k)k.focus({preventScroll:true});
  }
  function render(){
    if(!active)return;
    pop.replaceChildren();
    const head=elem('div','nl-cal-top');
    const h=elem('div','nl-cal-heading','Select '+active.name.toLowerCase());
    h.appendChild(elem('span','nl-cal-subheading','Tap a day or use the arrow keys'));
    const x=btn('nl-cal-close','×');x.setAttribute('aria-label','Close calendar');x.addEventListener('click',()=>close(true));
    head.append(h,x);pop.appendChild(head);
    const bar=elem('div','nl-cal-monthbar');const prev=btn('nl-cal-nav','‹');prev.setAttribute('aria-label','Previous month');
    const next=btn('nl-cal-nav','›');next.setAttribute('aria-label','Next month');
    const selectors=elem('div','nl-cal-selectors');
    const month=document.createElement('select');month.setAttribute('aria-label','Select month');
    monthNames.forEach((m,i)=>{const o=document.createElement('option');o.value=String(i);o.textContent=m;month.appendChild(o);});month.value=String(viewMonth);
    const year=document.createElement('select');year.setAttribute('aria-label','Select year');
    for(let y=Math.max(1900,viewYear-9);y<=Math.min(2100,viewYear+10);y++){
      const o=document.createElement('option');o.value=String(y);o.textContent=String(y);year.appendChild(o);
    }year.value=String(viewYear);
    month.addEventListener('change',()=>{viewMonth=Number(month.value);render();reposition();pop.querySelector('.nl-cal-selectors select')?.focus({preventScroll:true});});
    year.addEventListener('change',()=>{viewYear=Number(year.value);render();reposition();pop.querySelectorAll('.nl-cal-selectors select')[1]?.focus({preventScroll:true});});
    prev.addEventListener('click',()=>{monthShift(-1,false);reposition();pop.querySelector('.nl-cal-nav')?.focus({preventScroll:true});});
    next.addEventListener('click',()=>{monthShift(1,false);reposition();pop.querySelectorAll('.nl-cal-nav')[1]?.focus({preventScroll:true});});
    selectors.append(month,year);bar.append(prev,selectors,next);pop.appendChild(bar);
    const weekdaysRow=elem('div','nl-cal-weekdays');weekdays.forEach(w=>weekdaysRow.appendChild(elem('span','',w)));pop.appendChild(weekdaysRow);
    const grid=elem('div','nl-cal-grid');grid.setAttribute('aria-label','Days in '+monthNames[viewMonth]+' '+viewYear);
    const firstDay=new Date(viewYear,viewMonth,1).getDay();const today=localIso(new Date());
    const start=new Date(viewYear,viewMonth,1-firstDay);
    const currentMin=active.input.min||'';
    for(let i=0;i<42;i++){
      const d=new Date(start.getFullYear(),start.getMonth(),start.getDate()+i);const iso=localIso(d);
      const tile=btn('nl-cal-day',String(d.getDate()));tile.dataset.iso=iso;
      const outside=d.getMonth()!==viewMonth;
      tile.classList.toggle('nl-cal-outside',outside);
      tile.classList.toggle('nl-cal-selected',iso===active.input.value);
      tile.classList.toggle('nl-cal-today',iso===today);
      tile.classList.toggle('nl-cal-keyfocus',iso===focusedIso);
      tile.disabled=!!currentMin&&iso<currentMin;
      tile.tabIndex=iso===focusedIso?0:-1;
      tile.setAttribute('aria-label',d.toLocaleDateString('en-IN',{weekday:'long',day:'numeric',month:'long',year:'numeric'}));
      if(iso===active.input.value){tile.setAttribute('aria-current','date');tile.setAttribute('aria-pressed','true');}
      tile.addEventListener('click',()=>choose(iso));
      tile.addEventListener('keydown',keyboardDay);
      grid.appendChild(tile);
    }
    pop.appendChild(grid);
    const footer=elem('div','nl-cal-footer');
    footer.appendChild(elem('div','nl-cal-tip',currentMin?'Select '+cap(currentMin)+' or later':'Use arrows to browse dates'));
    const actions=elem('div','nl-cal-actions');
    const clear=btn('nl-cal-clear','Clear');clear.setAttribute('aria-label','Clear '+active.name.toLowerCase());
    clear.addEventListener('click',()=>{const field=active;field.input.value='';field.error.textContent='';close(true);field.input.dispatchEvent(new Event('change',{bubbles:true}));sync();});
    if(active===dateFields[1])actions.appendChild(clear);
    const todayButton=btn('nl-cal-today','Today');todayButton.disabled=!!currentMin&&today<currentMin;
    todayButton.addEventListener('click',()=>choose(today));actions.appendChild(todayButton);
    footer.appendChild(actions);pop.appendChild(footer);
  }
  dateFields.forEach(field=>{
    const input=field.input,wrap=elem('div','nl-booking-date-wrap');
    input.parentNode.insertBefore(wrap,input);wrap.appendChild(input);
    // Enhance only when scripting works. The original native date picker is kept as the no-JS fallback.
    input.type='hidden';input.required=false;
    const trigger=btn('nl-cal-trigger');trigger.setAttribute('aria-haspopup','dialog');trigger.setAttribute('aria-expanded','false');
    const labels=elem('span','nl-cal-label');field.main=elem('strong');field.sub=elem('small');labels.append(field.main,field.sub);
    const icon=elem('span','nl-cal-icon','▦');icon.setAttribute('aria-hidden','true');trigger.append(labels,icon);
    const error=elem('div','nl-cal-validation');error.setAttribute('role','alert');field.error=error;
    wrap.append(trigger,error);field.trigger=trigger;
    trigger.addEventListener('click',()=>open(field));
    input.addEventListener('change',()=>{update(field);if(active===field&&!pop.hidden)render();});
    update(field);
  });
  document.addEventListener('pointerdown',e=>{
    if(active&&!pop.hidden&&!pop.contains(e.target)&&!dateFields.some(f=>f.trigger.contains(e.target)))close(false);
  });
  document.addEventListener('keydown',e=>{if(e.key==='Escape'&&active&&!pop.hidden){e.preventDefault();close(true);}});
  window.addEventListener('resize',reposition);
  window.addEventListener('scroll',reposition,true);
  form.addEventListener('reset',()=>window.setTimeout(sync,0));
  form.addEventListener('submit',e=>{
    // Require the same two dates as the original native fields; do not change submitted parameters.
    // Let existing product and port validation display its own error first.
    const prod=document.getElementById('nlBookingProduct');if(prod&&!prod.value)return;
    for(const field of dateFields){
      const iso=field.input.value;
      const missing=!parseIso(iso),tooEarly=!!field.input.min&&iso<field.input.min;
      if(missing||tooEarly){
        e.preventDefault();e.stopImmediatePropagation();
        field.error.textContent=missing?'Please select '+field.name.toLowerCase()+'.':'Choose a date on or after '+cap(field.input.min)+'.';
        update(field);field.trigger.classList.add('nl-cal-invalid');field.trigger.focus();open(field);return;
      }
    }
  },true);
  window.addEventListener('pageshow',sync);
  sync();
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
