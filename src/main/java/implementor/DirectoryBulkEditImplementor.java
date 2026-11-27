package implementor;

import db_config.GetConnection;
import java.math.BigDecimal;
import java.sql.*;
import java.util.Objects;

/** Atomic admin directory edits; all SQL lives in Implementor and approved schema remains unchanged. */
public final class DirectoryBulkEditImplementor {
    private static String clean(String value) { return value==null ? "" : value.trim(); }
    private static String optional(String value) { String v=clean(value);return v.isEmpty()?null:v; }
    private static void maximum(String label,String v,int limit) {
        if(v!=null && v.length()>limit) throw new IllegalArgumentException(label+" exceeds "+limit+" characters.");
    }
    private static void requireAdmin(Connection c,int userId) throws SQLException {
        try(PreparedStatement q=c.prepareStatement("SELECT 1 FROM users WHERE user_id=? AND role='ADMIN' AND status='ACTIVE'")) {
            q.setInt(1,userId);try(ResultSet r=q.executeQuery()){
                if(!r.next())throw new SQLException("Only an active Admin can save these records.","45000");
            }
        }
    }
    private static void varchar(PreparedStatement ps,int index,String value)throws SQLException {
        if(value==null)ps.setNull(index,Types.VARCHAR);else ps.setString(index,value);
    }
    public void company(int actor,int id,String name,String type,String gst,String iec,
            String address,String city,String country,String ip) throws SQLException {
        name=clean(name);type=clean(type);gst=optional(gst);iec=optional(iec);
        address=optional(address);city=optional(city);country=optional(country);
        if(name.isEmpty()||name.length()>150)throw new IllegalArgumentException("Company name must contain 1 to 150 characters.");
        if(!("CONSUMER".equals(type)||"SELLER".equals(type)))throw new IllegalArgumentException("Choose a valid company type.");
        maximum("GST number",gst,20);maximum("IEC code",iec,15);
        maximum("City",city,60);maximum("Country",country,60);
        if(id<=0)throw new IllegalArgumentException("Choose a valid company.");
        try(Connection c=GetConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                requireAdmin(c,actor);
                String oldName,oldType,oldGst,oldIec,oldAddress,oldCity,oldCountry;
                try(PreparedStatement q=c.prepareStatement("SELECT company_name,company_type,gst_number,iec_code,address,city,country FROM companies WHERE company_id=? FOR UPDATE")) {
                    q.setInt(1,id);try(ResultSet r=q.executeQuery()) {
                        if(!r.next())throw new SQLException("Company record no longer exists.","45000");
                        oldName=r.getString(1);oldType=r.getString(2);oldGst=r.getString(3);oldIec=r.getString(4);
                        oldAddress=r.getString(5);oldCity=r.getString(6);oldCountry=r.getString(7);
                    }
                }
                if(!Objects.equals(oldType,type)) {
                    try(PreparedStatement q=c.prepareStatement("SELECT (SELECT COUNT(*) FROM users WHERE company_id=?) + (SELECT COUNT(*) FROM customers WHERE company_id=?) + (SELECT COUNT(*) FROM products WHERE owner_company_id=?) + (SELECT COUNT(*) FROM containers WHERE seller_id=?) + (SELECT COUNT(*) FROM vessels WHERE owner_company_id=?) + (SELECT COUNT(*) FROM pricing_rules WHERE seller_id=?) + (SELECT COUNT(*) FROM shipment WHERE seller_id=?)")) {
                        for(int n=1;n<=7;n++)q.setInt(n,id);
                        try(ResultSet r=q.executeQuery()) {
                            if(r.next()&&r.getLong(1)>0)throw new SQLException("Company type cannot change while accounts or transactions reference it.","45000");
                        }
                    }
                }
                if(Objects.equals(oldName,name)&&Objects.equals(oldType,type)&&Objects.equals(oldGst,gst)&&Objects.equals(oldIec,iec)
                    &&Objects.equals(oldAddress,address)&&Objects.equals(oldCity,city)&&Objects.equals(oldCountry,country)) {c.rollback();return;}
                try(PreparedStatement q=c.prepareStatement("UPDATE companies SET company_name=?,company_type=?,gst_number=?,iec_code=?,address=?,city=?,country=? WHERE company_id=?")) {
                    q.setString(1,name);q.setString(2,type);varchar(q,3,gst);varchar(q,4,iec);
                    varchar(q,5,address);varchar(q,6,city);varchar(q,7,country);q.setInt(8,id);
                    if(q.executeUpdate()!=1)throw new SQLException("Company update was not saved.","45000");
                }
                try(PreparedStatement q=c.prepareStatement("CALL sp_record_audit_action(?,'UPDATE','companies',?, JSON_OBJECT('company_name',?,'company_type',?,'gst_number',?,'iec_code',?,'address',?,'city',?,'country',?), JSON_OBJECT('company_name',?,'company_type',?,'gst_number',?,'iec_code',?,'address',?,'city',?,'country',?),?)")) {
                    q.setInt(1,actor);q.setInt(2,id);
                    String[] before={oldName,oldType,oldGst,oldIec,oldAddress,oldCity,oldCountry};
                    String[] after={name,type,gst,iec,address,city,country};
                    for(int i=0;i<7;i++){varchar(q,i+3,before[i]);varchar(q,i+10,after[i]);}
                    varchar(q,17,ip);q.execute();
                }
                c.commit();
            }catch(SQLException|RuntimeException e){try{c.rollback();}catch(SQLException x){e.addSuppressed(x);}throw e;}
        }
    }
    public void customer(int actor,int id,String contact,String address,String credit,String ip)throws SQLException {
        contact=optional(contact);address=optional(address);credit=clean(credit);
        maximum("Contact person",contact,100);
        if(id<=0)throw new IllegalArgumentException("Choose a valid customer.");
        if(!credit.matches("[0-9]{1,10}(\\.[0-9]{1,2})?"))throw new IllegalArgumentException("Credit limit must be a nonnegative number with up to 2 decimal places.");
        BigDecimal amount=new BigDecimal(credit);
        try(Connection c=GetConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                requireAdmin(c,actor);
                String previousContact,previousAddress; BigDecimal previousAmount;
                try(PreparedStatement q=c.prepareStatement("SELECT contact_person,billing_address,credit_limit FROM customers WHERE customer_id=? FOR UPDATE")) {
                    q.setInt(1,id);try(ResultSet r=q.executeQuery()){
                        if(!r.next())throw new SQLException("Customer record no longer exists.","45000");
                        previousContact=r.getString(1);previousAddress=r.getString(2);previousAmount=r.getBigDecimal(3);
                    }
                }
                if(Objects.equals(contact,previousContact)&&Objects.equals(address,previousAddress)
                    &&previousAmount!=null&&amount.compareTo(previousAmount)==0){c.rollback();return;}
                try(PreparedStatement q=c.prepareStatement("UPDATE customers SET contact_person=?,billing_address=?,credit_limit=? WHERE customer_id=?")) {
                    varchar(q,1,contact);varchar(q,2,address);q.setBigDecimal(3,amount);q.setInt(4,id);
                    if(q.executeUpdate()!=1)throw new SQLException("Customer update was not saved.","45000");
                }
                try(PreparedStatement q=c.prepareStatement("CALL sp_record_audit_action(?,'UPDATE','customers',?, JSON_OBJECT('contact_person',?,'billing_address',?,'credit_limit',?), JSON_OBJECT('contact_person',?,'billing_address',?,'credit_limit',?),?)")) {
                    q.setInt(1,actor);q.setInt(2,id);varchar(q,3,previousContact);varchar(q,4,previousAddress);
                    if(previousAmount==null)q.setNull(5,Types.DECIMAL);else q.setBigDecimal(5,previousAmount);
                    varchar(q,6,contact);varchar(q,7,address);q.setBigDecimal(8,amount);varchar(q,9,ip);q.execute();
                }
                c.commit();
            }catch(SQLException|RuntimeException e){try{c.rollback();}catch(SQLException x){e.addSuppressed(x);}throw e;}
        }
    }
}
