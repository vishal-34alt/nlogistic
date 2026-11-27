package implementor;

import db_config.GetConnection;
import model.ProfitLossPojo;
import operations.ProfitLossOperations;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ProfitLossImplementor implements ProfitLossOperations {
    private static void setNullableDate(CallableStatement stmt,int i,LocalDate value) throws SQLException {
        if(value==null)stmt.setNull(i,Types.DATE);else stmt.setDate(i,Date.valueOf(value));
    }
    private static void setupReport(CallableStatement cs,Integer seller,LocalDate start,LocalDate end) throws SQLException {
        if(seller==null)cs.setNull(1,Types.INTEGER);else cs.setInt(1,seller);
        setNullableDate(cs,2,start);setNullableDate(cs,3,end);
    }
    private static LocalDate date(ResultSet rs,String name) throws SQLException {
        Date d=rs.getDate(name);return d==null?null:d.toLocalDate();
    }
    private static ProfitLossPojo base(ResultSet rs) throws SQLException {
        ProfitLossPojo p=new ProfitLossPojo();
        p.setPeriodMonth(date(rs,"period_month"));p.setRevenue(rs.getBigDecimal("revenue"));
        p.setClaimLoss(rs.getBigDecimal("claim_loss"));p.setNetProfit(rs.getBigDecimal("net_profit"));
        return p;
    }
    @Override public List<ProfitLossPojo> shipmentReport(Integer seller,LocalDate start,LocalDate end) throws SQLException {
        List<ProfitLossPojo> rows=new ArrayList<>();
        try(Connection c=GetConnection.getConnection();
            CallableStatement cs=c.prepareCall("{CALL sp_get_profit_loss(?,?,?)}")) {
            setupReport(cs,seller,start,end);
            try(ResultSet rs=cs.executeQuery()) {
                while(rs.next()) {
                    ProfitLossPojo p=base(rs);
                    int sid=rs.getInt("shipment_id");p.setShipmentId(rs.wasNull()?null:sid);
                    p.setPlId(rs.getInt("pl_id"));p.setShipmentNo(rs.getString("shipment_no"));
                    p.setSellerId(rs.getInt("seller_id"));
                    p.setFreightCost(rs.getBigDecimal("freight_cost"));
                    p.setPortCost(rs.getBigDecimal("port_cost"));
                    p.setHandlingCost(rs.getBigDecimal("handling_cost"));
                    rows.add(p);
                }
            }
        }
        return rows;
    }
    @Override public List<ProfitLossPojo> monthlyReport(Integer seller,LocalDate start,LocalDate end) throws SQLException {
        List<ProfitLossPojo> rows=new ArrayList<>();
        try(Connection c=GetConnection.getConnection();
            CallableStatement cs=c.prepareCall("{CALL sp_get_profit_loss_monthly(?,?,?)}")) {
            setupReport(cs,seller,start,end);
            try(ResultSet rs=cs.executeQuery()) {
                while(rs.next()) {
                    ProfitLossPojo p=base(rs);
                    p.setOperatingCost(rs.getBigDecimal("cost"));
                    rows.add(p);
                }
            }
        }
        return rows;
    }
    @Override public ProfitLossPojo calculate(int shipmentId,LocalDate month) throws SQLException {
        try(Connection c=GetConnection.getConnection();
            CallableStatement cs=c.prepareCall("{CALL sp_calculate_profit_loss(?,?)}")) {
            cs.setInt(1,shipmentId);cs.setDate(2,Date.valueOf(month));
            try(ResultSet rs=cs.executeQuery()) {
                if(rs.next()) {
                    ProfitLossPojo p=base(rs);p.setShipmentId(rs.getInt("shipment_id"));
                    p.setSellerId(rs.getInt("seller_id"));
                    p.setFreightCost(rs.getBigDecimal("freight_cost"));
                    p.setPortCost(rs.getBigDecimal("port_cost"));
                    p.setHandlingCost(rs.getBigDecimal("handling_cost"));
                    return p;
                }
            }
        }
        throw new SQLException("P&L calculation produced no result");
    }
    @Override public void refresh(int shipmentId,LocalDate month,BigDecimal freight,
                                  BigDecimal port,BigDecimal handling) throws SQLException {
        try(Connection c=GetConnection.getConnection();
            CallableStatement cs=c.prepareCall("{CALL sp_refresh_profit_loss(?,?,?,?,?)}")) {
            cs.setInt(1,shipmentId);cs.setDate(2,Date.valueOf(month));
            cs.setBigDecimal(3,freight);cs.setBigDecimal(4,port);cs.setBigDecimal(5,handling);
            cs.execute();
        }
    }
}
