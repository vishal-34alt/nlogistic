<jsp:useBean id="nlViewSupport_Module1_profile" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_profile" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_profile" property="view" value="Module1/profile.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,java.math.*,model.*" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>My profile | N-LOGISTIC</title><style>
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

/* Refined account workspace. Role-aware layout without external CSS. */
.profile-hero{position:relative;overflow:hidden;isolation:isolate;display:flex;align-items:center;gap:22px;flex-wrap:wrap;background:linear-gradient(115deg,#412419 0%,#7c310e 67%,#d36316 100%);border:1px solid #ad622c;color:#fff;border-radius:24px;padding:clamp(22px,3.2vw,37px);margin-bottom:17px;box-shadow:0 18px 40px #8a471a20;animation:nlPageEnter .45s ease both}
.profile-hero::after{content:"";position:absolute;z-index:-1;inset:-100px -20px -40px 35%;pointer-events:none;background:repeating-radial-gradient(circle at 100% 100%,transparent 0 37px,#ffcf9220 38px 39px,transparent 40px 58px)}
.profile-avatar{width:90px;height:90px;flex:none;border:2px solid #ffd29d;border-radius:23px;background:#ffffff1c;color:#ffe4bd;display:grid;place-items:center;font-weight:900;font-size:2.1rem;box-shadow:inset 0 0 30px #ffffff0f}
.profile-identity{flex:1;min-width:190px}.profile-identity h2{font-size:clamp(1.6rem,2.5vw,2.2rem);margin:5px 0 6px;overflow-wrap:anywhere}.profile-identity p{margin:0;color:#ffebdc;max-width:650px}.profile-hero .caps{color:#ffd1a2}
.profile-badges{display:flex;gap:8px;flex-wrap:wrap;margin-top:14px}.profile-badges span{padding:4px 10px;border-radius:20px;background:#ffffff20;border:1px solid #ffffff50;color:white;font-size:.75rem;font-weight:800}
.profile-hero-actions{display:flex;gap:9px;flex-wrap:wrap;align-items:center}.profile-hero-actions .btn{background:#ffefd9;border-color:#ffe0b6;color:#7e3412}.profile-hero-actions .btn:hover{background:white}
.profile-overview{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:14px;margin-bottom:17px}.profile-fact{padding:18px 19px;border:1px solid #e8d4c1;border-radius:17px;background:#fffdfb;box-shadow:var(--shadow);min-width:0;animation:nlGentleIn .42s ease both}.profile-fact:nth-child(2){animation-delay:.05s}.profile-fact:nth-child(3){animation-delay:.1s}.profile-fact .fact-caption{color:#8b6b56;font-size:.78rem;font-weight:750;margin-bottom:5px}.profile-fact strong{display:block;font-size:1.12rem;letter-spacing:-.015em;overflow-wrap:anywhere}.profile-fact .fact-note{color:#a0806c;font-size:.74rem;margin-top:4px}
.profile-layout{display:grid;grid-template-columns:minmax(0,1.15fr) minmax(300px,.85fr);gap:17px;align-items:start}.profile-layout>.card,.profile-side>.card{margin-bottom:0}.profile-side{display:grid;gap:17px;min-width:0}.profile-section-intro{margin-top:0;color:#8a705e;font-size:.87rem}.profile-form{padding:17px 0;border-bottom:1px solid #f0dfd0}.profile-form:last-child{border-bottom:0;padding-bottom:2px}.profile-form:first-child{padding-top:4px}.profile-form-row{display:flex;gap:12px;align-items:center;justify-content:space-between;margin-top:11px;flex-wrap:wrap}.profile-field-help{font-size:.77rem;color:#987e6a}.profile-form-controls{display:flex;gap:9px;align-items:center;flex-wrap:wrap}.profile-form .btn:disabled{opacity:.46;box-shadow:none;transform:none}.profile-form .field .input{min-height:46px}
.profile-note{display:flex;gap:11px;align-items:flex-start;padding:13px 14px;border-radius:13px;background:#fff1e4;border:1px solid #efd8c0;color:#7d5337;font-size:.83rem}.profile-note strong{display:block;color:#663317;margin-bottom:2px}.profile-note .profile-note-icon{flex:none;font-size:1.1rem}
.profile-security-toggle{list-style:none;display:flex;justify-content:space-between;gap:12px;align-items:center;cursor:pointer;font-weight:850;font-size:.94rem;min-height:45px}.profile-security-toggle::-webkit-details-marker{display:none}.profile-security-toggle span{font-size:.76rem;font-weight:700;color:#984913}.profile-security-toggle:hover{color:#b74808}.profile-security[open] .profile-security-toggle{padding-bottom:10px}.profile-security[open] .profile-security-content{animation:nlGentleIn .24s ease both}
.profile-security-content{display:grid;gap:14px;margin-top:10px}.profile-password-field{position:relative;min-width:0}.profile-password-field .input{padding-right:80px}.profile-peek{position:absolute;right:6px;top:5px;min-height:34px;border:0;border-radius:8px;padding:5px 10px;background:#fff1e2;color:#8d4217;font-size:.77rem;font-weight:850}.profile-peek:hover{background:#fbe1ca}.profile-strength{height:6px;border-radius:999px;background:#edddcd;overflow:hidden;margin-top:8px}.profile-strength>span{display:block;height:100%;width:0%;background:#d66821;transition:width .23s ease,background .23s ease}.profile-strength[data-level="good"]>span{background:#3d8b53}.profile-strength[data-level="mid"]>span{background:#cf8a30}.profile-strength-message,.profile-password-match{color:#876b57;font-size:.78rem;margin:4px 0 0}
.profile-permissions{display:grid;gap:0;margin-top:8px}.profile-permissions li{list-style:none;display:flex;gap:9px;align-items:start;padding:11px 0;border-bottom:1px solid #f1e4da;font-size:.85rem}.profile-permissions li:last-child{border-bottom:0}.profile-permissions .perm-icon{flex:none;display:inline-grid;place-items:center;width:23px;height:23px;border-radius:7px;background:#fff0dd;color:#a74817;font-size:.9rem;font-weight:800}.profile-permissions strong{display:block;color:#463126;margin-bottom:1px}.profile-permissions small{color:#896f5c}.profile-links{display:flex;flex-wrap:wrap;gap:8px;margin-top:13px}.profile-links .btn{flex:1;min-width:130px}
.nl-backtop{position:fixed;right:22px;bottom:20px;z-index:60;display:grid;place-items:center;width:42px;height:42px;color:#fff;background:linear-gradient(145deg,#bc4008,#ef7318);border:1px solid #d56822;border-radius:14px;box-shadow:0 10px 24px #8c3c172c;cursor:pointer;opacity:0;pointer-events:none;transform:translateY(10px);transition:opacity .2s,transform .2s}.nl-backtop.is-visible{opacity:1;pointer-events:auto;transform:translateY(0)}.nl-backtop:hover{transform:translateY(-3px)}.nl-skip-link{position:fixed;top:-100px;left:15px;z-index:1000;background:white;color:#773312;border:2px solid #cd5a11;border-radius:10px;padding:11px 15px}.nl-skip-link:focus{top:10px}
@media(max-width:1050px){.profile-layout{grid-template-columns:minmax(0,1fr)}.profile-side{grid-template-columns:repeat(2,minmax(0,1fr))}}
@media(max-width:800px){.profile-side{grid-template-columns:minmax(0,1fr)}}
@media(max-width:650px){.profile-hero{padding:21px 18px;gap:14px}.profile-avatar{width:65px;height:65px;border-radius:16px;font-size:1.65rem}.profile-hero-actions{width:100%}.profile-overview{grid-template-columns:1fr;gap:9px}.profile-fact{padding:13px 16px}.profile-layout{gap:13px}.profile-form-row{align-items:flex-start}.profile-hero-actions .btn{width:100%}.nl-backtop{right:12px;bottom:12px}}
@media(prefers-reduced-motion:reduce){.profile-hero,.profile-fact,.profile-security[open] .profile-security-content{animation:none!important}.nl-backtop,.profile-strength>span{transition:none!important}}


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


.profile-bulk-contact{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:19px 16px;padding-top:7px}
.profile-bulk-contact .field{display:flex;flex-direction:column;gap:7px;min-width:0}
.profile-bulk-contact .field:nth-child(3){grid-column:1 / -1}
.profile-bulk-contact .input{min-height:51px;background:#fffdfb;border-radius:11px}
.profile-bulk-actions{grid-column:1/-1;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;background:#fff4e8;border:1px solid #f0d8c0;border-radius:14px;padding:14px 15px}
#nlProfileDirty{font-size:.79rem;color:#8b624b}
.profile-quicktip{background:#fff7ec;border:1px solid #edcfb4;border-radius:16px;padding:14px 16px;margin-bottom:16px}
@media(max-width:680px){.profile-bulk-contact{grid-template-columns:1fr}.profile-bulk-contact .field:nth-child(3){grid-column:auto}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .profile-fact,html[data-nl-mode="dark"] body.nl-themed-page .profile-panel,html[data-nl-mode="dark"] body.nl-themed-page .profile-note,html[data-nl-mode="dark"] body.nl-themed-page .profile-bulk-actions,html[data-nl-mode="dark"] body.nl-themed-page .profile-security-content,html[data-nl-mode="dark"] body.nl-themed-page .profile-quicktip,html[data-nl-mode="dark"] body.nl-themed-page .profile-overview{background:#203044!important;color:#edf4fc!important;border-color:#536c83!important;box-shadow:none!important}
html[data-nl-mode="dark"] body.nl-themed-page .profile-note,html[data-nl-mode="dark"] body.nl-themed-page .profile-bulk-actions,html[data-nl-mode="dark"] body.nl-themed-page .profile-fact{background:#2b3e52!important}
html[data-nl-mode="dark"] body.nl-themed-page .profile-note :is(span,p,strong),html[data-nl-mode="dark"] body.nl-themed-page .profile-fact :is(strong,.fact-caption,.fact-note),html[data-nl-mode="dark"] body.nl-themed-page .profile-bulk-actions span{color:#dce7f2!important}
html[data-nl-mode="dark"] body.nl-themed-page .profile-security-toggle,html[data-nl-mode="dark"] body.nl-themed-page .profile-security-toggle span{color:#f1f6fd!important}

</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<%@ include file="../shared/_theme.jsp" %>
<style>
/* v19.9 — Focused account header redesign. All styling is isolated to the profile page. */
/* A restrained page heading, instead of a second navigation strip. */
body[data-nl-screen="module1-profile"] .profile-page-heading{
 display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;
 gap:8px 18px;margin:6px 0 15px;padding:0 1px;
}
body[data-nl-screen="module1-profile"] .profile-page-heading .caps{
 color:#ae4b15!important;font-size:.72rem!important;
}
body[data-nl-screen="module1-profile"] .profile-page-meta{
 color:#766558!important;font-size:.8rem!important;font-weight:600!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] .profile-page-heading .caps{color:#ffac73!important}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] .profile-page-meta{color:#c1d0df!important}

body[data-nl-screen="module1-profile"] #profileHero.nl-account-hero{
  display:block!important;position:relative!important;isolation:isolate;overflow:hidden!important;
  padding:0!important;margin:0 0 18px!important;min-height:0!important;
  color:#352922!important;background:#fffdf9!important;background-image:none!important;
  border:1px solid #e9d7c7!important;border-top:4px solid #d75a11!important;
  border-radius:17px!important;box-shadow:0 9px 28px rgba(76,42,25,.075)!important;
}
body[data-nl-screen="module1-profile"] #profileHero::before,
body[data-nl-screen="module1-profile"] #profileHero::after{display:none!important;content:none!important}
body[data-nl-screen="module1-profile"] #profileHero .nl-scene-art{display:none!important}
body[data-nl-screen="module1-profile"] #profileHero .nl-account-top{
  display:flex;align-items:center;gap:18px;padding:24px clamp(20px,2.5vw,32px) 23px;min-width:0;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-avatar{
  display:grid;place-items:center;flex:none;width:68px!important;height:68px!important;
  border:1px solid #f2c7a3!important;border-radius:17px!important;
  font-size:1.75rem!important;font-weight:850!important;line-height:1!important;
  color:#ab4715!important;background:#ffeedf!important;box-shadow:none!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-identity{flex:1 1 auto;min-width:0!important}
body[data-nl-screen="module1-profile"] #profileHero .profile-identity .caps{
  display:block;color:#ad511a!important;letter-spacing:.12em!important;font-size:.68rem!important;margin:0 0 5px!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-identity h2{
  font-size:clamp(1.42rem,2.1vw,2rem)!important;letter-spacing:-.032em!important;
  line-height:1.17!important;color:#302720!important;margin:0 0 9px!important;font-weight:850!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-identity p{
  font-size:.86rem!important;line-height:1.55!important;margin:11px 0 0!important;
  max-width:670px;color:#6a594d!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-badges{
  display:flex;gap:7px;flex-wrap:wrap;align-items:center;margin:0!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-badges span{
  background:#fff2e6!important;color:#91471b!important;border:1px solid #f0d5be!important;
  border-radius:999px!important;padding:4px 10px!important;
  font-size:.7rem!important;font-weight:750!important;white-space:normal;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-badges .nl-account-status{
  display:inline-flex;align-items:center;gap:6px;background:#eaf6ed!important;
  border-color:#cfe8d4!important;color:#24683b!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-badges span.nl-account-status-dot{
  display:inline-block!important;flex:none;width:7px;height:7px;border-radius:50%;
  padding:0!important;min-height:0!important;min-width:0!important;border:0!important;background:#2a9b56!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-hero-actions{
  display:flex;flex:none;margin-left:auto;align-self:center;width:auto!important;min-width:0;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-hero-actions .btn{
  display:inline-flex;align-items:center;justify-content:center;gap:10px;white-space:nowrap;
  background:linear-gradient(110deg,#bb430c,#e56a15)!important;color:#fff!important;
  border:1px solid #c95312!important;border-radius:11px!important;
  min-height:43px;padding:10px 17px;box-shadow:0 4px 12px rgba(178,74,19,.17)!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-overview{
  display:grid!important;grid-template-columns:repeat(3,minmax(0,1fr))!important;
  gap:0!important;margin:0!important;padding:16px clamp(18px,2.5vw,30px)!important;
  border:0!important;border-top:1px solid #eadbce!important;
  background:#fbf7f2!important;background-image:none!important;box-shadow:none!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact{
  display:block;min-width:0;margin:0!important;padding:4px 20px!important;
  border:0!important;border-left:1px solid #e9d8c9!important;border-radius:0!important;
  background:transparent!important;background-image:none!important;
  box-shadow:none!important;animation:none!important;color:#302720!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact:first-child{
  border-left:0!important;padding-left:0!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-fact .fact-caption{
  color:#856951!important;font-size:.66rem!important;letter-spacing:.105em!important;
  font-weight:800!important;margin-bottom:5px!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-fact strong{
  display:block;color:#332a23!important;font-size:1rem!important;
  line-height:1.35!important;font-weight:800!important;
}
body[data-nl-screen="module1-profile"] #profileHero .profile-fact .fact-note{
  color:#806e61!important;font-size:.75rem!important;margin-top:4px!important;line-height:1.4;
}
/* Fully specified dark surfaces and text; never use white text over the light account header. */
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero.nl-account-hero{
  background:#203044!important;color:#f0f5fb!important;
  border-color:#435970!important;border-top-color:#f58a39!important;
  box-shadow:0 10px 28px rgba(0,0,0,.18)!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-avatar{
  background:#35495e!important;color:#ffbf8a!important;border-color:#60758a!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-identity .caps{
  color:#ffaf75!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-identity h2{
  color:#f4f7fd!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-identity p{
  color:#c6d3e1!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-badges span{
  background:#30455b!important;color:#e5edf8!important;border-color:#536b83!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-badges .nl-account-status{
  color:#b5ebc6!important;background:#244436!important;border-color:#416c57!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-overview{
  background:#19283a!important;border-top-color:#42576e!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact{
  border-left-color:#42576e!important;background:transparent!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-fact .fact-caption{
  color:#b8c9d9!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-fact strong{
  color:#f3f7fd!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-fact .fact-note{
  color:#afc1d3!important;
}
/* Keep password disclosure readable in both themes; do not touch form semantics. */
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] .profile-security,
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] .profile-security-toggle{
  background:#2a4055!important;color:#f0f6fd!important;border-color:#536b83!important;
}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] .profile-security-toggle span{color:#ffc49d!important}
html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact{color:#e7f0fa!important}
@media(max-width:980px){
  body[data-nl-screen="module1-profile"] #profileHero .nl-account-top{flex-wrap:wrap;gap:14px}
  body[data-nl-screen="module1-profile"] #profileHero .profile-hero-actions{margin-left:86px}
}
@media(max-width:660px){
  body[data-nl-screen="module1-profile"] #profileHero .nl-account-top{align-items:flex-start;padding:19px 17px}
  body[data-nl-screen="module1-profile"] #profileHero .profile-avatar{width:52px!important;height:52px!important;border-radius:13px!important;font-size:1.4rem!important}
  body[data-nl-screen="module1-profile"] #profileHero .profile-identity{flex:1 1 calc(100% - 72px)}
  body[data-nl-screen="module1-profile"] #profileHero .profile-hero-actions{margin:1px 0 0;width:100%!important}
  body[data-nl-screen="module1-profile"] #profileHero .profile-hero-actions .btn{width:100%!important}
  body[data-nl-screen="module1-profile"] #profileHero .profile-overview{grid-template-columns:1fr!important;padding:7px 17px!important}
  body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact,
  body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact:first-child{
    padding:12px 0!important;border:0!important;border-top:1px solid #e9d8c9!important;
  }
  body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact:first-child{border-top:0!important}
  html[data-nl-mode="dark"] body[data-nl-screen="module1-profile"] #profileHero .profile-overview .profile-fact{border-top-color:#42576e!important}
}
@media(prefers-reduced-motion:reduce){body[data-nl-screen="module1-profile"] #profileHero *{animation:none!important;transition:none!important}}
</style>
</head><body data-nl-screen="module1-profile" class="nl-themed-page nl-universal-module2" data-nl-enhanced="true"><jsp:include page="/WEB-INF/views/shared/_nav.jsp"/>
<div class="app-shell">
<jsp:include page="/WEB-INF/views/shared/_sidebar.jsp" />
<main class="main-area" id="mainContent"><div class="content-wrap">


<div class="bread"><a href="${requestScope.nlv_Module1_profile__1}/containerMovement?action=shipments">Workspace</a><span>/</span><b>My profile</b></div>
<div class="profile-page-heading"><span class="caps">MY ACCOUNT</span><span class="profile-page-meta">Personal details · Security · Workspace access</span></div>
${requestScope.nlv_Module1_profile__2}
${requestScope.nlv_Module1_profile__3}
<section class="profile-hero nl-profile-panel-outline nl-account-hero" id="profileHero" aria-labelledby="accountOverviewTitle">
  <div class="nl-account-top">
    <div class="profile-avatar" aria-hidden="true">${requestScope.nlv_Module1_profile__4}</div>
    <div class="profile-identity">
      <div class="caps">ACCOUNT OVERVIEW</div>
      <h2 id="accountOverviewTitle">${requestScope.nlv_Module1_profile__5}</h2>
      <div class="profile-badges" aria-label="Account role and status">
        <span>${requestScope.nlv_Module1_profile__6}</span>
        <span class="nl-account-status"><span class="nl-account-status-dot" aria-hidden="true"></span>${requestScope.nlv_Module1_profile__7}</span>
      </div>
      <p>Manage your contact details, sign-in security and workspace access in one place.</p>
    </div>
    <div class="profile-hero-actions"><a class="btn primary" href="${requestScope.nlv_Module1_profile__8}/containerMovement?action=shipments">View shipments <span aria-hidden="true">&rarr;</span></a></div>
  </div>
  <div class="profile-overview" aria-label="Account information at a glance">
    <article class="profile-fact"><div class="fact-caption">ACCOUNT ROLE</div><strong>${requestScope.nlv_Module1_profile__9}</strong><div class="fact-note">Permissions assigned by your administrator</div></article>
    <article class="profile-fact"><div class="fact-caption">ORGANIZATION</div><strong>${requestScope.nlv_Module1_profile__10}</strong><div class="fact-note">${requestScope.nlv_Module1_profile__11}</div></article>
    <article class="profile-fact"><div class="fact-caption">LAST SIGN-IN</div><strong>${requestScope.nlv_Module1_profile__12}</strong><div class="fact-note">Most recent successful sign-in</div></article>
  </div>
</section>
<div class="profile-layout">
  <section class="card profile-panel nl-profile-panel-outline" aria-labelledby="profilePersonalHeading">
    <div class="card-head"><div><div class="caps">PERSONAL DETAILS</div><h2 id="profilePersonalHeading">Contact information</h2><p class="profile-section-intro">Update your name, email and phone together with one save.</p></div><span class="pill good">Editable</span></div>
    <form class="profile-bulk-contact" id="nlProfileBulk" method="post" action="${requestScope.nlv_Module1_profile__13}/Module1Controller">
      <input type="hidden" name="action" value="saveProfile"/><input type="hidden" name="editMode" value="all"/><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_profile__14}"/>
      <div class="field"><label for="profileFullName">Full name</label><input class="input" id="profileFullName" name="fullName" value="${requestScope.nlv_Module1_profile__15}" maxlength="100" autocomplete="name" required="required"/><small class="profile-field-help">Appears on your account and in the workspace.</small></div>
      <div class="field"><label for="profileEmail">Email address</label><input class="input" type="email" id="profileEmail" name="email" value="${requestScope.nlv_Module1_profile__16}" maxlength="120" autocomplete="email" required="required"/><small class="profile-field-help">Used for signing in. Make sure you can access this inbox.</small></div>
      <div class="field"><label for="profilePhone">Phone number <span class="muted">(optional)</span></label><input class="input" id="profilePhone" name="phone" type="tel" maxlength="20" value="${requestScope.nlv_Module1_profile__17}" autocomplete="tel" placeholder="Add a phone number"/><small class="profile-field-help">Only used as contact information.</small></div>
      <div class="profile-bulk-actions"><span id="nlProfileDirty" role="status" aria-live="polite">Your details are up to date.</span><div class="profile-form-controls"><button class="btn ghost small" id="nlProfileUndo" type="reset" hidden="hidden">Undo changes</button><button class="btn primary" type="submit" id="nlProfileSave" disabled="disabled">Save all changes</button></div></div>
    </form>
    <div class="profile-note"><span class="profile-note-icon" aria-hidden="true">ⓘ</span><span><strong>About your permissions</strong>Role and organization assignments cannot be edited from this screen. All profile updates continue through the existing authenticated controller.</span></div>
  </section>
  <div class="profile-side">
    <section class="card nl-profile-panel-outline" aria-labelledby="profileSecurityHeading"><div class="caps">ACCOUNT PROTECTION</div><h2 id="profileSecurityHeading">Sign-in security</h2><p class="profile-section-intro">Keep your password private. A successful change will sign you out so you can log in again.</p>
      <details class="profile-security" id="passwordDisclosure"><summary class="profile-security-toggle">Change password <span>Open secure form ▾</span></summary><div class="profile-security-content">
        <form method="post" id="passwordChangeForm" action="${requestScope.nlv_Module1_profile__18}/Module1Controller" class="profile-security-content">
          <input type="hidden" name="action" value="changePassword"/><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_profile__19}"/>
          <div class="field"><label for="old">Current password</label><div class="profile-password-field"><input class="input" id="old" type="password" name="currentPassword" autocomplete="current-password" required="required"/><button type="button" class="profile-peek" data-peek="old" aria-label="Show current password">Show</button></div></div>
          <div class="field"><label for="new">New password</label><div class="profile-password-field"><input class="input" id="new" type="password" name="newPassword" autocomplete="new-password" maxlength="255" required="required"/><button type="button" class="profile-peek" data-peek="new" aria-label="Show new password">Show</button></div><div class="profile-strength" id="passwordStrength" data-level="weak" aria-hidden="true"><span></span></div><p class="profile-strength-message" id="passwordStrengthText" aria-live="polite">Use at least 8 characters.</p></div>
          <div class="field"><label for="confirm">Confirm new password</label><div class="profile-password-field"><input class="input" id="confirm" type="password" name="confirmPassword" autocomplete="new-password" maxlength="255" required="required"/><button type="button" class="profile-peek" data-peek="confirm" aria-label="Show confirmation password">Show</button></div><p class="profile-password-match" id="passwordMatch" aria-live="polite">Re-enter your new password.</p></div>
          <button class="btn primary" type="submit">Update password securely</button>
        </form>
      </div></details>
    </section>
    <section class="card nl-profile-panel-outline" aria-labelledby="profileAccessHeading"><div class="caps">WORKSPACE ACCESS</div><h2 id="profileAccessHeading">${requestScope.nlv_Module1_profile__20}</h2><p class="profile-section-intro">${requestScope.nlv_Module1_profile__21}</p>
      <ul class="profile-permissions" style="margin:0;padding:0">
        <li><span class="perm-icon" aria-hidden="true">✓</span><span><strong>Shipment list &amp; timelines</strong><small>${requestScope.nlv_Module1_profile__22}</small></span></li>
        <jsp:setProperty name="nlViewSupport_Module1_profile" property="fragment" value="nlv_Module1_profile__23" /><jsp:getProperty name="nlViewSupport_Module1_profile" property="fragment" />
        <jsp:setProperty name="nlViewSupport_Module1_profile" property="fragment" value="nlv_Module1_profile__24" /><jsp:getProperty name="nlViewSupport_Module1_profile" property="fragment" />
      </ul><div class="profile-links"><a class="btn light" href="${requestScope.nlv_Module1_profile__25}/containerMovement?action=movements">Movement history</a>${requestScope.nlv_Module1_profile__26}</div>
    </section>
  </div>
</div>
<script>
(function(){'use strict';
 var contact=document.getElementById('nlProfileBulk');
 if(contact){var contactInputs=Array.from(contact.querySelectorAll('input:not([type=hidden])'));
   var originals=contactInputs.map(function(el){return el.value;});
   var save=document.getElementById('nlProfileSave'),undo=document.getElementById('nlProfileUndo'),dirty=document.getElementById('nlProfileDirty');
   function refreshContact(){var changed=contactInputs.some(function(el,i){return el.value!==originals[i];});
     save.disabled=!changed;undo.hidden=!changed;dirty.textContent=changed?'Unsaved changes — review and save all together.':'Your details are up to date.';}
   contactInputs.forEach(function(el){el.addEventListener('input',refreshContact);});
   contact.addEventListener('reset',function(){setTimeout(refreshContact,0);});
   contact.addEventListener('submit',function(e){if(save.disabled||!contact.reportValidity())e.preventDefault();});refreshContact();
 }
 document.querySelectorAll('[data-peek]').forEach(function(button){button.addEventListener('click',function(){var field=document.getElementById(button.dataset.peek);if(!field)return;var reveal=field.type==='password';field.type=reveal?'text':'password';button.textContent=reveal?'Hide':'Show';button.setAttribute('aria-label',(reveal?'Hide ':'Show ')+field.getAttribute('name')+' password');});});
 var form=document.getElementById('passwordChangeForm');if(!form)return;
 var password=form.querySelector('[name="newPassword"]'),confirm=form.querySelector('[name="confirmPassword"]'),meter=document.getElementById('passwordStrength'),strengthLabel=document.getElementById('passwordStrengthText'),match=document.getElementById('passwordMatch');
 function strength(){var val=password.value,points=(val.length>=8?1:0)+(val.length>=12?1:0)+(/[a-z]/.test(val)&&/[A-Z]/.test(val)?1:0)+(/\d/.test(val)?1:0)+(/[^A-Za-z0-9]/.test(val)?1:0);var pct=Math.min(100,points*20);meter.querySelector('span').style.width=pct+'%';meter.dataset.level=points>=4?'good':points>=2?'mid':'weak';strengthLabel.textContent=val.length===0?'Use at least 8 characters.':points>=4?'Strong password':points>=2?'Consider adding upper/lowercase letters, numbers and symbols.':'Choose a longer, harder-to-guess password.';match.textContent=confirm.value?(confirm.value===val?'Passwords match.':'Passwords do not match yet.'):'Re-enter your new password.';}
 password.addEventListener('input',function(){password.setCustomValidity('');strength();});confirm.addEventListener('input',function(){confirm.setCustomValidity('');strength();});
 form.addEventListener('submit',function(e){password.setCustomValidity('');confirm.setCustomValidity('');if(password.value.length<8)password.setCustomValidity('Use at least 8 characters.');else if(password.value!==confirm.value)confirm.setCustomValidity('Passwords must match.');if(!form.reportValidity())e.preventDefault();});strength();
})();
</script>
<%@ include file="../shared/_end.jsp" %>
</div></main></div></body></html>