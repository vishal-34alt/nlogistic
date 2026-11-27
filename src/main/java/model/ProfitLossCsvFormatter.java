package model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

/** Clean UTF-8 CSV with metadata, amounts, totals and injection-safe text. No presentation CSS exists in CSV. */
public final class ProfitLossCsvFormatter {
    private ProfitLossCsvFormatter(){}
    private static final String CRLF="\r\n";
    private static String cell(Object value){
        String s=value==null?"":String.valueOf(value).replace('\r',' ').replace('\n',' ');
        String trimmed=s.stripLeading();
        if(!trimmed.isEmpty() && "=+-@".indexOf(trimmed.charAt(0))>=0 && !trimmed.matches("-?[0-9]+(\\.[0-9]+)?"))s="'"+s;
        return '"'+s.replace("\"","\"\"")+'"';
    }
    private static String money(BigDecimal b){
        return (b==null?BigDecimal.ZERO:b).setScale(2,RoundingMode.HALF_UP).toPlainString();
    }
    private static void line(StringBuilder out,String...values){
        for(int i=0;i<values.length;i++){
            if(i>0)out.append(',');
            out.append(cell(values[i]));
        }
        out.append(CRLF);
    }
    public static String format(List<ProfitLossPojo> entries,boolean monthly,Integer seller,LocalDate from,LocalDate to){
        StringBuilder b=new StringBuilder(1024+entries.size()*160);
        line(b,"N-LOGISTIC · MODULE 02 · FINANCIAL REPORT");
        line(b,"Report",monthly?"Monthly profit and loss":"Shipment-wise profit and loss");
        line(b,"Currency","INR");
        line(b,"From",from==null?"All available dates":from.toString());
        line(b,"To",to==null?"All available dates":to.toString());
        line(b,"Seller scope",seller==null?"All authorized sellers":"Seller company #"+seller);
        line(b,"Exported at",OffsetDateTime.now(ZoneId.of("Asia/Kolkata")).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss xxx")));
        line(b,"Records",String.valueOf(entries.size()));
        b.append(CRLF);
        if(monthly){line(b,"MONTH","REVENUE (INR)","OPERATING COST (INR)","CLAIM LOSS (INR)","NET PROFIT (INR)");}
        else{line(b,"MONTH","SHIPMENT ID","SHIPMENT NO","SELLER ID","REVENUE (INR)","FREIGHT COST (INR)","PORT COST (INR)","HANDLING COST (INR)","CLAIM LOSS (INR)","NET PROFIT (INR)");}
        BigDecimal rev=BigDecimal.ZERO,oper=BigDecimal.ZERO,freight=BigDecimal.ZERO,port=BigDecimal.ZERO,handling=BigDecimal.ZERO,claim=BigDecimal.ZERO,profit=BigDecimal.ZERO;
        for(ProfitLossPojo p:entries){
            if(monthly){line(b,p.getMonthLabel(),money(p.getRevenue()),money(p.getOperatingCost()),money(p.getClaimLoss()),money(p.getNetProfit()));}
            else{line(b,p.getMonthLabel(),String.valueOf(p.getShipmentId()),p.getShipmentNo(),String.valueOf(p.getSellerId()),money(p.getRevenue()),money(p.getFreightCost()),money(p.getPortCost()),money(p.getHandlingCost()),money(p.getClaimLoss()),money(p.getNetProfit()));}
            rev=rev.add(p.getRevenue());oper=oper.add(p.getOperatingCost());freight=freight.add(p.getFreightCost());port=port.add(p.getPortCost());handling=handling.add(p.getHandlingCost());claim=claim.add(p.getClaimLoss());profit=profit.add(p.getNetProfit());
        }
        if(monthly)line(b,"TOTAL",money(rev),money(oper),money(claim),money(profit));
        else line(b,"TOTAL","","","",money(rev),money(freight),money(port),money(handling),money(claim),money(profit));
        b.append(CRLF);
        line(b,"Notes","Values reflect the stored procedure results for the selected date range and authorized seller scope.");
        line(b,"Explanation","Revenue minus freight, port, handling and claim losses equals net profit.");
        line(b,"Tip","CSV supports clean headers and numeric columns; use Excel or Sheets to apply fonts and colors.");
        return b.toString();
    }
}
