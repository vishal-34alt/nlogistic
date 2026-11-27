package model;
import java.sql.SQLException;
import implementor.AccountRegistrationImplementor;
/** Public registration eligibility and validation belong in the model. */
public final class AccountRegistrationActions {
 public int register(String name,String email,String phone,String role,String password,String confirm,String company)throws SQLException{
  if(email==null||!email.trim().matches("^[^@\\s]+@[^@\\s]+[.][^@\\s]+$"))throw new IllegalArgumentException("invalid_email");
  if(password==null||!password.equals(confirm))throw new IllegalArgumentException("password_mismatch");
  if(!"SELLER".equals(role)&&!"CONSUMER".equals(role))throw new IllegalArgumentException("invalid_role");
  if(name==null||name.trim().isEmpty()||name.length()>100)throw new IllegalArgumentException("invalid");
  if(phone!=null&&phone.length()>20)throw new IllegalArgumentException("invalid");
  if(company==null||company.trim().isEmpty()||company.length()>150)throw new IllegalArgumentException("company_required");
  if(password.length()<8||password.length()>255)throw new IllegalArgumentException("invalid");
  return AccountRegistrationImplementor.register(name.trim(),email.trim(),phone,role,password,company.trim());
 }
}
