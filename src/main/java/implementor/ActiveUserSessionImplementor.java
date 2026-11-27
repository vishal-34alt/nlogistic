package implementor;
import java.sql.*;
import db_config.GetConnection;
import model.User;
import operations.AuthSessionOperations;
/** All DB reads for session refresh live in the Implementor layer. */
public final class ActiveUserSessionImplementor implements AuthSessionOperations {
    @Override public User findActiveUser(int userId) throws SQLException {
        try(Connection con=GetConnection.getConnection();
            PreparedStatement ps=con.prepareStatement(
                "SELECT role,company_id,full_name FROM users WHERE user_id=? AND status='ACTIVE'")) {
            ps.setInt(1,userId);
            try(ResultSet rs=ps.executeQuery()) {
                if(!rs.next())return null;
                int company=rs.getInt("company_id");
                return new User(userId,rs.getString("role"),rs.wasNull()?null:company,rs.getString("full_name"));
            }
        }
    }
}
