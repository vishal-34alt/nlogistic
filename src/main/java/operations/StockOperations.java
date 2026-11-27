package operations;
import java.sql.SQLException;import java.util.List;
import model.Product;import model.Stock;import model.InventoryLedger;import model.StockSummary;
public interface StockOperations {
 List<Product> products(int actor,int company) throws SQLException;
 Product product(int id,int actor,int company) throws SQLException;
 void createProduct(Product p,int actor,int company) throws SQLException;
 void updateProduct(Product p,int actor,int company) throws SQLException;
 void deleteProduct(int id,int actor,int company) throws SQLException;
 List<Stock> stock(String keyword,Integer shipment,int actor,int company) throws SQLException;
 void addStock(int product,int quantity,int actor,int company) throws SQLException;
 void updateStock(int stockId,String field,int value,int actor,int company) throws SQLException;
 void deleteStock(int stockId,int actor,int company,String ip) throws SQLException;
 List<InventoryLedger> ledger(Integer product,String type,String reference,Long refId,int actor,int company) throws SQLException;
 StockSummary shipmentSummary(int shipment,int actor,int company) throws SQLException;
 StockSummary authorizedShipmentSummary(int shipment,int actor)throws SQLException;
 java.util.List<model.Row> authorizedShipmentChoices(int actor)throws SQLException;
 List<model.Row> salesTransactions(int actor,int company,String query)throws SQLException;
}
