package operations;
import java.sql.SQLException;
import model.User;
public interface AuthSessionOperations {
    User findActiveUser(int userId) throws SQLException;
}
