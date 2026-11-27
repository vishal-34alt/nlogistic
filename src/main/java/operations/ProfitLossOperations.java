package operations;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import model.ProfitLossPojo;
public interface ProfitLossOperations {
    List<ProfitLossPojo> shipmentReport(Integer sellerId,LocalDate start,LocalDate end) throws SQLException;
    List<ProfitLossPojo> monthlyReport(Integer sellerId,LocalDate start,LocalDate end) throws SQLException;
    ProfitLossPojo calculate(int shipmentId,LocalDate month) throws SQLException;
    void refresh(int shipmentId,LocalDate month,BigDecimal freight,BigDecimal port,BigDecimal handling) throws SQLException;
}
