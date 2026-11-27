<jsp:useBean id="nlViewSupport_Module2_profitLossDashboard" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module2_profitLossDashboard" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module2_profitLossDashboard" property="view" value="Module2/profitLossDashboard.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,java.math.*,model.*" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Profit &amp; Loss | N-LOGISTIC</title><style>
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

/* Contextual export chooser: one clearly named action, two explained CSV formats. */
.report-download{grid-column:1/-1;display:flex;align-items:center;justify-content:space-between;gap:16px;flex-wrap:wrap;padding:15px 17px;background:#fffaf5;border:1px solid #ead6c4;border-radius:14px;min-width:0}
.download-title{display:block;font-size:.92rem;font-weight:850;color:#61321d}
.download-help{margin:3px 0 0;color:#856e60;font-size:.79rem;max-width:560px}
.csv-menu{position:relative;z-index:15;flex:0 0 auto}
.csv-menu>summary{cursor:pointer;list-style:none;min-width:190px;justify-content:space-between;gap:17px}
.csv-menu>summary::-webkit-details-marker{display:none}
.csv-menu[open]>summary{border-color:#cf711f;color:#a63d08;box-shadow:0 0 0 3px #efb77f48}
.csv-options{position:absolute;right:0;top:calc(100% + 9px);width:min(360px,calc(100vw - 40px));padding:7px;background:#fffdfb;border:1px solid #e7c5ac;border-radius:14px;box-shadow:0 16px 40px #43210c26;animation:dropin .18s ease both}
.csv-option{display:flex;flex-direction:column;align-items:flex-start;width:100%;text-align:left;padding:12px 13px;background:transparent;color:#56311e;border:0;border-radius:9px;gap:3px;line-height:1.3}
.csv-option:hover,.csv-option:focus-visible{background:#fff0df;outline-offset:2px}
.csv-option strong{font-size:.88rem}.csv-option small{color:#92715c;font-size:.75rem}
@media(max-width:650px){.report-download{align-items:stretch}.csv-menu,.csv-menu>summary{width:100%}.csv-options{left:0;right:auto;width:100%}}

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

/* Presentation finish: consistent alignment, keyboard visibility and gentle motion. */
:where(a,button,input,select,textarea,summary):focus-visible{outline:2px solid #e2640b;outline-offset:3px}
.card,.stat,.detail-box,.field,.form-actions,.table-wrap{min-width:0}
.page-heading h1{overflow-wrap:break-word}.card-head>div{min-width:0}
.top-details summary:focus-visible{outline:2px solid #ffbc80;outline-offset:4px}
.form-actions{display:flex;flex-wrap:wrap;align-items:center;gap:9px}
input,select,textarea{max-width:100%}
.data-table :is(td,th){line-height:1.45}
@media(prefers-reduced-motion:reduce){html{scroll-behavior:auto!important}}

/* Keep the export menu in the foreground even when animated summary cards form their own layers. */
.profit-filter-card{position:relative;z-index:2;overflow:visible}
.profit-filter-card.csv-report-elevated,.profit-filter-card:has(.csv-menu[open]){z-index:90}
.csv-menu{z-index:100}
.csv-options{z-index:200;max-height:min(360px,55vh);overflow-y:auto;overscroll-behavior:contain}
.csv-menu.menu-up .csv-options{top:auto;bottom:calc(100% + 9px);transform-origin:bottom right}
.csv-menu[open] .csv-options{animation:dropin .2s ease both}
.profit-filter-card~.stats-grid{z-index:0}
@media(max-width:650px){.csv-options{width:100%;min-width:0}.csv-menu.menu-up .csv-options{transform-origin:bottom left}}


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

/* v14 standalone gentle page transitions */
@keyframes nlStandalonePageIn{from{opacity:.45;transform:translateY(7px)}to{opacity:1;transform:translateY(0)}}
@media(prefers-reduced-motion:no-preference){.content-wrap{animation:nlStandalonePageIn .32s ease-out both}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-pl-toolbar,html[data-nl-mode="dark"] body.nl-themed-page .nl-pl-pages,html[data-nl-mode="dark"] body.nl-themed-page .nl-report-table-pane,html[data-nl-mode="dark"] body.nl-themed-page .nl-report-chart,html[data-nl-mode="dark"] body.nl-themed-page .nl-report-workspace{background:#203044!important;color:#edf4fc!important;border-color:#516b83!important}
</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<%@ include file="../shared/_theme.jsp" %>

<style>
/* v18.1: opt-in readability controls for the existing shipment P&L table. */
.nl-pl-toolbar{display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin:10px 0 13px}
.nl-pl-toolbar label{font-size:.82rem;color:#744e37;font-weight:730}
.nl-pl-toolbar :is(input,select){min-height:40px;border-radius:10px;border:1px solid #e4c8b0;background:white;padding:7px 11px;color:#3b291e}
.nl-pl-toolbar input{flex:1 1 230px;min-width:180px}
.nl-pl-toolbar select{max-width:130px}
.nl-pl-toolbar .nl-pl-count{font-size:.84rem;color:#755542;font-weight:700;margin-left:auto}
.nl-pl-pages{display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;padding:12px 5px 2px;font-size:.82rem;color:#795c48}
.nl-pl-pages button{border:1px solid #e7c5aa;color:#91451e;background:#fffaf5;border-radius:9px;min-height:36px;padding:6px 13px;font-weight:770}
.nl-pl-pages button:disabled{opacity:.45;cursor:not-allowed}
#profitTable{font-size:.85rem}
#profitTable td,#profitTable th{padding:12px 13px}
#profitTable thead th{position:sticky;top:0;z-index:1}
#profitTable tr.nl-pl-negative td:last-child{color:#ab3820;font-weight:800}
#profitTable tr.nl-pl-positive td:last-child{color:#237346;font-weight:790}
#profitTable td:nth-child(2){min-width:170px}
#profitTable td:nth-child(2) .mono{font-size:.79rem;overflow-wrap:anywhere}
#profitTable tbody tr[hidden]{display:none!important}
@media(max-width:700px){.nl-pl-toolbar .nl-pl-count{margin-left:0;width:100%}.nl-pl-pages{justify-content:center}}

/* v20.23 - P&L filters and chart/table readability */
body[data-nl-screen="module2-profitlossdashboard"] :is(.profit-filter-card,.card.soft){border-radius:18px!important}
body[data-nl-screen="module2-profitlossdashboard"] .profit-filter-card .form-grid{gap:12px!important}
body[data-nl-screen="module2-profitlossdashboard"] :is(.switcher,.card-head,.heading-actions){gap:10px;flex-wrap:wrap}
body[data-nl-screen="module2-profitlossdashboard"] .table-responsive{border-radius:13px;scrollbar-color:#c99a71 transparent}
@media(max-width:800px){body[data-nl-screen="module2-profitlossdashboard"] .profit-filter-card{padding:15px!important}}


/* v20.37: P&L-specific chart workspace and column alignment. */
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-report-heading{justify-content:flex-start;text-align:left;margin-bottom:13px}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-toolbar{display:grid;grid-template-columns:minmax(210px,235px) minmax(140px,175px) minmax(210px,1fr) auto;align-items:end;gap:12px;padding:14px 15px;border:1px solid #ead6c4;border-radius:15px;background:#fff8f1;margin-bottom:18px;min-width:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-choice{display:grid;align-content:start;gap:5px;font-size:.78rem;font-weight:800;color:#654a39;min-width:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-choice select{display:block;width:100%;min-height:41px;max-width:100%;padding:8px 30px 8px 12px;border:1px solid #e4c9b2;border-radius:10px;background:#fffdfb;color:#432b1e;appearance:auto;font-size:.86rem}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-series-controls{min-width:0;min-height:62px;margin:0;border:0;padding:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-series-controls legend{float:none;width:auto;margin:0 0 5px;padding:0;font-size:.78rem;font-weight:800;color:#654a39;line-height:1.4}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-series-options{display:flex;flex-wrap:wrap;gap:7px;align-items:center;min-height:39px}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-series-options label{display:inline-flex;align-items:center;gap:6px;padding:7px 10px;border-radius:9px;border:1px solid #ecd4bd;background:#fffdfb;cursor:pointer;color:#753e21;font-size:.81rem;font-weight:750;white-space:nowrap}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-series-options input{accent-color:#d65d0d;margin:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-export{min-height:41px;white-space:nowrap}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,280px),1fr));gap:13px;margin:9px 0 0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-grid[hidden]{display:none!important}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-grid ~ .form-note{margin-top:11px}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-mini-chart{min-width:0;padding:15px 14px 10px;border:1px solid #ead5c3;border-radius:14px;background:#fffdfb}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-mini-chart h3{font-size:1rem;margin-bottom:2px;text-align:left}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-mini-chart p{font-size:.76rem;color:#947361;margin:0 0 8px}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-mini-frame{height:245px;min-height:230px;position:relative;min-width:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-mini-frame canvas{height:100%!important;width:100%!important;display:block}
body[data-nl-screen="module2-profitlossdashboard"] :is(#monthTable,#profitTable){table-layout:fixed;border-collapse:collapse;width:100%;font-variant-numeric:tabular-nums}
body[data-nl-screen="module2-profitlossdashboard"] #monthTable{min-width:800px}
body[data-nl-screen="module2-profitlossdashboard"] #monthTable :is(th,td):nth-child(1){width:16%;text-align:left}
body[data-nl-screen="module2-profitlossdashboard"] #monthTable :is(th,td):nth-child(n+2){width:21%;text-align:right}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable{min-width:1130px}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(1){width:11%;text-align:left}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(2){width:21%;text-align:left}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(3){width:13%;text-align:right}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(4){width:11%;text-align:right}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(5){width:10%;text-align:right}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(6){width:11%;text-align:right}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(7){width:10%;text-align:right}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable :is(th,td):nth-child(8){width:13%;text-align:right}
body[data-nl-screen="module2-profitlossdashboard"] :is(#monthTable,#profitTable) thead th{white-space:normal;overflow-wrap:normal;word-break:normal;vertical-align:middle;line-height:1.35}
body[data-nl-screen="module2-profitlossdashboard"] :is(#monthTable,#profitTable) :is(th,td).numeric{text-align:right!important}
body[data-nl-screen="module2-profitlossdashboard"] :is(#monthTable,#profitTable) td.numeric{white-space:nowrap}
body[data-nl-screen="module2-profitlossdashboard"] #profitTable td:nth-child(2) .mono{display:block;max-width:100%;overflow-wrap:anywhere;font-size:.78rem}
body[data-nl-screen="module2-profitlossdashboard"] :is(#monthTable,#profitTable) tfoot td{background:#fff0de;font-weight:900}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-toolbar{display:grid;grid-template-columns:minmax(220px,1fr) auto auto;align-items:end;gap:12px;margin:12px 0 14px;padding:14px;border:1px solid #efdecc;border-radius:13px;background:#fff9f3}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-control{display:grid;gap:5px;font-size:.79rem;font-weight:750;color:#75523c;min-width:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-control input{width:100%;min-width:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-control select{width:118px;max-width:100%}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-toolbar .nl-pl-count{margin-left:0;align-self:center;text-align:right;white-space:normal}
body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-pages{align-items:center;padding:12px 4px 4px}
body[data-nl-screen="module2-profitlossdashboard"] .nl18-table-addons{display:flex;justify-content:flex-end;align-items:center;flex-wrap:wrap;gap:9px;padding:10px 12px;min-width:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl18-table-addons .nl18-table-status{margin-right:auto;min-width:140px}
body[data-nl-screen="module2-profitlossdashboard"] .nl18-table-addons select{min-width:125px;max-width:180px!important}
body[data-nl-screen="module2-profitlossdashboard"] .nl18-table-addons details{min-width:0}
body[data-nl-screen="module2-profitlossdashboard"] .nl18-table-addons details>summary{min-width:99px;white-space:nowrap}
body[data-nl-screen="module2-profitlossdashboard"] .nl18-table-addons button{white-space:nowrap}
html[data-nl-mode="dark"] body[data-nl-screen="module2-profitlossdashboard"] :is(.nl-pl-chart-toolbar,.nl-pl-mini-chart,.nl-pl-toolbar){background:#223348!important;border-color:#4b6278!important;color:#edf3fc!important}
html[data-nl-mode="dark"] body[data-nl-screen="module2-profitlossdashboard"] :is(.nl-pl-chart-choice,.nl-pl-chart-choice>span,.nl-pl-series-controls legend,.nl-pl-control,.nl-pl-mini-chart h3){color:#edf3fc!important}
html[data-nl-mode="dark"] body[data-nl-screen="module2-profitlossdashboard"] :is(.nl-pl-chart-choice select,.nl-pl-series-options label,.nl-pl-control input,.nl-pl-control select){background:#17293c!important;color:#f3f5fa!important;border-color:#567087!important}
html[data-nl-mode="dark"] body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-mini-chart p{color:#bacbdc!important}
html[data-nl-mode="dark"] body[data-nl-screen="module2-profitlossdashboard"] :is(#monthTable,#profitTable) tfoot td{background:#2c4053!important;color:#f4f7fb!important}
@media(max-width:1200px){body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-toolbar{grid-template-columns:repeat(2,minmax(0,1fr))}body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-export{justify-self:start}}
@media(max-width:700px){body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-chart-toolbar{grid-template-columns:minmax(0,1fr)}body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-series-controls{min-height:unset}body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-toolbar{grid-template-columns:minmax(0,1fr)}body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-control select{width:100%}body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-toolbar .nl-pl-count{text-align:left;width:auto}body[data-nl-screen="module2-profitlossdashboard"] .nl-pl-pages{justify-content:space-between}body[data-nl-screen="module2-profitlossdashboard"] .nl18-table-addons .nl18-table-status{flex:1 1 100%}}

</style>
</head><body data-nl-screen="module2-profitlossdashboard" class="nl-themed-page nl-universal-module2" data-nl-enhanced="true"><jsp:include page="/WEB-INF/views/shared/_nav.jsp"/>
<div class="app-shell">
<jsp:include page="/WEB-INF/views/shared/_sidebar.jsp" />
<main class="main-area" id="mainContent"><div class="content-wrap">

<div class="bread"><a href="${requestScope.nlv_Module2_profitLossDashboard__1}?action=shipments">Workspace</a><span>/</span><b>Profit and loss</b></div>
<div class="page-heading"><div><div class="caps">FINANCIAL PERFORMANCE</div><h1>Profit &amp; <span>loss</span></h1><p>Date-filtered monthly revenue, operating expenses, settled claim losses and net profitability.</p></div><div class="heading-actions"><span class="pill good">CSV export ready</span><a class="btn light" href="${requestScope.nlv_Module2_profitLossDashboard__2}?action=shipments">← Shipments</a></div></div>
${requestScope.nlv_Module2_profitLossDashboard__3}
<section class="card soft profit-filter-card"><div class="card-head"><div><h2>Reporting filters</h2><p class="sub">Select the same date range for the chart, summary and CSV downloads.</p></div><span class="pill">All values in INR</span></div>
<form method="get" action="${requestScope.nlv_Module2_profitLossDashboard__4}" data-filter-range class="form-grid ${requestScope.nlv_Module2_profitLossDashboard__5}">
${requestScope.nlv_Module2_profitLossDashboard__6}
<div class="field"><label for="startDate">From date</label><input id="startDate" class="input" type="date" name="startDate" value="${requestScope.nlv_Module2_profitLossDashboard__7}"/></div>
<div class="field"><label for="endDate">To date</label><input id="endDate" class="input" type="date" name="endDate" value="${requestScope.nlv_Module2_profitLossDashboard__8}"/></div>
<div class="field"><span>Report actions</span><div class="form-actions"><button type="submit" name="action" value="profitLoss" class="btn primary">Apply filters</button><a href="${requestScope.nlv_Module2_profitLossDashboard__9}?action=profitLoss" class="btn light">Reset</a></div></div>
<div class="report-download" role="group" aria-label="CSV downloads">
  <div><span class="download-title">Download report</span><p class="download-help">Choose the level of detail. Downloads use the dates and Seller selected above.</p></div>
  <details class="csv-menu"><summary class="btn light" aria-label="Choose CSV report type">Download CSV report <span aria-hidden="true">▾</span></summary>
    <div class="csv-options">
      <button type="submit" name="action" value="exportMonthlyProfitLossCsv" class="csv-option"><strong>Monthly summary (.csv)</strong><small>One row per month · revenue, costs and profit</small></button>
      <button type="submit" name="action" value="exportProfitLossCsv" class="csv-option"><strong>Shipment breakdown (.csv)</strong><small>One row per shipment and month · detailed cost breakdown</small></button>
    </div>
  </details>
</div>
</form></section>
<div class="stats-grid"><div class="stat"><div class="stat-icon">↗</div><div class="stat-label">Total revenue</div><div class="stat-value">₹${requestScope.nlv_Module2_profitLossDashboard__10}</div><div class="stat-sub">Filtered months</div></div><div class="stat"><div class="stat-icon">▤</div><div class="stat-label">Operating costs</div><div class="stat-value">₹${requestScope.nlv_Module2_profitLossDashboard__11}</div><div class="stat-sub">Freight, port, handling</div></div><div class="stat"><div class="stat-icon">◇</div><div class="stat-label">Settled claim losses</div><div class="stat-value">₹${requestScope.nlv_Module2_profitLossDashboard__12}</div><div class="stat-sub">Financial impact</div></div><div class="stat"><div class="stat-icon">✓</div><div class="stat-label">Net profit</div><div class="stat-value">₹${requestScope.nlv_Module2_profitLossDashboard__13}</div><div class="stat-sub">${requestScope.nlv_Module2_profitLossDashboard__14} reporting months</div></div></div>
<section class="card nl-pl-trend-card" aria-labelledby="nlTrendHeading">
  <div class="card-head nl-pl-report-heading"><div><h2 id="nlTrendHeading">Monthly performance trend</h2><p class="sub">Compare monthly revenue, operating costs and net profit with multiple graph views.</p></div></div>
  <div class="nl-pl-chart-toolbar" aria-label="Financial chart controls">
    <label class="nl-pl-chart-choice" for="nlChartLayout"><span>Graph view</span><select id="nlChartLayout"><option value="combined">Combined graph</option><option value="separate">Three separate graphs</option></select></label>
    <label class="nl-pl-chart-choice" for="nlChartStyle"><span>Chart style</span><select id="nlChartStyle"><option value="line">Line</option><option value="bar">Bar</option><option value="area">Area</option><option value="combo">Combination</option></select></label>
    <fieldset class="nl-pl-series-controls"><legend>Show series</legend><div class="nl-pl-series-options"><label><input type="checkbox" id="showRevenue" checked/> Revenue</label><label><input type="checkbox" id="showCost" checked/> Costs</label><label><input type="checkbox" id="showProfit" checked/> Profit</label></div></fieldset>
    <button type="button" class="btn primary nl-pl-chart-export" id="nlSaveFinancialChart" title="Save the displayed graph or graphs as one image">Save PNG</button>
  </div>
  ${requestScope.nlv_Module2_profitLossDashboard__15}
  <div class="nl-pl-chart-grid" id="nlSeparateCharts" hidden>
    <section class="nl-pl-mini-chart" data-series="revenue"><h3>Revenue</h3><p>Monthly income</p><div class="nl-pl-mini-frame"><canvas id="nlRevenueGraph" role="img" aria-label="Monthly revenue graph"></canvas></div></section>
    <section class="nl-pl-mini-chart" data-series="cost"><h3>Operating costs</h3><p>Freight, port and handling</p><div class="nl-pl-mini-frame"><canvas id="nlCostGraph" role="img" aria-label="Monthly operating costs graph"></canvas></div></section>
    <section class="nl-pl-mini-chart" data-series="profit"><h3>Net profit</h3><p>Revenue less costs and claims</p><div class="nl-pl-mini-frame"><canvas id="nlProfitGraph" role="img" aria-label="Monthly net profit graph"></canvas></div></section>
  </div>
</section>
<div class="card"><div class="card-head"><div><h2>Monthly summary <span class="pill">${requestScope.nlv_Module2_profitLossDashboard__16} months</span></h2><p class="sub">Same figures as the chart, ready for evaluation.</p></div><span class="pill good">FR2.9</span></div>
${requestScope.nlv_Module2_profitLossDashboard__17}</div>
<section class="card"><div class="card-head"><div><h2>Shipment-wise P&amp;L <span class="pill">${requestScope.nlv_Module2_profitLossDashboard__18} records</span></h2><p class="sub">Cost breakdown and settlement-adjusted profit for each shipment and month.</p></div><span class="pill">Date-range filtered</span></div>
${requestScope.nlv_Module2_profitLossDashboard__19}</section>

<script>
(function(){'use strict';
 function ready(){
  var table=document.getElementById('profitTable');if(!table)return;
  var tbody=table.tBodies[0],container=table.closest('.table-wrap');if(!tbody||!container)return;
  var controls=document.createElement('div');controls.className='nl-pl-toolbar';controls.setAttribute('aria-label','Shipment P and L table display controls');
  var searchGroup=document.createElement('label');searchGroup.className='nl-pl-control';
  var searchText=document.createElement('span');searchText.textContent='Find shipment or month';
  var input=document.createElement('input');input.type='search';input.placeholder='Search shipment number, month or amount';input.setAttribute('aria-label','Search loaded shipment P and L rows');
  searchGroup.append(searchText,input);
  var rowsGroup=document.createElement('label');rowsGroup.className='nl-pl-control';
  var rowsText=document.createElement('span');rowsText.textContent='Rows per page';
  var limit=document.createElement('select');limit.setAttribute('aria-label','Shipment P and L rows per page');
  [['10','10'],['25','25'],['50','50'],['all','All']].forEach(function(t){var o=document.createElement('option');o.value=t[0];o.textContent=t[1];limit.appendChild(o);});
  rowsGroup.append(rowsText,limit);
  var count=document.createElement('span');count.className='nl-pl-count';count.setAttribute('aria-live','polite');
  controls.append(searchGroup,rowsGroup,count);container.parentElement.insertBefore(controls,container);
  var pager=document.createElement('div');pager.className='nl-pl-pages';var summary=document.createElement('span'),actions=document.createElement('div');actions.className='table-buttons';
  var prev=document.createElement('button'),next=document.createElement('button');prev.type=next.type='button';prev.textContent='Previous';next.textContent='Next';var position=document.createElement('span');position.style.cssText='display:inline-block;padding:7px 10px;font-weight:760';actions.append(prev,position,next);pager.append(summary,actions);container.insertAdjacentElement('afterend',pager);
  var page=1;
  function paint(){
    var rows=Array.from(tbody.rows),term=input.value.trim().toLowerCase(),found=rows.filter(r=>r.textContent.toLowerCase().includes(term)),size=limit.value==='all'?Math.max(1,found.length):Number(limit.value),pages=Math.max(1,Math.ceil(found.length/size));
    page=Math.min(Math.max(1,page),pages);var subset=new Set(found.slice((page-1)*size,page*size));
    rows.forEach(r=>{r.hidden=!subset.has(r);var raw=r.cells[r.cells.length-1]?.textContent||'';var num=Number(raw.replace(/[^0-9.-]/g,''));r.classList.toggle('nl-pl-negative',Number.isFinite(num)&&num<0);r.classList.toggle('nl-pl-positive',Number.isFinite(num)&&num>0);});
    var from=found.length?(page-1)*size+1:0,to=Math.min(page*size,found.length);
    count.textContent=found.length+' of '+rows.length+' records';summary.textContent='Showing '+from+'-'+to+' of '+found.length+' matching records';position.textContent='Page '+page+' / '+pages;prev.disabled=page<=1;next.disabled=page>=pages;
  }
  input.addEventListener('input',()=>{page=1;paint();});limit.addEventListener('change',()=>{page=1;paint();});
  prev.addEventListener('click',()=>{page--;paint();});next.addEventListener('click',()=>{page++;paint();});
  // Existing column-sort handlers run before this zero-delay view refresh.
  table.querySelectorAll('[data-table-sort]').forEach(th=>th.addEventListener('click',()=>setTimeout(paint,0)));
  paint();
 }
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',ready);else ready();
})();
</script>

${requestScope.nlv_Module2_profitLossDashboard__20}
${requestScope.nlv_Module2_profitLossDashboard__21}
<div class="hint">CSV files can include headings, metadata, totals and spreadsheet-ready currency values. CSV itself cannot store fonts, borders, merged cells or background colors. The export uses an Excel-friendly UTF-8 BOM and CRLF line endings.</div>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.8/dist/chart.umd.min.js" defer></script>
<script>
/* v20.37: multi-graph P&L, using the existing DB-derived monthly values. */
window.addEventListener('load', function () {
  'use strict';
  var host = document.getElementById('monthlyData');
  var mainCanvas = document.getElementById('monthlyChart');
  var grid = document.getElementById('nlSeparateCharts');
  var layout = document.getElementById('nlChartLayout');
  var style = document.getElementById('nlChartStyle');
  var save = document.getElementById('nlSaveFinancialChart');
  var status = document.getElementById('chartStatus');
  if (!host || !mainCanvas || !grid || !layout || !style) {
    [layout, style, save].forEach(function (element) { if (element) element.disabled = true; });
    return;
  }
  var spans = Array.from(host.querySelectorAll('span'));
  var labels = spans.map(function (row) { return row.dataset.label; });
  var specs = [
    {key:'revenue', label:'Revenue', color:'#d95e0d', id:'showRevenue', canvas:'nlRevenueGraph'},
    {key:'cost', label:'Operating costs', color:'#bd8540', id:'showCost', canvas:'nlCostGraph'},
    {key:'profit', label:'Net profit', color:'#4c8461', id:'showProfit', canvas:'nlProfitGraph'}
  ];
  var chartInstances = [];
  function values(key) { return spans.map(function (row) { var num=Number(row.dataset[key]); return Number.isFinite(num)?num:0; }); }
  function enabled(spec) { var checkbox=document.getElementById(spec.id); return checkbox && checkbox.checked; }
  function isDark() { return document.documentElement.getAttribute('data-nl-mode') === 'dark'; }
  function isReducedMotion() { return window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches; }
  function money(n) { return '₹'+Number(n).toLocaleString('en-IN',{minimumFractionDigits:2,maximumFractionDigits:2}); }
  function chartType(spec) { return style.value==='combo' ? (spec.key==='profit'?'line':'bar') : (style.value==='bar'?'bar':'line'); }
  function dataset(spec) {
    var area = style.value==='area' || (style.value==='combo' && spec.key==='profit');
    return {label:spec.label,type:chartType(spec),data:values(spec.key),borderColor:spec.color,
      backgroundColor:chartType(spec)==='bar'?spec.color:spec.color+'28',fill:area?'origin':false,
      tension:.3,borderWidth:style.value==='bar'?1:2.6,pointRadius:style.value==='bar'?0:3,
      pointHoverRadius:5,maxBarThickness:42,borderRadius:chartType(spec)==='bar'?5:0};
  }
  function options(separate) {
    var dark=isDark(),tick=dark?'#d6e2f0':'#665449',line=dark?'#465d71':'#eee0d3';
    return {responsive:true,maintainAspectRatio:false,animation:{duration:isReducedMotion()?0:350},
      interaction:{mode:'index',intersect:false},plugins:{legend:{display:!separate,position:'bottom',labels:{color:tick,boxWidth:12,padding:16}},
      tooltip:{callbacks:{label:function(ctx){return ctx.dataset.label+': '+money(ctx.parsed.y);}}}},
      scales:{y:{ticks:{color:tick,callback:function(n){return '₹'+Number(n).toLocaleString('en-IN');}},grid:{color:line}},
        x:{ticks:{color:tick,maxRotation:0,autoSkip:true,maxTicksLimit:7},grid:{display:false}}}};
  }
  function drawNative(canvas,items,compact) {
    /* Same graph choices remain functional when Chart.js cannot be loaded. */
    var w=Math.max(240,canvas.clientWidth||480),h=Math.max(210,canvas.clientHeight||260);
    var dpr=Math.min(window.devicePixelRatio||1,2);
    canvas.width=Math.round(w*dpr);canvas.height=Math.round(h*dpr);
    var g=canvas.getContext('2d');if(!g)return;
    g.setTransform(dpr,0,0,dpr,0,0);g.clearRect(0,0,w,h);
    var left=69,right=compact?13:22,top=15,bottom=compact?39:47,pw=w-left-right,ph=h-top-bottom;
    var sets=items.map(function(item){return values(item.key);});
    var flat=[0];sets.forEach(function(s){flat=flat.concat(s);});
    var lo=Math.min.apply(null,flat),hi=Math.max.apply(null,flat);
    if(hi===lo)hi=lo+1;
    var dark=isDark(),tick=dark?'#cfdeed':'#816857',line=dark?'#465c70':'#eee1d6';
    var yFor=function(v){return top+(hi-v)*ph/(hi-lo);};
    g.font='11px Segoe UI, Arial';g.textAlign='right';g.textBaseline='middle';
    for(var t=0;t<=4;t++){var v=hi-(hi-lo)*t/4,y=yFor(v);g.strokeStyle=line;g.beginPath();g.moveTo(left,y);g.lineTo(w-right,y);g.stroke();g.fillStyle=tick;g.fillText('₹'+Math.round(v).toLocaleString('en-IN'),left-8,y);}
    var count=Math.max(1,labels.length),step=pw/count,zero=yFor(0),xAt=function(i){return left+step*(i+.5);};
    g.textAlign='center';g.textBaseline='alphabetic';g.fillStyle=tick;
    var skip=Math.max(1,Math.ceil(count/Math.max(2,Math.floor(pw/78))));
    labels.forEach(function(txt,i){if(i%skip===0)g.fillText(txt,xAt(i),h-14);});
    items.forEach(function(item,di){
      var nums=sets[di],variant=chartType(item),area=style.value==='area'||(style.value==='combo'&&item.key==='profit');
      if(variant==='bar'){
        var slot=Math.min(56,step*.82),bw=slot/items.length;
        nums.forEach(function(v,i){g.fillStyle=item.color;var x=xAt(i)-slot/2+bw*di+1,y=yFor(v);
          g.fillRect(x,Math.min(y,zero),Math.max(2,bw-2),Math.max(1,Math.abs(y-zero)));});
      }else{
        if(area&&nums.length){g.beginPath();g.moveTo(xAt(0),zero);nums.forEach(function(v,i){g.lineTo(xAt(i),yFor(v));});g.lineTo(xAt(nums.length-1),zero);g.closePath();g.globalAlpha=.16;g.fillStyle=item.color;g.fill();g.globalAlpha=1;}
        g.beginPath();g.strokeStyle=item.color;g.lineWidth=2.5;
        nums.forEach(function(v,i){if(i===0)g.moveTo(xAt(i),yFor(v));else g.lineTo(xAt(i),yFor(v));});g.stroke();
        nums.forEach(function(v,i){g.beginPath();g.arc(xAt(i),yFor(v),2.6,0,Math.PI*2);g.fillStyle=item.color;g.fill();});
      }
    });
    if(!compact&&items.length>1){g.font='11px Segoe UI, Arial';var width=items.length*115,base=Math.max(8,(w-width)/2);items.forEach(function(item,i){g.fillStyle=item.color;g.fillRect(base+115*i,h-9,8,7);g.fillStyle=tick;g.textAlign='left';g.fillText(item.label,base+115*i+11,h-3);});}
  }
  function buildChart(canvas,items,separate) {
    if(typeof Chart==='undefined'){drawNative(canvas,items,separate);return;}
    chartInstances.push(new Chart(canvas,{type:'line',data:{labels:labels,datasets:items.map(dataset)},options:options(separate)}));
  }
  function render() {
    chartInstances.forEach(function(ch){ch.destroy();});chartInstances=[];
    var separate=layout.value==='separate',active=specs.filter(enabled);
    grid.hidden=!separate;
    mainCanvas.parentElement.hidden=separate;
    grid.querySelectorAll('.nl-pl-mini-chart').forEach(function(card){
      var key=card.getAttribute('data-series');card.hidden=!active.some(function(s){return s.key===key;});
    });
    if(!active.length){if(status)status.textContent='Select at least one series to display a graph.';return;}
    if(separate){active.forEach(function(spec){buildChart(document.getElementById(spec.canvas),[spec],true);});}
    else{buildChart(mainCanvas,active,false);}
    if(status){
      if(separate)grid.insertAdjacentElement('afterend',status);
      else mainCanvas.parentElement.insertAdjacentElement('afterend',status);
      status.textContent=separate?'Three independent graphs based on the same monthly data. Toggle a series to show or hide its graph.':'Combined comparison of the selected monthly series. Change the graph view or chart style without reloading.';
    }
  }
  [layout,style].concat(specs.map(function(spec){return document.getElementById(spec.id);})).forEach(function(el){
    if(el)el.addEventListener('change',render);
  });
  if(save)save.addEventListener('click',function(){
    if(typeof Chart!=='undefined')chartInstances.forEach(function(ch){ch.update('none');});
    var separate=layout.value==='separate';
    var visible=separate?specs.filter(enabled).map(function(spec){return {canvas:document.getElementById(spec.canvas),title:spec.label};}):[{canvas:mainCanvas,title:'Monthly performance trend'}];
    if(!visible.length)return;
    var w=1250,cellH=350,head=54,out=document.createElement('canvas');out.width=w;out.height=visible.length*cellH+30;
    var ctx=out.getContext('2d');if(!ctx)return;
    ctx.fillStyle=isDark()?'#203044':'#fffaf5';ctx.fillRect(0,0,out.width,out.height);
    visible.forEach(function(item,i){
      var y=i*cellH;ctx.fillStyle=isDark()?'#f4f7fc':'#36251e';ctx.font='bold 25px Segoe UI, Arial';ctx.fillText(item.title,32,y+35);
      if(item.canvas.width&&item.canvas.height)ctx.drawImage(item.canvas,24,y+head,w-48,cellH-head-16);
    });
    var link=document.createElement('a');link.download='N-LOGISTIC_Monthly_Profit_Loss_'+(separate?'Three_Graphs':'Combined')+'.png';
    link.href=out.toDataURL('image/png');document.body.appendChild(link);link.click();link.remove();
  });
  if(typeof Chart==='undefined'){
    var pending=0;window.addEventListener('resize',function(){cancelAnimationFrame(pending);pending=requestAnimationFrame(render);});
  }
  if(typeof MutationObserver!=='undefined'){
    new MutationObserver(function(mutations){if(mutations.some(function(m){return m.attributeName==='data-nl-mode';}))render();})
      .observe(document.documentElement,{attributes:true,attributeFilter:['data-nl-mode']});
  }
  render();
});
</script>
<%@ include file="../shared/_end.jsp" %>
</div></main></div></body></html>