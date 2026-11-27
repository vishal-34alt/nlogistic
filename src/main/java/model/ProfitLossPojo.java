package model;

import implementor.ProfitLossImplementor;
import operations.ProfitLossOperations;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

/** Profit/loss data, report permissions and calculations; SQL stays in implementors. */
public class ProfitLossPojo {
    private static final ProfitLossOperations DATA=new ProfitLossImplementor();
    private Integer plId, shipmentId;
    private int sellerId;
    private String shipmentNo;
    private LocalDate periodMonth;
    private BigDecimal revenue=BigDecimal.ZERO,freightCost=BigDecimal.ZERO,
        portCost=BigDecimal.ZERO,handlingCost=BigDecimal.ZERO,
        claimLoss=BigDecimal.ZERO,netProfit=BigDecimal.ZERO,operatingCost;

    private Integer effectiveSeller(User actor,Integer requested) {
        if(actor==null)throw new SecurityException("Authentication required");
        actor.requireStaff();
        if(actor.isAdmin())return requested;
        if(actor.getCompanyId()==null)throw new SecurityException("Seller company is missing");
        if(requested!=null&&!requested.equals(actor.getCompanyId()))
            throw new SecurityException("Cannot view another seller's P&L");
        return actor.getCompanyId();
    }
    public List<ProfitLossPojo> shipments(User user,Integer seller,
          LocalDate start,LocalDate end) throws SQLException {
        checkDateRange(start,end);
        return DATA.shipmentReport(effectiveSeller(user,seller),start,end);
    }
    public List<ProfitLossPojo> monthly(User user,Integer seller,
          LocalDate start,LocalDate end) throws SQLException {
        checkDateRange(start,end);
        return DATA.monthlyReport(effectiveSeller(user,seller),start,end);
    }
    public ProfitLossPojo calculate(User user,ShipmentPojo shipment,LocalDate month)
           throws SQLException {
        requireOwns(user,shipment);
        return DATA.calculate(shipment.getShipmentId(),normalizeMonth(month));
    }
    public void refresh(User user,ShipmentPojo shipment,LocalDate month,
           BigDecimal freight,BigDecimal port,BigDecimal handling) throws SQLException {
        requireOwns(user,shipment);
        validateMoney(freight,"Freight cost");
        validateMoney(port,"Port cost");
        validateMoney(handling,"Handling cost");
        DATA.refresh(shipment.getShipmentId(),normalizeMonth(month),freight,port,handling);
    }
    private static void requireOwns(User user,ShipmentPojo shipment) {
        user.requireStaff();
        if(shipment==null)throw new IllegalArgumentException("Shipment not found");
        if(!user.canUpdateShipment(shipment.getSellerId()))throw new SecurityException("Not your shipment");
    }
    public static LocalDate normalizeMonth(LocalDate date) {
        if(date==null)throw new IllegalArgumentException("Reporting month is required");
        return date.withDayOfMonth(1);
    }
    private static void checkDateRange(LocalDate start,LocalDate end) {
        if(start!=null&&end!=null&&start.isAfter(end))throw new IllegalArgumentException("Invalid reporting date range");
    }
    private static void validateMoney(BigDecimal value,String label) {
        if(value==null||value.signum()<0||value.scale()>2||value.compareTo(new BigDecimal("999999999999.99"))>0)
            throw new IllegalArgumentException(label+" must be a nonnegative amount with at most two decimals");
    }
    public BigDecimal getOperatingCost() {
        return operatingCost!=null?operatingCost:freightCost.add(portCost).add(handlingCost);
    }
    public BigDecimal getTotalCost(){return getOperatingCost().add(claimLoss);}
    public String getMonthLabel(){return periodMonth==null?"":periodMonth.toString().substring(0,7);}
    private static String csvCell(Object value) {
        String s=value==null?"":String.valueOf(value);
        // Protect Excel users from imported formula injection.
        if(!(value instanceof Number)&&!s.isEmpty()&&"=+-@".indexOf(s.charAt(0))>=0)s="'"+s;
        return "\""+s.replace("\"","\"\"")+"\"";
    }
    public String asCsv(List<ProfitLossPojo> rows,boolean monthly) {
        StringBuilder b=new StringBuilder();
        if(monthly)b.append("Month,Revenue,Operating Cost,Claim Loss,Net Profit\r\n");
        else b.append("Month,Shipment ID,Shipment No,Seller ID,Revenue,Freight,Port,Handling,Claim Loss,Net Profit\r\n");
        for(ProfitLossPojo p:rows) {
            b.append(csvCell(p.getMonthLabel())).append(',');
            if(!monthly)b.append(csvCell(p.shipmentId)).append(',').append(csvCell(p.shipmentNo)).append(',')
                .append(csvCell(p.sellerId)).append(',');
            b.append(csvCell(p.revenue)).append(',');
            if(monthly)b.append(csvCell(p.getOperatingCost())).append(',');
            else b.append(csvCell(p.freightCost)).append(',').append(csvCell(p.portCost)).append(',')
                .append(csvCell(p.handlingCost)).append(',');
            b.append(csvCell(p.claimLoss)).append(',').append(csvCell(p.netProfit)).append("\r\n");
        }
        return b.toString();
    }
    public Integer getPlId(){return plId;} public void setPlId(Integer v){plId=v;}
    public Integer getShipmentId(){return shipmentId;} public void setShipmentId(Integer v){shipmentId=v;}
    public String getShipmentNo(){return shipmentNo;} public void setShipmentNo(String v){shipmentNo=v;}
    public int getSellerId(){return sellerId;} public void setSellerId(int v){sellerId=v;}
    public LocalDate getPeriodMonth(){return periodMonth;} public void setPeriodMonth(LocalDate v){periodMonth=v;}
    public BigDecimal getRevenue(){return revenue;} public void setRevenue(BigDecimal v){revenue=zero(v);}
    public BigDecimal getFreightCost(){return freightCost;} public void setFreightCost(BigDecimal v){freightCost=zero(v);}
    public BigDecimal getPortCost(){return portCost;} public void setPortCost(BigDecimal v){portCost=zero(v);}
    public BigDecimal getHandlingCost(){return handlingCost;} public void setHandlingCost(BigDecimal v){handlingCost=zero(v);}
    public BigDecimal getClaimLoss(){return claimLoss;} public void setClaimLoss(BigDecimal v){claimLoss=zero(v);}
    public BigDecimal getNetProfit(){return netProfit;} public void setNetProfit(BigDecimal v){netProfit=zero(v);}
    public void setOperatingCost(BigDecimal v){operatingCost=zero(v);}
    private static BigDecimal zero(BigDecimal x){return x==null?BigDecimal.ZERO:x;}
}
