<jsp:useBean id="nlViewSupport_Module1_audit_log" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_audit_log" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_audit_log" property="view" value="Module1/audit-log.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*,model.AuditLog" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Audit trail | N-LOGISTIC</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="../shared/_theme.jsp" %>
<style>
.nl-audit-v16{--ai:#3e2b21;--ao:#bb4910;--al:#ead6c4;color:var(--ai)}
.nl-audit-v16 .a-hero{background:linear-gradient(112deg,#fffdf9,#fff0df);border:1px solid #eccbb1;border-radius:21px;padding:clamp(19px,2.4vw,29px);margin-bottom:18px;display:flex;justify-content:space-between;align-items:center;gap:18px;flex-wrap:wrap}
.nl-audit-v16 .a-eyebrow{font-size:.72rem;letter-spacing:.14em;font-weight:850;color:#af4d1c}
.nl-audit-v16 h1{font-size:clamp(1.7rem,3vw,2.3rem);font-weight:860;margin:7px 0}
.nl-audit-v16 p{color:#775f50;line-height:1.5}
.nl-audit-v16 .a-hero a,.nl-audit-v16 .a-ghost{border:1px solid #e5b99b;background:#fff9f2;color:#914218;text-decoration:none;padding:10px 14px;border-radius:10px;font-weight:750}
.nl-audit-v16 .a-stats{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:10px;margin-bottom:18px}
.nl-audit-v16 .a-stat{background:#fffdf9;border:1px solid var(--al);border-radius:15px;padding:16px;min-width:0}
.nl-audit-v16 .a-stat span{font-size:.78rem;font-weight:700;color:#7c6250}.nl-audit-v16 .a-stat strong{font-size:1.65rem;color:#b34513;display:block;margin-top:6px}
.nl-audit-v16 .a-card{background:#fffdf9;border:1px solid var(--al);border-radius:19px;padding:clamp(16px,2vw,24px);margin:0 0 19px;box-shadow:0 12px 27px #5c351c0a}
.nl-audit-v16 .a-card h2{font-size:1.23rem;font-weight:830;margin-bottom:5px}
.nl-audit-v16 label{font-weight:740;font-size:.85rem;color:#654632;margin-bottom:7px}
.nl-audit-v16 .form-control,.nl-audit-v16 .form-select{border-radius:11px;border-color:#e4c9b4;background:#fffcf8;min-height:43px}
.nl-audit-v16 .a-primary{background:#c64c0e;color:#fff;border:1px solid #bc4613;border-radius:11px;padding:10px 18px;font-weight:800}
.nl-audit-v16 .a-toolbar{display:flex;gap:9px;align-items:center;flex-wrap:wrap;background:#fff4e8;border:1px solid #eed7c3;border-radius:12px;padding:12px;margin:15px 0}
.nl-audit-v16 .a-toolbar input{min-width:170px;flex:2 1 220px}.nl-audit-v16 .a-toolbar select{flex:1 1 135px;max-width:220px}
.nl-audit-v16 .a-count{font-size:.79rem;color:#846047;font-weight:750;margin-left:auto}
.nl-audit-v16 .a-table-wrap{max-height:650px;overflow:auto;border:1px solid #eedccc;border-radius:13px}
.nl-audit-v16 .a-table{margin:0;width:100%;min-width:830px;border-collapse:separate;border-spacing:0}
.nl-audit-v16 .a-table th{position:sticky;top:0;z-index:2;background:#fff0e2;color:#8b4219;font-size:.72rem;letter-spacing:.055em;text-transform:uppercase;padding:15px 14px;white-space:nowrap}
.nl-audit-v16 .a-sort{background:transparent;border:0;color:inherit;font:inherit;font-weight:800;letter-spacing:inherit;padding:0;text-transform:inherit;cursor:pointer}
.nl-audit-v16 .a-sort span{display:inline-block;width:7px;height:7px;border-right:1.6px solid #bb7e59;border-bottom:1.6px solid #bb7e59;transform:rotate(45deg);margin:0 0 3px 6px}
.nl-audit-v16 .a-sort[aria-sort="ascending"] span{transform:rotate(225deg);margin-bottom:0}
.nl-audit-v16 .a-table td{border-bottom:1px solid #f1e2d5;padding:14px;vertical-align:middle;font-size:.84rem}
.nl-audit-v16 .a-table tr:nth-child(even){background:#fdf7ef}.nl-audit-v16 .a-table tr:hover{background:#fff1e1}
.nl-audit-v16 .a-id{font-weight:850;color:#a54616}.nl-audit-v16 .a-chip{padding:6px 9px;border-radius:50px;font-size:.7rem;font-weight:850;color:#98420a;background:#fff0db;display:inline-block}
.nl-audit-v16 .a-chip.a-delete{background:#ffe7e3;color:#9c2c24}.nl-audit-v16 .a-chip.a-auth{background:#eaf2fb;color:#325b8d}.nl-audit-v16 .a-chip.a-create{background:#e6f5ec;color:#237048}
.nl-audit-v16 .a-preview{font-size:.8rem;line-height:1.45;color:#5d5046;max-width:310px;display:block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.nl-audit-v16 .a-preview.empty{color:#9d8373}.nl-audit-v16 .a-row-btn{border:1px solid #edc9b0;background:#fffaf4;color:#994619;border-radius:9px;padding:8px 12px;font-size:.8rem;font-weight:800}
.nl-audit-v16 .a-row-actions{display:flex;gap:5px;align-items:center}
.nl-audit-v16 .a-pager{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;padding-top:14px;font-size:.82rem;color:#776052}
.nl-audit-v16 .a-pager button{border:1px solid #e9c7ac;background:#fffaf4;border-radius:9px;padding:7px 12px;color:#914116}
.nl-audit-v16 .a-pager button:disabled{opacity:.42}
.nl-audit-v16 .a-readonly{margin-top:12px;font-size:.79rem;color:#856756}
.a-detail-json{white-space:pre-wrap;overflow-wrap:anywhere;max-height:310px;overflow:auto;background:#fff7ed;border:1px solid #edd9c7;border-radius:10px;padding:12px;font-size:.79rem;color:#4e392a}
.a-diff-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:13px}
.a-field-change{display:grid;grid-template-columns:minmax(120px,.65fr) 1fr 1fr;gap:8px;padding:9px;border-bottom:1px solid #f0dcc8;align-items:start;font-size:.8rem}
.a-field-change strong{overflow-wrap:anywhere}.a-field-change span{overflow-wrap:anywhere}
.a-field-change.changed{background:#fff2de}
@media(max-width:850px){.nl-audit-v16 .a-stats{grid-template-columns:repeat(3,minmax(0,1fr))}}
@media(max-width:570px){.nl-audit-v16 .a-stats{grid-template-columns:repeat(2,minmax(0,1fr))}.a-diff-grid{grid-template-columns:1fr}}

/* v16.9 | audit-card layout, exclusively inline HTML/CSS, no SVG or assets */
.nl-audit-v16 .a-hero{position:relative;isolation:isolate;overflow:hidden!important;display:grid;grid-template-columns:minmax(0,1fr) minmax(220px,290px);min-height:198px;gap:20px;align-items:center;padding:20px 26px;box-shadow:0 15px 33px #653a2011;background:linear-gradient(120deg,#fffcf8,#fff0e1 75%,#ffe4c9)}
.nl-audit-v16 .a-hero:before{content:"";position:absolute;width:245px;height:245px;right:-83px;top:-88px;border:1px solid #edcba9;border-radius:50%;box-shadow:0 0 0 26px #ffeddc99,0 0 0 55px #ffe5cd88;pointer-events:none}
.nl-audit-v16 .a-hero-copy,.nl-audit-v16 .a-hero-art{position:relative;z-index:1;min-width:0}
.nl-audit-v16 .a-hero h1{font-size:clamp(1.7rem,2.6vw,2.35rem);margin:5px 0 7px}
.nl-audit-v16 .a-hero p{font-size:.88rem;line-height:1.5;max-width:680px}
.nl-audit-v16 .a-hero-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:14px}
.nl-audit-v16 .a-hero-actions a{display:inline-flex;align-items:center;justify-content:center}
.nl-audit-v16 .a-hero-art{width:100%;max-width:290px;height:154px;overflow:hidden;justify-self:end;border-radius:16px}
.nl-audit-v16 .a-visual{position:absolute;inset:0;filter:drop-shadow(0 10px 13px #ae6e4135)}
.nl-audit-v16 .a-visual-halo{position:absolute;inset:4px 10px;border:1px solid #f0c7a4;border-radius:50%;background:radial-gradient(circle,#fffdf9,#ffdfc0 75%)}
.nl-audit-v16 .a-visual-book{position:absolute;left:63px;top:20px;width:144px;height:113px;border:3px solid #a0582b;border-radius:14px;background:linear-gradient(145deg,#fffefa,#ffddba);box-shadow:10px 11px 0 #ad63382b;animation:aPaperFloat 5.6s ease-in-out infinite}
.nl-audit-v16 .a-visual-book:before{content:"";position:absolute;left:19px;right:17px;top:25px;height:7px;border-radius:8px;background:#e0a678;box-shadow:0 19px 0 #f0c59d,0 38px 0 #f0c59d}
.nl-audit-v16 .a-visual-book:after{content:"";position:absolute;left:19px;width:64px;bottom:16px;height:7px;border-radius:8px;background:#e0a678}
.nl-audit-v16 .a-visual-glass{position:absolute;right:26px;top:18px;width:66px;height:66px;border:9px solid #d76a25;background:#fffbf0a8;border-radius:50%;box-shadow:0 4px 0 #a5582c;animation:aGlassHover 5s ease-in-out infinite}
.nl-audit-v16 .a-visual-glass:after{content:"";position:absolute;width:10px;height:40px;left:44px;top:46px;border-radius:8px;background:#ac5325;transform:rotate(-42deg)}
.nl-audit-v16 .a-visual-tag{position:absolute;left:29px;bottom:7px;width:95px;height:38px;border:2px solid #a85b2c;border-radius:11px;background:#fff9ed;transform:rotate(-10deg);animation:aTagFloat 6s ease-in-out infinite}
.nl-audit-v16 .a-visual-tag:before{content:"";position:absolute;left:13px;right:13px;top:10px;height:5px;border-radius:8px;background:#eac199;box-shadow:0 11px 0 #eac199}
@keyframes aPaperFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-6px)}}
@keyframes aGlassHover{0%,100%{transform:translate(0,0)}50%{transform:translate(-3px,-5px)}}
@keyframes aTagFloat{0%,100%{transform:rotate(-10deg) translateY(0)}50%{transform:rotate(-10deg) translateY(-4px)}}
@media(max-width:850px){.nl-audit-v16 .a-hero{grid-template-columns:1fr;padding:18px 20px;min-height:0}.nl-audit-v16 .a-hero-art{display:none}}
@media(prefers-reduced-motion:reduce){.nl-audit-v16 .a-visual *{animation:none!important}}
</style>
</head><body class="nl-themed-page bg-body-tertiary text-dark" data-nl-screen="module1-audit-log" data-theme="n-logistic-orange" data-nl-enhanced="true">
<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="nl-view-body nl-audit-v16">
<section class="a-hero" aria-labelledby="aHeroTitle"><div class="a-hero-copy"><div class="a-eyebrow">ADMINISTRATION / RECORD HISTORY</div><h1 id="aHeroTitle">Audit trail</h1><p class="mb-0">Review who changed a record, and compare the information before and after the action.</p><div class="a-hero-actions"><a href="${requestScope.nlv_Module1_audit_log__1}/Module1Controller?action=auditLogs">Refresh records</a></div></div><div class="a-hero-art" aria-hidden="true"><div class="a-visual"><div class="a-visual-halo"></div><div class="a-visual-book"></div><div class="a-visual-glass"></div><div class="a-visual-tag"></div></div></div></section>
<div class="a-stats" aria-label="Audit summary"><div class="a-stat"><span>Loaded events</span><strong>${requestScope.nlv_Module1_audit_log__2}</strong></div><div class="a-stat"><span>New records</span><strong>${requestScope.nlv_Module1_audit_log__3}</strong></div><div class="a-stat"><span>Updates</span><strong>${requestScope.nlv_Module1_audit_log__4}</strong></div><div class="a-stat"><span>Sign-in activity</span><strong>${requestScope.nlv_Module1_audit_log__5}</strong></div><div class="a-stat"><span>Deletions</span><strong>${requestScope.nlv_Module1_audit_log__6}</strong></div></div>
<section class="a-card" aria-label="Database filters"><div class="d-flex justify-content-between gap-2 flex-wrap align-items-start"><div><h2>Find an event</h2><p class="mb-0 small">Use a person or affected table to narrow the results from the database.</p></div><span class="a-eyebrow">READ ONLY</span></div>
<form class="row g-3 align-items-end mt-1" action="${requestScope.nlv_Module1_audit_log__7}/Module1Controller" method="get"><input type="hidden" name="action" value="searchAuditLog"><div class="col-md-4"><label for="aUserFilter">Person (User ID)</label><input id="aUserFilter" class="form-control" type="number" min="1" name="userId" value="${requestScope.nlv_Module1_audit_log__8}" placeholder="Anyone"></div><div class="col-md-5"><label for="aTableFilter">Affected area</label><select id="aTableFilter" class="form-select" name="tableName"><option value="">All areas</option><jsp:setProperty name="nlViewSupport_Module1_audit_log" property="fragment" value="nlv_Module1_audit_log__9" /><jsp:getProperty name="nlViewSupport_Module1_audit_log" property="fragment" /></select></div><div class="col-md-3 d-flex gap-2"><button class="btn a-primary flex-grow-1" type="submit">Apply filters</button><a class="a-ghost" href="${requestScope.nlv_Module1_audit_log__10}/Module1Controller?action=auditLogs">Reset</a></div></form></section>
<section class="a-card" aria-labelledby="aHistoryTitle"><div class="d-flex justify-content-between align-items-center gap-2 flex-wrap"><div><div class="a-eyebrow">REGISTER / AUTHORIZED RECORDS</div><h2 id="aHistoryTitle">Activity history &amp; change summaries</h2><p class="mb-0 small">Click View change to see formatted field values instead of raw JSON.</p></div><button type="button" class="a-ghost" id="aExportCsv">Export displayed CSV</button></div>
<div class="a-toolbar"><label class="visually-hidden" for="aLocalSearch">Search loaded events</label><input id="aLocalSearch" class="form-control" type="search" placeholder="Search user, action, record or values"><label class="visually-hidden" for="aActionFilter">Action category</label><select id="aActionFilter" class="form-select"><option value="">All actions</option><option value="CREATE">New records</option><option value="UPDATE">Updates</option><option value="AUTH">Sign-in activity</option><option value="DELETE">Deletions</option><option value="OTHER">Other</option></select><button type="button" id="aClearSearch" class="a-ghost">Clear</button><span class="a-count" id="aResultCount" role="status">${requestScope.nlv_Module1_audit_log__11} loaded</span></div>
<div class="a-table-wrap"><table class="a-table" id="aAuditTable" data-nl-enhanced="true" data-nl-no-auto-copy="true"><thead><tr><th><button class="a-sort" type="button" data-a-sort="0">Event <span aria-hidden="true"></span></button></th><th><button class="a-sort" type="button" data-a-sort="1">Performed by <span aria-hidden="true"></span></button></th><th><button class="a-sort" type="button" data-a-sort="2">Action <span aria-hidden="true"></span></button></th><th><button class="a-sort" type="button" data-a-sort="3">Affected record <span aria-hidden="true"></span></button></th><th>Change summary</th><th>Details</th></tr></thead><tbody>
<jsp:setProperty name="nlViewSupport_Module1_audit_log" property="fragment" value="nlv_Module1_audit_log__12" /><jsp:getProperty name="nlViewSupport_Module1_audit_log" property="fragment" />
</tbody></table><p id="aNoResults" class="p-4 text-center text-secondary" hidden="hidden">No events match. Try a different search or clear filters.</p></div>
<div class="a-pager"><span id="aPageInfo">Page 1</span><div class="d-flex gap-2 align-items-center"><label for="aPageSize">Rows</label><select class="form-select form-select-sm" id="aPageSize" style="width:auto;min-height:35px"><option value="10">10</option><option selected="selected" value="25">25</option><option value="50">50</option><option value="100">100</option></select><button type="button" id="aPrevious">Previous</button><button type="button" id="aNext">Next</button></div></div>
<p class="a-readonly">Stored audit entries are read only. A date is not shown because the approved audit_log table has no timestamp field; missing old/new values are not invented.</p></section>
</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<div class="modal fade" id="aChangeModal" tabindex="-1" aria-labelledby="aChangeTitle" aria-hidden="true"><div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable"><div class="modal-content" style="border-radius:19px;border:1px solid #e7c4a9"><div class="modal-header" style="background:#fff1e5"><div><div class="a-eyebrow">AUDIT / RECORDED EVIDENCE</div><h2 class="modal-title fs-4 fw-bold" id="aChangeTitle">Event details</h2><small class="text-secondary" id="aChangeSub"></small></div><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button></div><div class="modal-body"><h3 class="h6">Changed fields</h3><div id="aFieldGrid"></div><div class="a-diff-grid mt-3"><section><h3 class="h6">Before</h3><pre id="aOldJson" class="a-detail-json"></pre></section><section><h3 class="h6">After</h3><pre id="aNewJson" class="a-detail-json"></pre></section></div><p class="small text-secondary" id="aAuditIp"></p></div><div class="modal-footer"><button type="button" class="btn a-ghost" id="aCopyEvent">Copy event details</button><button type="button" class="btn a-primary" data-bs-dismiss="modal">Close</button></div></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){'use strict';const root=document.querySelector('.nl-audit-v16');if(!root)return;
const q=(s,r)=> (r||document).querySelector(s),all=(s,r)=>Array.from((r||document).querySelectorAll(s));
const rows=all('#aAuditTable tbody tr',root),search=q('#aLocalSearch'),filter=q('#aActionFilter'),size=q('#aPageSize');let page=1,filtered=rows.slice(),sortColumn=-1,sortAscending=false;
function update(){const term=search.value.trim().toLowerCase();filtered=rows.filter(tr=>(!term||tr.dataset.aSearch.toLowerCase().includes(term))&&(!filter.value||tr.dataset.aType===filter.value));
 if(sortColumn>=0){filtered.sort((a,b)=>{
  const cells=tr=>Array.from(tr.children);let left=cells(a)[sortColumn]?.textContent.trim()||'',right=cells(b)[sortColumn]?.textContent.trim()||'';
  let compare=sortColumn===0?Number(a.dataset.aId)-Number(b.dataset.aId):left.localeCompare(right,undefined,{numeric:true});
  return sortAscending?compare:-compare;
 });
 filtered.forEach(tr=>q('#aAuditTable tbody',root).appendChild(tr));}
 const maxPage=Math.max(1,Math.ceil(filtered.length/Number(size.value)));page=Math.max(1,Math.min(page,maxPage));
 const pageRows=filtered.slice((page-1)*Number(size.value),page*Number(size.value));rows.forEach(tr=>tr.hidden=!pageRows.includes(tr));
 q('#aResultCount').textContent=filtered.length+' of '+rows.length+' events';q('#aPageInfo').textContent='Page '+page+' of '+maxPage;
 q('#aPrevious').disabled=page===1;q('#aNext').disabled=page>=maxPage;q('#aNoResults').hidden=filtered.length!==0;
}
all('[data-a-sort]',root).forEach(b=>b.addEventListener('click',()=>{
 const index=Number(b.dataset.aSort);sortAscending=sortColumn===index?!sortAscending:true;sortColumn=index;page=1;
 all('[data-a-sort]',root).forEach(other=>other.removeAttribute('aria-sort'));
 b.setAttribute('aria-sort',sortAscending?'ascending':'descending');update();
}));
[search,filter,size].forEach(el=>el.addEventListener(el===search?'input':'change',()=>{page=1;update();}));
q('#aClearSearch').addEventListener('click',()=>{search.value='';filter.value='';page=1;update();search.focus();});
q('#aPrevious').addEventListener('click',()=>{page--;update();});q('#aNext').addEventListener('click',()=>{page++;update();});
function parse(text){if(!text||!text.trim())return null;try{return JSON.parse(text);}catch(e){return text;}}
function pretty(text){const data=parse(text);if(data===null)return 'Not recorded in the audit entry';return typeof data==='string'?data:JSON.stringify(data,null,2);}
function value(x){return x==null?'Not recorded':typeof x==='string'?x:JSON.stringify(x);}
let activeEvent=null;
all('[data-a-view]',root).forEach(button=>button.addEventListener('click',()=>{
 const id=button.dataset.aView;activeEvent={id,action:button.dataset.aAction,table:button.dataset.aTable,actor:button.dataset.aActor,ip:button.dataset.aIp,
 old:q('#aOld'+id).textContent,newValue:q('#aNew'+id).textContent};
 q('#aChangeTitle').textContent=activeEvent.action+' / Event #'+id;
 q('#aChangeSub').textContent=activeEvent.actor+' · '+activeEvent.table;
 q('#aOldJson').textContent=pretty(activeEvent.old);q('#aNewJson').textContent=pretty(activeEvent.newValue);
 q('#aAuditIp').textContent='Recorded IP address: '+(activeEvent.ip||'Unavailable');
 const o=parse(activeEvent.old),n=parse(activeEvent.newValue),grid=q('#aFieldGrid');grid.replaceChildren();
 const isObject=x=>x!==null && typeof x==='object' && !Array.isArray(x);
 if(isObject(o)||isObject(n)){
  const keys=new Set([...Object.keys(isObject(o)?o:{}),...Object.keys(isObject(n)?n:{})]);
  const head=document.createElement('div');head.className='a-field-change fw-bold';['Field','Previous','New'].forEach(x=>{const span=document.createElement('strong');span.textContent=x;head.appendChild(span);});grid.appendChild(head);
  [...keys].slice(0,60).forEach(key=>{const before=isObject(o)?o[key]:undefined,after=isObject(n)?n[key]:undefined;const row=document.createElement('div');row.className='a-field-change'+(JSON.stringify(before)!==JSON.stringify(after)?' changed':'');
   [key,value(before),value(after)].forEach((x,i)=>{const span=document.createElement(i===0?'strong':'span');span.textContent=x;row.appendChild(span);});grid.appendChild(row);});
 }else {const note=document.createElement('p');note.className='text-secondary small';note.textContent='A field-by-field comparison is unavailable because this action did not store both structured values.';grid.appendChild(note);}
 if(window.bootstrap)bootstrap.Modal.getOrCreateInstance(q('#aChangeModal')).show();
}));
q('#aCopyEvent').addEventListener('click',async()=>{if(!activeEvent)return;const text=JSON.stringify(activeEvent,null,2);try{await navigator.clipboard.writeText(text);q('#aCopyEvent').textContent='Copied';setTimeout(()=>q('#aCopyEvent').textContent='Copy event details',1200);}catch(e){q('#aCopyEvent').textContent='Copy unavailable';}});
q('#aExportCsv').addEventListener('click',()=>{
 const quote=x=>{let s=String(x??'').replace(/\s+/g,' ').trim();if(/^[=+@-]/.test(s))s="'"+s;return '"'+s.replace(/"/g,'""')+'"';};
 const entries=[['Event ID','Actor','Action','Affected area','Change summary']];
 filtered.forEach(tr=>{const cells=all('td',tr);entries.push([tr.dataset.aId,cells[1].textContent,cells[2].textContent,cells[3].textContent,cells[4].textContent]);});
 const blob=new Blob(['\uFEFF'+entries.map(x=>x.map(quote).join(',')).join('\r\n')],{type:'text/csv;charset=utf-8'});const url=URL.createObjectURL(blob),a=document.createElement('a');a.href=url;a.download='nlogistic-audit-visible.csv';a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);
});update();
})();
</script></body></html>
