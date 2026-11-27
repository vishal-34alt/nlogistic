
package operations;

import java.sql.SQLException;
import java.util.List;
import model.InventoryTurnover;

public interface InventoryTurnoverOperations {

    List<InventoryTurnover> getInventoryTurnover(Integer sellerCompanyId)
            throws SQLException;
}
