<%-- Accessible progressive enhancement. Does not bypass controller/database authorization. --%>
<script>
(function () {
  'use strict';
  const doc = document;
  const pageKey = location.pathname + location.search.replace(/([?&])(page|p)=\d+/g, '$1');
  const $ = (sel, root = doc) => root.querySelector(sel);
  const $$ = (sel, root = doc) => Array.from(root.querySelectorAll(sel));
  const storage = {
    get(k) { try { return JSON.parse(sessionStorage.getItem(k) || 'null'); } catch(e) { return null; } },
    set(k,v) { try { sessionStorage.setItem(k,JSON.stringify(v)); } catch(e) {} },
    del(k) { try { sessionStorage.removeItem(k); } catch(e) {} }
  };
  const simplify = s => String(s || '').replace(/\s+/g,' ').trim();
  function node(tag, className, text) {
    const el=doc.createElement(tag);if(className)el.className=className;if(text!==undefined)el.textContent=text;return el;
  }
  function controlLabel(el) {
    const wrap=el.closest('label');
    const id=el.id;
    return simplify((id && doc.querySelector('label[for="'+ CSS.escape(id) +'"]') || wrap)?.textContent || el.getAttribute('aria-label') || el.name || 'Field');
  }
  function markRequired() {
    $$('main input[required], .nl-view-body input[required], .nl-view-body textarea[required], .nl-view-body select[required], .nl-auth-card input[required]').forEach(input=>{
      if (input.type === 'hidden' || input.type === 'checkbox' || input.type === 'radio')return;
      let lbl = input.id ? doc.querySelector('label[for="'+CSS.escape(input.id)+'"]') : input.closest('label');
      if (lbl && !lbl.querySelector('.nl-required') && lbl.textContent.indexOf('*')<0){const star=node('span','nl-required text-danger fw-bold',' *');star.title='Required';const controlChild=Array.from(lbl.children).find(child=>child===input||child.contains(input));if(controlChild)lbl.insertBefore(star,controlChild);else lbl.appendChild(star);}
      if (!input.getAttribute('aria-describedby') && input.getAttribute('title')){input.setAttribute('aria-description',input.title);}
    });
  }
  // Universal header/nav behavior now lives in _universal_ui.jsp for every module.
  function initNav() {}
  // Click the actual identifier, not an added orange Copy button.  The
  // helper is browser-side only; authorization and record links are unchanged.
  function initCopy() {
    const announcer=node('div','nl-copy-announcement');
    announcer.setAttribute('role','status');announcer.setAttribute('aria-live','polite');
    doc.body.appendChild(announcer);
    let announceTimeout=0;
    function announce(message){announcer.textContent=message;announcer.classList.add('is-visible');
      clearTimeout(announceTimeout);announceTimeout=setTimeout(()=>announcer.classList.remove('is-visible'),1800);}
    async function writeClipboard(text){
      try{if(navigator.clipboard && navigator.clipboard.writeText){await navigator.clipboard.writeText(text);return true;}}catch(ignore){}
      const area=node('textarea');area.value=text;area.readOnly=true;
      area.style.cssText='position:fixed;left:-9999px;top:0;opacity:0';doc.body.appendChild(area);
      area.focus();area.select();let ok=false;
      try{ok=doc.execCommand('copy');}catch(ignore){}area.remove();return ok;
    }
    function enable(el,text,label){
      if(!el||!text||el.hasAttribute('data-nl-copy-value'))return;
      el.dataset.nlCopyValue=text;el.classList.add('nl-inline-copy');
      // Existing navigation links stay navigable, with Ctrl/Command+click copy.
      // The ordinary identifier text is copyable directly when not a link.
      const link=el.closest('a[href]');
      if(link){el.title='Ctrl+click to copy '+label+' (click to open details)';return;}
      el.setAttribute('role','button');el.setAttribute('tabindex','0');
      el.setAttribute('aria-label','Copy '+label+' '+text);el.title='Click to copy '+label;
    }
    $$('table:not([data-nl-no-auto-copy])').forEach(table=>{
      const headers=$$('thead th',table).map(th=>simplify(th.textContent).toLowerCase());
      const indices=headers.map((txt,i)=>/^(shipment|booking|invoice|container|claim|payment|sku|reference|user|id|code)(\s|$)/i.test(txt)?i:-1).filter(i=>i>=0).slice(0,2);
      if(!indices.length)return;
      $$('tbody tr',table).forEach(tr=>{
        const cells=$$('td',tr);
        indices.forEach(index=>{
          const td=cells[index];if(!td||td.colSpan>1)return;
          const valueEl=td.querySelector('a,strong,code,.mono');
          const text=simplify(valueEl?.textContent || td.textContent);
          if(!text||text.length>80)return;
          if(valueEl){enable(valueEl,text,headers[index]);return;}
          if(td.children.length)return; // Never replace badges, links or controls.
          td.textContent='';const value=node('span','',text);td.appendChild(value);
          enable(value,text,headers[index]);
        });
      });
    });
    doc.addEventListener('click',async event=>{
      const el=event.target.closest('[data-nl-copy-value]');if(!el)return;
      const linked=!!el.closest('a[href]');
      if(linked && !(event.ctrlKey||event.metaKey))return;
      event.preventDefault(); // Also prevent a parent <summary> from toggling.
      event.stopPropagation();
      const ok=await writeClipboard(el.dataset.nlCopyValue||'');
      if(ok){el.classList.add('is-copied');setTimeout(()=>el.classList.remove('is-copied'),1200);}
      announce(ok?'Copied '+(el.dataset.nlCopyValue||''):'Copy unavailable. Select the identifier and press Ctrl+C.');
    });
    doc.addEventListener('keydown',event=>{
      const el=event.target.closest('[data-nl-copy-value][role="button"]');
      if(!el || !['Enter',' '].includes(event.key))return;
      event.preventDefault();el.click();
    });
  }
  function initTables() {
    $$('table').forEach((table,index)=>{
      const tbody=$('tbody',table), th=$$('thead tr:first-child th',table);
      if(!tbody || !th.length || table.dataset.nlEnhanced || doc.body.classList.contains('nl-universal-module2'))return;
      const rows=$$('tr',tbody).filter(r=>$$('td',r).length>0 && !$$('td[colspan]',r).length);
      if(rows.length<6 || table.getAttribute('aria-label')==='Shipment status counts table')return;
      if(table.dataset.nlServerPaged==='true')return; // Preserve existing DB-backed pagination.
      table.dataset.nlEnhanced='true';table.classList.add('nl-enhanced-table');
      const key='nltable:'+pageKey+':'+index;
      const remembered=storage.get(key) || {}, settings={query:remembered.query||'',status:remembered.status||'all',size:remembered.size||10,page:remembered.page||1,sort:remembered.sort??-1,asc:remembered.asc??true};
      let current=rows.slice();
      const bar=node('div','nl-table-toolbar'); const filters=node('div','nl-table-filters');
      const search=node('input','form-control nl-table-search');search.type='search';search.placeholder='Search loaded rows';search.value=settings.query;search.setAttribute('aria-label','Search table '+(index+1));
      const statusIndex=th.findIndex(t=>(table.classList.contains('nl-audit-table') ? /^(action)$/i : /^(status|state)$/i).test(simplify(t.textContent)));
      const status=node('select','form-select nl-table-status');status.setAttribute('aria-label',table.classList.contains('nl-audit-table')?'Filter events by action':'Filter table by status');
      if(statusIndex>=0){
        const options=['all',...new Set(rows.map(r=>simplify($$('td',r)[statusIndex]?.textContent)).filter(Boolean))];
        options.forEach(t=>{const o=node('option','',t==='all'?(table.classList.contains('nl-audit-table')?'All actions':'All statuses'):t);o.value=t;status.appendChild(o);});status.value=options.includes(settings.status)?settings.status:'all';
      }
      const reset=node('button','btn btn-outline-secondary btn-sm','Clear filters');reset.type='button';
      filters.appendChild(search);if(statusIndex>=0)filters.appendChild(status);filters.appendChild(reset);
      // Client-only export of the rows already delivered to this authorized page.
      const exportButton=node('button','btn btn-outline-secondary btn-sm nl-export-btn','Export CSV');
      exportButton.type='button'; exportButton.title='Download only the records already loaded in this table';
      exportButton.addEventListener('click',()=>{
        const visible=rows.filter(r=>!r.hidden);
        const headers=th.map(h=>simplify(h.textContent).replace(/\s*\(SORT\)/ig,''));
        const normalizeCell=(value)=>{let text=simplify(value); if(/^[=+@-]/.test(text)) text="'"+text;return '"'+text.replace(/"/g,'""')+'"';};
        const data=[headers,...visible.map(r=>$$('td',r).map(c=>simplify(c.dataset.nlSortValue ?? c.textContent.replace(/\b(Copy|Copied|Retry)\b/g,'').trim())))];
        const csv='\ufeff'+data.map(r=>r.map(normalizeCell).join(',')).join('\r\n');
        const blob=new Blob([csv],{type:'text/csv;charset=utf-8'}),url=URL.createObjectURL(blob),a=node('a');
        a.href=url;a.download='n-logistic-loaded-records.csv';doc.body.appendChild(a);a.click();a.remove();
        setTimeout(()=>URL.revokeObjectURL(url),1000);
      });
      filters.appendChild(exportButton);

      const count=node('small','nl-table-records text-secondary small');count.setAttribute('aria-live','polite');count.setAttribute('role','status');
      bar.appendChild(filters);bar.appendChild(count);
      const host=table.closest('.table-responsive') || table;host.parentNode.insertBefore(bar,host);
      const nav=node('div','nl-table-pagination d-flex justify-content-end align-items-center gap-2 my-3'); const label=node('small','text-secondary');
      const prev=node('button','btn btn-outline-secondary btn-sm','Previous');const next=node('button','btn btn-outline-secondary btn-sm','Next');
      prev.type=next.type='button'; const size=node('select','form-select form-select-sm nl-page-size');size.setAttribute('aria-label','Rows per page');
      [10,25,50].forEach(n=>{const o=node('option','',n+' rows');o.value=String(n);size.appendChild(o);});size.value=String([10,25,50].includes(settings.size)?settings.size:10);
      const pager=node('div','d-flex align-items-center gap-2 flex-wrap');pager.append(prev,label,next,size);nav.appendChild(pager);host.parentNode.insertBefore(nav,host.nextSibling);
      const empty=node('div','nl-table-empty alert alert-secondary mt-2','No matching records. Clear filters or try a different search.');empty.hidden=true;empty.setAttribute('role','status');host.parentNode.insertBefore(empty,nav);
      const headers=th.map(x=>simplify(x.textContent));
      th.forEach((cell,col)=>{
        if(col>=headers.length-1 && /(action|manage|edit)/i.test(headers[col]))return;
        const caption=cell.textContent;cell.textContent='';const btn=node('button','nl-sort-head',caption);btn.type='button';btn.title='Sort by '+headers[col];btn.setAttribute('aria-label','Sort by '+headers[col]);
        btn.addEventListener('click',()=>{settings.asc=settings.sort===col?!settings.asc:true;settings.sort=col;settings.page=1;draw();});cell.appendChild(btn);
      });
      function draw(){
        const query=simplify(search.value).toLocaleLowerCase();settings.query=search.value;settings.size=+size.value;settings.status=statusIndex>=0?status.value:'all';
        current=rows.filter(r=>(!query||simplify(r.textContent).toLocaleLowerCase().includes(query)) && (settings.status==='all'||simplify($$('td',r)[statusIndex]?.textContent)===settings.status));
        if(settings.sort>=0){const col=settings.sort;current.sort((a,b)=>{
          const ax=$$('td',a)[col],by=$$('td',b)[col];
          const x=simplify(ax?.dataset.nlSortValue ?? ax?.textContent),y=simplify(by?.dataset.nlSortValue ?? by?.textContent);
          function key(v){
            const t=v.trim();
            // ISO dates and readable month names must sort chronologically, never by stripped digits.
            if(/^\d{4}-\d{2}-\d{2}/.test(t)){const d=Date.parse(t.slice(0,10));if(Number.isFinite(d))return ['date',d];}
            if(/^\d{1,2}\s+[A-Za-z]{3,9}\s+\d{4}/.test(t)){const d=Date.parse(t);if(Number.isFinite(d))return ['date',d];}
            const numeric=t.replace(/[\u20B9,$\s]/g,'').replace(/%$/,'');
            if(/^-?\d+(?:\.\d+)?$/.test(numeric))return ['number',Number(numeric)];
            return ['text',t];
          }
          const xKey=key(x),yKey=key(y);
          const res=(xKey[0]===yKey[0] && xKey[0]!=='text')?xKey[1]-yKey[1]:x.localeCompare(y,undefined,{numeric:true,sensitivity:'base'});
          return settings.asc?res:-res;});}
        th.forEach((thCell,col)=>{thCell.setAttribute('aria-sort',settings.sort===col?(settings.asc?'ascending':'descending'):'none');thCell.classList.toggle('nl-sorted',settings.sort===col);});
        const max=Math.max(1,Math.ceil(current.length/settings.size));settings.page=Math.min(max,Math.max(1,settings.page));
        rows.forEach(r=>r.hidden=true);current.forEach((r,i)=>{r.hidden=!(i>=(settings.page-1)*settings.size && i<settings.page*settings.size);});
        const slice=current.slice((settings.page-1)*settings.size,settings.page*settings.size);
        // Reorder matching rows without duplicating or changing their content.
        current.forEach(r=>tbody.appendChild(r));
        count.textContent='Showing '+slice.length+' of '+current.length+' matching records ('+rows.length+' loaded)';
        label.textContent='Page '+settings.page+' / '+max;prev.disabled=settings.page<=1;next.disabled=settings.page>=max;nav.hidden=current.length<=settings.size;
        empty.hidden=current.length!==0;storage.set(key,settings);
      }
      search.addEventListener('input',()=>{settings.page=1;draw();});status.addEventListener('change',()=>{settings.page=1;draw();});size.addEventListener('change',()=>{settings.page=1;draw();});
      reset.addEventListener('click',()=>{search.value='';status.value='all';settings.page=1;settings.sort=-1;draw();});
      prev.addEventListener('click',()=>{settings.page--;draw();});next.addEventListener('click',()=>{settings.page++;draw();});draw();
    });
  }
  function initForms(){
    let dirty=false, navigating=false;
    $$('form').forEach(form=>{
      const method=(form.getAttribute('method')||'get').toLowerCase();
      if(method!=='post')return;
      const changes=$$('input:not([type=hidden]):not([type=submit]):not([type=password]),select,textarea',form);
      changes.forEach(el=>{
        if(el.hasAttribute('required')&&!el.title)el.title=controlLabel(el)+' is required';
        // One validation message is rendered by _universal_ui.jsp. Previously this
        // listener inserted another sibling on *every* invalid event, causing
        // repeated 'Check email' messages that grew with each keystroke.
        el.addEventListener('invalid',()=>{el.classList.add('is-invalid');el.setAttribute('aria-invalid','true');});
        const clearValidity=()=>{if(el.validity.valid){el.classList.remove('is-invalid');el.removeAttribute('aria-invalid');}};
        el.addEventListener('input',clearValidity);
        el.addEventListener('change',clearValidity);
        el.addEventListener('change',()=>dirty=true);
      });
      form.addEventListener('submit',event=>{
        // Native POST must never be blocked by a stale page-wide submit lock.
        // Page-specific handlers may cancel this event (e.g. the new-Seller wizard).
        if(event.defaultPrevented || !form.checkValidity())return;
        const action=$('input[name=action]',form)?.value||'';
        const button=event.submitter || $('button[type=submit],input[type=submit]',form);
        const text=simplify(button?.textContent||button?.value||'');
        const irreversible=/delete|remove|deactivate|cancel|settle|reject|close|pay|record.payment/i.test(action+' '+text);
        const warning=form.hasAttribute('data-review')?null:(form.dataset.nlSiteConfirm || (irreversible?'Confirm this action? It may change existing records or cannot be reversed.':form.dataset.nlConfirm));
        if(warning && form.dataset.nlConfirmedByReview!=='true'){
          event.preventDefault();
          if(window.nlShowSiteConfirm)window.nlShowSiteConfirm(form,warning,button);
          else if(window.confirm(warning)){
            form.dataset.nlConfirmedByReview='true';
            if(form.requestSubmit)form.requestSubmit(event.submitter || undefined);
            else HTMLFormElement.prototype.submit.call(form);
          }
          return;
        }
        // Set only a navigation hint for beforeunload; never prevent the submit
        // or disable the submit button. Restore it if a later listener cancels.
        navigating=true;
        queueMicrotask(()=>{
          if(event.defaultPrevented){navigating=false;return;}
          dirty=false;
        });
      });
    });
    
  addEventListener('beforeunload',event=>{if(dirty&&!navigating){event.preventDefault();event.returnValue='';}});
  (function(){
    let pendingLeave=null;
    function ensureLeaveDialog(){
      let existing=doc.getElementById('nlLeaveGuard');
      if(existing)return existing;
      const style=doc.createElement('style');
      style.textContent='body.nl-leave-guard-open{overflow:hidden}.nl-leave-guard{position:fixed;inset:0;z-index:2000;background:rgba(21,16,12,.48);display:grid;place-items:center;padding:20px}.nl-leave-guard[hidden]{display:none!important}.nl-leave-card{width:min(520px,100%);background:linear-gradient(145deg,#fffdf9,#fff3e6);border:1px solid #efc8aa;border-radius:24px;box-shadow:0 24px 60px rgba(65,32,10,.24);padding:24px;color:#3b271d}.nl-leave-card .nl-leave-kicker{font-size:.75rem;letter-spacing:.13em;text-transform:uppercase;font-weight:800;color:#b14c1b}.nl-leave-card h2{margin:8px 0 10px;font-size:1.55rem;font-weight:850}.nl-leave-card p{margin:0 0 8px;color:#6f5748;line-height:1.55}.nl-leave-points{margin:14px 0 0;padding-left:18px;color:#6f5748;font-size:.92rem}.nl-leave-points li+li{margin-top:6px}.nl-leave-actions{display:flex;gap:10px;justify-content:flex-end;flex-wrap:wrap;margin-top:20px}.nl-leave-actions button{border-radius:999px;padding:10px 18px;font-weight:800;border:1px solid #dbb395;background:#fff8f1;color:#84401b}.nl-leave-actions .nl-leave-go{background:#cf5a18;border-color:#c35315;color:#fff}';
      doc.head.appendChild(style);
      const overlay=doc.createElement('div');
      overlay.id='nlLeaveGuard';overlay.className='nl-leave-guard';overlay.hidden=true;
      overlay.innerHTML='<div class="nl-leave-card" role="dialog" aria-modal="true" aria-labelledby="nlLeaveTitle" aria-describedby="nlLeaveText" tabindex="-1"><div class="nl-leave-kicker">Workspace changes</div><h2 id="nlLeaveTitle">Leave this page?</h2><p id="nlLeaveText">You have unsaved changes in this workspace.</p><ul class="nl-leave-points"><li>Choose Stay here to continue editing.</li><li>Choose Leave page to discard unsaved changes and continue.</li></ul><div class="nl-leave-actions"><button type="button" class="nl-leave-stay">Stay here</button><button type="button" class="nl-leave-go">Leave page</button></div></div>';
      overlay.addEventListener('click',e=>{if(e.target===overlay)closeLeaveDialog();});
      overlay.querySelector('.nl-leave-stay').addEventListener('click',closeLeaveDialog);
      overlay.querySelector('.nl-leave-go').addEventListener('click',()=>{const go=pendingLeave;pendingLeave=null;closeLeaveDialog();if(typeof go==='function')go();});
      doc.addEventListener('keydown',e=>{if(overlay.hidden)return;if(e.key==='Escape'){e.preventDefault();closeLeaveDialog();}});
      doc.body.appendChild(overlay);
      return overlay;
    }
    function closeLeaveDialog(){const overlay=doc.getElementById('nlLeaveGuard');if(overlay)overlay.hidden=true;doc.body.classList.remove('nl-leave-guard-open');pendingLeave=null;}
    function showLeaveDialog(go){pendingLeave=go;const overlay=ensureLeaveDialog();overlay.hidden=false;doc.body.classList.add('nl-leave-guard-open');overlay.querySelector('.nl-leave-stay').focus();}
    doc.addEventListener('click',event=>{
      const link=event.target.closest('a[href]');
      if(!link||event.defaultPrevented||!dirty||navigating)return;
      if(link.hasAttribute('download')||link.getAttribute('target')&&link.getAttribute('target')!=='_self')return;
      if(link.hasAttribute('data-nl-bypass-leave'))return;
      const raw=link.getAttribute('href');
      if(!raw||raw.startsWith('#')||/^javascript:/i.test(raw)||/^mailto:/i.test(raw)||/^tel:/i.test(raw))return;
      let next;try{next=new URL(raw,location.href);}catch(err){return;}
      if(next.href===location.href)return;
      event.preventDefault();
      showLeaveDialog(()=>{dirty=false;location.href=next.href;});
    },true);
  })();
}
  function applyStatuses(){
    const tokens={positive:/^(active|available|delivered|paid|settled|approved|completed|confirmed)$/i,negative:/^(cancelled|rejected|failed|locked|inactive|overdue)$/i,warning:/^(pending|partially.approved|partial|unpaid|low.stock|under.review|delayed)$/i,info:/^(in.transit|departed|arrived|booked|loaded|submitted)$/i};
    $$('.nl-view-body .badge,.nl-view-body .pill,.nl-view-body .tag').forEach(el=>{
      const v=simplify(el.textContent);if(tokens.positive.test(v))el.classList.add('nl-status-good text-bg-success');else if(tokens.negative.test(v))el.classList.add('nl-status-bad text-bg-danger');else if(tokens.warning.test(v))el.classList.add('nl-status-warn text-bg-warning');else if(tokens.info.test(v))el.classList.add('nl-status-info text-bg-info');
    });
  }
  function initBookingStepper(){
    if(!doc.body.classList.contains('nl-themed-page') || !location.pathname.includes('ContainerAllocationPricingController'))return;
    const form=$('form[action*="ContainerAllocationPricingController"]');if(!form || $('.nl-booking-steps'))return;
    const steps=['Goods','Route','Availability','Pricing','Confirmation'];
    const strip=node('nav','nl-booking-steps d-flex flex-wrap gap-2 mb-3');strip.setAttribute('aria-label','Booking progress');
    steps.forEach((name,i)=>{const item=node('span','nl-booking-step badge text-bg-light border p-2'+(i===0?' active':''),(i+1)+'. '+name);strip.appendChild(item);});
    const header=form.closest('section,main,.card')||form;header.parentNode.insertBefore(strip,header);
    // Progress is informational only: quote, availability and confirmation still come from the database.
  }
  function initBackLinks(){
    const path=location.pathname,query=new URLSearchParams(location.search),action=query.get('action')||'';
    let kind='',isListing=false,isDetail=false;
    if(path.endsWith('/containerMovement')){kind='shipments';isListing=['shipments','search','movements','searchMovements',''].includes(action);isDetail=['shipmentDetails','timeline','movementUpdate'].includes(action);}
    else if(path.endsWith('/billing')){kind='billing';isListing=['invoices','dashboard','outstanding','payments',''].includes(action);isDetail=['details','print','createInvoice'].includes(action);}
    else if(path.endsWith('/ClaimController')||path.endsWith('/claims')){kind='claims';isListing=['list',''].includes(action);isDetail=['view','new'].includes(action);}
    else if(path.endsWith('/stock')){kind='inventory';isListing=['dashboard',''].includes(action);isDetail=['edit-product','new-product','new-stock','ledger','summary','import'].includes(action);}
    if(!kind)return;
    const key='nl-last-list:'+kind;
    if(isListing){storage.set(key,location.href);return;}
    if(!isDetail)return;
    const url=storage.get(key);
    if(typeof url!=='string')return;
    try{
      const u=new URL(url,location.origin);
      if(u.origin!==location.origin||!u.pathname.startsWith(location.pathname.replace(/[^/]+$/,'')))return;
      const crumb=$('.nl-breadcrumb');if(!crumb)return;
      const a=node('a','nl-return-link btn btn-outline-secondary btn-sm my-2','Back to filtered results');a.href=u.pathname+u.search;a.title='Return to your previous filtered list';crumb.insertAdjacentElement('afterend',a);
    }catch(e){}
  }
  function improveStockAvailability(){
    if(!location.pathname.endsWith('/stock'))return;
    $$('table').forEach(table=>{
      const headings=$$('thead th',table).map(el=>simplify(el.textContent).toLowerCase());
      const usable=headings.findIndex(h=>h==='usable'),damaged=headings.findIndex(h=>h==='damaged');
      if(usable<0)return;
      $$('tbody tr',table).forEach(tr=>{
        const cells=$$('td',tr),cell=cells[usable];if(!cell)return;
        const amount=Number(simplify(cell.textContent).replace(/,/g,''));
        if(amount===0&&!cell.querySelector('.nl-zero-stock')){
          const indicator=node('span','badge nl-status-bad nl-zero-stock ms-2','Out of stock');cell.appendChild(indicator);
        }
        if(damaged>=0){const damagedCell=cells[damaged],damagedCount=Number(simplify(damagedCell?.textContent).replace(/,/g,''));
          if(damagedCount>0&&!damagedCell.querySelector('.nl-damaged-stock')){
            const tag=node('span','badge text-bg-warning ms-2 nl-damaged-stock','Damaged');tag.title=damagedCount+' damaged units are not usable';damagedCell.appendChild(tag);
          }
        }
      });
    });
  }
  function improveFeedback(){
    $$('.nl-view-body .alert,.nl-auth-card .alert').forEach(a=>{
      a.setAttribute('role',a.classList.contains('alert-danger')?'alert':'status');
      if(a.querySelector('.btn-close'))return;
      const b=node('button','btn-close float-end ms-2');b.type='button';b.title='Dismiss message';b.setAttribute('aria-label','Dismiss message');b.addEventListener('click',()=>a.remove());a.insertBefore(b,a.firstChild);
    });
  }
  doc.addEventListener('DOMContentLoaded',()=>{try{initNav();markRequired();initCopy();improveStockAvailability();initTables();initForms();applyStatuses();initBookingStepper();initBackLinks();improveFeedback();}catch(e){console.error('N-LOGISTIC progressive enhancement',e);}});
})();
</script>

<script>
(function(){
 'use strict';
 const run=()=>{
  if(document.body?.dataset.nlEnhanced!=='true') return;
  const $=(s,r=document)=>r.querySelector(s), all=(s,r=document)=>Array.from(r.querySelectorAll(s));
  const main=$('.nl-view-body')||$('main');if(!main)return;
  const bar=document.createElement('div');bar.className='nl-progress-track';bar.setAttribute('aria-hidden','true');document.body.prepend(bar);
  const progress=()=>{const max=document.documentElement.scrollHeight-innerHeight;bar.style.width=(max>0?Math.min(100,scrollY/max*100):0)+'%';};
  addEventListener('scroll',progress,{passive:true});addEventListener('resize',progress,{passive:true});progress();
  if('IntersectionObserver' in window){
    const observer=new IntersectionObserver(entries=>entries.forEach(e=>{if(e.isIntersecting){e.target.classList.add('nl-inview');observer.unobserve(e.target);}}),{threshold:.06,rootMargin:'0px 0px 70px 0px'});
    all('main section, .nl-view-body > .row, .nl-view-body > .card, .nl-view-body > section').forEach((el,i)=>{if(el.closest('.collapse:not(.show),.modal'))return;el.classList.add('nl-motion-reveal');observer.observe(el);});
  }
  all('[data-bs-toggle="tooltip"]').forEach(el=>{if(window.bootstrap?.Tooltip) new bootstrap.Tooltip(el);});
 };
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',run);else run();
})();
</script>
