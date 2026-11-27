package model;
import java.sql.SQLException;
import operations.AuthSessionOperations;
import implementor.ActiveUserSessionImplementor;
/** Filter calls the Model; the model calls an Implementor-backed operations interface. */
public final class AuthSessionActions {
    private final AuthSessionOperations dao=new ActiveUserSessionImplementor();
    public User activeUser(int userId) throws SQLException {
        if(userId<=0)return null;
        return dao.findActiveUser(userId);
    }
}
