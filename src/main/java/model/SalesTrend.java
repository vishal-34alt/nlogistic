
package model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;

public class SalesTrend {

    private int resultId;
    private Date periodMonth;
    private int originPortId;
    private int destPortId;
    private BigDecimal totalSales;
    private int totalQty;
    private BigDecimal growthPct;
    // Authorized trend category, populated by the Implementor, never by the JSP.
    private String groupKey;
    private String groupCode;
    private String groupName;
    private String chartLabel;


    public String getGroupKey() { return groupKey; }
    public void setGroupKey(String value) { this.groupKey=value; }
    public String getGroupCode() { return groupCode; }
    public void setGroupCode(String value) { this.groupCode=value; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String value) { this.groupName=value; }
    public String getChartLabel() { return chartLabel; }
    public void setChartLabel(String value) { this.chartLabel=value; }

    public int getResultId() {
        return resultId;
    }

    public void setResultId(int resultId) {
        this.resultId = resultId;
    }

    public Date getPeriodMonth() {
        return periodMonth;
    }

    public void setPeriodMonth(Date periodMonth) {
        this.periodMonth = periodMonth;
    }

    public int getOriginPortId() {
        return originPortId;
    }

    public void setOriginPortId(int originPortId) {
        this.originPortId = originPortId;
    }

    public int getDestPortId() {
        return destPortId;
    }

    public void setDestPortId(int destPortId) {
        this.destPortId = destPortId;
    }

    public BigDecimal getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(BigDecimal totalSales) {
        this.totalSales = totalSales;
    }

    public int getTotalQty() {
        return totalQty;
    }

    public void setTotalQty(int totalQty) {
        this.totalQty = totalQty;
    }

    public BigDecimal getGrowthPct() {
        return growthPct;
    }

    public void setGrowthPct(BigDecimal growthPct) {
        this.growthPct = growthPct;
    }

    // Calculate month-on-month sales growth
    public BigDecimal calculateGrowthPct(BigDecimal previousSales) {

        if (previousSales == null ||
            previousSales.compareTo(BigDecimal.ZERO) == 0 ||
            totalSales == null) {

            return null;
        }

        return totalSales.subtract(previousSales)
                .multiply(new BigDecimal("100"))
                .divide(previousSales, 2, RoundingMode.HALF_UP);
    }
}
