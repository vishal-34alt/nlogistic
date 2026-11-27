<jsp:useBean id="nlViewSupport_Module1_infrastructure" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="view" value="Module1/infrastructure.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Ports &amp; Vessels | N-LOGISTIC</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="../shared/_theme.jsp" %>
<style>
/* Scope all visual changes to the Module 1 infrastructure workspace. */
body[data-nl-screen="module1-infrastructure"] .nl-boardroom-tools,
body[data-nl-screen="module1-infrastructure"] .nl-section-index {display:none!important;}
.nl-infra {--i-ink:#3a2a20;--i-accent:#d45b17;--i-line:#ead6c5;--i-muted:#796558;}
.nl-infra .i-hero {border:1px solid #ecc9ad;border-radius:23px;background:linear-gradient(118deg,#fffdfa,#fff2e4 72%,#ffe7ce);box-shadow:0 15px 35px rgba(91,55,23,.07);padding:clamp(18px,2.4vw,34px);position:relative;overflow:hidden;}
.nl-infra .i-hero::before{content:"";position:absolute;right:-82px;top:-118px;width:320px;height:320px;border:1px solid rgba(208,95,30,.13);border-radius:50%;box-shadow:0 0 0 35px rgba(213,99,30,.035),0 0 0 72px rgba(213,99,30,.03);pointer-events:none}

.nl-infra .i-hero-grid{display:grid;grid-template-columns:minmax(0,1.5fr) minmax(250px,.8fr);gap:18px;align-items:start;position:relative;z-index:1}
.nl-infra .i-hero-visual{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}
.nl-infra .i-visual-card{background:rgba(255,255,255,.72);border:1px solid #efd2bb;border-radius:16px;padding:14px;min-height:92px;box-shadow:0 10px 22px rgba(105,63,28,.08)}
.nl-infra .i-visual-card strong{display:block;color:#b64916;font-size:1.45rem;line-height:1.1}
.nl-infra .i-visual-card span{display:block;font-size:.84rem;font-weight:760;margin-top:4px}
.nl-infra .i-visual-card small{display:block;font-size:.76rem;color:#80695b;margin-top:8px}
.nl-infra .i-toast-wrap{position:fixed;right:18px;top:88px;z-index:1300;display:grid;gap:10px}
.nl-infra .i-toast{min-width:min(420px,calc(100vw - 34px));background:#fffaf5;border:1px solid #edccb0;border-left:5px solid #d05a17;border-radius:16px;box-shadow:0 18px 40px rgba(74,41,15,.15);padding:14px 16px;display:flex;gap:12px;align-items:flex-start}
.nl-infra .i-toast.i-error{border-left-color:#b83a2d;background:#fff6f4}
.nl-infra .i-toast strong{display:block;font-size:.95rem}
.nl-infra .i-toast p{margin:2px 0 0;color:#725b4c;font-size:.84rem}
.nl-infra .i-toast button{margin-left:auto;border:0;background:transparent;color:#8c4b1d;font-size:1.15rem;line-height:1}
.nl-infra .i-seller-quick{display:flex;gap:8px;flex-wrap:wrap;margin-top:10px}
.nl-infra .i-seller-pill{border:1px solid #e8c8aa;background:#fff8f1;color:#91431a;border-radius:999px;padding:6px 10px;font-size:.77rem;font-weight:760}
.nl-infra .i-seller-pill:hover{background:#ffe9d5}
.nl-infra #iCountryModal .modal-content,.nl-infra #iNewCompanyModal .modal-content,.nl-infra #iInfraEditModal .modal-content{border-radius:24px}
.nl-infra #iInfraEditModal .modal-dialog{max-width:920px}
.nl-infra .modal-header .i-eyebrow{display:block;margin-bottom:4px}
.nl-infra .i-modal-note{background:#fff0df;border:1px solid #efd4b9;border-radius:14px;padding:12px;color:#975126;font-size:.82rem}
@media(max-width:900px){.nl-infra .i-hero-grid{grid-template-columns:1fr}}
.nl-infra .i-eyebrow{color:#ab551f;font-size:.72rem;letter-spacing:.14em;font-weight:800;text-transform:uppercase}
.nl-infra h1{font-size:clamp(1.75rem,3vw,2.5rem);font-weight:850;margin:5px 0 9px}
.nl-infra .i-desc{color:#775d4a;max-width:750px;font-size:.97rem;line-height:1.55}
.nl-infra .i-metrics{display:flex;gap:10px;flex-wrap:wrap;margin-top:17px}
.nl-infra .i-stat{background:rgba(255,255,255,.88);border:1px solid #f0d4ba;border-radius:13px;padding:10px 16px;min-width:136px}
.nl-infra .i-stat strong{font-size:1.4rem;color:#ad4211;font-weight:850;line-height:1.1;display:block}
.nl-infra .i-stat span{color:#76594a;font-size:.8rem;font-weight:650}
.nl-infra .i-tabbar{display:flex;gap:10px;flex-wrap:wrap;align-items:center;margin:19px 0 15px;border-bottom:1px solid #ead9c9;padding-bottom:13px}
.nl-infra .i-tab{border:1px solid #ecd3bf;background:#fffaf5;color:#714a31;border-radius:13px;font-weight:750;padding:12px 19px;transition:background-color .2s,transform .2s,box-shadow .2s}
.nl-infra .i-tab:hover{background:#fff0de;transform:translateY(-1px)}
.nl-infra .i-tab[aria-selected="true"]{background:linear-gradient(110deg,#b9400c,#e1661d);color:white;border-color:#c44e10;box-shadow:0 7px 15px rgba(196,79,19,.19)}
.nl-infra .i-tab .i-count{display:inline-flex;justify-content:center;align-items:center;min-width:27px;height:23px;padding:0 6px;border-radius:999px;background:#fce6d1;margin-left:10px;color:#9d491b;font-size:.75rem}
.nl-infra .i-tab[aria-selected="true"] .i-count{background:rgba(255,255,255,.24);color:#fff}
.nl-infra .i-panel[hidden]{display:none!important}
.nl-infra .i-panel{animation:i-slide .3s cubic-bezier(.22,.68,0,1.12) both}
@keyframes i-slide {from{opacity:.12;transform:translateY(12px) scale(.992)}to{opacity:1;transform:translateY(0) scale(1)}}
.nl-infra .i-work-card{background:#fffdf9;border:1px solid #edd9c8;border-radius:19px;padding:clamp(16px,2.2vw,26px);box-shadow:0 10px 25px rgba(83,50,27,.045);height:100%}
.nl-infra .i-work-card h2{font-size:1.18rem;font-weight:800;margin-bottom:5px}
.nl-infra .i-work-card .i-help{font-size:.85rem;color:#7d6858;margin-bottom:17px}
.nl-infra label{font-weight:700;font-size:.85rem;color:#5d402e;margin-bottom:5px}
.nl-infra .form-control,.nl-infra .form-select{background-color:#fffcf8;border-color:#e4c9b5;border-radius:11px;min-height:43px;padding:9px 12px;color:#3f3026}
.nl-infra .form-control:focus,.nl-infra .form-select:focus{border-color:#cb6025;box-shadow:0 0 0 3px rgba(209,89,29,.12)}
.nl-infra .form-text{font-size:.76rem;color:#806758;line-height:1.35;margin-top:5px}
.nl-infra .i-primary{color:#fff!important;background:linear-gradient(110deg,#c14710,#e7691a)!important;border:1px solid #bd4a15!important;border-radius:11px;padding:10px 18px;font-weight:750;box-shadow:0 6px 16px rgba(198,71,10,.14)}
.nl-infra .i-primary:hover{background:#ad390e!important;transform:translateY(-1px)}
.nl-infra .i-secondary{color:#9a4113;border:1px solid #e6bb9f;border-radius:10px;padding:9px 14px;font-weight:700;background:#fff8f1}
.nl-infra .i-secondary:hover{background:#ffebda;color:#8d3508}
.nl-infra .i-record-section{margin-top:22px;background:#fffdf9;border:1px solid #edd9c8;border-radius:20px;overflow:hidden;box-shadow:0 10px 28px rgba(75,44,22,.045)}
.nl-infra .i-record-header{padding:22px 23px 15px;display:flex;justify-content:space-between;align-items:flex-end;gap:12px;flex-wrap:wrap}
.nl-infra .i-record-header h2{font-size:1.27rem;font-weight:850;margin:0}
.nl-infra .i-record-header p{font-size:.82rem;color:#80695b;margin:6px 0 0}
.nl-infra .i-toolbar{display:flex;align-items:center;gap:10px;flex-wrap:wrap;border:1px solid #f0dfcd;border-radius:13px;background:#fff6eb;padding:11px 13px;margin:0 22px 15px}
.nl-infra .i-toolbar input{flex:1;min-width:180px;max-width:380px}
.nl-infra .i-toolbar select{max-width:220px}
.nl-infra .i-toolbar .i-result-count{font-size:.75rem;color:#876a54;margin-left:auto;font-weight:700}
.nl-infra .i-table-wrap{max-height:580px;overflow:auto}
.nl-infra .i-table{margin:0;width:100%;border-collapse:separate;border-spacing:0;min-width:745px;font-size:.87rem}
.nl-infra .i-table th{position:sticky;top:0;z-index:2;background:#fff1e6;color:#9d4d1e;text-transform:uppercase;letter-spacing:.055em;font-size:.69rem;padding:15px 16px;border-bottom:1px solid #e9d5c2;white-space:nowrap}
.nl-infra .i-table td{vertical-align:middle;padding:15px 16px;border-bottom:1px solid #f0e7db;color:#403027}
.nl-infra .i-table tbody tr:nth-child(even){background:#fcf7f0}
.nl-infra .i-table tbody tr:hover{background:#fff0df;transition:background .15s}
.nl-infra .i-row-title{font-weight:800;color:#30251f;display:block;font-size:.95rem}
.nl-infra .i-small{font-size:.76rem;color:#8b6e5b}
.nl-infra .i-code{display:inline-block;padding:5px 9px;border-radius:8px;background:#fff0df;border:1px solid #f1d0b5;color:#963d15;font-weight:800;font-size:.79rem;letter-spacing:.025em}
.nl-infra .i-pill{display:inline-block;border-radius:100px;padding:5px 11px;font-size:.74rem;font-weight:800;background:#e0f1e8;color:#08744c}
.nl-infra .i-pill.i-off{background:#fff0d8;color:#966018}
.nl-infra .i-actions{display:flex;align-items:center;gap:7px;flex-wrap:wrap}
.nl-infra .i-actions form{margin:0}
.nl-infra .i-row-btn{border:1px solid #e7c5aa;color:#983f13;background:#fffaf5;border-radius:9px;font-weight:700;padding:7px 11px;font-size:.79rem;white-space:nowrap}
.nl-infra .i-row-btn:hover{background:#ffeddc}
.nl-infra .i-row-btn.i-danger{color:#aa423b;border-color:#efc9c2}
.nl-infra .i-empty{padding:36px 20px;text-align:center;color:#856c5d;font-weight:650}
.nl-infra .i-banner{border-radius:14px;padding:13px 17px;margin:18px 0;font-weight:650;border:1px solid #c8e1cb;background:#edf8ee;color:#285d33}
.nl-infra .i-banner.i-error{background:#fff0e8;color:#9a3e18;border-color:#f0c9b5}
.nl-infra .i-detail{background:#fff8ee;border:1px solid #efd5b9;border-radius:11px;padding:12px;font-size:.83rem;color:#76523b}
#iInfraEditModal .modal-content{border-radius:22px;border:1px solid #f1cdb0;overflow:hidden;box-shadow:0 30px 80px #3b211850}
#iInfraEditModal .modal-header{background:linear-gradient(120deg,#fff0e0,#fffaf3);padding:22px 26px;border-bottom:1px solid #eadacb}
#iInfraEditModal .modal-body{padding:24px 26px}
#iInfraEditModal .modal-footer{background:#fffbf6;border-top:1px solid #eadacb;padding:16px 26px}
#iInfraEditModal .modal-title{font-weight:850}
#iInfraEditModal .i-primary{color:white;background:linear-gradient(110deg,#c14710,#e7691a);border:1px solid #bd4a15;border-radius:11px;padding:10px 18px;font-weight:750}
#iInfraEditModal .i-secondary{color:#9a4113;border:1px solid #e6bb9f;border-radius:10px;padding:9px 14px;font-weight:700;background:#fff8f1}
#iInfraEditModal .form-control,#iInfraEditModal .form-select{border:1px solid #e4c9b5;border-radius:11px;padding:9px 12px;min-height:43px;background:#fffcf8}
#iInfraEditModal label{font-weight:700;font-size:.85rem;color:#5d402e;margin-bottom:5px}
#iInfraEditModal .i-panel-summary{border-radius:12px;padding:13px;background:#fff2e3;color:#7c4a2a;font-size:.83rem;line-height:1.5}
#iInfraEditModal .i-eyebrow{color:#ab551f;font-size:.72rem;letter-spacing:.14em;font-weight:800;text-transform:uppercase}
.nl-infra .i-form-section{margin-bottom:15px}
.nl-infra .i-panel-summary{border-radius:12px;padding:13px;background:#fff2e3;color:#7c4a2a;font-size:.83rem;line-height:1.5}
@media(max-width:900px){.nl-infra .i-toolbar .i-result-count{margin-left:0}.nl-infra .i-table{min-width:700px}}
@media(prefers-reduced-motion:reduce){.nl-infra .i-panel{animation:none!important}.nl-infra .i-tab,.nl-infra .i-primary{transition:none!important;transform:none!important}}

/* v16 accessible pickers, compact activity summary and microinteractions */
.nl-infra .i-code-copy{font:inherit;font-weight:800;color:#963d15;cursor:pointer;transition:transform .15s,box-shadow .15s}
.nl-infra .i-code-copy:hover{box-shadow:0 3px 12px #a7471830;transform:translateY(-2px)}
.nl-infra .i-count-link{display:inline-flex;gap:6px;align-items:center;padding:7px 10px;border:1px solid #f0c8a6;border-radius:9px;background:#fff1e3;text-decoration:none;font-size:.8rem;color:#8e421d}
.nl-infra .i-picker-wrap{position:relative;display:flex;align-items:center;gap:7px}
.nl-infra .i-picker-action{border:1px solid #e7b88f;background:#fff0df;color:#9b4517;border-radius:10px;padding:10px 13px;font-size:.81rem;font-weight:800;white-space:nowrap}
.nl-infra .i-combo{position:relative}.nl-infra .i-seller-suggest{position:absolute;top:calc(100% + 4px);left:0;right:0;z-index:40;max-height:220px;overflow:auto;background:#fffdf9;border:1px solid #e6c7af;border-radius:12px;box-shadow:0 14px 30px #3d291b2d;padding:5px}
.nl-infra .i-seller-option{width:100%;border:0;text-align:left;border-radius:8px;padding:9px 11px;background:transparent;color:#533723;display:block}
.nl-infra .i-seller-option:hover,.nl-infra .i-seller-option:focus{background:#fff0dc;outline:2px solid #e1b18c;outline-offset:-2px}
.nl-infra .i-activity-list{max-height:285px;overflow:auto}.nl-infra .i-activity-row{display:flex;justify-content:space-between;gap:15px;padding:12px 9px;border-top:1px solid #f0e2d7}
.nl-infra .i-activity-row strong{color:#a74612;white-space:nowrap}
.i-picker-modal{border-radius:20px;overflow:hidden;border:1px solid #eac6aa;box-shadow:0 24px 70px #3a221c52}
.i-picker-modal .modal-header{background:#fff1e3;padding:22px}.i-picker-modal .modal-body{padding:22px}.i-picker-modal .modal-footer{background:#fff9f2}
.i-country-results{max-height:310px;overflow:auto;display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:5px}
.i-country-option{border:1px solid #eedbcc;border-radius:9px;background:#fffaf4;color:#63412e;padding:9px;text-align:left;font-size:.83rem}
.i-country-option:hover,.i-country-option:focus{background:#ffedd8;border-color:#d96e2b}
@media(max-width:580px){.i-country-results{grid-template-columns:1fr}.nl-infra .i-record-header{padding:18px 15px}}
@media(prefers-reduced-motion:reduce){.nl-infra .i-code-copy{transition:none;transform:none!important}}

.nl-infra .i-selected-summary{border-radius:11px;border:1px solid #eac6a8;background:#fff1e0;padding:12px}
.nl-infra .i-selected-summary strong,.nl-infra .i-selected-summary small{display:block}
.nl-infra .i-selected-summary strong{font-size:.95rem;color:#754020}.nl-infra .i-selected-summary small{font-size:.78rem;margin-top:6px;color:#8a6851}
/* Full edit now uses a proper centered popup instead of the side drawer. */
#iInfraEditModal .modal-dialog{max-width:min(920px,96vw)}
#iInfraEditModal .modal-content{border-radius:24px;overflow:hidden}
#iInfraEditModal .modal-body{overflow-y:auto}

.nl-infra .i-hero-art{position:relative;z-index:1;min-height:224px;align-self:center;display:flex;align-items:center;justify-content:center}
.nl-infra .i-hero-scene{width:min(100%,480px);height:auto;filter:drop-shadow(0 14px 18px #ab683c25)}
.nl-infra .i-hero-scene .i-ship{animation:iShipSway 5s ease-in-out infinite}
.nl-infra .i-hero-scene .i-waves{animation:iWaveShift 6s ease-in-out infinite}
.nl-infra .i-hero-scene .i-crane{animation:iCraneShift 8s ease-in-out infinite;transform-origin:73px 58px}
@keyframes iShipSway{0%,100%{transform:translateY(0)}50%{transform:translateY(-5px)}}
@keyframes iWaveShift{0%,100%{transform:translateX(-5px)}50%{transform:translateX(8px)}}
@keyframes iCraneShift{0%,100%{transform:rotate(0)}50%{transform:rotate(1deg)}}
body[data-nl-screen="module1-infrastructure"] #iInfraEditModal .modal-dialog{max-width:min(900px,94vw);margin-left:auto;margin-right:auto}
body[data-nl-screen="module1-infrastructure"] #iInfraEditModal .modal-content{border-radius:24px;background:#fffaf4}
body[data-nl-screen="module1-infrastructure"] #iNewCompanyModal .modal-content,
body[data-nl-screen="module1-infrastructure"] #iCountryModal .modal-content{background:#fffaf4;border:1px solid #e9c7a9;border-radius:24px;box-shadow:0 24px 60px #48281340}
body[data-nl-screen="module1-infrastructure"] #iNewCompanyModal .modal-header,
body[data-nl-screen="module1-infrastructure"] #iCountryModal .modal-header{background:linear-gradient(118deg,#fff1e2,#ffe4ce);border-bottom:1px solid #e8cbb2}
body[data-nl-screen="module1-infrastructure"] #iNewCompanyModal .modal-footer,
body[data-nl-screen="module1-infrastructure"] #iCountryModal .modal-footer{background:#fff2e6;border-top:1px solid #e8cbb2}
body[data-nl-screen="module1-infrastructure"] #iNewCompanyModal .i-primary,
body[data-nl-screen="module1-infrastructure"] #iCountryModal .i-primary{background:linear-gradient(110deg,#be4511,#e8691d);color:white;border:1px solid #b64513;font-weight:750;border-radius:11px}
body[data-nl-screen="module1-infrastructure"] #iNewCompanyModal label,
body[data-nl-screen="module1-infrastructure"] #iCountryModal label{color:#603b27;font-weight:750}
body[data-nl-screen="module1-infrastructure"] #iNewCompanyModal .form-control,
body[data-nl-screen="module1-infrastructure"] #iCountryModal .form-control{border-color:#dec1a8;background:#fffdf9;border-radius:11px}
body[data-nl-screen="module1-infrastructure"] #iNewCompanyModal .form-control:focus,
body[data-nl-screen="module1-infrastructure"] #iCountryModal .form-control:focus{border-color:#d75d1e;box-shadow:0 0 0 3px #df884830}
@media(max-width:900px){.nl-infra .i-hero-art{min-height:185px}}
@media(prefers-reduced-motion:reduce){.nl-infra .i-hero-scene *{animation:none!important;transition:none!important}}

/* Moving cargo vessel, quay crane and water: all drawn with CSS in this JSP. */
.nl-infra .i-hero-scene{width:min(100%,480px);height:245px;position:relative;isolation:isolate;flex:none;filter:drop-shadow(0 16px 18px rgba(135,67,31,.11))}
.nl-infra .i-visual-halo{position:absolute;inset:6px 23px 16px;border:1px solid rgba(211,102,40,.16);border-radius:50%;background:radial-gradient(circle at 50% 46%,rgba(255,253,247,.82),rgba(254,216,175,.12) 70%,transparent 72%)}
.nl-infra .i-css-crane{position:absolute;z-index:2;top:29px;left:16%;width:158px;height:157px;animation:iCraneSway 8s ease-in-out infinite}
.nl-infra .i-crane-post{position:absolute;bottom:0;left:30px;width:11px;height:136px;border-radius:4px;background:#9c4b25;box-shadow:inset -3px 0 #eaa16e}
.nl-infra .i-crane-beam{position:absolute;top:16px;left:26px;width:126px;height:10px;border-radius:5px;background:#bd5f2b;transform:rotate(-10deg);transform-origin:left}
.nl-infra .i-crane-rope{position:absolute;top:11px;right:18px;width:3px;height:71px;background:#ad784c}
.nl-infra .i-crane-hook{position:absolute;top:79px;right:13px;width:15px;height:18px;border:4px solid #ad5c29;border-top:0;border-radius:0 0 12px 12px}
.nl-infra .i-css-ship{position:absolute;z-index:4;bottom:52px;right:7%;width:70%;height:125px;animation:iShipBob 5.5s ease-in-out infinite}
.nl-infra .i-css-ship-deck{position:absolute;bottom:35px;right:22px;left:18px;height:72px}
.nl-infra .i-css-hull{position:absolute;bottom:0;left:0;right:0;height:48px;background:linear-gradient(135deg,#9b4828,#d66d34);clip-path:polygon(0 0,100% 0,88% 100%,13% 100%);border-radius:7px 7px 28px 28px;box-shadow:inset 0 -9px #793d28}
.nl-infra .i-css-container{position:absolute;bottom:0;width:57px;height:37px;border:2px solid #95522d;background:repeating-linear-gradient(90deg,#e38a52 0 7px,#f3a96a 7px 12px);border-radius:5px}
.nl-infra .i-con-one{left:45px}.nl-infra .i-con-two{left:106px;background:repeating-linear-gradient(90deg,#f7c18a 0 8px,#f8d3a4 8px 14px)}.nl-infra .i-con-three{left:168px}.nl-infra .i-con-four{left:107px;bottom:39px;background:repeating-linear-gradient(90deg,#bf5e32 0 8px,#d77642 8px 14px)}
.nl-infra .i-css-bridge{position:absolute;bottom:0;left:0;width:42px;height:55px;background:#fff6e7;border:3px solid #a35d33;border-radius:7px 7px 0 0;box-shadow:inset 0 13px #9c5c3b}
.nl-infra .i-css-waves{position:absolute;z-index:5;bottom:30px;left:10%;width:83%;height:40px;display:flex;justify-content:space-around;gap:7px;animation:iWaveWander 6s ease-in-out infinite}
.nl-infra .i-css-waves span{height:20px;flex:1;border-bottom:4px solid #c47c53;border-radius:50%;transform:rotate(-4deg)}.nl-infra .i-css-waves span:nth-child(even){transform:rotate(5deg);margin-top:12px;opacity:.7}
.nl-infra .i-css-bubble{position:absolute;width:9px;height:9px;border:2px solid #e1a06c;border-radius:50%;animation:iBubble 5s ease-in-out infinite}.nl-infra .i-bubble-one{right:11%;top:25px}.nl-infra .i-bubble-two{left:42%;top:16px;animation-delay:1.4s}
@keyframes iCraneSway{0%,100%{transform:rotate(0)}50%{transform:rotate(1.5deg)}}
@keyframes iShipBob{0%,100%{transform:translateY(0) rotate(0)}50%{transform:translateY(-7px) rotate(.5deg)}}
@keyframes iWaveWander{0%,100%{transform:translateX(-5px)}50%{transform:translateX(9px)}}
@keyframes iBubble{0%,100%{opacity:.8;transform:translateY(0)}50%{opacity:.25;transform:translateY(-8px)}}
@media(max-width:540px){.nl-infra .i-hero-scene{transform:scale(.82);transform-origin:center}}
@media(prefers-reduced-motion:reduce){.nl-infra .i-hero-scene *{animation:none!important}}


/* v16.6 compact reference directory hero; artwork remains CSS-only. */
.nl-infra .i-hero{padding:18px 23px!important;min-height:0!important}
.nl-infra .i-hero-grid{grid-template-columns:minmax(0,1.7fr) minmax(210px,.55fr)!important;align-items:center!important}
.nl-infra .i-hero-art{min-height:140px!important;max-height:153px!important;overflow:hidden}
.nl-infra .i-hero-scene{height:245px;transform:scale(.62);transform-origin:50% 19%;margin-top:0}
.nl-infra .i-metrics{margin-top:10px!important}
.nl-infra .i-stat{padding:7px 12px!important;min-width:110px!important}
.nl-infra .i-stat strong{font-size:1.14rem!important}
@media(max-width:920px){.nl-infra .i-hero-grid{grid-template-columns:1fr!important}.nl-infra .i-hero-art{display:none!important}}

/* v18.1: readable directory actions and aligned filters */
.nl-infra #iVesselTable{min-width:850px}
.nl-infra .i-assigned-count{display:inline-flex;align-items:center;gap:6px;padding:6px 10px;border:1px solid #ebd7c4;background:#fff7ed;border-radius:999px;color:#6c4227;font-size:.82rem;font-weight:800;white-space:nowrap}
.nl-infra #iVesselTable td:nth-child(5){font-variant-numeric:tabular-nums}
.nl-infra .i-toolbar{display:grid;grid-template-columns:minmax(220px,1fr) minmax(170px,215px) auto auto;align-items:center;gap:10px}
.nl-infra .i-toolbar .form-control,.nl-infra .i-toolbar .form-select{width:100%;min-width:0;max-width:none;margin:0}
.nl-infra .i-toolbar .i-result-count{margin-left:0;white-space:nowrap;text-align:right}
.nl-infra .i-toolbar .i-secondary{white-space:nowrap}
@media(max-width:970px){.nl-infra .i-toolbar{grid-template-columns:minmax(0,1fr) minmax(160px,220px)}.nl-infra .i-toolbar .i-result-count{text-align:left}}
@media(max-width:560px){.nl-infra .i-toolbar{grid-template-columns:1fr}.nl-infra .i-toolbar .i-result-count{white-space:normal}}
/* v18.2 – explain protected actions while keeping original buttons and server checks. */
.nl-infra .i-action-note{display:block;width:100%;color:#926b51;font-size:.74rem;line-height:1.35;margin-top:3px}
.nl-infra .i-actions .i-row-btn:disabled{opacity:.53;cursor:not-allowed;background:#f3ece5;color:#795e4c;border-color:#e8d7c7}
.nl-infra #iAddPortForm .form-text{min-height:15px;margin-top:5px;font-size:.78rem}
.nl-infra #iAddPortForm>div{min-width:0}
.nl-infra #iAddPortForm .i-picker-wrap{min-height:43px;align-items:stretch}
.nl-infra #iAddPortForm .i-picker-wrap input{min-width:0;flex:1}
.nl-infra #iAddPortForm .i-picker-wrap .nl18-field-counter{position:absolute;top:calc(100% + 3px);right:0;white-space:nowrap;font-size:.74rem}
.nl-infra #iAddPortForm .i-picker-action{white-space:nowrap;flex:none}
.nl-infra #iAddPortForm .i-form-steps{display:flex;gap:7px;flex-wrap:wrap;padding:0 0 7px;border-bottom:1px solid #f0ddce}
.nl-infra #iAddPortForm .i-form-steps span{font-size:.78rem;border-radius:999px;padding:6px 10px;background:#fff2e6;color:#9f511e;font-weight:750;border:1px solid #f0d9c8}
@media(max-width:620px){.nl-infra #iAddPortForm .i-picker-wrap{flex-wrap:wrap}.nl-infra #iAddPortForm .i-picker-action{min-height:40px}}

/* v18.3: Return to compact vessel management with clear, usable actions. */
.nl-infra #iAddVesselForm{row-gap:13px}
.nl-infra #iAddVesselForm .form-text{margin-top:5px;min-height:0}
.nl-infra #iAddVesselForm .nl18-field-counter{font-size:.72rem}
.nl-infra #iVesselTable .i-actions{gap:6px;align-items:center;flex-wrap:nowrap}
.nl-infra #iVesselTable .i-actions .i-row-btn{padding:8px 10px}
.nl-infra #iVesselTable td{padding-top:12px;padding-bottom:12px}
.nl-infra #iVesselTable .i-actions form{flex:none}
@media(max-width:980px){.nl-infra #iVesselTable .i-actions{flex-wrap:wrap}}
/* v18.6: compact, aligned Admin forms and searchable Seller picker. */
.nl-infra #iAddPortForm{row-gap:10px!important;align-items:start}
.nl-infra #iAddPortForm>.col-12,.nl-infra #iAddPortForm>.col-md-5,.nl-infra #iAddPortForm>.col-md-6,.nl-infra #iAddPortForm>.col-md-7{min-width:0}
.nl-infra #iAddPortForm .i-field-group-label{display:flex;align-items:baseline;justify-content:space-between;gap:8px;border-bottom:1px solid #efdfd1;padding:10px 0 6px;margin:5px 0 0}
.nl-infra #iAddPortForm .i-field-group-label span{font-size:.87rem;color:#97451d;font-weight:800}
.nl-infra #iAddPortForm .i-field-group-label small{font-size:.76rem;color:#806a58;text-align:right}
.nl-infra #iAddPortForm .i-field-group-label em{font-weight:500;font-style:normal;color:#846a57}
.nl-infra #iAddPortForm label{display:block;min-height:20px;margin-bottom:5px}
.nl-infra #iAddPortForm .nl18-field-counter{display:block!important;position:static!important;clear:both;text-align:right;margin-top:4px!important;font-size:.73rem!important;line-height:1.2;color:#907461}
.nl-infra #iAddPortForm .i-picker-wrap{display:grid!important;grid-template-columns:minmax(0,1fr) auto;grid-template-rows:auto auto;align-items:stretch;gap:4px 7px;min-height:0!important}
.nl-infra #iAddPortForm .i-picker-wrap>input{grid-column:1;grid-row:1;min-width:0;width:100%}
.nl-infra #iAddPortForm .i-picker-wrap>.i-picker-action{grid-column:2;grid-row:1;align-self:stretch}
.nl-infra #iAddPortForm .i-picker-wrap>.nl18-field-counter{grid-column:1/-1;grid-row:2;margin:0!important}
.nl-infra #iAddPortForm .form-text{min-height:0!important;line-height:1.4}
.nl-infra #iAddPortForm .i-form-steps{gap:6px;padding:0 0 9px}
.nl-infra #iAddPortForm .i-form-steps span{background:#fff9f3;border-color:#eedac6;font-size:.74rem}
.nl-infra #iAddPortForm>.col-12:last-child{margin-top:16px;padding-top:14px;border-top:1px solid #efdfd1}
.nl-infra .i-seller-select{position:relative}
.nl-infra .i-seller-select .form-control{padding-right:51px}
.nl-infra .i-seller-toggle{position:absolute;top:3px;right:3px;width:39px;height:37px;border:0;border-left:1px solid #ecd9c7;border-radius:0 9px 9px 0;background:#fff6ed;color:#a45120;display:grid;place-items:center;z-index:2}
.nl-infra .i-seller-toggle:hover,.nl-infra .i-seller-toggle[aria-expanded="true"]{background:#ffead7}
.nl-infra .i-seller-toggle span{display:block;width:9px;height:9px;border-right:2px solid currentColor;border-bottom:2px solid currentColor;transform:rotate(45deg) translateY(-2px)}
.nl-infra .i-seller-suggest{max-height:285px;overflow:auto;overscroll-behavior:contain;box-shadow:0 18px 38px #54381c2b;border-radius:12px;z-index:70}
.nl-infra .i-seller-count{padding:8px 11px;color:#8a6145;font-size:.75rem;border-bottom:1px solid #f1dfd0;background:#fff8ef;font-weight:750}
.nl-infra .i-seller-option{font-size:.84rem;line-height:1.35;padding:10px 12px}
.nl-infra #iAddVesselForm{row-gap:11px;align-items:start}
.nl-infra #iAddVesselForm>div{min-width:0}
.nl-infra #iAddVesselForm .nl18-field-counter{display:block;text-align:right;font-size:.73rem;margin-top:4px}
.nl-infra #iAddVesselForm .form-text{font-size:.78rem;line-height:1.45;margin-top:6px}
.nl-infra #iAddVesselForm>.col-12:last-child{margin-top:15px;padding-top:13px;border-top:1px solid #efdfd1}
@media(max-width:560px){.nl-infra #iAddPortForm .i-field-group-label{display:block}.nl-infra #iAddPortForm .i-field-group-label small{display:block;text-align:left;margin-top:3px}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .i-work-card,html[data-nl-mode="dark"] body.nl-themed-page .i-panel,html[data-nl-mode="dark"] body.nl-themed-page .i-table-wrap,html[data-nl-mode="dark"] body.nl-themed-page .i-record-section,html[data-nl-mode="dark"] body.nl-themed-page .i-selected-summary,html[data-nl-mode="dark"] body.nl-themed-page .i-modal-note,html[data-nl-mode="dark"] body.nl-themed-page .i-toolbar{background:#203044!important;color:#edf5fc!important;border-color:#516b83!important}
html[data-nl-mode="dark"] body.nl-themed-page .i-work-card :is(h2,h3,label,.i-kicker,p,small),html[data-nl-mode="dark"] body.nl-themed-page .i-table-wrap :is(th,td){color:#e9f2fa!important}
html[data-nl-mode="dark"] body.nl-themed-page .i-picker-action,html[data-nl-mode="dark"] body.nl-themed-page .i-picker-modal,html[data-nl-mode="dark"] body.nl-themed-page .i-country-option,html[data-nl-mode="dark"] body.nl-themed-page .i-seller-option{background:#2b3e52!important;color:#f4f7fc!important;border-color:#526d86!important}

/* v20.23 - directory controls, modals, and responsive admin forms */
body[data-nl-screen="module1-infrastructure"] .i-toolbar,body[data-nl-screen="module1-infrastructure"] .i-filter-row{gap:10px!important;flex-wrap:wrap!important}
body[data-nl-screen="module1-infrastructure"] :is(.i-toolbar,.i-filter-row) :is(input,select){min-width:0!important}
body[data-nl-screen="module1-infrastructure"] :is(.i-panel,.i-card,.i-detail){border-radius:15px!important}
body[data-nl-screen="module1-infrastructure"] .modal-content{overflow:hidden}
@media(max-width:750px){body[data-nl-screen="module1-infrastructure"] :is(.i-toolbar,.i-filter-row){align-items:stretch!important}body[data-nl-screen="module1-infrastructure"] :is(.i-toolbar,.i-filter-row) :is(.btn,button){min-height:42px}}

</style>
</head>
<body class="bg-light nl-themed-page bg-body-tertiary text-dark" data-nl-screen="module1-infrastructure" data-theme="n-logistic-orange" data-nl-enhanced="true">
<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0">
<div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div>
<div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5">
<div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">Administration / Reference data</div>
<div class="nl-view-body container-fluid p-0 px-0"><main class="nl-infra" id="infraTop">
<section class="i-hero">
 <div class="i-hero-grid">
  <div>
   <div class="i-eyebrow">Administration / Reference directory</div><h1>${requestScope.nlv_Module1_infrastructure__1}</h1>
   <p class="i-desc">Manage locations and fleets from their own Administration pages. Search existing records, add new ones, and update details without remembering database IDs.</p>
   <div class="i-metrics" aria-label="Directory overview">
     <div class="i-stat"><strong>${requestScope.nlv_Module1_infrastructure__2}</strong><span>Ports recorded</span></div>
     <div class="i-stat"><strong>${requestScope.nlv_Module1_infrastructure__3}</strong><span>Vessels recorded</span></div>
     <div class="i-stat"><strong>${requestScope.nlv_Module1_infrastructure__4}</strong><span>Active vessels</span></div>
     <div class="i-stat"><strong>${requestScope.nlv_Module1_infrastructure__5}</strong><span>In maintenance</span></div>
   </div>
  </div>
  <div class="i-hero-art" aria-hidden="true">
<div class="i-hero-scene" aria-hidden="true">
  <div class="i-visual-halo"></div>
  <div class="i-css-crane"><span class="i-crane-post"></span><span class="i-crane-beam"></span><span class="i-crane-rope"></span><span class="i-crane-hook"></span></div>
  <div class="i-css-ship"><div class="i-css-ship-deck"><span class="i-css-bridge"></span><span class="i-css-container i-con-one"></span><span class="i-css-container i-con-two"></span><span class="i-css-container i-con-three"></span><span class="i-css-container i-con-four"></span></div><div class="i-css-hull"></div></div>
  <div class="i-css-waves"><span></span><span></span><span></span></div>
  <span class="i-css-bubble i-bubble-one"></span><span class="i-css-bubble i-bubble-two"></span>
</div></div>
 </div>
</section>
${requestScope.nlv_Module1_infrastructure__6}
<nav class="i-tabbar" role="tablist" aria-label="Choose directory category">
 <button class="i-tab" id="iPortTab" type="button" role="tab" aria-controls="iPortsPanel" aria-selected="${requestScope.nlv_Module1_infrastructure__7}" data-infra-tab="ports">Ports <span class="i-count">${requestScope.nlv_Module1_infrastructure__8}</span></button>
 <button class="i-tab" id="iVesselTab" type="button" role="tab" aria-controls="iVesselsPanel" aria-selected="${requestScope.nlv_Module1_infrastructure__9}" data-infra-tab="vessels">Vessels <span class="i-count">${requestScope.nlv_Module1_infrastructure__10}</span></button>
 <span class="ms-auto small text-secondary">Also available as separate Administration menu links</span>
</nav>

<!-- PORTS -->
<section id="iPortsPanel" class="i-panel" role="tabpanel" aria-labelledby="iPortTab">
<div class="row g-3">
 <div class="col-xl-7">
  <section class="i-work-card" aria-labelledby="iAddPortTitle"><h2 id="iAddPortTitle">Add a port</h2><p class="i-help">Use the recognised port code and location. City and country provide suggestions as you type.</p>
  <form method="post" action="${requestScope.nlv_Module1_infrastructure__11}/adminInfrastructure" class="row g-3" id="iAddPortForm">
  <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_infrastructure__12}"><input type="hidden" name="action" value="addPort">
  <div class="col-12"><div class="i-form-steps" aria-label="Port registration sections"><span>1. Saved location</span><span>2. Port identity</span><span>3. City &amp; coordinates</span></div></div>
  <div class="col-12"><label for="iPortLocationTemplate">Choose a saved port location (optional)</label><select id="iPortLocationTemplate" class="form-select"><option value="">Use custom city and country</option><jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="fragment" value="nlv_Module1_infrastructure__13" /><jsp:getProperty name="nlViewSupport_Module1_infrastructure" property="fragment" /></select><div class="form-text">Choosing an existing location fills city, country and coordinates. Use a new code and port name for the new record.</div></div>
  <div class="col-12 i-field-group-label"><span>Port identity</span><small>Enter a unique recognised port code and name.</small></div>
  <div class="col-md-5"><label for="iPortCode">Port code <span class="text-danger">*</span></label><input id="iPortCode" class="form-control" name="portCode" maxlength="10" placeholder="e.g. INBOM" pattern="[A-Za-z0-9]{2,10}" required="required"><div class="form-text">2–10 letters or numbers</div></div>
  <div class="col-md-7"><label for="iPortName">Port name <span class="text-danger">*</span></label><input id="iPortName" class="form-control" name="portName" maxlength="100" placeholder="e.g. Mumbai Port" required="required"></div>
  <div class="col-12 i-field-group-label"><span>Location</span><small>City and country identify the port location.</small></div>
  <div class="col-md-6"><label for="iPortCity">City</label><input id="iPortCity" class="form-control" name="city" list="iCityOptions" maxlength="60" placeholder="Choose or type city"></div>
  <div class="col-md-6"><label for="iPortCountry">Country</label><div class="i-picker-wrap"><input id="iPortCountry" class="form-control" name="country" maxlength="60" placeholder="Select country or type a name"><button type="button" class="i-picker-action" data-i-country="iPortCountry" aria-label="Browse countries">Choose</button></div></div>
  <div class="col-12 i-field-group-label"><span>Coordinates <em>(optional)</em></span><small>Use decimal degrees if available.</small></div>
  <div class="col-md-6"><label for="iPortLat">Latitude <span class="i-small">(optional)</span></label><input id="iPortLat" class="form-control" name="latitude" type="number" step="0.000001" min="-90" max="90" placeholder="18.943"></div>
  <div class="col-md-6"><label for="iPortLon">Longitude <span class="i-small">(optional)</span></label><input id="iPortLon" class="form-control" name="longitude" type="number" step="0.000001" min="-180" max="180" placeholder="72.845"></div>
  <div class="col-12 d-flex flex-wrap gap-2 align-items-center"><button type="submit" class="btn i-primary">+ Add port</button><button class="btn i-secondary" type="reset">Clear form</button><small class="text-secondary">Required fields are marked *</small></div>
  </form></section>
 </div>
 <div class="col-xl-5">
  <section class="i-work-card" aria-labelledby="iManagePortsTitle"><h2 id="iManagePortsTitle">Update an existing port</h2><p class="i-help">Select a port by its name, then change any of its details in one window.</p>
   <label for="iPortSelector">Choose port</label><select id="iPortSelector" class="form-select mb-3"><option value="">Select an existing port...</option>
   <jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="fragment" value="nlv_Module1_infrastructure__14" /><jsp:getProperty name="nlViewSupport_Module1_infrastructure" property="fragment" />
   </select><div id="iSelectedPortSummary" class="i-selected-summary mb-3" hidden="hidden"><strong id="iSelectedPortName"></strong><small id="iSelectedPortDetails"></small></div>
   <button type="button" class="btn i-primary w-100" id="iEditSelectedPort" disabled="disabled">Open full port editor</button>
   <div class="i-detail mt-3"><strong>Safe changes</strong><div class="mt-1">A port already used by shipments cannot be removed. Updating its information preserves the existing relationships.</div></div>
  </section>
 </div>
</div>
<datalist id="iCityOptions"><option value="Mumbai"></option><option value="Navi Mumbai"></option><option value="Chennai"></option><option value="Kolkata"></option><option value="Dubai"></option><option value="Singapore"></option><option value="Rotterdam"></option><option value="Los Angeles"></option><option value="Hamburg"></option><jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="fragment" value="nlv_Module1_infrastructure__15" /><jsp:getProperty name="nlViewSupport_Module1_infrastructure" property="fragment" /></datalist>

<section class="i-record-section" aria-labelledby="iPortListTitle">
 <div class="i-record-header"><div><h2 id="iPortListTitle">Port directory</h2><p>Search by port code, name, city or country. Use Edit to update all fields at once.</p></div><button class="btn i-secondary" type="button" data-i-export="ports">Export CSV</button></div>
 <div class="i-toolbar"><label class="visually-hidden" for="iPortSearch">Search ports</label><input id="iPortSearch" type="search" class="form-control" placeholder="Search ports..." autocomplete="off"><button class="btn i-secondary" type="button" data-i-clear="ports">Clear</button><span class="i-result-count" id="iPortCount">Showing ${requestScope.nlv_Module1_infrastructure__16} ports</span></div>
 <div class="i-table-wrap"><table class="i-table" id="iPortTable" data-nl-enhanced="true" data-nl-no-auto-copy="true"><thead><tr><th>Port</th><th>Code</th><th>Location</th><th>Active shipments</th><th>Coordinates</th><th>Actions</th></tr></thead><tbody>
 <jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="fragment" value="nlv_Module1_infrastructure__17" /><jsp:getProperty name="nlViewSupport_Module1_infrastructure" property="fragment" />
 </tbody></table><div id="iPortEmpty" class="i-empty" hidden="hidden">No ports match your search. Clear the search to see all records.</div></div>
</section>
<section class="i-work-card i-activity-card mt-3" aria-label="Port shipment activity">
 <div class="d-flex justify-content-between flex-wrap gap-2 align-items-center"><div><h2>Port shipment activity</h2><p class="i-help mb-0">Live count of shipments still in progress, including origins and destinations. Completed and cancelled shipments are excluded.</p></div><button type="button" class="btn i-secondary" id="iTogglePortActivity" aria-expanded="false" aria-controls="iPortActivityPanel">Show activity summary</button></div>
 <div id="iPortActivityPanel" hidden="hidden" class="i-activity-list mt-3">
 ${requestScope.nlv_Module1_infrastructure__18}
 </div>
</section>
</section>

<!-- VESSELS -->
<section id="iVesselsPanel" class="i-panel" role="tabpanel" aria-labelledby="iVesselTab" hidden="hidden">
<div class="row g-3"><div class="col-xl-7"><section class="i-work-card" aria-labelledby="iAddVesselTitle"><h2 id="iAddVesselTitle">Add a vessel</h2><p class="i-help">Search for the Seller by name, or type a new one and add its details without leaving this page. IMO numbers are validated before saving.</p>
<form method="post" action="${requestScope.nlv_Module1_infrastructure__19}/adminInfrastructure" class="row g-3" id="iAddVesselForm">
<input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_infrastructure__20}"><input type="hidden" name="action" value="addVessel">
<div class="col-md-6"><label for="iVesselName">Vessel name</label><input id="iVesselName" name="vesselName" class="form-control" maxlength="100" placeholder="e.g. NLOG Amber Voyager" required="required"></div>
<div class="col-md-6"><label for="iVesselImo">IMO number <span class="i-small">(optional)</span></label><input id="iVesselImo" name="imoNumber" class="form-control" maxlength="7" pattern="[0-9]{7}" placeholder="7 digit IMO"><div id="iImoFeedback" class="form-text">Enter all 7 digits, including the check digit.</div></div>
<div class="col-md-7"><label for="iOwnerName">Owner / Seller company</label><div class="i-combo i-seller-select" data-i-seller-picker="add"><input type="hidden" id="iOwner" name="ownerCompanyId" value=""><input id="iOwnerName" type="text" class="form-control" autocomplete="off" maxlength="150" placeholder="Search or choose a Seller company" role="combobox" aria-autocomplete="list" aria-expanded="false" aria-controls="iSellerSuggestAdd"><button type="button" class="i-seller-toggle" data-i-seller-toggle="add" aria-label="Show all Seller companies" aria-expanded="false" aria-controls="iSellerSuggestAdd"><span aria-hidden="true"></span></button><div class="i-seller-suggest" id="iSellerSuggestAdd" role="listbox" hidden="hidden"></div></div><div class="form-text">Type to search, or select the arrow to browse all existing Sellers. You can still enter a new company name.</div></div>
<div class="col-md-5"><label for="iCapacity">Capacity (TEU)</label><input id="iCapacity" name="capacityTeu" class="form-control" type="number" min="1" step="1" placeholder="e.g. 2500"><div class="form-text">TEU = twenty-foot container units</div></div>
<div class="col-12 d-flex flex-wrap gap-2 align-items-center"><button class="btn i-primary" type="submit">+ Add vessel</button><button class="btn i-secondary" type="reset">Clear form</button><span class="small text-secondary">New vessels start as Active.</span></div>
</form></section></div>
<div class="col-xl-5"><section class="i-work-card" aria-labelledby="iManageVesselsTitle"><h2 id="iManageVesselsTitle">Update a vessel</h2><p class="i-help">Change its name, IMO number, owner or capacity, or adjust its operating status.</p>
<label for="iVesselSelector">Choose vessel</label><select id="iVesselSelector" class="form-select mb-3"><option value="">Select an existing vessel...</option><jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="fragment" value="nlv_Module1_infrastructure__21" /><jsp:getProperty name="nlViewSupport_Module1_infrastructure" property="fragment" /></select>
<div id="iSelectedVesselSummary" class="i-selected-summary mb-3" hidden="hidden"><strong id="iSelectedVesselName"></strong><small id="iSelectedVesselDetails"></small></div>
<button class="btn i-primary w-100" type="button" id="iEditSelectedVessel" disabled="disabled">Open full vessel editor</button>
<div class="i-detail mt-3"><strong>About vessel actions</strong><div class="mt-1">Maintenance pauses new assignments and keeps existing shipment history. Only vessels never referenced by a shipment can be deleted.</div></div>
</section></div></div>
<section class="i-record-section" aria-labelledby="iVesselListTitle"><div class="i-record-header"><div><h2 id="iVesselListTitle">Vessel directory</h2><p>See Seller, IMO, capacity, assignments and operating status. Maintenance stops future assignments; shipment history stays intact.</p></div><button class="btn i-secondary" type="button" data-i-export="vessels">Export CSV</button></div>
<div class="i-toolbar"><label class="visually-hidden" for="iVesselSearch">Search vessels</label><input id="iVesselSearch" type="search" class="form-control" placeholder="Search vessel name, IMO, Seller..." autocomplete="off"><label class="visually-hidden" for="iStatusFilter">Vessel status</label><select id="iStatusFilter" class="form-select"><option value="">All statuses</option><option value="ACTIVE">Active</option><option value="MAINTENANCE">Maintenance</option></select><button class="btn i-secondary" type="button" data-i-clear="vessels">Clear</button><span id="iVesselCount" class="i-result-count">Showing ${requestScope.nlv_Module1_infrastructure__22} vessels</span></div>
<div class="i-table-wrap"><table class="i-table" id="iVesselTable" data-nl-enhanced="true" data-nl-no-auto-copy="true"><thead><tr><th>Vessel</th><th>IMO</th><th>Owner / Seller</th><th>Capacity</th><th>Active shipments</th><th>Status</th><th>Actions</th></tr></thead><tbody>
<jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="fragment" value="nlv_Module1_infrastructure__23" /><jsp:getProperty name="nlViewSupport_Module1_infrastructure" property="fragment" /></tbody></table><div id="iVesselEmpty" class="i-empty" hidden="hidden">No vessels match the selected filters.</div></div></section>
</section>

<div id="iSellerData" hidden="hidden" aria-hidden="true">${requestScope.nlv_Module1_infrastructure__24}</div>
<!-- Full-edit modal: prefilled from the corresponding record (one user action per transaction) -->
<div class="modal fade i-modal" id="iInfraEditModal" tabindex="-1" aria-labelledby="iModalTitle" aria-hidden="true">
 <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable"><div class="modal-content">
 <div class="modal-header"><div><div class="i-eyebrow">Administration / Update</div><h2 id="iModalTitle" class="modal-title fs-4">Edit record</h2><div class="small text-secondary" id="iModalSub">Update all details in one place.</div></div><button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Close"></button></div>
 <form id="iEditPortForm" method="post" action="${requestScope.nlv_Module1_infrastructure__25}/adminInfrastructure" hidden="hidden">
 <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_infrastructure__26}"><input type="hidden" name="action" value="updatePortDetails"><input type="hidden" name="id" id="iEditPortId">
 <div class="modal-body row g-3"><div class="col-md-4"><label for="iEditPortCode">Port code *</label><input id="iEditPortCode" name="portCode" class="form-control" maxlength="10" pattern="[A-Za-z0-9]{2,10}" required="required"></div><div class="col-md-8"><label for="iEditPortName">Port name *</label><input id="iEditPortName" name="portName" class="form-control" maxlength="100" required="required"></div>
 <div class="col-md-6"><label for="iEditPortCity">City</label><input id="iEditPortCity" name="city" list="iCityOptions" class="form-control" maxlength="60"></div><div class="col-md-6"><label for="iEditPortCountry">Country</label><div class="i-picker-wrap"><input id="iEditPortCountry" name="country" class="form-control" maxlength="60"><button type="button" class="i-picker-action" data-i-country="iEditPortCountry" aria-label="Browse countries">Choose</button></div></div>
 <div class="col-md-6"><label for="iEditPortLat">Latitude</label><input id="iEditPortLat" name="latitude" type="number" min="-90" max="90" step="0.000001" class="form-control"></div><div class="col-md-6"><label for="iEditPortLon">Longitude</label><input id="iEditPortLon" name="longitude" type="number" min="-180" max="180" step="0.000001" class="form-control"></div><div class="col-12"><div class="i-panel-summary">All these details are saved together. Existing port references remain linked to this record.</div></div></div>
 <div class="modal-footer"><button class="btn i-secondary" type="button" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn i-primary">Save port changes</button></div>
 </form>
 <form id="iEditVesselForm" method="post" action="${requestScope.nlv_Module1_infrastructure__27}/adminInfrastructure" hidden="hidden">
 <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_infrastructure__28}"><input type="hidden" name="action" value="updateVesselDetails"><input type="hidden" name="id" id="iEditVesselId">
 <div class="modal-body row g-3"><div class="col-md-6"><label for="iEditVesselName">Vessel name *</label><input id="iEditVesselName" name="vesselName" class="form-control" maxlength="100" required="required"></div><div class="col-md-6"><label for="iEditVesselImo">IMO number</label><input id="iEditVesselImo" name="imoNumber" pattern="[0-9]{7}" maxlength="7" class="form-control"><div class="form-text">Seven digits with a valid check digit</div></div>
 <div class="col-md-7"><label for="iEditVesselOwner">Owner / Seller</label><div class="i-combo i-seller-select" data-i-seller-picker="edit"><input type="hidden" name="ownerCompanyId" id="iEditVesselOwner" value=""><input id="iEditVesselOwnerName" type="text" class="form-control" autocomplete="off" maxlength="150" placeholder="Search or choose a Seller company" role="combobox" aria-autocomplete="list" aria-expanded="false" aria-controls="iSellerSuggestEdit"><button type="button" class="i-seller-toggle" data-i-seller-toggle="edit" aria-label="Show all Seller companies" aria-expanded="false" aria-controls="iSellerSuggestEdit"><span aria-hidden="true"></span></button><div class="i-seller-suggest" id="iSellerSuggestEdit" role="listbox" hidden="hidden"></div></div></div><div class="col-md-5"><label for="iEditVesselCapacity">Capacity (TEU)</label><input id="iEditVesselCapacity" name="capacityTeu" type="number" min="1" step="1" class="form-control"></div><div class="col-md-6"><label for="iEditVesselStatus">Operating status</label><select id="iEditVesselStatus" name="status" class="form-select"><option value="ACTIVE">Active – available for operations</option><option value="MAINTENANCE">Maintenance – unavailable for new journeys</option></select></div>
 <div class="col-12"><div class="i-panel-summary">Edit all vessel information and its operating status in one save. Maintenance keeps existing shipment assignments and prevents new ones; deletion remains protected when shipment history exists.</div></div></div>
 <div class="modal-footer"><button class="btn i-secondary" type="button" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn i-primary">Save vessel changes</button></div>
 </form>
 </div></div>
</div>
<!-- Searchable country picker: populated from ISO country labels, not duplicate browser datalist entries. -->
<div class="modal fade" id="iCountryModal" tabindex="-1" aria-labelledby="iCountryModalTitle" aria-hidden="true"><div class="modal-dialog modal-dialog-centered"><div class="modal-content i-picker-modal"><div class="modal-header"><div><div class="i-eyebrow">Location helper</div><h2 class="modal-title fs-4" id="iCountryModalTitle">Choose a country</h2><small class="text-secondary">Search and click a country to fill the form.</small></div><button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Close"></button></div><div class="modal-body"><label for="iCountryQuery">Search countries</label><input id="iCountryQuery" type="search" class="form-control mb-3" placeholder="Start typing a country name" autocomplete="off"><div id="iCountryResults" class="i-country-results" role="listbox" aria-label="Matching countries">${requestScope.nlv_Module1_infrastructure__29}</div><p id="iCountryNoResults" class="i-small mt-3" hidden="hidden">No matching country. You may type a different country in the form.</p></div><div class="modal-footer"><button type="button" class="btn i-secondary" data-bs-dismiss="modal">Close</button></div></div></div></div>
<!-- Create a new seller without leaving vessel registration; one atomic company+vessel transaction. -->
<div class="modal fade" id="iNewCompanyModal" tabindex="-1" aria-labelledby="iNewSellerTitle" aria-hidden="true"><div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable"><div class="modal-content i-picker-modal"><div class="modal-header"><div><div class="i-eyebrow">Vessel / New seller</div><h2 class="modal-title fs-4" id="iNewSellerTitle">Create Seller company and vessel</h2><small class="text-secondary">This Seller was not found. Enter the details to create both records together.</small></div><button class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Close"></button></div>
<form id="iCreateSellerVessel" method="post" action="${requestScope.nlv_Module1_infrastructure__30}/adminInfrastructure"><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_infrastructure__31}"><input type="hidden" name="action" value="addVesselWithNewSeller"><input type="hidden" name="vesselName" id="iNewSellerVesselName"><input type="hidden" name="imoNumber" id="iNewSellerImo"><input type="hidden" name="capacityTeu" id="iNewSellerCapacity"><div class="modal-body row g-3"><div class="col-md-8"><label for="iNewSellerName">Company name *</label><input name="companyName" id="iNewSellerName" class="form-control" maxlength="150" required="required"></div><div class="col-md-4"><label>Company type</label><input class="form-control" value="Seller" disabled="disabled"></div><div class="col-md-6"><label for="iNewSellerGst">GST number (optional)</label><input name="gstNumber" id="iNewSellerGst" maxlength="20" class="form-control"></div><div class="col-md-6"><label for="iNewSellerIec">IEC code (optional)</label><input name="iecCode" id="iNewSellerIec" maxlength="15" class="form-control"></div><div class="col-12"><label for="iNewSellerPortTemplate">Use an existing port location (optional)</label><select id="iNewSellerPortTemplate" class="form-select"><option value="">Enter a different city and country</option><jsp:setProperty name="nlViewSupport_Module1_infrastructure" property="fragment" value="nlv_Module1_infrastructure__32" /><jsp:getProperty name="nlViewSupport_Module1_infrastructure" property="fragment" /></select></div><div class="col-md-6"><label for="iNewSellerCity">City</label><input name="companyCity" id="iNewSellerCity" maxlength="60" class="form-control" list="iCityOptions"></div><div class="col-md-6"><label for="iNewSellerCountry">Country</label><div class="i-picker-wrap"><input name="companyCountry" id="iNewSellerCountry" maxlength="60" class="form-control"><button type="button" class="i-picker-action" data-i-country="iNewSellerCountry">Choose</button></div></div><div class="col-12"><label for="iNewSellerAddress">Address (optional)</label><textarea name="companyAddress" id="iNewSellerAddress" rows="2" class="form-control" maxlength="10000"></textarea></div><div class="col-12"><div class="i-panel-summary">The Seller company and vessel are saved in one transaction. If either is rejected by the database, neither is created.</div></div></div><div class="modal-footer"><button type="button" class="btn i-secondary" data-bs-dismiss="modal">Go back</button><button type="submit" class="btn i-primary">Create company &amp; vessel</button></div></form></div></div></div>
</main>
</div>
<%@ include file="../shared/_shell_end.jsp" %>
</div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){'use strict';
 const root=document.querySelector('.nl-infra');if(!root)return;
 // Reuse read-only port rows to help fill location fields without inventing new data.
 function fillFromSavedPort(picker,city,country,latitude,longitude){
  const select=document.getElementById(picker);if(!select)return;
  select.addEventListener('change',()=>{if(!select.value)return;
   const row=root.querySelector('tr[data-i-record="port"][data-id="'+select.value+'"]');if(!row)return;
   const values={};if(city)values[city]=row.dataset.city||'';if(country)values[country]=row.dataset.country||'';
   if(latitude)values[latitude]=row.dataset.latitude||'';if(longitude)values[longitude]=row.dataset.longitude||'';
   Object.entries(values).forEach(([id,value])=>{const el=document.getElementById(id);if(el){el.value=value;el.dispatchEvent(new Event('input',{bubbles:true}));}});
  });
 }
 fillFromSavedPort('iPortLocationTemplate','iPortCity','iPortCountry','iPortLat','iPortLon');
 fillFromSavedPort('iNewSellerPortTemplate','iNewSellerCity','iNewSellerCountry');
 const q=(s,scope)=> (scope||document).querySelector(s);
 const all=(s,scope)=> Array.from((scope||document).querySelectorAll(s));
 function chooseTab(tab){
  const chosen=tab==='vessels'?'vessels':'ports';
  all('[data-infra-tab]',root).forEach(b=>{const selected=b.dataset.infraTab===chosen;b.setAttribute('aria-selected',selected?'true':'false');b.tabIndex=selected?0:-1;});
  q('#iPortsPanel').hidden=chosen!=='ports';q('#iVesselsPanel').hidden=chosen!=='vessels';
  try{let url=new URL(window.location.href);url.searchParams.set('tab',chosen);history.replaceState(null,'',url.pathname+url.search+url.hash);}catch(e){}
 }
 all('[data-infra-tab]',root).forEach(b=>b.addEventListener('click',()=>chooseTab(b.dataset.infraTab)));
 const current=new URLSearchParams(location.search).get('tab');chooseTab(current);
 const editModal=q('#iInfraEditModal');
 function setValue(id,value){const el=q('#'+id);if(el)el.value=value==null?'':String(value);}
 function showEditor(kind,id){
  const row=q('tr[data-i-record="'+kind+'"][data-id="'+String(id)+'"]',root);if(!row)return;
  const isPort=kind==='port';q('#iModalTitle').textContent='Edit '+(isPort?'port':'vessel');
  q('#iModalSub').textContent=row.dataset.name+' — update all details together.';
  q('#iEditPortForm').hidden=!isPort;q('#iEditVesselForm').hidden=isPort;
  if(isPort){setValue('iEditPortId',row.dataset.id);setValue('iEditPortCode',row.dataset.code);setValue('iEditPortName',row.dataset.name);
   setValue('iEditPortCity',row.dataset.city);setValue('iEditPortCountry',row.dataset.country);
   setValue('iEditPortLat',row.dataset.latitude);setValue('iEditPortLon',row.dataset.longitude);
  }else{setValue('iEditVesselId',row.dataset.id);setValue('iEditVesselName',row.dataset.name);
   setValue('iEditVesselImo',row.dataset.imo);setValue('iEditVesselOwner',row.dataset.owner);
   const seller=all('#iSellerData [data-seller-id]').find(x=>x.dataset.sellerId===row.dataset.owner);
   setValue('iEditVesselOwnerName',seller?seller.dataset.sellerName:'');setValue('iEditVesselCapacity',row.dataset.capacity);setValue('iEditVesselStatus',row.dataset.status);}
  if(window.bootstrap&&bootstrap.Modal){bootstrap.Modal.getOrCreateInstance(editModal).show();}
  else {const note=document.createElement('div');note.className='i-banner i-error';note.setAttribute('role','alert');note.textContent='The editor could not open. Refresh the page and try again.';root.prepend(note);note.scrollIntoView({block:'center'});}
 }
 root.addEventListener('click',e=>{const b=e.target.closest('[data-i-edit]');if(b&&root.contains(b))showEditor(b.dataset.iEdit,b.dataset.id);});
 const portSel=q('#iPortSelector'),vesselSel=q('#iVesselSelector');
 portSel.addEventListener('change',()=>{
   q('#iEditSelectedPort').disabled=!portSel.value;
   const row=q('tr[data-i-record="port"][data-id="'+portSel.value+'"]',root);
   q('#iSelectedPortSummary').hidden=!row;
   if(row){q('#iSelectedPortName').textContent=row.dataset.name+' ('+row.dataset.code+')';
     q('#iSelectedPortDetails').textContent=(row.dataset.city||'City not set')+', '+(row.dataset.country||'Country not set');}
 });
 vesselSel.addEventListener('change',()=>{
   q('#iEditSelectedVessel').disabled=!vesselSel.value;
   const row=q('tr[data-i-record="vessel"][data-id="'+vesselSel.value+'"]',root);
   q('#iSelectedVesselSummary').hidden=!row;
   if(row){q('#iSelectedVesselName').textContent=row.dataset.name;
     q('#iSelectedVesselDetails').textContent='IMO: '+(row.dataset.imo||'not assigned')+' · '+(row.dataset.status==='ACTIVE'?'Active':'Maintenance');}
 });
 q('#iEditSelectedPort').addEventListener('click',()=>showEditor('port',portSel.value));
 q('#iEditSelectedVessel').addEventListener('click',()=>showEditor('vessel',vesselSel.value));
 function applyFilters(kind){
  const table=q(kind==='ports'?'#iPortTable':'#iVesselTable');const keyword=q(kind==='ports'?'#iPortSearch':'#iVesselSearch').value.trim().toLowerCase();
  const status=kind==='vessels'?q('#iStatusFilter').value:'';let shown=0;
  all('tbody tr',table).forEach(tr=>{const match=tr.textContent.toLowerCase().includes(keyword)&&(!status||tr.dataset.status===status);
    tr.hidden=!match;if(match)shown++;});
  q(kind==='ports'?'#iPortCount':'#iVesselCount').textContent='Showing '+shown+' of '+all('tbody tr',table).length+' '+kind;
  q(kind==='ports'?'#iPortEmpty':'#iVesselEmpty').hidden=shown!==0;
 }
 ['ports','vessels'].forEach(kind=>{
  q(kind==='ports'?'#iPortSearch':'#iVesselSearch').addEventListener('input',()=>applyFilters(kind));
  q('[data-i-clear="'+kind+'"]',root).addEventListener('click',()=>{
    q(kind==='ports'?'#iPortSearch':'#iVesselSearch').value='';if(kind==='vessels')q('#iStatusFilter').value='';applyFilters(kind);});
  q('[data-i-export="'+kind+'"]',root).addEventListener('click',()=>{
    const table=q(kind==='ports'?'#iPortTable':'#iVesselTable');
    const quote=text=>{let value=String(text).replace(/\s+/g,' ').trim();if(/^[=+@-]/.test(value))value="'"+value;return '"'+value.replace(/"/g,'""')+'"';};
    const rows=[all('thead th',table).slice(0,-1).map(c=>quote(c.textContent)).join(',')];
    all('tbody tr',table).filter(tr=>!tr.hidden).forEach(tr=>rows.push(all('td',tr).slice(0,-1).map(c=>quote(c.textContent)).join(',')));
    const blob=new Blob(['\uFEFF'+rows.join('\r\n')],{type:'text/csv;charset=utf-8'});
    const url=URL.createObjectURL(blob);const a=document.createElement('a');a.href=url;a.download='nlogistic-'+kind+'.csv';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
  });
 });
 q('#iStatusFilter').addEventListener('change',()=>applyFilters('vessels'));
 // Validate the IMO check digit before posting (the model and DB also enforce it).
 function checkImo(input,show){const value=input.value.trim();
   if(!value){input.setCustomValidity('');if(show)show.textContent='Optional. Enter seven digits including the check digit.';return true;}
   let valid=/^[0-9]{7}$/.test(value);
   if(valid){let sum=0;for(let i=0;i<6;i++)sum+=Number(value[i])*(7-i);valid=sum%10===Number(value[6]);}
   input.setCustomValidity(valid?'':'Enter a seven-digit IMO number with its correct check digit.');
   if(show)show.textContent=valid?'Valid IMO check digit.':'Invalid IMO number or check digit. Check the number.';
   return valid;
 }
 const addImo=q('#iVesselImo');addImo.addEventListener('input',()=>checkImo(addImo,q('#iImoFeedback')));
 const editImo=q('#iEditVesselImo');editImo.addEventListener('input',()=>checkImo(editImo,null));
 [q('#iAddVesselForm'),q('#iEditVesselForm')].forEach(form=>form.addEventListener('submit',e=>{
  const input=q('input[name="imoNumber"]',form);if(!checkImo(input,input===addImo?q('#iImoFeedback'):null)){
     e.preventDefault();input.reportValidity();}
 }));
 [q('#iPortCode'),q('#iEditPortCode')].forEach(input=>input.addEventListener('input',()=>input.value=input.value.toUpperCase()));

 // Searchable Seller fields use app-rendered names, not browser datalist overlays.
 const sellerData=all('#iSellerData [data-seller-id]').map(x=>({id:x.dataset.sellerId,name:x.dataset.sellerName}));
 function initSellerPicker(mode){
   const input=q(mode==='add'?'#iOwnerName':'#iEditVesselOwnerName'), hidden=q(mode==='add'?'#iOwner':'#iEditVesselOwner');
   const result=q(mode==='add'?'#iSellerSuggestAdd':'#iSellerSuggestEdit');
   const toggle=q('[data-i-seller-toggle="'+mode+'"]');
   let showAll=false;
   const close=()=>{result.hidden=true;showAll=false;input.setAttribute('aria-expanded','false');toggle.setAttribute('aria-expanded','false');};
   function render(){
     const term=input.value.trim().toLowerCase();result.replaceChildren();
     const exact=sellerData.find(x=>x.name.toLowerCase()===term);
     hidden.value=exact?exact.id:'';
     // Arrow shows ALL Seller companies; typing filters the same list.
     const matches=(showAll?sellerData:sellerData.filter(x=>x.name.toLowerCase().includes(term)));
     if(!showAll&&!term){close();return;}
     if(matches.length){const count=document.createElement('div');count.className='i-seller-count';count.textContent=matches.length+' Seller compan'+(matches.length===1?'y':'ies');result.appendChild(count);}
     matches.forEach(x=>{const b=document.createElement('button');b.type='button';b.className='i-seller-option';b.setAttribute('role','option');b.textContent=x.name;
       b.addEventListener('click',()=>{input.value=x.name;hidden.value=x.id;input.dispatchEvent(new Event('change',{bubbles:true}));input.focus();close();});result.appendChild(b);});
     if(!exact&&!showAll&&term){const p=document.createElement('div');p.className='i-small p-2';p.textContent=matches.length?'Or continue typing to create a new Seller.':'No existing Seller matches. Enter the new company name and continue to save.';result.appendChild(p);}
     if(!matches.length&&showAll){const empty=document.createElement('div');empty.className='i-small p-2';empty.textContent='No Seller companies registered.';result.appendChild(empty);}
     result.hidden=false;input.setAttribute('aria-expanded','true');toggle.setAttribute('aria-expanded','true');
   }
   input.addEventListener('input',()=>{showAll=false;render();});
   input.addEventListener('focus',()=>{if(input.value.trim())render();});
   toggle.addEventListener('click',()=>{if(!result.hidden && showAll){close();return;}showAll=true;render();input.focus();});
   input.addEventListener('keydown',e=>{if(e.key==='Escape')close();else if(e.key==='ArrowDown'&&result.hidden){e.preventDefault();showAll=true;render();const first=result.querySelector('button');if(first)first.focus();}});
   result.addEventListener('keydown',e=>{if(e.key==='Escape'){close();input.focus();}});
   document.addEventListener('click',e=>{if(!input.parentElement.contains(e.target))close();});
   return ()=>{const exact=sellerData.find(x=>x.name.toLowerCase()===input.value.trim().toLowerCase());if(exact)hidden.value=exact.id;return !!exact;};
 }
 const resolveAddSeller=initSellerPicker('add'),resolveEditSeller=initSellerPicker('edit');
 const sellerModal=q('#iNewCompanyModal');
 q('#iAddVesselForm').addEventListener('submit',e=>{
    if(!checkImo(addImo,q('#iImoFeedback')))return;
    resolveAddSeller();const typed=q('#iOwnerName').value.trim();if(!typed||q('#iOwner').value)return;
    e.preventDefault();setValue('iNewSellerName',typed);setValue('iNewSellerVesselName',q('#iVesselName').value);
    setValue('iNewSellerImo',q('#iVesselImo').value);setValue('iNewSellerCapacity',q('#iCapacity').value);
    if(window.bootstrap)bootstrap.Modal.getOrCreateInstance(sellerModal).show();
 });
 q('#iEditVesselForm').addEventListener('submit',e=>{
    if(!resolveEditSeller()&&q('#iEditVesselOwnerName').value.trim()){
       e.preventDefault();q('#iEditVesselOwnerName').setCustomValidity('Choose an existing Seller for an edit. To create a new Seller and vessel, use Add a vessel.');
       q('#iEditVesselOwnerName').reportValidity();
    }
 });
 q('#iEditVesselOwnerName').addEventListener('input',()=>q('#iEditVesselOwnerName').setCustomValidity(''));
 // Searchable, deduplicated country options inside a styled application modal.
 let currentCountryInput=null;const countryModal=q('#iCountryModal'),countryQuery=q('#iCountryQuery');
 all('[data-i-country]').forEach(b=>b.addEventListener('click',()=>{
    currentCountryInput=q('#'+b.dataset.iCountry);countryQuery.value='';filterCountries();
    if(window.bootstrap)bootstrap.Modal.getOrCreateInstance(countryModal).show();
 }));
 function filterCountries(){const term=countryQuery.value.trim().toLowerCase();let count=0;
   all('[data-country-choice]',countryModal).forEach(b=>{b.hidden=!b.dataset.countryChoice.toLowerCase().includes(term);if(!b.hidden)count++;});
   q('#iCountryNoResults').hidden=count!==0;
 }
 countryQuery.addEventListener('input',filterCountries);
 countryModal.addEventListener('shown.bs.modal',()=>countryQuery.focus());
 all('[data-country-choice]',countryModal).forEach(b=>b.addEventListener('click',()=>{
   if(currentCountryInput){currentCountryInput.value=b.dataset.countryChoice;currentCountryInput.dispatchEvent(new Event('change',{bubbles:true}));}
   if(window.bootstrap)bootstrap.Modal.getOrCreateInstance(countryModal).hide();
 }));
 q('#iTogglePortActivity').addEventListener('click',()=>{const panel=q('#iPortActivityPanel');panel.hidden=!panel.hidden;
   q('#iTogglePortActivity').textContent=panel.hidden?'Show activity summary':'Hide activity summary';
   q('#iTogglePortActivity').setAttribute('aria-expanded',String(!panel.hidden));});
 all('[data-i-dismiss-toast]').forEach(btn=>btn.addEventListener('click',()=>{const toast=btn.closest('.i-toast-wrap');if(toast)toast.remove();}));
 setTimeout(()=>{const toast=q('.i-toast-wrap');if(toast)toast.remove();},4200);
 const liftModal=(selector)=>{const modal=q(selector);if(!modal)return;modal.addEventListener('show.bs.modal',()=>{const open=all('.modal.show').length;const z=1060+(open*20);modal.style.zIndex=String(z);setTimeout(()=>{const backdrops=all('.modal-backdrop');if(backdrops.length)backdrops[backdrops.length-1].style.zIndex=String(z-5);},20);});};
 ['#iCountryModal','#iNewCompanyModal','#iInfraEditModal'].forEach(liftModal);

 // Native form submissions: no fetch, no interception or synthetic response handling.
 // The Admin controller processes the POST and redirects to the appropriate tab.
 // The server's verified flash feedback is displayed above the directory.

})();
</script>
</body></html>
