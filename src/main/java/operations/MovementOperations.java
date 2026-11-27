package operations;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import model.ContainerMovementPojo;
public interface MovementOperations {
    List<ContainerMovementPojo> search(int userId,Integer shipmentId,String status,
                                        LocalDate startDate,LocalDate endDate) throws SQLException;
    long insert(ContainerMovementPojo movement) throws SQLException;
    void deleteLatest(int userId,long movementId,String reason) throws SQLException;
}
