<jsp:useBean id="nlViewSupport_Module3_pricing_audit" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module3_pricing_audit" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module3_pricing_audit" property="view" value="Module3/pricing-audit.jsp" />

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>



<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>
</head><body data-nl-screen="module3-pricing-audit" data-nl-enhanced="true" data-theme="n-logistic-orange" class="bg-light nl-themed-page bg-body-tertiary text-dark">

<%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3" aria-label="Breadcrumb">${requestScope.nlv_Module3_pricing_audit__1} / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">

<jsp:include page="/WEB-INF/views/shared/header.jsp">
    <jsp:param name="pageTitle" value="Pricing Audit History" />
    <jsp:param name="pageSubtitle" value="Track changes made to your pricing rules." />
    <jsp:param name="activeModule" value="inventory" />
    <jsp:param name="navInventoryUrl" value="/ContainerAllocationPricingController?module=container" />
</jsp:include>

<jsp:include page="/WEB-INF/views/shared/tabs.jsp">
    <jsp:param name="module" value="inventory" />
    <jsp:param name="activeTab" value="pricing" />
    <jsp:param name="tab1Key" value="directory" />
    <jsp:param name="tab1Label" value="Container directory" />
    <jsp:param name="tab1Url" value="/ContainerAllocationPricingController?module=container" />
    <jsp:param name="tab1Roles" value="SELLER" />
    <jsp:param name="tab2Key" value="pricing" />
    <jsp:param name="tab2Label" value="Back to pricing rules" />
    <jsp:param name="tab2Url" value="/ContainerAllocationPricingController?module=pricing" />
    <jsp:param name="tab2Roles" value="SELLER" />
</jsp:include>


            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 class="fw-bold text-dark mb-1">Pricing Audit History</h4>
                    <p class="text-secondary mb-0">
                        Track changes made to your pricing rules.
                    </p>
                </div>

                <a href="ContainerAllocationPricingController?module=pricing"
                   class="btn btn-outline-secondary">
                     Back to Pricing
                </a>
            </div>

            <div class="card shadow-sm p-3 mb-3 border-0 rounded-4 border-warning-subtle">
                <div class="card-body p-4">

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Change Records</h5>
                        <span class="badge bg-warning-subtle text-dark">
                            ${requestScope.nlv_Module3_pricing_audit__2} Records
                        </span>
                    </div>

                    <div class="table-responsive rounded-3">
                        <table class="table table-hover align-middle table-striped">

                            <thead class="table-warning">
                                <tr>
                                    <th>Audit ID</th>
                                    <th>Rule ID</th>
                                    <th>Old Rate</th>
                                    <th>New Rate</th>
                                    <th>Old Multiplier</th>
                                    <th>New Multiplier</th>
                                    <th>Changed By</th>
                                    <th>Date &amp; Time</th>
                                </tr>
                            </thead>

                            <tbody>

                            <jsp:setProperty name="nlViewSupport_Module3_pricing_audit" property="fragment" value="nlv_Module3_pricing_audit__3" /><jsp:getProperty name="nlViewSupport_Module3_pricing_audit" property="fragment" />

                            </tbody>
                        </table>
                    </div>

                </div>
            </div>



</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
