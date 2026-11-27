
package operations;

import java.sql.SQLException;
import java.util.List;
import model.AnalyticsProfitLoss;

public interface AnalyticsProfitLossOperations {

    List<AnalyticsProfitLoss> getProfitLoss(Integer sellerCompanyId) throws SQLException;
}
