package implementor;
import db_config.GetConnection;import operations.DirectoryOperations;
import java.sql.*;import java.util.*;
/** Read-only, parameterized directory access. Never trusts a client-supplied company. */
public final class DirectoryImplementor implements DirectoryOperations {
 private static void authorized(Connection c,int uid)throws SQLException{
  try(PreparedStatement s=c.prepareStatement("SELECT 1 FROM users WHERE user_id=? AND status='ACTIVE'")){
   s.setInt(1,uid);try(ResultSet r=s.executeQuery()){if(!r.next())throw new SecurityException("Active account required");}
  }
 }
 public List<Map<String,Object>> availableProducts(int uid)throws Exception{
  try(Connection c=GetConnection.getConnection()){
   authorized(c,uid);List<Map<String,Object>> rows=new ArrayList<>();
   String sql="SELECT p.product_id,p.sku,p.product_name,p.unit_weight_kg,c.company_name,"
   +"COALESCE(SUM(CASE WHEN st.shipment_id IS NULL THEN GREATEST(st.quantity-COALESCE(st.damaged_qty,0),0) ELSE 0 END),0) AS available_qty,"
   +"hv.suggested_unit_cbm,hv.samples FROM products p JOIN companies c ON c.company_id=p.owner_company_id "
   +"LEFT JOIN stock st ON st.product_id=p.product_id "
   +"LEFT JOIN (SELECT si.product_id,ROUND(SUM(si.volume_cbm)/NULLIF(SUM(si.quantity),0),3) AS suggested_unit_cbm,COUNT(*) samples "
   +"FROM shipment_items si JOIN shipment sh ON sh.shipment_id=si.shipment_id "
   +"WHERE si.quantity>0 AND si.volume_cbm>0 AND sh.status<>'CANCELLED' GROUP BY si.product_id) hv ON hv.product_id=p.product_id "
   +"GROUP BY p.product_id,p.sku,p.product_name,p.unit_weight_kg,c.company_name,hv.suggested_unit_cbm,hv.samples "
   +"HAVING available_qty>0 ORDER BY p.product_name";
   try(PreparedStatement s=c.prepareStatement(sql);ResultSet r=s.executeQuery()){
    while(r.next()){Map<String,Object> m=new LinkedHashMap<>();m.put("id",r.getInt("product_id"));m.put("label",r.getString("product_name")+" · "+r.getString("sku")+" · "+r.getString("company_name"));m.put("available",r.getInt("available_qty"));m.put("unitWeightKg",r.getBigDecimal("unit_weight_kg"));
      m.put("historicalUnitCbm",r.getBigDecimal("suggested_unit_cbm"));m.put("historySamples",r.getInt("samples"));rows.add(m);}
   }return rows;
  }
 }
 /** Candidate routes are a planning hint only. The booking procedures always recheck capacity and price. */
 /** Single authoritative set of read-only eligible booking lanes for both paged and legacy callers. */
 private static String routeQuery(){
  return "SELECT r.origin_port_id,r.dest_port_id,po.port_name AS origin_name,pd.port_name AS destination_name,"
   +"po.port_code AS origin_code,pd.port_code AS destination_code,"
   +"COUNT(DISTINCT co.container_id) AS available_containers,h.avg_days,h.samples,"
   +"COALESCE(t.active_shipments,0) AS active_shipments "
   +"FROM products pr JOIN companies owner ON owner.company_id=pr.owner_company_id "
   +"JOIN pricing_rules r ON r.seller_id=owner.company_id AND r.is_active=1 "
   +"AND (r.valid_from IS NULL OR r.valid_from<=?) AND (r.valid_to IS NULL OR r.valid_to>=?) "
   +"JOIN containers co ON co.seller_id=r.seller_id AND co.container_type=r.container_type "
   +"AND co.current_port_id=r.origin_port_id AND co.status='AVAILABLE' "
   +"JOIN ports po ON po.port_id=r.origin_port_id JOIN ports pd ON pd.port_id=r.dest_port_id "
   +"LEFT JOIN (SELECT seller_id,origin_port_id,dest_port_id,"
   +"ROUND(AVG(DATEDIFF(actual_arrival,etd))) AS avg_days,COUNT(*) samples FROM shipment "
   +"WHERE actual_arrival IS NOT NULL AND etd IS NOT NULL AND actual_arrival>=etd "
   +"AND status IN ('ARRIVED','CUSTOMS_CLEARED','DELIVERED') "
   +"GROUP BY seller_id,origin_port_id,dest_port_id) h "
   +"ON h.seller_id=r.seller_id AND h.origin_port_id=r.origin_port_id AND h.dest_port_id=r.dest_port_id "
   +"LEFT JOIN (SELECT seller_id,origin_port_id,dest_port_id,"
   +"SUM(CASE WHEN status NOT IN ('CANCELLED','DELIVERED') THEN 1 ELSE 0 END) AS active_shipments "
   +"FROM shipment GROUP BY seller_id,origin_port_id,dest_port_id) t "
   +"ON t.seller_id=r.seller_id AND t.origin_port_id=r.origin_port_id AND t.dest_port_id=r.dest_port_id "
   +"JOIN users u ON u.user_id=? AND u.status='ACTIVE' AND u.role='CONSUMER' "
   +"WHERE pr.product_id=? AND EXISTS (SELECT 1 FROM stock st WHERE st.product_id=pr.product_id "
   +"AND st.shipment_id IS NULL AND st.quantity>COALESCE(st.damaged_qty,0)) "
   +"GROUP BY r.origin_port_id,r.dest_port_id,po.port_name,pd.port_name,po.port_code,pd.port_code,h.avg_days,h.samples,t.active_shipments "
   ;
 }
 public List<Map<String,Object>> availableRoutes(int uid,int productId,java.sql.Date travelDate)throws Exception{
  if(productId<=0 || travelDate==null)throw new IllegalArgumentException("Select a product and booking date first");
  String sql=routeQuery()+" ORDER BY available_containers DESC,origin_name,destination_name";
  try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
   authorized(c,uid);ps.setDate(1,travelDate);ps.setDate(2,travelDate);ps.setInt(3,uid);ps.setInt(4,productId);
   List<Map<String,Object>> out=new ArrayList<>();try(ResultSet r=ps.executeQuery()){
    while(r.next()){
     Map<String,Object> row=new LinkedHashMap<>();
     row.put("originPortId",r.getInt("origin_port_id"));row.put("destPortId",r.getInt("dest_port_id"));
     row.put("origin",r.getString("origin_name")+" ("+r.getString("origin_code")+")");
     row.put("destination",r.getString("destination_name")+" ("+r.getString("destination_code")+")");
     row.put("availableContainers",r.getInt("available_containers"));
     row.put("activeShipments",r.getInt("active_shipments"));
     row.put("historicalTransitDays",r.getObject("avg_days"));row.put("historySamples",r.getInt("samples"));out.add(row);
    }
   }return out;
  }
 }
 /** Server-side search, sort and pagination; never returns an unbounded list to the browser. */
 public Map<String,Object> routePage(int uid,int productId,java.sql.Date travelDate,String search,String sort,int page,int size,boolean activeOnly,int originPortId,int destPortId)throws Exception{
  if(productId<=0||travelDate==null)throw new IllegalArgumentException("Choose goods and booking date first");
  int safeSize=(size==20||size==50)?size:10;
  int safePage=Math.max(1,Math.min(page,100000));
  String q=search==null?"":search.trim().toLowerCase(Locale.ROOT);
  if(q.length()>100)q=q.substring(0,100);
  // Escape LIKE wildcards so typed port names are treated literally.
  String like="%"+q.replace("!","!!").replace("%","!%").replace("_","!_")+"%";
  String ordering;
  if("shipments".equals(sort))ordering="lanes.active_shipments DESC,lanes.available_containers DESC,lanes.origin_name,lanes.destination_name";
  else if("alpha".equals(sort))ordering="lanes.origin_name,lanes.destination_name";
  else if("transit".equals(sort))ordering="CASE WHEN lanes.avg_days IS NULL THEN 1 ELSE 0 END,lanes.avg_days,lanes.available_containers DESC,lanes.origin_name";
  else ordering="lanes.available_containers DESC,lanes.origin_name,lanes.destination_name";
  String sql="SELECT lanes.*,COUNT(*) OVER() AS match_count FROM ("+routeQuery()+") lanes "
   +"WHERE (LOWER(CONCAT(lanes.origin_name,' ',lanes.origin_code,' ',lanes.destination_name,' ',lanes.destination_code)) LIKE ? ESCAPE '!') "
   +"AND (?=0 OR lanes.active_shipments>0) "
   +"AND (?=0 OR lanes.origin_port_id=?) AND (?=0 OR lanes.dest_port_id=?) "
   +"ORDER BY "+ordering+" LIMIT ? OFFSET ?";
  int offset=(safePage-1)*safeSize;
  List<Map<String,Object>> rows=new ArrayList<>();long total=0;
  try(Connection c=GetConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
   authorized(c,uid);
   ps.setDate(1,travelDate);ps.setDate(2,travelDate);ps.setInt(3,uid);ps.setInt(4,productId);
   ps.setString(5,like);ps.setInt(6,activeOnly?1:0);
   ps.setInt(7,originPortId);ps.setInt(8,originPortId);
   ps.setInt(9,destPortId);ps.setInt(10,destPortId);
   ps.setInt(11,safeSize);ps.setInt(12,offset);
   try(ResultSet r=ps.executeQuery()){
    while(r.next()){
     total=r.getLong("match_count");
     Map<String,Object> row=new LinkedHashMap<>();
     row.put("originPortId",r.getInt("origin_port_id"));row.put("destPortId",r.getInt("dest_port_id"));
     row.put("origin",r.getString("origin_name")+" ("+r.getString("origin_code")+")");
     row.put("destination",r.getString("destination_name")+" ("+r.getString("destination_code")+")");
     row.put("availableContainers",r.getInt("available_containers"));row.put("activeShipments",r.getInt("active_shipments"));
     row.put("historicalTransitDays",r.getObject("avg_days"));row.put("historySamples",r.getInt("samples"));rows.add(row);
    }
   }
  }
  Map<String,Object> result=new LinkedHashMap<>();result.put("routes",rows);result.put("total",total);
  result.put("page",safePage);result.put("pageSize",safeSize);return result;
 }
 public List<Map<String,Object>> availablePorts(int uid)throws Exception{
  try(Connection c=GetConnection.getConnection()){
   authorized(c,uid);List<Map<String,Object>> rows=new ArrayList<>();
   try(PreparedStatement s=c.prepareStatement("SELECT port_id,port_code,port_name,city,country FROM ports ORDER BY country,port_name");ResultSet r=s.executeQuery()){
    while(r.next()){Map<String,Object> m=new LinkedHashMap<>();m.put("id",r.getInt("port_id"));m.put("label",r.getString("port_code")+" · "+r.getString("port_name")+" · "+r.getString("country"));rows.add(m);}
   }return rows;
  }
 }
}
