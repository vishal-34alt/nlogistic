
package model;

import java.sql.Timestamp;

public class User {

    private int userId;
    private String role;
    private Integer companyId;
    private String fullName;
    private String email;
    private String phone;
    private String status;
    private int failedAttempts;
    private Timestamp lastLogin;

    // Default Constructor
    public User() {
    }

    // Parameterized Constructor
    public User(int userId, String role, Integer companyId,
                String fullName, String email, String phone,
                String status, int failedAttempts, Timestamp lastLogin) {

        this.userId = userId;
        this.role = role;
        this.companyId = companyId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.status = status;
        this.failedAttempts = failedAttempts;
        this.lastLogin = lastLogin;
    }

    /** Verified Module 2 identity constructor. Role and company must come from the active users record. */
    public User(int userId, String role, Integer companyId, String fullName) {
        this.userId = userId;
        this.role = role;
        this.companyId = companyId;
        this.fullName = fullName;
        this.status = "ACTIVE";
    }

    /** Backwards-compatible name used by shipment and sidebar views. */
    public String getName() {
        return fullName;
    }

    /** Shipment editing is restricted to the Seller who owns the record. */
    public boolean canUpdateShipment(int sellerId) {
        return isSeller() && companyId != null && companyId.intValue() == sellerId;
    }

    public void requireSeller() {
        if (!isSeller())
            throw new SecurityException("Only the owning Seller may change shipment or movement information");
    }

    public void requireStaff() {
        if (!isAdmin() && !isSeller())
            throw new SecurityException("Seller or Admin access required");
    }

    // Business Logic - Validate User
    public boolean isValidUser() {

        return fullName != null
            && !fullName.trim().isEmpty()
            && email != null
            && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    // Validate User Registration
    public boolean isValidRegistration(String password) {

        return isValidUser()
            && password != null
            && !password.trim().isEmpty();
    }

    // Validate Login Credentials
    public static boolean isValidLoginCredentials(
            String email, String password) {

        return email != null
            && !email.trim().isEmpty()
            && password != null
            && !password.isEmpty();
    }

    // Check Active Status
    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(status);
    }

    // Check Admin Role
    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role);
    }

    // Check Seller Role
    public boolean isSeller() {
        return "SELLER".equalsIgnoreCase(role);
    }

    // Check Consumer Role
    public boolean isConsumer() {
        return "CONSUMER".equalsIgnoreCase(role);
    }

    // Getters and Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Integer companyId) {
        this.companyId = companyId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getFailedAttempts() {
        return failedAttempts;
    }

    public void setFailedAttempts(int failedAttempts) {
        this.failedAttempts = failedAttempts;
    }

    public Timestamp getLastLogin() {
        return lastLogin;
    }

    public void setLastLogin(Timestamp lastLogin) {
        this.lastLogin = lastLogin;
    }
}
