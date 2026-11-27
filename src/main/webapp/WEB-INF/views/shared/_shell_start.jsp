<jsp:useBean id="nlViewSupport_shared__shell_start" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_shared__shell_start" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_shared__shell_start" property="view" value="shared/_shell_start.jsp" />


<header class="nl-app-header navbar navbar-dark bg-dark bg-gradient shadow-sm border-bottom border-warning px-3 px-lg-4 py-3 sticky-top gap-2" role="banner">
  <div class="d-flex align-items-center gap-3">
    <button type="button" class="btn btn-outline-warning border-0 rounded-3" id="nlMenuToggle" aria-label="Toggle navigation" title="Toggle sidebar" aria-controls="nlMobileNav"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGNUU1QzkiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik00IDdoMTZNNCAxMmgxNk00IDE3aDE2Ii8+PC9zdmc+" width="22" height="22" alt="" aria-hidden="true"></button>
    <a class="navbar-brand fw-bold fs-5 text-warning d-flex align-items-center gap-2 mb-0 border border-warning rounded-pill px-3 py-2" href="${requestScope.nlv_shared__shell_start__1}/Module1Controller?action=dashboard"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGNUU1QzkiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjIiIHk9IjUiIHdpZHRoPSIyMCIgaGVpZ2h0PSIxNCIgcng9IjIiLz48cGF0aCBkPSJNNiA1djE0TTEwIDV2MTRNMTQgNXYxNE0xOCA1djE0Ii8+PC9zdmc+" width="23" height="23" alt="" aria-hidden="true"> N-LOGISTIC</a>
  </div>
  <form role="search" class="d-none d-md-flex align-items-center bg-body-secondary rounded-pill border border-warning-subtle px-3 py-1 mx-auto gap-2 shadow-sm" action="${requestScope.nlv_shared__shell_start__2}/Module1Controller" method="get" aria-label="Search accessible records and pages">
    <input type="hidden" name="action" value="workspaceSearch"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM0RDM0MjUiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxjaXJjbGUgY3g9IjExIiBjeT0iMTEiIHI9IjciLz48cGF0aCBkPSJtMTYgMTYgNSA1Ii8+PC9zdmc+" width="19" height="19" alt="" aria-hidden="true"><label for="nlWorkspaceSearch" class="visually-hidden">Search authorized records and pages</label>
    <input id="nlWorkspaceSearch" class="form-control form-control-sm bg-body-secondary border-0" type="search" name="q" maxlength="64" placeholder="Search records or pages... (Ctrl+K)" autocomplete="off" required>
    <button class="btn btn-warning btn-sm bg-gradient fw-semibold rounded-pill px-3" type="submit">Search</button>
  </form>
  ${requestScope.nlv_shared__shell_start__3}
  <div class="nl-header-utilities d-flex align-items-center gap-2 ms-auto ms-lg-0">
    <button type="button" class="nl-theme-switch nl-theme-header" data-nl-theme-toggle aria-label="Switch to dark mode" aria-pressed="false" title="Switch to dark mode"><span data-nl-theme-symbol aria-hidden="true">&#9790;</span><span data-nl-theme-label>Dark mode</span></button>
    <div class="dropdown nl-quick-dropdown">
      <button type="button" class="nl-header-action btn btn-outline-warning dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Open quick actions">Quick actions</button>
      <ul class="dropdown-menu dropdown-menu-end nl-header-dropdown shadow-lg">
        <li><h6 class="dropdown-header">Workspace shortcuts</h6></li>
        <li><a class="dropdown-item" href="${requestScope.nlv_shared__shell_start__4}/containerMovement?action=shipments">Shipment tracking</a></li>
        <jsp:setProperty name="nlViewSupport_shared__shell_start" property="fragment" value="nlv_shared__shell_start__5" /><jsp:getProperty name="nlViewSupport_shared__shell_start" property="fragment" />
        <jsp:setProperty name="nlViewSupport_shared__shell_start" property="fragment" value="nlv_shared__shell_start__6" /><jsp:getProperty name="nlViewSupport_shared__shell_start" property="fragment" />
        <jsp:setProperty name="nlViewSupport_shared__shell_start" property="fragment" value="nlv_shared__shell_start__7" /><jsp:getProperty name="nlViewSupport_shared__shell_start" property="fragment" />
        <jsp:setProperty name="nlViewSupport_shared__shell_start" property="fragment" value="nlv_shared__shell_start__8" /><jsp:getProperty name="nlViewSupport_shared__shell_start" property="fragment" />
        <jsp:setProperty name="nlViewSupport_shared__shell_start" property="fragment" value="nlv_shared__shell_start__9" /><jsp:getProperty name="nlViewSupport_shared__shell_start" property="fragment" />
      </ul>
    </div>
    <div class="dropdown nl-account-dropdown">
      <button type="button" class="nl-account-toggle btn btn-outline-warning dropdown-toggle d-flex align-items-center gap-2" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Account menu: ${requestScope.nlv_shared__shell_start__10}">
        <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGNUU1QzkiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxjaXJjbGUgY3g9IjEyIiBjeT0iNyIgcj0iNCIvPjxwYXRoIGQ9Ik00IDIxdi0yYTggOCAwIDAgMSAxNiAwdjJ6Ii8+PC9zdmc+" width="21" height="21" alt="" aria-hidden="true">
        <span class="nl-account-identity d-none d-xl-flex flex-column text-start"><strong>${requestScope.nlv_shared__shell_start__11}</strong><span>${requestScope.nlv_shared__shell_start__12}</span></span>
      </button>
      <ul class="dropdown-menu dropdown-menu-end nl-header-dropdown nl-account-menu shadow-lg">
        <li><h6 class="dropdown-header">${requestScope.nlv_shared__shell_start__13} workspace</h6></li>
        <li><a class="dropdown-item" href="${requestScope.nlv_shared__shell_start__14}/Module1Controller?action=dashboard">Overview</a></li>
        <li><a class="dropdown-item" href="${requestScope.nlv_shared__shell_start__15}/Module1Controller?action=viewProfile">My profile</a></li>
        <li><hr class="dropdown-divider"></li>
        <li><form method="post" action="${requestScope.nlv_shared__shell_start__16}/Module1Controller"><input type="hidden" name="action" value="logout"><input type="hidden" name="csrfToken" value="${requestScope.nlv_shared__shell_start__17}"><button type="submit" class="dropdown-item">Sign out</button></form></li>
      </ul>
    </div>
  </div>
</header>
<div class="offcanvas offcanvas-start bg-warning-subtle d-lg-none" tabindex="-1" id="nlMobileNav" aria-labelledby="nlMobileNavHeading">
  <div class="offcanvas-header bg-dark bg-gradient text-warning"><h2 class="offcanvas-title fs-5 fw-bold" id="nlMobileNavHeading">N-LOGISTIC</h2><button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Close navigation"></button></div>
  <div class="offcanvas-body p-0 d-block"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" />
    <form role="search" class="p-3 d-md-none" action="${requestScope.nlv_shared__shell_start__18}/Module1Controller" method="get"><input type="hidden" name="action" value="workspaceSearch"><label class="form-label" for="nlMobileSearch">Search records</label><div class="input-group"><input class="form-control" id="nlMobileSearch" name="q" maxlength="64" placeholder="Search..." required><button class="btn btn-warning bg-gradient" type="submit">Search</button></div></form>
  </div>
</div>

<!-- v19.1: top-bar menus work consistently without depending on Bootstrap or page stacking. -->
<script id="nl-header-dropdown-resilience-v191">
(function(){'use strict';
  if(window.__nlHeaderDropdownReady)return;window.__nlHeaderDropdownReady=true;
  function ready(){
    var header=document.querySelector('.nl-app-header');if(!header)return;
    var entries=Array.prototype.slice.call(header.querySelectorAll('.nl-quick-dropdown,.nl-account-dropdown')).map(function(host,i){
      var trigger=host.querySelector('button[data-bs-toggle="dropdown"]');
      var menu=host.querySelector('.nl-header-dropdown');
      if(!trigger||!menu)return null;
      if(!menu.id)menu.id='nlTopMenu'+(i+1);
      trigger.setAttribute('aria-controls',menu.id);
      return {host:host,trigger:trigger,menu:menu,open:false};
    }).filter(Boolean);
    if(!entries.length)return;
    function place(entry){
      if(!entry.open)return;
      var rect=entry.trigger.getBoundingClientRect();
      var w=Math.min(Math.max(entry.menu.scrollWidth||255,245),Math.max(245,window.innerWidth-16));
      w=Math.min(w,window.innerWidth-16);
      var x=Math.max(8,Math.min(window.innerWidth-w-8,rect.right-w));
      var roomBelow=window.innerHeight-rect.bottom-12;
      var roomAbove=rect.top-12;
      var menuH=Math.min(entry.menu.scrollHeight||320,Math.min(490,window.innerHeight-32));
      var above=roomBelow<Math.min(menuH,220)&&roomAbove>roomBelow;
      var y=above?Math.max(8,rect.top-menuH-8):rect.bottom+8;
      entry.menu.style.left=Math.round(x)+'px';entry.menu.style.top=Math.round(y)+'px';
      entry.menu.style.width=Math.round(w)+'px';entry.menu.style.maxHeight=Math.max(110,Math.floor(above?roomAbove:roomBelow))+'px';
    }
    function shut(entry,restoreFocus){
      if(!entry||!entry.open)return;
      entry.open=false;entry.menu.classList.remove('show','nl-header-menu-portal');
      entry.menu.style.removeProperty('left');entry.menu.style.removeProperty('top');entry.menu.style.removeProperty('width');entry.menu.style.removeProperty('max-height');
      entry.menu.style.removeProperty('position');entry.menu.style.removeProperty('z-index');
      entry.host.appendChild(entry.menu);entry.host.classList.remove('show');
      entry.trigger.classList.remove('show');entry.trigger.setAttribute('aria-expanded','false');
      if(restoreFocus)entry.trigger.focus();
    }
    function open(entry,moveFocus){
      entries.forEach(function(e){if(e!==entry)shut(e,false);});
      if(entry.open){if(moveFocus){var first=entry.menu.querySelector('a,button:not([disabled])');if(first)first.focus();}return;}
      entry.open=true;
      entry.host.classList.add('show');entry.trigger.classList.add('show');entry.trigger.setAttribute('aria-expanded','true');
      document.body.appendChild(entry.menu);
      entry.menu.classList.add('show','nl-header-menu-portal');entry.menu.style.position='fixed';entry.menu.style.zIndex='2147483000';
      place(entry);
      if(moveFocus){var item=entry.menu.querySelector('a,button:not([disabled])');if(item)item.focus();}
    }
    entries.forEach(function(entry){
      // Capture the trigger before Bootstrap's document listener; stop duplicate toggles.
      entry.trigger.addEventListener('click',function(event){
        event.preventDefault();event.stopPropagation();
        if(entry.open)shut(entry,false);else open(entry,false);
      },true);
      entry.trigger.addEventListener('keydown',function(event){
        if(event.key==='ArrowDown'||event.key==='Enter'&&event.altKey){event.preventDefault();event.stopPropagation();open(entry,true);}
      });
      entry.menu.addEventListener('click',function(event){
        if(event.target.closest('a[href]'))shut(entry,false);
      });
      entry.menu.addEventListener('keydown',function(event){
        if(event.key==='Tab'&&event.shiftKey&&event.target===entry.menu.querySelector('a,button:not([disabled])')){
          event.preventDefault();shut(entry,true);
        }
      });
    });
    document.addEventListener('click',function(event){
      entries.forEach(function(entry){if(entry.open&&!entry.menu.contains(event.target)&&!entry.trigger.contains(event.target))shut(entry,false);});
    });
    document.addEventListener('keydown',function(event){
      if(event.key==='Escape'){entries.forEach(function(entry){if(entry.open){event.preventDefault();shut(entry,true);}});}
    });
    window.addEventListener('resize',function(){entries.forEach(function(e){if(e.open)place(e);});},{passive:true});
    window.addEventListener('scroll',function(){entries.forEach(function(e){if(e.open)place(e);});},{passive:true,capture:true});
    window.addEventListener('pagehide',function(){entries.forEach(function(e){shut(e,false);});});
  }
  if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',ready,{once:true});else ready();
})();
</script>
