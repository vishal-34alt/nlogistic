package operations;
import java.sql.SQLException;
import java.util.List;
import model.WorkspaceSearchHit;
public interface WorkspaceSearchOperations {
    List<WorkspaceSearchHit> search(int userId,String query) throws SQLException;
}
