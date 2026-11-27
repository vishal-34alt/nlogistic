package model;

import java.math.BigDecimal;
import java.sql.Date;

public class AnalyticsProfitLoss {

    private int plId;
    private int shipmentId;
    private int sellerId;
    private Date periodMonth;
    private BigDecimal revenue;
    private BigDecimal freightCost;
    private BigDecimal portCost;
    private BigDecimal handlingCost;
    private BigDecimal claimLoss;
    private BigDecimal netProfit;

    public int getPlId() {
        return plId;
    }

    public void setPlId(int plId) {
        this.plId = plId;
    }

    public int getShipmentId() {
        return shipmentId;
    }

    public void setShipmentId(int shipmentId) {
        this.shipmentId = shipmentId;
    }

    public int getSellerId() {
        return sellerId;
    }

    public void setSellerId(int sellerId) {
        this.sellerId = sellerId;
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

    public BigDecimal getFreightCost() {
        return freightCost;
    }

    public void setFreightCost(BigDecimal freightCost) {
        this.freightCost = freightCost;
    }

    public BigDecimal getPortCost() {
        return portCost;
    }

    public void setPortCost(BigDecimal portCost) {
        this.portCost = portCost;
    }

    public BigDecimal getHandlingCost() {
        return handlingCost;
    }

    public void setHandlingCost(BigDecimal handlingCost) {
        this.handlingCost = handlingCost;
    }

    public BigDecimal getClaimLoss() {
        return claimLoss;
    }

    public void setClaimLoss(BigDecimal claimLoss) {
        this.claimLoss = claimLoss;
    }

    public BigDecimal getNetProfit() {
        return netProfit;
    }

    public void setNetProfit(BigDecimal netProfit) {
        this.netProfit = netProfit;
    }
    // Business logic: Calculate net profit
    public BigDecimal calculateNetProfit() {

        BigDecimal totalExpenses =
                getSafeValue(freightCost)
                .add(getSafeValue(portCost))
                .add(getSafeValue(handlingCost))
                .add(getSafeValue(claimLoss));

        return getSafeValue(revenue).subtract(totalExpenses);
    }

    // Handle null monetary values
    private BigDecimal getSafeValue(BigDecimal value) {

        return value == null ? BigDecimal.ZERO : value;
    }
}
