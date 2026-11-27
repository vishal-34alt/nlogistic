package model;
import java.sql.SQLException;import java.util.List;import operations.StockOperations;import implementor.StockImplementor;
/** Module 4 model: validation and business rules. No JDBC or SQL in model. */
public final class StockActions {
 private final StockOperations db;
 public StockActions(){this(new StockImplementor());}
 public StockActions(StockOperations operations){db=operations;}
 private void identity(int actor,int company){if(actor<=0||company<=0)throw new SecurityException("Seller identity required");}
 private void productValidation(Product p){
  if(p==null||empty(p.getSku())||empty(p.getProductName())||empty(p.getCategory())||empty(p.getHsCode())||empty(p.getUnit())||p.getUnitWeightKg()==null||p.getUnitPrice()==null)
   throw new IllegalArgumentException("All seven product fields are required");
  if(!p.getHsCode().trim().matches("[0-9]{6}([0-9]{2}){0,3}"))
   throw new IllegalArgumentException("HS code must contain 6, 8, 10 or 12 digits");
  if(p.getUnitWeightKg().signum()<=0||p.getUnitWeightKg().scale()>3||p.getUnitPrice().signum()<0||p.getUnitPrice().scale()>2)
   throw new IllegalArgumentException("Enter a positive weight (up to 3 decimal places) and a nonnegative price (up to 2 decimal places)");
  if(p.getSku().length()>40||p.getProductName().length()>120||len(p.getCategory())>60||len(p.getHsCode())>12||len(p.getUnit())>10)
   throw new IllegalArgumentException("Product text is too long");
 }
 private boolean empty(String s){return s==null||s.trim().isEmpty();} private int len(String s){return s==null?0:s.length();}
 public List<Product> products(int actor,int company)throws SQLException{identity(actor,company);return db.products(actor,company);}
 public Product product(int id,int actor,int company)throws SQLException{identity(actor,company);return db.product(id,actor,company);}
 public void createProduct(Product p,int actor,int company)throws SQLException{identity(actor,company);productValidation(p);p.setOwnerCompanyId(company);db.createProduct(p,actor,company);}
 public void updateProduct(Product p,int actor,int company)throws SQLException{identity(actor,company);productValidation(p);db.updateProduct(p,actor,company);}
 public void deleteProduct(int id,int actor,int company)throws SQLException{identity(actor,company);db.deleteProduct(id,actor,company);}
 public List<Stock> stock(String q,Integer shipment,int actor,int company)throws SQLException{identity(actor,company);return db.stock(q,shipment,actor,company);}
 public void addStock(int product,int qty,int actor,int company)throws SQLException{identity(actor,company);if(product<=0||qty<=0)throw new IllegalArgumentException("Product and positive quantity required");db.addStock(product,qty,actor,company);}
 public void updateStock(int id,String field,int value,int actor,int company)throws SQLException{identity(actor,company);if(id<=0||value<0||!("quantity".equals(field)||"damaged_qty".equals(field)))throw new IllegalArgumentException("Invalid stock adjustment");db.updateStock(id,field,value,actor,company);}
 public void deleteStock(int id,int actor,int company,String ip)throws SQLException{identity(actor,company);db.deleteStock(id,actor,company,ip);}
 public List<InventoryLedger> ledger(Integer product,String type,String reference,Long refId,int actor,int company)throws SQLException{identity(actor,company);return db.ledger(product,type,reference,refId,actor,company);}
 public java.util.List<model.Row> authorizedShipmentChoices(int actor)throws SQLException{
   if(actor<=0)throw new SecurityException("Sign in required");
   return db.authorizedShipmentChoices(actor);
 }
 public StockSummary authorizedSummary(int shipment,int actor)throws SQLException{
   if(shipment<=0||actor<=0)throw new IllegalArgumentException("Valid shipment required");
   return db.authorizedShipmentSummary(shipment,actor);
 }
 public List<model.Row> salesTransactions(int actor,int company,String query)throws SQLException{
   identity(actor,company);return db.salesTransactions(actor,company,query);
 }
 public StockSummary summary(int shipment,int actor,int company)throws SQLException{identity(actor,company);if(shipment<=0)throw new IllegalArgumentException("Valid shipment ID required");return db.shipmentSummary(shipment,actor,company);}
}
