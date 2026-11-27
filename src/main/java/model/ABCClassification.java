
package model;

import java.math.BigDecimal;
import java.sql.Date;

public class ABCClassification {

    private int resultId;
    private int productId;
    private BigDecimal annualValue;
    private BigDecimal cumulativePct;
    private String abcClass;
    private Date calculatedOn;

    public int getResultId() {
        return resultId;
    }

    public void setResultId(int resultId) {
        this.resultId = resultId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public BigDecimal getAnnualValue() {
        return annualValue;
    }

    public void setAnnualValue(BigDecimal annualValue) {
        this.annualValue = annualValue;
    }

    public BigDecimal getCumulativePct() {
        return cumulativePct;
    }

    public void setCumulativePct(BigDecimal cumulativePct) {
        this.cumulativePct = cumulativePct;
    }

    public String getAbcClass() {
        return abcClass;
    }

    public void setAbcClass(String abcClass) {
        this.abcClass = abcClass;
    }

    public Date getCalculatedOn() {
        return calculatedOn;
    }

    public void setCalculatedOn(Date calculatedOn) {
        this.calculatedOn = calculatedOn;
    }
    // Business logic: Determine ABC category
    public String determineAbcClass() {

        if (cumulativePct == null) {
            return null;
        }

        if (cumulativePct.compareTo(new BigDecimal("70")) < 0) {
            return "A";
        }
        else if (cumulativePct.compareTo(new BigDecimal("90")) < 0) {
            return "B";
        }
        else {
            return "C";
        }
    }
}
