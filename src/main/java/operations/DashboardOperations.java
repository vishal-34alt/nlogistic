package operations;
import java.sql.SQLException;
import model.DashboardSummary;
public interface DashboardOperations { DashboardSummary summary(int userId) throws SQLException; }
