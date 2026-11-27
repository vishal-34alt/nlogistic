package model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;

public class InventoryTurnover {

    private int resultId;
    private int productId;
    private Date periodStart;
    private Date periodEnd;
    private BigDecimal cogs;
    private BigDecimal avgInventory;
    private BigDecimal turnoverRatio;

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

    public Date getPeriodStart() {
        return periodStart;
    }

    public void setPeriodStart(Date periodStart) {
        this.periodStart = periodStart;
    }

    public Date getPeriodEnd() {
        return periodEnd;
    }

    public void setPeriodEnd(Date periodEnd) {
        this.periodEnd = periodEnd;
    }

    public BigDecimal getCogs() {
        return cogs;
    }

    public void setCogs(BigDecimal cogs) {
        this.cogs = cogs;
    }

    public BigDecimal getAvgInventory() {
        return avgInventory;
    }

    public void setAvgInventory(BigDecimal avgInventory) {
        this.avgInventory = avgInventory;
    }

    public BigDecimal getTurnoverRatio() {
        return turnoverRatio;
    }

    public void setTurnoverRatio(BigDecimal turnoverRatio) {
        this.turnoverRatio = turnoverRatio;
    }
    // Business logic: Calculate inventory turnover ratio
    public BigDecimal calculateTurnoverRatio() {

        if (cogs == null || avgInventory == null ||
            avgInventory.compareTo(BigDecimal.ZERO) == 0) {

            return BigDecimal.ZERO;
        }

        return cogs.divide(
            avgInventory,
            2,
            RoundingMode.HALF_UP
        );
    }
}
