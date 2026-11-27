package implementor;
import db_config.GetConnection;import operations.AnalyticsMaintenanceOperations;
import java.sql.*;import java.util.*;import java.math.BigDecimal;
/** Maintains SRS sales_trend_result without fabricating missing cost data or ML predictions. */
public final class AnalyticsMaintenanceImplementor implements AnalyticsMaintenanceOperations {
 public int refreshSalesCache(int actor)throws SQLException{
  try(Connection c=GetConnection.getConnection()){
   c.setAutoCommit(false);
   try{
    try(PreparedStatement p=c.prepareStatement("SELECT 1 FROM users WHERE user_id=? AND role='ADMIN' AND status='ACTIVE'")){
     p.setInt(1,actor);try(ResultSet r=p.executeQuery()){if(!r.next())throw new SecurityException("Only Admin can refresh the system-wide analytics cache");}
    }
    final String query="SELECT DATE_FORMAT(st.sale_date,'%Y-%m-01') AS period_month,s.origin_port_id,s.dest_port_id,SUM(st.total_amount) AS total_sales,SUM(st.quantity) AS total_qty FROM sales_transactions st JOIN shipment s ON s.shipment_id=st.shipment_id WHERE s.status<>'CANCELLED' GROUP BY DATE_FORMAT(st.sale_date,'%Y-%m-01'),s.origin_port_id,s.dest_port_id ORDER BY s.origin_port_id,s.dest_port_id,period_month";
    class SalesRow {java.sql.Date month;int origin,dest,qty;BigDecimal total;}
    List<SalesRow> rows=new ArrayList<>();
    try(PreparedStatement s=c.prepareStatement(query);ResultSet r=s.executeQuery()){
     while(r.next()){SalesRow row=new SalesRow();row.month=java.sql.Date.valueOf(r.getString("period_month"));row.origin=r.getInt("origin_port_id");row.dest=r.getInt("dest_port_id");row.total=r.getBigDecimal("total_sales");row.qty=r.getInt("total_qty");rows.add(row);}
    }
    try(PreparedStatement clear=c.prepareStatement("DELETE FROM sales_trend_result")){clear.executeUpdate();}
    String insert="INSERT INTO sales_trend_result(period_month,origin_port_id,dest_port_id,total_sales,total_qty,growth_pct) VALUES(?,?,?,?,?,?)";
    Map<String,SalesRow> previous=new HashMap<>();
    try(PreparedStatement p=c.prepareStatement(insert)){
     for(SalesRow row:rows){String route=row.origin+":"+row.dest;SalesRow prev=previous.get(route);
      BigDecimal growth=BigDecimal.ZERO;
      if(prev!=null&&prev.total!=null&&prev.total.signum()>0&&prev.month.toLocalDate().plusMonths(1).equals(row.month.toLocalDate()))
       growth=row.total.subtract(prev.total).multiply(BigDecimal.valueOf(100)).divide(prev.total,2,java.math.RoundingMode.HALF_UP);
      p.setDate(1,row.month);p.setInt(2,row.origin);p.setInt(3,row.dest);p.setBigDecimal(4,row.total);p.setInt(5,row.qty);p.setBigDecimal(6,growth);p.addBatch();previous.put(route,row);
     }p.executeBatch();
    }
    c.commit();return rows.size();
   }catch(SQLException|RuntimeException e){c.rollback();throw e;}finally{c.setAutoCommit(true);}
  }
 }
 public int generateBaselineForecast(int actor,int origin,int dest,String type,java.time.LocalDate month)throws SQLException {
  if(origin<=0||dest<=0||origin==dest||month==null||month.getDayOfMonth()!=1||month.isBefore(java.time.LocalDate.now().withDayOfMonth(1))||!java.util.Arrays.asList("DRY","REEFER","OPEN_TOP","TANK").contains(type))throw new IllegalArgumentException("Invalid future month, route or container type");
  try(Connection c=GetConnection.getConnection()){
   c.setAutoCommit(false);
   try{
    try(PreparedStatement p=c.prepareStatement("SELECT 1 FROM users WHERE user_id=? AND role='ADMIN' AND status='ACTIVE'")){
     p.setInt(1,actor);try(ResultSet rs=p.executeQuery()){if(!rs.next())throw new SecurityException("Only Admin can generate shared forecasts");}
    }
    // This is a transparent six-month demand baseline, not an ML output.
    int history;
    try(PreparedStatement p=c.prepareStatement("SELECT COUNT(*) FROM shipment sh JOIN containers co ON co.container_id=sh.container_id WHERE sh.origin_port_id=? AND sh.dest_port_id=? AND co.container_type=? AND sh.status<>'CANCELLED' AND sh.etd>=? AND sh.etd<?")){
     p.setInt(1,origin);p.setInt(2,dest);p.setString(3,type);p.setDate(4,java.sql.Date.valueOf(month.minusMonths(6)));p.setDate(5,java.sql.Date.valueOf(month));
     try(ResultSet rs=p.executeQuery()){rs.next();history=rs.getInt(1);}
    }
    if(history<=0)throw new IllegalArgumentException("No dated shipment history in the six months before this month; cannot infer demand");
    int predicted=Math.max(1,(int)Math.round(history/6.0));
    int capacity;
    try(PreparedStatement p=c.prepareStatement("SELECT COUNT(*) FROM containers WHERE current_port_id=? AND container_type=? AND status='AVAILABLE'")){
     p.setInt(1,origin);p.setString(2,type);try(ResultSet rs=p.executeQuery()){rs.next();capacity=rs.getInt(1);}
    }
    double pressure=(double)(predicted-capacity)/Math.max(1,capacity);
    java.math.BigDecimal multiplier=java.math.BigDecimal.valueOf(Math.max(.75,Math.min(1.5,1.0+.10*pressure))).setScale(2,java.math.RoundingMode.HALF_UP);
    Integer found=null;
    try(PreparedStatement p=c.prepareStatement("SELECT forecast_id FROM demand_forecast WHERE origin_port_id=? AND dest_port_id=? AND container_type=? AND forecast_month=? ORDER BY forecast_id DESC LIMIT 1 FOR UPDATE")){
     p.setInt(1,origin);p.setInt(2,dest);p.setString(3,type);p.setDate(4,java.sql.Date.valueOf(month));try(ResultSet r=p.executeQuery()){if(r.next())found=r.getInt(1);}
    }
    int id;
    if(found!=null){
     try(PreparedStatement p=c.prepareStatement("UPDATE demand_forecast SET predicted_bookings=?,confidence_pct=NULL,suggested_multiplier=? WHERE forecast_id=?")){
      p.setInt(1,predicted);p.setBigDecimal(2,multiplier);p.setInt(3,found);p.executeUpdate();id=found;
     }
    }else{
     try(PreparedStatement p=c.prepareStatement("INSERT INTO demand_forecast(origin_port_id,dest_port_id,container_type,forecast_month,predicted_bookings,confidence_pct,suggested_multiplier) VALUES(?,?,?,?,?,NULL,?)",Statement.RETURN_GENERATED_KEYS)){
      p.setInt(1,origin);p.setInt(2,dest);p.setString(3,type);p.setDate(4,java.sql.Date.valueOf(month));p.setInt(5,predicted);p.setBigDecimal(6,multiplier);p.executeUpdate();
      try(ResultSet rs=p.getGeneratedKeys()){if(!rs.next())throw new SQLException("Forecast ID unavailable");id=rs.getInt(1);}
     }
    }
    c.commit();return id;
   }catch(SQLException|RuntimeException e){c.rollback();throw e;}finally{c.setAutoCommit(true);}
  }
 }
 public Set<Integer> shipmentIdsForRoute(int company, Integer origin, Integer dest) throws SQLException {
  Set<Integer> ids = new HashSet<>();
  String sql = "SELECT shipment_id FROM shipment WHERE (? IS NULL OR seller_id=?) "
      + "AND (? IS NULL OR origin_port_id=?) AND (? IS NULL OR dest_port_id=?)";
  try (Connection c = GetConnection.getConnection(); PreparedStatement stmt = c.prepareStatement(sql)) {
   // company is a required primitive int; it cannot be null. Bind it directly.
   stmt.setInt(1, company);
   stmt.setInt(2, company);
   bindOptionalFilter(stmt, 3, origin);
   bindOptionalFilter(stmt, 5, dest);
   try (ResultSet rs = stmt.executeQuery()) {
    while (rs.next()) ids.add(rs.getInt(1));
   }
  }
  return ids;
 }

 private static void bindOptionalFilter(PreparedStatement stmt, int startIndex, Integer value) throws SQLException {
  if (value == null) {
   stmt.setNull(startIndex, Types.INTEGER);
   stmt.setNull(startIndex + 1, Types.INTEGER);
  } else {
   stmt.setInt(startIndex, value);
   stmt.setInt(startIndex + 1, value);
  }
 }
}
