
package operations;

import java.sql.SQLException;
import java.util.List;
import model.Profitability;

public interface ProfitabilityOperations {

    List<Profitability> getProfitability(Integer sellerCompanyId)
            throws SQLException;
}
