package model;

import java.sql.SQLException;
import operations.UserOperations;
import implementor.UserImplementor;

/** Domain operations for an authenticated user's own profile. */
public final class ProfileActions {
    private final UserOperations users;
    public ProfileActions() { this(new UserImplementor()); }
    public ProfileActions(UserOperations users) { this.users=users; }

    public User profile(int actorId) throws SQLException {
        if(actorId<=0) throw new SecurityException("Login required");
        User user=users.getUserById(actorId);
        if(user==null || !user.isActive()) throw new SecurityException("Account is not active");
        return user;
    }

    public User updateOwnField(int actorId,String field,String value,String ip) throws SQLException {
        profile(actorId); // active session identity is rechecked in the DB
        if(value==null) value="";
        value=value.trim();
        switch (field == null ? "" : field) {
            case "full_name":
                if(value.isEmpty()||value.length()>100)throw new IllegalArgumentException("Name must have 1 to 100 characters");
                break;
            case "email":
                if(value.length()>120||!value.matches("^[^@\\s]+@[^@\\s]+[.][^@\\s]+$"))throw new IllegalArgumentException("Enter a valid email address");
                break;
            case "phone":
                if(value.length()>20||(!value.isEmpty()&&!value.matches("^[+0-9() .-]{7,20}$")))throw new IllegalArgumentException("Enter a valid phone number");
                break;
            default: throw new SecurityException("Unsupported profile field");
        }
        users.updateUserField(actorId, actorId, field, value, ip);
        return profile(actorId);
    }

    public User saveContact(int actorId,String name,String email,String phone,String ip)throws SQLException{
        profile(actorId);
        new implementor.UserBulkEditImplementor().save(actorId,actorId,name,email,phone,null,false,ip);
        return profile(actorId);
    }

    public void changePassword(int actorId,String currentPassword,String password,String confirm,String ip) throws SQLException {
        User user=profile(actorId);
        if(currentPassword==null||currentPassword.isEmpty()) throw new IllegalArgumentException("Current password is required");
        if(password==null||password.length()<8||password.length()>255||!password.equals(confirm))
            throw new IllegalArgumentException("New passwords must match and contain at least 8 characters");
        if(password.equals(currentPassword))throw new IllegalArgumentException("Choose a different new password");
        // Existing SRS login procedure verifies the current password. Never check hashes in the controller.
        User verified;
        try { verified=users.getUserForLogin(user.getEmail(),currentPassword); }
        catch(SQLException ex) { if("45000".equals(ex.getSQLState()))throw new IllegalArgumentException("Current password is incorrect"); throw ex; }
        if(verified==null||verified.getUserId()!=actorId)throw new SecurityException("Invalid account credentials");
        users.updateUserField(actorId, actorId, "password_hash", password, ip);
    }
}
