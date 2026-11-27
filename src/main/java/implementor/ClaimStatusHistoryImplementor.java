package implementor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import operations.ClaimStatusHistoryOperations;
import db_config.GetConnection;
import model.ClaimStatusHistory;

public class ClaimStatusHistoryImplementor implements ClaimStatusHistoryOperations {

    @Override
    public void addClaimComment(int claimId, int userId, String comment) throws Exception {
        String sql = "{CALL sp_add_claim_comment(?, ?, ?)}";
        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, claimId);
            cs.setInt(2, userId);
            cs.setString(3, comment);
            cs.execute();
        }
    }

    @Override
    public List<ClaimStatusHistory> getHistoryByClaimId(int claimId, int userId) throws Exception {
        List<ClaimStatusHistory> list = new ArrayList<>();
        String sql = "{CALL sp_get_claim_details(?, ?)}";
        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, claimId);
            cs.setInt(2, userId);
            boolean hasRs = cs.execute();
            // Advance to Result Set 3 (History)
            if (hasRs && cs.getMoreResults() && cs.getMoreResults()) {
                try (ResultSet rs = cs.getResultSet()) {
                    while (rs.next()) {
                        ClaimStatusHistory h = new ClaimStatusHistory();
                        h.setHistoryId(rs.getLong("history_id"));
                        h.setClaimId(rs.getInt("claim_id"));
                        h.setOldStatus(rs.getString("old_status"));
                        h.setNewStatus(rs.getString("new_status"));
                        h.setChangedBy(rs.getObject("changed_by") != null ? rs.getInt("changed_by") : null);
                        h.setChangedByName(rs.getString("changed_by_name"));
                        h.setRemarks(rs.getString("remarks"));
                        h.setChangedAt(rs.getTimestamp("changed_at"));
                        list.add(h);
                    }
                }
            }
        }
        return list;
    }
}