package implementor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import operations.ClaimDocumentOperations;
import db_config.GetConnection;
import model.ClaimDocument;

public class ClaimDocumentImplementor implements ClaimDocumentOperations {

    @Override
    public int addClaimDocument(int claimId, int userId, String fileName, String filePath, String fileType) throws Exception {
        String sql = "{CALL sp_add_claim_document(?, ?, ?, ?, ?)}";
        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, claimId);
            cs.setInt(2, userId);
            cs.setString(3, fileName);
            cs.setString(4, filePath);
            cs.setString(5, fileType);
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cdoc_id");
                }
            }
        }
        return 0;
    }

    @Override
    public void updateClaimDocument(int userId, int cdocId, String fieldName, String newValue) throws Exception {
        String sql = "{CALL sp_update_claim_document(?, ?, ?, ?)}";
        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, userId);
            cs.setInt(2, cdocId);
            cs.setString(3, fieldName);
            cs.setString(4, newValue);
            cs.execute();
        }
    }

    @Override
    public void deleteClaimDocument(int userId, int cdocId) throws Exception {
        String sql = "{CALL sp_delete_claim_document(?, ?)}";
        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, userId);
            cs.setInt(2, cdocId);
            cs.execute();
        }
    }

    @Override
    public List<ClaimDocument> getDocumentsByClaimId(int claimId, int userId) throws Exception {
        List<ClaimDocument> list = new ArrayList<>();
        String sql = "{CALL sp_get_claim_details(?, ?)}";
        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, claimId);
            cs.setInt(2, userId);
            boolean hasRs = cs.execute();
            // Advance to Result Set 2 (Claim Documents)
            if (hasRs && cs.getMoreResults()) {
                try (ResultSet rs = cs.getResultSet()) {
                    while (rs.next()) {
                        ClaimDocument doc = new ClaimDocument();
                        doc.setCdocId(rs.getInt("cdoc_id"));
                        doc.setClaimId(rs.getInt("claim_id"));
                        doc.setFileName(rs.getString("file_name"));
                        doc.setFilePath(rs.getString("file_path"));
                        doc.setFileType(rs.getString("file_type"));
                        doc.setUploadedAt(rs.getTimestamp("uploaded_at"));
                        list.add(doc);
                    }
                }
            }
        }
        return list;
    }
}