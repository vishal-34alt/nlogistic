
package implementor;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Types;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import operations.PricingOperations;
import db_config.GetConnection;
import model.PricingRule;

public class PricingImplementor implements PricingOperations {

    private Connection openConnection() throws Exception {

        Connection con = GetConnection.getConnection();

        if (con == null) {
            throw new Exception("Unable to connect to n_logistic_db");
        }

        return con;
    }

    // Convert a ResultSet into a list of maps
    private List<Map<String, Object>> mapResultSet(ResultSet rs)
            throws Exception {

        List<Map<String, Object>> records = new ArrayList<>();

        ResultSetMetaData metadata = rs.getMetaData();
        int columnCount = metadata.getColumnCount();

        while (rs.next()) {

            Map<String, Object> row = new LinkedHashMap<>();

            for (int i = 1; i <= columnCount; i++) {
                row.put(
                        metadata.getColumnLabel(i),
                        rs.getObject(i)
                );
            }

            records.add(row);
        }

        return records;
    }

    // INSERT PRICING RULE
    @Override
    public int insertPricingRule(
            int userId,
            int sellerId,
            PricingRule rule) throws Exception {
    	   String sql = "{CALL sp_insert_pricing_rule(?,?,?,?,?,?,?,?,?,?,?,?)}";
        

        try (Connection con = openConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.setInt(2, sellerId);
            cs.setInt(3, rule.getOriginPortId());
            cs.setInt(4, rule.getDestPortId());
            cs.setString(5, rule.getContainerType());
            cs.setBigDecimal(6, rule.getBaseRate());
            cs.setBigDecimal(7, rule.getRatePerKg());
            cs.setBigDecimal(8, rule.getRatePerCbm());
            cs.setBigDecimal(9, rule.getSeasonMultiplier());
            cs.setBigDecimal(10, rule.getDemandMultiplier());
            cs.setDate(11, rule.getValidFrom());

            if (rule.getValidTo() == null) {
                cs.setNull(12, Types.DATE);
            } else {
                cs.setDate(12, rule.getValidTo());
            }

            // The procedure has 12 IN parameters.
            // The closing placeholder is intentionally not required.
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("rule_id");
                }
            }
        }

        return 0;
    }

    // UPDATE PRICING RULE FIELD
    @Override
    public Map<String, Object> updatePricingRuleField(
            int userId,
            int ruleId,
            String fieldName,
            String newValue) throws Exception {

        String sql = "{CALL sp_update_pricing_rule_field(?,?,?,?)}";

        try (Connection con = openConnection()) {
            ensureNotArchived(con, ruleId);
            try (CallableStatement cs = con.prepareCall(sql)) {
                cs.setInt(1, userId);
                cs.setInt(2, ruleId);
            cs.setString(3, fieldName);
            cs.setString(4, newValue);

            try (ResultSet rs = cs.executeQuery()) {

                List<Map<String, Object>> result = mapResultSet(rs);

                if (!result.isEmpty()) {
                    return result.get(0);
                }
            }
        }

            }
        return null;
    }

    // Full edit: the approved database provides field procedures but no
    // sp_update_pricing_rule routine. Use one authorized UPDATE so all changes
    // commit together and the installed pricing audit trigger runs once.
    @Override
    public void editPricingRule(int userId, int ruleId, PricingRule rule) throws Exception {
        String check = "SELECT pr.rule_id FROM pricing_rules pr JOIN users u ON u.user_id=? "
                + "AND u.role='SELLER' AND u.status='ACTIVE' AND u.company_id=pr.seller_id "
                + "WHERE pr.rule_id=? FOR UPDATE";
        String update = "UPDATE pricing_rules SET base_rate=?, rate_per_kg=?, rate_per_cbm=?, "
                + "season_multiplier=?, demand_multiplier=?, valid_from=?, valid_to=? WHERE rule_id=?";
        try (Connection con = openConnection()) {
            con.setAutoCommit(false);
            Object previousActor = null;
            try {
                try (java.sql.PreparedStatement ps = con.prepareStatement(check)) {
                    ps.setInt(1, userId);
                    ps.setInt(2, ruleId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new SecurityException(
                                "Pricing rule not found or you are not its owning Seller.");
                    }
                }
                ensureNotArchived(con, ruleId);
                try (java.sql.PreparedStatement ps = con.prepareStatement("SELECT @pricing_actor_user_id")) {
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) previousActor = rs.getObject(1);
                    }
                }
                try (java.sql.PreparedStatement ps = con.prepareStatement("SET @pricing_actor_user_id=?")) {
                    ps.setInt(1, userId);
                    ps.execute();
                }
                try (java.sql.PreparedStatement ps = con.prepareStatement(update)) {
                    ps.setBigDecimal(1, rule.getBaseRate());
                    ps.setBigDecimal(2, rule.getRatePerKg());
                    ps.setBigDecimal(3, rule.getRatePerCbm());
                    ps.setBigDecimal(4, rule.getSeasonMultiplier());
                    ps.setBigDecimal(5, rule.getDemandMultiplier());
                    ps.setDate(6, rule.getValidFrom());
                    if (rule.getValidTo() == null) ps.setNull(7, Types.DATE);
                    else ps.setDate(7, rule.getValidTo());
                    ps.setInt(8, ruleId);
                    if (ps.executeUpdate() != 1) throw new java.sql.SQLException(
                            "Pricing rule was not updated.", "45000");
                }
                con.commit();
            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                try (java.sql.PreparedStatement ps = con.prepareStatement("SET @pricing_actor_user_id=?")) {
                    if (previousActor == null) ps.setNull(1, Types.INTEGER);
                    else ps.setObject(1, previousActor);
                    ps.execute();
                } finally {
                    con.setAutoCommit(true);
                }
            }
        }
    }

    private void ensureNotArchived(Connection con, int ruleId) throws Exception {
        String sql = "SELECT 1 FROM audit_log WHERE table_name='pricing_rules' "
                + "AND record_id=? AND action='DELETE' LIMIT 1";
        try (java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ruleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) throw new IllegalArgumentException(
                        "This pricing rule was deleted and cannot be edited.");
            }
        }
    }

    // The SRS pricing_audit FK requires preserving rules. Deletion therefore
    // archives the rule and records an auditable DELETE marker, rather than
    // physically deleting pricing history. The entire operation is atomic.
    @Override
    public void archivePricingRule(int userId, int sellerId, int ruleId) throws Exception {
        try (Connection con = openConnection()) {
            con.setAutoCommit(false);
            try {
                String check = "SELECT pr.base_rate, pr.season_multiplier, pr.demand_multiplier, pr.is_active "
                    + "FROM pricing_rules pr JOIN users u ON u.user_id=? "
                    + "AND u.role='SELLER' AND u.status='ACTIVE' "
                    + "AND u.company_id=pr.seller_id "
                    + "WHERE pr.seller_id=? AND pr.rule_id=? FOR UPDATE";
                java.math.BigDecimal baseRate, multiplier;
                boolean wasActive;
                try (java.sql.PreparedStatement ps = con.prepareStatement(check)) {
                    ps.setInt(1,userId);ps.setInt(2,sellerId);ps.setInt(3,ruleId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new SecurityException(
                                "Pricing rule not found or does not belong to your company.");
                        baseRate=rs.getBigDecimal("base_rate");
                        wasActive=rs.getBoolean("is_active");
                        java.math.BigDecimal season=rs.getBigDecimal("season_multiplier");
                        java.math.BigDecimal demand=rs.getBigDecimal("demand_multiplier");
                        multiplier=(season==null?java.math.BigDecimal.ONE:season)
                          .multiply(demand==null?java.math.BigDecimal.ONE:demand);
                    }
                }
                ensureNotArchived(con,ruleId);
                try (java.sql.PreparedStatement ps=con.prepareStatement(
                        "UPDATE pricing_rules SET is_active=FALSE WHERE rule_id=? AND seller_id=?")) {
                    ps.setInt(1,ruleId);ps.setInt(2,sellerId);
                    if (ps.executeUpdate()!=1) throw new IllegalArgumentException("Rule was not found.");
                }
                try (java.sql.PreparedStatement ps=con.prepareStatement(
                        "INSERT INTO pricing_audit (rule_id,old_rate,new_rate,old_multiplier,new_multiplier,changed_by) "
                        + "VALUES (?,?,?,?,?,?)")) {
                    ps.setInt(1,ruleId);ps.setBigDecimal(2,baseRate);ps.setBigDecimal(3,baseRate);
                    ps.setBigDecimal(4,multiplier);ps.setBigDecimal(5,multiplier);ps.setInt(6,userId);
                    ps.executeUpdate();
                }
                try (java.sql.PreparedStatement ps=con.prepareStatement(
                        "INSERT INTO audit_log (user_id,action,table_name,record_id,old_value,new_value) "
                        + "VALUES (?, 'DELETE', 'pricing_rules', ?, JSON_OBJECT('is_active', ?), "
                        + "JSON_OBJECT('is_active', FALSE, 'archived', TRUE))")) {
                    ps.setInt(1,userId);ps.setInt(2,ruleId);ps.setBoolean(3,wasActive);ps.executeUpdate();
                }
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    // DEACTIVATE PRICING RULE
    @Override
    public void deactivatePricingRule(
            int userId,
            int ruleId) throws Exception {

        String sql = "{CALL sp_delete_pricing_rule(?,?)}";

        try (Connection con = openConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.setInt(2, ruleId);

            cs.execute();
        }
    }

    @Override public List<Map<String,Object>> searchPricingRules(int actor,int seller,String query)throws Exception {
        String q=query==null?"":query.trim();
        String sql="SELECT pr.*,CONCAT(op.port_name, ' (',op.port_code,')') AS origin_port,CONCAT(dp.port_name, ' (',dp.port_code,')') AS dest_port FROM pricing_rules pr JOIN users u ON u.user_id=? AND u.company_id=pr.seller_id AND u.role='SELLER' AND u.status='ACTIVE' LEFT JOIN ports op ON op.port_id=pr.origin_port_id LEFT JOIN ports dp ON dp.port_id=pr.dest_port_id WHERE pr.seller_id=? AND NOT EXISTS (SELECT 1 FROM audit_log al WHERE al.table_name='pricing_rules' AND al.record_id=pr.rule_id AND al.action='DELETE') AND (?='' OR CAST(pr.rule_id AS CHAR) LIKE ? OR CAST(pr.origin_port_id AS CHAR) LIKE ? OR CAST(pr.dest_port_id AS CHAR) LIKE ? OR pr.container_type LIKE ?) ORDER BY pr.rule_id DESC";
        try(Connection c=openConnection();java.sql.PreparedStatement ps=c.prepareStatement(sql)){
            ps.setInt(1,actor);ps.setInt(2,seller);ps.setString(3,q);for(int i=4;i<=7;i++)ps.setString(i,"%"+q+"%");
            try(ResultSet rs=ps.executeQuery()){return mapResultSet(rs);}
        }
    }
    // DISPLAY PRICING RULES
    @Override
    public List<Map<String, Object>> getPricingRules(
            Integer sellerId) throws Exception {

        List<Map<String, Object>> rules = new ArrayList<>();

        String sql = "{CALL sp_show_pricing_rules(?)}";

        try (Connection con = openConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            if (sellerId == null) {
                cs.setNull(1, Types.INTEGER);
            } else {
                cs.setInt(1, sellerId);
            }

            try (ResultSet rs = cs.executeQuery()) {
                rules = mapResultSet(rs);
            }
        }

        return rules;
    }

    // DISPLAY PRICING AUDIT
    @Override
    public List<Map<String, Object>> getPricingAudit(
            Integer ruleId) throws Exception {

        List<Map<String, Object>> audit = new ArrayList<>();

        String sql = "{CALL sp_show_pricing_audit(?)}";

        try (Connection con = openConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            if (ruleId == null) {
                cs.setNull(1, Types.INTEGER);
            } else {
                cs.setInt(1, ruleId);
            }

            try (ResultSet rs = cs.executeQuery()) {
                audit = mapResultSet(rs);
            }
        }

        return audit;
    }
}
