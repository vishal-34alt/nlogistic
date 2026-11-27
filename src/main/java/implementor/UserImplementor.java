
package implementor;

import db_config.GetConnection;
import model.User;
import operations.UserOperations;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class UserImplementor implements UserOperations {

    @Override
    public User getUserById(int actorId) throws SQLException {
        if (actorId<=0) throw new IllegalArgumentException("Invalid account");
        final String sql="SELECT user_id,role,company_id,full_name,email,phone,status,failed_attempts,last_login "
                +"FROM users WHERE user_id=? AND status='ACTIVE'";
        try (Connection connection=GetConnection.getConnection();
             java.sql.PreparedStatement statement=connection.prepareStatement(sql)) {
            statement.setInt(1, actorId);
            try(ResultSet result=statement.executeQuery()){
                return result.next()?mapUser(result):null;
            }
        }
    }


    @Override
    public int insertUser(User user, String password)
            throws SQLException {

        String sql = "{CALL sp_insert_user(?, ?, ?, ?, ?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, user.getRole());

            if (user.getCompanyId() == null) {
                cs.setNull(2, Types.INTEGER);
            } else {
                cs.setInt(2, user.getCompanyId());
            }

            cs.setString(3, user.getFullName());
            cs.setString(4, user.getEmail());
            cs.setString(5, password);
            cs.setString(6, user.getPhone());

            boolean hasResult = cs.execute();

            if (hasResult) {
                try (ResultSet rs = cs.getResultSet()) {
                    if (rs.next()) {
                        return rs.getInt("user_id");
                    }
                }
            }
        }

        return 0;
    }

    @Override
    public boolean updateUserField(
            int userId,
            int recordId,
            String fieldName,
            String newValue,
            String ipAddress) throws SQLException {

        String sql = "{CALL sp_update_user_field(?, ?, ?, ?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.setInt(2, recordId);
            cs.setString(3, fieldName);
            cs.setString(4, newValue);
            cs.setString(5, ipAddress);

            cs.execute();
            return true;
        }
    }

    @Override
    public boolean deleteUser(int userId) throws SQLException {

        String sql = "{CALL sp_delete_user(?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.execute();

            return true;
        }
    }

    @Override
    public List<User> getAllUsers() throws SQLException {

        List<User> users = new ArrayList<>();

        String sql = "{CALL sp_show_users()}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }
        }

        return users;
    }

    @Override
    public List<User> searchUsers(
            String keyword,
            String role,
            String status) throws SQLException {

        List<User> users = new ArrayList<>();

        String sql = "{CALL sp_search_users(?, ?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, keyword);
            cs.setString(2, role);
            cs.setString(3, status);

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        }

        return users;
    }

    @Override
    public User getUserForLogin(
            String email,
            String password) throws SQLException {

        String sql = "{CALL sp_get_user_for_login(?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, email);
            cs.setString(2, password);

            try (ResultSet rs = cs.executeQuery()) {

                if (rs.next()) {
                    User user = new User();

                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));

                    int companyId = rs.getInt("company_id");

                    if (rs.wasNull()) {
                        user.setCompanyId(null);
                    } else {
                        user.setCompanyId(companyId);
                    }

                    user.setStatus(rs.getString("status"));
                    user.setLastLogin(rs.getTimestamp("last_login"));

                    return user;
                }
            }
        }

        return null;
    }

    @Override
    public boolean logout(int userId) throws SQLException {

        String sql = "{CALL sp_logout(?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.execute();

            return true;
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {

        User user = new User();

        user.setUserId(rs.getInt("user_id"));
        user.setRole(rs.getString("role"));

        int companyId = rs.getInt("company_id");

        if (rs.wasNull()) {
            user.setCompanyId(null);
        } else {
            user.setCompanyId(companyId);
        }

        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setStatus(rs.getString("status"));
        user.setFailedAttempts(rs.getInt("failed_attempts"));
        user.setLastLogin(rs.getTimestamp("last_login"));

        return user;
    }
}
