package operations;

import java.sql.SQLException;
import java.util.List;
import model.DemandForecast;

public interface DemandForecastOperations {

    List<DemandForecast> getDemandForecast(Integer sellerCompanyId)
            throws SQLException;
}