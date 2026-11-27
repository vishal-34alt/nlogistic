package operations;
import java.sql.SQLException;
import java.util.List;
import model.User;
import model.PortPojo;
import model.ShipmentPojo;

public interface ShipmentOperations {
    User findActiveUser(int userId) throws SQLException;
    List<ShipmentPojo> search(int userId, String containerNumber, Integer shipmentId,
                              Integer portId, String status) throws SQLException;
    void enrichDetails(ShipmentPojo shipment) throws SQLException;
    List<PortPojo> listPorts() throws SQLException;
    void updateField(int userId, int shipmentId, String field, String value) throws SQLException;
    void updateSchedule(int userId, int shipmentId, java.time.LocalDate etd,
                        java.time.LocalDate eta) throws SQLException;
    void reportDelay(int userId, int shipmentId, java.time.LocalDate revisedEta, String reason) throws SQLException;
}
