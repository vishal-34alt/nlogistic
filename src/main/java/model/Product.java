package model;

import java.math.BigDecimal;

public class Product {
    private int productId;
    private String sku, productName, category, hsCode, unit, sellerName;
    private BigDecimal unitWeightKg, unitPrice;
    private int ownerCompanyId;
    public int getProductId(){return productId;} public void setProductId(int v){productId=v;}
    public String getSku(){return sku;} public void setSku(String v){sku=v;}
    public String getProductName(){return productName;} public void setProductName(String v){productName=v;}
    public String getCategory(){return category;} public void setCategory(String v){category=v;}
    public String getHsCode(){return hsCode;} public void setHsCode(String v){hsCode=v;}
    public String getUnit(){return unit;} public void setUnit(String v){unit=v;}
    public String getSellerName(){return sellerName;} public void setSellerName(String v){sellerName=v;}
    public BigDecimal getUnitWeightKg(){return unitWeightKg;} public void setUnitWeightKg(BigDecimal v){unitWeightKg=v;}
    public BigDecimal getUnitPrice(){return unitPrice;} public void setUnitPrice(BigDecimal v){unitPrice=v;}
    public int getOwnerCompanyId(){return ownerCompanyId;} public void setOwnerCompanyId(int v){ownerCompanyId=v;}
}
