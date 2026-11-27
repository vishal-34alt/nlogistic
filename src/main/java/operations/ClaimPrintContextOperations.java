package operations;
import model.Row;
public interface ClaimPrintContextOperations {
    Row findByShipment(int shipmentId) throws Exception;
}
