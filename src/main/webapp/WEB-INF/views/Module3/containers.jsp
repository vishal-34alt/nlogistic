<jsp:useBean id="nlViewSupport_Module3_containers" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module3_containers" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module3_containers" property="view" value="Module3/containers.jsp" />
<%@ page pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map,java.util.HashMap" %>
<%@ page import="model.Container" %>



<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>

<style>
.nl-editor-card{border:1px solid #edcba9!important;background:linear-gradient(115deg,#fffefa,#fff5e9)!important;scroll-margin-top:105px}
.nl-editor-card .card-body{padding:clamp(16px,2vw,26px)!important}
.nl-editor-card h5{font-size:1.33rem;letter-spacing:-.02em}
.nl-editor-card .nl-editor-field label{margin-bottom:8px;color:#6b4630}
.nl-editor-card :is(.form-control,.form-select){min-height:46px;border-color:#e2c6b0;background:#fff;color:#3d2a1e;border-radius:11px}
.nl-editor-card .row{align-items:start}
.nl-editor-assist{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px;margin-top:16px}
.nl-editor-assist>div{background:#fff;border:1px solid #efdfcf;border-radius:12px;padding:11px 14px}
.nl-editor-assist small{display:block;color:#8a6650;font-size:.75rem;font-weight:710;margin-bottom:4px}
.nl-editor-assist strong{display:block;color:#52321f;font-size:.92rem;overflow-wrap:anywhere}
.nl-editor-card button[type=submit]{min-height:42px;padding:9px 21px}
@media(max-width:640px){.nl-editor-assist{grid-template-columns:1fr}}
</style>
</head><body data-nl-screen="module3-containers" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module3_containers__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">

<jsp:include page="/WEB-INF/views/shared/header.jsp">
    <jsp:param name="pageTitle" value="Container Directory" />
    <jsp:param name="pageSubtitle" value="View, register and update your container information." />
    <jsp:param name="activeModule" value="inventory" />
    <jsp:param name="navInventoryUrl" value="/ContainerAllocationPricingController?module=container" />
</jsp:include>

<jsp:include page="/WEB-INF/views/shared/tabs.jsp">
    <jsp:param name="module" value="inventory" />
    <jsp:param name="activeTab" value="directory" />
    <jsp:param name="tab1Key" value="directory" />
    <jsp:param name="tab1Label" value="Container directory" />
    <jsp:param name="tab1Url" value="/ContainerAllocationPricingController?module=container" />
    <jsp:param name="tab1Roles" value="SELLER" />
    <jsp:param name="tab2Key" value="pricing" />
    <jsp:param name="tab2Label" value="Pricing rules" />
    <jsp:param name="tab2Url" value="/ContainerAllocationPricingController?module=pricing" />
    <jsp:param name="tab2Roles" value="SELLER" />
</jsp:include>

<!-- PAGE HEADING -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">

                <div>
                    <small class="text-secondary fw-semibold">
                        ADMINISTRATION / CONTAINERS
                    </small>

                    <h3 class="fw-bold mt-2 mb-1">
                        Container Directory
                    </h3>

                    <p class="text-secondary mb-0">
                        Manage your shipping containers and their availability.
                    </p>
                </div>

                <button class="btn btn-warning bg-gradient fw-semibold px-4 mt-3 mt-md-0"
                       
                        data-bs-toggle="collapse"
                        data-bs-target="#addContainerForm">

                    
                    Add Container
                </button>

            </div>

            <!-- SUCCESS MESSAGE -->
            ${requestScope.nlv_Module3_containers__2}

            <!-- ERROR MESSAGE -->
            ${requestScope.nlv_Module3_containers__3}

            <!-- ADD CONTAINER FORM -->
            <div class="collapse mb-4" id="addContainerForm">

                <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

                    <div class="card-body p-4">

                        <h5 class="fw-bold mb-1">Add New Container</h5>

                        <p class="text-secondary small mb-4">
                            Enter the container details below.
                        </p>

                        <form action="${requestScope.nlv_Module3_containers__4}/ContainerAllocationPricingController"
                              method="post">

                            <input type="hidden" name="module" value="container">
                            <input type="hidden" name="action" value="insert">
                            <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module3_containers__5}">

                            <div class="row g-3">

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Container Number
                                    </label>

                                    <input type="text"
                                           name="containerNumber"
                                           class="form-control"
                                           maxlength="15"
                                           placeholder="Enter container number"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Container Type
                                    </label>

                                    <select name="containerType"
                                            class="form-select" required>

                                        <option value="">Select Type</option>
                                        <option value="DRY">DRY</option>
                                        <option value="REEFER">REEFER</option>
                                        <option value="OPEN_TOP">OPEN TOP</option>
                                        <option value="TANK">TANK</option>

                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Container Size
                                    </label>

                                    <select name="sizeFt"
                                            class="form-select" required>

                                        <option value="">Select Size</option>
                                        <option value="20">20 FT</option>
                                        <option value="40">40 FT</option>

                                    </select>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Maximum Weight (KG)
                                    </label>

                                    <input type="number"
                                           name="maxWeightKg"
                                           class="form-control"
                                           min="0.01"
                                           step="0.01"
                                           placeholder="Maximum weight"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Maximum Volume (CBM)
                                    </label>

                                    <input type="number"
                                           name="maxVolumeCbm"
                                           class="form-control"
                                           min="0.01"
                                           step="0.01"
                                           placeholder="Maximum volume"
                                           required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">
                                        Current Port ID
                                    </label>

                                    <select name="currentPortId" class="form-select" required><option value="">Choose port</option><jsp:setProperty name="nlViewSupport_Module3_containers" property="fragment" value="nlv_Module3_containers__6" /><jsp:getProperty name="nlViewSupport_Module3_containers" property="fragment" /></select>
                                </div>

                            </div>

                            <div class="d-flex gap-2 mt-4">

                                <button type="submit"
                                        class="btn btn-warning bg-gradient fw-semibold px-4"
                                       >

                                    
                                    Save Container
                                </button>

                                <button type="reset"
                                        class="btn btn-light border px-4">
                                    Reset
                                </button>

                            </div>

                        </form>

                    </div>
                </div>
            </div>

            <form action="${requestScope.nlv_Module3_containers__7}/ContainerAllocationPricingController" method="get" class="card p-3 mb-3 border-warning-subtle shadow-sm"><input type="hidden" name="module" value="container"><div class="row g-2 align-items-end"><div class="col-md-6"><label class="form-label">Search containers</label><input class="form-control" name="q" placeholder="Container number or ID" value="${requestScope.nlv_Module3_containers__8}"></div><div class="col-md-3"><label class="form-label">Status</label><select class="form-select" name="status"><option value="">All statuses</option><jsp:setProperty name="nlViewSupport_Module3_containers" property="fragment" value="nlv_Module3_containers__9" /><jsp:getProperty name="nlViewSupport_Module3_containers" property="fragment" /></select></div><div class="col-md-3"><button class="btn btn-warning w-100">Search database</button></div></div></form>
            <section class="card p-3 mb-4 shadow-sm border-warning-subtle"><h5 class="fw-bold">Container maintenance</h5><p class="small text-muted">Only available containers can enter maintenance. Removal is blocked for containers linked to any shipment.</p><div class="row g-3"></div></section>

            <!-- SPECIFIC FIELD UPDATE -->
            <div class="card shadow-sm p-3 mb-4 border-0 rounded-4 border-warning-subtle nl-editor-card" id="nlContainerEditor">

                <div class="card-body p-4">

                    <h5 class="fw-bold mb-1">
                        Update container details
                    </h5>

                    <p class="text-secondary small mb-4">
                        Choose a container and update one approved field at a time. The current value and accepted format are shown below.
                    </p>

                    <form action="${requestScope.nlv_Module3_containers__10}/ContainerAllocationPricingController"
                          method="post">

                        <input type="hidden" name="module" value="container">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="csrfToken" value="${requestScope.nlv_Module3_containers__11}">

                        <div class="row g-3">

                            <div class="col-md-4 nl-editor-field">

                                <label class="form-label fw-semibold">
                                    Select container
                                </label>

                                <select name="containerId" id="nlUpdateContainer" class="form-select" required>
  <option value="">Choose existing container...</option>
  <jsp:setProperty name="nlViewSupport_Module3_containers" property="fragment" value="nlv_Module3_containers__12" /><jsp:getProperty name="nlViewSupport_Module3_containers" property="fragment" />
 </select><div class="form-text">Select by container number; the ID is submitted automatically.</div>

                            </div>

                            <div class="col-md-4 nl-editor-field">

                                <label class="form-label fw-semibold">
                                    Field to update
                                </label>

                                <select name="fieldName"
                                        id="fieldName"
                                        class="form-select"
                                        required>

                                    <option value="">Select Field</option>
                                    <option value="container_number">Container Number</option>
                                    <option value="container_type">Container Type</option>
                                    <option value="size_ft">Container Size</option>
                                    <option value="max_weight_kg">Maximum Weight (KG)</option>
                                    <option value="max_volume_cbm">Maximum Volume (CBM)</option>
                                    <option value="current_port_id">Current Port</option>

                                </select>

                            </div>

                            <div class="col-md-4 nl-editor-field">

                                <label class="form-label fw-semibold">
                                    New value
                                </label>

                                <input type="text"
                                       name="newValue"
                                       id="newValue"
                                       class="form-control"
                                       placeholder="Enter new value"
                                       required>
                                <select id="nlUpdatePortValue" class="form-select" aria-label="Choose new container port" disabled="disabled" hidden="hidden">
                                    <option value="">Choose an existing port</option>
                                    <jsp:setProperty name="nlViewSupport_Module3_containers" property="fragment" value="nlv_Module3_containers__13" /><jsp:getProperty name="nlViewSupport_Module3_containers" property="fragment" />
                                </select>

                            </div>

                        </div>

                        <datalist id="nlContainerTypeOptions"><option value="DRY"></option><option value="REEFER"></option><option value="OPEN_TOP"></option><option value="TANK"></option></datalist><datalist id="nlContainerSizeOptions"><option value="20"></option><option value="40"></option></datalist>
<div class="nl-editor-assist" id="nlEditorGuide" aria-live="polite"><div><small>Current value</small><strong id="nlEditorCurrent">Select a container and field</strong></div><div><small>Accepted input</small><strong id="nlEditorHint">Choose a field above to see the expected format.</strong></div></div>
                        <div class="mt-4">

                            <button type="submit"
                                    class="btn btn-warning bg-gradient fw-semibold px-4"
                                   >

                                
                                Update Container
                            </button>

                        </div>

                    </form>

                </div>
            </div>


            <!-- CONTAINER DIRECTORY TABLE -->
            <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">

                <div class="card-body p-3 p-lg-4">

                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">

                        <div>
                            <h5 class="fw-bold mb-1">
                                All Containers
                            </h5>

                            <p class="text-secondary small mb-0">
                                View and manage your container inventory.
                            </p>
                        </div>

                        <div class="mt-3 mt-md-0">
                            <span class="badge bg-warning-subtle text-dark px-3 py-2">
                                
                                ${requestScope.nlv_Module3_containers__14}
                                Containers
                            </span>
                        </div>

                    </div>

                    <div class="table-responsive rounded-3">

                        <table class="table table-hover align-middle table-striped">

                            <thead class="table-warning">

                                <tr>
                                    <th>Container</th>
                                    <th>Type</th>
                                    <th>Size</th>
                                    <th>Max Weight</th>
                                    <th>Max Volume</th>
                                    <th>Current Port</th>
                                    <th>Status</th>
                                    <th class="text-end">Manage</th>
                                </tr>

                            </thead>

                            <tbody>

                                <jsp:setProperty name="nlViewSupport_Module3_containers" property="fragment" value="nlv_Module3_containers__15" /><jsp:getProperty name="nlViewSupport_Module3_containers" property="fragment" />

                            </tbody>

                        </table>

                    </div>

                </div>
            </div>

            <!-- FOOTER -->
            <footer class="text-center text-secondary small mt-5 mb-3">
                N-LOGISTIC | Logistics Management System
            </footer>



</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>

<script>
(function(){
 const id=document.getElementById('nlUpdateContainer'),field=document.getElementById('fieldName');
 const text=document.getElementById('newValue'),port=document.getElementById('nlUpdatePortValue');
 if(!id||!field||!text||!port)return;
 const sync=function(){
   const usePort=field.value==='current_port_id';
   port.disabled=!usePort;port.hidden=!usePort;
   if(usePort){port.name='newValue';port.required=true;text.disabled=true;text.required=false;text.removeAttribute('name');text.hidden=true;}
   else{text.name='newValue';text.required=true;text.disabled=false;text.hidden=false;port.removeAttribute('name');port.required=false;}
 };
 field.addEventListener('change',sync);sync();
 const values={container_number:['Container number','Up to 15 characters'],container_type:['Container type','Choose DRY, REEFER, OPEN_TOP or TANK'],size_ft:['Container size','20 or 40 feet'],max_weight_kg:['Maximum weight','Positive kilograms (up to 2 decimal places)'],max_volume_cbm:['Maximum volume','Positive CBM (up to 2 decimal places)'],current_port_id:['Current port','Choose a port from the dropdown']};
 const guide=document.getElementById('nlEditorGuide'),present=document.getElementById('nlEditorCurrent'),hint=document.getElementById('nlEditorHint');
 const names={container_number:'containerNumber',container_type:'containerType',size_ft:'sizeFt',max_weight_kg:'maxWeight',max_volume_cbm:'maxVolume',current_port_id:'portId'};
 const selectRow=()=>document.querySelector('tr[data-container-id="'+id.value+'"]');
 function describe(){
   const row=selectRow(),chosen=field.value;
   hint.textContent=values[chosen]?values[chosen][1]:'Choose a field above to see the expected format.';
   const key=names[chosen];present.textContent=row&&key?row.dataset[key]||'Not recorded':'Select a container and field';
   if(chosen==='container_type'){text.setAttribute('list','nlContainerTypeOptions');text.placeholder='DRY / REEFER / OPEN_TOP / TANK';}
   else if(chosen==='size_ft'){text.setAttribute('list','nlContainerSizeOptions');text.placeholder='20 or 40';}
   else{ text.removeAttribute('list');text.placeholder=chosen==='container_number'?'New container number':chosen==='max_weight_kg'?'e.g. 24000.00':chosen==='max_volume_cbm'?'e.g. 33.00':'Enter new value'; }
   text.removeAttribute('pattern');if(chosen==='size_ft')text.pattern='20|40';
   if(chosen==='container_type')text.pattern='DRY|REEFER|OPEN_TOP|TANK';
   text.maxLength=chosen==='container_number'?15:chosen==='container_type'?8:255;
 }
 id.addEventListener('change',describe);field.addEventListener('change',()=>{sync();describe();});describe();

 document.querySelectorAll('.nl-container-edit').forEach(function(button){
   button.addEventListener('click',function(){
      id.value=button.dataset.containerId;id.dispatchEvent(new Event('change',{bubbles:true}));
      const editor=document.getElementById('nlContainerEditor');
      if(editor)editor.scrollIntoView({behavior:window.matchMedia('(prefers-reduced-motion: reduce)').matches?'auto':'smooth',block:'center'});
      field.focus({preventScroll:true});
   });
 });
})();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
