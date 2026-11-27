<script>
(function(){'use strict';
 var toggle=document.getElementById('menuToggle');
 if(toggle){toggle.addEventListener('click',function(){var open=document.body.classList.toggle('menu-open');toggle.setAttribute('aria-expanded',String(open));});}
 document.addEventListener('keydown',function(e){if(e.key==='Escape'){document.body.classList.remove('menu-open');if(toggle)toggle.setAttribute('aria-expanded','false');document.querySelectorAll('.top-details[open]').forEach(function(n){n.open=false;});}if((e.ctrlKey||e.metaKey)&&e.key.toLowerCase()==='k'){var input=document.querySelector('.top-search input');if(input){e.preventDefault();input.focus();}}});
 document.addEventListener('click',function(e){document.querySelectorAll('.top-details[open]').forEach(function(n){if(!n.contains(e.target))n.open=false;});});
 document.querySelectorAll('.account-menu .menu-drop a').forEach(function(link){link.addEventListener('click',function(){var details=link.closest('details');if(details)details.open=false;});});
 document.querySelectorAll('.sidebar .nav-link').forEach(function(link){link.addEventListener('click',function(){document.body.classList.remove('menu-open');});});
 function legacyCopy(text){var area=document.createElement('textarea');area.value=text;area.style.position='fixed';area.style.left='-9999px';document.body.appendChild(area);area.select();var result=false;try{result=document.execCommand('copy');}catch(ignore){}area.remove();return result;}
 // Module 2 uses _end.jsp rather than _shell_end.jsp: keep identifiers
 // click-to-copy here as well, without attaching any orange Copy buttons.
 var nlCopyNotice=null,nlCopyNoticeTimer=0;
 function nlShowCopyNotice(message){
   if(!nlCopyNotice){nlCopyNotice=document.createElement('div');nlCopyNotice.className='nl-copy-announcement';
     nlCopyNotice.setAttribute('role','status');nlCopyNotice.setAttribute('aria-live','polite');document.body.appendChild(nlCopyNotice);}
   nlCopyNotice.textContent=message;nlCopyNotice.classList.add('is-visible');
   clearTimeout(nlCopyNoticeTimer);nlCopyNoticeTimer=setTimeout(function(){nlCopyNotice.classList.remove('is-visible');},1800);
 }
 document.addEventListener('click',function(event){
   var el=event.target.closest('[data-nl-copy-value]');if(!el)return;
   event.preventDefault();event.stopPropagation();
   var value=el.getAttribute('data-nl-copy-value')||'';
   function complete(ok){if(ok){el.classList.add('is-copied');setTimeout(function(){el.classList.remove('is-copied');},1200);}
     nlShowCopyNotice(ok?'Copied '+value:'Copy unavailable. Select the ID and press Ctrl+C.');}
   if(navigator.clipboard && navigator.clipboard.writeText){navigator.clipboard.writeText(value).then(function(){complete(true);}).catch(function(){complete(legacyCopy(value));});}
   else complete(legacyCopy(value));
 });
 document.addEventListener('keydown',function(event){
   var el=event.target.closest('[data-nl-copy-value][role="button"]');
   if(!el || (event.key!=='Enter' && event.key!==' '))return;
   event.preventDefault();el.click();
 });
 document.querySelectorAll('[data-copy]').forEach(function(el){el.addEventListener('click',function(){
   var v=el.getAttribute('data-copy')||'',original=el.innerHTML;
   function result(ok){
     toast(ok?'Copied to clipboard':'Copy unavailable - select the reference');
     if(!ok)return;
     if(el._copyReset)clearTimeout(el._copyReset);
     if(!el.dataset.copyOriginal)el.dataset.copyOriginal=original;
     el.classList.add('is-copied');el.textContent=el.classList.contains('icon-only')?'Copied':'Copied';
     el._copyReset=setTimeout(function(){el.innerHTML=el.dataset.copyOriginal||original;el.classList.remove('is-copied');},1300);
   }
   if(navigator.clipboard&&navigator.clipboard.writeText)navigator.clipboard.writeText(v).then(function(){result(true);}).catch(function(){result(legacyCopy(v));});
   else result(legacyCopy(v));
 });});
 document.querySelectorAll('[data-table-search]').forEach(function(el){el.addEventListener('input',function(){var table=document.getElementById(el.getAttribute('data-table-search'));if(!table)return;var q=el.value.toLowerCase().trim(),visible=0;table.querySelectorAll('tbody tr').forEach(function(row){var match=row.textContent.toLowerCase().indexOf(q)>=0;row.hidden=!match;if(match)visible++;});var target=document.getElementById(el.getAttribute('data-count-target')||'');if(target)target.textContent=visible+' shown';});});
 document.querySelectorAll('[data-table-sort]').forEach(function(th){th.addEventListener('click',function(){var table=th.closest('table'),body=table&&table.querySelector('tbody');if(!body)return;var ix=Array.from(th.parentElement.children).indexOf(th),direction=th.getAttribute('data-dir')==='asc'?'desc':'asc';th.setAttribute('data-dir',direction);var rows=Array.from(body.rows);rows.sort(function(a,b){var x=a.cells[ix].textContent.trim(),y=b.cells[ix].textContent.trim();var numberLike=/^[-+]?\s*[\u20B9$]?\s*[0-9,]+(?:\.[0-9]+)?$/;var numeric=numberLike.test(x)&&numberLike.test(y);var r=numeric?Number(x.replace(/[^0-9.-]/g,''))-Number(y.replace(/[^0-9.-]/g,'')):x.localeCompare(y,undefined,{numeric:true});return direction==='asc'?r:-r;});rows.forEach(function(row){body.appendChild(row);});});th.setAttribute('tabindex','0');th.setAttribute('role','button');th.addEventListener('keydown',function(e){if(e.key==='Enter')th.click();});});
 document.querySelectorAll('[data-confirm]').forEach(function(f){f.setAttribute('data-nl-site-confirm',f.getAttribute('data-confirm'));});
 document.querySelectorAll('[data-today]').forEach(function(el){if(!el.value)el.value=new Date().toISOString().substring(0,10);});
 document.querySelectorAll('[data-filter-range]').forEach(function(form){form.addEventListener('submit',function(e){var a=form.querySelector('[name=startDate]'),b=form.querySelector('[name=endDate]');if(a&&b&&a.value&&b.value&&a.value>b.value){e.preventDefault();toast('From date cannot be after To date');a.focus();}});});

 // Presentation QoL: filter and sort shipment cards already returned by the server.
 var cardsHost=document.getElementById('shipmentCollection');
 if(cardsHost){
   var allCards=Array.from(cardsHost.querySelectorAll('.shipment-row'));
   var localStatus='ALL';
   var localSort=document.getElementById('shipmentSort');
   var quickFind=document.getElementById('nlShipmentQuickFind');
   var clearFind=document.getElementById('nlClearShipmentQuickFind');
   function applyShipmentView(){
     var cards=allCards.slice();
     if(localSort){
       var order=localSort.value;
       cards.sort(function(a,b){
         if(order==='oldest')return Number(a.dataset.shipmentId)-Number(b.dataset.shipmentId);
         if(order==='eta')return a.dataset.eta.localeCompare(b.dataset.eta)||Number(b.dataset.shipmentId)-Number(a.dataset.shipmentId);
         if(order==='status')return a.dataset.shipmentStatus.localeCompare(b.dataset.shipmentStatus)||Number(b.dataset.shipmentId)-Number(a.dataset.shipmentId);
         return Number(b.dataset.shipmentId)-Number(a.dataset.shipmentId);
       });
     }
     var fragment=document.createDocumentFragment();cards.forEach(function(card){fragment.appendChild(card);});cardsHost.appendChild(fragment);
     var visible=0;
     cards.forEach(function(card){
       var st=card.dataset.shipmentStatus;
       var statusMatch=localStatus==='ALL'||localStatus==='ACTIVE'&&st!=='DELIVERED'&&st!=='CANCELLED'||localStatus===st||localStatus==='DELAYED'&&card.dataset.delayed==='true';
       var term=quickFind?quickFind.value.toLocaleLowerCase().trim():'';
       var matches=statusMatch&&(!term||card.textContent.toLocaleLowerCase().includes(term));
       card.hidden=!matches;if(matches)visible++;
     });
     var count=document.getElementById('shipmentCount');if(count)count.textContent=visible+' of '+allCards.length+' on this page';
     var noResults=document.getElementById('noLocalRecords');if(noResults)noResults.hidden=visible!==0;
   }
   document.querySelectorAll('[data-status-filter]').forEach(function(button){button.addEventListener('click',function(){
     localStatus=button.dataset.statusFilter;
     document.querySelectorAll('[data-status-filter]').forEach(function(b){var on=b===button;b.classList.toggle('is-active',on);b.setAttribute('aria-pressed',String(on));});
     applyShipmentView();
   });});
   if(localSort)localSort.addEventListener('change',applyShipmentView);
   if(quickFind)quickFind.addEventListener('input',function(){if(clearFind)clearFind.hidden=!quickFind.value;applyShipmentView();});
   if(clearFind)clearFind.addEventListener('click',function(){quickFind.value='';clearFind.hidden=true;applyShipmentView();quickFind.focus();});
   applyShipmentView();
 }

 // Confirm sensitive movement actions in a branded, keyboard-accessible dialog.
 document.querySelectorAll('form[data-review]').forEach(function(form){
   var sending=false, modal=document.createElement('dialog');modal.className='nl-review-dialog';
   modal.innerHTML='<div class="nl-review-head"><span class="caps">REVIEW BEFORE SAVING</span><h2 id="nlReviewHeading"></h2><p id="nlReviewSubtitle"></p></div><div class="nl-review-body"><div id="nlReviewFacts"></div><div id="nlReviewNote" class="nl-review-note"></div></div><div class="nl-review-actions"><button type="button" class="btn light" data-review-cancel>Go back</button><button type="button" class="btn primary" data-review-accept>Confirm update</button></div>';
   document.body.appendChild(modal);
   var title=modal.querySelector('#nlReviewHeading'),sub=modal.querySelector('#nlReviewSubtitle'),facts=modal.querySelector('#nlReviewFacts'),note=modal.querySelector('#nlReviewNote'),yes=modal.querySelector('[data-review-accept]');
   function val(name){var field=form.elements.namedItem(name);return field?(field.tagName==='SELECT'&&field.selectedIndex>=0?field.options[field.selectedIndex].text:field.value.trim()):'';}
   function addFact(label,value){var row=document.createElement('div');row.className='nl-review-fact';var l=document.createElement('span'),v=document.createElement('strong');l.textContent=label;v.textContent=value||'Not provided';row.appendChild(l);row.appendChild(v);facts.appendChild(row);}
   function saveOnce(){
     if(sending)return;
     if(!form.reportValidity())return;
     sending=true;yes.disabled=true;yes.textContent='Submitting…';
     if(modal.open)modal.close();
     // Native submission bypasses a second submit event and the review re-entry bug.
     HTMLFormElement.prototype.submit.call(form);
   }
   form.addEventListener('submit',function(e){
     if(sending){e.preventDefault();return;}
     if(form.dataset.nlConfirmedByReview==='true'){e.preventDefault();saveOnce();return;}
     e.preventDefault();if(!form.reportValidity())return;
     var correction=form.dataset.review==='correction';facts.textContent='';
     title.textContent=correction?'Restore previous checkpoint?':'Record this shipment checkpoint?';
     sub.textContent=correction?'Review the shipment and reason before restoring the previous status.':'Confirm the details before they become part of the tracking history.';
     if(correction){addFact('Shipment', '#'+val('shipmentId'));addFact('Latest movement', '#'+val('movementId'));addFact('Reason',val('reason'));note.textContent='Only the latest eligible checkpoint can be reversed. The database records an audit entry.';yes.textContent='Confirm undo';}
     else{addFact('Next status',val('status'));addFact('Checkpoint',val('locationText'));addFact('Port',val('portId')||'Other / offshore location');addFact('Remarks',val('remarks')||'None');note.textContent='Only the owning Seller can record a movement. The database validates the transition and records the event time.';yes.textContent='Record checkpoint';}
     if(typeof modal.showModal==='function')modal.showModal();
     else if(window.nlShowSiteConfirm)window.nlShowSiteConfirm(form,title.textContent,e.submitter);
   });
   modal.querySelector('[data-review-cancel]').addEventListener('click',function(){modal.close();});
   modal.addEventListener('click',function(e){if(e.target===modal)modal.close();});
   yes.addEventListener('click',saveOnce);
 });
 // A focused alternative to a flat movement table: grouped shipment logs or chronological rows.
 document.querySelectorAll('[data-movement-view]').forEach(function(button){button.addEventListener('click',function(){
   var mode=button.dataset.movementView;
   document.querySelectorAll('[data-movement-view]').forEach(function(b){var active=b===button;b.classList.toggle('is-active',active);b.setAttribute('aria-pressed',String(active));});
   document.querySelectorAll('[data-movement-panel]').forEach(function(panel){panel.hidden=panel.dataset.movementPanel!==mode;});
 });});
 document.querySelectorAll('[data-group-action]').forEach(function(button){button.addEventListener('click',function(){var open=button.dataset.groupAction==='expand';document.querySelectorAll('.movement-group').forEach(function(group){group.open=open;});});});
 document.querySelectorAll('[data-days]').forEach(function(button){button.addEventListener('click',function(){var form=button.closest('form');if(!form)return;var a=form.querySelector('[name=startDate]'),b=form.querySelector('[name=endDate]');if(!a||!b)return;
   function formatDate(d){var y=d.getFullYear(),m=String(d.getMonth()+1).padStart(2,'0'),day=String(d.getDate()).padStart(2,'0');return y+'-'+m+'-'+day;}
   var to=new Date(),from=new Date(to.getFullYear(),to.getMonth(),to.getDate());from.setDate(from.getDate()-Number(button.dataset.days)+1);a.value=formatDate(from);b.value=formatDate(to);form.requestSubmit?form.requestSubmit():form.submit();
 });});

 // Export menu: open above summary cards, flip when near the viewport edge, close outside/Escape.
 document.querySelectorAll('.csv-menu').forEach(function(menu){
   var container=menu.closest('.profit-filter-card');
   menu.addEventListener('toggle',function(){
     if(container)container.classList.toggle('csv-report-elevated',menu.open);
     if(!menu.open){menu.classList.remove('menu-up');return;}
     var panel=menu.querySelector('.csv-options'),rect=menu.getBoundingClientRect();
     var needed=Math.min(panel?panel.scrollHeight:220,window.innerHeight*.55)+24;
     menu.classList.toggle('menu-up',window.innerHeight-rect.bottom<needed&&rect.top>needed);
   });
   document.addEventListener('click',function(e){if(menu.open&&!menu.contains(e.target))menu.open=false;});
   document.addEventListener('keydown',function(e){if(e.key==='Escape'&&menu.open){menu.open=false;menu.querySelector('summary').focus();}});
 });
 // Contextual jump-to-top appears only after a user has actually scrolled.
 if(document.querySelector('.main-area')){
   var back=document.createElement('button');back.className='nl-backtop';back.type='button';back.textContent='Top';back.setAttribute('aria-label','Back to top');back.title='Back to top';document.body.appendChild(back);
   function syncBack(){back.classList.toggle('is-visible',window.scrollY>550);}
   window.addEventListener('scroll',syncBack,{passive:true});syncBack();
   back.addEventListener('click',function(){window.scrollTo({top:0,behavior:window.matchMedia('(prefers-reduced-motion: reduce)').matches?'instant':'smooth'});});
 }

 function toast(message){var old=document.getElementById('nlToast');if(old)old.remove();var item=document.createElement('div');item.id='nlToast';item.className='toast';item.setAttribute('role','status');item.textContent=message;document.body.appendChild(item);setTimeout(function(){item.remove();},3300);}
})();
</script>
