package implementor;

import db_config.GetConnection;
import model.User;
import model.PortPojo;
import model.ShipmentPojo;
import operations.ShipmentOperations;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/** All shipment SQL and stored procedure access stays in implementor. */
public class ShipmentImplementor implements ShipmentOperations {
    @Override public User findActiveUser(int userId) throws SQLException {
        String sql = "SELECT user_id,role,company_id,full_name FROM users WHERE user_id=? AND status='ACTIVE'";
        try (Connection conn = GetConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1,userId);
            try(ResultSet rs=ps.executeQuery()) {
                if(!rs.next())return null;
                int company=rs.getInt("company_id");
                Integer companyId=rs.wasNull()?null:company;
                return new User(rs.getInt("user_id"), rs.getString("role"), companyId,rs.getString("full_name"));
            }
        }
    }
    @Override public List<ShipmentPojo> search(int userId,String container,Integer id,Integer port,String status) throws SQLException {
        List<ShipmentPojo> results=new ArrayList<>();
        try(Connection conn=GetConnection.getConnection();
            CallableStatement cs=conn.prepareCall("{CALL sp_search_shipments(?,?,?,?,?)}")) {
            cs.setInt(1,userId);
            if(container==null)cs.setNull(2,Types.VARCHAR); else cs.setString(2,container);
            if(id==null)cs.setNull(3,Types.INTEGER); else cs.setInt(3,id);
            if(port==null)cs.setNull(4,Types.INTEGER); else cs.setInt(4,port);
            if(status==null)cs.setNull(5,Types.VARCHAR); else cs.setString(5,status);
            try(ResultSet rs=cs.executeQuery()) {
                while(rs.next()) {
                    ShipmentPojo s=new ShipmentPojo();
                    s.setShipmentId(rs.getInt("shipment_id"));
                    s.setShipmentNo(rs.getString("shipment_no"));
                    s.setContainerNumber(rs.getString("container_number"));
                    s.setConsumerId(rs.getInt("consumer_id"));
                    s.setSellerId(rs.getInt("seller_id"));
                    s.setOriginPortName(rs.getString("origin_port"));
                    s.setDestPortName(rs.getString("dest_port"));
                    s.setStatus(rs.getString("status"));
                    s.setEtd(date(rs,"etd"));
                    s.setEta(date(rs,"eta"));
                    s.setActualArrival(date(rs,"actual_arrival"));
                    s.setQuotedPrice(rs.getBigDecimal("quoted_price"));
                    results.add(s);
                }
            }
        }
        loadLatestDelayNotices(results);
        return results;
    }
    // Fetch the most recent reported delay for each authorized shipment in batches.
    // Keeping this in Implementor avoids one database round trip per shipment card.
    private void loadLatestDelayNotices(List<ShipmentPojo> shipments) throws SQLException {
        if(shipments.isEmpty())return;
        java.util.Map<Integer,ShipmentPojo> byId=new java.util.HashMap<>();
        for(ShipmentPojo shipment:shipments)byId.put(shipment.getShipmentId(),shipment);
        java.util.List<Integer> ids=new java.util.ArrayList<>(byId.keySet());
        try(Connection conn=GetConnection.getConnection()) {
            for(int start=0;start<ids.size();start+=200) {
                java.util.List<Integer> batch=ids.subList(start,Math.min(start+200,ids.size()));
                StringBuilder query=new StringBuilder("SELECT record_id, "
                    +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.previous_eta')) AS previous_eta, "
                    +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.revised_eta')) AS revised_eta, "
                    +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.reason')) AS reason, "
                    +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.reported_at')) AS reported_at "
                    +"FROM audit_log WHERE table_name='shipment' AND action='SHIPMENT_DELAY_REPORTED' "
                    +"AND record_id IN (");
                for(int i=0;i<batch.size();i++)query.append(i==0?"?":",?");
                query.append(") ORDER BY log_id DESC");
                try(PreparedStatement ps=conn.prepareStatement(query.toString())) {
                    for(int i=0;i<batch.size();i++)ps.setInt(i+1,batch.get(i));
                    try(ResultSet rs=ps.executeQuery()) {
                        java.util.Set<Integer> seen=new java.util.HashSet<>();
                        while(rs.next()) {
                            int recordId=rs.getInt("record_id");
                            if(!seen.add(recordId))continue;
                            ShipmentPojo shipment=byId.get(recordId);
                            if(shipment==null)continue;
                            String previous=rs.getString("previous_eta");
                            String revised=rs.getString("revised_eta");
                            if(previous==null||revised==null)continue;
                            try {
                                shipment.addDelayNotice(java.time.LocalDate.parse(previous),
                                    java.time.LocalDate.parse(revised),rs.getString("reason"),
                                    rs.getString("reported_at"));
                            } catch(java.time.format.DateTimeParseException invalidHistoricalNotice) {
                                // Ignore malformed legacy audit data without hiding all shipments.
                            }
                        }
                    }
                }
            }
        }
    }
    @Override public void enrichDetails(ShipmentPojo s) throws SQLException {
        // Called only AFTER an ownership-filtered sp_search_shipments returns the record.
        // All joined fields derive from approved tables; no schema changes or JSP SQL.
        String detailsSql = "SELECT sh.container_id, sh.vessel_id, sh.origin_port_id, sh.dest_port_id, "
            + "sh.cargo_description, sh.cargo_weight_kg, sh.cargo_volume_cbm, "
            + "seller.company_name AS seller_name, consumer_user.full_name AS consumer_name, "
            + "v.vessel_name, c.container_type, inv.invoice_no, inv.status AS invoice_status, "
            + "inv.total_amount AS invoice_total, inv.paid_amount AS invoice_paid "
            + "FROM shipment sh "
            + "LEFT JOIN companies seller ON seller.company_id=sh.seller_id "
            + "LEFT JOIN customers consumer ON consumer.customer_id=sh.consumer_id "
            + "LEFT JOIN users consumer_user ON consumer_user.user_id=consumer.user_id "
            + "LEFT JOIN vessels v ON v.vessel_id=sh.vessel_id "
            + "LEFT JOIN containers c ON c.container_id=sh.container_id "
            + "LEFT JOIN billing_invoices inv ON inv.shipment_id=sh.shipment_id "
            + "WHERE sh.shipment_id=?";
        String cargoSql = "SELECT p.sku,p.product_name,si.quantity,si.unit_price,si.amount,si.weight_kg,si.volume_cbm "
            + "FROM shipment_items si JOIN products p ON p.product_id=si.product_id "
            + "WHERE si.shipment_id=? ORDER BY si.item_id";
        String eventSql = "SELECT status,location_text,remarks,event_time "
            + "FROM container_movements WHERE shipment_id=? ORDER BY movement_id DESC LIMIT 1";
        String firstSql = "SELECT MIN(event_time) AS booked_at FROM container_movements "
            + "WHERE shipment_id=? AND status='BOOKED'";
        try(Connection conn=GetConnection.getConnection()) {
            try(PreparedStatement ps=conn.prepareStatement(detailsSql)) {
                ps.setInt(1,s.getShipmentId());
                try(ResultSet rs=ps.executeQuery()) {
                    if(rs.next()) {
                        s.setContainerId(nullableInt(rs,"container_id"));
                        s.setVesselId(nullableInt(rs,"vessel_id"));
                        s.setOriginPortId(nullableInt(rs,"origin_port_id"));
                        s.setDestPortId(nullableInt(rs,"dest_port_id"));
                        s.setCargoDescription(rs.getString("cargo_description"));
                        s.setCargoWeightKg(rs.getBigDecimal("cargo_weight_kg"));
                        s.setCargoVolumeCbm(rs.getBigDecimal("cargo_volume_cbm"));
                        s.setConsumerName(rs.getString("consumer_name"));
                        s.setSellerCompanyName(rs.getString("seller_name"));
                        s.setVesselName(rs.getString("vessel_name"));
                        s.setContainerType(rs.getString("container_type"));
                        s.setInvoiceNo(rs.getString("invoice_no"));
                        s.setInvoiceStatus(rs.getString("invoice_status"));
                        s.setInvoiceTotal(rs.getBigDecimal("invoice_total"));
                        s.setInvoicePaid(rs.getBigDecimal("invoice_paid"));
                    }
                }
            }
            try(PreparedStatement ps=conn.prepareStatement(cargoSql)) {
                ps.setInt(1,s.getShipmentId());
                try(ResultSet rs=ps.executeQuery()) {
                    while(rs.next())s.addCargoLine(new ShipmentPojo.CargoLine(
                        rs.getString("sku"),rs.getString("product_name"),rs.getInt("quantity"),
                        rs.getBigDecimal("unit_price"),rs.getBigDecimal("amount"),
                        rs.getBigDecimal("weight_kg"),rs.getBigDecimal("volume_cbm")));
                }
            }
            try(PreparedStatement ps=conn.prepareStatement(eventSql)) {
                ps.setInt(1,s.getShipmentId());
                try(ResultSet rs=ps.executeQuery()) {
                    if(rs.next()) {
                        s.setLatestEventStatus(rs.getString("status"));
                        s.setLatestEventLocation(rs.getString("location_text"));
                        s.setLatestEventRemarks(rs.getString("remarks"));
                        java.sql.Timestamp tm=rs.getTimestamp("event_time");
                        s.setLatestEventTime(tm==null?null:tm.toString());
                    }
                }
            }
            try(PreparedStatement ps=conn.prepareStatement(firstSql)) {
                ps.setInt(1,s.getShipmentId());
                try(ResultSet rs=ps.executeQuery()) {
                    if(rs.next()) {
                        java.sql.Timestamp tm=rs.getTimestamp("booked_at");
                        s.setBookedAt(tm==null?null:tm.toString());
                    }
                }
            }

            s.clearDelayNotices();
            String noticeSql="SELECT log_id, "
                +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.previous_eta')) AS previous_eta, "
                +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.revised_eta')) AS revised_eta, "
                +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.reason')) AS reason, "
                +"JSON_UNQUOTE(JSON_EXTRACT(new_value, '$.reported_at')) AS reported_at "
                +"FROM audit_log WHERE table_name='shipment' AND action='SHIPMENT_DELAY_REPORTED' "
                +"AND record_id=? ORDER BY log_id DESC LIMIT 20";
            try(PreparedStatement ps=conn.prepareStatement(noticeSql)) {
                ps.setInt(1,s.getShipmentId());
                try(ResultSet rs=ps.executeQuery()) {
                    while(rs.next()) {
                        String old=rs.getString("previous_eta"), revised=rs.getString("revised_eta");
                        if(old==null||revised==null)continue;
                        s.addDelayNotice(java.time.LocalDate.parse(old),java.time.LocalDate.parse(revised),
                            rs.getString("reason"),rs.getString("reported_at"));
                    }
                }
            }
        }
    }
    @Override public List<PortPojo> listPorts() throws SQLException {
        List<PortPojo> list=new ArrayList<>();
        try(Connection c=GetConnection.getConnection();
            PreparedStatement ps=c.prepareStatement("SELECT port_id,port_name FROM ports ORDER BY port_name");
            ResultSet rs=ps.executeQuery()) {
            while(rs.next()) list.add(new PortPojo(rs.getInt(1),rs.getString(2)));
        }
        return list;
    }
    @Override public void updateField(int userId,int shipmentId,String field,String value) throws SQLException {
        try(Connection c=GetConnection.getConnection();
            CallableStatement cs=c.prepareCall("{CALL sp_update_shipment_field(?,?,?,?)}")) {
            cs.setInt(1,userId);cs.setInt(2,shipmentId);cs.setString(3,field);cs.setString(4,value);
            cs.execute();
        }
    }
    /** Update ETD and ETA in one authorized database statement (atomic pair). */
    @Override public void updateSchedule(int userId,int shipmentId,
            java.time.LocalDate etd,java.time.LocalDate eta) throws SQLException {
        String sql="UPDATE shipment sh SET sh.etd=?, sh.eta=? "
            +"WHERE sh.shipment_id=? AND sh.status NOT IN ('DELIVERED','CANCELLED') "
            +"AND EXISTS (SELECT 1 FROM users u WHERE u.user_id=? AND u.status='ACTIVE' "
            +"AND u.role='SELLER' AND u.company_id=sh.seller_id)";
        try(Connection c=GetConnection.getConnection();
            PreparedStatement ps=c.prepareStatement(sql)) {
            ps.setDate(1,Date.valueOf(etd));
            ps.setDate(2,Date.valueOf(eta));
            ps.setInt(3,shipmentId);
            ps.setInt(4,userId);
            int updated=ps.executeUpdate();
            if(updated==1)return;
            // Drivers can return zero when both date values are unchanged.
            // Distinguish an unchanged authorized record from lost authorization.
            try(PreparedStatement check=c.prepareStatement(
                    "SELECT sh.etd,sh.eta FROM shipment sh JOIN users u "
                    +"ON u.company_id=sh.seller_id AND u.user_id=? AND u.role='SELLER' "
                    +"AND u.status='ACTIVE' WHERE sh.shipment_id=? "
                    +"AND sh.status NOT IN ('DELIVERED','CANCELLED')")) {
                check.setInt(1,userId);
                check.setInt(2,shipmentId);
                try(ResultSet rs=check.executeQuery()) {
                    if(rs.next() && Date.valueOf(etd).equals(rs.getDate(1))
                            && Date.valueOf(eta).equals(rs.getDate(2)))return;
                }
            }
            throw new SQLException("Shipment schedule not saved: record closed, modified or access denied", "45000");
        }
    }

    /** Atomically save the revised ETA and an immutable notice readable by the Consumer.
     * The existing audit_log is used rather than introducing any new table/column.
     */
    @Override public void reportDelay(int userId, int shipmentId,
            java.time.LocalDate revisedEta, String reason) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                java.time.LocalDate oldEta, etd;
                String status;
                String select="SELECT sh.etd, sh.eta, sh.status FROM shipment sh "
                    +"JOIN users u ON u.company_id=sh.seller_id "
                    +"WHERE sh.shipment_id=? AND u.user_id=? AND u.role='SELLER' "
                    +"AND u.status='ACTIVE' FOR UPDATE";
                try(PreparedStatement ps=c.prepareStatement(select)) {
                    ps.setInt(1,shipmentId);ps.setInt(2,userId);
                    try(ResultSet rs=ps.executeQuery()) {
                        if(!rs.next())throw new SQLException("Shipment is unavailable to this Seller", "45000");
                        Date d=rs.getDate("etd"),a=rs.getDate("eta");
                        etd=d==null?null:d.toLocalDate();oldEta=a==null?null:a.toLocalDate();
                        status=rs.getString("status");
                    }
                }
                if("DELIVERED".equals(status)||"CANCELLED".equals(status)
                        ||"ARRIVED".equals(status)||"CUSTOMS_CLEARED".equals(status))
                    throw new SQLException("Cannot report a shipment delay after arrival or closure", "45000");
                if(oldEta==null||!revisedEta.isAfter(oldEta)
                        ||(etd!=null&&revisedEta.isBefore(etd)))
                    throw new SQLException("Revised ETA must be later than the saved ETA and not before ETD", "45000");
                if(reason==null||reason.trim().length()<10||reason.length()>255)
                    throw new SQLException("Reason must contain 10 to 255 characters", "45000");
                try(PreparedStatement ps=c.prepareStatement(
                        "UPDATE shipment SET eta=? WHERE shipment_id=? AND eta=?")) {
                    ps.setDate(1,Date.valueOf(revisedEta));ps.setInt(2,shipmentId);ps.setDate(3,Date.valueOf(oldEta));
                    if(ps.executeUpdate()!=1)throw new SQLException("Shipment ETA changed; reload and retry", "45000");
                }
                // MySQL JSON_OBJECT safely quotes user-supplied reason. No string-built JSON.
                String audit="INSERT INTO audit_log (user_id,action,table_name,record_id,old_value,new_value,ip_address) "
                    +"VALUES (?, 'SHIPMENT_DELAY_REPORTED', 'shipment', ?, JSON_OBJECT('eta', ?), "
                    +"JSON_OBJECT('previous_eta', ?, 'revised_eta', ?, 'reason', ?, "
                    +"'reported_at', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')), NULL)";
                try(PreparedStatement ps=c.prepareStatement(audit)) {
                    ps.setInt(1,userId);ps.setInt(2,shipmentId);
                    ps.setString(3,oldEta.toString());ps.setString(4,oldEta.toString());
                    ps.setString(5,revisedEta.toString());ps.setString(6,reason);
                    if(ps.executeUpdate()!=1)throw new SQLException("Delay report not recorded", "45000");
                }
                c.commit();
            } catch(SQLException|RuntimeException ex) {
                try { c.rollback(); } catch(SQLException rollback) { ex.addSuppressed(rollback); }
                throw ex;
            } finally { c.setAutoCommit(true); }
        }
    }
    private static Integer nullableInt(ResultSet rs,String col) throws SQLException {
        int val=rs.getInt(col);return rs.wasNull()?null:val;
    }
    private static java.time.LocalDate date(ResultSet rs,String col) throws SQLException {
        Date d=rs.getDate(col);return d==null?null:d.toLocalDate();
    }
}
