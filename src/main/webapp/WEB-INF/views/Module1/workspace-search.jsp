<jsp:useBean id="nlViewSupport_Module1_workspace_search" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_workspace_search" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_workspace_search" property="view" value="Module1/workspace-search.jsp" />
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map,java.util.LinkedHashMap,java.util.ArrayList,model.WorkspaceSearchHit" %>

<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Search | N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %></head>
<body data-nl-screen="module1-workspace-search" data-nl-enhanced="true" data-theme="n-logistic-orange" class="nl-themed-page bg-body-tertiary text-dark"><%@ include file="../shared/_shell_start.jsp" %>
<div class="container-fluid px-0"><div class="row g-0"><div id="nlSidebarCol" class="col-12 col-lg-2 d-none d-lg-block bg-warning-subtle border-end border-warning-subtle shadow-sm"><jsp:include page="/WEB-INF/views/shared/sidebar.jsp" /></div><div id="nlMainColumn" class="col-12 col-lg-10 min-vh-100 bg-body-tertiary p-3 p-lg-4 p-xl-5"><div class="small fw-semibold text-uppercase text-warning-emphasis mb-3">Search / WORKSPACE</div><div class="nl-view-body container-fluid p-0 px-0">
<div class="nl-page-hero"><div class="nl-eyebrow">WORKSPACE / UNIVERSAL SEARCH</div><div class="nl-page-hero-row"><div><h1>Search across N Logistic</h1><p>Find available screens, shipments, containers, invoices and claims in one place. Results respect your account permissions.</p></div><div class="nl-page-hero-badge">Role-aware results</div></div></div>
<form class="card p-3 mb-4 border-0 shadow-sm rounded-4 border-warning-subtle" action="${requestScope.nlv_Module1_workspace_search__1}/Module1Controller" method="get"><input type="hidden" name="action" value="workspaceSearch">
<div class="input-group"><label for="searchQuery" class="visually-hidden">Search records</label><input id="searchQuery" class="form-control" name="q" required maxlength="64" value="${requestScope.nlv_Module1_workspace_search__2}" placeholder="Shipment, invoice, claim, container or SKU"><button class="btn btn-warning bg-gradient">Search</button></div></form>
<section class="card p-4 border-0 shadow-sm rounded-4 border-warning-subtle"><div class="nl-search-result-heading"><div><div class="nl-eyebrow">SEARCH RESULTS</div><h2 class="h5 mb-2">${requestScope.nlv_Module1_workspace_search__3} matches for &quot;${requestScope.nlv_Module1_workspace_search__4}&quot;</h2><p class="text-secondary mb-3">Select a screen or authorized record. The destination still enforces its own access checks.</p></div><span class="nl-event-count">${requestScope.nlv_Module1_workspace_search__5} result categories</span></div>
${requestScope.nlv_Module1_workspace_search__6}</section>
</div><%@ include file="../shared/_shell_end.jsp" %></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>
