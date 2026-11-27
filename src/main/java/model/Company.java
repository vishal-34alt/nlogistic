
package model;

public class Company {

    private int companyId;
    private String companyName;
    private String companyType;
    private String gstNumber;
    private String iecCode;
    private String address;
    private String city;
    private String country;

    // Default Constructor
    public Company() {
    }

    // Parameterized Constructor
    public Company(int companyId, String companyName,
                   String companyType, String gstNumber,
                   String iecCode, String address,
                   String city, String country) {

        this.companyId = companyId;
        this.companyName = companyName;
        this.companyType = companyType;
        this.gstNumber = gstNumber;
        this.iecCode = iecCode;
        this.address = address;
        this.city = city;
        this.country = country;
    }

    // Business Logic - Company Validation
    public boolean isValidCompany() {

        if (companyName == null || companyName.trim().isEmpty()) {
            return false;
        }

        return isValidCompanyType();
    }

    // Check Company Type
    public boolean isValidCompanyType() {

        return "CONSUMER".equalsIgnoreCase(companyType)
            || "SELLER".equalsIgnoreCase(companyType);
    }

    // Check Seller Company
    public boolean isSellerCompany() {
        return "SELLER".equalsIgnoreCase(companyType);
    }

    // Check Consumer Company
    public boolean isConsumerCompany() {
        return "CONSUMER".equalsIgnoreCase(companyType);
    }

    // Getters and Setters

    public int getCompanyId() {
        return companyId;
    }

    public void setCompanyId(int companyId) {
        this.companyId = companyId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getCompanyType() {
        return companyType;
    }

    public void setCompanyType(String companyType) {
        this.companyType = companyType;
    }

    public String getGstNumber() {
        return gstNumber;
    }

    public void setGstNumber(String gstNumber) {
        this.gstNumber = gstNumber;
    }

    public String getIecCode() {
        return iecCode;
    }

    public void setIecCode(String iecCode) {
        this.iecCode = iecCode;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }
}
