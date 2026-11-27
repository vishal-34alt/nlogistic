<%-- Shared progressive UI interactions. No extra JavaScript file or permissions bypass. --%>
<script>
(function(){'use strict';
  const doc=document, one=(s,r=doc)=>r.querySelector(s), all=(s,r=doc)=>Array.from(r.querySelectorAll(s));
  function start(){
    const menu=one('#nlMenuToggle');
    if(menu){
      let collapsed=false;
      try{collapsed=localStorage.getItem('nl.universal.sidebar.collapsed')==='1';}catch(ignore){}
      const apply=()=>{doc.body.classList.toggle('nl-sidebar-collapsed',collapsed);menu.setAttribute('aria-expanded',String(!collapsed));menu.title=collapsed?'Expand navigation':'Collapse navigation';
        menu.setAttribute('aria-controls',matchMedia('(min-width:992px)').matches?'nlSidebarCol':'nlMobileNav');};
      const clearStaleNavigation=()=>{
        if(!matchMedia('(min-width:992px)').matches)return;
        doc.body.classList.remove('menu-open');
        const mobile=one('#nlMobileNav');if(mobile&&window.bootstrap){const instance=window.bootstrap.Offcanvas.getInstance(mobile);if(instance)instance.hide();}
        // Only offcanvas backdrops. Never interfere with an actual payment/account modal.
        doc.querySelectorAll('.offcanvas-backdrop').forEach(backdrop=>backdrop.remove());
        // Browser repaint can complete after Bootstrap's offcanvas hide transition.
        window.requestAnimationFrame(()=>doc.querySelectorAll('.offcanvas-backdrop').forEach(backdrop=>backdrop.remove()));
        if(!one('.modal.show')){doc.body.classList.remove('modal-open');doc.body.style.removeProperty('overflow');doc.body.style.removeProperty('padding-right');}
      };
      clearStaleNavigation();apply();menu.addEventListener('click',e=>{if(!matchMedia('(min-width:992px)').matches){
          if(window.bootstrap){const mobile=one('#nlMobileNav');if(mobile)window.bootstrap.Offcanvas.getOrCreateInstance(mobile).show();}
          return;
        }
        e.preventDefault();e.stopPropagation();clearStaleNavigation();collapsed=!collapsed;apply();
        try{localStorage.setItem('nl.universal.sidebar.collapsed',collapsed?'1':'0');}catch(ignore){}
      });
      window.addEventListener('resize',()=>{if(window.matchMedia('(min-width:992px)').matches){
        clearStaleNavigation();apply();
      }},{passive:true});
    }
    all('.nl-side-group .nl-side-toggle').forEach(button=>{
      const panel=one('.nl-side-children',button.closest('.nl-side-group'));if(!panel)return;
      button.addEventListener('click',()=>{const open=button.getAttribute('aria-expanded')!=='true';
        button.setAttribute('aria-expanded',String(open));panel.hidden=!open;});
    });
    // Bootstrap modals must be direct body children: animated page wrappers establish
    // stacking contexts and otherwise leave the backdrop above the dialog.
    all('.nl-view-body .modal, .content-wrap .modal').forEach(modal=>doc.body.appendChild(modal));
    const userModal=one('#updateModal');
    if(userModal){
      userModal.addEventListener('show.bs.modal',e=>{
        const source=e.relatedTarget,id=source&&source.getAttribute('data-id');
        const hidden=one('#updateUserId',userModal);if(hidden)hidden.value=id||'';
        const title=one('.modal-title',userModal);if(title)title.textContent='Edit user #'+(id||'');
        const values={nlBulkName:'name',nlBulkEmail:'email',nlBulkPhone:'phone',nlBulkStatus:'status'};
        Object.entries(values).forEach(([field,attr])=>{
          const input=one('#'+field,userModal);if(input)input.value=source?.getAttribute('data-'+attr)||'';
        });
      });
    }
    // Every plain data table receives readable mobile labels; tables containing
    // interactive editors keep their original layout rather than corrupt form controls.
    all('.nl-view-body table.table').forEach(table=>{
      const headers=all('thead tr:first-child th',table).map(x=>x.textContent.trim());
      if(!headers.length||one('tbody form,tbody input,tbody select,tbody textarea',table))return;
      table.classList.add('nl-smart-table');
      all('tbody tr',table).forEach(tr=>all('td',tr).forEach((td,i)=>{if(!td.hasAttribute('data-label'))td.setAttribute('data-label',headers[i]||'Details');}));
    });
    // Every pricing-rule value remains visible when rows switch to responsive cards.
    if(doc.body.getAttribute('data-nl-screen')==='module3-pricing'){
      all('.nl-view-body table.table').forEach(table=>{
        const labels=all('thead th',table).map(th=>th.textContent.trim());
        all('tbody tr',table).forEach(tr=>all('td',tr).forEach((cell,i)=>{
          if(!cell.hasAttribute('data-label'))cell.setAttribute('data-label',labels[i]||'Details');
        }));
      });
    }
    // One authoritative Analytics scrollspy: never highlight two report links at once.
    // No sidebar scrolling/animation is triggered by page-scroll updates.
    if(location.pathname.endsWith('/analytics') || doc.body.getAttribute('data-nl-screen')==='module6-analytics'){
      const groups=all('.nl-side-group[data-u-menu="analytics"]');
      const links=groups.flatMap(g=>all('.nl-side-child',g));
      if(links.length){
        const reports=links.map(link=>{
          const href=link.getAttribute('href')||'';
          const match=href.match(/#(sales-trends|abc-classification|inventory-turnover|demand-forecast|profitability|profit-loss)$/);
          return match?{link:link,id:match[1],section:doc.getElementById(match[1])}:null;
        }).filter(item=>item&&item.section);
        // Sidebar link order may differ from the physical report order
        // (Profitability appears before Demand Forecast on this page).
        // Always track the order in the document, not the menu's order.
        reports.sort((a,b)=>a.section.compareDocumentPosition(b.section)&4?-1:1);
        const dashboardLink=links.find(link=>!link.hash&&/\/analytics(?:\?|$)/.test(link.getAttribute('href')||''));
        let queued=false,currentKey=null;
        function refreshAnalyticsNav(){
          queued=false;
          // A report becomes current as its heading enters the visible reading
          // zone below the sticky app header (not after it hides behind it).
          const header=one('.nl-app-header');
          const headerBottom=header?Math.max(0,header.getBoundingClientRect().bottom):0;
          const marker=Math.min(innerHeight-75,Math.max(230,headerBottom+90));
          let picked=null;
          for(const report of reports){if(report.section.getBoundingClientRect().top<=marker)picked=report;}
          // The final report may never reach the marker on short pages; when
          // scrolled to the very end, select the actual final report.
          if(reports.length && scrollY+innerHeight>=doc.documentElement.scrollHeight-20){
            picked=reports[reports.length-1];
          }
          const nextKey=picked?picked.id:'dashboard';
          if(currentKey===nextKey&&links.filter(link=>link.classList.contains('is-current')).length===1)return;
          currentKey=nextKey;
          for(const link of links){
            const active=picked?link===picked.link:link===dashboardLink;
            link.classList.toggle('is-current',active);
            if(active)link.setAttribute('aria-current','location');else link.removeAttribute('aria-current');
          }
        }
        function queueNav(){if(!queued){queued=true;requestAnimationFrame(refreshAnalyticsNav);}}
        addEventListener('scroll',queueNav,{passive:true});
        addEventListener('resize',queueNav,{passive:true});
        addEventListener('hashchange',()=>{queueNav();setTimeout(queueNav,300);});
        reports.forEach(r=>r.link.addEventListener('click',()=>{setTimeout(queueNav,80);setTimeout(queueNav,420);}));
        refreshAnalyticsNav();
        setTimeout(refreshAnalyticsNav,120);
      }
    }
    // A selected container shows immediately in the edit form: no internal ID memorization.
    all('table tbody tr').forEach(tr=>{const select=one('#nlUpdateContainer');if(!select)return;
      const first=one('td',tr);if(!first)return;const match=first.textContent.match(/ID:\s*(\d+)/i);
      if(!match)return;first.style.cursor='pointer';first.title='Click to edit container #'+match[1];
      first.addEventListener('click',e=>{if(e.target.closest('a,button,input'))return;select.value=match[1];
        if(select.value){select.scrollIntoView({behavior:'smooth',block:'center'});select.focus({preventScroll:true});}});
    });
    // Underline meaningful numbers and keep currency aligned across the application.
    all('.nl-view-body table').forEach(table=>{
      const cells=all('thead th',table),right=[];
      cells.forEach((th,i)=>{if(/^(amount|price|total|paid|balance|cost|value|quantity|weight|volume|revenue|count|margin|tax|claimed|approved|available|damaged)/i.test(th.textContent.trim()))right.push(i);});
      all('tbody tr',table).forEach(tr=>{const tds=all('td',tr);right.forEach(i=>{if(tds[i]&&!one('input,textarea,select',tds[i]))tds[i].classList.add('nl-numeric-cell');});});
    });
    // Consistent, noninvasive QoL: feedback on mandatory controls without introducing new inputs.
    all('.nl-view-body input[required], .nl-view-body select[required], .nl-view-body textarea[required]').forEach(field=>{
      if(field.type==='hidden' || field.dataset.nlRequiredEnhanced)return;
      field.dataset.nlRequiredEnhanced='true';
      if(!field.hasAttribute('aria-required'))field.setAttribute('aria-required','true');
      const valid=()=>field.classList.toggle('nl-field-valid',field.value.trim().length>0 && field.checkValidity());
      field.addEventListener('change',valid);field.addEventListener('blur',valid);
    });
    // Preserve all form actions while preventing accidental repeated submissions.
    all('.nl-view-body form[method="post"], .nl-view-body form[method="POST"]').forEach(form=>{
      if(form.dataset.nlNoSubmitLock==='true')return;
      form.addEventListener('submit',e=>{
        if(e.defaultPrevented || !form.checkValidity() || form.dataset.nlSubmitting==='true')return;
        // Queue this check after other listeners have had a chance to cancel a review dialog.
        setTimeout(()=>{
          if(e.defaultPrevented)return;
          form.dataset.nlSubmitting='true';
          const btn=e.submitter || form.querySelector('button[type="submit"]');
          if(btn){btn.classList.add('nl-form-wait');btn.setAttribute('aria-busy','true');}
        },0);
      });
    });
    // Make complex screens discoverable: jump between actual page sections.
    const headings=all('.nl-view-body h2[id], .nl-view-body h3[id]').filter(h=>h.offsetParent!==null);
    const portTabOnly=doc.body.dataset.nlScreen==='module1-infrastructure' && (new URLSearchParams(location.search).get('tab')||'ports').toLowerCase()==='ports';
    if(doc.body.dataset.nlScreen!=='module1-profile' && !portTabOnly && headings.length>=4 && headings.length<=16 && !one('.nl-section-index') && !one('#nlSmartBooking')){
      const nav=doc.createElement('nav');nav.className='nl-section-index';nav.setAttribute('aria-label','Jump to page section');
      headings.slice(0,9).forEach(h=>{
        const a=doc.createElement('a');a.href='#'+encodeURIComponent(h.id);a.textContent=h.textContent.trim().slice(0,55);nav.appendChild(a);
      });
      const root=one('.nl-view-body');if(root)root.insertBefore(nav,root.firstChild);
    }
    all('.nl-side-main.is-current').forEach(link=>link.setAttribute('aria-current','location'));
    all('.alert[role="alert"],.alert[role="status"]').forEach(el=>{if(!el.hasAttribute('aria-live'))el.setAttribute('aria-live',el.classList.contains('alert-danger')?'assertive':'polite');});
    // Compact page tools, not three distracting duplicate toolbar actions.
    const view=one('.nl-view-body')||one('.nl-universal-module2 .content-wrap');
    if(view && !one('.nl-boardroom-tools',view)){
      const tools=doc.createElement('div');tools.className='nl-boardroom-tools';
      const details=doc.createElement('details');details.className='nl-page-tools';
      const summary=doc.createElement('summary');summary.textContent='Page tools';summary.setAttribute('aria-label','Open page tools');details.appendChild(summary);
      const menuPanel=doc.createElement('div');menuPanel.className='nl-page-tools-panel';
      [['Refresh page',()=>location.reload()],['Print current page',()=>window.print()]].forEach(([label,fn])=>{
        const b=doc.createElement('button');b.type='button';b.textContent=label;b.addEventListener('click',()=>{details.open=false;fn();});menuPanel.appendChild(b);
      });details.appendChild(menuPanel);tools.appendChild(details);
      // A single top metadata row: breadcrumb on the left, Page tools on the right.
      // Never create a separate empty toolbar row above the screen's hero card.
      const main=one('#nlMainColumn');
      const mainCrumb=main?Array.from(main.children).find(child=>
        child.getAttribute('aria-label')==='Breadcrumb' ||
        (child.classList.contains('small') && child.classList.contains('text-uppercase'))):null;
      const localCrumb=!mainCrumb?(one(':scope > .bread',view)||one(':scope > .nl-breadcrumb',view)):null;
      if(mainCrumb || localCrumb){
        const row=doc.createElement('div');row.className='nl-page-meta-row';
        if(mainCrumb){main.insertBefore(row,view);row.appendChild(mainCrumb);}
        else {view.insertBefore(row,view.firstChild);row.appendChild(localCrumb);}
        row.appendChild(tools);
      }else view.insertBefore(tools,view.firstChild);
      doc.addEventListener('click',e=>{if(details.open&&!details.contains(e.target))details.open=false;});
    }
    // Discoverable quick-navigation suggestions, sourced ONLY from the server-rendered
    // role-allowed sidebar. Typed searches still use the database-backed search route.
    const headerInput=one('#nlWorkspaceSearch'),mobileInput=one('#nlMobileSearch');
    const shortcuts=all('.nl-side-main,.nl-side-child').filter(a=>a.href).map(a=>({
      title:a.textContent.trim().replace(/\s+/g,' '),url:a.href
    }));
    const addSuggest=(input)=>{
      if(!input)return;
      input.setAttribute('autocomplete','off');
      const host=input.closest('form');if(!host)return;
      host.classList.add('nl-search-host');
      const panel=doc.createElement('div');panel.className='nl-search-suggestions';panel.hidden=true;panel.setAttribute('role','listbox');panel.setAttribute('aria-label','Matching workspace pages');host.appendChild(panel);
      let active=0,choices=[];
      const show=()=>{
        const term=input.value.toLowerCase().trim();panel.replaceChildren();choices=[];active=0;
        if(term.length<2){panel.hidden=true;return;}
        const seen=new Set();shortcuts.filter(x=>x.title.toLowerCase().includes(term)).slice(0,6).forEach(x=>{
          if(seen.has(x.url))return;seen.add(x.url);choices.push(x);
          const a=doc.createElement('a');a.className='nl-search-suggestion';a.href=x.url;a.setAttribute('role','option');
          const name=doc.createElement('span');name.textContent=x.title;const tag=doc.createElement('small');tag.textContent='Open page';a.append(name,tag);panel.appendChild(a);
        });
        if(choices.length){const note=doc.createElement('div');note.className='nl-search-hint';note.textContent='Press Enter to search records, or choose a matching page';panel.appendChild(note);}
        panel.hidden=!choices.length;
      };
      input.addEventListener('input',show);input.addEventListener('focus',show);
      input.addEventListener('keydown',e=>{if(e.key==='Escape'){panel.hidden=true;return;}
        if(e.key==='ArrowDown'&&!panel.hidden){e.preventDefault();one('a',panel)?.focus();}
      });
      panel.addEventListener('keydown',e=>{if(e.key==='Escape'){e.preventDefault();panel.hidden=true;input.focus();}});
      doc.addEventListener('click',e=>{if(!host.contains(e.target))panel.hidden=true;});
    };
    addSuggest(headerInput);addSuggest(mobileInput);
    doc.addEventListener('keydown',e=>{
      if((e.ctrlKey||e.metaKey)&&e.key.toLowerCase()==='k'){
        if(headerInput&&headerInput.offsetParent!==null){e.preventDefault();headerInput.focus();headerInput.select();}
        else if(window.bootstrap){const mobile=one('#nlMobileNav');if(mobile){e.preventDefault();window.bootstrap.Offcanvas.getOrCreateInstance(mobile).show();setTimeout(()=>mobileInput?.focus(),170);}}
      }
    });
    if(!one('.nl-backtop,.nl-universal-backtop')){
    const scroll=doc.createElement('button');scroll.type='button';scroll.className='nl-universal-backtop';scroll.textContent='Top';scroll.setAttribute('aria-label','Back to top');doc.body.appendChild(scroll);
    const sync=()=>scroll.classList.toggle('is-visible',window.scrollY>510);
    addEventListener('scroll',sync,{passive:true});sync();scroll.addEventListener('click',()=>window.scrollTo({top:0,behavior:matchMedia('(prefers-reduced-motion: reduce)').matches?'auto':'smooth'}));
    }
  }
  if(doc.readyState==='loading')doc.addEventListener('DOMContentLoaded',start);else start();
})();
</script>

<%-- Themed, accessible, single-confirmation control for all registered dangerous actions. --%>
<script>
(function(){'use strict';
 let active=null, previousFocus=null;
 function ensure(){
   let backdrop=document.getElementById('nlSafeConfirmation');if(backdrop)return backdrop;
   backdrop=document.createElement('div');backdrop.id='nlSafeConfirmation';backdrop.className='nl-safe-confirm';backdrop.hidden=true;
   backdrop.innerHTML='<div class="nl-safe-confirm-card" role="dialog" aria-modal="true" aria-labelledby="nlConfirmTitle" aria-describedby="nlConfirmMessage" tabindex="-1">'+
      '<span class="nl-confirm-label">N-LOGISTIC / PLEASE REVIEW</span><h2 id="nlConfirmTitle">Confirm action</h2><p id="nlConfirmMessage"></p>'+
      '<div class="nl-safe-confirm-actions"><button type="button" data-site-cancel>Cancel</button><button type="button" data-site-proceed>Confirm action</button></div></div>';
   document.body.appendChild(backdrop);
   backdrop.querySelector('[data-site-cancel]').addEventListener('click',close);
   backdrop.querySelector('[data-site-proceed]').addEventListener('click',()=>{
      if(!active)return;const pending=active;active=null;close();
      const form=pending.form;if(!form.isConnected)return;
      form.dataset.nlConfirmedByReview='true';
      if(form.requestSubmit){
         const submitter=pending.submitter;
         if(submitter && submitter.form===form && !submitter.disabled)form.requestSubmit(submitter);
         else form.requestSubmit();
      }else HTMLFormElement.prototype.submit.call(form);
   });
   backdrop.addEventListener('click',e=>{if(e.target===backdrop)close();});
   document.addEventListener('keydown',e=>{
      if(backdrop.hidden)return;
      if(e.key==='Escape'){e.preventDefault();close();}
      if(e.key==='Tab'){const a=Array.from(backdrop.querySelectorAll('button:not([disabled])'));const first=a[0],last=a[a.length-1];
        if(e.shiftKey&&document.activeElement===first){e.preventDefault();last.focus();}
        else if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first.focus();}}
   });
   return backdrop;
 }
 function close(){const backdrop=document.getElementById('nlSafeConfirmation');if(backdrop)backdrop.hidden=true;
   document.body.classList.remove('nl-site-confirm-open');active=null;if(previousFocus&&previousFocus.isConnected)previousFocus.focus();previousFocus=null;}
 window.nlShowSiteConfirm=function(form,message,submitter){
   if(!form||form.dataset.nlConfirmedByReview==='true')return false;
   const overlay=ensure();previousFocus=document.activeElement;
   const button=submitter || form.querySelector('button[type="submit"]');
   active={form,submitter:button};
   overlay.querySelector('#nlConfirmTitle').textContent=form.dataset.nlConfirmTitle||'Confirm action';
   overlay.querySelector('#nlConfirmMessage').textContent=message||'Are you sure you want to continue?';
   overlay.querySelector('[data-site-proceed]').textContent=/delete|remove|deactivate/i.test(message)?'Yes, continue':'Confirm action';
   overlay.hidden=false;document.body.classList.add('nl-site-confirm-open');overlay.querySelector('[data-site-cancel]').focus();
   return true;
 };
})();
</script>

<%-- v17 QOL: required warnings and common compact animated workspace hero; no separate assets. --%>
<script>
(function(){'use strict';
 const doc=document;
 function text(s){return String(s||'').replace(/\s+/g,' ').trim();}
 function fieldName(field){
   const id=field.id;const label=id?Array.from(doc.querySelectorAll('label')).find(x=>x.htmlFor===id):field.closest('label');
   return text(label?.textContent||field.getAttribute('aria-label')||field.getAttribute('placeholder')||field.name||'Required field').replace(/\*/g,'').slice(0,90);
 }
 function warning(label,message){
   let box=doc.getElementById('nlRequiredWarning');
   if(!box){box=doc.createElement('div');box.className='nl-field-warning';box.id='nlRequiredWarning';box.setAttribute('role','alert');
     box.innerHTML='<strong>Required information missing</strong><p></p><button type="button">Got it</button>';
     box.querySelector('button').addEventListener('click',()=>box.remove());doc.body.appendChild(box);}
   box.querySelector('p').textContent=label+': '+message;
   clearTimeout(box._auto);box._auto=setTimeout(()=>{if(box.isConnected)box.remove();},6000);
 }
 function enhanceFields(){
   Array.from(doc.querySelectorAll('input[required],select[required],textarea[required]')).forEach(input=>{
     if(input.type==='hidden'||input.type==='checkbox'||input.type==='radio'||input.dataset.nlWarnReady)return;
     input.dataset.nlWarnReady='true';
     const id=input.id;let label=id?doc.querySelector('label[for="'+(window.CSS?.escape?CSS.escape(id):id)+'"]'):input.closest('label');
     if(!label){const parent=input.closest('.col,.field,.col-md-6,.col-12,.form-group');if(parent)label=parent.querySelector('label');}
     if(label&&!label.querySelector('.nl-required,.nl-required-top')&&!/\*/.test(label.textContent)){
       const star=doc.createElement('span');star.className='nl-required-top';star.textContent='*';star.title='Required field';star.setAttribute('aria-hidden','true');const controlChild=Array.from(label.children).find(child=>child===input||child.contains(input));if(controlChild)label.insertBefore(star,controlChild);else label.appendChild(star);
     }
     input.addEventListener('input',()=>{if(input.validity.valid){input.classList.remove('nl-field-invalid');input.removeAttribute('aria-invalid');}});
   });
   doc.addEventListener('invalid',event=>{
     const input=event.target;if(!(input instanceof HTMLElement)||!input.matches('input,textarea,select'))return;
     input.classList.add('nl-field-invalid');input.setAttribute('aria-invalid','true');
     // Inline error is owned by initFields() for forms. Avoid a second global
     // warning/toast while the browser checks incomplete email input.
     if(!input.closest('form'))warning(fieldName(input),input.validity.valueMissing?'This field cannot be left empty.':input.validationMessage||'Please enter a valid value.');
   },true);
 }
 function autoHero(){
   const screen=(doc.body.dataset.nlScreen||'').toLowerCase();
   if(/login|register|print|error|module2-module2error/.test(screen))return;
   // The account page has its own compact identity header; do not inject a large security illustration into it.
   if(screen==='module1-profile')return;
   const host=doc.querySelector('.nl-view-body')||doc.querySelector('.content-wrap');
   if(!host)return;
   const catalog={
     'module1-users':['users','Access & identity','Manage user accounts and account permissions.'],
     'module1-companies':['companies','Partner directory','Manage Seller and Consumer companies.'],
     'module1-customers':['customers','Customer records','Manage customer and billing contacts.'],
     'module1-dashboard':['admin','Admin workspace','Your administration overview.'],
     'module1-audit-log':['audit','Activity history','Inspect recent account and business changes.'],
     'module1-infrastructure':['ports','Ports & vessels','Manage the maritime network.'],
     'module1-profile':['profile','Account settings','Manage your personal details and security.'],
     'module1-workspace-search':['search','Workspace search','Find authorized records and pages.'],
     'module2-shipmentmanagement':['shipments','Shipment operations','Follow your shipment progress.'],
     'module2-movementtracking':['route','Movement history','Review verified journey checkpoints.'],
     'module2-movementupdate':['checkpoint','Movement update','Record a shipment movement checkpoint.'],
     'module2-profitlossdashboard':['finance','Financial performance','Review revenue, costs and profit together.'],
     'module3-booking':['booking','Booking','Plan your shipment from product to confirmation.'],
     'module3-booking-result':['confirmation','Booking confirmed','Review your next steps and invoice.'],
     'module3-containers':['containers','Container directory','Manage capacity and available containers.'],
     'module3-pricing':['pricing','Pricing rules','Review route pricing and freight rates.'],
     'module3-pricing-audit':['priceaudit','Price history','Review historical pricing changes.'],
     'module4-dashboard':['stock','Inventory','Stock and product overview.'],
     'module4-import':['import','Import inventory','Bring new stock records into the system.'],
     'module4-import-result':['importresult','Import results','Review the outcome of each uploaded row.'],
     'module4-ledger':['ledger','Stock ledger','Review stock movements and adjustments.'],
     'module4-product-form':['product','Product details','Keep product information accurate.'],
     'module4-sales':['sales','Sales records','Review sales and quantity changes.'],
     'module4-stock-form':['stockadd','New stock','Add stock to your inventory.'],
     'module4-summary':['stocksummary','Stock valuation','Review shipment stock and value.'],
     'module5-create':['invoicecreate','New invoice','Create a commercial invoice.'],
     'module5-details':['invoice','Invoice details','View the invoice and its recorded payments.'],
     'module5-invoices':['invoices','Invoices','Manage open and settled invoices.'],
     'module5-payments':['payments','Payments','Review amounts paid and remaining.'],
     'module6-analytics':['analytics','Analytics','Explore business reports and charts.'],
     'module7-claims':['claims','Claims register','Track cargo claims and their status.'],
     'module7-claim_details':['claimdetail','Claim inspection','Review evidence and settlement details.'],
     'module7-submit_claim':['claimfile','New claim','Submit your evidence for review.']
   };
   const item=catalog[screen]||['workspace','Workspace','Manage this workspace.'];
   const query=new URLSearchParams(location.search);
   const scene=screen==='module1-infrastructure' && query.get('tab')==='vessels'?'vessels':
     screen==='module5-invoices' && query.get('action')==='outstanding'?'outstanding':item[0];
   const artSelectors='.nl-scene-art,.cc-hero-art,.cu-hero-art,.i-hero-visual,.na-hero-art,.uh-art,.a-hero-art,.hero-art,.nl-analytics-art,.nl-claim-hero-art,.i-hero-art';
   const alreadyCustomized='.cc-hero,.cu-hero,.i-hero,.na-hero,.nl-user-hero,.nl-analytics-hero,.nl-claim-top,.nl-ops-hero,.page-hero,.nl-page-hero,.nl-claims-hero,.nl-bill-hero,.a-hero';
   let existing=host.querySelector(alreadyCustomized);
   const pageHeading=host.querySelector('.page-heading:not(.page-hero)');
   // Reuse headings from already-developed screens, rather than injecting a second header.
   if(!existing && pageHeading)existing=pageHeading;
   if(!existing){
     let shared=host.querySelector('.nl-shared-page-header');
     if(shared)existing=shared;
   }
   if(!existing){
     const claimHead=host.querySelector('.nl-claims-content > .d-flex');
     if(claimHead && claimHead.querySelector('h1'))existing=claimHead;
   }
   if(!existing){
     const direct=Array.from(host.children).find(function(el){
       if(!el.matches)return false;
       if(el.matches('header') && el.querySelector('h1,h2'))return true;
       if(el.matches('section') && el.querySelector('h1,h2') && !el.querySelector('form,table'))return true;
       return false;
     });
     if(direct)existing=direct;
   }
   if(existing){
     const sharedHeading=host.querySelector('.nl-shared-page-header');
     if(sharedHeading && sharedHeading!==existing){
       // A feature page has a more specific, informative heading. Never show both.
       sharedHeading.hidden=true;
     }
     // Some customized pages already have their own exact illustration. Keep it.
     existing.dataset.nlScene=scene;
     if(existing.classList.contains('page-hero') || existing.classList.contains('cc-hero') ||
        existing.classList.contains('cu-hero') || existing.classList.contains('i-hero') ||
        existing.classList.contains('na-hero') || existing.classList.contains('nl-analytics-hero'))return;
     existing.classList.add('nl-screen-hero');
     existing.dataset.nlScene=scene;
     if(!existing.querySelector(artSelectors))addArt(existing,scene);
     // Shared Module 3 directory headings often repeat the exact same title below.
     // Keep nearby action buttons; suppress only the redundant heading text.
     if(existing===sharedHeading){
       const normalized=function(v){return String(v||'').toLowerCase().replace(/[^a-z0-9]+/g,' ').trim();};
       const canonical=normalized(existing.querySelector('h1')?.textContent);
       if(canonical)Array.from(host.querySelectorAll('h2,h3')).slice(0,12).forEach(function(title){
         if(existing.contains(title)||normalized(title.textContent)!==canonical)return;
         title.classList.add('visually-hidden');
       });
     }
     return;
   }
   // Pages that lack a standalone header are given a compact, page-specific hero.
   // The original section headings stay in place when they describe a separate task.
   const hero=doc.createElement('section');hero.className='nl-auto-hero nl-screen-hero';hero.dataset.nlScene=scene;
   const copy=doc.createElement('div');copy.className='nl-auto-copy';
   const kicker=doc.createElement('small');kicker.textContent='N-LOGISTIC / '+item[1].toUpperCase();
   let target=host.querySelector('h1');
   let raw=target?text(target.textContent):text(doc.title.split('|')[0]);
   if(!raw || raw.length>70)raw=item[1];
   const h=doc.createElement('h1');h.textContent=raw;
   const p=doc.createElement('p');p.textContent=item[2];
   copy.append(kicker,h,p);hero.appendChild(copy);addArt(hero,scene);
   const breadcrumb=host.querySelector(':scope > .bread,:scope > .breadcrumb,:scope > nav[aria-label="Breadcrumb"]');
   if(breadcrumb)breadcrumb.insertAdjacentElement('afterend',hero);else host.insertBefore(hero,host.firstChild);
   // Don't leave the original identical H1 immediately under the hero as a duplicate.
   if(target && target!==h && text(target.textContent).toLowerCase()===raw.toLowerCase())target.classList.add('visually-hidden');
 }
 function addArt(hero,scene){
   const motif={users:'people',companies:'building',customers:'people',admin:'report',audit:'audit',ports:'port',vessels:'ship',profile:'security',search:'search',shipments:'ship',route:'route',checkpoint:'check',finance:'finance',booking:'route',confirmation:'check',containers:'cargo',pricing:'price',priceaudit:'audit',stock:'cargo',import:'import',importresult:'check',ledger:'ledger',product:'product',sales:'sales',stockadd:'cargo',stocksummary:'report',invoicecreate:'invoice',invoice:'invoice',invoices:'invoice',outstanding:'payment',payments:'payment',analytics:'report',claims:'claim',claimdetail:'audit',claimfile:'claim',workspace:'report',saletrend:'report',abc:'report',turnover:'report',productprofit:'finance',forecast:'route',pandl:'finance'};
   const art=doc.createElement('div');art.className='nl-scene-art';art.dataset.nlScene=scene;art.dataset.nlMotif=motif[scene]||'report';
   art.setAttribute('aria-hidden','true');
   ['plate','shape','detail','spark','line'].forEach(function(label){
     const node=doc.createElement('span');node.className='nl-scene-'+label;art.appendChild(node);
   });
   hero.appendChild(art);
 }
 function reportScenes(){
   if((doc.body.dataset.nlScreen||'')!=='module6-analytics')return;
   const mapping={'sales-trends':'saletrend','abc-classification':'abc','inventory-turnover':'turnover','profitability':'productprofit','demand-forecast':'forecast','profit-loss':'pandl'};
   Object.keys(mapping).forEach(function(id){
     const section=doc.getElementById(id);if(!section)return;
     const header=section.querySelector('.panel-heading');if(!header||header.querySelector('.nl-report-scene'))return;
     header.classList.add('nl-scene-report-heading');
     const small=doc.createElement('span');small.className='nl-report-scene';small.setAttribute('aria-hidden','true');
     const name=mapping[id];small.dataset.nlScene=name;
     ['bar-a','bar-b','bar-c','mark'].forEach(function(cls){const node=doc.createElement('i');node.className='nl-mini-'+cls;small.appendChild(node);});
     header.appendChild(small);
   });
 }
 function run(){try{enhanceFields();autoHero();reportScenes();}catch(e){console.error('N-LOGISTIC shared accessibility QOL',e);}}
 if(doc.readyState==='loading')doc.addEventListener('DOMContentLoaded',run);else run();
})();
</script>

<%-- N-LOGISTIC v18.0: five-phase additive enhancements, progressive and browser-only. --%>
<script id="nlV18Script">
(function(){'use strict';
  var doc=document,body=doc.body;
  if(!body || !body.getAttribute('data-nl-screen') || body.getAttribute('data-nl-enhanced')!=='true')return;
  var screen=body.dataset.nlScreen||'',base=doc.querySelector('.nl-view-body')||doc.querySelector('.content-wrap');
  if(!base)return;
  var one=(s,r)=> (r||doc).querySelector(s);
  var all=(s,r)=>Array.from((r||doc).querySelectorAll(s));
  var make=(tag,cls,txt)=>{var x=doc.createElement(tag);if(cls)x.className=cls;if(txt!==undefined)x.textContent=txt;return x;};
  var clean=t=>String(t||'').replace(/\s+/g,' ').trim();
  var safeGet=(key,session)=>{try{return JSON.parse((session?sessionStorage:localStorage).getItem(key)||'null');}catch(e){return null;}};
  var safeSet=(key,value,session)=>{try{(session?sessionStorage:localStorage).setItem(key,JSON.stringify(value));}catch(e){}};
  var role=clean(one('.nl-account-identity strong')?.textContent || one('.sidebar .role')?.textContent || 'workspace');
  var sessionKey='nl18-links:'+role+':'+clean(one('.nl-account-identity span')?.textContent||'');
  var scope=one('#nlMainColumn')||base;
  var navLinks=all('.nl-side-main[href],.nl-side-child[href],.nl-header-dropdown a[href]');
  var nav=[];var seen={};
  navLinks.forEach(a=>{
    try{var url=new URL(a.href,location.href);if(url.origin!==location.origin || url.pathname.indexOf(location.pathname.split('/')[1])<0)return;
      var path=url.pathname+url.search;
      if(seen[path])return;seen[path]=true;
      nav.push({url:path,title:clean(a.textContent).slice(0,85)||'Workspace page'});
    }catch(e){}
  });
  function addButton(text,fn,cls){var b=make('button',cls||'nl18-mini-btn',text);b.type='button';b.addEventListener('click',fn);return b;}
  function openOverlay(title,subtitle,build){
    var outer=make('div','nl18-overlay'),panel=make('div','nl18-modal'),head=make('div','nl18-modal-head'),block=make('div');
    outer.tabIndex=-1;outer.setAttribute('role','presentation');
    panel.setAttribute('role','dialog');panel.setAttribute('aria-modal','true');panel.tabIndex=-1;
    var kicker=make('div','nl18-eyebrow',subtitle||'N-LOGISTIC / WORKSPACE');
    var heading=make('h2','',title);heading.id='nl18Heading'+Math.floor(Math.random()*1000000);panel.setAttribute('aria-labelledby',heading.id);
    block.append(kicker,heading);var close=addButton('\u00d7',shut,'nl18-modal-close');close.setAttribute('aria-label','Close dialog');
    head.append(block,close);panel.appendChild(head);outer.appendChild(panel);
    var active=doc.activeElement;
    function shut(){outer.remove();doc.removeEventListener('keydown',keys,true);try{active?.focus({preventScroll:true});}catch(e){}}
    function keys(e){if(e.key==='Escape'){e.preventDefault();shut();}else if(e.key==='Tab'){
      var items=all('a[href],button:not([disabled]),input:not([disabled]),select:not([disabled]),summary',panel).filter(x=>x.offsetParent!==null);
      if(!items.length){e.preventDefault();panel.focus();return;}
      if(e.shiftKey&&doc.activeElement===items[0]){e.preventDefault();items[items.length-1].focus();}
      else if(!e.shiftKey&&doc.activeElement===items[items.length-1]){e.preventDefault();items[0].focus();}
    }}
    outer.addEventListener('click',e=>{if(e.target===outer)shut();});
    build(panel,shut);
    doc.body.appendChild(outer);doc.addEventListener('keydown',keys,true);close.focus();return outer;
  }
  function openLinkDialog(type){
    var valid=nav.map(x=>x.url),items=(safeGet(sessionKey+':'+type,true)||[]).filter(x=>valid.indexOf(x.url)>=0);
    openOverlay(type==='favorites'?'Pinned workspace pages':'Recently visited pages','NAVIGATION / '+(type==='favorites'?'FAVORITES':'RECENT'),(panel,close)=>{
      var desc=make('p','nl18-muted',items.length?'Choose a page. Each destination enforces your normal permissions.':'No pages saved yet. Use Page tools to pin pages from your navigation.');panel.appendChild(desc);
      var list=make('div','nl18-command-items');items.forEach(x=>{var a=make('a','',x.title);a.href=x.url;list.appendChild(a);});panel.appendChild(list);
      var actions=make('div','nl18-modal-actions');actions.appendChild(addButton('Close',close));panel.appendChild(actions);
    });
  }
  function initNavigation(){
    var current=nav.find(x=>x.url===location.pathname+location.search)||null;
    var recent=(safeGet(sessionKey+':recent',true)||[]).filter(x=>nav.some(n=>n.url===x.url));
    if(current){recent=[current].concat(recent.filter(x=>x.url!==current.url)).slice(0,6);safeSet(sessionKey+':recent',recent,true);}
    var panel=one('.nl-page-tools-panel');
    if(panel && !one('.nl18-tool-anchor',panel)){
      var divider=make('div','nl18-divider nl18-tool-anchor');panel.appendChild(divider);
      var favoriteButton=addButton('\u2606 Pin this page',()=>{
        if(!current)return;var favorites=safeGet(sessionKey+':favorites',true)||[],already=favorites.some(x=>x.url===current.url);
        favorites=already?favorites.filter(x=>x.url!==current.url):[current].concat(favorites).slice(0,10);
        safeSet(sessionKey+':favorites',favorites,true);favoriteButton.textContent=already?'\u2606 Pin this page':'\u2605 Unpin this page';
      });
      if(current){var currentPinned=(safeGet(sessionKey+':favorites',true)||[]).some(x=>x.url===current.url);if(currentPinned)favoriteButton.textContent='\u2605 Unpin this page';panel.appendChild(favoriteButton);}
      panel.appendChild(addButton('\u2605 Pinned pages',()=>openLinkDialog('favorites')));
      panel.appendChild(addButton('\u21b6 Recently visited',()=>openLinkDialog('recent')));
      panel.appendChild(addButton('\u2328 Page shortcuts',()=>openCommand(true)));
      var dense=addButton('\u2195 Display: Standard',()=>{
        var order=['standard','compact','spacious'],at=order.indexOf(safeGet('nl18-density',false)||'standard');setDensity(order[(at+1)%order.length]);dense.textContent='\u2195 Display: '+cap(order[(at+1)%order.length]);
      });panel.appendChild(dense);
      function cap(s){return s.charAt(0).toUpperCase()+s.slice(1);}
      dense.textContent='\u2195 Display: '+cap(safeGet('nl18-density',false)||'standard');
    }
    function setDensity(value){body.classList.remove('nl18-dense-compact','nl18-dense-standard','nl18-dense-spacious');body.classList.add('nl18-dense-'+value);safeSet('nl18-density',value,false);}
    setDensity(['compact','standard','spacious'].includes(safeGet('nl18-density',false))?safeGet('nl18-density',false):'standard');
    doc.addEventListener('keydown',function(e){if((e.ctrlKey||e.metaKey)&&e.shiftKey&&e.key.toLowerCase()==='p'&&!e.altKey){e.preventDefault();openCommand(false);}});
  }
  function openCommand(guide){
    openOverlay(guide?'Keyboard & workspace shortcuts':'Go to workspace page','ROLE-AUTHORIZED NAVIGATION',(panel,close)=>{
      var txt=make('p','nl18-muted','Ctrl+K focuses your existing search. Ctrl+Shift+P opens this page switcher. Escape closes it.');panel.appendChild(txt);
      var input=make('input','nl18-command-search');input.type='search';input.placeholder='Find a page already in your navigation';input.setAttribute('aria-label','Filter authorized pages');panel.appendChild(input);
      var list=make('div','nl18-command-items');panel.appendChild(list);
      function render(){list.replaceChildren();nav.filter(n=>n.title.toLowerCase().includes(input.value.trim().toLowerCase())).slice(0,22).forEach(n=>{
        var a=make('a','',n.title);a.href=n.url;list.appendChild(a);
      });if(!list.children.length)list.appendChild(make('p','nl18-muted','No matching page. The normal search can find records.'));
      }input.addEventListener('input',render);render();setTimeout(()=>input.focus(),0);
    });
  }
  function initWelcome(){
    if(screen!=='module1-dashboard')return;
    var main=one('main',base)||base;
    if(one('.nl18-page-welcome',main))return;
    var section=make('section','nl18-page-welcome');section.setAttribute('aria-label','Workspace overview and visual preferences');
    var identity=one('.nl-account-identity span'),name=clean(identity?.textContent||'');
    var text=make('div'),eyebrow=make('div','nl18-eyebrow','YOUR '+(role||'').toUpperCase()+' WORKSPACE');
    var h=make('h2','',name?'Welcome back, '+name:'Workspace overview');
    var p=make('p','',new Date().toLocaleDateString(undefined,{weekday:'long',year:'numeric',month:'long',day:'numeric'})+' \u00b7 Existing operational data, unchanged');
    text.append(eyebrow,h,p);var actions=make('div','nl18-mini-actions');
    actions.appendChild(addButton('Pinned pages',()=>openLinkDialog('favorites')));
    actions.appendChild(addButton('Browse workspace',()=>openCommand(false)));
    section.append(text,actions);main.insertBefore(section,main.firstChild);
    all('.nl-dash-kpi',main).forEach(el=>{if(el.hasAttribute('title'))return;var label=clean(one('.nl-kpi-label',el)?.textContent);if(label)el.title='Open '+label+' records. Values are supplied by the existing dashboard data.';});
  }
  function initSections(){
    // Port management intentionally has no generated "On this page" shortcut bar.
    // Vessel and all other modules retain the original navigation.
    if(screen==='module1-profile')return; // Account screen already has sections; avoid duplicate shortcut rows.
    if(screen==='module1-infrastructure' && (new URLSearchParams(location.search).get('tab')||'ports').toLowerCase()==='ports')return;
    if(one('.nl-section-index',base)||one('.nl18-section-jumps',base))return;
    var headings=all('h2,h3',base).filter(h=>!h.closest('.modal,.nl18-overlay,.nl-review-dialog,[hidden],.nl-auto-hero,.nl-screen-hero,.nl-analytics-report .nl-report-table-pane') && clean(h.textContent).length>=5 && clean(h.textContent).length<=75);
    var unique=new Set();headings=headings.filter(h=>{var text=clean(h.textContent).toLowerCase();if(unique.has(text))return false;unique.add(text);return true;}).slice(0,10);
    if(headings.length<4)return;
    var nav=make('nav','nl18-section-jumps');nav.setAttribute('aria-label','Jump to page sections');nav.appendChild(make('span','','On this page'));
    headings.forEach((h,i)=>{if(!h.id)h.id='nl18-section-'+i;var a=make('a','',clean(h.textContent).slice(0,38));a.href='#'+h.id;nav.appendChild(a);});
    var hero=one('.nl-screen-hero,.nl-page-hero,.nl-claims-hero,.cc-hero,.cu-hero,.i-hero,.nl-analytics-hero',base);
    if(hero)hero.insertAdjacentElement('afterend',nav);else base.insertBefore(nav,base.firstChild);
  }
  function initFields(){
    all('textarea[maxlength],input[maxlength]',base).forEach(el=>{
      if(el.type==='hidden'||el.type==='password'||el.type==='email'||el.type==='search'||el.closest('.nl-product-picker')||el.dataset.nl18Counter)return;
      var max=Number(el.maxLength);if(max<=0||max>2000 || el.type==='number')return;el.dataset.nl18Counter='true';
      var counter=make('small','nl18-field-counter');counter.setAttribute('aria-live','off');
      el.insertAdjacentElement('afterend',counter);
      function update(){counter.textContent=String(el.value.length)+' / '+max+' characters';counter.style.color=(max-el.value.length)<10?'#b44121':'';}
      el.addEventListener('input',update);update();
    });
    all('form',base).forEach(form=>{
      // Exactly one inline validation message per control, even after repeated
      // checkValidity()/reportValidity() calls or rapid typing. Never stack nodes.
      function findError(field){
        const id=field.dataset.nl18ErrorId;
        return id?doc.getElementById(id):null;
      }
      function clearError(field){
        const error=findError(field);if(error)error.remove();
        field.classList.remove('nl18-has-error','is-invalid','nl-field-invalid');
        field.removeAttribute('aria-invalid');
        const id=field.dataset.nl18ErrorId;
        if(id){field.removeAttribute('aria-errormessage');delete field.dataset.nl18ErrorId;}
      }
      form.addEventListener('invalid',function(e){
        const field=e.target;if(!field||!field.matches('input,textarea,select')||field.type==='hidden')return;
        field.classList.add('nl18-has-error');field.setAttribute('aria-invalid','true');
        let error=findError(field);
        if(!error){error=make('small','nl18-field-error');error.setAttribute('role','status');
          error.id='nl18-invalid-'+(field.id||Math.random().toString(36).slice(2));
          field.dataset.nl18ErrorId=error.id;
          // Keep message beside field, not in the input or behind a button.
          (field.closest('.i-picker-wrap,.i-combo')||field).insertAdjacentElement('afterend',error);
        }
        error.textContent=field.validity.valueMissing?'This field is required.':field.validationMessage||'Please enter a valid value.';
        field.setAttribute('aria-errormessage',error.id);
      },true);
      function onFieldUpdate(e){const field=e.target;if(!field?.matches?.('input,textarea,select'))return;
        // Do not call checkValidity() here; it can emit another invalid event.
        if(field.validity.valid)clearError(field);
        else {const error=findError(field);if(error)error.textContent=field.validationMessage||'Please enter a valid value.';}
      }
      form.addEventListener('input',onFieldUpdate);
      form.addEventListener('change',onFieldUpdate);
    });
    all('input[type=file]',base).forEach(el=>{
      if(el.dataset.nl18File)return;el.dataset.nl18File='true';
      var p=make('div','nl18-file-card');p.textContent='No file selected';el.insertAdjacentElement('afterend',p);
      el.addEventListener('change',()=>{var fs=Array.from(el.files||[]);p.textContent=fs.length?fs.map(f=>f.name+' ('+(f.size/1024/1024).toFixed(2)+' MB)').join(' \u00b7 '):'No file selected';});
    });
  }
  function initTables(){
    all('table',base).forEach((table,idx)=>{
      if(table.dataset.nl18Tools||table.closest('.nl-review-dialog,.nl18-overlay')||table.classList.contains('nl-calendar'))return;
      var cols=all('thead tr:first-child th',table),rows=all('tbody tr',table);
      if(cols.length<4||rows.length<2||cols.some(x=>Number(x.colSpan)>1)||rows.length>280||one('tbody form,tbody textarea,tbody select',table))return;
      table.dataset.nl18Tools='yes';
      var wrapper=table.closest('.table-responsive')||table;
      var toolbar=make('div','nl18-toolbar nl18-table-addons');toolbar.setAttribute('aria-label','Extra visual table controls');
      var info=make('span','nl18-table-status','Table display \u00b7 '+rows.length+' loaded rows');toolbar.appendChild(info);
      var density=make('select','nl18-mini-btn');density.setAttribute('aria-label','Table row density');
      ['standard','compact','spacious'].forEach(label=>{var o=make('option','',label[0].toUpperCase()+label.slice(1));o.value=label;density.appendChild(o);});
      density.value='standard';density.addEventListener('change',()=>{
        table.classList.remove('nl18-table-compact','nl18-table-spacious');if(density.value!=='standard')table.classList.add('nl18-table-'+density.value);
        table.style.setProperty('--nl18-row-padding',density.value==='compact'?'5px':density.value==='spacious'?'15px':'');
      });toolbar.appendChild(density);
      var chooser=make('details','');var summary=make('summary','','Columns \u25be');chooser.appendChild(summary);
      var options=make('div','nl18-column-menu');options.setAttribute('aria-label','Visible columns');
      cols.forEach((th,i)=>{
        var name=clean(th.textContent)||'Column '+(i+1);var label=make('label');
        var check=make('input');check.type='checkbox';check.checked=true;
        var isActions=/(action|manage|edit|view)/i.test(name)||i===0||i===cols.length-1;
        if(isActions){check.disabled=true;check.title='Always keep identifier/action columns visible';}
        var t=make('span','',name);label.append(check,t);options.appendChild(label);
        check.addEventListener('change',()=>{
          var shown=Array.from(options.querySelectorAll('input')).filter(x=>x.checked).length;
          if(shown<2){check.checked=true;return;}
          all('tr',table).forEach(tr=>{var c=tr.children[i];if(c && Number(c.colSpan)===1)c.hidden=!check.checked;});
        });
      });chooser.appendChild(options);toolbar.appendChild(chooser);
      toolbar.appendChild(addButton('Preview a row',()=>{
        var row=rows.find(r=>!r.hidden);if(!row)return;
        previewRow(table,row,cols);
      }));
      wrapper.parentNode?.insertBefore(toolbar,wrapper);
      table.addEventListener('dblclick',e=>{if(e.target.closest('a,button,input,select,textarea,summary'))return;
        var tr=e.target.closest('tbody tr');if(tr && !tr.hidden)previewRow(table,tr,cols);
      });
      var prior=toolbar.previousElementSibling;var search=(prior?.classList.contains('nl-table-toolbar')?one('.nl-table-search',prior):null) || one('[data-table-search="'+(table.id||'____')+'"]',base);
      if(search)search.addEventListener('input',()=>{
        var term=clean(search.value);setTimeout(()=>{
          var found=rows.filter(r=>!r.hidden).length;info.textContent=found+' / '+rows.length+' rows on this page';
          highlightVisible(table,term);
        },0);
      });
      var localSearch=prior?.classList.contains('nl-table-toolbar')?one('.nl-table-search',prior):null;
      if(localSearch&&localSearch.value)highlightVisible(table,localSearch.value);
    });
  }
  function highlightVisible(table,term){
    all('mark.nl18-tablemark',table).forEach(mark=>mark.replaceWith(doc.createTextNode(mark.textContent)));
    if(!term||term.length<2)return;term=term.trim().slice(0,65);var left=120;
    all('tbody tr',table).forEach(tr=>{
      if(tr.hidden || left<=0)return;
      all('td',tr).forEach(td=>{
        if(left<=0)return;
        var walker=doc.createTreeWalker(td,NodeFilter.SHOW_TEXT,{acceptNode(node){
          if(!node.parentElement||node.parentElement.closest('a,button,script,style,mark,input,textarea'))return NodeFilter.FILTER_REJECT;
          return node.nodeValue.toLowerCase().includes(term.toLowerCase())?NodeFilter.FILTER_ACCEPT:NodeFilter.FILTER_REJECT;
        }});var textNodes=[];while(walker.nextNode()&&textNodes.length<15)textNodes.push(walker.currentNode);
        textNodes.forEach(n=>{var original=n.nodeValue,offset=original.toLowerCase().indexOf(term.toLowerCase());if(offset<0)return;
          var fragment=doc.createDocumentFragment();fragment.append(doc.createTextNode(original.slice(0,offset)));
          fragment.append(make('mark','nl18-tablemark',original.slice(offset,offset+term.length)));
          fragment.append(doc.createTextNode(original.slice(offset+term.length)));n.replaceWith(fragment);left--;
        });
      });
    });
  }
  function previewRow(table,row,cols){
    var values=all('td',row),headers=cols.map(c=>clean(c.textContent));
    openOverlay('Record preview','READ ONLY / EXISTING TABLE',(panel,close)=>{
      panel.appendChild(make('p','nl18-muted','Information already displayed in this table. Existing View/Edit actions remain available.'));
      var dl=make('dl','nl18-modal-list');values.forEach((v,i)=>{if(!headers[i])return;
        var visible=v.cloneNode(true);all('[hidden],.visually-hidden,input[type=hidden],.nl18-preview-button',visible).forEach(x=>x.remove());
        dl.append(make('dt','',headers[i]),make('dd','',clean(visible.textContent.replace(/\b(Copy|Copied|Retry)\b/g,'')).slice(0,450)||'\u2014'));
      });panel.appendChild(dl);var footer=make('div','nl18-modal-actions');
      var link=one('a[href]',row);if(link){var target=make('a','nl18-mini-btn','Open original record');target.href=link.href;footer.appendChild(target);}
      footer.appendChild(addButton('Close',close));panel.appendChild(footer);
    });
  }
  function initBooking(){
    if(screen!=='module3-booking')return;
    var product=one('#nlBookingProduct'),qty=one('#nlBookingQuantity'),unit=one('#nlBookingUnitCbm'),origin=one('#nlBookingOrigin'),dest=one('#nlBookingDestination');
    if(!product||!qty||!unit)return;
    var card=one('.nl-booking-guidance',base)||one('form',base);if(!card)return;
    var glance=make('section','nl18-booking-glance');glance.setAttribute('aria-label','Booking selection snapshot');
    var intro=make('div');intro.append(make('div','nl18-eyebrow','BOOKING AT A GLANCE'),make('p','nl18-muted','Read-only summary of your current form. Final checks are performed on the server.'));
    var facts=make('div','nl18-booking-facts');var fields=['Goods','Quantity','Unit CBM','Route'];var outputs={};fields.forEach(t=>{var tile=make('div'),s=make('small','',t),v=make('strong','','Not selected');outputs[t]=v;tile.append(s,v);facts.appendChild(tile);});
    glance.append(intro,facts);card.insertAdjacentElement('afterend',glance);
    function label(sel){var opt=sel?.options?.[sel.selectedIndex];return opt?.value?clean(opt.textContent):'Not selected';}
    function refresh(){
      var selected=product.options[product.selectedIndex];
      var goods=(selected && selected.value)?clean(selected.textContent).replace(/\s*\u00b7\s*\d+\s+available$/,''):'Not selected';
      var q=Number(qty.value),u=Number(unit.value);
      var quantity=(qty.value!==''&&Number.isFinite(q)&&q>0)?q.toLocaleString()+' unit(s)':'Not entered';
      var volume=(unit.value!==''&&Number.isFinite(u)&&u>0)?u.toLocaleString(undefined,{maximumFractionDigits:5})+' CBM / unit':'Not entered';
      var from=origin&&origin.value?clean(origin.options[origin.selectedIndex].textContent):'';
      var to=dest&&dest.value?clean(dest.options[dest.selectedIndex].textContent):'';
      outputs.Goods.textContent=goods;
      outputs.Quantity.textContent=quantity;
      outputs['Unit CBM'].textContent=volume;
      outputs.Route.textContent=(from&&to)?from+' \u2192 '+to:'Select both ports';
    }
    [product,qty,unit,origin,dest].filter(Boolean).forEach(x=>{
      x.addEventListener('change',refresh);
      x.addEventListener('input',refresh);
      x.addEventListener('keyup',refresh);
    });
    doc.addEventListener('click',function(event){if(event.target.closest('#nlProductPicker,#nlQtySuggestions,#nlVolumeGuidance'))setTimeout(refresh,30);});
    window.addEventListener('pageshow',refresh);
    setTimeout(refresh,100);
    // Existing suggestion scripts sometimes set .value without dispatching input/change.
    // Keep this tiny read-only view synchronized without modifying booking form fields.
    var last='';var timer=setInterval(function(){
      if(!glance.isConnected){clearInterval(timer);return;}
      if(doc.visibilityState==='hidden')return;
      var state=[product.value,qty.value,unit.value,origin?.value,dest?.value].join('|');
      if(state!==last){last=state;refresh();}
    },450);
    refresh();
    // Explicit draft restoration only; no automatic overwrite of server-restored values.
    var form=one('form[action*="ContainerAllocationPricingController"]',base);
    if(!form || !one('input[name="bookingDate"]',form))return;
    var key='nl18-booking-draft';var names=['productId','quantity','unitCbm','originPortId','destPortId','bookingDate','dueDate'];
    function save(){var snapshot={};names.forEach(n=>{var f=form.elements.namedItem(n);if(f && f.tagName)snapshot[n]=f.value;});snapshot.saved=Date.now();safeSet(key,snapshot,true);}
    form.addEventListener('input',save);form.addEventListener('change',save);
    var old=safeGet(key,true);
    if(old&&Date.now()-old.saved<1000*60*60*8){
      var actions=make('div','nl18-mini-actions');var restore=addButton('Restore saved draft',()=>{
        names.forEach(n=>{var f=form.elements.namedItem(n);if(!f||!f.tagName||!old[n])return;
          if(new URLSearchParams(location.search).has(n) && f.value && f.value!==old[n])return; // never overwrite explicit server input
          f.value=old[n];if(n==='productId'){var textField=one('#nlBookingProductSearch');if(textField){textField.value=f.options[f.selectedIndex]?.textContent?.trim()||'';textField.setCustomValidity('');}}f.dispatchEvent(new Event('change',{bubbles:true}));
        });
        refresh();restore.textContent='Draft restored';restore.disabled=true;
      });actions.appendChild(restore);glance.append(actions);
    }
    form.addEventListener('submit',e=>{if(!e.defaultPrevented && form.checkValidity())safeSet(key,null,true);});
  }
  function initQuote(){
    if(screen!=='module3-booking-result')return;
    var target=all('.card',base).find(c=>/Your quotation/i.test(clean(one('h5,h2',c)?.textContent)));
    if(!target)return;var rows=all('table tr',target),amounts={};rows.forEach(tr=>{
      var cells=all('td',tr);if(cells.length!==2)return;var name=clean(cells[0].textContent).toLowerCase();
      var raw=clean(cells[1].textContent),numbers=raw.match(/-?\d[\d,]*(?:\.\d+)?/g);var value=Number(numbers?.[numbers.length-1]?.replace(/,/g,''));if(numbers?.length && Number.isFinite(value)&&value>=0)amounts[name]=value;
    });
    // Freight may include goods; read the authoritative total once (subrows are explanatory only).
    function amountMatching(label){var match=Object.keys(amounts).find(k=>k===label||k.startsWith(label+' (')||k.startsWith(label+' /'));return match===undefined?undefined:amounts[match];}
    var vals=[amountMatching('freight amount'),amountMatching('handling amount'),amountMatching('tax amount')],total=amountMatching('quotation total');
    if(vals.some(x=>!Number.isFinite(x))||!Number.isFinite(total)||total<=0||Math.abs(vals.reduce((a,b)=>a+b,0)-total)>Math.max(.5,total*.001))return;
    var box=make('section','nl18-quote-chart');box.setAttribute('aria-label','Visual breakdown of calculated quotation');
    box.appendChild(make('strong','','Quotation composition \u00b7 visualization only'));
    var bar=make('div','nl18-quote-bar');var colors=['#bb521b','#ed9a45','#f4ca93'];
    vals.forEach((v,i)=>{var cell=make('span');cell.style.width=Math.max(0,(v/total*100))+'%';cell.style.backgroundColor=colors[i];cell.title=['Freight (goods + shipping)','Handling','Tax'][i]+' '+(v/total*100).toFixed(1)+'%';bar.appendChild(cell);});
    box.appendChild(bar);var key=make('div','nl18-quote-key');['Freight','Handling','Tax'].forEach((x,i)=>{
      var label=make('span'),swatch=make('i');swatch.style.backgroundColor=colors[i];label.append(swatch,doc.createTextNode(x+' \u00b7 '+(vals[i]/total*100).toFixed(1)+'%'));key.appendChild(label);
    });box.appendChild(key);target.querySelector('.card-body')?.appendChild(box);
  }
  function initShipments(){
    if(screen!=='module2-shipmentmanagement' && screen!=='module2-movementtracking')return;
    var host=one('#shipmentCollection');if(host){
      var cards=all('.shipment-row',host);if(cards.length){
        var numbers={};cards.forEach(c=>{var name=c.dataset.shipmentStatus||'OTHER';numbers[name]=(numbers[name]||0)+1;});
        var panel=make('details','nl18-feature-panel');var summary=make('summary','','On-page shipment status overview');
        panel.appendChild(summary);var content=make('div','nl18-feature-panel-content nl18-mini-actions');
        Object.keys(numbers).sort().forEach(k=>{var tag=make('span','nl18-stamp',k.replace(/_/g,' ')+' \u00b7 '+numbers[k]);content.appendChild(tag);});
        var note=make('p','nl18-muted','Counts reflect only the shipments loaded on this page, not the complete database.');content.appendChild(note);
        panel.appendChild(content);host.insertAdjacentElement('beforebegin',panel);
      }
    }
    var timeline=all('.movement-event,.nl-event,.timeline-item,.event-row',base);
    if(screen==='module2-movementtracking' && timeline.length){
      var detail=make('span','nl18-timeline-pill','Recorded checkpoint events: '+timeline.length);
      var header=one('.content-wrap h1',base)||one('h1',base);header?.insertAdjacentElement('afterend',detail);
    }
  }
  function initInventory(){
    if(!screen.startsWith('module4-') && !['module3-containers','module3-pricing','module3-pricing-audit'].includes(screen))return;
    all('table',base).forEach(table=>{
      var heads=all('thead th',table).map(h=>clean(h.textContent).toLowerCase());
      var quantity=heads.findIndex(x=>/^(quantity|stock quantity|total quantity)$/.test(x));
      var damaged=heads.findIndex(x=>/^damaged/.test(x));
      if(quantity<0||damaged<0)return;
      all('tbody tr',table).forEach(row=>{
        var cells=all('td',row),a=Number(clean(cells[quantity]?.textContent).replace(/,/g,'')),b=Number(clean(cells[damaged]?.textContent).replace(/,/g,''));
        if(!Number.isFinite(a)||!Number.isFinite(b)||a<=0||b<0||b>a)return;
        var bar=make('div','nl18-progress-track');bar.style.marginTop='7px';bar.title='Visual ratio: '+(a-b)+' usable / '+b+' damaged, from displayed quantities';
        var fill=make('span');fill.style.width=((a-b)/a*100)+'%';bar.appendChild(fill);cells[quantity]?.appendChild(bar);
      });
    });
  }
  function initBilling(){
    if(screen!=='module5-details')return;
    var pay=one('#record-payment');if(!pay)return;
    var existing=one('.nl-payment-progress',pay);if(existing){
      var value=Number(existing.getAttribute('aria-valuenow'))||0;
      var note=make('small','nl18-muted','Recorded payment progress: '+value+'% of this invoice total.');
      existing.insertAdjacentElement('afterend',note);
    }
    var fields=one('#recordPaymentForm');if(fields){
      var input=one('#nlPaymentReference',fields),method=one('#nlPaymentMode',fields);
      if(input && method){
        var add=make('span','nl18-muted','');input.insertAdjacentElement('afterend',add);
        function refresh(){add.textContent=(method.value==='CASH')?'Cash payments do not require a transaction reference.':'Keep the bank/UPI/cheque reference for your records.';}
        method.addEventListener('change',refresh);refresh();
      }
    }
  }
  function initClaims(){
    if(!screen.startsWith('module7-'))return;
    var cards=all('.evidence-item-card',base);cards.forEach(c=>c.classList.add('nl18-attention'));
    if(screen==='module7-claim_details'){
      var statuses=all('.badge',base).map(x=>clean(x.textContent).replace(/^\u25cf\s*/,'')),current=statuses.find(x=>/^(SUBMITTED|UNDER REVIEW|APPROVED|PARTIALLY APPROVED|REJECTED|SETTLED)$/i.test(x));
      if(current){var panel=make('div','nl18-timeline-pill','Recorded claim status \u00b7 '+current);var head=one('h1',base);head?.insertAdjacentElement('afterend',panel);}
    }
  }
  function initAnalytics(){
    if(screen!=='module6-analytics' && screen!=='module2-profitlossdashboard')return;
    all('.nl-report-chart',base).forEach(card=>{
      var heading=one('.nl-chart-tools',card)||one('.nl-report-chart-meta',card)||card;
      if(one('.nl18-chart-max',heading))return;
      var btn=addButton('Focus chart',()=>{
        openOverlay('Chart focus','VISUALIZATION / EXISTING DATA',(panel,close)=>{
          var text=clean(one('h2,h3,strong',card)?.textContent)||'Chart';panel.appendChild(make('p','nl18-muted',text+' \u00b7 This view displays the existing chart at a larger scale.'));
          var canvas=one('canvas',card);if(canvas && canvas.width>0 && canvas.height>0){
            var img=make('img');img.alt='Expanded chart: '+text;try{img.src=canvas.toDataURL('image/png');}catch(err){img.alt='Chart preview unavailable; use the existing interactive chart below.';}img.style.cssText='width:100%;height:auto;max-height:60vh;object-fit:contain;border-radius:12px;background:white;border:1px solid #e9d6c7';panel.appendChild(img);
          }else panel.appendChild(make('p','nl18-muted','No chart image currently available; the original chart and table remain below.'));
          var controls=make('div','nl18-modal-actions');controls.appendChild(addButton('Close',close));panel.appendChild(controls);
        });
      },'nl18-mini-btn nl18-chart-max');heading.appendChild(btn);
    });
  }
  function initDirectoryOverview(){
    var supported=['module3-containers','module3-pricing','module3-pricing-audit','module4-dashboard','module4-ledger','module4-sales','module1-users','module1-companies','module1-customers','module1-infrastructure','module1-audit-log','module5-invoices','module5-payments','module7-claims'];
    if(!supported.includes(screen))return;
    var tables=all('table',base),table=tables.find(t=>all('tbody tr',t).length>=2 && all('thead th',t).length>=3);
    if(!table || one('.nl18-directory-overview',base))return;
    var rows=all('tbody tr',table).filter(r=>all('td',r).length>2 && !one('td[colspan]',r));
    if(!rows.length)return;
    var headings=all('thead th',table).map(h=>clean(h.textContent).toLowerCase());
    var statusIndex=headings.findIndex(x=>/(^status$|^role$|^company type$|^txn type$|^transaction type$)/i.test(x));
    if(statusIndex<0)return;
    var counts={},total=0;rows.forEach(r=>{
      var cells=all('td',r);var val=clean(cells[statusIndex]?.textContent).replace(/\s+/g,' ').slice(0,36);
      if(!val)return;counts[val]=(counts[val]||0)+1;total++;
    });
    if(total<2)return;
    var overview=make('details','nl18-feature-panel nl18-directory-overview');
    overview.appendChild(make('summary','','Visual summary of loaded records'));
    var content=make('div','nl18-feature-panel-content'),tags=make('div','nl18-mini-actions');
    Object.entries(counts).slice(0,12).forEach(([key,value])=>tags.appendChild(make('span','nl18-stamp',key+' \u00b7 '+value)));
    content.append(tags,make('p','nl18-muted','Summary of '+total+' records loaded in this table. It is not an additional database query or an all-time total.'));
    overview.appendChild(content);var wrapper=table.closest('.table-responsive')||table;
    wrapper.parentNode?.insertBefore(overview,wrapper);
  }
  function initPaymentStatus(){
    if(!screen.startsWith('module5-'))return;
    all('table',base).forEach(t=>{
      var heads=all('thead th',t).map(x=>clean(x.textContent).toLowerCase());
      var paidIdx=heads.findIndex(x=>/(^paid$|paid amount|amount paid)/.test(x));
      var totalIdx=heads.findIndex(x=>/(^total$|total amount|invoice total)/.test(x));
      if(paidIdx<0||totalIdx<0)return;
      all('tbody tr',t).forEach(row=>{
        var tds=all('td',row),numeric=x=>{var m=clean(x).match(/-?\d[\d,]*(?:\.\d+)?/g);return m?.length?Number(m[m.length-1].replace(/,/g,'')):NaN;},paid=numeric(tds[paidIdx]?.textContent),total=numeric(tds[totalIdx]?.textContent);
        if(total<=0||!Number.isFinite(paid)||!Number.isFinite(total))return;
        var bar=make('div','nl18-progress-track');bar.style.cssText='height:6px;margin-top:7px';
        var fill=make('span');fill.style.width=Math.min(100,Math.max(0,100*paid/total))+'%';bar.title='Recorded payment '+(paid/total*100).toFixed(0)+'% of invoice total';bar.appendChild(fill);tds[paidIdx]?.appendChild(bar);
      });
    });
  }
  function initClaimOverview(){
    if(screen!=='module7-claim_details'&&screen!=='module7-claims')return;
    var statusNodes=all('.badge,.pill,.status',base);
    var stages=['SUBMITTED','UNDER_REVIEW','APPROVED','PARTIALLY_APPROVED','REJECTED','SETTLED'];
    if(screen==='module7-claim_details'){
      var found=statusNodes.map(x=>clean(x.textContent).replace(/^\u25cf\s*/,'').toUpperCase().replace(/\s+/g,'_')).find(x=>stages.includes(x));
      if(!found)return;
      var block=make('section','nl18-progress-panel');block.setAttribute('aria-label','Claim stage visualization');
      block.appendChild(make('strong','','Claim status \u00b7 '+found.replace(/_/g,' ')));
      var path=make('div','nl18-mini-actions');
      var chosen=found==='SETTLED'?4:found==='REJECTED'||found==='APPROVED'||found==='PARTIALLY_APPROVED'?3:found==='UNDER_REVIEW'?2:1;
      ['Submitted','Under review','Decision','Settlement'].forEach((text,i)=>{
        var tag=make('span','nl18-timeline-pill',text);if(i<chosen)tag.style.cssText='background:#ffe5cb;border-color:#dc9e68;color:#8f3f19';path.appendChild(tag);
      });block.appendChild(path);
      block.appendChild(make('p','nl18-muted','The visual steps reflect only the existing recorded status. No review decision is inferred.'));
      var head=one('h1',base);if(head)head.closest('.d-flex')?.insertAdjacentElement('afterend',block);
    }
  }
  function initRouteDetails(){
    if(screen!=='module2-shipmentmanagement')return;
    var cards=all('.shipment-row',base);
    cards.forEach(card=>{
      var status=card.dataset.shipmentStatus||'';if(!status||one('.nl18-journey-visual',card))return;
      var panel=one('.shipment-row-actions, .shipment-actions, .shipment-footer',card);
      if(!panel)return;
      var info=make('span','nl18-timeline-pill nl18-journey-visual','Current status \u00b7 '+status.replace(/_/g,' '));
      panel.insertBefore(info,panel.firstChild);
    });
  }
  function initPrintAndAccessibility(){
    all('a[href^="#"]',base).forEach(link=>{
      var raw=link.getAttribute('href');if(raw?.length>1){try{var id=decodeURIComponent(raw.slice(1));if(!doc.getElementById(id))return;link.addEventListener('click',()=>{
        var target=doc.getElementById(id);if(target && !target.hasAttribute('tabindex'))target.setAttribute('tabindex','-1');
      });}catch(e){}}
    });
    all('img:not([alt])',base).forEach(img=>{if(img.closest('button,a'))return;img.setAttribute('alt','');});
    var print=one('.nl-page-tools-panel');if(print && !one('.nl18-print-helper',print)){
      var hint=make('small','nl18-muted nl18-print-helper','Tip: printed reports hide navigation and preserve existing record data.');hint.style.cssText='display:block;padding:5px 10px';print.appendChild(hint);
    }
  }
  function initNavTooltips(){
    all('.nl-side-main,.nl-side-child',doc).forEach(a=>{
      if(a.title || !a.href)return;
      var label=clean(a.textContent);if(label)a.title=label;
    });
  }
  function initFilterChips(){
    all('.nl-table-toolbar',base).forEach(toolbar=>{
      if(toolbar.dataset.nl18Chips)return;toolbar.dataset.nl18Chips='1';
      var input=one('input[type=search]',toolbar),filter=one('select.nl-table-status',toolbar);
      if(!input&&!filter)return;
      var host=make('div','nl18-mini-actions');host.style.margin='5px 0 11px';host.setAttribute('aria-label','Active local table filters');
      toolbar.insertAdjacentElement('afterend',host);
      function update(){host.replaceChildren();
        if(input&&input.value.trim()){
          var btn=addButton('Search: '+input.value.slice(0,40)+' \u00d7',()=>{input.value='';input.dispatchEvent(new Event('input',{bubbles:true}));input.focus();});
          btn.title='Clear local text filter';host.appendChild(btn);
        }
        if(filter&&filter.value&&filter.value!=='all'){
          var selected=clean(filter.options[filter.selectedIndex]?.textContent)||filter.value;
          var btn=addButton('Status: '+selected+' \u00d7',()=>{filter.value='all';filter.dispatchEvent(new Event('change',{bubbles:true}));});
          btn.title='Clear local status filter';host.appendChild(btn);
        }
        host.hidden=host.childElementCount===0;
      }
      input?.addEventListener('input',update);filter?.addEventListener('change',update);update();
    });
  }
  function initLongFormStatus(){
    all('form',base).forEach(form=>{
      var required=all('input[required],select[required],textarea[required]',form).filter(x=>x.type!=='hidden'&&x.type!=='radio'&&x.type!=='checkbox'&&!x.disabled);
      if(required.length<5||required.length>28||form.dataset.nl18Completion)return;
      form.dataset.nl18Completion='true';
      var panel=make('div','nl18-progress-panel');panel.style.cssText='margin:12px 0';
      var legend=make('div','nl18-progress-legend'),description=make('strong','','Required fields completed'),count=make('span','','0 / '+required.length);
      legend.append(description,count);panel.appendChild(legend);
      var track=make('div','nl18-progress-track'),fill=make('span');track.setAttribute('role','progressbar');track.setAttribute('aria-label','Completed required fields');track.setAttribute('aria-valuemin','0');track.setAttribute('aria-valuemax',String(required.length));track.appendChild(fill);panel.appendChild(track);
      var footer=one('[type=submit]',form)?.closest('.form-actions,.d-flex,.nl-payment-submit-row');
      if(footer&&form.contains(footer))footer.insertAdjacentElement('beforebegin',panel);else form.insertBefore(panel,form.firstChild);
      function refresh(){var completed=required.filter(x=>x.value.trim()!=='' && x.checkValidity()).length;
        count.textContent=completed+' / '+required.length;fill.style.width=(completed/required.length*100)+'%';track.setAttribute('aria-valuenow',String(completed));
      }
      form.addEventListener('input',refresh);form.addEventListener('change',refresh);refresh();
    });
  }
  function initShipmentQuickPreview(){
    if(screen!=='module2-shipmentmanagement')return;
    all('#shipmentCollection .shipment-row',base).forEach(card=>{
      if(one('.nl18-card-preview',card))return;
      var target=one('.shipment-actions',card);
      if(!target)return;
      var button=addButton('Quick preview',()=>{
        openOverlay('Shipment snapshot','READ ONLY / SHIPMENT OVERVIEW',(panel,close)=>{
          var fields=[
            ['Shipment',one('.nl-card-heading strong',card)?.textContent],
            ['Reference',one('.nl-reference-value .mono',card)?.textContent],
            ['Container',one('.nl-container-value .mono',card)?.textContent],
            ['From',one('.nl-compact-origin strong',card)?.textContent],
            ['To',one('.nl-compact-destination strong',card)?.textContent],
            ['Current status',one('.nl-status-head .pill',card)?.textContent || card.dataset.shipmentStatus],
            ['Progress',one('.nl-progress-count',card)?.textContent],
            ['Estimated arrival',one('.row-facts span:first-child b',card)?.textContent],
            ['Shipment quotation',one('.row-facts span:last-child b',card)?.textContent]
          ];
          var note=make('p','nl18-muted','A quick, read-only overview of the existing shipment record. Open details for cargo, billing and tracking history.');panel.appendChild(note);
          var grid=make('dl','nl18-snapshot-grid');fields.forEach(entry=>{
            var value=clean(entry[1]);if(!value)return;
            var cell=make('div','nl18-snapshot-field'),label=make('dt','',entry[0]),data=make('dd','',value);
            cell.append(label,data);grid.appendChild(cell);
          });panel.appendChild(grid);
          var actions=make('div','nl18-modal-actions');
          var link=one('.shipment-actions a[href*="shipmentDetails"]',card)||one('.shipment-actions a[href]',card);
          if(link){var open=make('a','nl18-mini-btn nl18-preview-primary','Open shipment details');open.href=link.href;actions.appendChild(open);}
          actions.appendChild(addButton('Close',close));panel.appendChild(actions);
        });
      },'nl18-preview-button nl18-card-preview');
      button.title='Review the existing shipment information without leaving the list';target.appendChild(button);
    });
  }
  function initTypeHints(){
    var types={'DRY':'Standard dry-cargo container','REEFER':'Temperature-controlled container','OPEN_TOP':'Top-access container','TANK':'Tank container'};
    if(screen==='module3-containers'){
      all('table tbody td',base).forEach(td=>{
        var value=clean(td.textContent);if(!types[value])return;
        td.title=types[value];td.classList.add('nl18-container-type');
      });
    }
    if(screen==='module4-ledger'){
      var hints={'IN':'Stock entered or returned','OUT':'Stock removed or reserved','DAMAGE':'Damaged stock recorded','ADJUST':'Authorized stock adjustment','CLAIM_LOSS':'Stock loss from claim settlement'};
      all('table tbody td',base).forEach(td=>{var value=clean(td.textContent);if(!hints[value])return;td.title=hints[value];td.classList.add('nl18-ledger-type');});
    }
    if(screen.startsWith('module7-')){
      var states={'SUBMITTED':'Awaiting review','UNDER_REVIEW':'The Seller is reviewing this claim','APPROVED':'Claim approved','PARTIALLY_APPROVED':'Claim partially approved','REJECTED':'Claim rejected','SETTLED':'Settlement recorded'};
      all('.badge,.pill',base).forEach(el=>{var val=clean(el.textContent).replace(/^\u25cf\s*/, '').replace(/\s/g,'_').toUpperCase();if(states[val]&&!el.title)el.title=states[val];});
    }
  }
  function initActionContinuity(){
    // Infrastructure uses full POST/redirect with server flash; do not restore
    // stale DOM position or filters after a vessel/port action.
    if(screen==='module1-infrastructure')return;
    var key='nl18-action-return',saved=safeGet(key,true);
    if(saved && saved.path===location.pathname && Date.now()-saved.at<45000){
      try{sessionStorage.removeItem(key);}catch(e){}
      if(screen==='module1-infrastructure' && saved.filters){
        [['iPortSearch','input'],['iVesselSearch','input'],['iStatusFilter','change']].forEach(item=>{
          var el=doc.getElementById(item[0]),v=saved.filters[item[0]];
          if(el && typeof v==='string'){el.value=v;el.dispatchEvent(new Event(item[1],{bubbles:true}));}
        });
      }
      var restore=()=>window.scrollTo({top:Math.max(0,saved.y||0),behavior:'instant'});
      requestAnimationFrame(restore);setTimeout(restore,90);setTimeout(restore,380);
      // Only report messages verified by the server. Never claim the operation succeeded automatically.
      var flash=one('.i-toast-wrap .i-toast, .alert-success, .alert-danger, .alert-warning',base);
      if(flash && screen!=='module1-infrastructure'){
        var msg=clean(flash.textContent).slice(0,240);
        if(msg){var toast=make('div','nl18-action-toast',msg),close=addButton('Close',()=>toast.remove());toast.setAttribute('role','status');toast.appendChild(close);doc.body.appendChild(toast);setTimeout(()=>toast.remove(),5400);}
      }
    }
    all('form[method="post"],form[method="POST"]',base).forEach(form=>{
      form.addEventListener('submit',event=>{
        // Delay until review/validation listeners have either permitted or cancelled the submit.
        queueMicrotask(()=>{
          if(event.defaultPrevented || !form.checkValidity())return;
          try{
            var path=new URL(form.getAttribute('action')||location.href,location.href).pathname;
            var filters={};['iPortSearch','iVesselSearch','iStatusFilter'].forEach(id=>{var el=doc.getElementById(id);if(el)filters[id]=el.value;});
            safeSet(key,{path:path,y:window.scrollY,at:Date.now(),filters:filters},true);
          }catch(e){}
        },0);
      });
    });
  }
  function initReadability(){
    all('.nl-view-body .alert,.content-wrap .notice',base).forEach(el=>{
      if(!el.hasAttribute('role'))el.setAttribute('role',el.classList.contains('alert-danger')?'alert':'status');
    });
    all('.nl-view-body h1,.content-wrap h1',base).forEach(h=>{h.style.overflowWrap='anywhere';});
  }
  function run(){
    var tasks=[initNavigation,initWelcome,initSections,initFields,initTables,initBooking,initQuote,initShipments,initInventory,initBilling,initClaims,initAnalytics,initDirectoryOverview,initPaymentStatus,initClaimOverview,initPrintAndAccessibility,initNavTooltips,initFilterChips,initLongFormStatus,initShipmentQuickPreview,initTypeHints,initActionContinuity,initReadability];
    tasks.forEach(fn=>{try{fn();}catch(e){console.warn('N-LOGISTIC additive UI:',fn.name,e);}});
  }
  if(doc.readyState==='loading')doc.addEventListener('DOMContentLoaded',run);else run();
})();
</script>

<%-- v20.23 existing-JSP universal QOL enhancements; presentation-only. --%>
<script>
(function(){'use strict';
const doc=document,one=(s,r=doc)=>r.querySelector(s),all=(s,r=doc)=>Array.from(r.querySelectorAll(s));
const screen=()=>doc.body?.getAttribute('data-nl-screen')||'';
const text=el=>String(el?.textContent||'').replace(/\s+/g,' ').trim();
function make(tag,cls,content){const e=doc.createElement(tag);if(cls)e.className=cls;if(content!=null)e.textContent=content;return e;}
function initSkipLink(){const target=one('.nl-view-body')||one('main');if(!target)return;if(!target.id)target.id='nl23MainContent';
 const a=make('a','nl23-skiplink','Skip to main content');a.href='#'+target.id;doc.body.insertBefore(a,doc.body.firstChild);}
function initSubmitState(){all('form[method="post"],form[method="POST"]',doc).forEach(form=>{
 if(form.dataset.nl23BusyInit)return;form.dataset.nl23BusyInit='1';
 form.addEventListener('submit',event=>{
  // Respect existing validation, review popups and named submit buttons.
  window.setTimeout(()=>{if(event.defaultPrevented||!form.checkValidity())return;
   const btn=event.submitter || one('button[type="submit"],input[type="submit"]',form);if(!btn||btn.classList.contains('nl23-action-busy'))return;
   form.setAttribute('aria-busy','true');btn.classList.add('nl23-action-busy');
   if(btn.tagName==='BUTTON'&&!btn.name){btn.dataset.nl23OriginalText=btn.textContent;btn.textContent='Submitting…';}
   // Do not disable named submitters: name/value can be essential to the controller.
   if(!btn.name)btn.disabled=true;
   window.setTimeout(()=>{if(!form.isConnected)return;form.removeAttribute('aria-busy');btn.classList.remove('nl23-action-busy');btn.disabled=false;
    if(btn.dataset.nl23OriginalText){btn.textContent=btn.dataset.nl23OriginalText;delete btn.dataset.nl23OriginalText;}},9000);
  });
 },false);
 });}
function initUploadHints(){all('input[type="file"]',doc).forEach(input=>{
 if(input.dataset.nl23Enhanced||input.id==='evidenceFile')return;input.dataset.nl23Enhanced='1';
 const panel=make('div','nl23-file-panel');panel.hidden=true;panel.setAttribute('role','status');panel.setAttribute('aria-live','polite');
 if(input.id==='ivImportFile'){
  const current=doc.getElementById('ivSelectedFile');if(current)current.insertAdjacentElement('afterend',panel);else input.insertAdjacentElement('afterend',panel);
 }else input.insertAdjacentElement('afterend',panel);
 input.addEventListener('change',async function(){panel.replaceChildren();panel.classList.remove('is-error');
  const file=input.files?.[0];if(!file){panel.hidden=true;input.setCustomValidity('');return;}panel.hidden=false;
  panel.appendChild(make('strong','nl23-file-title',file.name));
  const detail=make('div','', (file.size/1048576).toFixed(2)+' MB · '+(file.type||'File format detected from extension'));panel.appendChild(detail);
  const isImport=input.id==='ivImportFile';const ext=(file.name.split('.').pop()||'').toLowerCase();
  const allowed=isImport?['csv','xlsx']:['pdf','jpg','jpeg','png','csv','xlsx'];
  let error='';if(file.size>10*1048576)error='This file is over the 10 MB maximum.';
  else if(!allowed.includes(ext))error='Unsupported file type.';
  input.setCustomValidity(error);
  if(error){panel.classList.add('is-error');panel.appendChild(make('p','',error+' Choose a supported file before submitting.'));return;}
  if(isImport&&ext==='csv'){
   try{const sample=await file.slice(0,16384).text();if(input.files?.[0]!==file)return;
    const lines=sample.replace(/^\uFEFF/,'').split(/\r?\n/).filter(x=>x.trim()).slice(0,4);
    if(!lines.length){panel.appendChild(make('div','', 'The CSV preview is empty. Check the file before importing.'));return;}
    const parse=line=>{let arr=[],s='',quoted=false;for(let i=0;i<line.length;i++){const c=line[i];if(c==='"'){if(quoted&&line[i+1]==='"'){s+='"';i++;}else quoted=!quoted;}else if(c===','&&!quoted){arr.push(s);s='';}else s+=c;}arr.push(s);return arr;};
    const header=parse(lines[0]).slice(0,8);const required=['sku','product_name','unit_weight_kg','unit_price','quantity'];
    const missing=required.filter(key=>!header.some(h=>h.trim().toLowerCase()===key));
    if(missing.length){const hint=make('div','', 'Required columns not visible in preview: '+missing.join(', '));hint.style.color='#b64c25';panel.appendChild(hint);}
    panel.appendChild(make('div','nl23-inline-hint','CSV preview · first '+Math.max(0,lines.length-1)+' data row(s) · up to 8 columns'));
    const scroll=make('div','nl23-file-overflow'),table=make('table','nl23-file-table'),head=make('thead'),body=make('tbody'),tr=make('tr');
    header.forEach(h=>tr.appendChild(make('th','',h)));head.appendChild(tr);
    lines.slice(1).forEach(line=>{const row=make('tr');parse(line).slice(0,header.length).forEach(v=>row.appendChild(make('td','',v.slice(0,90))));body.appendChild(row);});
    table.append(head,body);scroll.appendChild(table);panel.appendChild(scroll);
   }catch(err){panel.appendChild(make('div','', 'CSV preview is unavailable; server-side import validation remains authoritative.'));}
  }else if(isImport){panel.appendChild(make('div','nl23-inline-hint','Excel file selected. Preview happens after the existing import validation.'));}
 });
 });}
function initEmptyStates(){all('.nl-view-body table,.content-wrap table').forEach(table=>{
 const body=one('tbody',table),head=one('thead',table);if(!body||!head)return;
 if(all('tr',body).length||table.classList.contains('nl-calendar')||table.closest('[hidden]'))return;
 if(table.nextElementSibling?.classList.contains('nl23-empty'))return;
 const msg=make('div','nl23-empty','No records in this view. Try clearing filters or choosing another date range.');
 msg.setAttribute('role','status');table.insertAdjacentElement('afterend',msg);
 });}
function initSmallHints(){
 const view=one('.nl-view-body')||one('.content-wrap');if(!view)return;
 if(screen()==='module5-invoices'){
  const target=one('.nl-invoice-table',view);if(target&&!one('.nl23-invoice-hint',view)){
   const hint=make('p','nl23-inline-hint nl23-invoice-hint','Payment progress reflects recorded invoice amounts. Open invoice details to review individual payments.');
   (target.closest('.table-responsive')||target).insertAdjacentElement('afterend',hint);}}
 if(screen()==='module7-claim_details'){
  const evidence=one('.nl-claim-evidence-card',view);if(evidence&&!one('.nl23-claim-evidence-hint',evidence)){
   const hint=make('p','nl23-inline-hint nl23-claim-evidence-hint','Evidence files are submitted records, not proof of independent verification.');
   const header=one('.nl-card-header-styled',evidence);header?.insertAdjacentElement('afterend',hint);}}
 if(screen()==='module3-booking'){
  const routes=one('#nlAvailableRoutes',view);if(routes&&!one('.nl23-route-hint',routes)){
   const hint=make('p','nl23-inline-hint nl23-route-hint','Selected routes update the booking fields; availability and pricing are confirmed by the existing booking flow.');
   const head=one('#nlRoutesTitle',routes);head?.insertAdjacentElement('afterend',hint);}}
}
function init(){if(doc.body?.dataset.nlEnhanced!=='true')return;
 [initSkipLink,initSubmitState,initUploadHints,initEmptyStates,initSmallHints].forEach(fn=>{try{fn();}catch(e){console.warn('N-LOGISTIC v20.23 UI',fn.name,e);}});
}
if(doc.readyState==='loading')doc.addEventListener('DOMContentLoaded',init);else init();
})();
</script>


<%-- v20.38: shared, non-destructive table alignment; no SQL, assets or new files. --%>
<script id="nl-v2038-global-table-grid">
(function () {
  'use strict';
  if (window.__nlGlobalGridV2038) return;
  window.__nlGlobalGridV2038 = true;
  const root = document;
  const numberWord = /\b(?:amount|total|paid|balance|price|rate|charges?|costs?|revenue|profit|loss|tax|duty|freight|handling|quantity|quantities|qty|units|weight|volume|cbm|value|count|bookings|confidence|growth|margin|cumulative|turnover|multiplier|capacity|teu|available|damaged|usable|average|limit|percentage|percent)\b/i;
  const notNumber = /\b(?:id|identifier|code|number|name|sku|product|shipment|container|invoice|customer|seller|company|route|port|location|country|city|type|category|status|method|reference|date|month|time|email|phone|action|manage|details|record|description|class|remarks|file)\b/i;
  const moneyToken = /^[+-]?\s*[₹$€£]?\s*[0-9][0-9,]*(?:\.[0-9]+)?\s*(?:%|x|kg|cbm|teu)?$/i;
  const excludedScreen = /^(?:module3-pricing|module5-print)$/i;
  const skipTable = table => table.closest('dialog,.nl18-overlay,.nl-review-dialog') ||
    table.closest('form') || table.matches('.nl-calendar,.nl23-file-table,.nl-cargo-table') ||
    table.classList.contains('charges') ||
    table.querySelector('tbody tr td[colspan],thead th[colspan]:not([colspan="1"])');
  const headerText = th => (th.textContent || '').replace(/[↕↗↘↑↓⇅△▽]/g,' ').replace(/\s+/g,' ').trim();
  const getType = (header,col,rows) => {
    const label=headerText(header);
    if(/\b(?:actions?|manage|operations?)\b/i.test(label)) return 'action';
    if(/\b(?:month|date|time|validity|due|period|etd|eta|updated)\b/i.test(label)) return 'date';
    // IDs and categorical fields are identifiers, not quantities.
    if (notNumber.test(label)) {
      if (/\b(?:amount|total|price|cost|value|quantity|weight|volume|rate|capacity|balance|margin|turnover)\b/i.test(label) &&
          !/\b(?:id|code|number|name|sku|product|shipment|invoice|date|month|time|status|type)\b/i.test(label)) return 'numeric';
      return 'text';
    }
    if (numberWord.test(label)) return 'numeric';
    const samples=rows.slice(0,8).map(r=>r.cells[col]).filter(Boolean);
    if (samples.length && samples.every(cell => moneyToken.test(cell.textContent.trim()) && !cell.querySelector('a,button,input,select'))) return 'numeric';
    return 'text';
  };
  function align(table) {
    if (!table.isConnected || excludedScreen.test(document.body?.dataset.nlScreen || '') || skipTable(table)) return;
    const head=table.tHead,body=table.tBodies[0];
    if(!head || !body || !head.rows.length || !body.rows.length) return;
    const headings=Array.from(head.rows[0].cells);
    if(headings.length<2 || headings.some(h=>h.colSpan!==1) ||
       Array.from(body.rows).some(r=>r.cells.length>0 && r.cells.length!==headings.length)) return;
    const rows=Array.from(body.rows);
    const types=headings.map((th,i)=>getType(th,i,rows));
    const signature=headings.map(headerText).join('|')+'|'+types.join('|');
    if(table.dataset.nlGridSignature===signature && table.dataset.nlGrid==='1') {
      rows.forEach(row=>Array.from(row.cells).forEach((td,i)=>{
        if(types[i] && td.dataset.nlColType!==types[i])td.dataset.nlColType=types[i];
      }));
      return;
    }
    table.dataset.nlGridSignature=signature;
    table.dataset.nlGrid='1';
    const wrappers='.table-responsive,.table-wrap,.iv-table-wrap,.i-table-wrap,.a-table-wrap,.cc-table-wrap,.cu-table-wrap,.nl-pl-table-wrap,.nl-pricing-table-wrap,.nl-cargo-table-wrap,.nl-global-grid-scroll';
    let scroller=table.closest(wrappers);
    if(!scroller){
      scroller=document.createElement('div');scroller.className='nl-global-grid-scroll';
      table.parentNode.insertBefore(scroller,table);scroller.appendChild(table);
    } else scroller.classList.add('nl-global-grid-scroll');
    headings.forEach((th,i)=>th.dataset.nlColType=types[i]);
    rows.forEach(row=>Array.from(row.cells).forEach((td,i)=>{if(types[i])td.dataset.nlColType=types[i];}));
    // Reserve readable widths. Horizontal scroll stays inside the table card.
    const min=headings.reduce((width,th,i)=>{
      const label=headerText(th).length;
      if(types[i]==='numeric')return width+Math.max(112,Math.min(186,label*6.5+34));
      if(types[i]==='action')return width+145;
      if(types[i]==='date')return width+146;
      const name=headerText(th).toLowerCase();
      if(/\b(?:port|address|description|company|product|vessel|route|shipment)\b/i.test(name))return width+195;
      return width+Math.max(116,Math.min(175,label*6.8+45));
    },0);
    table.style.setProperty('--nl-grid-min',Math.max(420,Math.ceil(min))+'px');
  }
  function sync(){
    const b=document.body;if(!b || !b.classList.contains('nl-themed-page'))return;
    document.querySelectorAll('table').forEach(align);
  }
  let queued=false;
  function schedule(){if(queued)return;queued=true;requestAnimationFrame(()=>{queued=false;sync();});}
  if(root.readyState==='loading')root.addEventListener('DOMContentLoaded',()=>{sync();watch();},{once:true});
  else {sync();watch();}
  function watch(){
    // Rows and headings may be rebuilt by filtering or module scripts.
    const observer=new MutationObserver(mutations=>{
      if(mutations.some(m=>Array.from(m.addedNodes).some(n=>n.nodeType===1 && (n.matches?.('table,thead,tbody,tr,th,td,.table-responsive,.table-wrap') || n.querySelector?.('table,tbody tr')))))schedule();
    });
    observer.observe(document.body,{childList:true,subtree:true});
    addEventListener('resize',schedule,{passive:true});
  }
})();
</script>

<!-- Module 2 shipment scheduling: inline theme-aware calendar, no additional asset files. -->
<style>
body.nl-themed-page .nl-schedule-panel{margin:19px 0 22px;padding:20px;min-width:0;border:1px solid #e8cdb6;border-radius:18px;background:linear-gradient(125deg,#fff9f3,#fff0e4);box-shadow:0 7px 19px #a34a1510}
body.nl-themed-page .nl-schedule-header{display:flex;align-items:center;gap:12px;margin-bottom:17px;min-width:0}
body.nl-themed-page .nl-schedule-emblem{width:43px;height:43px;display:grid;place-items:center;flex:none;border:1px solid #ecc3a4;background:#ffead7;color:#b84a13;border-radius:13px;font-size:1.45rem}
body.nl-themed-page .nl-schedule-header-copy{min-width:0;flex:1}
body.nl-themed-page .nl-schedule-header-copy h3{margin:0 0 4px!important;font-size:1.2rem!important;font-weight:850!important;letter-spacing:-.025em;text-align:left!important;color:#563222!important}
body.nl-themed-page .nl-schedule-header-copy p{margin:0!important;color:#886b58!important;font-size:.83rem;line-height:1.45}
body.nl-themed-page .nl-schedule-pill{flex:none;white-space:nowrap;padding:6px 10px;border-radius:999px;background:#ffead9;border:1px solid #ecc8ab;color:#994414;font-size:.71rem;font-weight:800}
body.nl-themed-page .nl-schedule-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
body.nl-themed-page .nl-schedule-form{min-width:0;display:flex;flex-direction:column;align-items:stretch;gap:9px;padding:17px;border:1px solid #efddcd;border-radius:15px;background:#fffdf9;box-shadow:0 3px 10px #75412409}
body.nl-themed-page .nl-schedule-form>label{font-size:.86rem;font-weight:800;color:#694330}
body.nl-themed-page .nl-sched-required{color:#ce5715;font-weight:900}
body.nl-themed-page .nl-schedule-form .nl-schedule-date{width:100%;min-height:45px;padding:9px 13px;border:1px solid #e3bea1;border-radius:11px;background:#fffcf8;color:#372922;font:inherit;cursor:pointer;min-width:0;color-scheme:light}
body.nl-themed-page .nl-schedule-date-slot{position:relative;min-width:0}
body.nl-themed-page .nl-schedule-calendar-trigger{width:100%;min-height:51px;padding:9px 11px 9px 14px;background:#fffdfa!important;color:#513425!important;border:1px solid #e3bea1!important;border-radius:12px!important;display:flex!important;align-items:center!important;justify-content:space-between!important;gap:12px!important;text-align:left!important;box-shadow:none!important;transform:none!important;min-width:0}
body.nl-themed-page .nl-schedule-calendar-trigger:hover,body.nl-themed-page .nl-schedule-calendar-trigger[aria-expanded=true]{border-color:#d75f17!important;box-shadow:0 0 0 3px #e4681720!important}
body.nl-themed-page .nl-schedule-calendar-trigger .nl-sched-trigger-copy{min-width:0;flex:1;display:grid;gap:1px}
body.nl-themed-page .nl-schedule-calendar-trigger strong{font-size:.93rem;font-weight:800;line-height:1.35;color:inherit}
body.nl-themed-page .nl-schedule-calendar-trigger small{font-size:.71rem;color:#886c59}
body.nl-themed-page .nl-sched-icon{flex:none;width:36px;height:34px;border-radius:9px;border:1px solid #f1d2bb;background:#ffedda;display:grid;place-items:center;color:#b6470b;font-size:1.1rem}
body.nl-themed-page .nl-schedule-saved{font-size:.76rem;color:#856951}
body.nl-themed-page .nl-schedule-saved strong{color:#52382b}
body.nl-themed-page .nl-schedule-error{min-height:0;margin:0!important;color:#ad361e!important;font-size:.78rem;font-weight:650}
body.nl-themed-page .nl-schedule-error:empty{display:none}
body.nl-themed-page .nl-schedule-form .nl-schedule-save{align-self:flex-start;min-height:39px!important;margin-top:auto;max-width:100%;white-space:normal}
body.nl-themed-page .nl-schedule-footer{margin:13px 2px 0!important;color:#836757!important;font-size:.79rem;line-height:1.5}
body.nl-themed-page .nl-other-shipment-fields{margin-top:17px!important}
/* v20.44: top-aligned Seller metadata fields. The live character counter on the
   value field must never push the selector label or control lower than its peer. */
body.nl-themed-page .nl-other-shipment-fields .nl-metadata-form{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));column-gap:16px;row-gap:14px;align-items:start;width:100%;max-width:100%;margin:12px 0 0}
body.nl-themed-page .nl-other-shipment-fields .nl-metadata-form>.field{display:flex;flex-direction:column;align-items:stretch;justify-content:flex-start;gap:8px;min-width:0;margin:0;padding:0}
body.nl-themed-page .nl-other-shipment-fields .nl-metadata-form>.field>label{display:block;line-height:20px;min-height:20px;margin:0!important;text-align:left}
body.nl-themed-page .nl-other-shipment-fields .nl-metadata-form>.field>:is(.input,.select){display:block;width:100%;min-width:0;min-height:44px;height:44px;margin:0;box-sizing:border-box}
body.nl-themed-page .nl-other-shipment-fields .nl-metadata-action{grid-column:1/-1;display:flex;align-items:center;justify-content:flex-start;margin:0;padding:0;min-width:0}
body.nl-themed-page .nl-other-shipment-fields .nl-metadata-action .btn{min-height:41px;white-space:nowrap}
@media(max-width:690px){body.nl-themed-page .nl-other-shipment-fields .nl-metadata-form{grid-template-columns:minmax(0,1fr);row-gap:13px}}
.nl-sched-calendar-pop{position:fixed;z-index:100001;box-sizing:border-box;width:min(360px,calc(100vw - 22px));max-height:min(510px,calc(100vh - 18px));overflow-y:auto;background:#fffaf5;border:1px solid #e9c6ab;border-radius:17px;box-shadow:0 24px 60px #5c290b35;padding:16px;color:#452d20;font:14px/1.4 'Segoe UI',Arial,sans-serif}
.nl-sched-calendar-pop[hidden]{display:none!important}
.nl-sched-calendar-head{display:flex;justify-content:space-between;gap:7px;align-items:flex-start;margin-bottom:11px}
.nl-sched-calendar-head strong{display:block;font-size:.87rem;color:#a24711}.nl-sched-calendar-head small{font-size:.71rem;color:#886b5a}
.nl-sched-calendar-pop button{cursor:pointer;box-sizing:border-box;font:inherit;box-shadow:none!important;transform:none!important}
.nl-sched-calendar-pop .nl-sched-close{background:#fff2e6;border:1px solid #efd2bd;color:#9a4216;border-radius:8px;width:30px;height:30px;font-size:1rem;line-height:1}
.nl-sched-monthbar{display:grid;grid-template-columns:33px minmax(0,1fr) 33px;gap:8px;align-items:center;margin-bottom:12px}
.nl-sched-monthbar strong{font-size:.95rem;text-align:center;color:#4c2d1d}
.nl-sched-selectors{display:grid;grid-template-columns:minmax(0,1.1fr) minmax(0,.9fr);gap:6px}.nl-sched-selectors select{width:100%;min-width:0;padding:8px 5px;background:#fff5eb;color:#5d341d;border:1px solid #e7c8b0;border-radius:8px;font-size:.82rem;font-weight:800}
.nl-sched-monthbar button{height:33px;border-radius:9px;border:1px solid #e7c8b0;background:#fff2e5;color:#ab4814;font-size:1.35rem;line-height:1}
.nl-sched-week,.nl-sched-days{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));gap:4px}
.nl-sched-week{padding-bottom:8px;border-bottom:1px solid #f0ddcd;margin-bottom:6px}
.nl-sched-week span{text-align:center;font-size:.68rem;font-weight:800;color:#977b6a}
.nl-sched-days button{display:grid;place-items:center;width:100%;height:35px;padding:0;border:1px solid transparent;border-radius:9px;background:transparent;color:#4a3126;font-size:.82rem}
.nl-sched-days button[data-outside=true]{color:#a9988b}
.nl-sched-days button[data-today=true]{border-color:#d8a47d;color:#b14d15;font-weight:850}
.nl-sched-days button:hover,.nl-sched-days button:focus-visible{background:#ffe9d5;border-color:#dba77e;outline:0}
.nl-sched-days button[data-selected=true]{background:linear-gradient(120deg,#bd460c,#eb741d)!important;border-color:#e36c1a;color:white!important;font-weight:900}
.nl-sched-calendar-foot{border-top:1px solid #efdbcd;padding-top:10px;margin-top:9px;display:flex;align-items:center;justify-content:space-between;gap:8px}
.nl-sched-calendar-foot span{font-size:.72rem;color:#8d6b56}
.nl-sched-calendar-foot button{border:1px solid #d26a29;border-radius:9px;background:#d85b12;color:#fff;padding:7px 11px;font-weight:800;font-size:.77rem}
html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-panel{background:linear-gradient(135deg,#1e2e40,#253950)!important;border-color:#4f6a7e!important;box-shadow:none!important}
html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-form{background:#192a3c!important;border-color:#476077!important}
html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-header-copy h3,html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-form>label,html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-saved strong{color:#f3f7fc!important}
html[data-nl-mode=dark] body.nl-themed-page :is(.nl-schedule-header-copy p,.nl-schedule-saved,.nl-schedule-footer,.nl-schedule-calendar-trigger small){color:#bcd0e0!important}
html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-pill{background:#354d61!important;border-color:#60778c!important;color:#f4ca9d!important}
html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-emblem,html[data-nl-mode=dark] body.nl-themed-page .nl-sched-icon{background:#334a60!important;border-color:#59758d!important;color:#ffc08c!important}
html[data-nl-mode=dark] body.nl-themed-page :is(.nl-schedule-date,.nl-schedule-calendar-trigger){background:#23364a!important;color:#f3f8fd!important;border-color:#5c778d!important;color-scheme:dark}
html[data-nl-mode=dark] .nl-sched-calendar-pop{background:#213247;color:#f5f7fc;border-color:#607c94;box-shadow:0 23px 52px #050b16a0}
html[data-nl-mode=dark] .nl-sched-calendar-head strong,html[data-nl-mode=dark] .nl-sched-monthbar strong{color:#f6cfaf}
html[data-nl-mode=dark] .nl-sched-calendar-pop :is(small,.nl-sched-calendar-foot span,.nl-sched-week span){color:#bed0df}
html[data-nl-mode=dark] .nl-sched-calendar-pop :is(.nl-sched-close,.nl-sched-monthbar button,.nl-sched-selectors select){background:#34495f;color:#fff0e0;border-color:#60798e}
html[data-nl-mode=dark] .nl-sched-calendar-pop .nl-sched-days button{color:#e6f1fb}
html[data-nl-mode=dark] .nl-sched-calendar-pop .nl-sched-days button[data-outside=true]{color:#a5b3c3}
html[data-nl-mode=dark] .nl-sched-calendar-pop .nl-sched-days button:hover{background:#3b536c;border-color:#bb8d65}
html[data-nl-mode=dark] .nl-sched-calendar-pop :is(.nl-sched-week,.nl-sched-calendar-foot){border-color:#4c657b}
@media(max-width:690px){body.nl-themed-page .nl-schedule-panel{padding:14px}body.nl-themed-page .nl-schedule-grid{grid-template-columns:1fr}body.nl-themed-page .nl-schedule-pill{display:none}body.nl-themed-page .nl-other-shipment-fields .nl-metadata-form{grid-template-columns:1fr}}

/* v20.40 one-action schedule form, encoding-safe calendar marks */
body.nl-themed-page .nl-schedule-combined{display:block;margin:0}
body.nl-themed-page .nl-schedule-combined .nl-schedule-grid{margin-bottom:12px}
body.nl-themed-page .nl-schedule-combined .nl-schedule-form{gap:10px;min-width:0}
body.nl-themed-page .nl-schedule-combined .nl-schedule-error{margin:0 0 9px!important}
body.nl-themed-page .nl-schedule-toolbar{display:flex;align-items:center;justify-content:flex-start;gap:14px;flex-wrap:wrap;margin:3px 2px 0}
body.nl-themed-page .nl-schedule-toolbar .nl-schedule-save{flex:none;margin:0!important;min-width:155px}
body.nl-themed-page .nl-schedule-helper{font-size:.78rem;color:#826451}
body.nl-themed-page .nl-schedule-server-error{border:1px solid #de9887;color:#a6351c;background:#fff0ea;border-radius:11px;padding:12px 16px;margin:12px 0}
body.nl-themed-page .nl-sched-icon{position:relative}
body.nl-themed-page .nl-sched-icon:before{content:'';position:absolute;width:17px;height:18px;left:8px;top:7px;border:2px solid currentColor;border-radius:4px;background:linear-gradient(to bottom,currentColor 0 4px,transparent 4px)}
body.nl-themed-page .nl-sched-icon:after{content:'';position:absolute;left:13px;top:18px;width:3px;height:3px;border-radius:1px;background:currentColor;box-shadow:6px 0 0 currentColor,0 5px 0 currentColor,6px 5px 0 currentColor}
.nl-sched-monthbar button.nl-sched-prev,.nl-sched-monthbar button.nl-sched-next{position:relative;display:grid;place-items:center}
.nl-sched-monthbar button.nl-sched-prev:before,.nl-sched-monthbar button.nl-sched-next:before{content:'';display:block;width:9px;height:9px;border-top:2px solid currentColor;border-right:2px solid currentColor;transform:rotate(-135deg)}
.nl-sched-monthbar button.nl-sched-next:before{transform:rotate(45deg)}
.nl-sched-close{position:relative;display:grid;place-items:center}
.nl-sched-close:before,.nl-sched-close:after{content:'';width:14px;height:2px;background:currentColor;position:absolute;transform:rotate(45deg)}
.nl-sched-close:after{transform:rotate(-45deg)}
body.nl-themed-page .nl-status-correction,body.nl-themed-page .nl-other-shipment-fields{margin-top:16px!important}
body.nl-themed-page .nl-status-correction .correction-preview{display:flex;gap:14px;flex-wrap:wrap;align-items:center;padding:13px;background:#fff8f1;border:1px solid #efd2b9;border-radius:12px}
body.nl-themed-page .nl-status-correction .correction-preview>div{display:grid;gap:3px;flex:1;min-width:120px}
body.nl-themed-page .nl-status-correction .correction-preview small{font-size:.73rem;color:#80624d}
body.nl-themed-page .nl-status-correction .correction-preview strong{font-size:1rem;color:#4c3021}
body.nl-themed-page .nl-status-correction .correction-arrow{font-size:1.2rem;color:#b8520f}
body.nl-themed-page .nl-status-correction .correction-help{font-size:.79rem;color:#816451}
body.nl-themed-page .nl-status-correction .correction-error{padding:12px;margin:10px 0;color:#ab351e;border:1px solid #e7b1a2;border-radius:10px;background:#fff0ea}
html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-helper,html[data-nl-mode=dark] body.nl-themed-page .nl-status-correction .correction-preview small,html[data-nl-mode=dark] body.nl-themed-page .nl-status-correction .correction-help{color:#bdd0e3}
html[data-nl-mode=dark] body.nl-themed-page .nl-schedule-server-error,html[data-nl-mode=dark] body.nl-themed-page .nl-status-correction .correction-error{color:#ffbcad;background:#462e32;border-color:#926364}
html[data-nl-mode=dark] body.nl-themed-page .nl-status-correction .correction-preview{background:#27384c;border-color:#5c7184}
html[data-nl-mode=dark] body.nl-themed-page .nl-status-correction .correction-preview strong{color:#f7f5f1}
@media(max-width:690px){body.nl-themed-page .nl-schedule-toolbar{align-items:stretch;flex-direction:column}body.nl-themed-page .nl-schedule-toolbar .nl-schedule-save{align-self:stretch}body.nl-themed-page .nl-status-correction .correction-arrow{display:none}}

@media(prefers-reduced-motion:reduce){.nl-sched-calendar-pop *,body.nl-themed-page .nl-schedule-panel *{animation:none!important;transition:none!important}}

/* v20.43: Hide any stale mis-decoded icon text. All picker icons are drawn with CSS
   borders/pseudo-elements, never Unicode glyphs or external icon fonts. */
body.nl-themed-page .nl-sched-icon,
.nl-sched-calendar-pop :is(.nl-sched-prev,.nl-sched-next,.nl-sched-close){font-size:0!important;line-height:0!important;text-indent:0!important;white-space:nowrap;overflow:hidden}
body.nl-themed-page .nl-sched-icon::before,body.nl-themed-page .nl-sched-icon::after,
.nl-sched-calendar-pop :is(.nl-sched-prev,.nl-sched-next,.nl-sched-close)::before,
.nl-sched-calendar-pop .nl-sched-close::after{font-size:0!important}
body.nl-themed-page .nl-status-advanced{margin-top:18px!important}
body.nl-themed-page .nl-status-advanced .card-head{margin-bottom:10px}
body.nl-themed-page .nl-status-advanced .expander{display:block!important;margin:12px 0 0!important;max-width:100%;overflow:visible}
body.nl-themed-page .nl-status-advanced .expander>summary{display:list-item!important;white-space:normal;line-height:1.5;padding:3px 0;font-weight:850}
body.nl-themed-page .nl-status-advanced .expander>div{padding-top:14px}
body.nl-themed-page .nl-status-advanced .nl-status-unavailable{font-size:.87rem;color:#806754;line-height:1.55;padding:9px 4px}
body.nl-themed-page .nl-status-advanced .nl-other-shipment-fields .nl-metadata-form{max-width:100%}
html[data-nl-mode=dark] body.nl-themed-page .nl-status-advanced .nl-status-unavailable{color:#c6d5e3!important}
@media(max-width:690px){body.nl-themed-page .nl-status-advanced{padding:15px!important}}

</style>
<script>
(function(){'use strict';
const inputs=[...document.querySelectorAll('input.nl-schedule-date')];
if(!inputs.length)return;
const form=inputs[0].closest('form.nl-schedule-combined');
if(!form)return;
const activeForms=inputs.map(input=>({input,field:input.dataset.scheduleField,form}));
const pop=document.createElement('div');pop.className='nl-sched-calendar-pop';
pop.id='nlShipmentDateCalendar';pop.setAttribute('role','dialog');
pop.setAttribute('aria-label','Choose shipment date');pop.hidden=true;document.body.appendChild(pop);
let active=null,year=0,month=0;
const pad=n=>String(n).padStart(2,'0'),iso=d=>d.getFullYear()+'-'+pad(d.getMonth()+1)+'-'+pad(d.getDate());
function parse(s){if(!/^\d{4}-\d\d-\d\d$/.test(s||''))return null;const a=s.split('-').map(Number),d=new Date(a[0],a[1]-1,a[2]);return iso(d)===s?d:null;}
function pretty(s){const d=parse(s);return d?d.toLocaleDateString('en-IN',{day:'numeric',month:'short',year:'numeric'}):'';}
function el(tag,cls,text){const n=document.createElement(tag);if(cls)n.className=cls;if(text!==undefined)n.textContent=text;return n;}
function button(cls,text){const n=el('button',cls,text);n.type='button';return n;}
function sync(f){const s=f.input.value;f.title.textContent=s?pretty(s):'Choose a date';f.subtitle.textContent=s?parse(s).toLocaleDateString('en-IN',{weekday:'long'}):'Select using calendar';}
function reposition(){if(!active||pop.hidden)return;const r=active.trigger.getBoundingClientRect(),w=Math.min(360,innerWidth-22),gap=8;pop.style.maxHeight=Math.min(510,innerHeight-20)+'px';const h=pop.getBoundingClientRect().height,above=r.top>h+gap+12&&(innerHeight-r.bottom<h+gap);pop.style.top=Math.max(8,Math.min(innerHeight-h-8,above?r.top-gap-h:r.bottom+gap))+'px';pop.style.left=Math.max(11,Math.min(innerWidth-w-11,r.left))+'px';}
function close(refocus){if(!active)return;const prior=active;pop.hidden=true;prior.trigger.setAttribute('aria-expanded','false');active=null;if(refocus)prior.trigger.focus();}
function open(f){if(active===f&&!pop.hidden){close(true);return;}if(active)close(false);active=f;const d=parse(f.input.value)||new Date();year=d.getFullYear();month=d.getMonth();f.trigger.setAttribute('aria-expanded','true');pop.setAttribute('aria-label','Choose '+(f.field==='eta'?'expected arrival':'expected departure'));pop.hidden=false;render();reposition();const focus=pop.querySelector('[data-selected=true]')||pop.querySelector('.nl-sched-days button:not([data-outside=true])');if(focus)focus.focus({preventScroll:true});}
function choose(value){if(!active)return;const f=active;f.input.value=value;sync(f);f.input.dispatchEvent(new Event('change',{bubbles:true}));form.querySelector('.nl-schedule-error').textContent='';close(true);}
function moveMonth(delta){const d=new Date(year,month+delta,1);year=d.getFullYear();month=d.getMonth();render();reposition();}
function render(){if(!active)return;pop.replaceChildren();
const head=el('div','nl-sched-calendar-head'),info=el('div');info.append(el('strong','',active.field==='eta'?'Expected arrival':'Expected departure'),el('small','','Choose a date for this shipment'));
const x=button('nl-sched-close','');x.replaceChildren();x.setAttribute('aria-label','Close calendar');x.onclick=()=>close(true);head.append(info,x);pop.appendChild(head);
const bar=el('div','nl-sched-monthbar'),prev=button('nl-sched-prev',''),next=button('nl-sched-next',''),selectors=el('div','nl-sched-selectors');prev.replaceChildren();next.replaceChildren();prev.setAttribute('aria-label','Previous month');next.setAttribute('aria-label','Next month');prev.onclick=()=>moveMonth(-1);next.onclick=()=>moveMonth(1);
const monthSelect=el('select');monthSelect.setAttribute('aria-label','Calendar month');for(let m=0;m<12;m++){const opt=el('option','',new Date(2026,m,1).toLocaleDateString('en-IN',{month:'short'}));opt.value=String(m);monthSelect.appendChild(opt);}monthSelect.value=String(month);monthSelect.onchange=()=>{month=Number(monthSelect.value);render();reposition();};
const yearSelect=el('select');yearSelect.setAttribute('aria-label','Calendar year');for(let y=Math.max(1900,year-10);y<=Math.min(2100,year+10);y++){const opt=el('option','',String(y));opt.value=String(y);yearSelect.appendChild(opt);}yearSelect.value=String(year);yearSelect.onchange=()=>{year=Number(yearSelect.value);render();reposition();};selectors.append(monthSelect,yearSelect);bar.append(prev,selectors,next);pop.appendChild(bar);
const week=el('div','nl-sched-week');['Su','Mo','Tu','We','Th','Fr','Sa'].forEach(n=>week.appendChild(el('span','',n)));pop.appendChild(week);
const grid=el('div','nl-sched-days'),first=new Date(year,month,1).getDay(),start=new Date(year,month,1-first);
for(let i=0;i<42;i++){const date=new Date(start.getFullYear(),start.getMonth(),start.getDate()+i),value=iso(date),b=button('',String(date.getDate()));b.dataset.outside=String(date.getMonth()!==month);b.dataset.today=String(value===iso(new Date()));b.dataset.selected=String(value===active.input.value);b.setAttribute('aria-label',date.toLocaleDateString('en-IN',{dateStyle:'full'}));b.onclick=()=>choose(value);
b.onkeydown=e=>{const increments={ArrowLeft:-1,ArrowRight:1,ArrowUp:-7,ArrowDown:7};if(!(e.key in increments))return;e.preventDefault();const d=new Date(date.getFullYear(),date.getMonth(),date.getDate()+increments[e.key]);year=d.getFullYear();month=d.getMonth();render();reposition();const target=pop.querySelector('.nl-sched-days button[aria-label="'+d.toLocaleDateString('en-IN',{dateStyle:'full'})+'"]');if(target)target.focus({preventScroll:true});};grid.appendChild(b);}pop.appendChild(grid);
const footer=el('div','nl-sched-calendar-foot');footer.appendChild(el('span','','Use arrow keys to change days'));const today=button('','Today');today.onclick=()=>choose(iso(new Date()));footer.appendChild(today);pop.appendChild(footer);
}
activeForms.forEach(f=>{const i=f.input,slot=i.parentNode,trigger=button('nl-schedule-calendar-trigger');trigger.setAttribute('aria-haspopup','dialog');trigger.setAttribute('aria-expanded','false');trigger.setAttribute('aria-controls','nlShipmentDateCalendar');trigger.setAttribute('aria-label','Choose '+(f.field==='eta'?'expected arrival':'expected departure')+' date');
const copy=el('span','nl-sched-trigger-copy');f.title=el('strong');f.subtitle=el('small');copy.append(f.title,f.subtitle);const icon=el('span','nl-sched-icon','');icon.replaceChildren();icon.setAttribute('aria-hidden','true');trigger.append(copy,icon);slot.appendChild(trigger);f.trigger=trigger;sync(f);i.type='hidden';i.required=false;trigger.onclick=()=>open(f);});
form.addEventListener('submit',e=>{const departure=activeForms.find(f=>f.field==='etd'),arrival=activeForms.find(f=>f.field==='eta'),etd=departure.input.value,eta=arrival.input.value,error=form.querySelector('.nl-schedule-error');let reason='',focus=departure;
if(!parse(etd))reason='Choose a valid expected departure date.';
else if(!parse(eta)){reason='Choose a valid expected arrival date.';focus=arrival;}
else if(eta<etd){reason='Expected arrival must be on or after expected departure.';focus=arrival;}
if(reason){e.preventDefault();error.textContent=reason;open(focus);return;}error.textContent='';form.querySelector('.nl-schedule-save').disabled=true;},true);
document.addEventListener('pointerdown',e=>{if(active&&!pop.hidden&&!pop.contains(e.target)&&!active.trigger.contains(e.target))close(false);});
document.addEventListener('keydown',e=>{if(e.key==='Escape'&&active&&!pop.hidden){e.preventDefault();close(true);}});
addEventListener('resize',reposition);addEventListener('scroll',reposition,true);
const failedCorrection=document.querySelector('#checkpointCorrection .correction-error');if(failedCorrection){document.getElementById('checkpointCorrection').open=true;}
const otherField=document.getElementById('edit-field'),otherInput=document.getElementById('edit-value');
if(otherField&&otherInput){const update=()=>{otherInput.value='';otherInput.placeholder=otherField.value==='vessel_id'?'Enter an active vessel ID':'Enter updated cargo description';otherInput.maxLength=otherField.value==='vessel_id'?10:255;otherInput.inputMode=otherField.value==='vessel_id'?'numeric':'text';};otherField.addEventListener('change',update);update();}
})();
</script>
