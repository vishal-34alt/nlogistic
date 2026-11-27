package implementor;
import db_config.GetConnection;
import operations.StockOperations;
import model.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;
/** Every DB request is bound and seller-scoped. Names match n_logistic_db unchanged. */
public final class StockImplementor implements StockOperations {
 private static void auth(Connection c,int actor,int company)throws SQLException {
  try(PreparedStatement p=c.prepareStatement("SELECT 1 FROM users WHERE user_id=? AND company_id=? AND role='SELLER' AND status='ACTIVE'")) {
   p.setInt(1,actor);p.setInt(2,company);try(ResultSet rs=p.executeQuery()){if(!rs.next())throw new SQLException("Active Seller access required","28000");}
  }
 }
 private static void ownProduct(Connection c,int id,int company)throws SQLException {
  try(PreparedStatement p=c.prepareStatement("SELECT 1 FROM products WHERE product_id=? AND owner_company_id=?")) {
   p.setInt(1,id);p.setInt(2,company);try(ResultSet rs=p.executeQuery()){if(!rs.next())throw new SQLException("Product not found for this Seller","28000");}
  }
 }
 private static void ownStock(Connection c,int id,int company)throws SQLException {
  try(PreparedStatement p=c.prepareStatement("SELECT 1 FROM stock s JOIN products p ON p.product_id=s.product_id WHERE s.stock_id=? AND p.owner_company_id=?")) {
   p.setInt(1,id);p.setInt(2,company);try(ResultSet rs=p.executeQuery()){if(!rs.next())throw new SQLException("Stock record unavailable for this Seller","28000");}
  }
 }
 private static Product mapProduct(ResultSet r)throws SQLException {
  Product p=new Product();p.setProductId(r.getInt("product_id"));p.setSku(r.getString("sku"));p.setProductName(r.getString("product_name"));p.setCategory(r.getString("category"));p.setHsCode(r.getString("hs_code"));p.setUnit(r.getString("unit"));p.setUnitWeightKg(r.getBigDecimal("unit_weight_kg"));p.setUnitPrice(r.getBigDecimal("unit_price"));p.setOwnerCompanyId(r.getInt("owner_company_id"));return p;
 }
 private static BigDecimal bd(ResultSet r,String col)throws SQLException{BigDecimal v=r.getBigDecimal(col);return v==null?BigDecimal.ZERO:v;}
 private static Stock mapStock(ResultSet r)throws SQLException {
  Stock s=new Stock();s.setStockId(r.getInt("stock_id"));s.setProductId(r.getInt("product_id"));s.setOwnerCompanyId(r.getInt("owner_company_id"));
  s.setSku(r.getString("sku"));s.setProductName(r.getString("product_name"));
  int sh=r.getInt("shipment_id");s.setShipmentId(r.wasNull()?null:sh);int ct=r.getInt("container_id");s.setContainerId(r.wasNull()?null:ct);
  s.setShipmentNo(r.getString("shipment_no"));s.setContainerNumber(r.getString("container_number"));s.setQuantity(bd(r,"quantity"));s.setDamagedQty(bd(r,"damaged_qty"));s.setAvailableQty(bd(r,"usable_qty"));
  s.setReservedQty((s.getShipmentId()!=null||s.getContainerId()!=null)?s.getQuantity():BigDecimal.ZERO);s.setLastUpdated(r.getTimestamp("last_updated"));return s;
 }

 /** Serialize Seller product writes and reject duplicate SKUs/details before calling existing procedures. */
 private static void lockSellerProductWrites(Connection c,int company)throws SQLException {
  try(PreparedStatement stmt=c.prepareStatement("SELECT company_id FROM companies WHERE company_id=? FOR UPDATE")){
   stmt.setInt(1,company);try(ResultSet rs=stmt.executeQuery()){
    if(!rs.next())throw new SQLException("Seller company was not found","45000");
   }
  }
 }
 private static void ensureDistinctProduct(Connection c,Product product,int company,int exceptId)throws SQLException {
  String query="SELECT product_id,sku FROM products WHERE owner_company_id=? AND product_id<>? AND "
   +"(LOWER(TRIM(sku))=LOWER(TRIM(?)) OR "
   +"(LOWER(TRIM(product_name))=LOWER(TRIM(?)) AND LOWER(TRIM(COALESCE(category,'')))=LOWER(TRIM(?)) "
   +"AND LOWER(TRIM(COALESCE(hs_code,'')))=LOWER(TRIM(?)) AND LOWER(TRIM(COALESCE(unit,'')))=LOWER(TRIM(?)) "
   +"AND unit_weight_kg=? AND unit_price=?)) ORDER BY product_id LIMIT 1";
  try(PreparedStatement stmt=c.prepareStatement(query)){
   stmt.setInt(1,company);stmt.setInt(2,exceptId);
   stmt.setString(3,product.getSku());stmt.setString(4,product.getProductName());
   stmt.setString(5,product.getCategory());stmt.setString(6,product.getHsCode());stmt.setString(7,product.getUnit());
   stmt.setBigDecimal(8,product.getUnitWeightKg());stmt.setBigDecimal(9,product.getUnitPrice());
   try(ResultSet rs=stmt.executeQuery()){
    if(rs.next())throw new SQLException("This Seller already has the same SKU or identical product details (existing SKU: "
     +rs.getString("sku")+"). Use Add stock to increase its quantity.","45000");
   }
  }
 }
 @Override public List<Product> products(int actor,int company)throws SQLException {
  List<Product> out=new ArrayList<>();try(Connection c=GetConnection.getConnection()) {auth(c,actor,company);
   try(PreparedStatement p=c.prepareStatement("SELECT product_id,sku,product_name,category,hs_code,unit,unit_weight_kg,unit_price,owner_company_id FROM products WHERE owner_company_id=? ORDER BY product_id DESC")){
    p.setInt(1,company);try(ResultSet r=p.executeQuery()){while(r.next())out.add(mapProduct(r));}
   }
  }return out;
 }
 @Override public Product product(int id,int actor,int company)throws SQLException {
  try(Connection c=GetConnection.getConnection()){auth(c,actor,company);try(PreparedStatement p=c.prepareStatement("SELECT product_id,sku,product_name,category,hs_code,unit,unit_weight_kg,unit_price,owner_company_id FROM products WHERE product_id=? AND owner_company_id=?")){
   p.setInt(1,id);p.setInt(2,company);try(ResultSet r=p.executeQuery()){return r.next()?mapProduct(r):null;}
  }}
 }
 @Override public void createProduct(Product p,int actor,int company)throws SQLException {
  try(Connection c=GetConnection.getConnection()){
   auth(c,actor,company);c.setAutoCommit(false);
   try{
    lockSellerProductWrites(c,company);
    ensureDistinctProduct(c,p,company,0);
    try(CallableStatement s=c.prepareCall("{CALL sp_insert_product(?,?,?,?,?,?,?,?)}")){
     s.setString(1,p.getSku().trim());s.setString(2,p.getProductName().trim());
     s.setString(3,p.getCategory().trim());s.setString(4,p.getHsCode().trim());s.setString(5,p.getUnit().trim());
     s.setBigDecimal(6,p.getUnitWeightKg());s.setBigDecimal(7,p.getUnitPrice());s.setInt(8,company);s.execute();
     while(s.getMoreResults()||s.getUpdateCount()!=-1){}
    }
    c.commit();
   }catch(SQLException ex){c.rollback();throw ex;}finally{c.setAutoCommit(true);}
  }
 }
 @Override public void updateProduct(Product p,int actor,int company)throws SQLException {
  try(Connection c=GetConnection.getConnection()){auth(c,actor,company);ownProduct(c,p.getProductId(),company);
   c.setAutoCommit(false);
   try {
    lockSellerProductWrites(c,company);
    ensureDistinctProduct(c,p,company,p.getProductId());
    String[] fields={"sku","product_name","category","hs_code","unit","unit_weight_kg","unit_price"};
    String[] values={p.getSku().trim(),p.getProductName().trim(),p.getCategory().trim(),p.getHsCode().trim(),p.getUnit().trim(),p.getUnitWeightKg().toPlainString(),p.getUnitPrice().toPlainString()};
    for(int i=0;i<fields.length;i++)try(CallableStatement s=c.prepareCall("{CALL sp_update_product_field(?,?,?,?)}")){
     s.setInt(1,actor);s.setInt(2,p.getProductId());s.setString(3,fields[i]);s.setString(4,values[i]);s.execute();
     while(s.getMoreResults()||s.getUpdateCount()!=-1){}
    }c.commit();
   }catch(SQLException ex){c.rollback();throw ex;}finally{c.setAutoCommit(true);}
  }
 }
 @Override public void deleteProduct(int id,int actor,int company)throws SQLException {
  try(Connection c=GetConnection.getConnection()){auth(c,actor,company);ownProduct(c,id,company);try(CallableStatement s=c.prepareCall("{CALL sp_delete_product(?)}")){s.setInt(1,id);s.execute();}}
 }
 @Override public List<Stock> stock(String keyword,Integer shipment,int actor,int company)throws SQLException {
  String sql="SELECT s.stock_id,p.product_id,p.sku,p.product_name,p.owner_company_id,s.shipment_id,sh.shipment_no,s.container_id,c.container_number,s.quantity,s.damaged_qty,s.quantity-s.damaged_qty AS usable_qty,s.last_updated "
   +"FROM stock s JOIN products p ON p.product_id=s.product_id LEFT JOIN shipment sh ON sh.shipment_id=s.shipment_id LEFT JOIN containers c ON c.container_id=s.container_id "
   +"WHERE p.owner_company_id=? AND (? IS NULL OR p.sku LIKE CONCAT('%',?,'%') OR p.product_name LIKE CONCAT('%',?,'%')) AND (? IS NULL OR s.shipment_id=?) "
   +"AND (s.quantity>0 OR NOT EXISTS (SELECT 1 FROM audit_log a WHERE a.table_name='stock' AND a.record_id=s.stock_id AND a.action='DELETE')) "
   +"ORDER BY s.stock_id DESC";
  List<Stock> out=new ArrayList<>();try(Connection c=GetConnection.getConnection()){auth(c,actor,company);try(PreparedStatement p=c.prepareStatement(sql)){
   p.setInt(1,company);if(keyword==null||keyword.trim().isEmpty()){p.setNull(2,Types.VARCHAR);p.setNull(3,Types.VARCHAR);p.setNull(4,Types.VARCHAR);}else{p.setString(2,keyword.trim());p.setString(3,keyword.trim());p.setString(4,keyword.trim());}
   if(shipment==null){p.setNull(5,Types.INTEGER);p.setNull(6,Types.INTEGER);}else{p.setInt(5,shipment);p.setInt(6,shipment);}
   try(ResultSet r=p.executeQuery()){while(r.next())out.add(mapStock(r));}
  }}return out;
 }
 @Override public void addStock(int product,int quantity,int actor,int company)throws SQLException{
  try(Connection c=GetConnection.getConnection()){auth(c,actor,company);ownProduct(c,product,company);try(CallableStatement s=c.prepareCall("{CALL sp_insert_stock(?,?)}")){s.setInt(1,product);s.setInt(2,quantity);s.execute();}}
 }
 @Override public void updateStock(int stockId,String field,int value,int actor,int company)throws SQLException {
  try(Connection c=GetConnection.getConnection()){auth(c,actor,company);ownStock(c,stockId,company);try(CallableStatement s=c.prepareCall("{CALL sp_update_stock_field(?,?,?,?)}")){
   s.setInt(1,actor);s.setInt(2,stockId);s.setString(3,field);s.setString(4,Integer.toString(value));s.execute();
  }}
 }
 @Override public void deleteStock(int stockId,int actor,int company,String ip)throws SQLException {
  // Historical stock movements have FK references to stock_id. Preserve the row
  // and append-only ledger; remove general stock from the active catalogue.
  try(Connection c=GetConnection.getConnection()) {
   auth(c,actor,company);c.setAutoCommit(false);
   try {
    int product,quantity,damaged;Integer shipment,container;
    try(PreparedStatement ps=c.prepareStatement("SELECT s.product_id,s.quantity,s.damaged_qty,s.shipment_id,s.container_id "
      +"FROM stock s JOIN products p ON p.product_id=s.product_id WHERE s.stock_id=? AND p.owner_company_id=? FOR UPDATE")) {
     ps.setInt(1,stockId);ps.setInt(2,company);
     try(ResultSet rs=ps.executeQuery()){
      if(!rs.next())throw new SQLException("Stock not found for this Seller.","45000");
      product=rs.getInt("product_id");quantity=rs.getInt("quantity");damaged=rs.getInt("damaged_qty");
      int sh=rs.getInt("shipment_id");shipment=rs.wasNull()?null:sh;
      int co=rs.getInt("container_id");container=rs.wasNull()?null:co;
     }
    }
    if(shipment!=null||container!=null)
     throw new SQLException("Shipment-reserved stock cannot be deleted. Cancel or complete the shipment through its workflow.","45000");
    if(quantity==0 && damaged==0) {
     try(PreparedStatement ps=c.prepareStatement("SELECT 1 FROM audit_log WHERE table_name='stock' AND record_id=? AND action='DELETE' LIMIT 1")){
      ps.setInt(1,stockId);try(ResultSet rs=ps.executeQuery()){
       if(rs.next())throw new SQLException("This stock record was already removed.","45000");
      }
     }
    }
    // Existing triggers record the quantity/damage adjustment in the immutable ledger.
    // Zero-quantity rows are eligible too, without requiring a no-op UPDATE.
    if(quantity!=0 || damaged!=0) {
     try(PreparedStatement ps=c.prepareStatement("UPDATE stock SET quantity=0,damaged_qty=0 WHERE stock_id=?")){
      ps.setInt(1,stockId);
      if(ps.executeUpdate()!=1)throw new SQLException("Unable to remove the stock record.","45000");
     }
    }
    try(CallableStatement cs=c.prepareCall("{CALL sp_record_audit_action(?,?,?,?,?,?,?)}")){
     cs.setInt(1,actor);cs.setString(2,"DELETE");cs.setString(3,"stock");cs.setLong(4,stockId);
     cs.setString(5,"{\"product_id\":"+product+",\"quantity\":"+quantity+",\"damaged_qty\":"+damaged+"}");
     cs.setNull(6,Types.VARCHAR);cs.setString(7,ip);cs.execute();
    }
    c.commit();
   }catch(SQLException|RuntimeException ex){c.rollback();throw ex;}finally{c.setAutoCommit(true);}
  }
 }
 @Override public List<InventoryLedger> ledger(Integer product,String type,String reference,Long refId,int actor,int company)throws SQLException {
  String sql="SELECT l.ledger_id,l.stock_id,l.product_id,l.txn_type,l.quantity,l.balance_after,l.reference_type,l.reference_id,l.txn_time,p.sku,p.product_name "
   +"FROM inventory_ledger l JOIN products p ON p.product_id=l.product_id WHERE p.owner_company_id=? AND (? IS NULL OR l.product_id=?) AND (? IS NULL OR l.txn_type=?) "
   +"AND (? IS NULL OR l.reference_type=?) AND (? IS NULL OR l.reference_id=?) ORDER BY l.ledger_id DESC LIMIT 1000";
  List<InventoryLedger> out=new ArrayList<>();try(Connection c=GetConnection.getConnection()){auth(c,actor,company);try(PreparedStatement p=c.prepareStatement(sql)){
   p.setInt(1,company);nullableInt(p,2,product);nullableInt(p,3,product);nullableStr(p,4,type);nullableStr(p,5,type);nullableStr(p,6,reference);nullableStr(p,7,reference);nullableLong(p,8,refId);nullableLong(p,9,refId);
   try(ResultSet r=p.executeQuery()){while(r.next()){
    InventoryLedger x=new InventoryLedger();x.setLedgerId(r.getLong("ledger_id"));x.setStockId(r.getInt("stock_id"));x.setProductId(r.getInt("product_id"));x.setTxnType(r.getString("txn_type"));x.setQuantity(bd(r,"quantity"));x.setBalanceAfter(bd(r,"balance_after"));x.setReferenceType(r.getString("reference_type"));
    long id=r.getLong("reference_id");x.setReferenceId(r.wasNull()?null:id);x.setTxnTime(r.getTimestamp("txn_time"));x.setSku(r.getString("sku"));x.setProductName(r.getString("product_name"));out.add(x);
   }}
  }}return out;
 }
 private static void nullableInt(PreparedStatement p,int i,Integer n)throws SQLException{if(n==null)p.setNull(i,Types.INTEGER);else p.setInt(i,n);}
 private static void nullableLong(PreparedStatement p,int i,Long n)throws SQLException{if(n==null)p.setNull(i,Types.BIGINT);else p.setLong(i,n);}
 private static void nullableStr(PreparedStatement p,int i,String n)throws SQLException{if(n==null||n.trim().isEmpty())p.setNull(i,Types.VARCHAR);else p.setString(i,n.trim());}
 @Override public StockSummary shipmentSummary(int shipment,int actor,int company)throws SQLException {
  String sql="SELECT p.sku,p.product_name,s.quantity,p.unit_price,(s.quantity*p.unit_price) AS stock_value FROM stock s JOIN products p ON p.product_id=s.product_id JOIN shipment sh ON sh.shipment_id=s.shipment_id WHERE sh.shipment_id=? AND sh.seller_id=? ORDER BY s.stock_id";
  StockSummary out=new StockSummary();out.setShipmentId(shipment);BigDecimal qty=BigDecimal.ZERO,value=BigDecimal.ZERO;
  try(Connection c=GetConnection.getConnection()){auth(c,actor,company);try(PreparedStatement p=c.prepareStatement(sql)){
   p.setInt(1,shipment);p.setInt(2,company);try(ResultSet r=p.executeQuery()){List<StockSummary.Line> lines=new ArrayList<>();while(r.next()){
    StockSummary.Line line=new StockSummary.Line();line.setSku(r.getString("sku"));line.setProductName(r.getString("product_name"));line.setQuantity(bd(r,"quantity"));line.setUnitPrice(bd(r,"unit_price"));line.setStockValue(bd(r,"stock_value"));lines.add(line);qty=qty.add(line.getQuantity());value=value.add(line.getStockValue());
   }out.setLines(lines);out.setTotalQuantity(qty);out.setTotalValue(value);}
  }}return out;
 }

 /** Discover only shipments authorized for the signed-in actor. No extra DB objects. */
 @Override public List<model.Row> authorizedShipmentChoices(int actor)throws SQLException{
  if(actor<=0)throw new SecurityException("Sign in required");
  String sql="SELECT sh.shipment_id,sh.shipment_no,sh.status FROM shipment sh " +
   "JOIN users u ON u.user_id=? AND u.status='ACTIVE' " +
   "LEFT JOIN customers cu ON cu.user_id=u.user_id " +
   "WHERE u.role='ADMIN' OR (u.role='SELLER' AND u.company_id=sh.seller_id) " +
   "OR (u.role='CONSUMER' AND cu.customer_id=sh.consumer_id) " +
   "ORDER BY sh.shipment_id DESC LIMIT 200";
  List<model.Row> out=new ArrayList<>();
  try(Connection c=GetConnection.getConnection();PreparedStatement p=c.prepareStatement(sql)){
   p.setInt(1,actor);
   try(ResultSet r=p.executeQuery()){
    while(r.next()){model.Row row=new model.Row();row.put("shipment_id",r.getInt("shipment_id"));
     row.put("shipment_no",r.getString("shipment_no"));row.put("status",r.getString("status"));out.add(row);}
   }
  }
  return out;
 }
 /** Read-only shipment quantities/values. Consumers only see their own shipments. */
 @Override public StockSummary authorizedShipmentSummary(int shipment,int actor)throws SQLException {
  if(actor<=0||shipment<=0)throw new IllegalArgumentException("Valid actor and shipment required");
  String sql="SELECT p.sku,p.product_name,si.quantity,si.unit_price,si.amount AS stock_value FROM shipment_items si JOIN products p ON p.product_id=si.product_id JOIN shipment sh ON sh.shipment_id=si.shipment_id JOIN users u ON u.user_id=? AND u.status='ACTIVE' LEFT JOIN customers cu ON cu.user_id=u.user_id WHERE sh.shipment_id=? AND (u.role='ADMIN' OR (u.role='SELLER' AND u.company_id=sh.seller_id) OR (u.role='CONSUMER' AND cu.customer_id=sh.consumer_id)) ORDER BY si.item_id";
  StockSummary summary=new StockSummary();summary.setShipmentId(shipment);BigDecimal qty=BigDecimal.ZERO,value=BigDecimal.ZERO;List<StockSummary.Line> lines=new ArrayList<>();
  try(Connection c=GetConnection.getConnection()){
   try(PreparedStatement auth=c.prepareStatement("SELECT 1 FROM shipment sh JOIN users u ON u.user_id=? AND u.status='ACTIVE' LEFT JOIN customers cu ON cu.user_id=u.user_id WHERE sh.shipment_id=? AND (u.role='ADMIN' OR (u.role='SELLER' AND u.company_id=sh.seller_id) OR (u.role='CONSUMER' AND cu.customer_id=sh.consumer_id))")){
    auth.setInt(1,actor);auth.setInt(2,shipment);try(ResultSet rs=auth.executeQuery()){if(!rs.next())throw new SecurityException("Shipment not accessible");}
   }
   try(PreparedStatement p=c.prepareStatement(sql)){
    p.setInt(1,actor);p.setInt(2,shipment);try(ResultSet r=p.executeQuery()){
     while(r.next()){StockSummary.Line line=new StockSummary.Line();line.setSku(r.getString("sku"));line.setProductName(r.getString("product_name"));line.setQuantity(bd(r,"quantity"));line.setUnitPrice(bd(r,"unit_price"));line.setStockValue(bd(r,"stock_value"));lines.add(line);qty=qty.add(line.getQuantity());value=value.add(line.getStockValue());}
    }
   }
  }
  summary.setLines(lines);summary.setTotalQuantity(qty);summary.setTotalValue(value);return summary;
 }
 /** Sale history restricted to the signed-in seller company. Read-only audit context. */
 @Override public List<model.Row> salesTransactions(int actor,int company,String query)throws SQLException{
  if(company<=0)throw new SecurityException("Seller company required");
  String q=query==null?"":query.trim();List<model.Row> rows=new ArrayList<>();
  String sql="SELECT st.sale_id,st.sale_date,p.sku,p.product_name,sh.shipment_no,sh.status AS shipment_status,st.quantity,st.unit_price,st.total_amount FROM sales_transactions st JOIN products p ON p.product_id=st.product_id JOIN shipment sh ON sh.shipment_id=st.shipment_id WHERE sh.seller_id=? AND p.owner_company_id=? AND (?='' OR sh.shipment_no LIKE ? OR p.sku LIKE ? OR p.product_name LIKE ?) ORDER BY st.sale_date DESC,st.sale_id DESC LIMIT 500";
  try(Connection c=GetConnection.getConnection()){auth(c,actor,company);try(PreparedStatement p=c.prepareStatement(sql)){
   p.setInt(1,company);p.setInt(2,company);p.setString(3,q);for(int i=4;i<=6;i++)p.setString(i,"%"+q+"%");
   try(ResultSet r=p.executeQuery()){while(r.next()){model.Row row=new model.Row();for(String col:new String[]{"sale_id","sale_date","sku","product_name","shipment_no","shipment_status","quantity","unit_price","total_amount"})row.put(col,r.getObject(col));rows.add(row);}}
  }}return rows;
 }
}