package operations;
import java.sql.SQLException;
import java.util.Set;
public interface AnalyticsMaintenanceOperations {
 int refreshSalesCache(int actor)throws SQLException;
 int generateBaselineForecast(int actor,int origin,int dest,String type,java.time.LocalDate month)throws SQLException;
 Set<Integer> shipmentIdsForRoute(int company,Integer origin,Integer dest)throws SQLException;
}
