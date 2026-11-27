package model;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Business-ready A4 PDF generated from authorized invoice data.
 * No PDF library, database change, filesystem storage or Java web dependency required.
 * Normal-sized invoices render on one page. Long item descriptions/charge lists paginate.
 */
public final class InvoicePdfBuilder {
    private InvoicePdfBuilder() {}
    private static final double W = 595.28, H = 841.89;
    private static final double LEFT = 46, RIGHT = 549;
    private static final String DARK = "0.22 0.14 0.11", ORANGE = "0.76 0.30 0.08";
    private static final String MUTED = "0.48 0.42 0.37", WHITE = "1 1 1";

    private static final class Page {
        final StringBuilder commands = new StringBuilder(4096);
        void rect(double x,double y,double w,double h,String color) {
            commands.append("q ").append(color).append(" rg ").append(n(x)).append(' ').append(n(y))
                .append(' ').append(n(w)).append(' ').append(n(h)).append(" re f Q\n");
        }
        void line(double x,double y,double xx,double yy,String color) {
            commands.append("q ").append(color).append(" RG .65 w ").append(n(x)).append(' ')
                .append(n(y)).append(" m ").append(n(xx)).append(' ').append(n(yy)).append(" l S Q\n");
        }
        void txt(double x,double y,int size,boolean bold,String color,String value) {
            commands.append("BT ").append(color).append(" rg /F").append(bold?2:1)
                .append(' ').append(size).append(" Tf 1 0 0 1 ").append(n(x)).append(' ')
                .append(n(y)).append(" Tm (").append(pdfText(value)).append(") Tj ET\n");
        }
        void right(double right,double y,int size,boolean bold,String color,String value) {
            String v=clean(value);
            // Helvetica is proportional. Estimate is intentionally conservative.
            txt(Math.max(320,right-v.length()*size*(bold?.55:.51)),y,size,bold,color,v);
        }
    }
    private static String n(double d){return String.format(Locale.ROOT,"%.2f",d);}
    private static String clean(String input) {
        if(input==null)return "-";
        String ascii=Normalizer.normalize(input,Normalizer.Form.NFKD)
            .replaceAll("\\p{M}","")
            .replaceAll("[^\\x20-\\x7e]","?")
            .replaceAll("[\\t\\r\\n]+"," ").trim();
        return ascii.isEmpty()?"-":ascii;
    }
    private static String pdfText(String input){return clean(input).replace("\\","\\\\").replace("(","\\(").replace(")","\\)");}
    private static List<String> wrap(String raw,int max){
        String s=clean(raw);List<String> lines=new ArrayList<>();
        while(s.length()>max){
            int at=s.lastIndexOf(' ',max);if(at<max/2)at=max;
            lines.add(s.substring(0,at).trim());s=s.substring(at).trim();
        }
        lines.add(s);return lines;
    }
    private static void top(Page page,Row invoice,boolean first) {
        page.rect(0,H-118,W,118,DARK);
        page.rect(0,H-122,W,4,ORANGE);
        page.txt(LEFT,778,26,true,WHITE,"N-LOGISTIC");
        page.txt(LEFT,757,9,false,"0.98 0.78 0.62","IMPORT & EXPORT MANAGEMENT SYSTEM");
        page.right(RIGHT,782,19,true,WHITE,"COMMERCIAL INVOICE");
        page.right(RIGHT,760,10,false,"0.98 0.78 0.62",invoice.text("invoice_no"));
        if(first) {
            page.txt(LEFT,699,10,true,ORANGE,"INVOICE DETAILS");
            page.txt(LEFT,679,10,true,DARK,"Invoice no.");page.txt(118,679,10,false,DARK,invoice.text("invoice_no"));
            page.txt(315,679,10,true,DARK,"Shipment");page.txt(387,679,10,false,DARK,invoice.text("shipment_no"));
            page.txt(LEFT,658,9,true,MUTED,"Issue date");page.txt(118,658,9,false,DARK,invoice.text("issue_date"));
            page.txt(315,658,9,true,MUTED,"Due date");page.txt(387,658,9,false,DARK,invoice.text("due_date"));
            page.rect(LEFT,576,244,59,"0.981 0.966 0.950");page.rect(303,576,246,59,"0.981 0.966 0.950");
            page.txt(LEFT+13,615,9,true,ORANGE,"FROM / SELLER");
            page.txt(LEFT+13,595,11,true,DARK,clean(invoice.text("seller_name")).substring(0,Math.min(42,clean(invoice.text("seller_name")).length())));
            page.txt(316,615,9,true,ORANGE,"BILL TO / CONSUMER");
            page.txt(316,595,11,true,DARK,clean(invoice.text("consumer_name")).substring(0,Math.min(40,clean(invoice.text("consumer_name")).length())));
        }else{
            page.txt(LEFT,686,10,true,DARK,"CHARGE DETAILS (CONTINUED)");
            page.txt(LEFT,663,9,false,MUTED,"Shipment " + clean(invoice.text("shipment_no")));
        }
    }
    private static void heading(Page p,double y){
        p.rect(LEFT,y-10,RIGHT-LEFT,28,"0.95 0.89 0.83");
        p.txt(LEFT+10,y,9,true,DARK,"CHARGE TYPE");
        p.txt(169,y,9,true,DARK,"DESCRIPTION");
        p.txt(399,y,9,true,DARK,"QTY");
        p.right(RIGHT-10,y,9,true,DARK,"AMOUNT (INR)");
    }
    private static void item(Page p,Row row,double top,List<String> description,int height,boolean shade){
        if(shade)p.rect(LEFT,top-height+3,RIGHT-LEFT,height,"0.989 0.980 0.969");
        p.txt(LEFT+10,top-12,9,true,DARK,row.text("item_type"));
        for(int i=0;i<description.size();i++)p.txt(169,top-12-(i*11),9,false,DARK,description.get(i));
        p.txt(400,top-12,9,false,MUTED,row.text("quantity"));
        p.right(RIGHT-10,top-12,10,true,DARK,row.text("amount"));
        p.line(LEFT,top-height+3,RIGHT,top-height+3,"0.88 0.83 0.77");
    }
    private static void total(Page p,Row invoice,double y,
                              List<Row> payments,boolean delivery) {
        p.rect(LEFT,y-148,RIGHT-LEFT,154,"0.981 0.966 0.950");
        p.txt(LEFT+15,y-18,10,true,DARK,"INVOICE SUMMARY");
        String[][] rows={{"Subtotal",invoice.text("sub_total")},{"Tax / GST",invoice.text("tax_amount")},
            {"Invoice total",invoice.text("total_amount")},{"Payments recorded",invoice.text("paid_amount")}};
        int line=0;
        for(String[] r:rows){
            p.txt(LEFT+15,y-39-line*22,9,false,MUTED,r[0]);
            p.right(RIGHT-15,y-39-line*22,10,line==2,DARK,"INR "+r[1]);line++;
        }
        p.rect(LEFT+9,y-145,RIGHT-LEFT-18,26,DARK);
        boolean cancelled="CANCELLED".equals(invoice.text("shipment_status"));
        p.txt(LEFT+18,y-137,10,true,WHITE,cancelled?"ARCHIVED (NOT PAYABLE)":"BALANCE DUE");
        p.right(RIGHT-20,y-137,12,true,WHITE,"INR "+invoice.text("balance"));
        p.txt(LEFT,y-176,9,true,ORANGE,cancelled?"CANCELLED BOOKING - INVOICE ARCHIVED":
            "PAYMENT STATUS: "+invoice.text("status"));
        if(payments!=null && !payments.isEmpty()) {
            Row latest=payments.get(0);
            String details="Recorded payments: "+payments.size()+" | Latest: "
                +latest.text("payment_date")+" ("+latest.text("payment_mode")+")";
            p.txt(LEFT,y-194,8,false,MUTED,details);
        } else p.txt(LEFT,y-194,8,false,MUTED,"No payment has yet been recorded for this invoice.");
        p.txt(LEFT,y-207,8,false,MUTED,cancelled?
                "Historical invoice only. No payment is due for the cancelled booking.":delivery?
                "Pay on delivery requested; original invoice due date remains unchanged.":
                "Payments are recorded here; no online transfer is initiated by N-LOGISTIC.");
    }
    private static byte[] assemble(List<Page> pages,Row invoice)throws IOException {
        int count=pages.size();List<String> objects=new ArrayList<>();
        objects.add("<< /Type /Catalog /Pages 2 0 R >>");
        StringBuilder kids=new StringBuilder();for(int i=0;i<count;i++)kids.append(5+2*i).append(" 0 R ");
        objects.add("<< /Type /Pages /Count "+count+" /Kids ["+kids+"] >>");
        objects.add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>");
        objects.add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>");
        for(int i=0;i<count;i++){
            Page p=pages.get(i);
            p.line(LEFT,53,RIGHT,53,"0.88 0.82 0.76");
            p.txt(LEFT,37,8,false,MUTED,"N-LOGISTIC  |  Authorized billing record");
            p.right(RIGHT,37,8,false,MUTED,"Page "+(i+1)+" of "+count);
            objects.add("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 "+n(W)+" "+n(H)+"] "
                +"/Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /Contents "+(6+2*i)+" 0 R >>");
            byte[] bytes=p.commands.toString().getBytes(StandardCharsets.US_ASCII);
            objects.add("<< /Length "+bytes.length+" >>\nstream\n"+p.commands+"endstream");
        }
        ByteArrayOutputStream output=new ByteArrayOutputStream();output.write("%PDF-1.4\n".getBytes(StandardCharsets.US_ASCII));
        List<Integer> offset=new ArrayList<>();
        for(int i=0;i<objects.size();i++){offset.add(output.size());output.write(((i+1)+" 0 obj\n"+objects.get(i)+"\nendobj\n").getBytes(StandardCharsets.US_ASCII));}
        int xref=output.size();StringBuilder trailer=new StringBuilder("xref\n0 "+(objects.size()+1)+"\n0000000000 65535 f \n");
        for(Integer position:offset)trailer.append(String.format(Locale.ROOT,"%010d 00000 n \n",position));
        trailer.append("trailer\n<< /Size ").append(objects.size()+1).append(" /Root 1 0 R >>\nstartxref\n").append(xref).append("\n%%EOF\n");
        output.write(trailer.toString().getBytes(StandardCharsets.US_ASCII));return output.toByteArray();
    }
    public static byte[] build(Row invoice,List<Row> items)throws IOException {
        return build(invoice,items,new ArrayList<Row>(),false);
    }
    public static byte[] build(Row invoice,List<Row> items,List<Row> payments,boolean delivery)throws IOException {
        if(invoice==null)throw new IllegalArgumentException("Invoice is required");
        List<Page> pages=new ArrayList<>();Page page=new Page();pages.add(page);top(page,invoice,true);
        double y=545;heading(page,y);y-=23;int n=0;
        for(Row item:items){
            if(item.get("item_id")==null)continue;
            List<String> descriptions=wrap(item.text("description"),47);
            int height=Math.max(31,17+descriptions.size()*11);
            if(y-height<235){page=new Page();pages.add(page);top(page,invoice,false);y=626;heading(page,y);y-=23;}
            item(page,item,y,descriptions,height,(n++%2)==0);y-=height;
        }
        if(n==0){page.txt(LEFT+10,y-17,10,false,MUTED,"No itemized charges available");y-=38;}
        if(y<282){page=new Page();pages.add(page);top(page,invoice,false);y=629;}
        total(page,invoice,y-8,payments,delivery);
        return assemble(pages,invoice);
    }
}
