<jsp:useBean id="nlViewSupport_Module1_users" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_users" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_users" property="view" value="Module1/users.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>



<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>N-LOGISTIC | Users</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
<%@ include file="../shared/_theme.jsp" %>

<style>
/* v16.9 | Asset-free administration hero; animation stays inside the card. */
.nl-user-hero{position:relative;isolation:isolate;display:grid;grid-template-columns:minmax(0,1fr) minmax(230px,290px);gap:18px;align-items:center;min-height:198px;margin-bottom:20px;padding:20px 26px;border:1px solid #edcbb0;border-radius:23px;overflow:hidden;background:linear-gradient(118deg,#fffcf8 0%,#fff1e3 74%,#ffe4cb 100%);box-shadow:0 16px 34px rgba(85,50,22,.07)}
.nl-user-hero:before{content:"";position:absolute;right:-64px;top:-91px;width:244px;height:244px;border:1px solid #edcba9;border-radius:50%;box-shadow:0 0 0 26px #ffeddc99,0 0 0 55px #ffe5cd88;pointer-events:none}
.nl-user-hero .uh-copy,.nl-user-hero .uh-art{position:relative;z-index:1;min-width:0}
.nl-user-hero .uh-kicker{font-size:.75rem;letter-spacing:.13em;text-transform:uppercase;font-weight:850;color:#af4b19}
.nl-user-hero h1{font-size:clamp(1.7rem,2.55vw,2.35rem);font-weight:900;color:#34231b;margin:.35rem 0 .5rem}
.nl-user-hero p{font-size:.89rem;line-height:1.55;color:#765e50;max-width:710px;margin:0}
.nl-user-hero .uh-art{height:156px;width:100%;max-width:290px;justify-self:end;overflow:hidden;border-radius:18px}
.nl-user-hero .uh-scene{position:absolute;inset:0;width:100%;height:100%;filter:drop-shadow(0 9px 10px #9b5a2b28)}
.nl-user-hero .uh-orbit{position:absolute;inset:5px 12px;border-radius:50%;border:1px solid #e9b991;background:radial-gradient(circle at 55% 54%,#fffcf9 0,#ffe1c6 85%)}
.nl-user-hero .uh-card{position:absolute;left:67px;top:24px;width:166px;height:104px;border-radius:15px;border:3px solid #a45a2f;background:linear-gradient(140deg,#fffefa,#ffdcba);box-shadow:9px 10px 0 #b3613227;animation:uhFloat 6s ease-in-out infinite}
.nl-user-hero .uh-avatar{position:absolute;left:18px;top:18px;width:59px;height:60px;border-radius:12px;background:#f8bd90;overflow:hidden}
.nl-user-hero .uh-avatar:before{content:"";position:absolute;top:10px;left:20px;width:21px;height:21px;border-radius:50%;background:#fff1df;border:2px solid #a55a2b}
.nl-user-hero .uh-avatar:after{content:"";position:absolute;left:8px;bottom:-13px;width:47px;height:41px;background:#a45a2e;border-radius:50% 50% 0 0}
.nl-user-hero .uh-lines{position:absolute;right:14px;top:29px;width:55px;display:grid;gap:9px}
.nl-user-hero .uh-lines i{display:block;height:7px;border-radius:10px;background:#dda77b}
.nl-user-hero .uh-lines i:nth-child(2){width:80%;background:#edc49f}.nl-user-hero .uh-lines i:nth-child(3){width:60%;background:#edc49f}
.nl-user-hero .uh-seal{position:absolute;top:10px;right:7px;width:51px;height:51px;border-radius:50%;background:linear-gradient(145deg,#ffbd83,#da5b18);border:5px solid #fff8ef;box-shadow:0 8px 15px #a3562a30;animation:uhPulse 4.8s ease-in-out infinite}
.nl-user-hero .uh-seal:before,.nl-user-hero .uh-seal:after{content:"";position:absolute;background:#fff9f2;border-radius:8px}
.nl-user-hero .uh-seal:before{width:22px;height:5px;left:10px;top:18px}.nl-user-hero .uh-seal:after{width:5px;height:22px;left:18px;top:10px}
.nl-user-hero .uh-ticket{position:absolute;left:25px;bottom:9px;width:90px;height:41px;border-radius:11px;border:2px solid #b96c3c;transform:rotate(-9deg);background:#fffaf4;animation:uhTicket 5.5s ease-in-out infinite}
.nl-user-hero .uh-ticket:before,.nl-user-hero .uh-ticket:after{content:"";position:absolute;left:12px;right:12px;height:5px;border-radius:10px;background:#edc299}
.nl-user-hero .uh-ticket:before{top:11px}.nl-user-hero .uh-ticket:after{top:22px;right:27px}
@keyframes uhFloat{0%,100%{transform:translateY(0)}50%{transform:translateY(-5px)}}
@keyframes uhPulse{0%,100%{transform:scale(1)}50%{transform:scale(1.08)}}
@keyframes uhTicket{0%,100%{transform:rotate(-9deg) translateY(0)}50%{transform:rotate(-9deg) translateY(-4px)}}
@media(max-width:790px){.nl-user-hero{grid-template-columns:1fr;min-height:0;padding:18px 20px}.nl-user-hero .uh-art{display:none}}
@media(prefers-reduced-motion:reduce){.nl-user-hero *{animation:none!important}}
/* v18.2 – Add User and Search Users share a 50/50 administrative workspace. */
.nl-user-half-layout{display:grid;grid-template-columns:minmax(0,1.45fr) minmax(330px,1fr);gap:16px;align-items:start;margin-bottom:20px}
.nl-user-half-layout>.card{height:auto;margin-bottom:0!important;min-width:0;background:#fffdf9;box-shadow:0 10px 24px rgba(84,51,26,.07)!important;border:1px solid #eed3bc!important}
.nl-user-half-layout .nl-user-half-add .row>.col-md-6{width:50%;flex:0 0 50%}
.nl-user-half-layout .nl-user-half-add .row>.col-md-4{width:50%;flex:0 0 50%}
.nl-user-half-layout .nl-user-half-add .row>.col-12{padding-top:3px}
.nl-user-half-layout .nl-user-half-search .card-body{padding:8px!important}
.nl-user-half-layout .nl-user-search-inputs > div{width:100%;flex:0 0 100%}
.nl-user-half-layout .nl-user-half-search form{margin-top:12px}
.nl-user-half-layout .form-control,.nl-user-half-layout .form-select{min-height:44px;border-radius:11px}
.nl-user-half-layout .nl-user-half-search .card-body h5{margin:0!important;padding-bottom:12px;border-bottom:1px solid #efddcf}

@media(max-width:1270px){.nl-user-half-layout{grid-template-columns:1fr}.nl-user-half-layout .nl-user-half-add .row>.col-md-6,.nl-user-half-layout .nl-user-half-add .row>.col-md-4{width:50%;flex:0 0 50%}}
@media(max-width:620px){.nl-user-half-layout .nl-user-half-add .row>.col-md-6,.nl-user-half-layout .nl-user-half-add .row>.col-md-4{width:100%;flex:0 0 100%}}
/* v18.3: more balanced account form / search cards, retained original controls. */
.nl-user-half-layout .nl-user-half-add{padding:20px!important}
.nl-user-half-layout .nl-user-half-add form.row{row-gap:11px!important}
.nl-user-half-layout .nl-user-half-search .card-body{padding:6px!important}
.nl-user-half-layout .nl-user-half-search .btn{min-height:43px}
.nl-user-half-layout .nl-user-half-add .form-text{line-height:1.35}

/* v18.8: opt-in searchable Admin company selector; original select remains the no-JS fallback. */
.nl-user-company-picker{position:relative;min-width:0}
.nl-user-company-inputline{display:grid;grid-template-columns:minmax(0,1fr) 42px;gap:7px}
.nl-user-company-inputline input{min-width:0}
.nl-user-company-toggle{border:1px solid #dbbd9e;background:#fff8ef;color:#ac4f19;border-radius:10px;font-size:1.15rem;min-height:44px;cursor:pointer}
.nl-user-company-list{position:absolute;top:calc(100% + 5px);left:0;right:0;max-height:248px;overflow-y:auto;overscroll-behavior:contain;z-index:25;background:#fffdfa;border:1px solid #e3c4aa;border-radius:12px;box-shadow:0 14px 30px #43270c33;padding:6px}
.nl-user-company-list[hidden]{display:none!important}
.nl-user-company-option{display:block;width:100%;text-align:left;padding:10px 12px;border:0;background:transparent;color:#563521;border-radius:8px;cursor:pointer;overflow-wrap:anywhere}
.nl-user-company-option:hover,.nl-user-company-option:focus{background:#fff0df}
.nl-user-company-help{display:block;font-size:.78rem;margin-top:6px;color:#856652}
.nl-user-half-add .nl-user-feedback{font-size:.89rem;line-height:1.5;margin-bottom:16px}
html[data-nl-mode="dark"] .nl-user-company-toggle,html[data-nl-mode="dark"] .nl-user-company-list{background:#263646;color:#e9eff6;border-color:#58687a}
html[data-nl-mode="dark"] .nl-user-company-option{color:#eaf1f8}
html[data-nl-mode="dark"] .nl-user-company-option:hover,html[data-nl-mode="dark"] .nl-user-company-option:focus{background:#34475b}
html[data-nl-mode="dark"] .nl-user-company-help{color:#b5c8d9}

/* v19.3 module-specific dark appearance, presentation only. */
html[data-nl-mode="dark"] body.nl-themed-page .nl-user-half-layout .card,html[data-nl-mode="dark"] body.nl-themed-page .nl-user-hero,html[data-nl-mode="dark"] body.nl-themed-page .nl-user-company-list,html[data-nl-mode="dark"] body.nl-themed-page .nl-user-company-option,html[data-nl-mode="dark"] body.nl-themed-page .nl-user-company-toggle{background:#203044!important;color:#edf5fc!important;border-color:#526a80!important}
html[data-nl-mode="dark"] body.nl-themed-page .nl-user-company-option:hover{background:#30465a!important}
</style>
</head>

<body data-nl-screen="module1-users" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module1_users__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">


<div class="container-fluid px-0"><div class="row"><div class="col-12 p-2">

            <section class="nl-user-hero" aria-labelledby="nlUserPageTitle">
              <div class="uh-copy"><div class="uh-kicker">Administration / Account directory</div><h1 id="nlUserPageTitle">User management</h1><p>Manage registered accounts, permissions and access in one secure workspace. Add a user or find an existing account below.</p></div>
              <div class="uh-art" aria-hidden="true"><div class="uh-scene"><div class="uh-orbit"></div><div class="uh-card"><span class="uh-avatar"></span><span class="uh-lines"><i></i><i></i><i></i></span></div><span class="uh-seal"></span><span class="uh-ticket"></span></div></div>
            </section>

            ${requestScope.nlv_Module1_users__2}
            ${requestScope.nlv_Module1_users__3}

            <div class="nl-user-half-layout">
            <div class="card p-4 mb-4 shadow-sm rounded-4 border-warning-subtle nl-user-half-add">
              <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3"><div><h4 class="fw-bold mb-1">Add a user</h4><p class="text-muted small mb-0">Create an account under an existing company; permissions are assigned on the server.</p></div><span class="badge text-bg-warning">Admin only</span></div>
              ${requestScope.nlv_Module1_users__4}
              <form method="post" action="${requestScope.nlv_Module1_users__5}/Module1Controller" class="row g-3">
              <input type="hidden" name="action" value="addUser"><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_users__6}">
              <div class="col-md-6"><label class="form-label">Full name</label><input class="form-control" name="fullName" maxlength="100" value="${requestScope.nlv_Module1_users__7}" required></div>
              <div class="col-md-6"><label class="form-label">Email</label><input class="form-control" type="email" name="email" maxlength="120" autocomplete="off" value="${requestScope.nlv_Module1_users__8}" required></div>
              <div class="col-md-4"><label class="form-label">Phone</label><input class="form-control" name="phone" maxlength="20" value="${requestScope.nlv_Module1_users__9}"></div>
              <div class="col-md-4"><label class="form-label">Role</label><select class="form-select" name="role" id="nlAdminUserRole" required><option value="CONSUMER" ${requestScope.nlv_Module1_users__10}>Consumer</option><option value="SELLER" ${requestScope.nlv_Module1_users__11}>Seller</option><option value="ADMIN" ${requestScope.nlv_Module1_users__12}>Admin</option></select></div>
              <div class="col-md-4"><label class="form-label" for="nlAdminCompanyQuery">Company</label>
              <div class="nl-user-company-picker" id="nlAdminCompanyPicker">
                <select class="form-select" name="companyId" id="nlAdminCompany" aria-label="Choose existing company">
                  <option value="">Choose company</option>
                  <jsp:setProperty name="nlViewSupport_Module1_users" property="fragment" value="nlv_Module1_users__13" /><jsp:getProperty name="nlViewSupport_Module1_users" property="fragment" />
                </select>
                <div class="nl-user-company-inputline" id="nlAdminCompanyCustom" hidden="hidden">
                  <input class="form-control" id="nlAdminCompanyQuery" type="search" placeholder="Type or select a company" autocomplete="off" aria-label="Search existing companies" role="combobox" aria-expanded="false" aria-controls="nlAdminCompanyOptions"/>
                  <button class="nl-user-company-toggle" id="nlAdminCompanyToggle" type="button" aria-label="Show all eligible companies" aria-controls="nlAdminCompanyOptions" aria-expanded="false">&#9662;</button>
                </div>
                <div class="nl-user-company-list" id="nlAdminCompanyOptions" role="listbox" hidden="hidden"></div>
              </div>
              <span class="nl-user-company-help">Choose an existing Seller/Consumer company. Admin accounts do not belong to a company.</span></div>
              <div class="col-md-6"><label class="form-label">Temporary password</label><input class="form-control" id="nlAdminTempPassword" name="password" type="password" maxlength="255" autocomplete="new-password" required></div>
              <div class="col-12"><button type="submit" class="btn btn-warning px-4">Create user</button></div>
              </form>
              <script>(function(){'use strict';
                var role=document.getElementById('nlAdminUserRole'),co=document.getElementById('nlAdminCompany');
                var query=document.getElementById('nlAdminCompanyQuery'),toggle=document.getElementById('nlAdminCompanyToggle');
                var panel=document.getElementById('nlAdminCompanyOptions'),custom=document.getElementById('nlAdminCompanyCustom');
                if(!role||!co||!query||!toggle||!panel||!custom)return;
                var options=Array.from(co.options).filter(function(o){return !!o.value;});
                var listOpen=false;
                function visibleOptions(){return options.filter(function(o){return o.dataset.type===role.value;});}
                function close(){listOpen=false;panel.hidden=true;query.setAttribute('aria-expanded','false');toggle.setAttribute('aria-expanded','false');}
                function render(){var needle=query.value.trim().toLowerCase();panel.textContent='';
                  var list=visibleOptions().filter(function(o){return !needle||o.textContent.toLowerCase().includes(needle);});
                  list.forEach(function(o){var btn=document.createElement('button');btn.type='button';btn.className='nl-user-company-option';btn.setAttribute('role','option');btn.textContent=o.textContent;btn.dataset.id=o.value;
                    btn.addEventListener('click',function(){co.value=o.value;query.value=o.textContent.trim();query.setCustomValidity('');close();});panel.appendChild(btn);});
                  if(!list.length){var empty=document.createElement('div');empty.className='nl-user-company-help';empty.style.padding='10px';empty.textContent='No matching existing '+role.value.toLowerCase()+' company.';panel.appendChild(empty);}
                }
                function open(){if(role.value==='ADMIN')return;render();listOpen=true;panel.hidden=false;query.setAttribute('aria-expanded','true');toggle.setAttribute('aria-expanded','true');}
                function sync(){var old=co.value;options.forEach(function(o){o.hidden=o.dataset.type!==role.value;});
                  if(old&&(!co.selectedOptions[0]||co.selectedOptions[0].dataset.type!==role.value))co.value='';
                  co.disabled=role.value==='ADMIN';co.required=false;query.disabled=role.value==='ADMIN';query.required=role.value!=='ADMIN';toggle.disabled=role.value==='ADMIN';
                  query.value=co.value?co.options[co.selectedIndex].textContent.trim():'';query.setCustomValidity('');close();}
                // Keep the standard SELECT visible if JavaScript fails. Only enhance after listeners are ready.
                toggle.addEventListener('click',function(){if(listOpen)close();else {query.value=co.value?'':query.value;open();}});
                query.addEventListener('focus',open);
                query.addEventListener('input',function(){co.value='';query.setCustomValidity('');open();});
                query.addEventListener('keydown',function(e){if(e.key==='Escape')close();if(e.key==='ArrowDown'){e.preventDefault();open();panel.querySelector('button')?.focus();}});
                panel.addEventListener('keydown',function(e){if(e.key==='Escape'){close();query.focus();}if(e.key==='ArrowDown'||e.key==='ArrowUp'){e.preventDefault();var buttons=Array.from(panel.querySelectorAll('button'));var idx=buttons.indexOf(document.activeElement),next=(idx+(e.key==='ArrowDown'?1:-1)+buttons.length)%buttons.length;buttons[next]?.focus();}});
                document.addEventListener('click',function(e){if(!document.getElementById('nlAdminCompanyPicker').contains(e.target))close();});
                var form=co.closest('form');form.addEventListener('submit',function(e){if(role.value!=='ADMIN'&&!co.value){e.preventDefault();query.setCustomValidity('Choose an existing company from the suggestions.');query.reportValidity();open();}else query.setCustomValidity('');});
                role.addEventListener('change',sync);
                custom.hidden=false;co.style.display='none';co.tabIndex=-1;co.setAttribute('aria-hidden','true');sync();
              })();</script>
              <script>document.getElementById("nlAdminTempPassword").minLength = 8;</script>
            </div>
            <!-- SEARCH FORM -->
            <div class="card shadow-sm p-3 mb-3 border-0 mb-4 rounded-4 border-warning-subtle nl-user-half-search">

                <div class="card-body p-4">

                    <h5 class="fw-bold mb-3">Search Users</h5>

                    <form action="Module1Controller" method="get">

                        <input type="hidden" name="action"
                               value="searchUsers">

                        <div class="row g-3 nl-user-search-inputs">

                            <div class="col-md-4">
                                <label class="form-label" for="nlSearchUsersKeyword">Name or email</label><input type="text"
                                       id="nlSearchUsersKeyword" name="keyword"
                                       class="form-control"
                                       placeholder="Search name or email">
                            </div>

                            <div class="col-md-3">
                                <label class="form-label" for="nlSearchUsersRole">Role</label><select id="nlSearchUsersRole" name="role" class="form-select">
                                    <option value="">All Roles</option>
                                    <option value="ADMIN">ADMIN</option>
                                    <option value="CONSUMER">CONSUMER</option>
                                    <option value="SELLER">SELLER</option>
                                </select>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label" for="nlSearchUsersStatus">Account status</label><select id="nlSearchUsersStatus" name="status" class="form-select">
                                    <option value="">All Status</option>
                                    <option value="ACTIVE">ACTIVE</option>
                                    <option value="INACTIVE">INACTIVE</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <button type="submit"
                                        class="btn btn-warning bg-gradient w-100">
                                    Search
                                </button>
                            </div>

                        </div>
                    </form>
                    <div class="mt-3 small text-secondary">Searches the authorized user directory in the database. Use the original results table below to update or deactivate accounts.</div>
                </div>
            </div>

            </div><!-- /nl-user-half-layout -->

            <!-- USER TABLE -->
            <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

                <div class="card-body p-4">

                    <div class="d-flex justify-content-between mb-3">
                        <h5 class="fw-bold">Registered Users</h5>
                        <span class="badge bg-warning text-dark">
                            User Records
                        </span>
                    </div>

                    <div class="table-responsive rounded-3">

                        <table class="table table-hover align-middle table-striped">

                            <thead class="table-warning">
                                <tr>
                                    <th>User ID</th>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>

                            <tbody>

                            <jsp:setProperty name="nlViewSupport_Module1_users" property="fragment" value="nlv_Module1_users__14" /><jsp:getProperty name="nlViewSupport_Module1_users" property="fragment" />

                            </tbody>

                        </table>

                    </div>
                </div>
            </div>

            <!-- A single update for several fields, with an atomic audited DB transaction. -->
            <div class="modal fade nl-account-modal" id="updateModal" tabindex="-1" aria-labelledby="updateUserModalTitle" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable"><div class="modal-content">
                <form action="${requestScope.nlv_Module1_users__15}/Module1Controller" method="post" id="nlAdminBulkForm">
                  <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_users__16}">
                  <input type="hidden" name="action" value="updateUser"><input type="hidden" name="editMode" value="all"><input type="hidden" name="recordId" id="updateUserId">
                  <div class="modal-header nl-account-modal-head"><div><div class="nl-eyebrow">ADMINISTRATION / USER ACCOUNT</div><h2 class="modal-title h4 mb-0" id="updateUserModalTitle">Edit account</h2>
                  <p class="small text-secondary mb-0 mt-2">Update name, contact and account status together. Leave fields unchanged if no change is needed.</p></div>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close editor"></button></div>
                  <div class="modal-body p-4">
                    <div class="row g-3">
                      <div class="col-md-6"><label for="nlBulkName" class="form-label fw-semibold">Full name <span class="text-danger">*</span></label><input id="nlBulkName" name="fullName" class="form-control" maxlength="100" autocomplete="off" required="required"></div>
                      <div class="col-md-6"><label for="nlBulkEmail" class="form-label fw-semibold">Email address <span class="text-danger">*</span></label><input id="nlBulkEmail" type="email" name="email" class="form-control" maxlength="120" autocomplete="off" required="required"></div>
                      <div class="col-md-6"><label for="nlBulkPhone" class="form-label fw-semibold">Phone number</label><input id="nlBulkPhone" type="tel" name="phone" class="form-control" maxlength="20" placeholder="Optional"></div>
                      <div class="col-md-6"><label for="nlBulkStatus" class="form-label fw-semibold">Account access <span class="text-danger">*</span></label><select id="nlBulkStatus" name="status" class="form-select" required="required"><option value="ACTIVE">Active — can sign in</option><option value="INACTIVE">Inactive — cannot sign in</option><option value="LOCKED">Locked — access restricted</option></select></div>
                    </div>
                    <div class="nl-modal-advice mt-4"><strong>One save, multiple updates</strong><p class="mb-0 mt-1">Only changed details are updated. The entire change is committed together, with an audit record. Role and company remain unchanged.</p></div>
                  </div>
                  <div class="modal-footer justify-content-between p-3"><small class="text-secondary">All fields can be reviewed before saving.</small><div class="d-flex gap-2"><button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-warning">Save account changes</button></div></div>
                </form>
              </div></div>
            </div>

            <div class="text-center text-secondary mt-5">
                <small>N-LOGISTIC Management System | User Management</small>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>




</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script>
(function(){'use strict';
 const myId=String('${requestScope.nlv_Module1_users__17}');
 const editor=document.getElementById('updateModal');if(!editor)return;
 editor.addEventListener('show.bs.modal',function(ev){
   const button=ev.relatedTarget;if(!button)return;
   const current=button.dataset.id===myId;
   const status=document.getElementById('nlBulkStatus');if(!status)return;
   Array.from(status.options).forEach(opt=>{if(opt.value==='INACTIVE'||opt.value==='LOCKED'){opt.hidden=current;opt.disabled=current;}});
   if(current)status.value='ACTIVE';
   const note=editor.querySelector('.nl-modal-advice p');if(note){note.textContent=current?'This is your current Admin account. You can update your contact details, but the account must remain Active.':'Only changed details are updated and the change is audited. Role and company remain unchanged.';}
 });
})();
</script>
</body>
</html>
