
package operations;

import java.sql.SQLException;
import java.util.List;
import model.ABCClassification;

public interface ABCClassificationOperations {

    List<ABCClassification> getABCClassification(Integer sellerCompanyId)
            throws SQLException;
}
