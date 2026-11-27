package model;
import java.sql.SQLException;
import implementor.DashboardImplementor;
import operations.DashboardOperations;
/** Business entry point without a separate service package. */
public final class DashboardActions {
  private final DashboardOperations operations=new DashboardImplementor();
  public DashboardSummary summary(int userId)throws SQLException {
     if(userId<=0)throw new SecurityException("Login required");
     return operations.summary(userId);
  }
}
