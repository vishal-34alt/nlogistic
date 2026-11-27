package implementor;
import db_config.GetConnection;
import java.sql.*;
/** Registration always provisions a NEW company, preventing arbitrary company takeover. */
public final class AccountRegistrationImplementor {
 private AccountRegistrationImplementor(){}
 public static int register(String name,String email,String phone,String role,String password,String companyName)throws SQLException {
  if(!("SELLER".equals(role)||"CONSUMER".equals(role)))throw new IllegalArgumentException("Invalid role");
  if(name==null||name.trim().isEmpty()||name.length()>100||email==null||!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")||password==null||password.length()<8||companyName==null||companyName.trim().isEmpty()||companyName.length()>150)throw new IllegalArgumentException("Valid name, email, password and new company name are required");
  try(Connection c=GetConnection.getConnection()){
   c.setAutoCommit(false);
   try{
    int company;
    try(CallableStatement s=c.prepareCall("{CALL sp_insert_company(?,?,?,?,?,?,?)}")) {
     s.setString(1,companyName.trim());s.setString(2,role);for(int i=3;i<=7;i++)s.setNull(i,Types.VARCHAR);
     company=id(s,"company_id");
    }
    int user;
    try(CallableStatement s=c.prepareCall("{CALL sp_insert_user(?,?,?,?,?,?)}")) {
     s.setString(1,role);s.setInt(2,company);s.setString(3,name.trim());s.setString(4,email.trim());s.setString(5,password);s.setString(6,phone);
     user=id(s,"user_id");
    }
    if("CONSUMER".equals(role))try(CallableStatement s=c.prepareCall("{CALL sp_insert_customer(?,?,?,?,?)}")){
     s.setInt(1,user);s.setInt(2,company);s.setString(3,name.trim());s.setNull(4,Types.LONGVARCHAR);s.setBigDecimal(5,java.math.BigDecimal.ZERO);s.execute();
    }
    c.commit();return user;
   }catch(SQLException|RuntimeException e){c.rollback();throw e;}finally{c.setAutoCommit(true);}
  }
 }

 /** Admin provisions an account for an EXISTING registered company. */
 public static int adminCreate(int adminId,String name,String email,String phone,String role,String password,Integer companyId)throws SQLException {
  if(adminId<=0||name==null||name.trim().isEmpty()||name.length()>100||email==null||!email.trim().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")||password==null||password.length()<8||password.length()>255||phone!=null&&phone.length()>20)throw new IllegalArgumentException("Valid account details are required");
  if(!"ADMIN".equals(role)&&!"SELLER".equals(role)&&!"CONSUMER".equals(role))throw new IllegalArgumentException("Invalid role");
  if(!"ADMIN".equals(role)&& (companyId==null||companyId<=0))throw new IllegalArgumentException("Choose an existing company");
  if("ADMIN".equals(role)&&companyId!=null)throw new IllegalArgumentException("Admin must not belong to a company");
  try(Connection c=GetConnection.getConnection()) {
   c.setAutoCommit(false);
   try {
    try(PreparedStatement ps=c.prepareStatement("SELECT 1 FROM users WHERE user_id=? AND role='ADMIN' AND status='ACTIVE'")){
     ps.setInt(1,adminId);try(ResultSet rs=ps.executeQuery()){if(!rs.next())throw new SecurityException("Admin required");}
    }
    if(companyId!=null)try(PreparedStatement ps=c.prepareStatement("SELECT company_type FROM companies WHERE company_id=?")){
     ps.setInt(1,companyId);try(ResultSet rs=ps.executeQuery()){if(!rs.next()||!role.equals(rs.getString(1)))throw new IllegalArgumentException("Company does not match role");}
    }
    int userId;
    try(CallableStatement s=c.prepareCall("{CALL sp_insert_user(?,?,?,?,?,?)}")){
     s.setString(1,role);if(companyId==null)s.setNull(2,Types.INTEGER);else s.setInt(2,companyId);
     s.setString(3,name.trim());s.setString(4,email.trim());s.setString(5,password);s.setString(6,phone);
     userId=id(s,"user_id");
    }
    if(userId<=0)throw new SQLException("Account was not created");
    if("CONSUMER".equals(role))try(CallableStatement s=c.prepareCall("{CALL sp_insert_customer(?,?,?,?,?)}")){
     s.setInt(1,userId);s.setInt(2,companyId);s.setString(3,name.trim());s.setNull(4,Types.LONGVARCHAR);s.setBigDecimal(5,java.math.BigDecimal.ZERO);s.execute();
    }
    c.commit();return userId;
   }catch(SQLException|RuntimeException e){c.rollback();throw e;}finally{c.setAutoCommit(true);}
  }
 }

 private static int id(CallableStatement s,String col)throws SQLException{
  boolean b=s.execute();while(true){if(b){try(ResultSet rs=s.getResultSet()){if(rs.next())return rs.getInt(col);}}else if(s.getUpdateCount()==-1)break;b=s.getMoreResults();}
  throw new SQLException("Registration procedure returned no "+col);
 }
}
