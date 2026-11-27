package implementor;

import db_config.GetConnection;
import model.AuditLog;
import operations.AuditLogOperations;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.sql.PreparedStatement;

public class AuditLogImplementor implements AuditLogOperations {

    @Override
    public List<AuditLog> getAllAuditLogs() throws SQLException {

        List<AuditLog> logs = new ArrayList<>();

        String sql = "{CALL sp_show_audit_log()}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                logs.add(mapAuditLog(rs));
            }
        }
        fillActorNames(logs);
        return logs;
    }

    @Override
    public List<AuditLog> searchAuditLog(Integer userId, String tableName)
            throws SQLException {

        List<AuditLog> logs = new ArrayList<>();

        String sql = "{CALL sp_search_audit_log(?,?,?,?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            // User ID filter
            if (userId == null) {
                cs.setNull(1, Types.INTEGER);
            } else {
                cs.setInt(1, userId);
            }

            // Table name filter
            if (tableName == null || tableName.trim().isEmpty()) {
                cs.setNull(2, Types.VARCHAR);
            } else {
                cs.setString(2, tableName);
            }

            // Date filters are NULL because audit_log has no timestamp column
            cs.setNull(3, Types.DATE);
            cs.setNull(4, Types.DATE);

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    logs.add(mapAuditLog(rs));
                }
            }
        }
        fillActorNames(logs);
        return logs;
    }

    /** Uses the existing users table; never changes stored audit history. */
    private void fillActorNames(List<AuditLog> logs) throws SQLException {
        if(logs.isEmpty())return;
        Map<Integer,String> names=new HashMap<>();
        try(Connection con=GetConnection.getConnection();
            PreparedStatement ps=con.prepareStatement("SELECT user_id,full_name FROM users");
            ResultSet rs=ps.executeQuery()) {
            while(rs.next())names.put(rs.getInt("user_id"),rs.getString("full_name"));
        }
        for(AuditLog log:logs){
            if(log.getUserId()!=null)log.setActorName(names.get(log.getUserId()));
        }
    }

    private AuditLog mapAuditLog(ResultSet rs) throws SQLException {

        AuditLog log = new AuditLog();

        log.setLogId(rs.getLong("log_id"));

        int userId = rs.getInt("user_id");
        log.setUserId(rs.wasNull() ? null : userId);

        log.setAction(rs.getString("action"));
        log.setTableName(rs.getString("table_name"));

        long recordId = rs.getLong("record_id");
        log.setRecordId(rs.wasNull() ? null : recordId);

        log.setOldValue(rs.getString("old_value"));
        log.setNewValue(rs.getString("new_value"));
        log.setIpAddress(rs.getString("ip_address"));

        return log;
    }
}