<jsp:useBean id="nlViewSupport_Module2_movementTracking" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module2_movementTracking" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module2_movementTracking" property="view" value="Module2/movementTracking.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,java.time.*,java.math.*,model.*" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Movement tracking | N-LOGISTIC</title><style>
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

/* v16.7 compact movement hero */
.page-hero{position:relative;display:grid;grid-template-columns:minmax(0,1.45fr) minmax(230px,.7fr);gap:18px;align-items:center;padding:22px 24px;border:1px solid #ecd3bf;border-radius:24px;background:linear-gradient(126deg,#fffdfa,#fff1e1 72%,#ffe5cb);box-shadow:0 16px 34px rgba(87,53,23,.07);overflow:hidden}
.page-hero:after{content:"";position:absolute;right:-82px;top:-86px;width:245px;height:245px;border-radius:50%;border:1px solid rgba(212,91,23,.13);box-shadow:0 0 0 26px rgba(212,91,23,.05),0 0 0 56px rgba(212,91,23,.025)}
.page-hero .hero-copy,.page-hero .hero-actions,.page-hero .hero-art{position:relative;z-index:1}
.page-hero .hero-copy p{max-width:700px;color:#7a6456;margin:0}
.page-hero .hero-copy h1{margin:.3rem 0 .55rem}
.page-hero .hero-actions{display:flex;flex-wrap:wrap;gap:9px;align-items:center;justify-content:flex-end}
.page-hero .hero-art{display:flex;justify-content:flex-end;align-items:center;min-height:140px}
.page-hero .mv-scene{position:relative;width:300px;height:160px;transform:scale(.96);transform-origin:100% 50%;filter:drop-shadow(0 14px 18px rgba(133,72,36,.13))}
.page-hero .mv-halo{position:absolute;inset:6px 18px 0 54px;border-radius:50%;border:1px solid rgba(205,100,41,.16);background:radial-gradient(circle at 55% 44%,rgba(255,255,255,.85),rgba(255,216,181,.16) 74%,transparent 75%)}
.page-hero .mv-path{position:absolute;left:58px;right:34px;top:76px;height:2px;border-top:3px dashed #d98e54}
.page-hero .mv-node{position:absolute;top:66px;width:22px;height:22px;border-radius:50%;border:3px solid #d36a22;background:#fff9f3;box-shadow:0 0 0 5px #ffe7d2}
.page-hero .mv-node.one{left:60px}.page-hero .mv-node.two{left:136px;animation:mvPulse 3.8s ease-in-out infinite}.page-hero .mv-node.three{left:216px}.page-hero .mv-card{position:absolute;left:24px;top:22px;width:92px;height:60px;border:2px solid #9e5730;border-radius:14px;background:linear-gradient(145deg,#fffef9,#fff0df);box-shadow:8px 10px 0 rgba(152,78,35,.13);transform:rotate(-9deg);animation:mvFloat 5.2s ease-in-out infinite}
.page-hero .mv-card:before,.page-hero .mv-card:after{content:"";position:absolute;left:14px;right:14px;height:6px;border-radius:6px;background:#e6b68d}
.page-hero .mv-card:before{top:16px;box-shadow:0 12px 0 #e6b68d}.page-hero .mv-card:after{top:40px;right:28px}
.page-hero .mv-box{position:absolute;right:18px;bottom:36px;width:66px;height:54px;border:3px solid #9b502b;border-radius:10px;background:repeating-linear-gradient(90deg,#f9ad70 0 9px,#ed9555 9px 17px);box-shadow:5px 8px 0 rgba(121,58,32,.14);animation:mvBox 4.6s ease-in-out infinite}
.page-hero .mv-arrow{position:absolute;left:164px;top:52px;width:52px;height:20px;border-bottom:3px solid #cf621d;border-right:3px solid #cf621d;transform:rotate(-8deg)}
.page-hero .mv-arrow:after{content:"";position:absolute;right:-4px;bottom:-6px;width:12px;height:12px;border-top:3px solid #cf621d;border-right:3px solid #cf621d;transform:rotate(45deg)}
@keyframes mvPulse{0%,100%{transform:scale(1)}50%{transform:scale(1.12)}}
@keyframes mvFloat{0%,100%{transform:translateY(0) rotate(-9deg)}50%{transform:translateY(-5px) rotate(-9deg)}}
@keyframes mvBox{0%,100%{transform:translateY(0)}50%{transform:translateY(-4px)}}
@media(max-width:760px){.page-hero{grid-template-columns:1fr;padding:20px}.page-hero .hero-art{display:none}.page-hero .hero-actions{justify-content:flex-start}}
@media(prefers-reduced-motion:reduce){.page-hero *{animation:none!important}}


/* Animated movement checkpoints — based strictly on the recorded shipment status. */
.journey-panel{margin:20px 0 24px;padding:21px 18px;border-radius:19px;background:linear-gradient(135deg,#fff7ec,#fffdfa);border:1px solid #edddcc}
.journey-head{display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px;margin-bottom:18px}.journey-head h3{margin:2px 0 5px;font-size:1.15rem}.journey-head p{font-size:.8rem;color:#8b7463;margin:0}
.journey-scroll{overflow-x:auto;overscroll-behavior-x:contain;scrollbar-width:thin;scrollbar-color:#edbf99 #fff1e1}
.journey-scroll:focus-visible{outline:2px solid #dd670e;border-radius:9px;outline-offset:2px}
.journey-flow{min-width:700px;position:relative;padding:10px 0 14px}
.journey-rail{position:absolute;z-index:0;top:32px;left:calc(100% / 14);right:calc(100% / 14);height:5px;background:#edd9c8;border-radius:999px;overflow:hidden}
.journey-fill{display:block;height:100%;width:var(--journey-progress,0%);border-radius:inherit;background:linear-gradient(90deg,#b6490d,#f28f2f);box-shadow:0 0 12px #e8792440;animation:journeyFill 1.45s cubic-bezier(.2,.8,.2,1) both}
.journey-steps{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));position:relative;z-index:1;padding:0;margin:0;list-style:none}
.journey-stage{text-align:center;display:flex;align-items:center;flex-direction:column;min-width:0;gap:5px}
.journey-dot{width:44px;height:44px;border:3px solid #e1c7b2;border-radius:50%;display:grid;place-items:center;color:#977961;background:#fffcfa;font-size:.81rem;font-weight:900;box-shadow:0 3px 6px #7040170b;transition:transform .2s ease}
.journey-stage.done .journey-dot{background:linear-gradient(130deg,#ab430f,#f18b24);border-color:#f3a967;color:#fff}
.journey-stage.current .journey-dot{background:linear-gradient(130deg,#af3905,#f08019);border-color:#ffe0af;color:#fff;box-shadow:0 0 0 7px rgba(238,124,24,.14);animation:journeyPulse 2.6s ease-in-out infinite}
.journey-stage-label{font-size:.73rem;font-weight:900;color:#6a4e3e;letter-spacing:.015em;line-height:1.35;padding:0 3px;overflow-wrap:anywhere}
.journey-stage.current .journey-stage-label{color:#b74710}
.journey-stage-caption{font-size:.65rem;color:#ae8e78;line-height:1.25}
.journey-stage.current .journey-stage-caption{font-weight:800;color:#b74710}
.journey-stage.done .journey-stage-caption{color:#777a48}
.journey-cancel-note{display:flex;align-items:start;gap:12px;padding:12px 16px;margin-top:18px;border-radius:12px;background:#fff0e7;border:1px solid #efd5c5;color:#835238;font-size:.82rem;line-height:1.55}
.journey-cancel-note>span{font-size:1.5rem;line-height:1;color:#b85125}
@keyframes journeyFill{from{width:0}to{width:var(--journey-progress,0%)}}
@keyframes journeyPulse{0%,100%{box-shadow:0 0 0 6px rgba(232,115,19,.13);transform:scale(1)}50%{box-shadow:0 0 0 12px rgba(232,115,19,.045);transform:scale(1.045)}}
@media(max-width:650px){.journey-panel{padding:15px 10px}.journey-head{padding:0 7px}.journey-flow{min-width:690px}.journey-stage-label{font-size:.7rem}}
@media(prefers-reduced-motion:reduce){.journey-fill,.journey-stage.current .journey-dot{animation:none!important}}

/* Presentation finish: consistent alignment, keyboard visibility and gentle motion. */
:where(a,button,input,select,textarea,summary):focus-visible{outline:2px solid #e2640b;outline-offset:3px}
.card,.stat,.detail-box,.field,.form-actions,.table-wrap{min-width:0}
.page-heading h1{overflow-wrap:break-word}.card-head>div{min-width:0}
.top-details summary:focus-visible{outline:2px solid #ffbc80;outline-offset:4px}
.form-actions{display:flex;flex-wrap:wrap;align-items:center;gap:9px}
input,select,textarea{max-width:100%}
.data-table :is(td,th){line-height:1.45}
@media(prefers-reduced-motion:reduce){html{scroll-behavior:auto!important}}

/* Confirm a Seller's action inside the app rather than in a browser alert. */
.nl-review-dialog{border:1px solid #f1d7bd;border-radius:22px;background:#fffdf9;color:#36251e;width:min(540px,calc(100vw - 28px));max-height:min(85vh,760px);padding:0;box-shadow:0 30px 90px #2c150c55;overflow:auto;animation:reviewIn .24s ease both}
.nl-review-dialog::backdrop{background:rgba(35,20,15,.59);backdrop-filter:blur(5px)}
.nl-review-head{padding:24px 26px 15px;border-bottom:1px solid #f2e2d3;background:linear-gradient(135deg,#fff1e2,#fffaf5)}
.nl-review-head .caps{display:block;margin-bottom:8px}.nl-review-head h2{margin:0 0 8px;font-size:1.42rem}.nl-review-head p{margin:0;color:#806858;font-size:.88rem}
.nl-review-body{padding:19px 26px}.nl-review-fact{display:flex;gap:18px;justify-content:space-between;align-items:flex-start;padding:11px 0;border-bottom:1px solid #f5e5d7}.nl-review-fact>span{flex:0 0 39%;color:#896c5b;font-size:.85rem}.nl-review-fact>strong{flex:1;min-width:0;text-align:right;overflow-wrap:anywhere;font-size:.93rem}.nl-review-note{margin:17px 0 0;padding:12px 14px;background:#fff5e9;border:1px solid #f4dec9;border-radius:12px;font-size:.86rem;color:#674631;line-height:1.5}
.nl-review-actions{display:flex;justify-content:flex-end;gap:10px;flex-wrap:wrap;padding:17px 26px 22px}.nl-review-actions .btn{min-width:120px}.nl-review-dialog[open] .nl-review-body{animation:reviewIn .3s ease both}
@keyframes reviewIn{from{opacity:0;transform:translateY(16px) scale(.985)}to{opacity:1;transform:translateY(0) scale(1)}}
@media(max-width:520px){.nl-review-head,.nl-review-body{padding-left:17px;padding-right:17px}.nl-review-actions{padding:14px 17px 20px}.nl-review-actions .btn{flex:1}.nl-review-fact>span{flex-basis:42%}}
@media(prefers-reduced-motion:reduce){.nl-review-dialog,.nl-review-dialog[open] .nl-review-body{animation:none!important}.nl-review-dialog::backdrop{backdrop-filter:none}}

/* Grouped movement change log - accessible, collapsible, scroll free on desktop. */
.date-shortcuts{grid-column:1/-1;display:flex;align-items:center;flex-wrap:wrap;gap:8px}.date-shortcuts>span{font-size:.8rem;font-weight:750;color:#7e5d46;margin-right:4px}.date-chip{border:1px solid #efd0b5;background:#fff9f2;color:#894417;border-radius:999px;padding:7px 14px;font-size:.8rem;font-weight:750}.date-chip:hover,.date-chip:focus-visible{background:#ffebd6;border-color:#e96c14}
.movement-viewbar,.group-utility{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:13px;margin-bottom:16px}.movement-viewbar p{margin:4px 0 0}.movement-viewactions{padding:4px;background:#fff2e5;border:1px solid #edd1b6;display:flex;gap:4px;border-radius:13px}.view-switch{padding:10px 13px;border:0;border-radius:10px;background:transparent;color:#78553e;font-weight:750;font-size:.83rem}.view-switch:hover{background:#ffe6cc}.view-switch.is-active{color:#fff;background:linear-gradient(120deg,#b4460b,#e86d15);box-shadow:0 4px 12px #b04c1433}
.movement-groups{display:grid;gap:12px}.movement-group{border:1px solid #efd8c6;border-radius:17px;background:#fffbf7;overflow:hidden;transition:box-shadow .2s ease,border-color .2s ease}.movement-group[open]{border-color:#ecb881;box-shadow:0 10px 20px #a15a2012}.movement-group>summary{display:flex;justify-content:space-between;align-items:center;gap:15px;padding:17px 19px;list-style:none;cursor:pointer;background:#fff7ef}.movement-group>summary::-webkit-details-marker{display:none}.movement-group>summary:hover{background:#ffeddc}.group-identity{display:flex;gap:12px;align-items:center;min-width:0}.group-symbol{width:41px;height:41px;border-radius:12px;display:grid;place-items:center;background:#ffe9d4;color:#a54412;flex-shrink:0}.group-identity strong{display:block;color:#3e281d;font-size:.97rem}.group-identity small{display:block;color:#997765;font-size:.78rem;margin-top:3px}.group-aside{display:flex;gap:12px;align-items:center;justify-content:flex-end;flex-wrap:wrap;min-width:0}.group-chevron{color:#a44a0f;font-size:1.3rem;transition:transform .2s}.movement-group[open] .group-chevron{transform:rotate(180deg)}.group-body{padding:17px 21px 15px;animation:groupReveal .25s ease both}.group-events{display:grid;gap:0}.group-event{display:grid;grid-template-columns:30px minmax(0,1fr);gap:12px;min-width:0}.group-event-step{position:relative;display:flex;justify-content:center}.group-event-step:after{content:"";position:absolute;top:20px;bottom:-3px;width:2px;background:#f0ccb0}.group-event:last-child .group-event-step:after{display:none}.event-bullet{display:grid;place-items:center;position:relative;z-index:2;border-radius:50%;background:#fff0e0;border:1px solid #edb987;width:26px;height:26px;color:#b44b13;font-size:.75rem}.group-event:first-child .event-bullet{background:#d55b0b;color:white;border-color:#d55b0b}.event-details{padding:0 0 20px;min-width:0}.event-topline{display:flex;gap:10px;justify-content:space-between;align-items:flex-start;flex-wrap:wrap}.event-topline strong{font-size:.93rem}.event-topline time{font-size:.79rem;color:#866b59;font-variant-numeric:tabular-nums}.event-location{margin-top:3px;color:#614737;font-size:.9rem;overflow-wrap:anywhere}.event-comment{margin-top:8px;border-left:3px solid #f1c7a1;padding:7px 10px;background:#fff5ea;border-radius:0 8px 8px 0;font-size:.83rem;color:#71513b;overflow-wrap:anywhere}.event-actor{display:inline-block;margin-top:6px;font-size:.73rem;color:#a07b61}.group-footer{display:flex;gap:12px;align-items:center;justify-content:flex-end;flex-wrap:wrap;padding-top:12px;border-top:1px solid #f3e1d3}.group-footer .mini-copy{width:auto}
@keyframes groupReveal{from{opacity:0;transform:translateY(-5px)}to{opacity:1;transform:translateY(0)}}
@media(max-width:720px){.group-aside .small{display:none}.movement-group>summary{padding:14px 12px}.group-body{padding:14px 11px}.movement-viewactions{width:100%}.view-switch{flex:1}.group-footer{justify-content:flex-start}}
@media(prefers-reduced-motion:reduce){.group-chevron,.movement-group,.group-body{transition:none!important;animation:none!important}}


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

/* Undo workflow: make previous/current status and any database rejection obvious. */
.correction-preview{display:flex;align-items:center;gap:14px;flex-wrap:wrap;padding:15px;border:1px solid #f1cfae;background:#fff8f0;border-radius:14px;margin:12px 0 14px}
.correction-preview>div{flex:1 1 160px;min-width:0;display:grid;gap:4px}
.correction-preview small{font-size:.76rem;color:#896855;font-weight:750}
.correction-preview strong{font-size:1.11rem;color:#513020}
.correction-arrow{width:37px;height:37px;border-radius:50%;background:#ffe5c7;display:grid;place-items:center;color:#a94711;font-size:1.35rem;font-weight:900}
.correction-help{font-size:.85rem;color:#765542;margin:6px 0 16px}
.correction-error{border:1px solid #e2a3a3;background:#fff1ed;color:#963b25;padding:13px 16px;border-radius:13px;margin:0 0 20px}
.correction-error strong{display:inline}
.correction-error small{display:inline-block;margin-top:6px;color:#8c513f}
@media(max-width:540px){.correction-preview{gap:9px}.correction-arrow{width:30px;height:30px}}

/* v16.9 | card containment & button alignment, using existing inline CSS artwork */
.page-heading.page-hero{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(220px,285px)!important;grid-template-rows:auto auto;grid-template-areas:"copy art" "actions art";align-items:center;column-gap:20px;row-gap:10px;min-height:195px;max-height:none;margin:0 0 20px;padding:20px 24px;overflow:hidden!important;isolation:isolate;box-shadow:0 15px 33px #653a2011}
.page-hero .hero-copy{grid-area:copy;align-self:end;min-width:0;position:relative;z-index:1}
.page-hero .hero-actions{grid-area:actions;display:flex;align-self:start;align-items:center;justify-content:flex-start!important;gap:9px;flex-wrap:wrap;min-width:0;position:relative;z-index:1}
.page-hero .hero-actions .btn{margin:0;white-space:nowrap}
.page-hero .hero-art{grid-area:art;position:relative;z-index:1;justify-self:end;align-self:center;display:block!important;width:100%;max-width:285px;height:154px;min-height:154px;overflow:hidden!important;border-radius:16px}
.page-hero .mv-scene{position:absolute;top:5px;left:4px;width:300px!important;height:160px!important;transform:scale(.91)!important;transform-origin:top left!important;filter:none!important}
@media(max-width:860px){.page-heading.page-hero{grid-template-columns:1fr!important;grid-template-areas:"copy" "actions";padding:18px 20px;min-height:0}.page-hero .hero-art{display:none!important}}
@media(prefers-reduced-motion:reduce){.page-hero .mv-scene *{animation:none!important}}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .journey-panel,html[data-nl-mode="dark"] body.nl-themed-page .timeline-item,html[data-nl-mode="dark"] body.nl-themed-page .movement-group,html[data-nl-mode="dark"] body.nl-themed-page .movement-group>summary,html[data-nl-mode="dark"] body.nl-themed-page .group-body,html[data-nl-mode="dark"] body.nl-themed-page .group-event,html[data-nl-mode="dark"] body.nl-themed-page .group-footer{background:#203044!important;background-image:none!important;color:#edf4fc!important;border-color:#4b657c!important}
html[data-nl-mode="dark"] body.nl-themed-page .timeline-item :is(h3,p,strong,span),html[data-nl-mode="dark"] body.nl-themed-page .movement-group :is(h3,p,strong,.group-identity small,.event-location,.event-comment,.event-actor),html[data-nl-mode="dark"] body.nl-themed-page .journey-panel :is(h3,p,.journey-stage-label,.journey-stage-caption){color:#edf4fc!important}
html[data-nl-mode="dark"] body.nl-themed-page .event-comment,html[data-nl-mode="dark"] body.nl-themed-page .group-symbol,html[data-nl-mode="dark"] body.nl-themed-page .event-bullet{background:#2b3e52!important;color:#ffca9c!important;border-color:#63778b!important}
html[data-nl-mode="dark"] body.nl-themed-page .journey-dot,html[data-nl-mode="dark"] body.nl-themed-page .step-dot{background:#2b3e52!important;color:#edf4fc!important;border-color:#768ba0!important}

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
</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<%@ include file="../shared/_theme.jsp" %>
</head><body data-nl-screen="module2-movementtracking" class="nl-themed-page nl-universal-module2" data-nl-enhanced="true"><jsp:include page="/WEB-INF/views/shared/_nav.jsp" />
<div class="app-shell">
<jsp:include page="/WEB-INF/views/shared/_sidebar.jsp" />
<main class="main-area" id="mainContent"><div class="content-wrap">

<div class="bread"><a href="${requestScope.nlv_Module2_movementTracking__1}?action=shipments">Workspace</a> <span>/</span> <b>Movement tracking</b></div>
<div class="page-heading page-hero"><div class="hero-copy"><div class="caps">${requestScope.nlv_Module2_movementTracking__2}</div><h1>${requestScope.nlv_Module2_movementTracking__3} <span>${requestScope.nlv_Module2_movementTracking__4}</span></h1><p>${requestScope.nlv_Module2_movementTracking__5}</p></div><div class="hero-art" aria-hidden="true"><div class="mv-scene"><div class="mv-halo"></div><div class="mv-card"></div><div class="mv-path"></div><span class="mv-node one"></span><span class="mv-node two"></span><span class="mv-node three"></span><div class="mv-arrow"></div><div class="mv-box"></div></div></div><div class="hero-actions"><a class="btn light" href="${requestScope.nlv_Module2_movementTracking__6}?action=shipments">← Shipments</a><a class="btn light" href="${requestScope.nlv_Module2_movementTracking__7}?action=movements">All events</a></div></div>
${requestScope.nlv_Module2_movementTracking__8}
${requestScope.nlv_Module2_movementTracking__9}
${requestScope.nlv_Module2_movementTracking__10}
${requestScope.nlv_Module2_movementTracking__11}
<section class="card"><div class="card-head"><div><h2>${requestScope.nlv_Module2_movementTracking__12} <span class="pill">${requestScope.nlv_Module2_movementTracking__13} events</span></h2><p class="sub">View the recorded history of every shipment, including cancellations. These events are saved by authorized users, not live GPS.</p></div></div>
${requestScope.nlv_Module2_movementTracking__14}
</section>
${requestScope.nlv_Module2_movementTracking__15}
<%@ include file="../shared/_end.jsp" %>
</div></main></div></body></html>
