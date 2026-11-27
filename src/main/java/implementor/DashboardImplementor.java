package implementor;
import db_config.GetConnection;
import model.DashboardSummary;
import operations.DashboardOperations;
import java.sql.*;
import java.util.*;
/** Queries are filtered to the active DB user's role and permitted shipment ownership. */
@SuppressWarnings("unused")
public final class DashboardImplementor implements DashboardOperations {
  @Override public DashboardSummary summary(int userId)throws SQLException {
    DashboardSummary s=new DashboardSummary();
    try(Connection c=GetConnection.getConnection()){
      String role;Integer company=null,customer=null;
      try(PreparedStatement p=c.prepareStatement("SELECT role,company_id FROM users WHERE user_id=? AND status='ACTIVE'")){
        p.setInt(1,userId);try(ResultSet r=p.executeQuery()){
          if(!r.next())throw new SQLException("Login expired","28000");
          role=r.getString("role");int v=r.getInt("company_id");if(!r.wasNull())company=v;
        }
      }
      if("CONSUMER".equals(role)){
        try(PreparedStatement p=c.prepareStatement("SELECT customer_id FROM customers WHERE user_id=?")){
          p.setInt(1,userId);try(ResultSet r=p.executeQuery()){if(r.next())customer=r.getInt(1);}
        }
      }
      if(!"ADMIN".equals(role)&&!"SELLER".equals(role)&&!"CONSUMER".equals(role))throw new SQLException("Role not permitted","28000");
      if(("SELLER".equals(role)&&company==null)||("CONSUMER".equals(role)&&customer==null))return s;
      String scope="ADMIN".equals(role)?"":("SELLER".equals(role)?" WHERE s.seller_id=?":" WHERE s.consumer_id=?");
      String conditionScope=scope.isEmpty()?" WHERE ":scope+" AND ";
      Integer owner="ADMIN".equals(role)?null:("SELLER".equals(role)?company:customer);
      if("ADMIN".equals(role)){
        s.setRegisteredUsers(count(c,"SELECT COUNT(*) FROM users",null));
        s.setRegisteredCompanies(count(c,"SELECT COUNT(*) FROM companies",null));
        s.setRegisteredCustomers(count(c,"SELECT COUNT(*) FROM customers",null));
        s.setRegisteredPorts(count(c,"SELECT COUNT(*) FROM ports",null));
        s.setRegisteredVessels(count(c,"SELECT COUNT(*) FROM vessels",null));
        s.setMaintenanceVessels(count(c,"SELECT COUNT(*) FROM vessels WHERE status='MAINTENANCE'",null));
        s.setAuditEvents(count(c,"SELECT COUNT(*) FROM audit_log",null));
      }
      if(!"CONSUMER".equals(role)) {
        if("ADMIN".equals(role))s.setAvailableContainers(count(c,"SELECT COUNT(*) FROM containers WHERE status='AVAILABLE'",null));
        else s.setAvailableContainers(count(c,"SELECT COUNT(*) FROM containers WHERE status='AVAILABLE' AND seller_id=?",company));
      }
      s.setActiveShipments(count(c,"SELECT COUNT(*) FROM shipment s"+conditionScope+"s.status NOT IN ('DELIVERED','CANCELLED')",scope.isEmpty()?null:owner));
      s.setOpenInvoices(count(c,"SELECT COUNT(*) FROM billing_invoices i JOIN shipment s ON s.shipment_id=i.shipment_id"+conditionScope+"i.status <> 'PAID' AND s.status <> 'CANCELLED'",scope.isEmpty()?null:owner));
      s.setOpenClaims(count(c,"SELECT COUNT(*) FROM claims cl JOIN shipment s ON s.shipment_id=cl.shipment_id"+conditionScope+"cl.status NOT IN ('SETTLED','REJECTED') AND NOT EXISTS(SELECT 1 FROM audit_log aw WHERE aw.table_name='claims' AND aw.action='WITHDRAW_CLAIM' AND aw.record_id=cl.claim_id)",scope.isEmpty()?null:owner));
      try(PreparedStatement p=c.prepareStatement("SELECT COALESCE(SUM(pay.amount),0) AS total FROM payments pay JOIN billing_invoices i ON i.invoice_id=pay.invoice_id JOIN shipment s ON s.shipment_id=i.shipment_id"+scope)){
        if(!scope.isEmpty())p.setInt(1,owner);
        try(ResultSet r=p.executeQuery()){if(r.next())s.setRecordedPayments(r.getBigDecimal("total"));}
      }
      String byStatus="SELECT s.status, COUNT(*) AS n FROM shipment s"+scope+" GROUP BY s.status ORDER BY s.status";
      try(PreparedStatement p=c.prepareStatement(byStatus)){
        if(!scope.isEmpty())p.setInt(1,owner);
        try(ResultSet r=p.executeQuery()){while(r.next())s.getShipmentStatuses().put(r.getString("status"),r.getInt("n"));}
      }
      try(PreparedStatement p=c.prepareStatement("SELECT action,table_name FROM audit_log WHERE user_id=? ORDER BY log_id DESC LIMIT 5")){
        p.setInt(1,userId);try(ResultSet r=p.executeQuery()){
          while(r.next())s.getRecentActions().add(r.getString("action")+" · "+r.getString("table_name"));
        }
      }
    }
    return s;
  }
  private static int count(Connection c,String sql,Integer owner)throws SQLException{
    try(PreparedStatement p=c.prepareStatement(sql)){
      if(owner!=null)p.setInt(1,owner);
      try(ResultSet r=p.executeQuery()){return r.next()?r.getInt(1):0;}
    }
  }
}
