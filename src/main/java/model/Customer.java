
package model;

import java.math.BigDecimal;

public class Customer {

    private int customerId;
    private int userId;
    private int companyId;
    private String contactPerson;
    private String billingAddress;
    private BigDecimal creditLimit;

    public Customer() {
    }

    public Customer(int customerId, int userId, int companyId,
                    String contactPerson, String billingAddress,
                    BigDecimal creditLimit) {

        this.customerId = customerId;
        this.userId = userId;
        this.companyId = companyId;
        this.contactPerson = contactPerson;
        this.billingAddress = billingAddress;
        this.creditLimit = creditLimit;
    }

    public Customer(int userId, int companyId,
                    String contactPerson, String billingAddress,
                    BigDecimal creditLimit) {

        this.userId = userId;
        this.companyId = companyId;
        this.contactPerson = contactPerson;
        this.billingAddress = billingAddress;
        this.creditLimit = creditLimit;
    }

    // Getters and Setters

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getBillingAddress() {
        return billingAddress;
    }

    public void setBillingAddress(String billingAddress) {
        this.billingAddress = billingAddress;
    }

    public BigDecimal getCreditLimit() {
        return creditLimit;
    }

    public void setCreditLimit(BigDecimal creditLimit) {
        this.creditLimit = creditLimit;
    }

    // Business Validation Methods

    public boolean isValidCustomer() {
        return userId > 0 && companyId > 0;
    }

    public boolean hasValidCreditLimit() {
        return creditLimit == null || creditLimit.compareTo(BigDecimal.ZERO) >= 0;
    }

    public boolean hasCreditLimit() {
        return creditLimit != null
                && creditLimit.compareTo(BigDecimal.ZERO) > 0;
    }

}
