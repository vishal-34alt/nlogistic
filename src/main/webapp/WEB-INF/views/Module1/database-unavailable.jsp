<jsp:useBean id="nlViewSupport_Module1_database_unavailable" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module1_database_unavailable" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module1_database_unavailable" property="view" value="Module1/database-unavailable.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Service temporarily unavailable | N-LOGISTIC</title>
<style>
:root{color-scheme:light}*{box-sizing:border-box}body{margin:0;min-height:100vh;display:grid;place-items:center;background:radial-gradient(circle at 90% 10%,#ffdbb8,transparent 36%),#f8f2ec;color:#34271f;font:16px/1.6 system-ui,'Segoe UI',sans-serif;padding:22px}
main{max-width:560px;width:100%;background:#fffcf9;border:1px solid #eccdb6;border-radius:22px;padding:clamp(24px,5vw,43px);box-shadow:0 18px 45px #57392120}
.brand{font-size:.79rem;font-weight:900;letter-spacing:.13em;color:#a64713}.flag{display:inline-block;margin:24px 0 12px;padding:6px 11px;background:#fff0df;border:1px solid #f3caa0;color:#9c4b19;border-radius:999px;font-size:.76rem;font-weight:800}
h1{font-size:clamp(1.6rem,5vw,2.25rem);line-height:1.15;margin:0 0 15px}p{color:#755e4e;margin:9px 0 17px}a{display:inline-block;border-radius:11px;background:#c84b08;color:white;font-weight:800;text-decoration:none;padding:11px 19px}a:focus-visible{outline:3px solid #c84b08;outline-offset:3px}.hint{border-top:1px solid #efdfd0;margin-top:25px;padding-top:15px;font-size:.84rem}
</style></head><body><main role="main">
<div class="brand">N-LOGISTIC / SERVICE STATUS</div><span class="flag">Temporary database interruption</span>
<h1>We couldn't reach the database</h1>
<p>Your request was not completed. The MySQL server may have stopped or become unavailable. This is not a wrong-password message.</p>
<p>If you were signed in, your session has not been intentionally signed out. Once MySQL is running, open the page again.</p>
<a href="${requestScope.nlv_Module1_database_unavailable__1}/Module1Controller?action=viewLogin">Open sign-in</a>
<p class="hint">Administrator: check the MySQL service and the application database connection settings. No database reset is required.</p>
</main></body></html>
