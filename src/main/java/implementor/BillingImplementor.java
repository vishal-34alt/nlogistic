package implementor;
import operations.BillingOperations;import model.Row;import db_config.GetConnection;import java.sql.*;import java.util.*;
public class BillingImplementor implements BillingOperations {
 @Override public List<Row> findActiveUser(int userId)throws SQLException {
   return query("SELECT role, full_name, company_id FROM users WHERE user_id = ? AND status = 'ACTIVE'",userId);
 }
 @Override public List<Row> unbilledSellerShipments(int sellerCompanyId)throws SQLException {
   return query("SELECT s.shipment_id, s.shipment_no, s.quoted_price FROM shipment s "
         +"LEFT JOIN billing_invoices i ON i.shipment_id=s.shipment_id "
         +"WHERE s.seller_id=? AND s.status <> 'CANCELLED' AND i.invoice_id IS NULL",sellerCompanyId);
 }

 /** A payment must redirect only to the Consumer's own shipment.
  * No controller/JSP SQL, and no submitted shipment ID is trusted. */
 @Override public Integer shipmentIdForInvoice(int consumerUserId,int invoiceId)throws SQLException {
   if(consumerUserId<=0||invoiceId<=0)return null;
   String sql="SELECT i.shipment_id FROM billing_invoices i "
       +"JOIN customers c ON c.customer_id=i.consumer_id "
       +"JOIN users u ON u.user_id=c.user_id "
       +"WHERE i.invoice_id=? AND u.user_id=? AND u.role='CONSUMER' "
       +"AND u.status='ACTIVE' LIMIT 1";
   try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)) {
     ps.setInt(1,invoiceId);ps.setInt(2,consumerUserId);
     try(ResultSet rs=ps.executeQuery()){
       return rs.next()?Integer.valueOf(rs.getInt(1)):null;
     }
   }
 }

 /** Resolve a shipment's invoice only if the ACTIVE actor can access the shipment. */
 @Override public Integer invoiceIdForShipment(int userId,int shipmentId)throws SQLException {
   if(userId<=0||shipmentId<=0)return null;
   String sql="SELECT i.invoice_id FROM users u "
       +"JOIN shipment s ON s.shipment_id=? "
       +"JOIN billing_invoices i ON i.shipment_id=s.shipment_id "
       +"LEFT JOIN customers cu ON cu.user_id=u.user_id "
       +"WHERE u.user_id=? AND u.status='ACTIVE' AND "
       +"(u.role='ADMIN' OR (u.role='SELLER' AND u.company_id=s.seller_id) "
       +"OR (u.role='CONSUMER' AND cu.customer_id=s.consumer_id)) LIMIT 1";
   try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)) {
     ps.setInt(1,shipmentId);ps.setInt(2,userId);
     try(ResultSet rs=ps.executeQuery()){return rs.next()?Integer.valueOf(rs.getInt(1)):null;}
   }
 }

 /** Shipment status is separate from the invoice's approved UNPAID/PARTIAL/PAID enum. */
 @Override public Map<Integer,String> invoiceShipmentStatuses(int userId)throws SQLException {
   String sql="SELECT i.invoice_id,s.status AS shipment_status FROM billing_invoices i "
       +"JOIN shipment s ON s.shipment_id=i.shipment_id "
       +"JOIN users u ON u.user_id=? AND u.status='ACTIVE' "
       +"LEFT JOIN customers cu ON cu.user_id=u.user_id "
       +"WHERE u.role='ADMIN' OR (u.role='SELLER' AND u.company_id=i.seller_id) "
       +"OR (u.role='CONSUMER' AND cu.customer_id=i.consumer_id)";
   Map<Integer,String> states=new HashMap<>();
   try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
     ps.setInt(1,userId);
     try(ResultSet rs=ps.executeQuery()){
       while(rs.next())states.put(rs.getInt("invoice_id"),rs.getString("shipment_status"));
     }
   }
   return states;
 }
 @Override public String invoiceShipmentStatus(int userId,int invoiceId)throws SQLException {
   String sql="SELECT s.status FROM billing_invoices i "
       +"JOIN shipment s ON s.shipment_id=i.shipment_id "
       +"JOIN users u ON u.user_id=? AND u.status='ACTIVE' "
       +"LEFT JOIN customers cu ON cu.user_id=u.user_id "
       +"WHERE i.invoice_id=? AND (u.role='ADMIN' "
       +"OR (u.role='SELLER' AND u.company_id=i.seller_id) "
       +"OR (u.role='CONSUMER' AND cu.customer_id=i.consumer_id)) LIMIT 1";
   try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
     ps.setInt(1,userId);ps.setInt(2,invoiceId);
     try(ResultSet rs=ps.executeQuery()){return rs.next()?rs.getString(1):null;}
   }
 }
 /** Resolve an invoice note through an authorized Seller without exposing any SQL in Model. */
 @Override public Integer invoiceForLineItem(int userId,int itemId)throws SQLException {
   String sql="SELECT i.invoice_id FROM invoice_line_items li "
       +"JOIN billing_invoices i ON i.invoice_id=li.invoice_id "
       +"JOIN users u ON u.user_id=? AND u.status='ACTIVE' AND u.role='SELLER' "
       +"AND u.company_id=i.seller_id WHERE li.item_id=? LIMIT 1";
   try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
     ps.setInt(1,userId);ps.setInt(2,itemId);
     try(ResultSet rs=ps.executeQuery()){return rs.next()?Integer.valueOf(rs.getInt(1)):null;}
   }
 }
 @Override public void recordDeliveryArrangement(int userId,int invoiceId,String ipAddress)throws SQLException {
   if(userId<=0 || invoiceId<=0)throw new IllegalArgumentException("Choose a valid invoice");
   String check="SELECT i.status,i.due_date,i.total_amount,i.paid_amount FROM billing_invoices i "
       +"JOIN customers cu ON cu.customer_id=i.consumer_id "
       +"JOIN users u ON u.user_id=cu.user_id AND u.role='CONSUMER' AND u.status='ACTIVE' "
       +"WHERE i.invoice_id=? AND u.user_id=? FOR UPDATE";
   String recorded="SELECT 1 FROM audit_log WHERE user_id=? AND table_name='billing_invoices' "
       +"AND record_id=? AND action='PAY_ON_DELIVERY' LIMIT 1";
   String audit="INSERT INTO audit_log(user_id,action,table_name,record_id,old_value,new_value,ip_address) "
       +"VALUES (?,'PAY_ON_DELIVERY','billing_invoices',?,NULL, "
       +"JSON_OBJECT('choice','PAY_ON_DELIVERY','invoice_id',?,'recorded_at',NOW(),'invoice_due_date',?),?)";
   try(Connection c=GetConnection.getConnection()) {
     c.setAutoCommit(false);
     try {
       String due;
       try(PreparedStatement ps=c.prepareStatement(check)){
         ps.setInt(1,invoiceId);ps.setInt(2,userId);
         try(ResultSet rs=ps.executeQuery()){
           if(!rs.next())throw new SecurityException("Invoice not accessible to this Consumer");
           if("PAID".equals(rs.getString("status")))throw new IllegalArgumentException("This invoice is already paid");
           due=rs.getString("due_date");
         }
       }
       boolean exists;
       try(PreparedStatement ps=c.prepareStatement(recorded)){
         ps.setInt(1,userId);ps.setInt(2,invoiceId);
         try(ResultSet rs=ps.executeQuery()){exists=rs.next();}
       }
       if(!exists)try(PreparedStatement ps=c.prepareStatement(audit)){
         ps.setInt(1,userId);ps.setInt(2,invoiceId);ps.setInt(3,invoiceId);
         ps.setString(4,due);ps.setString(5,ipAddress==null?null:ipAddress.substring(0,Math.min(ipAddress.length(),45)));
         ps.executeUpdate();
       }
       c.commit();
     }catch(SQLException|RuntimeException ex){try{c.rollback();}catch(SQLException rollback){ex.addSuppressed(rollback);}throw ex;}
   }
 }
 @Override public boolean hasDeliveryArrangement(int userId,int invoiceId)throws SQLException {
   String sql="SELECT 1 FROM audit_log a JOIN billing_invoices i ON i.invoice_id=a.record_id "
       +"JOIN users u ON u.user_id=? AND u.status='ACTIVE' "
       +"LEFT JOIN customers cu ON cu.user_id=u.user_id "
       +"WHERE a.action='PAY_ON_DELIVERY' AND a.table_name='billing_invoices' "
       +"AND a.record_id=? AND (u.role='ADMIN' OR "
       +"(u.role='SELLER' AND u.company_id=i.seller_id) OR "
       +"(u.role='CONSUMER' AND cu.customer_id=i.consumer_id)) LIMIT 1";
   try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
     ps.setInt(1,userId);ps.setInt(2,invoiceId);
     try(ResultSet rs=ps.executeQuery()){return rs.next();}
   }
 }
 private List<Row> read(ResultSet rs)throws SQLException {List<Row> out=new ArrayList<>();ResultSetMetaData m=rs.getMetaData();while(rs.next()){Row r=new Row();for(int i=1;i<=m.getColumnCount();i++)r.put(m.getColumnLabel(i),rs.getObject(i));out.add(r);}return out;}
 private void bind(PreparedStatement s,Object[] a)throws SQLException{for(int i=0;i<a.length;i++)s.setObject(i+1,a[i]);}
 public List<Row> query(String sql,Object... a)throws SQLException{try(Connection c=GetConnection.getConnection();PreparedStatement s=c.prepareStatement(sql)){bind(s,a);try(ResultSet r=s.executeQuery()){return read(r);}}}
 public List<Row> call(String p,Object... a)throws SQLException{if(!p.matches("sp_[a-z_]+"))throw new IllegalArgumentException();String sql="{call "+p+"("+String.join(",",Collections.nCopies(a.length,"?"))+")}";try(Connection c=GetConnection.getConnection();CallableStatement s=c.prepareCall(sql)){bind(s,a);boolean b=s.execute();List<Row> first=null;while(true){if(b){try(ResultSet r=s.getResultSet()){List<Row> rows=read(r);if(first==null)first=rows;}}else if(s.getUpdateCount()==-1)break;b=s.getMoreResults();}return first==null?Collections.emptyList():first;}}
}
