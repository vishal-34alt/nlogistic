package implementor;

import db_config.GetConnection;
import java.sql.*;
import java.util.Locale;

/** Atomic multi-field account update. No new table, package or stored routine. */
public final class UserBulkEditImplementor {
    public void save(int actor, int target, String name, String email,
                     String phone, String status, boolean adminEdit, String ip) throws SQLException {
        name = clean(name); email = clean(email).toLowerCase(Locale.ROOT); phone = clean(phone);
        if (name.isEmpty() || name.length()>100) throw new IllegalArgumentException("Enter a name of 1 to 100 characters.");
        if (email.length()>120 || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"))
            throw new IllegalArgumentException("Enter a valid email address.");
        if (phone.length()>20 || (!phone.isEmpty() && !phone.matches("^[+0-9() .-]{7,20}$")))
            throw new IllegalArgumentException("Enter a valid phone number, or leave it empty.");
        if (adminEdit && !("ACTIVE".equals(status)||"INACTIVE".equals(status)||"LOCKED".equals(status)))
            throw new IllegalArgumentException("Choose an account status from the list.");
        if (actor<=0 || target<=0) throw new SecurityException("Sign in to update your account.");
        try (Connection con=GetConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                try (PreparedStatement auth=con.prepareStatement("SELECT role,status FROM users WHERE user_id=? FOR UPDATE")) {
                    auth.setInt(1, actor);
                    try (ResultSet r=auth.executeQuery()) {
                        if (!r.next()||!"ACTIVE".equals(r.getString("status")) ||
                            (adminEdit && !"ADMIN".equals(r.getString("role"))) ||
                            (!adminEdit && actor!=target)) throw new SecurityException("Account access denied.");
                    }
                }
                String oldName,oldEmail,oldPhone,oldStatus;
                try (PreparedStatement lookup=con.prepareStatement("SELECT full_name,email,phone,status FROM users WHERE user_id=? FOR UPDATE")) {
                    lookup.setInt(1,target);
                    try (ResultSet r=lookup.executeQuery()) {
                        if(!r.next()) throw new IllegalArgumentException("User not found.");
                        oldName=r.getString("full_name");oldEmail=r.getString("email");
                        oldPhone=r.getString("phone");oldStatus=r.getString("status");
                    }
                }
                if(!adminEdit) status=oldStatus;
                if(target==actor && !"ACTIVE".equals(status))
                    throw new IllegalArgumentException("You cannot deactivate your own account.");
                if(eq(oldName,name)&&eq(oldEmail,email)&&eq(clean(oldPhone),phone)&&eq(oldStatus,status)) {
                    con.rollback();return;
                }
                try(PreparedStatement ps=con.prepareStatement("UPDATE users SET full_name=?,email=?,phone=?,status=? WHERE user_id=?")) {
                    ps.setString(1,name);ps.setString(2,email);ps.setString(3,phone.isEmpty()?null:phone);
                    ps.setString(4,status);ps.setInt(5,target);
                    if(ps.executeUpdate()!=1) throw new SQLException("Account update was not saved.");
                }
                // Existing approved audit procedure has no COMMIT and participates in this transaction.
                try(CallableStatement audit=con.prepareCall("CALL sp_record_audit_action(?, 'UPDATE', 'users', ?, JSON_OBJECT('full_name',?,'email',?,'phone',?,'status',?), JSON_OBJECT('full_name',?,'email',?,'phone',?,'status',?), ?)")) {
                    audit.setInt(1,actor);audit.setLong(2,target);
                    audit.setString(3,oldName);audit.setString(4,oldEmail);audit.setString(5,oldPhone);audit.setString(6,oldStatus);
                    audit.setString(7,name);audit.setString(8,email);audit.setString(9,phone);audit.setString(10,status);
                    audit.setString(11,ip==null?null:ip.substring(0,Math.min(45,ip.length())));
                    audit.execute();
                }
                con.commit();
            } catch(SQLException|RuntimeException e){
                try{con.rollback();}catch(SQLException rollback){e.addSuppressed(rollback);}throw e;
            } finally { try {con.setAutoCommit(true);}catch(SQLException ignored){} }
        }
    }
    private static boolean eq(String a,String b){return a==null?b==null:a.equals(b);}
    private static String clean(String s){return s==null?"":s.trim();}
}
