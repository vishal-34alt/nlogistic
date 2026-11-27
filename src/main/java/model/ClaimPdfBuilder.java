package model;

import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.*;

/** Standalone printable A4 claim statement; no HTML screenshot or new dependency. */
public final class ClaimPdfBuilder {
    private ClaimPdfBuilder(){}
    private static final double W=595.28,H=841.89,L=44,R=551;
    private static final String INK="0.18 0.12 0.09",ORANGE="0.80 0.27 0.04",
        GRAY="0.45 0.37 0.32",WHITE="1 1 1",PAPER="0.99 0.97 0.94",LINE="0.89 0.81 0.73";
    private static final class Page {
        StringBuilder content=new StringBuilder(4096);
        double cursor=715;
        void box(double x,double y,double w,double h,String color){content.append("q ").append(color).append(" rg ").append(n(x)).append(' ').append(n(y)).append(' ').append(n(w)).append(' ').append(n(h)).append(" re f Q\n");}
        void rule(double x,double y,double x2,double y2){content.append("q ").append(LINE).append(" RG .5 w ").append(n(x)).append(' ').append(n(y)).append(" m ").append(n(x2)).append(' ').append(n(y2)).append(" l S Q\n");}
        void text(double x,double y,int size,boolean bold,String color,String raw){content.append("BT ").append(color).append(" rg /F").append(bold?2:1).append(' ').append(size).append(" Tf 1 0 0 1 ").append(n(x)).append(' ').append(n(y)).append(" Tm (").append(safe(raw)).append(") Tj ET\n");}
        void right(double x,double y,int size,boolean bold,String color,String value){String v=ascii(value);text(Math.max(L,x-v.length()*size*.53),y,size,bold,color,v);}
    }
    private static String n(double x){return String.format(Locale.ROOT,"%.2f",x);}
    private static String ascii(String s){if(s==null||s.trim().isEmpty())return "-";return Normalizer.normalize(s,Normalizer.Form.NFKD).replaceAll("\\p{M}","").replaceAll("[^\\x20-\\x7e]"," ").replaceAll("\\s+"," ").trim();}
    private static String safe(String s){return ascii(s).replace("\\","\\\\").replace("(","\\(").replace(")","\\)");}
    private static String cash(BigDecimal n){return n==null?"Pending":String.format(Locale.ROOT,"INR %,.2f",n);}
    private static List<String> wrap(String input,int len){String src=ascii(input);List<String> out=new ArrayList<>();while(src.length()>len){int cut=src.lastIndexOf(' ',len);if(cut<len/3)cut=len;out.add(src.substring(0,cut).trim());src=src.substring(cut).trim();}out.add(src);return out;}
    private static void begin(Page p,Claim c){
        p.box(0,H-109,W,109,INK);p.box(0,H-113,W,4,ORANGE);
        p.text(L,786,23,true,WHITE,"N-LOGISTIC");
        p.text(L,766,8,false,"0.99 0.75 0.55","IMPORT & EXPORT MANAGEMENT SYSTEM");
        p.right(R,786,15,true,WHITE,"CARGO CLAIM STATEMENT");
        p.right(R,767,9,false,"0.99 0.75 0.55",c.getClaimNo());
        p.cursor=710;
    }
    private static void section(List<Page> pages,Claim c,String title){
        Page p=room(pages,c,67);p.box(L,p.cursor-9,R-L,23,PAPER);p.text(L+10,p.cursor,10,true,ORANGE,title);p.cursor-=28;
    }
    private static Page room(List<Page> pages,Claim claim,double needed){
        Page p=pages.get(pages.size()-1);
        if(p.cursor-needed<80){p=new Page();pages.add(p);begin(p,claim);}
        return p;
    }
    private static void pair(List<Page> pages,Claim c,String label,String value){
        Page p=room(pages,c,21);p.text(L+8,p.cursor,9,true,GRAY,label);p.text(L+164,p.cursor,9,false,INK,ascii(value).substring(0,Math.min(56,ascii(value).length())));
        p.rule(L,p.cursor-7,R,p.cursor-7);p.cursor-=21;
    }
    private static void paragraph(List<Page> pages,Claim claim,String text){
        for(String line:wrap(text,102)){Page p=room(pages,claim,16);p.text(L+8,p.cursor,9,false,INK,line);p.cursor-=14;}
        pages.get(pages.size()-1).cursor-=9;
    }
    private static byte[] assemble(List<Page> pages)throws IOException{
        List<String> objs=new ArrayList<>();objs.add("<< /Type /Catalog /Pages 2 0 R >>");
        StringBuilder kids=new StringBuilder();for(int i=0;i<pages.size();i++)kids.append(5+2*i).append(" 0 R ");
        objs.add("<< /Type /Pages /Kids ["+kids+"] /Count "+pages.size()+" >>");
        objs.add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>");
        objs.add("<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>");
        for(int i=0;i<pages.size();i++){
            Page p=pages.get(i);p.rule(L,51,R,51);
            p.text(L,34,8,false,GRAY,"N-LOGISTIC | Authorized claim record | Not a payment receipt");
            p.right(R,34,8,false,GRAY,"Page "+(i+1)+" / "+pages.size());
            objs.add("<< /Type /Page /Parent 2 0 R /MediaBox [0 0 "+n(W)+" "+n(H)+"] /Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> /Contents "+(6+2*i)+" 0 R >>");
            byte[] stream=p.content.toString().getBytes(StandardCharsets.US_ASCII);
            objs.add("<< /Length "+stream.length+" >>\nstream\n"+p.content+"endstream");
        }
        ByteArrayOutputStream out=new ByteArrayOutputStream();out.write("%PDF-1.4\n".getBytes(StandardCharsets.US_ASCII));List<Integer> offsets=new ArrayList<>();
        for(int i=0;i<objs.size();i++){offsets.add(out.size());out.write(((i+1)+" 0 obj\n"+objs.get(i)+"\nendobj\n").getBytes(StandardCharsets.US_ASCII));}
        int xref=out.size();StringBuilder tail=new StringBuilder("xref\n0 "+(objs.size()+1)+"\n0000000000 65535 f \n");
        for(Integer o:offsets)tail.append(String.format(Locale.ROOT,"%010d 00000 n \n",o));
        tail.append("trailer\n<< /Size ").append(objs.size()+1).append(" /Root 1 0 R >>\nstartxref\n").append(xref).append("\n%%EOF\n");
        out.write(tail.toString().getBytes(StandardCharsets.US_ASCII));return out.toByteArray();
    }
    public static byte[] build(ClaimPrintActions.Report report)throws IOException{
        if(report==null||report.claim==null)throw new IllegalArgumentException("Authorized claim report required.");
        Claim c=report.claim;Row r=report.context;
        List<Page> pages=new ArrayList<>();Page p=new Page();pages.add(p);begin(p,c);
        // A4 reference panel: no table rows stretched across the entire application.
        p.box(L,p.cursor-78,R-L,90,PAPER);
        p.text(L+14,p.cursor-18,10,true,ORANGE,"CLAIM REFERENCE");p.text(L+14,p.cursor-37,12,true,INK,c.getClaimNo());
        p.text(L+14,p.cursor-61,9,false,GRAY,"Shipment: "+c.getShipmentNo());
        p.text(L+276,p.cursor-19,10,true,ORANGE,"REVIEW STATUS");p.text(L+276,p.cursor-39,11,true,INK,c.getStatus().replace('_',' '));
        p.text(L+276,p.cursor-61,8,false,GRAY,"Filed: "+String.valueOf(c.getRaisedAt()));p.cursor-=96;
        section(pages,c,"PARTIES & SHIPMENT");
        pair(pages,c,"Seller / carrier",r.text("seller_name"));
        pair(pages,c,"Consumer company",r.text("consumer_company"));
        pair(pages,c,"Shipment",c.getShipmentNo());
        pair(pages,c,"Container",r.text("container_number"));
        pair(pages,c,"Route",r.text("origin_name")+" to "+r.text("destination_name"));
        section(pages,c,"CLAIM AND SETTLEMENT");
        pair(pages,c,"Reason",c.getClaimType().replace('_',' '));
        pair(pages,c,"Amount claimed",cash(c.getClaimedAmount()));
        pair(pages,c,"Approved amount",c.getApprovedAmount()==null||c.getApprovedAmount().signum()==0&&!("SETTLED".equals(c.getStatus())||"APPROVED".equals(c.getStatus()))?"Awaiting decision":cash(c.getApprovedAmount()));
        pair(pages,c,"Settled on",c.getSettledAt()==null?"Not settled":String.valueOf(c.getSettledAt()));
        section(pages,c,"DESCRIPTION OF INCIDENT");
        paragraph(pages,c,c.getDescription());
        section(pages,c,"SUPPORTING EVIDENCE ("+report.docs.size()+")");
        if(report.docs.isEmpty())paragraph(pages,c,"No evidence documents are attached to this claim.");
        for(ClaimDocument d:report.docs){
            Page part=room(pages,c,27);part.text(L+8,part.cursor,9,true,INK,d.getFileName());
            part.right(R-8,part.cursor,8,false,GRAY,d.getFileType()==null?"FILE":d.getFileType());
            part.cursor-=12;part.text(L+8,part.cursor,8,false,GRAY,"Uploaded: "+d.getUploadedAt()+" | On record (not independently verified)");part.cursor-=16;
        }
        section(pages,c,"SELLER ASSESSMENT / NOTES");
        paragraph(pages,c,c.getSellerRemarks()==null||c.getSellerRemarks().trim().isEmpty()?"No assessment remarks recorded yet.":c.getSellerRemarks());
        section(pages,c,"CLAIM STATUS HISTORY");
        if(report.timeline.isEmpty())paragraph(pages,c,"No status changes recorded yet.");
        for(ClaimStatusHistory h:report.timeline){
            Page part=room(pages,c,43);part.text(L+8,part.cursor,9,true,INK,h.getNewStatus().replace('_',' '));
            part.right(R-8,part.cursor,8,false,GRAY,String.valueOf(h.getChangedAt()));part.cursor-=15;
            for(String line:wrap(h.getRemarks(),100)){part=room(pages,c,14);part.text(L+8,part.cursor,8,false,GRAY,line);part.cursor-=13;}
            part.cursor-=6;
        }
        Page last=pages.get(pages.size()-1);
        last.text(L+8,73,8,false,GRAY,"Issued for recordkeeping. Settlement is effective only when authorized and recorded.");
        last.text(L+8,61,8,false,GRAY,"This document is not a commercial invoice and does not prove a payment.");
        return assemble(pages);
    }
}
