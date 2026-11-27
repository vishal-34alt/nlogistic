package model;
import java.sql.SQLException;
import java.util.List;
import implementor.WorkspaceSearchImplementor;
import operations.WorkspaceSearchOperations;
/** Business-level validation and delegation; no service package. */
public final class WorkspaceSearchActions {
    private final WorkspaceSearchOperations operations=new WorkspaceSearchImplementor();
    public List<WorkspaceSearchHit> search(int userId,String query) throws SQLException {
        if(userId<=0)throw new SecurityException("Sign in required");
        String text=query==null?"":query.trim();
        if(text.length()<2 || text.length()>64)throw new IllegalArgumentException("Enter 2–64 characters to search");
        return operations.search(userId,text);
    }
}
