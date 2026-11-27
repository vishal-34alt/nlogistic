
package model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;

public class Profitability {

    private int resultId;
    private int productId;
    private Date periodMonth;
    private BigDecimal revenue;
    private BigDecimal cost;
    private BigDecimal marginPct;

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

    public Date getPeriodMonth() {
        return periodMonth;
    }

    public void setPeriodMonth(Date periodMonth) {
        this.periodMonth = periodMonth;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    public BigDecimal getCost() {
        return cost;
    }

    public void setCost(BigDecimal cost) {
        this.cost = cost;
    }

    public BigDecimal getMarginPct() {
        return marginPct;
    }

    public void setMarginPct(BigDecimal marginPct) {
        this.marginPct = marginPct;
    }
    // Business logic: Calculate profit margin percentage
    public BigDecimal calculateMarginPct() {

        if (revenue == null || cost == null ||
            revenue.compareTo(BigDecimal.ZERO) <= 0) {

            return BigDecimal.ZERO;
        }

        BigDecimal profit = revenue.subtract(cost);

        return profit.multiply(new BigDecimal("100"))
                .divide(revenue, 2, RoundingMode.HALF_UP);
    }
}
