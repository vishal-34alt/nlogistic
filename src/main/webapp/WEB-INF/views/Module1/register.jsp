<jsp:useBean id="nlViewSupport_Module1_register" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_register" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_register" property="view" value="Module1/register.jsp" />
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Create account | N-LOGISTIC</title><link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"><%@ include file="../shared/_theme.jsp" %>
<style>
@keyframes nlDockFloat{0%,100%{transform:translateX(0) translateY(0)}50%{transform:translateX(24px) translateY(-8px)}}
@keyframes nlOceanRoll{from{background-position:0 0,0 0}to{background-position:180px 0,-220px 0}}
body.nl-auth-page{position:relative;isolation:isolate;overflow-x:hidden;background:linear-gradient(135deg,#ffebd7,#fff8ee 50%,#f8ddc2)!important}
body.nl-auth-page::before{content:'';position:fixed;z-index:-1;pointer-events:none;left:-8vw;top:9vh;width:42vw;height:48vh;border-radius:38% 62% 55% 45%;background:radial-gradient(ellipse at center,#dd8f4a30,#ad5b1520 45%,transparent 70%);animation:nlDockFloat 12s ease-in-out infinite}
body.nl-auth-page::after{content:'';position:fixed;z-index:-1;pointer-events:none;left:0;right:0;bottom:0;height:30vh;opacity:.5;background-image:repeating-radial-gradient(ellipse at 20% 160%,transparent 0 33px,#dd8a4b28 34px 36px,transparent 38px 65px),repeating-radial-gradient(ellipse at 75% 165%,transparent 0 38px,#b65f2d27 40px 42px,transparent 45px 73px);animation:nlOceanRoll 22s linear infinite}
.nl-auth-shell{position:relative;z-index:1}
@media(prefers-reduced-motion:reduce){body.nl-auth-page::before,body.nl-auth-page::after{animation:none!important}}

/* v20.17 - registration page visual parity for light and dark modes. */
body.nl-auth-page{min-height:100vh;background:radial-gradient(ellipse at 12% 18%,#ffd7ab52,transparent 38%),linear-gradient(145deg,#fff8f0 0%,#ffeedc 48%,#f5e4d2 100%)!important}
body.nl-auth-page::before{left:-6vw;top:8vh;width:38vw;height:44vh;background:radial-gradient(ellipse at center,#e89c5f2e,#a95a1b18 46%,transparent 71%)}
body.nl-auth-page::after{height:24vh;opacity:.62;background-image:repeating-linear-gradient(165deg,transparent 0 84px,#d79a6330 85px 86px,transparent 87px 141px),repeating-radial-gradient(ellipse at 18% 165%,transparent 0 36px,#cd7d4321 37px 39px,transparent 40px 72px),repeating-radial-gradient(ellipse at 80% 162%,transparent 0 42px,#c26d3420 43px 45px,transparent 46px 80px)}
.nl-auth-page .nl-auth-container{padding-top:1.4rem!important;padding-bottom:1.4rem!important}
.nl-auth-page .nl-auth-shell{max-width:1120px;margin-inline:auto;border-radius:30px!important;border:1px solid #e8cfbc!important;box-shadow:0 28px 70px rgba(104,51,20,.18)!important;background:transparent!important}
.nl-auth-page .nl-auth-hero{position:relative;overflow:hidden;background:linear-gradient(160deg,#3a241b 0%,#6b341f 56%,#b65425 100%)!important;padding:2.6rem 2.8rem!important}
.nl-auth-page .nl-auth-hero::before{content:"";position:absolute;inset:auto -14% -12% auto;width:76%;height:36%;border-radius:50%;border:1px solid rgba(255,205,155,.24);opacity:.78;pointer-events:none}
.nl-auth-page .nl-auth-hero::after{content:"";position:absolute;inset:auto -10% -10% 4%;height:34%;opacity:.38;border-radius:0;background:repeating-linear-gradient(165deg,transparent 0 56px,rgba(252,193,131,.14) 57px 58px,transparent 59px 108px),radial-gradient(circle at 75% 10%,rgba(255,186,113,.32),transparent 38%)}
.nl-auth-page .nl-auth-hero .badge{background:rgba(255,255,255,.06)!important;color:#ffe2b4!important;border-color:#f2af67!important}
.nl-auth-page .nl-auth-hero h2{font-size:clamp(3rem,4.9vw,5rem);line-height:1.02;max-width:390px;margin-bottom:1.35rem!important}
.nl-auth-page .nl-auth-hero h2 .text-warning{color:#ffbd6b!important}
.nl-auth-page .nl-auth-hero p{max-width:390px;font-size:1.02rem;color:#fff1e2!important}
.nl-auth-page .nl-auth-hero ul{gap:1.05rem!important;margin-top:2rem!important;margin-bottom:2.25rem!important}
.nl-auth-page .nl-auth-hero ul li{font-size:.98rem;color:#fff3e9;font-weight:650}
.nl-auth-page .nl-auth-hero p.mt-auto{font-size:1.1rem;letter-spacing:.22em;color:#ffd8ac!important}
.nl-auth-page .nl-auth-form{background:linear-gradient(180deg,#fffefd 0%,#fffaf4 100%)!important;padding:2.7rem 2.7rem 2.4rem!important}
.nl-auth-page .nl-auth-form .badge{background:#fff0df!important;color:#d8651e!important;border-color:#f0cfac!important}
.nl-auth-page .nl-auth-form h1{font-size:clamp(2.8rem,4.4vw,4.25rem)!important;line-height:1.03!important;letter-spacing:-.06em!important;color:#34231a!important;max-width:520px}
.nl-auth-page .nl-auth-form .text-warning-emphasis{color:#da641c!important}
.nl-auth-page .nl-auth-form .text-secondary{color:#7d6657!important}
.nl-auth-page .nl-auth-form .form-control,.nl-auth-page .nl-auth-form .form-select{min-height:54px;border-radius:12px!important;background:#fff!important;border-color:#e3c7ae!important;box-shadow:none!important}
.nl-auth-page .nl-auth-form .form-control:focus,.nl-auth-page .nl-auth-form .form-select:focus{border-color:#db7535!important;box-shadow:0 0 0 3px rgba(237,142,72,.18)!important}
.nl-auth-page .nl-auth-form button[type=submit]{min-height:58px;border-radius:12px!important;font-size:1rem!important;box-shadow:0 14px 28px rgba(183,73,20,.22)!important}
.nl-auth-page .nl-auth-form .border-top{margin-top:1.55rem!important;padding-top:1.25rem!important}
.nl-auth-page .nl-theme-switch{background:#fff7ee;border-color:#e4c3a5;color:#7a3b15}
.nl-auth-page .nl-theme-switch:hover{background:#ffead4;border-color:#d48b57}
html[data-nl-mode="dark"] body.nl-auth-page{background:radial-gradient(circle at 9% 16%,rgba(113,63,33,.22),transparent 27%),radial-gradient(circle at 92% 8%,rgba(51,88,131,.18),transparent 25%),linear-gradient(145deg,#101827 0%,#17263a 54%,#0f1b2a 100%)!important;color:#ecf3fb}
html[data-nl-mode="dark"] body.nl-auth-page::before{background:radial-gradient(ellipse at center,#6d3f1e33,#1b2a3a14 45%,transparent 70%)}
html[data-nl-mode="dark"] body.nl-auth-page::after{opacity:.48;background-image:repeating-linear-gradient(165deg,transparent 0 88px,rgba(79,111,145,.18) 89px 90px,transparent 91px 147px),repeating-radial-gradient(ellipse at 16% 164%,transparent 0 42px,rgba(77,113,149,.16) 43px 45px,transparent 46px 80px),repeating-radial-gradient(ellipse at 82% 160%,transparent 0 44px,rgba(236,128,54,.09) 45px 47px,transparent 48px 83px)}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-shell{border-color:#3a4d62!important;box-shadow:0 30px 80px rgba(1,8,17,.42)!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-hero{background:linear-gradient(160deg,#35231b 0%,#6a341d 54%,#b85729 100%)!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-hero .badge{background:rgba(255,255,255,.06)!important;color:#ffe2b6!important;border-color:#ffb46e!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-hero h2{color:#f7fbff!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-hero h2 .text-warning{color:#ffc46f!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form{background:linear-gradient(180deg,#1b2a3b 0%,#1b2d41 100%)!important;color:#ecf4fd!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form h1{color:#f5f9fd!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .text-warning-emphasis{color:#ff9d52!important;text-shadow:0 0 0 transparent}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .badge{background:#f4efe81a!important;color:#ffbb81!important;border-color:#7c5e47!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .form-label{color:#f4f7fb!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .text-secondary{color:#bfd0df!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .form-control,html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .form-select{background:#132132!important;border-color:#4e6178!important;color:#f4f8fc!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .form-control::placeholder,html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .form-select{color:#d7e1ea}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form .border-top{border-color:#3e5268!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-auth-form a{color:#ffb172!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-theme-switch{background:#1a2b3d!important;border-color:#556b83!important;color:#ffd1a8!important}
html[data-nl-mode="dark"] body.nl-auth-page .nl-theme-switch:hover{background:#22364b!important}
@media(max-width:991.98px){.nl-auth-page .nl-auth-shell{border-radius:24px!important}.nl-auth-page .nl-auth-hero,.nl-auth-page .nl-auth-form{padding:2rem!important}.nl-auth-page .nl-auth-hero h2{font-size:clamp(2.4rem,8vw,3.6rem);max-width:100%}.nl-auth-page .nl-auth-form h1{font-size:clamp(2.2rem,7vw,3.25rem)!important}}
@media(max-width:575.98px){body.nl-auth-page::after{height:18vh}.nl-auth-page .nl-auth-container{padding-top:.75rem!important;padding-bottom:.75rem!important}.nl-auth-page .nl-auth-hero,.nl-auth-page .nl-auth-form{padding:1.35rem!important}.nl-auth-page .nl-auth-hero h2{font-size:2.45rem}.nl-auth-page .nl-auth-form h1{font-size:2rem!important}}
</style>
</head>
<body data-nl-screen="module1-register" data-nl-enhanced="true" class="nl-auth-page"><button type="button" class="nl-theme-switch" data-nl-theme-toggle aria-pressed="false" style="position:fixed;right:18px;top:16px;z-index:1200"><span data-nl-theme-symbol aria-hidden="true">&#9790;</span><span data-nl-theme-label>Dark mode</span></button><main class="nl-auth-container container py-4 py-lg-5 min-vh-100 d-flex align-items-center"><div class="row justify-content-center w-100 mx-0"><div class="col-12 col-xl-11 col-xxl-10"><div class="row g-0 bg-white nl-auth-shell rounded-4 shadow-lg overflow-hidden border border-warning-subtle"><section class="nl-auth-hero col-12 col-lg-5 bg-dark bg-gradient text-white p-4 p-md-5 d-flex flex-column rounded-start-4">
  <span class="badge border border-warning text-warning rounded-pill align-self-start px-3 py-2 mb-5">N-LOGISTIC</span>
  <h2 class="display-5 fw-bold lh-sm mb-4">Your logistics.<span class="d-block text-warning">One platform.</span></h2>
  <p class="text-white-50 fs-6 mb-4">Manage cargo, shipments, billing and logistics operations in a secure, centralized workspace.</p>
  <ul class="list-unstyled d-grid gap-4 mt-3 mb-5">
    <li class="d-flex align-items-center gap-3"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGNUU1QzkiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik0zIDVoMTF2MTJIM3pNMTQgOWg0bDMgNHY0aC03eiIvPjxjaXJjbGUgY3g9IjciIGN5PSIxOCIgcj0iMiIvPjxjaXJjbGUgY3g9IjE4IiBjeT0iMTgiIHI9IjIiLz48L3N2Zz4=" width="23" height="23" alt="" aria-hidden="true"><span>End-to-end shipment tracking</span></li>
    <li class="d-flex align-items-center gap-3"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGNUU1QzkiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxyZWN0IHg9IjMiIHk9IjUiIHdpZHRoPSIxOCIgaGVpZ2h0PSIxNSIgcng9IjMiLz48cGF0aCBkPSJNMyAxMGgxOE03IDE1aDUiLz48L3N2Zz4=" width="23" height="23" alt="" aria-hidden="true"><span>Freight pricing and recorded payments</span></li>
    <li class="d-flex align-items-center gap-3"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGNUU1QzkiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Ik00IDIwVjEzaDR2N00xMCAyMFY0aDR2MTZNMTYgMjB2LTloNHY5TTMgMjFoMTgiLz48L3N2Zz4=" width="23" height="23" alt="" aria-hidden="true"><span>Real-data analytics and reports</span></li>
    <li class="d-flex align-items-center gap-3"><img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNGNUU1QzkiIHN0cm9rZS13aWR0aD0iMS43IiBzdHJva2UtbGluZWNhcD0icm91bmQiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjxwYXRoIGQ9Im0zIDcgOS00IDkgNHYxMGwtOSA0LTktNHpNMyA3bDkgNCA5LTRNMTIgMTF2MTAiLz48L3N2Zz4=" width="23" height="23" alt="" aria-hidden="true"><span>Inventory and container management</span></li>
  </ul>
  <p class="text-warning fw-bold mt-auto mb-0">N-LOGISTIC</p>
</section><div class="nl-auth-form col-12 col-lg-7 bg-white p-4 p-md-5">
<div class="badge bg-warning-subtle text-warning-emphasis rounded-pill px-3 py-2 mb-3">Welcome to N-LOGISTIC</div>
<h1 class="h2 fw-bold mb-2">Create your <span class="text-warning-emphasis">N-LOGISTIC</span> account</h1><p class="text-secondary mb-4">Get started with your logistics workspace.</p>
${requestScope.nlv_Module1_register__1}
<form action="${requestScope.nlv_Module1_register__2}/Module1Controller" method="post"><input type="hidden" name="csrfToken" value="${requestScope.nlv_Module1_register__3}"><input type="hidden" name="action" value="register">
<div class="row g-3">
<div class="col-12 col-md-6"><label class="form-label fw-semibold" for="register-name">Full name <span class="text-danger">*</span></label><input class="form-control form-control-lg bg-light" id="register-name" name="fullName" value="${requestScope.nlv_Module1_register__4}" maxlength="100" placeholder="Your name" required></div>
<div class="col-12 col-md-6"><label class="form-label fw-semibold" for="register-company">Company <span class="text-danger">*</span></label><input class="form-control form-control-lg bg-light" id="register-company" name="companyName" value="${requestScope.nlv_Module1_register__5}" maxlength="150" placeholder="Company name" required>${requestScope.nlv_Module1_register__6}</div>
<div class="col-12 col-md-6"><label class="form-label fw-semibold" for="register-email">Email <span class="text-danger">*</span></label><input class="form-control form-control-lg bg-light" id="register-email" name="email" value="${requestScope.nlv_Module1_register__7}" type="email" maxlength="120" placeholder="name@company.com" required>${requestScope.nlv_Module1_register__8}</div>
<div class="col-12 col-md-6"><label class="form-label fw-semibold" for="register-role">Role <span class="text-danger">*</span></label><select class="form-select form-select-lg bg-light" id="register-role" name="role" required><option value="">Select permitted role</option><option value="CONSUMER" ${requestScope.nlv_Module1_register__9}>Consumer</option><option value="SELLER" ${requestScope.nlv_Module1_register__10}>Seller</option></select></div>
<div class="col-12 col-md-6"><label class="form-label fw-semibold" for="register-password">Password <span class="text-danger">*</span></label><input class="form-control form-control-lg bg-light" id="register-password" name="password" type="password" maxlength="255" pattern=".{8,255}" title="Password must contain at least 8 characters" placeholder="At least 8 characters" autocomplete="new-password" required></div>
<div class="col-12 col-md-6"><label class="form-label fw-semibold" for="register-confirm">Confirm password <span class="text-danger">*</span></label><input class="form-control form-control-lg bg-light" id="register-confirm" name="confirmPassword" type="password" maxlength="255" pattern=".{8,255}" title="Confirm the password with at least 8 characters" placeholder="Repeat password" autocomplete="new-password" required>${requestScope.nlv_Module1_register__11}</div>
<div class="col-12"><label class="form-label fw-semibold" for="register-phone">Phone number <span class="text-danger">*</span></label><input class="form-control form-control-lg bg-light" id="register-phone" name="phone" value="${requestScope.nlv_Module1_register__12}" type="tel" maxlength="20" placeholder="10-digit contact number" required></div>
</div><button type="submit" class="btn btn-warning bg-gradient btn-lg w-100 fw-bold py-3 shadow-sm rounded-3 mt-4">Create account &rarr;</button></form>
<p class="small text-secondary mt-3">A new company is created for this account. Joining an existing company requires administrator approval.</p>
<div class="text-center border-top pt-4 mt-4 small text-secondary">Already have an account? <a class="link-warning-emphasis fw-bold" href="${requestScope.nlv_Module1_register__13}/Module1Controller?action=viewLogin">Sign in</a></div>
</div></div><p class="text-center text-secondary small mt-4 mb-0">N-LOGISTIC &middot; Secure logistics workspace</p></div></div></main><script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script></body></html>