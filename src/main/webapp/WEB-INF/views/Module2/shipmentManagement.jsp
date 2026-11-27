<jsp:useBean id="nlViewSupport_Module2_shipmentManagement" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module2_shipmentManagement" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module2_shipmentManagement" property="view" value="Module2/shipmentManagement.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,java.math.*,model.*" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Shipment management | N-LOGISTIC</title><style>
:root{--ink:#302019;--text:#4f3d32;--muted:#8a7668;--line:#ead6c4;--paper:#fffaf5;--cream:#fff4e9;--bg:#f9f2eb;--accent:#e4670f;--accentDeep:#b93d05;--gold:#f8b457;--shadow:0 12px 34px rgba(85,39,14,.07),0 2px 5px rgba(85,39,14,.035);--rad:20px;font-synthesis:none}
*,*::before,*::after{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;color:var(--ink);background:var(--bg);font:15px/1.52 'Segoe UI',Inter,Arial,sans-serif;-webkit-font-smoothing:antialiased}button,input,select,textarea{font:inherit}button,a{touch-action:manipulation}a{color:var(--accentDeep);text-decoration:none}a:hover{color:var(--accent)}button{cursor:pointer}button:disabled{cursor:not-allowed;opacity:.55}img,svg{max-width:100%}summary{cursor:pointer}p{margin:.3rem 0 1rem;color:var(--text)}h1,h2,h3,h4{line-height:1.14;margin:0 0 .6rem;letter-spacing:-.035em;font-weight:800}h1{font-size:clamp(1.85rem,2.5vw,2.9rem)}h2{font-size:1.35rem}h3{font-size:1.1rem}small,.small{font-size:.84rem}.muted{color:var(--muted)}.caps{text-transform:uppercase;font-size:.7rem;font-weight:800;letter-spacing:.17em;color:#b96735}.mono{font-family:ui-monospace,SFMono-Regular,Consolas,monospace;font-size:.85em;overflow-wrap:anywhere}.hidden{display:none!important}.wrap{overflow-wrap:anywhere}.visually-hidden{position:absolute!important;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}
body:before{content:"";position:fixed;inset:75px 0 auto 0;height:470px;pointer-events:none;opacity:.8;background:radial-gradient(ellipse 72% 48% at 98% 0,rgba(250,160,80,.16),transparent),linear-gradient(133deg,rgba(255,250,245,.5),transparent)}
.topbar{height:76px;position:sticky;top:0;z-index:40;display:flex;align-items:center;gap:24px;padding:0 clamp(18px,2.4vw,40px);background:linear-gradient(105deg,#352018 0%,#6e2e12 53%,#c64e06 100%);color:#fff;box-shadow:0 8px 23px #56250c22;isolation:isolate}
.topbar:after{content:"";position:absolute;inset:0;z-index:-1;pointer-events:none;background:radial-gradient(ellipse 38% 140% at 87% 115%,rgba(255,162,70,.38),transparent),repeating-radial-gradient(ellipse at 88% 110%,transparent 0 36px,rgba(255,201,136,.085) 37px 38px,transparent 39px 58px)}
.brand{display:flex;align-items:center;gap:11px;border:1px solid #ffbf67;border-radius:999px;color:#ffd38d;font-weight:900;letter-spacing:.08em;white-space:nowrap;padding:10px 17px;font-size:1rem;background:#321e182f}.brand:hover{color:#fff}.brand-mark{font-size:1.25rem;line-height:1}.menu-button,.icon-button{width:40px;height:40px;display:inline-grid;place-items:center;border:0;border-radius:12px;background:#ffffff10;color:#fff;flex-shrink:0}.menu-button:hover,.icon-button:hover{background:#ffffff30}.menu-button{display:none}.top-search{display:flex;flex:1;max-width:540px;margin:auto;align-items:center;gap:10px;padding:7px 12px 7px 15px;background:#ffffff14;border:1px solid #ffffff32;border-radius:999px}.top-search input{min-width:0;flex:1;border:0;background:transparent;color:#fff;outline:0;font-size:.9rem}.top-search input::placeholder{color:#f7dac6}.top-search button{background:#ffcf93;border:0;padding:7px 17px;border-radius:999px;font-size:.85rem;font-weight:800;color:#713415}.top-right{margin-left:auto;display:flex;align-items:center;gap:9px}.top-right details{position:relative}.avatar{display:grid;place-items:center;flex:0 0 auto;width:37px;height:37px;border:1px solid #fec278;border-radius:50%;background:#27100c24;color:#ffd8a5;font-weight:900}.account-summary{font-size:.7rem;line-height:1.15;color:#ffe6d0}.account-summary strong{display:block;color:#fff;font-size:.85rem;white-space:nowrap;max-width:155px;overflow:hidden;text-overflow:ellipsis}.menu-drop{position:absolute;right:0;top:calc(100% + 13px);background:#fffaf5;border:1px solid var(--line);border-radius:16px;box-shadow:0 16px 36px #3c210a25;padding:8px;min-width:218px;color:var(--ink)}.menu-drop a,.menu-drop button{display:flex;align-items:center;width:100%;text-align:left;gap:8px;padding:10px 12px;border:0;background:transparent;color:#473025;border-radius:10px;font-size:.9rem}.menu-drop a:hover,.menu-drop button:hover{background:#fff0df}.top-details summary{display:flex;align-items:center;gap:10px;list-style:none;cursor:pointer}.top-details summary::-webkit-details-marker{display:none}.top-details[open]>.menu-drop{animation:dropin .18s ease both}
.app-shell{display:grid;grid-template-columns:252px minmax(0,1fr);min-height:calc(100vh - 76px);position:relative}.sidebar{position:sticky;top:76px;height:calc(100vh - 76px);align-self:start;background:linear-gradient(180deg,#fff8ef 0%,#fff1e3 100%);border-right:1px solid #ecd7c2;padding:29px 15px 16px;display:flex;flex-direction:column;gap:14px;z-index:30}.sidebar-title{padding:0 14px 13px;border-bottom:1px solid #ecd5bb}.nav-list{display:grid;gap:7px}.nav-link{display:flex;align-items:center;gap:14px;border-radius:13px;padding:13px 14px;font-size:.94rem;font-weight:650;color:#624b3e;min-height:47px;transition:background .2s,color .2s,transform .2s}.nav-link svg{width:19px;height:19px;flex:none}.nav-link:hover{background:#ffe9d4;color:#923b0d;transform:translateX(3px)}.nav-link.active{color:#fff;background:linear-gradient(112deg,#ae3a08,#ee7317);box-shadow:0 7px 16px #a6461c2e}.nav-link.active:hover{color:#fff}.sidebar-bottom{margin-top:auto;padding:20px 7px 4px;border-top:1px solid var(--line)}.sidebar-bottom button{width:100%;background:#fffaf5;border:1px solid #e4c2aa;border-radius:12px;padding:12px;color:#633a26;text-align:left;font-weight:750}.sidebar-bottom button:hover{background:#fff1e7}
.main-area{min-width:0;padding:clamp(20px,2.6vw,43px) clamp(18px,3vw,52px) 60px;max-width:100%}.content-wrap{max-width:1450px;margin:0 auto}.bread{display:flex;align-items:center;gap:10px;font-size:.8rem;color:#9f6a48;margin-bottom:15px;font-weight:650}.bread b{color:#3b291d}.page-heading{display:flex;flex-wrap:wrap;justify-content:space-between;align-items:flex-start;gap:14px;margin-bottom:25px}.page-heading h1 span{color:var(--accent)}.page-heading p{margin-bottom:0}.heading-actions{display:flex;flex-wrap:wrap;gap:9px;align-items:center}.pill{display:inline-flex;gap:6px;align-items:center;min-height:27px;padding:3px 10px;border-radius:999px;background:#fff0de;border:1px solid #edcfaf;color:#9a470f;font-size:.72rem;font-weight:800;white-space:nowrap}.pill.good{background:#edf4db;border-color:#d4dfb1;color:#527322}.pill.blue{background:#e9f2fb;border-color:#c7deef;color:#305678}.pill.gray{background:#f1ede7;border-color:#e0d2c2;color:#77685d}.pill.bad{background:#ffe5dc;border-color:#f7c2b5;color:#b8421f}
.card{background:#fffdfb;border:1px solid #eedcca;border-radius:var(--rad);box-shadow:var(--shadow);padding:clamp(16px,2vw,27px);margin-bottom:18px;min-width:0;animation:rise .34s ease both}.card.soft{background:linear-gradient(125deg,#fffdfb,#fff3e7)}.card h2,.card h3{margin-bottom:8px}.card-head{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:14px;margin-bottom:18px}.card-head .sub{font-size:.88rem;color:#826f61;margin:0}.profile-stats{grid-template-columns:repeat(3,minmax(0,1fr))}.stats-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:15px;margin-bottom:18px}.stat{padding:18px 20px;background:#fffaf5;border:1px solid #efdccc;border-radius:18px;box-shadow:var(--shadow);min-width:0;transition:transform .2s,box-shadow .2s}.stat:hover{transform:translateY(-3px);box-shadow:0 15px 28px #7d42121a}.stat .stat-label{font-size:.82rem;color:#775d4b;font-weight:650;margin:4px 0}.stat .stat-value{font-size:clamp(1.45rem,2vw,2rem);font-weight:900;letter-spacing:-.045em;overflow-wrap:anywhere}.stat .stat-sub{font-size:.77rem;color:#a17a5d}.stat .stat-icon{width:35px;height:35px;display:grid;place-items:center;border-radius:11px;background:#ffead6;color:#a6400b;margin-bottom:12px;font-size:1rem;font-weight:900}
.btn{display:inline-flex;justify-content:center;align-items:center;gap:8px;border:1px solid transparent;background:#f4e2d1;color:#58311c;border-radius:11px;min-height:41px;max-width:100%;padding:9px 15px;font-size:.88rem;font-weight:780;line-height:1.3;vertical-align:middle;transition:transform .17s,background .17s,box-shadow .17s;text-align:center}.btn:hover{transform:translateY(-1px);box-shadow:0 5px 12px #5c2f131e}.btn.primary{color:#fff;background:linear-gradient(110deg,#bc4209,#ed7014);box-shadow:0 5px 13px #bc43062b}.btn.primary:hover{background:linear-gradient(110deg,#a33708,#d45d0e);color:#fff}.btn.light{background:#fffaf6;border-color:#e9d0bc;color:#803c15}.btn.light:hover{background:#fff0e2}.btn.dark{background:#39241c;color:#fff}.btn.small{font-size:.77rem;min-height:31px;padding:6px 10px;border-radius:9px}.btn.ghost{background:transparent;color:#8f451c;border-color:transparent}.btn.ghost:hover{background:#fff0de}
.form-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;align-items:end}.form-grid.two{grid-template-columns:repeat(2,minmax(0,1fr))}.form-grid.three{grid-template-columns:repeat(3,minmax(0,1fr))}.field{display:grid;gap:7px;min-width:0}.field>label,.field>span{font-size:.82rem;font-weight:750;color:#674a37}.input,.select,.textarea{appearance:auto;display:block;width:100%;max-width:100%;min-height:43px;padding:10px 13px;background:#fffdfb;border:1px solid #e6cdb9;border-radius:11px;color:var(--ink);box-shadow:inset 0 1px 1px #45291308;outline:none;transition:box-shadow .18s,border-color .18s}.input:focus,.select:focus,.textarea:focus{border-color:#ec862b;box-shadow:0 0 0 3px #faac5744}.textarea{min-height:95px;resize:vertical}.input::placeholder,.textarea::placeholder{color:#aa9380}.form-actions{display:flex;align-items:center;gap:9px;flex-wrap:wrap}.form-note{font-size:.78rem;color:#8c7668}.hint{padding:12px 16px;border:1px solid #f4d6b6;border-radius:13px;background:#fff5e9;color:#89532f;font-size:.85rem;overflow-wrap:anywhere}.alert{padding:14px 17px;border-radius:13px;margin-bottom:16px;background:#eff8eb;color:#446936;border:1px solid #cfe3c8}.alert.error{background:#fff0ed;border-color:#f0cdc4;color:#963c23}.alert.info{background:#edf6fd;border-color:#cfdfec;color:#2d607e}.empty{padding:36px 15px;text-align:center;color:#9a7963}.empty strong{display:block;font-size:1rem;color:#543b2a;margin-bottom:6px}
.table-wrap{width:100%;overflow-x:auto;border:1px solid #f0dfd1;border-radius:14px;-webkit-overflow-scrolling:touch;scrollbar-color:#dec0a4 transparent}.data-table{border-collapse:collapse;width:100%;font-size:.84rem;min-width:740px}.data-table th{font-size:.7rem;text-transform:uppercase;letter-spacing:.04em;text-align:left;white-space:nowrap;background:#faeadd;color:#723c1e;padding:13px 15px;font-weight:900}.data-table td{padding:13px 15px;border-top:1px solid #f0e2d5;color:#514035;vertical-align:middle}.data-table tr:nth-child(even) td{background:#fff8f1}.data-table tr:hover td{background:#fff0e1}.data-table .numeric{text-align:right;white-space:nowrap;font-variant-numeric:tabular-nums}.data-table td:first-child{font-weight:700}.data-table .actions{display:flex;align-items:center;gap:6px;flex-wrap:nowrap}.data-table td span.inline-muted{display:block;font-size:.77rem;color:#927565;font-weight:400}.table-toolbar{display:flex;flex-wrap:wrap;justify-content:space-between;align-items:center;gap:12px;margin-bottom:14px}.table-toolbar .input{width:min(300px,100%)}.table-status{font-size:.8rem;color:#94725f}.table-buttons{display:flex;flex-wrap:wrap;gap:7px}.kpi-strip{display:flex;flex-wrap:wrap;gap:14px}.kpi-strip>span{display:flex;align-items:center;gap:6px;font-size:.8rem;color:#866e5e}
.progress-track{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));margin:26px 0;gap:4px}.progress-step{text-align:center;min-width:0;position:relative;padding:0 4px}.progress-step:before{content:"";height:3px;background:#ead8c9;position:absolute;left:-50%;right:50%;top:17px;z-index:0}.progress-step:first-child:before{display:none}.progress-step.done:before,.progress-step.current:before{background:#e76d11}.step-dot{position:relative;z-index:1;display:grid;place-items:center;width:36px;height:36px;border:2px solid #dcc3ae;border-radius:50%;margin:0 auto 9px;background:#fff;color:#947666;font-weight:800}.progress-step.done .step-dot,.progress-step.current .step-dot{color:#fff;background:linear-gradient(135deg,#ae4208,#eb7516);border-color:#db6f1d}.progress-step.current .step-dot{box-shadow:0 0 0 5px #ffd8b3}.progress-step .step-name{display:block;font-size:.71rem;overflow-wrap:anywhere;font-weight:750;color:#705546}.timeline{display:grid;gap:13px}.timeline-item{padding:15px 18px 15px 40px;position:relative;border:1px solid #f0dac8;background:#fff9f3;border-radius:13px}.timeline-item:before{content:"";position:absolute;left:17px;top:22px;width:11px;height:11px;border-radius:50%;background:#e66c15;box-shadow:0 0 0 4px #ffe5cb}.timeline-item h3{margin-bottom:5px}.timeline-item p{margin:0;font-size:.87rem}
.detail-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:11px}.detail-box{padding:13px 14px;border-radius:12px;background:#fff6ed;border:1px solid #f2e0ce;min-width:0}.detail-box small{display:block;color:#8b7262;font-weight:700;margin-bottom:5px}.detail-box strong{font-size:.94rem;overflow-wrap:anywhere}.expander{border:1px solid #ebd6c5;border-radius:14px;background:#fff8f1;padding:13px 17px;margin-top:15px}.expander summary{font-weight:850;color:#884416}.expander>div{padding-top:15px}.chart-frame{height:320px;min-height:250px;position:relative}.chart-frame canvas{display:block;width:100%!important;height:100%!important}.tab-actions{display:flex;gap:8px;flex-wrap:wrap}.tab-actions a{color:#84451d}.switcher{display:flex;align-items:center;flex-wrap:wrap;gap:9px}.switcher label{cursor:pointer}.switcher input{accent-color:#d75d0c}.section-divider{border:0;border-top:1px solid #efdfd0;margin:20px 0}.foot{padding-top:25px;margin-top:25px;border-top:1px solid #ead7c5;font-size:.8rem;color:#aa846c;display:flex;justify-content:space-between;flex-wrap:wrap;gap:7px}.toast{position:fixed;right:19px;bottom:19px;z-index:90;max-width:380px;background:#40241b;color:#fff;padding:13px 17px;border-radius:12px;box-shadow:0 15px 45px #3d21094a;animation:rise .2s ease both}
.auth-body{background:radial-gradient(ellipse 45% 55% at 10% 12%,#ffdfc3,transparent),radial-gradient(ellipse 35% 65% at 95% 90%,#ffe7d0,transparent),#fff7ed;min-height:100vh;padding:32px;display:grid;place-items:center}.auth-frame{width:min(1040px,100%);min-height:650px;display:grid;grid-template-columns:.9fr 1.1fr;overflow:hidden;border-radius:25px;border:1px solid #f1d4ba;background:#fffdfa;box-shadow:0 30px 75px #58361d23}.auth-left{background:linear-gradient(150deg,#382219,#6b3018 52%,#d65a09);padding:50px 46px;color:#fff;display:flex;flex-direction:column;justify-content:space-between;position:relative;overflow:hidden}.auth-left:after{position:absolute;content:"";width:410px;height:410px;border:1px solid #ffc47e3d;border-radius:50%;bottom:-200px;right:-140px;box-shadow:0 0 0 42px #ffc47e15,0 0 0 88px #ffc47e0d}.auth-left .brand{align-self:flex-start}.auth-left h1{color:#fff;font-size:clamp(2.9rem,4vw,4.9rem);line-height:1.12;margin-bottom:22px}.auth-left h1 span{color:#ffb66a}.auth-left p{color:#fbe5d4;max-width:330px}.auth-list{display:grid;gap:16px;font-size:.92rem;font-weight:650;color:#fff9ed}.auth-list div{display:flex;gap:11px;align-items:center}.auth-right{display:flex;flex-direction:column;justify-content:center;padding:clamp(30px,5vw,83px)}.auth-right h2{font-size:2.6rem}.auth-right .field{margin-top:19px}.auth-right .btn{min-height:50px;margin-top:23px;width:100%}.password-wrap{display:flex;gap:7px}.password-wrap input{flex:1;min-width:0}.auth-back{margin-top:30px;color:#a07961;font-size:.8rem}.auth-back a{color:#a9480d}
@keyframes rise{from{opacity:0;transform:translateY(9px)}to{opacity:1;transform:translateY(0)}}@keyframes dropin{from{opacity:0;transform:translateY(-5px)}to{opacity:1;transform:translateY(0)}}
@media(max-width:1200px){.stats-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.form-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.detail-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.main-area{padding:26px}.topbar{gap:12px}.account-summary{display:none}}
@media(max-width:930px){.app-shell{grid-template-columns:minmax(0,1fr)}.sidebar{position:fixed;top:76px;left:0;bottom:0;height:calc(100vh - 76px);width:255px;transform:translateX(-105%);transition:transform .2s ease;box-shadow:15px 15px 40px #33170823}.menu-button{display:inline-grid}body.menu-open .sidebar{transform:translateX(0)}body.menu-open:after{content:"";position:fixed;inset:76px 0 0;background:#28150d7a;z-index:25}.top-search{max-width:390px}.main-area{padding:24px 18px}.auth-frame{grid-template-columns:.75fr 1.25fr}.auth-left{padding:34px 25px}}
@media(max-width:650px){.profile-stats{grid-template-columns:minmax(0,1fr)}.topbar{height:65px;padding:0 12px;gap:7px}.topbar .brand{font-size:.77rem;padding:8px 10px}.topbar .brand-mark{font-size:1rem}.top-search{display:none}.sidebar{top:65px;height:calc(100vh - 65px)}body.menu-open:after{top:65px}.main-area{padding:19px 12px 40px}.page-heading{margin-bottom:19px}.stats-grid{grid-template-columns:repeat(2,minmax(0,1fr));gap:9px}.stat{padding:13px}.stat .stat-value{font-size:1.47rem}.form-grid,.form-grid.two,.form-grid.three{grid-template-columns:minmax(0,1fr)}.detail-grid{grid-template-columns:minmax(0,1fr)}.card{padding:15px}.progress-track{display:flex;overflow-x:auto;padding:10px 5px;gap:2px}.progress-step{min-width:87px;flex-shrink:0}.chart-frame{height:255px}.account-summary{display:none}.auth-body{padding:15px}.auth-frame{grid-template-columns:1fr;min-height:unset}.auth-left{padding:25px}.auth-left h1{font-size:2rem}.auth-left p,.auth-list{display:none}.auth-right{padding:30px 24px 38px}.auth-right h2{font-size:2rem}.table-toolbar .input{width:100%}.table-status{width:100%}.page-heading h1{font-size:1.9rem}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important;scroll-behavior:auto!important}}

/* Staff actions remain legible when three controls are shown. */
.data-table td .actions{display:flex;flex-wrap:wrap;gap:6px;min-width:165px}
.data-table td .actions .btn{white-space:nowrap}

/* Page motion: embedded in this JSP; no external CSS dependency. */
@keyframes nlPageEnter{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
@keyframes nlGentleIn{from{opacity:0;transform:translateY(5px)}to{opacity:1;transform:translateY(0)}}
@keyframes nlSlideFromTop{from{opacity:0;transform:translateY(-7px)}to{opacity:1;transform:translateY(0)}}
.bread,.caps{animation:nlGentleIn .36s ease both}
.page-heading{animation:nlPageEnter .44s cubic-bezier(.2,.8,.2,1) both}
.stats-grid>.stat{animation:nlPageEnter .45s cubic-bezier(.2,.8,.2,1) both}
.stats-grid>.stat:nth-child(2){animation-delay:.065s}
.stats-grid>.stat:nth-child(3){animation-delay:.13s}
.stats-grid>.stat:nth-child(4){animation-delay:.195s}
.card{animation:nlPageEnter .44s cubic-bezier(.2,.8,.2,1) both}
.nav-link,.btn,.top-details summary,.select,.input,.textarea,.expander summary{transition:background-color .18s ease,color .18s ease,border-color .18s ease,box-shadow .2s ease,transform .18s ease}
.btn:hover:not(:disabled){transform:translateY(-2px)}
.btn:active:not(:disabled){transform:translateY(0)}
.nav-link:hover{transform:translateX(3px)}
.top-details[open] .menu-drop{animation:nlSlideFromTop .2s ease both}
.expander[open]>summary{color:var(--accentDeep)}
.expander[open]>div{animation:nlGentleIn .27s ease both}
.timeline-item{animation:nlGentleIn .38s ease both}
.table-wrap tbody tr{transition:background-color .2s ease}
.field :is(.input,.select,.textarea):focus-visible{outline:2px solid var(--accent);outline-offset:2px;box-shadow:0 0 0 5px rgba(228,103,15,.11)}
.detail-heading{margin-bottom:16px}
@media(prefers-reduced-motion:reduce){.bread,.caps,.page-heading,.stats-grid>.stat,.card,.top-details[open] .menu-drop,.expander[open]>div,.timeline-item{animation:none!important}.nav-link,.btn,.top-details summary,.select,.input,.textarea,.expander summary,.table-wrap tbody tr{transition:none!important}.btn:hover:not(:disabled),.nav-link:hover{transform:none!important}}

/* v16.7 compact shipment hero */
.page-hero{position:relative;display:grid;grid-template-columns:minmax(0,1.45fr) minmax(230px,.7fr);gap:18px;align-items:center;padding:22px 24px;border:1px solid #ecd3bf;border-radius:24px;background:linear-gradient(126deg,#fffdfa,#fff1e1 72%,#ffe5cb);box-shadow:0 16px 34px rgba(87,53,23,.07);overflow:hidden}
.page-hero:after{content:"";position:absolute;right:-82px;top:-86px;width:245px;height:245px;border-radius:50%;border:1px solid rgba(212,91,23,.13);box-shadow:0 0 0 26px rgba(212,91,23,.05),0 0 0 56px rgba(212,91,23,.025)}
.page-hero .hero-copy,.page-hero .hero-actions,.page-hero .hero-art{position:relative;z-index:1}
.page-hero .hero-copy p{max-width:700px;color:#7a6456;margin:0}
.page-hero .hero-copy h1{margin:.3rem 0 .55rem}
.page-hero .hero-actions{display:flex;flex-wrap:wrap;gap:9px;align-items:center;justify-content:flex-end}
.page-hero .hero-art{display:flex;justify-content:flex-end;align-items:center;min-height:140px}
.page-hero .ship-scene{position:relative;width:300px;height:160px;transform:scale(.96);transform-origin:100% 50%;filter:drop-shadow(0 14px 18px rgba(133,72,36,.13))}
.page-hero .ship-halo{position:absolute;inset:6px 18px 0 54px;border-radius:50%;border:1px solid rgba(205,100,41,.16);background:radial-gradient(circle at 55% 44%,rgba(255,255,255,.85),rgba(255,216,181,.16) 74%,transparent 75%)}
.page-hero .ship-line{position:absolute;left:50px;right:6px;bottom:42px;height:8px;border-radius:20px;background:repeating-linear-gradient(90deg,#f0bf96 0 12px,transparent 12px 22px)}
.page-hero .ship-wave{position:absolute;left:40px;right:10px;bottom:36px;height:12px;background:radial-gradient(circle at 8px 8px,#f7d8bb 0 7px,transparent 8px) 0 0/30px 12px repeat-x;opacity:.75}
.page-hero .ship-boat{position:absolute;right:78px;bottom:42px;width:86px;height:48px;animation:shipSail 5.8s ease-in-out infinite}
.page-hero .ship-boat:before{content:"";position:absolute;left:0;right:0;bottom:0;height:20px;background:linear-gradient(180deg,#ffb67b,#d8661b);border:2px solid #9d522a;border-radius:0 0 18px 18px;clip-path:polygon(0 40%,100% 0,88% 100%,12% 100%)}
.page-hero .ship-boat:after{content:"";position:absolute;left:31px;bottom:18px;width:8px;height:26px;background:#9d522a;box-shadow:16px -2px 0 #9d522a}
.page-hero .ship-sail{position:absolute;left:38px;bottom:28px;width:40px;height:28px;background:linear-gradient(145deg,#fffef8,#fff0df);border:2px solid #9d522a;clip-path:polygon(0 100%,100% 100%,0 0);border-radius:4px 0 0 0}
.page-hero .ship-sail.small{left:55px;bottom:26px;width:28px;height:22px}
.page-hero .ship-boxes{position:absolute;right:6px;bottom:52px;display:flex;gap:5px;animation:shipBoxes 5.2s ease-in-out infinite}
.page-hero .ship-boxes i{display:block;width:16px;height:22px;border:2px solid #9b502b;border-radius:4px;background:repeating-linear-gradient(90deg,#f9ad70 0 6px,#ed9555 6px 12px)}
.page-hero .ship-spark{position:absolute;width:10px;height:10px;border-radius:3px;transform:rotate(45deg);background:#e18d4d;animation:shipSpark 4s ease-in-out infinite}
.page-hero .ship-spark.one{left:76px;top:26px}.page-hero .ship-spark.two{right:26px;top:42px;animation-delay:1.2s}
@keyframes shipSail{0%,100%{transform:translateX(0)}50%{transform:translateX(-8px) translateY(-2px)}}
@keyframes shipBoxes{0%,100%{transform:translateY(0)}50%{transform:translateY(-4px)}}
@keyframes shipSpark{0%,100%{opacity:1;transform:rotate(45deg) scale(1)}50%{opacity:.35;transform:rotate(45deg) scale(.75)}}
@media(max-width:760px){.page-hero{grid-template-columns:1fr;padding:20px}.page-hero .hero-art{display:none}.page-hero .hero-actions{justify-content:flex-start}}
@media(prefers-reduced-motion:reduce){.page-hero *{animation:none!important}}


/* Shipment records — responsive cards, not a squeezed seven-column table. */
.shipment-records{background:#fffdfa}
.shipment-toolbar{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;padding:11px 13px;background:#fff6ed;border:1px solid #f0dfcf;border-radius:15px;margin:4px 0 18px}
.status-tabs{display:flex;flex-wrap:wrap;gap:6px}
.status-tab{border:1px solid transparent;background:transparent;border-radius:999px;color:#7c5b47;font-size:.83rem;padding:9px 12px;font-weight:750;cursor:pointer;transition:background .2s,transform .2s,color .2s}
.status-tab:hover{background:#fce9d8;transform:translateY(-1px)}
.status-tab.is-active{background:linear-gradient(110deg,#b43e0a,#eb6b10);color:white;box-shadow:0 5px 12px #ce550c26}
.records-tools{display:flex;align-items:center;flex-wrap:wrap;gap:13px}.sort-label{display:flex;align-items:center;gap:8px;font-size:.83rem;font-weight:750;color:#785b47}.sort-label .select{min-height:37px;width:auto;max-width:165px;background:#fff}.shipment-collection{display:grid;gap:11px}
.shipment-row{min-width:0;display:grid;grid-template-columns:minmax(205px,1.5fr) minmax(180px,1.25fr) minmax(150px,.92fr) minmax(145px,.92fr);align-items:center;gap:18px;padding:19px 20px;border:1px solid #ecd7c5;border-radius:16px;background:#fff;box-shadow:0 2px 6px #5f2f0d0a;transition:border-color .22s ease,box-shadow .22s ease,transform .22s ease;animation:nlGentleIn .35s ease both}
.shipment-row:nth-child(even){background:#fffbf7}.shipment-row:hover{border-color:#e5b38b;box-shadow:0 10px 22px #a55a2320;transform:translateY(-2px)}.shipment-reference,.shipment-route,.shipment-summary,.shipment-actions{min-width:0}
.row-kicker{font-size:.65rem;letter-spacing:.12em;color:#9b715b;font-weight:900;margin-bottom:7px}.record-dot{display:inline-block;width:7px;height:7px;border-radius:50%;background:#ed8d3b;margin-right:3px}
.reference-line{display:flex;align-items:center;gap:7px;min-width:0;flex-wrap:wrap}.reference-line .mono{font-size:.82rem;line-height:1.4;color:#39251a;overflow-wrap:anywhere;word-break:break-word}
.mini-copy{display:inline-flex;align-items:center;justify-content:center;gap:4px;border-radius:7px;border:1px solid #eed5c3;padding:4px 7px;font-size:.69rem;font-weight:850;color:#a34b19;background:#fff8f1;line-height:1.3;white-space:nowrap;cursor:pointer;transition:background .15s ease}
.mini-copy:hover{background:#ffe9d7}.mini-copy:focus-visible{outline:2px solid #ed7a25;outline-offset:2px}.mini-copy.icon-only{padding:3px 6px;line-height:1}.container-sub{display:flex;align-items:center;gap:6px;flex-wrap:wrap;color:#856b5d;font-size:.76rem;margin-top:8px}.container-sub .mono{color:#654a3b}
.route-pair{display:flex;flex-direction:column;gap:5px;font-size:.85rem;font-weight:750;color:#433024;line-height:1.4}.route-pair>span:first-child,.route-pair>span:last-child{overflow-wrap:anywhere}.route-arrow{color:#dc650d;font-size:1.12rem;line-height:1;margin-left:2px}
.shipment-summary .pill{margin:0 3px 7px 0}.row-facts{display:flex;flex-wrap:wrap;column-gap:15px;row-gap:4px}.row-facts span{display:flex;flex-direction:column;font-size:.64rem;font-weight:800;letter-spacing:.07em;color:#a08068}.row-facts b{font-size:.82rem;letter-spacing:0;color:#412a1b;font-weight:850;font-variant-numeric:tabular-nums;white-space:nowrap}
.shipment-actions{display:flex;align-items:center;justify-content:flex-end;flex-wrap:wrap;gap:7px}.shipment-actions .btn{min-height:35px;white-space:nowrap}.shipment-actions .status-action{font-size:.72rem}
.records-pagination{border-top:1px solid #f0e1d4;margin-top:19px;padding-top:17px;display:flex;justify-content:space-between;align-items:center;gap:14px;flex-wrap:wrap}
@media(max-width:1350px){.shipment-row{grid-template-columns:minmax(160px,1.4fr) minmax(150px,1fr) minmax(130px,1fr);gap:14px}.shipment-actions{grid-column:1/-1;justify-content:flex-end;border-top:1px dashed #f0dfd1;padding-top:10px}}
@media(max-width:760px){.shipment-toolbar{padding:10px}.shipment-row{grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:16px;padding:16px}.shipment-summary{grid-column:1}.shipment-actions{grid-column:1/-1}.route-pair{font-size:.8rem}}
@media(max-width:520px){.shipment-row{grid-template-columns:minmax(0,1fr);gap:13px}.shipment-route{padding-top:9px;border-top:1px solid #f0e1d5}.shipment-summary{grid-column:auto}.shipment-actions{justify-content:flex-start}.shipment-actions .btn{flex:1 1 auto;white-space:normal}.sort-label{width:100%;justify-content:space-between}.sort-label .select{max-width:none;flex:1}.records-tools{width:100%}.status-tab{padding:8px 10px}}
@media(prefers-reduced-motion:reduce){.shipment-row,.status-tab{animation:none!important;transition:none!important}.shipment-row:hover,.status-tab:hover{transform:none!important}}

/* Presentation finish: consistent alignment, keyboard visibility and gentle motion. */
:where(a,button,input,select,textarea,summary):focus-visible{outline:2px solid #e2640b;outline-offset:3px}
.card,.stat,.detail-box,.field,.form-actions,.table-wrap{min-width:0}
.page-heading h1{overflow-wrap:break-word}.card-head>div{min-width:0}
.top-details summary:focus-visible{outline:2px solid #ffbc80;outline-offset:4px}
.form-actions{display:flex;flex-wrap:wrap;align-items:center;gap:9px}
input,select,textarea{max-width:100%}
.data-table :is(td,th){line-height:1.45}
@media(prefers-reduced-motion:reduce){html{scroll-behavior:auto!important}}
[hidden="hidden"], [hidden]{display:none!important}

/* Role-appropriate shipment overview, same compact grid for every account. */
.role-summary-head{display:flex;justify-content:space-between;align-items:center;gap:15px;flex-wrap:wrap;margin-bottom:12px}.role-summary-head>p{margin:0;max-width:420px;text-align:right}.role-summary-label{display:flex;gap:10px;align-items:center;flex-wrap:wrap}.role-summary-label>strong{font-size:.94rem}.role-indicator{font-size:.67rem;letter-spacing:.1em;font-weight:900;border:1px solid #f1cba5;color:#a34a14;background:#fff3e4;border-radius:999px;padding:6px 10px}.role-stats .stat{background:linear-gradient(140deg,#fffcf9,#fff5eb)}.role-stats .stat-value{font-variant-numeric:tabular-nums}
@media(max-width:700px){.role-summary-head>p{text-align:left}.role-stats .stat{padding:14px}.role-stats .stat-label{min-height:2.6em}}


/* Consistent accessible navigation and low-distraction interactions. */
.nl-backtop{position:fixed;right:22px;bottom:20px;z-index:60;display:grid;place-items:center;width:42px;height:42px;color:#fff;background:linear-gradient(145deg,#bc4008,#ef7318);border:1px solid #d56822;border-radius:14px;box-shadow:0 10px 24px #8c3c172c;cursor:pointer;opacity:0;pointer-events:none;transform:translateY(10px);transition:opacity .2s,transform .2s}.nl-backtop.is-visible{opacity:1;pointer-events:auto;transform:translateY(0)}.nl-backtop:hover{transform:translateY(-3px)}
.nl-skip-link{position:fixed;top:-100px;left:15px;z-index:1000;background:white;color:#773312;border:2px solid #cd5a11;border-radius:10px;padding:11px 15px}.nl-skip-link:focus{top:10px}
:where(a,button,input,textarea,select,summary):focus-visible{outline:2px solid #e2640b;outline-offset:3px}
@media(prefers-reduced-motion:reduce){.nl-backtop{transition:none!important}}


/* Honor HTML hidden, including forms and conditional controls styled as buttons. */
[hidden]{display:none!important}

/* FINAL PRESENTATION POLISH: shared header appearance, individually embedded in each JSP. */
.topbar{overflow:visible}
.top-right{flex-shrink:0;min-width:0}
.top-details.account-menu{isolation:isolate;z-index:1}
.top-details.account-menu[open]{z-index:95}
.account-trigger{display:flex;align-items:center;gap:11px;min-height:52px;padding:6px 9px 6px 7px;border:1px solid transparent;border-radius:15px;max-width:min(320px,32vw);transition:background-color .18s ease,border-color .18s ease,box-shadow .18s ease;outline-offset:3px}
.account-trigger:hover,.account-menu[open] .account-trigger{background:#ffffff19;border-color:#ffdeac52}
.account-trigger .account-avatar{width:42px;height:42px;border:1.5px solid #ffd19a;background:linear-gradient(145deg,#d36516,#73300f);color:#fff0d4;font-size:.91rem;box-shadow:0 2px 10px #301a1940}
.account-menu[data-role="ADMIN"] .account-avatar{background:linear-gradient(145deg,#99502d,#3c221d)}
.account-menu[data-role="CONSUMER"] .account-avatar{background:linear-gradient(145deg,#c27128,#7d3b21)}
.account-trigger .account-summary{min-width:0;display:flex;flex-direction:column;gap:3px;font-size:.79rem;line-height:1.1}
.account-trigger .account-summary strong{display:block;max-width:225px;color:#fff;font-size:.88rem;font-weight:800;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}
.account-role{width:max-content;display:inline-flex;align-items:center;font-size:.62rem;font-weight:900;letter-spacing:.09em;text-transform:uppercase;color:#ffdcaf;white-space:nowrap}
.account-role:before{content:"";width:5px;height:5px;margin-right:6px;background:#ffd399;border-radius:50%}
.account-caret{flex:none;color:#ffe5c7;font-size:1.12rem;transition:transform .22s ease}
.account-menu[open] .account-caret{transform:rotate(180deg)}
.account-menu .account-panel{z-index:150;width:min(310px,calc(100vw - 30px));min-width:225px;max-width:calc(100vw - 24px);padding:10px;border-radius:17px;box-shadow:0 18px 46px #2b130f36}
.account-panel-header{padding:11px 12px 13px;margin-bottom:5px;background:linear-gradient(125deg,#fff3e6,#fff9f4);border-radius:12px;border:1px solid #f1dfd0}
.account-panel-name{font-weight:850;color:#3b261d;font-size:.98rem;overflow-wrap:anywhere}
.account-panel-role{display:inline-block;margin:5px 0 1px;padding:3px 8px;background:#fee4ca;border-radius:7px;color:#9b3f13;font-size:.69rem;font-weight:800}
.account-panel-header p{margin:4px 0 0;color:#816454;font-size:.76rem;line-height:1.4}
.account-panel-separator{height:1px;margin:7px 4px;background:#ecd9c9}
.account-menu .menu-drop :is(a,button):focus-visible{outline:2px solid #d6671d;outline-offset:1px}
.card,.stat,.detail-box{transition:box-shadow .2s ease,border-color .2s ease,transform .2s ease}
.card:focus-within{border-color:#eac3a5}
.btn:active:not(:disabled),.mini-copy:active{transform:translateY(1px) scale(.99)}
@media(max-width:1020px){.account-trigger{max-width:200px}.account-trigger .account-summary{display:none}.account-trigger .account-summary strong{max-width:115px}}
@media(max-width:690px){.account-trigger{gap:6px;padding:3px 5px;min-height:40px}.account-trigger .account-avatar{height:35px;width:35px;font-size:.73rem}.account-trigger .account-summary{display:none}.account-caret{font-size:1rem}.account-menu .account-panel{right:-3px}}
@media(prefers-reduced-motion:reduce){.account-trigger,.account-caret,.card,.stat,.detail-box,.btn,.mini-copy{transition:none!important;animation:none!important}}


/* Shipment list final refinement: readable identity / vertical journey / action panel. */
.shipment-collection{gap:13px}
.shipment-row{position:relative;display:grid;grid-template-columns:minmax(220px,1.1fr) minmax(195px,1fr) minmax(285px,1.2fr);gap:20px;align-items:stretch;padding:20px 22px 19px 24px;border-radius:18px;background:linear-gradient(117deg,#fffdfb 0%,#fffaf5 100%);border:1px solid #e9d4c3;overflow:hidden;box-shadow:0 4px 14px #703f2110}
.shipment-row:before{position:absolute;content:"";left:0;top:0;bottom:0;width:4px;background:linear-gradient(#ffb276,#d55d14)}
.shipment-row[data-shipment-status="DELIVERED"]:before{background:#7d9e5a}
.shipment-row[data-shipment-status="CANCELLED"]:before{background:#ae9b8e}
.shipment-row:focus-within{border-color:#dc965f;box-shadow:0 0 0 3px #f7d8b9a8}
.shipment-row:hover{transform:translateY(-2px);box-shadow:0 11px 25px #703f211b}
.shipment-row:nth-child(even){background:linear-gradient(115deg,#fffaf5,#fff7ef)}
.shipment-reference{align-self:center;padding-right:3px}
.shipment-reference .row-kicker{letter-spacing:.12em}
.reference-line{gap:9px;margin-top:10px;align-items:center}
.reference-line .mono{font-weight:850;font-size:.89rem;letter-spacing:-.01em;line-height:1.5}
.container-sub{margin-top:11px;padding-top:9px;border-top:1px solid #f2e4d8;align-items:center}
.container-sub .mono{font-weight:750}
.shipment-route{padding:1px 8px 1px 21px;border-left:1px solid #eeddd0;align-self:stretch;display:flex;flex-direction:column;justify-content:center}
.shipment-route .row-kicker{margin-bottom:8px}
.route-pair{display:grid;grid-template-columns:minmax(0,1fr);gap:0;font-size:.89rem;line-height:1.35;font-weight:750}
.route-pair>span:first-child{color:#553425}
.route-pair>span:last-child{font-weight:850;color:#38241d}
.route-arrow{position:relative;display:flex;align-items:center;justify-content:flex-start;color:#de6612;font-size:1.05rem;font-weight:900;width:25px;height:29px;margin-left:4px;line-height:1}
.shipment-insight{display:flex;flex-direction:column;align-self:stretch;justify-content:space-between;min-width:0;gap:10px;padding-left:21px;border-left:1px solid #eeddd0}
.shipment-summary{min-width:0}.shipment-summary>.pill{margin:0 5px 6px 0}
.shipment-summary .row-facts{margin-top:6px;display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}
.shipment-summary .row-facts>span{display:block;padding:9px 10px;border-radius:10px;background:#fff2e6;border:1px solid #f3dfcc;color:#986f52;font-size:.66rem;line-height:1.28;text-transform:none;letter-spacing:0}
.shipment-summary .row-facts b{display:block;margin-top:4px;font-size:.86rem;white-space:normal;overflow-wrap:anywhere;color:#38231b}
.shipment-actions{display:flex;justify-content:flex-start;flex-wrap:wrap;gap:7px;margin-top:5px;padding-top:11px;border-top:1px dashed #ead7c7}
.shipment-actions .btn{min-height:34px}
.shipment-actions .status-action{background:#fff4e9;border:1px solid #f0ceae;color:#94400d}
.mini-copy{transition:background-color .2s,border-color .2s,color .2s,transform .15s}
.mini-copy.is-copied{border-color:#a3c1a2;background:#f0faeb;color:#466e37}
@media(max-width:1400px){.shipment-row{grid-template-columns:minmax(190px,1.05fr) minmax(165px,1fr) minmax(270px,1.2fr);gap:13px}.shipment-route,.shipment-insight{padding-left:15px}}
@media(max-width:1090px){.shipment-row{grid-template-columns:minmax(190px,1fr) minmax(155px,1fr)}.shipment-insight{grid-column:1/-1;display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);align-items:center;gap:13px;padding:12px 0 0;border:0;border-top:1px solid #f0dfd0}.shipment-actions{border:0;padding:0;margin:0;justify-content:flex-end}}
@media(max-width:710px){.shipment-row{grid-template-columns:minmax(0,1fr);padding:17px 17px 16px 20px;gap:13px}.shipment-route{padding:12px 0 2px;border:0;border-top:1px solid #f0dfd0}.shipment-insight{display:grid;grid-template-columns:minmax(0,1fr);gap:11px}.shipment-actions{justify-content:flex-start}.shipment-actions .btn{flex:1 1 auto}}
@media(max-width:420px){.shipment-summary .row-facts{gap:7px}.shipment-summary .row-facts>span{padding:8px}.shipment-actions .btn{font-size:.75rem;padding:8px}}
@media(prefers-reduced-motion:reduce){.shipment-row{animation:none!important;transition:none!important}.shipment-row:hover{transform:none!important}}


.nl-booking-cancel{position:relative;min-width:0}
.nl-booking-cancel>summary{list-style:none;cursor:pointer}
.nl-booking-cancel>summary::-webkit-details-marker{display:none}
.nl-cancel-inline{position:absolute;right:0;top:calc(100% + 6px);z-index:35;display:grid;gap:9px;width:min(330px,calc(100vw - 40px));padding:14px;background:#fffaf4;border:1px solid #e6bfa3;border-radius:14px;box-shadow:0 15px 35px #321b1322}
.nl-cancel-inline label{font-size:.76rem;font-weight:800}
.nl-cancel-inline .input{width:100%;min-height:40px}
@media(max-width:650px){.nl-cancel-inline{right:auto;left:0}}

/* v13 · clearer shipment details, preserving the existing three-column card. */
.shipment-collection{gap:15px}
.shipment-row{grid-template-columns:minmax(235px,1.08fr) minmax(210px,.95fr) minmax(320px,1.22fr);align-items:stretch;gap:0;padding:0;border-radius:19px;background:#fffdfa;box-shadow:0 5px 18px rgba(96,54,28,.065)}
.shipment-row:nth-child(even){background:#fff9f3}
.shipment-row:before{width:5px}
.shipment-row>.shipment-reference,.shipment-row>.shipment-route,.shipment-row>.shipment-insight{padding:22px 23px;min-width:0;margin:0;align-self:stretch}
.shipment-row>.shipment-route,.shipment-row>.shipment-insight{border-left:1px solid #ecd9c9}
.shipment-row .nl-label{display:block;color:#997460;font-size:.67rem;font-weight:800;letter-spacing:.055em;line-height:1.35;text-transform:uppercase}
.nl-card-heading{display:flex;align-items:center;gap:9px;margin-bottom:21px;color:#693c25;font-size:.82rem;font-weight:750}
.nl-card-heading strong{color:#ae4b16}
.nl-card-id-mark{display:inline-grid;place-items:center;border-radius:10px;width:33px;height:33px;background:#fff0e2;color:#c75b19;font-size:1.1rem}
.nl-reference-value{display:flex;gap:8px;align-items:center;flex-wrap:wrap;margin-top:5px;min-width:0}
.nl-reference-value .mono{font-size:1rem!important;font-weight:850!important;color:#302018!important;letter-spacing:0;line-height:1.5;overflow-wrap:anywhere}
.nl-reference-value .mini-copy,.nl-container-value .mini-copy{flex:0 0 auto}
.nl-container-info{margin-top:18px;padding:13px 14px;background:rgba(255,239,223,.78);border:1px solid #efdac6;border-radius:12px}
.nl-container-value{display:flex;align-items:center;gap:7px;flex-wrap:wrap;margin-top:4px;font-weight:800;color:#472f23}
.nl-container-value .mono{font-size:.83rem;color:#472f23}
.nl-help{margin:12px 0 0;color:#957868;font-size:.74rem;line-height:1.45}
.nl-section-title{color:#865f48;font-size:.71rem;font-weight:900;letter-spacing:.1em;text-transform:uppercase;margin-bottom:13px}
.shipment-row>.shipment-route{display:block}
.nl-route-stack{position:relative;margin-top:9px}
.nl-route-stop{display:grid;grid-template-columns:16px minmax(0,1fr);align-items:start;gap:11px}
.nl-route-stop>div{min-width:0}
.nl-route-dot{display:block;width:13px;height:13px;border:3px solid #e26f25;background:#fff9f3;border-radius:50%;margin-top:5px;box-shadow:0 0 0 3px #ffe8d4}
.nl-route-end .nl-route-dot{background:#c95716;border-color:#c95716;box-shadow:0 0 0 3px #ffe8d4}
.nl-route-stop strong{display:block;margin-top:5px;font-weight:850;color:#38251e;font-size:1.02rem;line-height:1.4;overflow-wrap:anywhere}
.nl-route-connector{margin:4px 0 5px 5px;padding:1px 0;height:30px;border-left:2px dashed #e7b38b;color:#d4671d;font-size:.83rem;line-height:26px}
.nl-route-connector span{margin-left:8px}
.shipment-row>.shipment-insight{display:flex;gap:11px;justify-content:space-between}
.nl-status-head{display:flex;align-items:flex-start;justify-content:space-between;gap:8px}
.nl-status-head .nl-section-title{margin-bottom:7px}
.nl-status-head .pill{font-size:.74rem;font-weight:850;letter-spacing:.02em;padding:6px 10px}
.nl-progress-count{display:inline-block;flex:0 0 auto;margin-top:2px;padding:4px 8px;border:1px solid #edd5c1;border-radius:8px;background:#fff8f1;color:#8d5940;font-weight:850;font-size:.73rem}
.nl-status-description{font-size:.79rem;color:#795746;line-height:1.4;margin:5px 0 10px}
.nl-progress-track{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));gap:4px;margin:11px 0 14px}
.nl-progress-track span{height:5px;min-width:0;border-radius:99px;background:#eadbd0}
.nl-progress-track span.is-complete{background:#ce611c}
.nl-progress-track span.is-current{background:#f0a455}
.shipment-row .row-facts{gap:9px;margin-top:0}
.shipment-row .row-facts>span{padding:12px 12px;min-width:0;border-radius:12px;background:#fff3e6;border:1px solid #eed8c5}
.shipment-row .row-facts small{font-size:.7rem;color:#875c43;font-weight:800;line-height:1.35}
.shipment-row .row-facts b{font-size:1.02rem;font-weight:850;color:#38231c;line-height:1.35;margin-top:5px;font-variant-numeric:tabular-nums}
.shipment-row .row-facts span:last-child{background:#fff8ef}
.shipment-row>.shipment-insight .shipment-actions{margin-top:5px;gap:8px;padding-top:14px}
.shipment-row .shipment-actions .btn{min-height:40px;padding:9px 13px;font-size:.8rem;font-weight:850;border-radius:10px}
.shipment-row .shipment-actions .btn.primary{box-shadow:0 5px 12px rgba(186,70,12,.14)}
.shipment-row .nl-booking-cancel{z-index:2}
@media(max-width:1330px){.shipment-row{grid-template-columns:minmax(210px,1.05fr) minmax(175px,.9fr) minmax(290px,1.25fr)}.shipment-row>.shipment-reference,.shipment-row>.shipment-route,.shipment-row>.shipment-insight{padding:19px 17px}.nl-reference-value .mono{font-size:.89rem!important}}
@media(max-width:1040px){.shipment-row{grid-template-columns:minmax(0,1fr) minmax(0,1fr)}.shipment-row>.shipment-insight{grid-column:1/-1;border-left:0;border-top:1px solid #ecd9c9}.shipment-row>.shipment-reference,.shipment-row>.shipment-route,.shipment-row>.shipment-insight{padding:17px 19px}}
@media(max-width:720px){.shipment-row{grid-template-columns:minmax(0,1fr)}.shipment-row>.shipment-route,.shipment-row>.shipment-insight{border-left:0;border-top:1px solid #ecd9c9}.shipment-row>.shipment-reference,.shipment-row>.shipment-route,.shipment-row>.shipment-insight{padding:18px 19px}.nl-card-heading{margin-bottom:13px}}
@media(max-width:480px){.shipment-row .row-facts{grid-template-columns:minmax(0,1fr)}.shipment-row .shipment-actions .btn{flex:1 1 auto}}
.shipment-row .nl-cancel-inline{position:static;top:auto;right:auto;left:auto;width:min(100%,360px);margin-top:9px;box-shadow:0 6px 16px #321b1314}
@media(prefers-reduced-motion:reduce){.shipment-row,.shipment-row .btn{transition:none!important;animation:none!important}}
/* v14 standalone: voyage animation is decorative, never a live tracking claim. */
.nl-journey-banner{display:flex;gap:15px;justify-content:space-between;align-items:center;border:1px solid #f0d5bd;border-radius:16px;padding:10px 17px;margin:-4px 0 19px;background:linear-gradient(105deg,#fffaf5 0%,#fff1e1 100%);overflow:hidden;min-height:67px}
.nl-journey-banner strong{display:block;color:#69371c;font-size:.91rem;margin-bottom:1px}
.nl-journey-banner p{margin:0;color:#8a6651;font-size:.78rem;line-height:1.4}
.nl-journey-art{position:relative;flex:0 0 218px;height:48px;overflow:hidden;isolation:isolate}
.nl-journey-art .nl-water{position:absolute;left:0;right:0;bottom:2px;height:10px;background:repeating-linear-gradient(100deg,#ed9f5b 0 15px,transparent 15px 26px);opacity:.5;border-radius:40%;background-size:52px 100%;animation:nlWaveDrift 4s linear infinite}
.nl-journey-art .nl-boat{position:absolute;left:13%;bottom:8px;font-size:1.75rem;transform-origin:50% 90%;filter:drop-shadow(0 3px 2px #8a3a1245);animation:nlBoatMove 7s ease-in-out infinite alternate}
.nl-journey-art .nl-container-art{position:absolute;right:12%;top:5px;font-size:1.4rem;color:#b95314;opacity:.7;animation:nlContainerFloat 3.5s ease-in-out infinite}
@keyframes nlWaveDrift{to{background-position:52px 0}}
@keyframes nlBoatMove{0%{left:13%;transform:translateY(0) rotate(-2deg)}50%{transform:translateY(-2px) rotate(2deg)}100%{left:51%;transform:translateY(0) rotate(-1deg)}}
@keyframes nlContainerFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-4px)}}
.nl-local-find{flex:1 1 220px;min-width:160px;max-width:340px}
.nl-local-find .input{background:#fffcf8;border-color:#e9cdb4}
.nl-local-search-note{width:100%;color:#8b6c58;font-size:.75rem;margin:-4px 0 1px}
.nl-local-clear{flex:0 0 auto}
.shipment-row .nl-container-info{transition:background-color .22s,border-color .22s}
.shipment-row:hover .nl-container-info{background:#ffebd9;border-color:#eab98e}
.shipment-row .nl-status-head .pill{white-space:normal;text-align:center}
@media(max-width:700px){.nl-journey-banner{padding:12px 14px}.nl-journey-art{flex-basis:108px}.nl-journey-art .nl-boat{font-size:1.38rem}.nl-journey-art .nl-container-art{font-size:1rem}.nl-local-find{max-width:none;flex-basis:100%}.nl-local-clear{flex-grow:1}}
@media(prefers-reduced-motion:reduce){.nl-journey-art .nl-water,.nl-journey-art .nl-boat,.nl-journey-art .nl-container-art{animation:none!important}.shipment-row .nl-container-info{transition:none!important}}


/* v16.9 | card containment & button alignment, using existing inline CSS artwork */
.page-heading.page-hero{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(220px,285px)!important;grid-template-rows:auto auto;grid-template-areas:"copy art" "actions art";align-items:center;column-gap:20px;row-gap:10px;min-height:195px;max-height:none;margin:0 0 20px;padding:20px 24px;overflow:hidden!important;isolation:isolate;box-shadow:0 15px 33px #653a2011}
.page-hero .hero-copy{grid-area:copy;align-self:end;min-width:0;position:relative;z-index:1}
.page-hero .hero-actions{grid-area:actions;display:flex;align-self:start;align-items:center;justify-content:flex-start!important;gap:9px;flex-wrap:wrap;min-width:0;position:relative;z-index:1}
.page-hero .hero-actions .btn{margin:0;white-space:nowrap}
.page-hero .hero-art{grid-area:art;position:relative;z-index:1;justify-self:end;align-self:center;display:block!important;width:100%;max-width:285px;height:154px;min-height:154px;overflow:hidden!important;border-radius:16px}
.page-hero .ship-scene{position:absolute;top:5px;left:4px;width:300px!important;height:160px!important;transform:scale(.91)!important;transform-origin:top left!important;filter:none!important}
@media(max-width:860px){.page-heading.page-hero{grid-template-columns:1fr!important;grid-template-areas:"copy" "actions";padding:18px 20px;min-height:0}.page-hero .hero-art{display:none!important}}
@media(prefers-reduced-motion:reduce){.page-hero .ship-scene *{animation:none!important}}
.nl-raise-claim{background:#fff0df;border:1px solid #d55d20!important;color:#9e3b10!important;font-weight:850!important}.nl-raise-claim:hover{background:#ffd6b7!important;transform:translateY(-2px)!important}
.nl-shipment-focus{animation:nlShipHighlight 2.2s ease-in-out 2;outline:3px solid #e8691a;scroll-margin-top:100px}
@keyframes nlShipHighlight{0%,100%{box-shadow:0 0 0 0 rgba(236,112,24,0)}50%{box-shadow:0 0 0 10px rgba(236,112,24,.13)}}

/* v17.4: two-column shipment cards and compact route, no central journey column. */
.shipment-row{grid-template-columns:minmax(0,1fr) minmax(0,1.15fr)!important;gap:0!important}
.shipment-row>.shipment-reference,.shipment-row>.shipment-insight{min-width:0!important;padding:20px 23px!important}
.shipment-row>.shipment-insight{border-left:1px solid #ecd9c9!important;border-top:0!important;grid-column:auto!important;display:flex!important;flex-direction:column!important;gap:12px!important}
.nl-compact-route{display:flex;align-items:center;gap:11px;margin-top:16px;padding:11px 13px;background:#fff3e9;border:1px solid #efd8c3;border-radius:12px;min-width:0}
.nl-compact-route>span:not(.nl-compact-arrow){flex:1;min-width:0}
.nl-compact-route small{display:block;text-transform:uppercase;font-weight:800;font-size:.68rem;color:#945d38;letter-spacing:.05em}
.nl-compact-route strong{display:block;overflow-wrap:anywhere;font-size:.91rem;line-height:1.35;color:#3b281c}
.nl-compact-arrow{flex:none;color:#d45c12;font-size:1.35rem;font-weight:900}
.shipment-row[data-shipment-status="CANCELLED"] .nl-progress-count,.shipment-row[data-shipment-status="CANCELLED"] .nl-progress-track{display:none!important}
@media(max-width:990px){.shipment-row{grid-template-columns:minmax(0,1fr)!important}.shipment-row>.shipment-insight{border-left:0!important;border-top:1px solid #ecd9c9!important}.shipment-row>.shipment-reference,.shipment-row>.shipment-insight{padding:17px 18px!important}}
@media(max-width:420px){.nl-compact-route{gap:7px;padding:10px}.nl-compact-route strong{font-size:.82rem}}

/* v17.7 | Consumer cancellation: coordinated card actions and accessible centered dialog. */
.shipment-row .shipment-actions{display:flex!important;flex-flow:row wrap;align-items:center!important;justify-content:flex-start!important;gap:10px!important;min-height:62px;margin-top:auto!important;padding-top:15px!important;border-top:1px solid #efd9c8!important}
.shipment-row .shipment-actions>.btn{display:inline-flex;align-items:center;justify-content:center;min-height:43px!important;padding:10px 16px!important;font-size:.9rem!important;line-height:1.25!important;font-weight:750!important;white-space:nowrap;flex:0 0 auto}
.shipment-row .nl-cancel-trigger,.nl-detail-cancel-action .nl-cancel-trigger{border:1px solid #d89079!important;background:#fff7f3!important;color:#a23a20!important;font-weight:800!important;box-shadow:none!important;min-height:43px}
.shipment-row .nl-cancel-trigger:hover,.nl-detail-cancel-action .nl-cancel-trigger:hover{background:#ffe9e1!important;border-color:#bd6043!important;color:#8e2f19!important}
.shipment-row .shipment-reference .nl-label,.shipment-row .nl-section-title{font-size:.76rem!important;letter-spacing:.055em!important;line-height:1.45!important}
.shipment-row .nl-card-heading,.shipment-row .nl-status-description{font-size:.92rem!important;line-height:1.5!important}
.shipment-row .nl-container-value .mono,.shipment-row .nl-compact-route strong{font-size:.95rem!important}
.shipment-row .row-facts>span{padding:12px 13px!important}
.shipment-row .row-facts small{font-size:.78rem!important}
.shipment-row .row-facts b{font-size:1rem!important;line-height:1.35!important}
.shipment-row>.shipment-insight{justify-content:space-between;gap:14px!important}
.shipment-row>.shipment-reference{align-self:stretch}
.nl-detail-cancel-action{display:flex;align-items:center;gap:13px;flex-wrap:wrap;margin-top:14px;padding:13px 0;border-top:1px solid #edd9c7}
.nl-detail-cancel-action>span{color:#836754;font-size:.85rem}
.nl-cancel-feedback{margin:12px 0 18px;padding:14px 17px;border:1px solid #edb9a2;border-left:5px solid #c54318;border-radius:13px;background:#fff1ea;color:#783217;font-size:.95rem;line-height:1.55}.nl-cancel-feedback strong{font-weight:850}
.nl-cancel-dialog[hidden]{display:none!important}
.nl-cancel-dialog:not([hidden]){display:flex;position:fixed;inset:0;margin:0;align-items:center;justify-content:center;padding:16px;overflow:auto;background:rgba(33,21,17,.68);z-index:99999}
.nl-cancel-dialog:not([hidden]){backdrop-filter:blur(5px)}
.nl-cancel-panel{padding:24px}
.nl-cancel-top{display:flex;align-items:flex-start;gap:13px;margin-bottom:14px}
.nl-cancel-mark{display:grid;place-items:center;flex:0 0 42px;height:42px;border-radius:12px;background:#fff0e8;color:#af462a;font-size:1.15rem;font-weight:900;border:1px solid #f2cbb9}
.nl-cancel-title{flex:1;min-width:0}
.nl-cancel-title small{font-weight:850;letter-spacing:.09em;color:#a2542c;font-size:.72rem}
.nl-cancel-title h3{font-size:1.45rem!important;line-height:1.2;margin:4px 0 0}
.nl-cancel-close{flex:0 0 36px;width:36px;height:36px;background:#fff5ed;color:#8f5f46;border:1px solid #efdbc9;border-radius:10px;font-size:1.5rem;line-height:1}
.nl-cancel-explainer{color:#675143;font-size:.94rem;line-height:1.62;margin:4px 0 19px}
.nl-cancel-form{display:grid;gap:9px}
.nl-cancel-form label{display:block;font-size:.93rem;font-weight:800;color:#482e21}
.nl-cancel-required{color:#c02e1e;margin-left:3px}
.nl-cancel-form textarea.input{width:100%;resize:vertical;min-height:99px;padding:12px 13px;border:1px solid #dcc0ad;border-radius:12px;box-shadow:none;background:#fff;color:#35221a;font-size:.95rem;line-height:1.45}
.nl-cancel-form textarea:focus{border-color:#ce6a2c!important;outline:3px solid #f7d2b8!important;outline-offset:0!important}
.nl-cancel-note{color:#88685a;font-size:.81rem;margin:0}
.nl-cancel-footer{display:flex;align-items:center;justify-content:flex-end;gap:10px;flex-wrap:wrap;margin-top:13px;padding-top:15px;border-top:1px solid #efddcf}
.nl-cancel-footer .btn{min-height:43px;padding:10px 16px;font-size:.88rem;font-weight:800}
.nl-cancel-confirm{color:white!important;background:linear-gradient(110deg,#a3311b,#c64e2a)!important;border:1px solid #ae3922!important}
.nl-cancel-confirm:hover{background:linear-gradient(110deg,#892b19,#af3d20)!important;color:white!important}
@media(max-width:700px){.shipment-row .shipment-actions{min-height:0}.shipment-row .shipment-actions>.btn{flex:1 1 145px;white-space:normal}.nl-cancel-panel{padding:18px}.nl-cancel-footer .btn{flex:1 1 155px}.nl-cancel-title h3{font-size:1.2rem!important}}


/* v17.9 | Responsive shipment details and focused confirmation modal. */
.detail-heading{align-items:center!important;margin-bottom:18px!important;gap:14px!important}
.detail-heading>.btn{flex:0 0 auto!important;width:auto!important;min-height:42px!important;padding:10px 16px!important}
#details>.card-head{align-items:center!important;margin-bottom:18px!important}
#details>.card-head h2{font-size:clamp(1.17rem,2.2vw,1.75rem)!important;overflow-wrap:anywhere;line-height:1.35}
#details>.card-head .heading-actions{flex:0 0 auto}
#details .detail-box{min-height:93px;border-color:#ecd7c5!important}
#details .detail-box small{color:#886b56!important;font-size:.83rem!important;font-weight:700}
#details .detail-box strong{line-height:1.45!important;font-size:1rem!important;overflow-wrap:anywhere}
.nl-record-more{margin-top:24px;display:grid;gap:16px}
.nl-record-section{min-width:0;border:1px solid #ebd6c3;border-radius:17px;background:linear-gradient(140deg,#fffdfb,#fff8f1);padding:clamp(15px,2vw,22px)}
.nl-record-section-heading{display:flex;align-items:center;gap:12px;margin-bottom:18px}
.nl-record-section-icon{flex:0 0 38px;height:38px;display:grid;place-items:center;background:#ffecd8;border:1px solid #edd1b7;border-radius:11px;color:#a84614;font-size:.76rem;font-weight:900}
.nl-record-section h3{margin:0 0 3px;font-size:1.08rem!important;letter-spacing:-.018em}
.nl-record-section-heading p{margin:0;color:#896b57;font-size:.82rem}
.nl-record-info-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:13px}
.nl-record-info-grid.compact{grid-template-columns:repeat(2,minmax(0,1fr))}
.nl-record-info-grid>div{min-width:0;padding:12px 14px;border:1px solid #f1dfce;border-radius:12px;background:#fff}
.nl-record-info-grid small{display:block;color:#806452;font-size:.8rem;font-weight:700;margin-bottom:6px}
.nl-record-info-grid strong{display:block;color:#36251c;font-size:.93rem;font-weight:800;line-height:1.45;overflow-wrap:anywhere}
.nl-record-info-grid .nl-wide-info{grid-column:span 2}
.nl-record-bottom{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}
.nl-cargo-table-wrap{overflow-x:auto;border-radius:12px;border:1px solid #e9d6c5}
.nl-cargo-table{width:100%;border-collapse:collapse;min-width:590px;font-variant-numeric:tabular-nums}
.nl-cargo-table th{background:#fff0e2;text-align:left;color:#78543b;font-size:.8rem;font-weight:850;padding:12px 15px}
.nl-cargo-table td{background:#fff;padding:13px 15px;border-top:1px solid #f2e2d5;font-size:.9rem;color:#463126;vertical-align:middle}
.nl-cargo-table td strong{display:block;max-width:260px}.nl-cargo-table td small{display:block;font-size:.78rem;color:#906b54;margin-top:3px}
.nl-record-muted{font-size:.88rem;color:#8a6b56}.nl-record-archive-note{margin:14px 0 0;padding:11px 13px;border-radius:10px;border:1px solid #ebd2b8;background:#fff0df;color:#81502b;font-size:.84rem}
.nl-cancel-dialog:not([hidden]){width:100%!important;max-width:none!important;max-height:none!important;overflow-y:auto!important}
.nl-cancel-dialog .nl-cancel-panel{flex:0 1 570px;width:min(570px,100%);max-height:calc(100vh - 32px);max-height:calc(100dvh - 32px);overflow-y:auto;border:1px solid #dfbea9;border-radius:23px;background:#fffcf9;color:#38281e;box-shadow:0 28px 95px #27130a60}
.nl-cancel-panel{padding:clamp(20px,3.6vw,31px)!important;position:relative}
.nl-cancel-panel::before{content:"";display:block;height:5px;background:linear-gradient(90deg,#d36d2b,#e89e64,#f3caaa);position:absolute;inset:0 0 auto 0;border-radius:22px 22px 0 0}
.nl-cancel-mark{height:45px!important;flex-basis:45px!important;border-radius:14px!important;background:#fff0e4!important;color:#c04a21!important}
.nl-cancel-title h3{font-size:1.5rem!important;letter-spacing:-.025em!important}
.nl-cancel-title small{font-size:.7rem!important;letter-spacing:.13em!important}
.nl-cancel-explainer{margin:15px 0 17px!important;font-size:.94rem!important;line-height:1.63!important;color:#665144!important}
.nl-cancel-impact{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:8px;margin-bottom:20px}
.nl-cancel-impact>div{border:1px solid #f0dcca;border-radius:11px;background:linear-gradient(160deg,#fff8f1,#fffdfb);padding:11px 10px;min-width:0}
.nl-cancel-impact span{display:grid;place-items:center;width:26px;height:26px;border-radius:8px;background:#ffead7;color:#aa501c;font-size:.96rem;font-weight:900;margin-bottom:8px}
.nl-cancel-impact strong{display:block;color:#442f23;font-size:.78rem;line-height:1.35}
.nl-cancel-impact small{display:block;color:#856a58;font-size:.72rem;line-height:1.45;margin-top:4px}
.nl-cancel-form label{font-size:.89rem!important;font-weight:800!important}
.nl-cancel-form textarea.input{min-height:105px!important;font-size:.94rem!important;border:1px solid #dcc5b1!important;box-shadow:none!important}
.nl-cancel-form textarea.input:focus{border-color:#ce6a2c!important;outline:3px solid #f7d2b8!important}
.nl-cancel-note{font-size:.8rem!important;background:#fff4ea;border-left:3px solid #e6a175;border-radius:5px;padding:9px 12px;color:#7c604c}
.nl-cancel-footer{margin-top:12px!important;padding-top:17px!important}
.nl-cancel-footer .btn{min-height:46px!important;border-radius:11px!important;font-size:.9rem!important}
@media(max-width:920px){.nl-record-bottom{grid-template-columns:1fr}.nl-record-info-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:640px){.nl-record-info-grid,.nl-record-info-grid.compact{grid-template-columns:1fr}.nl-record-info-grid .nl-wide-info{grid-column:auto}.nl-cancel-impact{grid-template-columns:1fr}.nl-cancel-impact>div{display:grid;grid-template-columns:30px 1fr;gap:1px 10px}.nl-cancel-impact span{grid-row:span 2;margin:0}.nl-cancel-impact small{margin:0}.nl-cancel-title h3{font-size:1.2rem!important}.detail-heading>.btn{width:100%!important}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row,html[data-nl-mode="dark"] body.nl-themed-page .shipment-row:nth-child(even),html[data-nl-mode="dark"] body.nl-themed-page .shipment-row:nth-child(odd),html[data-nl-mode="dark"] body.nl-themed-page .shipment-row>.shipment-reference,html[data-nl-mode="dark"] body.nl-themed-page .shipment-row>.shipment-route,html[data-nl-mode="dark"] body.nl-themed-page .shipment-row>.shipment-insight,html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .shipment-summary,html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-status-head{background:#203044!important;background-image:none!important;color:#f1f6fd!important;border-color:#506a82!important;box-shadow:none!important}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .nl-container-info,html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .row-facts>span{background:#2b3e52!important;color:#d5e2f0!important;border-color:#556e84!important;box-shadow:none!important}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row :is(.nl-container-value,.mono,.nl-route-stop strong,.row-facts b,.nl-card-heading strong,.nl-status-description){color:#f1f6fd!important}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row :is(.nl-label,.row-kicker,.nl-section-title){color:#ffbb89!important}
html[data-nl-mode="dark"] body.nl-themed-page .shipment-row .btn.light{background:#29415a!important;color:#ffe2c7!important;border-color:#647d92!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-record-section,html[data-nl-mode="dark"] body.nl-themed-page .nl-record-info-grid>div,html[data-nl-mode="dark"] body.nl-themed-page .nl-cargo-table,html[data-nl-mode="dark"] body.nl-themed-page .nl-record-bottom,html[data-nl-mode="dark"] body.nl-themed-page .nl-record-archive-note{background:#203044!important;color:#eef5fc!important;border-color:#526a80!important;box-shadow:none!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-record-info-grid>div{background:#2b3e52!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-record-section :is(h2,h3,strong,b,span,.mono,dt,dd),html[data-nl-mode="dark"] body.nl-themed-page .nl-record-info-grid :is(strong,b,span){color:#ecf4fb!important}

/* Module 2 - persisted shipment delay notice and Seller reporting workflow */
body.nl-themed-page .nl-delay-notice{margin:16px 0 22px;padding:18px 20px;border:1px solid #edb184;border-left:5px solid #d4570f;border-radius:15px;background:#fff4e9;color:#563723;box-shadow:0 6px 18px #7c38110e}
body.nl-themed-page .nl-delay-notice-head{display:flex;align-items:center;gap:12px;margin-bottom:13px}
body.nl-themed-page .nl-delay-notice-head strong{font-size:1.08rem;color:#8c3607;display:block}
body.nl-themed-page .nl-delay-notice-head small,body.nl-themed-page .nl-delay-report small{display:block;color:#87644e;font-size:.78rem}
body.nl-themed-page .nl-delay-emblem{display:grid;place-items:center;width:36px;height:36px;flex:0 0 36px;border-radius:11px;background:#dc631c;color:#fff;font-size:1.27rem;font-weight:900}
body.nl-themed-page .nl-delay-date-strip{display:flex;flex-wrap:wrap;gap:10px;margin-bottom:12px}
body.nl-themed-page .nl-delay-date-strip span{flex:1 1 150px;display:grid;gap:4px;padding:9px 12px;border:1px solid #f1d2b5;background:#fffaf6;border-radius:10px;font-size:.75rem;color:#85624d}
body.nl-themed-page .nl-delay-date-strip strong{font-size:.95rem;color:#573522;font-variant-numeric:tabular-nums}
body.nl-themed-page .nl-delay-reason{margin:9px 0 7px;font-size:.9rem;overflow-wrap:anywhere;white-space:normal}
body.nl-themed-page .nl-delay-reported-at,body.nl-themed-page .nl-delay-visibility-note{font-size:.77rem;color:#8f6a52;margin:8px 0 0}
body.nl-themed-page .nl-delay-history{margin-top:12px;border-top:1px solid #eed0b7;padding-top:10px;font-size:.83rem}
body.nl-themed-page .nl-delay-history summary{cursor:pointer;font-weight:750;color:#a3440e}
body.nl-themed-page .nl-delay-history p{padding:5px 0;margin:3px 0;overflow-wrap:anywhere}
body.nl-themed-page .nl-delay-report{margin:17px 0 20px;border:1px solid #e9c5a6;border-radius:14px;background:#fff9f3;overflow:visible;min-width:0}
body.nl-themed-page .nl-delay-report>summary{list-style:none;cursor:pointer;padding:15px 17px;color:#9f410d;font-size:1rem;font-weight:850;display:flex;justify-content:space-between;align-items:center;gap:12px}
body.nl-themed-page .nl-delay-report>summary::-webkit-details-marker{display:none}
body.nl-themed-page .nl-delay-report>summary::before{content:'+';font-size:1.28rem;margin-right:3px;color:#bb520b}
body.nl-themed-page .nl-delay-report[open]>summary::before{content:'-'}
body.nl-themed-page .nl-delay-report .nl-delay-summary-hint{font-size:.78rem;color:#947057;font-weight:600;margin-left:auto}
body.nl-themed-page .nl-delay-report-body{padding:16px 18px 18px;border-top:1px solid #eed9c8}
body.nl-themed-page .nl-delay-report-body>p{margin:0 0 14px;color:#78604d;font-size:.86rem}
body.nl-themed-page .nl-delay-form{display:grid;gap:13px;min-width:0}
body.nl-themed-page .nl-delay-form-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:13px}
body.nl-themed-page .nl-delay-form-grid .field{min-width:0;align-self:start}
body.nl-themed-page .nl-delay-current{min-height:45px;display:flex;align-items:center;padding:10px 12px;background:#f6eee6;border:1px solid #e7d3c1;border-radius:11px;font-weight:750}
body.nl-themed-page .nl-delay-date{width:100%;min-height:45px;background:#fffefa;border-color:#e3b994;color-scheme:light}
body.nl-themed-page .nl-delay-form .textarea{width:100%;min-height:80px}
body.nl-themed-page .nl-delay-report-actions{display:flex;align-items:center;flex-wrap:wrap;gap:11px}
body.nl-themed-page .nl-delay-error{margin:5px 0 14px;padding:11px 13px;border:1px solid #dc9b90;border-radius:10px;background:#fff1ef;color:#9d3828}
html[data-nl-mode=dark] body.nl-themed-page :is(.nl-delay-notice,.nl-delay-report){background:#24374a!important;border-color:#b7724d!important;color:#eaf2f9!important}
html[data-nl-mode=dark] body.nl-themed-page :is(.nl-delay-date-strip span,.nl-delay-current,.nl-delay-form .input,.nl-delay-form .textarea){background:#192c3e!important;border-color:#567189!important;color:#f0f6fa!important;color-scheme:dark}
html[data-nl-mode=dark] body.nl-themed-page :is(.nl-delay-notice-head strong,.nl-delay-date-strip strong,.nl-delay-report>summary,.nl-delay-history summary){color:#ffb685!important}
html[data-nl-mode=dark] body.nl-themed-page :is(.nl-delay-notice-head small,.nl-delay-report small,.nl-delay-report-body>p,.nl-delay-reported-at,.nl-delay-visibility-note,.nl-delay-summary-hint){color:#c4d4e1!important}
@media(max-width:650px){body.nl-themed-page .nl-delay-form-grid{grid-template-columns:1fr}body.nl-themed-page .nl-delay-report>summary{flex-wrap:wrap}body.nl-themed-page .nl-delay-notice{padding:14px}}

/* v20.47: Consumer overview highlights persisted Seller delay reports. */
body.nl-themed-page .shipment-row .nl-list-delay-alert{margin:10px 0 12px;padding:12px 14px;border:1px solid #efbc8b;border-left:4px solid #d25d16;border-radius:12px;background:#fff2e7;color:#71401f;overflow-wrap:anywhere;line-height:1.45}
body.nl-themed-page .nl-list-delay-head{display:flex;align-items:center;gap:8px;margin-bottom:6px}
body.nl-themed-page .nl-list-delay-head strong{font-size:.9rem;color:#9c420e}
body.nl-themed-page .nl-list-delay-icon{display:grid;place-items:center;flex:0 0 22px;height:22px;border-radius:7px;background:#d75a16;color:white;font-size:14px;font-weight:900}
body.nl-themed-page .nl-list-delay-dates{font-size:.81rem;line-height:1.5}
body.nl-themed-page .nl-list-delay-dates strong{font-variant-numeric:tabular-nums;white-space:nowrap}
body.nl-themed-page .nl-list-delay-reason{margin:6px 0 0;font-size:.81rem;color:inherit;overflow-wrap:anywhere}
html[data-nl-mode="dark"] body.nl-themed-page .nl-list-delay-alert{background:#473222!important;border-color:#c47a45!important;color:#ffe5ce!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-list-delay-head strong{color:#ffbd8b!important}
</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<%@ include file="../shared/_theme.jsp" %>
<style id="nl-v2012-cancel-booking-orange">
/* Keep the existing cancellation confirmation and permissions unchanged.
   Only match the Cancel booking / Cancel shipment triggers to other orange actions. */
html body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"]
  :is(.shipment-row,.nl-detail-cancel-action) button.nl-cancel-trigger:not(:disabled) {
  background:var(--nl-action-gradient,linear-gradient(112deg,#bf430d,#e76a15))!important;
  background-image:var(--nl-action-gradient,linear-gradient(112deg,#bf430d,#e76a15))!important;
  background-color:#ce510e!important;
  color:#fff!important;
  -webkit-text-fill-color:#fff!important;
  border-color:#ba430f!important;
  box-shadow:0 5px 13px rgba(170,60,11,.16)!important;
}
html body.nl-themed-page[data-nl-screen="module2-shipmentmanagement"]
  :is(.shipment-row,.nl-detail-cancel-action) button.nl-cancel-trigger:not(:disabled):is(:hover,:focus-visible) {
  background:var(--nl-action-hover,linear-gradient(112deg,#a73507,#d4560e))!important;
  background-image:var(--nl-action-hover,linear-gradient(112deg,#a73507,#d4560e))!important;
  color:#fff!important;
  -webkit-text-fill-color:#fff!important;
  border-color:#a73507!important;
  box-shadow:0 8px 18px rgba(170,60,11,.27)!important;
}

/* v20.23 - scan-first shipment card rhythm */
body[data-nl-screen="module2-shipmentmanagement"] .shipment-row{border-radius:17px!important;transition:box-shadow .18s ease,border-color .18s ease}
body[data-nl-screen="module2-shipmentmanagement"] .shipment-row:hover{box-shadow:0 12px 29px #7c4b241e!important}
body[data-nl-screen="module2-shipmentmanagement"] :is(.shipment-actions,.shipment-row-actions,.shipment-footer){gap:10px!important;flex-wrap:wrap!important}
body[data-nl-screen="module2-shipmentmanagement"] :is(.shipment-actions,.shipment-row-actions) :is(a,button){min-height:39px;white-space:normal;text-align:center}
@media(max-width:620px){body[data-nl-screen="module2-shipmentmanagement"] .shipment-row{min-width:0!important}body[data-nl-screen="module2-shipmentmanagement"] :is(.shipment-actions,.shipment-row-actions)>*{flex:1 1 140px}}

</style>
</head><body data-nl-screen="module2-shipmentmanagement" class="nl-themed-page nl-universal-module2" data-nl-enhanced="true"><jsp:include page="/WEB-INF/views/shared/_nav.jsp" />
<div class="app-shell">
<jsp:include page="/WEB-INF/views/shared/_sidebar.jsp" />
<main class="main-area" id="mainContent"><div class="content-wrap">

<%-- Post-payment success is shown on the authorized shipment-detail page. --%>
${requestScope.nlv_Module2_shipmentManagement__1}
${requestScope.nlv_Module2_shipmentManagement__2}
${requestScope.nlv_Module2_shipmentManagement__3}
${requestScope.nlv_Module2_shipmentManagement__4}

<script>
/* v17.12: The ordinary HTML div overlay avoids JSP validator unknown-tag warnings.
   A centered viewport overlay preserves action layout, ESC, focus management, and close controls. */
(function(){'use strict';
  var opened=null;
  function closeDialog(dialog){
    if(!dialog || dialog.hidden)return;
    dialog.hidden=true;
    var trigger=dialog._returnFocus;
    if(opened===dialog)opened=null;
    if(trigger && trigger.isConnected)trigger.focus();
  }
  document.querySelectorAll('.nl-cancel-dialog').forEach(function(dialog){
    /* Move out of animated/transformed shipment cards so fixed overlay is viewport-relative. */
    if(dialog.parentElement!==document.body)document.body.appendChild(dialog);
    var reason=dialog.querySelector('textarea[name="reason"]');
    if(reason)reason.minLength=6; /* Native validation without a JSP-unsupported minlength attribute. */
    dialog.querySelectorAll('[data-close-cancel]').forEach(function(button){
      button.addEventListener('click',function(){closeDialog(dialog);});
    });
    dialog.addEventListener('click',function(event){
      if(event.target===dialog)closeDialog(dialog);
    });
    dialog.addEventListener('keydown',function(event){
      if(event.key!=='Tab')return;
      var focusable=Array.from(dialog.querySelectorAll('button:not([disabled]), textarea:not([disabled]), input:not([type="hidden"]):not([disabled])'));
      if(!focusable.length)return;
      var first=focusable[0],last=focusable[focusable.length-1];
      if(event.shiftKey && document.activeElement===first){event.preventDefault();last.focus();}
      else if(!event.shiftKey && document.activeElement===last){event.preventDefault();first.focus();}
    });
  });
  document.querySelectorAll('[data-open-cancel]').forEach(function(trigger){
    trigger.addEventListener('click',function(){
      var dialog=document.getElementById(trigger.getAttribute('data-open-cancel'));
      if(!dialog)return;
      if(opened && opened!==dialog)closeDialog(opened);
      dialog._returnFocus=trigger;
      dialog.hidden=false;
      opened=dialog;
      var reason=dialog.querySelector('textarea[name="reason"]');
      if(reason)reason.focus();else dialog.focus();
    });
  });
  document.addEventListener('keydown',function(event){
    if(event.key==='Escape' && opened){event.preventDefault();closeDialog(opened);}
  });
})();
</script>
<%@ include file="../shared/_end.jsp" %>
</div></main></div><script>(function(){const id=new URLSearchParams(location.search).get('highlightShipment');if(!id||!/^[0-9]+$/.test(id))return;const row=document.getElementById('shipment-'+id);if(row){row.classList.add('nl-shipment-focus');row.scrollIntoView({behavior:matchMedia('(prefers-reduced-motion: reduce)').matches?'auto':'smooth',block:'center'});}})();</script></body></html>
