package model;
import java.sql.SQLException;
import java.util.List;
import operations.*;
import implementor.*;
/** Module 1 account/admin use-cases live in model. Java controller manages HTTP only. */
public final class Module1Actions {
 private final UserOperations users=new UserImplementor();
 private final CompanyOperations companies=new CompanyImplementor();
 private final CustomerOperations customers=new CustomerImplementor();
 private final AuditLogOperations audits=new AuditLogImplementor();
 public int addUser(int admin,String name,String email,String phone,String role,String password,Integer company)throws SQLException{
   return AccountRegistrationImplementor.adminCreate(admin,name,email,phone,role,password,company);
 }
 public List<User> users() throws SQLException{return users.getAllUsers();}
 public List<User> searchUsers(String keyword,String role,String status)throws SQLException{return users.searchUsers(keyword,role,status);}
 public void deactivateUser(int actor,int target,String ip)throws SQLException{
   if(actor==target)throw new IllegalArgumentException("Cannot deactivate your own Admin account");
   users.updateUserField(actor,target,"status","INACTIVE",ip);
 }
 public void updateUser(int actor,int target,String field,String value,String ip)throws SQLException{
   if(actor==target && "status".equals(field) && !"ACTIVE".equalsIgnoreCase(value))
     throw new IllegalArgumentException("Your current Admin account must remain active.");
   users.updateUserField(actor,target,field,value,ip);
 }
 public void updateUserAll(int actor,int target,String name,String email,String phone,String status,String ip)throws SQLException{
   new UserBulkEditImplementor().save(actor,target,name,email,phone,status,true,ip);
 }
 public User login(String email,String password)throws SQLException{return users.getUserForLogin(email,password);}
 public void logout(int actor)throws SQLException{users.logout(actor);}
 public List<Company> companies()throws SQLException{return companies.getAllCompanies();}
 public List<Company> searchCompanies(String keyword,String companyType)throws SQLException{return companies.searchCompanies(keyword,companyType);}
 public void addCompany(Company c)throws SQLException{companies.insertCompany(c);}
 public void updateCompany(int actor,int target,String field,String value,String ip)throws SQLException{
   companies.updateCompanyField(actor,target,field,value,ip);
 }
 public void updateCompanyAll(int actor,int target,String name,String type,String gst,String iec,String address,String city,String country,String ip)throws SQLException{
   new DirectoryBulkEditImplementor().company(actor,target,name,type,gst,iec,address,city,country,ip);
 }
 public void updateCustomerAll(int actor,int target,String contact,String address,String credit,String ip)throws SQLException{
   new DirectoryBulkEditImplementor().customer(actor,target,contact,address,credit,ip);
 }
 public void deleteCompany(int actor,int id)throws SQLException{
   User u=users.getUserById(actor);if(u==null||!"ADMIN".equals(u.getRole()))throw new SecurityException("Admin required");
   if(id<=0)throw new IllegalArgumentException("Invalid company");
   companies.deleteCompany(id);
 }
 public List<Customer> customers()throws SQLException{return customers.getAllCustomers();}
 public List<Customer> searchCustomers(String keyword)throws SQLException{return customers.searchCustomers(keyword);}
 public void addCustomer(Customer c)throws SQLException{customers.insertCustomer(c);}
 public void updateCustomer(int actor,int target,String field,String value,String ip)throws SQLException{
   customers.updateCustomerField(actor,target,field,value,ip);
 }
 public void deleteConsumer(int actor,int customer)throws SQLException{customers.deleteConsumer(actor,customer);}
 public List<AuditLog> auditLogs()throws SQLException{return audits.getAllAuditLogs();}
 public List<AuditLog> searchAuditLogs(Integer user,String table)throws SQLException{return audits.searchAuditLog(user,table);}
}
