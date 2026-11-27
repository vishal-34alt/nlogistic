package operations;

import java.sql.SQLException;
import java.util.List;
import model.AuditLog;

public interface AuditLogOperations {

    List<AuditLog> getAllAuditLogs() throws SQLException;

    List<AuditLog> searchAuditLog(Integer userId, String tableName)
            throws SQLException;
}