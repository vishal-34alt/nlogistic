<jsp:useBean id="nlViewSupport_Module5_print" class="model.JspSupport" scope="request" />
<jsp:setProperty name="nlViewSupport_Module5_print" property="pageContext" value="${pageContext}" />
<jsp:setProperty name="nlViewSupport_Module5_print" property="view" value="Module5/print.jsp" />
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*,model.Row" %>

<!doctype html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Commercial Invoice ${requestScope.nlv_Module5_print__1} | N-LOGISTIC</title>
<style>
*{box-sizing:border-box}body{background:#ede9e4;color:#38291f;font-family:Arial,Helvetica,sans-serif;margin:0}
.sheet{width:210mm;min-height:297mm;margin:30px auto;background:#fff;box-shadow:0 16px 50px #34221c24;position:relative;padding:0 18mm 19mm}
.header{background:#40291e;color:#fff;margin:0 -18mm;padding:24mm 18mm 18mm;display:flex;align-items:flex-start;justify-content:space-between;gap:30px;border-bottom:5px solid #da6822}
.brand{font-size:26px;font-weight:900;letter-spacing:2px}.brand-sub{font-size:9px;color:#efc5a8;letter-spacing:2px;margin-top:9px}.invoice-heading{text-align:right}.invoice-heading h1{margin:0 0 8px;font-size:18px;letter-spacing:2px}.invoice-heading small{display:block;color:#e7b896;line-height:1.8}
.meta{display:grid;grid-template-columns:1fr 1fr;gap:12px 24px;margin:28px 0}.meta .key{font-size:10px;text-transform:uppercase;color:#957763;letter-spacing:1px;margin-bottom:4px}.meta .value{font-size:12px;font-weight:700}
.parties{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:31px}.party{border-radius:10px;padding:17px;background:#fcf6ef;border:1px solid #eddfd0}.party h2{font-size:10px;text-transform:uppercase;letter-spacing:1.4px;color:#a25422;margin:0 0 10px}.party div{font-size:13px;font-weight:700;overflow-wrap:anywhere}
.h2{margin:0 0 13px;font-size:15px}.charges{width:100%;border-collapse:collapse;font-size:11px}.charges th{text-align:left;background:#f1e4d7;color:#4d2c1f;padding:11px 8px;text-transform:uppercase;letter-spacing:.5px;font-size:9px}.charges td{padding:11px 8px;border-bottom:1px solid #e9e1da;vertical-align:top}.charges .number{text-align:right;white-space:nowrap}.charges .desc{overflow-wrap:anywhere}.charges tbody tr:nth-child(even){background:#fcf9f5}
.totals{margin:22px 0 0 auto;max-width:325px;border-radius:11px;padding:15px;background:#fcf8f3;border:1px solid #efddcc}.totalrow{display:flex;justify-content:space-between;gap:15px;font-size:11px;padding:7px 0;color:#654a3a}.totalrow strong{color:#2e211c}.totalrow.strong{font-size:13px;border-top:1px solid #e2ceb9;margin-top:4px;font-weight:800}.balance{background:#40291e;color:#fff;border-radius:7px;padding:12px;margin-top:9px;display:flex;justify-content:space-between;font-size:14px;font-weight:800}.status{margin-top:12px;text-transform:uppercase;font-weight:800;font-size:10px;color:#b5511b}
.note{margin-top:24px;padding-top:16px;border-top:1px solid #e7ddd4;color:#7c6a5e;font-size:10px;line-height:1.65}.toolbar{margin:22px auto;max-width:210mm;display:flex;align-items:center;gap:12px;justify-content:flex-end}.toolbar a,.toolbar button{padding:12px 18px;text-decoration:none;border:1px solid #bd6431;border-radius:8px;font-size:13px;font-weight:800;cursor:pointer}.toolbar button{background:#c75b18;color:#fff}.toolbar a{background:#fff;color:#733f23}
@page{size:A4;margin:0}
@media print{html,body{width:210mm;background:#fff}.toolbar{display:none}.sheet{width:210mm;min-height:297mm;margin:0;box-shadow:none;padding:0 18mm 15mm}.header{padding-top:17mm}.parties,.meta,.totals{break-inside:avoid}.charges tr{break-inside:avoid}.charges thead{display:table-header-group}.note{break-inside:avoid}}
@media(max-width:850px){.sheet{width:100%;min-height:0;margin:0;padding:0 18px 30px}.header{margin:0 -18px;padding:28px 18px}.meta,.parties{grid-template-columns:1fr}.toolbar{padding:0 12px}.charges{font-size:10px}}
</style></head><body>
<div class="toolbar"><a href="${requestScope.nlv_Module5_print__2}?action=details&amp;invoice=${requestScope.nlv_Module5_print__3}">Back to invoice</a><button type="button" onclick="window.print()">Print / Save as PDF</button></div>
<main class="sheet" aria-label="Printable commercial invoice">
${requestScope.nlv_Module5_print__4}
<header class="header"><div><div class="brand">N-LOGISTIC</div><div class="brand-sub">IMPORT &amp; EXPORT MANAGEMENT SYSTEM</div></div><div class="invoice-heading"><h1>COMMERCIAL INVOICE</h1><small>Invoice ${requestScope.nlv_Module5_print__5}</small><small>${requestScope.nlv_Module5_print__6}</small></div></header>
<section class="meta" aria-label="Invoice references"><div><div class="key">Invoice reference</div><div class="value">${requestScope.nlv_Module5_print__7}</div></div><div><div class="key">Shipment reference</div><div class="value">${requestScope.nlv_Module5_print__8}</div></div><div><div class="key">Issue date</div><div class="value">${requestScope.nlv_Module5_print__9}</div></div><div><div class="key">Payment due date</div><div class="value">${requestScope.nlv_Module5_print__10}</div></div></section>
<section class="parties" aria-label="Invoice parties"><div class="party"><h2>From · Seller</h2><div>${requestScope.nlv_Module5_print__11}</div></div><div class="party"><h2>Bill to · Consumer</h2><div>${requestScope.nlv_Module5_print__12}</div></div></section>
<section aria-label="Invoice charges"><h2 class="h2">Shipment charges</h2><table class="charges"><thead><tr><th>Charge</th><th>Description</th><th class="number">Qty</th><th class="number">Rate (INR)</th><th class="number">Amount (INR)</th></tr></thead><tbody>
<jsp:setProperty name="nlViewSupport_Module5_print" property="fragment" value="nlv_Module5_print__13" /><jsp:getProperty name="nlViewSupport_Module5_print" property="fragment" />
</tbody></table></section>
<section class="totals" aria-label="Invoice totals"><div class="totalrow"><span>Subtotal</span><strong>INR ${requestScope.nlv_Module5_print__14}</strong></div><div class="totalrow"><span>Applicable tax</span><strong>INR ${requestScope.nlv_Module5_print__15}</strong></div><div class="totalrow strong"><span>Invoice total</span><strong>INR ${requestScope.nlv_Module5_print__16}</strong></div><div class="totalrow"><span>Recorded payment(s)</span><strong>INR ${requestScope.nlv_Module5_print__17}</strong></div><div class="balance"><span>${requestScope.nlv_Module5_print__18}</span><span>INR ${requestScope.nlv_Module5_print__19}</span></div><div class="status">${requestScope.nlv_Module5_print__20}${requestScope.nlv_Module5_print__21}</div></section>
<section class="note" aria-label="Payment details"><strong>Payment information</strong><br>
${requestScope.nlv_Module5_print__22}
${requestScope.nlv_Module5_print__23}
</section>
<footer class="note">This invoice was generated from the N-LOGISTIC booking and billing records. It shows recorded payments only. N-LOGISTIC does not transfer funds or operate an online payment gateway. For payment arrangements, refer to the invoice due date and the terms agreed with the Seller. Longer charge lists may continue onto additional pages.</footer>
</main></body></html>
