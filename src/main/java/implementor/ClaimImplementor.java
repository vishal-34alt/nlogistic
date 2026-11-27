package implementor;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import operations.ClaimOperations;
import db_config.GetConnection;
import model.Claim;
import model.ClaimShipmentOption;
import model.ClaimStockOption;

/** Module 7 SQL stays in the implementor layer. Business mutations use reviewed stored procedures. */
public final class ClaimImplementor implements ClaimOperations {
    @Override
    public int submitClaim(int userId, int shipmentId, String claimType, String description,
                           BigDecimal claimedAmount, int claimWindowDays) throws Exception {
        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall("{CALL sp_submit_claim(?, ?, ?, ?, ?, ?)}")) {
            cs.setInt(1, userId);
            cs.setInt(2, shipmentId);
            cs.setString(3, claimType);
            cs.setString(4, description);
            cs.setBigDecimal(5, claimedAmount);
            cs.setInt(6, claimWindowDays);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) return rs.getInt("claim_id");
            }
        }
        throw new SQLException("Claim was not confirmed by the database.");
    }
    @Override
    public void updateClaimField(int userId, int claimId, String fieldName, String newValue) throws Exception {
        try (Connection con=GetConnection.getConnection(); CallableStatement cs=con.prepareCall("{CALL sp_update_claim_field(?, ?, ?, ?)}")) {
            requireActiveClaim(con,claimId);
            cs.setInt(1,userId);cs.setInt(2,claimId);cs.setString(3,fieldName);cs.setString(4,newValue);cs.execute();
        }
    }
    /**
     * An unreviewed SUBMITTED claim can be removed from all user-facing registers,
     * while its row, evidence, FK history and audit trail remain intact.
     * The approved database refuses physical deletion of protected history. Store
     * a one-way WITHDRAW_CLAIM audit event rather than weakening its trigger/FKs.
     */
    @Override
    public void deleteClaim(int claimId,int userId) throws Exception {
        if(claimId<=0||userId<=0)throw new IllegalArgumentException("Invalid claim or user.");
        try(Connection con=GetConnection.getConnection()){
            con.setAutoCommit(false);
            try {
                String claimNo;
                try(PreparedStatement ps=con.prepareStatement(
                    "SELECT cl.claim_no FROM claims cl JOIN customers cu ON cu.customer_id=cl.consumer_id "
                    +"JOIN users u ON u.user_id=cu.user_id WHERE cl.claim_id=? AND u.user_id=? "
                    +"AND u.role='CONSUMER' AND u.status='ACTIVE' AND cl.status='SUBMITTED' "
                    +"AND NOT EXISTS(SELECT 1 FROM claim_status_history h WHERE h.claim_id=cl.claim_id "
                    +"AND (h.new_status IN ('UNDER_REVIEW','APPROVED','PARTIALLY_APPROVED','REJECTED','SETTLED') "
                    +"OR h.old_status IN ('UNDER_REVIEW','APPROVED','PARTIALLY_APPROVED','REJECTED','SETTLED'))) "
                    +"FOR UPDATE")){
                    ps.setInt(1,claimId);ps.setInt(2,userId);
                    try(ResultSet rs=ps.executeQuery()){
                        if(!rs.next())throw new IllegalArgumentException("Only your own never-reviewed, submitted claim may be removed.");
                        claimNo=rs.getString(1);
                    }
                }
                if(isWithdrawn(con,claimId))throw new IllegalArgumentException("This claim has already been removed.");
                try(PreparedStatement audit=con.prepareStatement(
                    "INSERT INTO audit_log(user_id,action,table_name,record_id,old_value,new_value,ip_address) "
                    +"VALUES (?,'WITHDRAW_CLAIM','claims',?, "
                    +"JSON_OBJECT('claim_no',?,'status','SUBMITTED'), "
                    +"JSON_OBJECT('state','REMOVED','history_retained',true,'removed_at',NOW()),NULL)")){
                    audit.setInt(1,userId);audit.setInt(2,claimId);audit.setString(3,claimNo);
                    if(audit.executeUpdate()!=1)throw new SQLException("Claim removal was not recorded.");
                }
                con.commit();
            }catch(Exception ex){
                try{con.rollback();}catch(SQLException rollback){ex.addSuppressed(rollback);}
                throw ex;
            }finally{try{con.setAutoCommit(true);}catch(SQLException ignored){}}
        }
    }
    private static boolean isWithdrawn(Connection con,int claimId)throws SQLException {
        try(PreparedStatement ps=con.prepareStatement(
            "SELECT 1 FROM audit_log WHERE table_name='claims' AND action='WITHDRAW_CLAIM' "
            +"AND record_id=? LIMIT 1")){
            ps.setInt(1,claimId);try(ResultSet rs=ps.executeQuery()){return rs.next();}
        }
    }
    private static java.util.Set<Integer> withdrawnClaimIds(Connection con)throws SQLException {
        java.util.Set<Integer> withdrawn=new java.util.HashSet<>();
        try(PreparedStatement ps=con.prepareStatement(
            "SELECT DISTINCT record_id FROM audit_log WHERE table_name='claims' "
            +"AND action='WITHDRAW_CLAIM' AND record_id IS NOT NULL");
            ResultSet rs=ps.executeQuery()){
            while(rs.next())withdrawn.add(rs.getInt(1));
        }
        return withdrawn;
    }
    private static void requireActiveClaim(Connection con,int claimId)throws SQLException {
        if(isWithdrawn(con,claimId))throw new IllegalArgumentException("This claim was removed before review and is no longer active.");
    }
    @Override
    public List<Claim> searchClaims(int userId,String status) throws Exception {
        List<Claim> list=new ArrayList<>();
        try (Connection con=GetConnection.getConnection(); CallableStatement cs=con.prepareCall("{CALL sp_search_claims(?, ?)}")) {
            cs.setInt(1,userId);
            if(status==null||status.trim().isEmpty()||"ALL".equalsIgnoreCase(status))cs.setNull(2,Types.VARCHAR);
            else cs.setString(2,status);
            try(ResultSet rs=cs.executeQuery()) {while(rs.next())list.add(mapClaim(rs));}
        }
        try(Connection con=GetConnection.getConnection()){
            java.util.Set<Integer> removed=withdrawnClaimIds(con);
            list.removeIf(c->removed.contains(c.getClaimId()));
        }
        return list;
    }
    @Override
    public Claim getClaimById(int claimId,int userId) throws Exception {
        try (Connection con=GetConnection.getConnection(); CallableStatement cs=con.prepareCall("{CALL sp_get_claim_details(?, ?)}")) {
            cs.setInt(1,claimId);cs.setInt(2,userId);
            try(ResultSet rs=cs.executeQuery()) {
                Claim result=rs.next()?mapClaim(rs):null;
                if(result==null)return null;
                // Check the in-database audit marker without exposing removed claims.
                try(Connection auditCon=GetConnection.getConnection()){
                    return isWithdrawn(auditCon,result.getClaimId())?null:result;
                }
            }
        }
    }
    private Claim mapClaim(ResultSet rs) throws SQLException {
        Claim c=new Claim();
        c.setClaimId(rs.getInt("claim_id"));c.setClaimNo(rs.getString("claim_no"));
        c.setShipmentId(rs.getInt("shipment_id"));c.setShipmentNo(rs.getString("shipment_no"));
        Object container=rs.getObject("container_id");c.setContainerId(container==null?null:((Number)container).intValue());
        c.setConsumerId(rs.getInt("consumer_id"));c.setClaimType(rs.getString("claim_type"));
        c.setDescription(rs.getString("description"));c.setClaimedAmount(rs.getBigDecimal("claimed_amount"));
        c.setApprovedAmount(rs.getBigDecimal("approved_amount"));c.setStatus(rs.getString("status"));
        c.setSellerRemarks(rs.getString("seller_remarks"));c.setRaisedAt(rs.getTimestamp("raised_at"));
        c.setSettledAt(rs.getTimestamp("settled_at"));return c;
    }
    @Override
    public void reviewClaim(int claimId,int userId,String decision,BigDecimal approvedAmount,String remarks) throws Exception {
        try(Connection con=GetConnection.getConnection();CallableStatement cs=con.prepareCall("{CALL sp_review_claim(?, ?, ?, ?, ?)}")) {
            requireActiveClaim(con,claimId);
            cs.setInt(1,claimId);cs.setInt(2,userId);cs.setString(3,decision);
            cs.setBigDecimal(4,approvedAmount==null?BigDecimal.ZERO:approvedAmount);
            cs.setString(5,remarks);cs.execute();
        }
    }
    @Override
    public void settleClaim(int claimId,int userId,Integer stockId,Integer quantity,String remarks) throws Exception {
        try(Connection con=GetConnection.getConnection();CallableStatement cs=con.prepareCall("{CALL sp_settle_claim(?, ?, ?, ?, ?)}")) {
            requireActiveClaim(con,claimId);
            cs.setInt(1,claimId);cs.setInt(2,userId);
            if(stockId==null)cs.setNull(3,Types.INTEGER);else cs.setInt(3,stockId);
            if(quantity==null)cs.setNull(4,Types.INTEGER);else cs.setInt(4,quantity);
            cs.setString(5,remarks);cs.execute();
        }
    }
    @Override
    public List<ClaimShipmentOption> getEligibleShipments(int userId,int windowDays) throws Exception {
        // Scoped by active Consumer -> customer -> shipment; no administrative visibility leak.
        String sql="SELECT s.shipment_id,s.shipment_no,s.status,s.actual_arrival FROM shipment s "
            +"JOIN customers cu ON cu.customer_id=s.consumer_id "
            +"JOIN users u ON u.user_id=cu.user_id "
            +"WHERE u.user_id=? AND u.role='CONSUMER' AND u.status='ACTIVE' "
            +"AND s.status IN ('ARRIVED','DELIVERED') AND s.actual_arrival IS NOT NULL "
            +"AND DATEDIFF(CURDATE(),s.actual_arrival) BETWEEN 0 AND ? "
            +"ORDER BY s.actual_arrival DESC,s.shipment_no";
        List<ClaimShipmentOption> out=new ArrayList<>();
        try(Connection con=GetConnection.getConnection();PreparedStatement ps=con.prepareStatement(sql)) {
            ps.setInt(1,userId);ps.setInt(2,windowDays);
            try(ResultSet rs=ps.executeQuery()) {while(rs.next())out.add(new ClaimShipmentOption(
                rs.getInt("shipment_id"),rs.getString("shipment_no"),rs.getString("status"),rs.getDate("actual_arrival")));}
        }
        return out;
    }
    @Override
    public List<ClaimShipmentOption> getClaimCandidateShipments(int userId, int windowDays) throws Exception {
        // This query is scoped to the CURRENT consumer's shipments only. Prices are
        // read from existing SRS columns; no new column or stored routine is used.
        // Missing invoice/items remain null so the UI never misreports them as zero.
        String sql = "SELECT s.shipment_id, s.shipment_no, s.status, s.actual_arrival, "
            + "DATEDIFF(CURDATE(), s.actual_arrival) AS age_days, s.quoted_price, "
            + "(SELECT SUM(si.amount) FROM shipment_items si WHERE si.shipment_id=s.shipment_id) AS cargo_value, "
            + "(SELECT SUM(si.quantity) FROM shipment_items si WHERE si.shipment_id=s.shipment_id) AS cargo_units, "
            + "(SELECT bi.total_amount FROM billing_invoices bi WHERE bi.shipment_id=s.shipment_id "
            + " ORDER BY bi.invoice_id DESC LIMIT 1) AS invoice_total, "
            + "o.port_name AS origin_name, d.port_name AS destination_name, "
            + "co.company_name AS seller_name, ct.container_number "
            + "FROM shipment s "
            + "JOIN customers cu ON cu.customer_id=s.consumer_id "
            + "JOIN users u ON u.user_id=cu.user_id "
            + "LEFT JOIN ports o ON o.port_id=s.origin_port_id "
            + "LEFT JOIN ports d ON d.port_id=s.dest_port_id "
            + "LEFT JOIN companies co ON co.company_id=s.seller_id "
            + "LEFT JOIN containers ct ON ct.container_id=s.container_id "
            + "WHERE u.user_id=? AND u.role='CONSUMER' AND u.status='ACTIVE' "
            + "AND s.status IN ('ARRIVED','DELIVERED') "
            + "ORDER BY (s.actual_arrival IS NULL), s.actual_arrival DESC, s.shipment_no";
        List<ClaimShipmentOption> result = new ArrayList<>();
        try (Connection con=GetConnection.getConnection(); PreparedStatement ps=con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs=ps.executeQuery()) {
                while (rs.next()) {
                    Object ageValue=rs.getObject("age_days");
                    Integer age=ageValue instanceof Number ? ((Number) ageValue).intValue() : null;
                    boolean allowed=age!=null && age>=0 && age<=windowDays;
                    String reason=allowed ? null : (age==null ? "No actual arrival date recorded"
                        : (age<0 ? "Actual arrival date is in the future"
                        : "Past the " + windowDays + "-day claim window"));
                    Object units=rs.getObject("cargo_units");
                    Integer cargoUnits=units instanceof Number ? ((Number) units).intValue() : null;
                    result.add(new ClaimShipmentOption(rs.getInt("shipment_id"),rs.getString("shipment_no"),
                        rs.getString("status"),rs.getDate("actual_arrival"),allowed,reason,
                        rs.getBigDecimal("cargo_value"),rs.getBigDecimal("quoted_price"),
                        rs.getBigDecimal("invoice_total"),cargoUnits,rs.getString("origin_name"),
                        rs.getString("destination_name"),rs.getString("seller_name"),
                        rs.getString("container_number")));
                }
            }
        }
        return result;
    }
    @Override
    public List<ClaimStockOption> getShipmentStock(int userId,int shipmentId) throws Exception {
        String sql="SELECT st.stock_id,p.product_name,st.quantity,st.damaged_qty FROM stock st "
            +"JOIN products p ON p.product_id=st.product_id "
            +"JOIN shipment sh ON sh.shipment_id=st.shipment_id "
            +"JOIN users u ON u.company_id=sh.seller_id "
            +"WHERE u.user_id=? AND u.role='SELLER' AND u.status='ACTIVE' AND sh.shipment_id=? "
            +"ORDER BY st.stock_id";
        List<ClaimStockOption> out=new ArrayList<>();
        try(Connection con=GetConnection.getConnection();PreparedStatement ps=con.prepareStatement(sql)) {
            ps.setInt(1,userId);ps.setInt(2,shipmentId);
            try(ResultSet rs=ps.executeQuery()) {while(rs.next())out.add(new ClaimStockOption(
                rs.getInt("stock_id"),rs.getString("product_name"),rs.getInt("quantity"),rs.getInt("damaged_qty")));}
        }
        return out;
    }
}
