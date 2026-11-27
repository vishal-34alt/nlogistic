package operations;
import model.Row;import java.sql.*;import java.util.*;
public interface BillingOperations {
 List<Row> findActiveUser(int userId)throws SQLException;
 Integer invoiceIdForShipment(int userId,int shipmentId)throws SQLException;
 /** Resolve the owned shipment from an invoice; used only for post-payment navigation. */
 Integer shipmentIdForInvoice(int consumerUserId,int invoiceId)throws SQLException;
 List<Row> unbilledSellerShipments(int sellerCompanyId)throws SQLException;
 /** Store a Consumer's pay-on-delivery selection as an audit event. No schema changes. */
 void recordDeliveryArrangement(int userId,int invoiceId,String ipAddress)throws SQLException;
 boolean hasDeliveryArrangement(int userId,int invoiceId)throws SQLException;
 /** Shipment states of invoices visible to this user; no SQL outside the Implementor. */
 java.util.Map<Integer,String> invoiceShipmentStatuses(int userId)throws SQLException;
 String invoiceShipmentStatus(int userId,int invoiceId)throws SQLException;
 Integer invoiceForLineItem(int userId,int itemId)throws SQLException;
 List<Row> call(String procedure,Object... parameters)throws SQLException;
 List<Row> query(String sql,Object... parameters)throws SQLException;
}
