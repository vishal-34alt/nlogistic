
package operations;

import java.sql.SQLException;
import java.util.List;
import model.User;

public interface UserOperations {

    /** Only an active user whose identifier matches the supplied ID. */
    User getUserById(int userId) throws SQLException;

    // Register new user
    int insertUser(User user, String password) throws SQLException;

    // Update one specific user field
    boolean updateUserField(
        int userId,
        int recordId,
        String fieldName,
        String newValue,
        String ipAddress
    ) throws SQLException;

    // Delete user
    boolean deleteUser(int userId) throws SQLException;

    // Display all users
    List<User> getAllUsers() throws SQLException;

    // Search users
    List<User> searchUsers(
        String keyword,
        String role,
        String status
    ) throws SQLException;

    // User login authentication
    User getUserForLogin(
        String email,
        String password
    ) throws SQLException;

    // User logout
    boolean logout(int userId) throws SQLException;
}
