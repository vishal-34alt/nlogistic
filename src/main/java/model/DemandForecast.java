package model;

import java.math.BigDecimal;
import java.sql.Date;

public class DemandForecast {

    private int forecastId;
    private int originPortId;
    private int destPortId;
    private String containerType;
    private Date forecastMonth;
    private int predictedBookings;
    private BigDecimal confidencePct;
    private BigDecimal suggestedMultiplier;

    public int getForecastId() {
        return forecastId;
    }

    public void setForecastId(int forecastId) {
        this.forecastId = forecastId;
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

    public String getContainerType() {
        return containerType;
    }

    public void setContainerType(String containerType) {
        this.containerType = containerType;
    }

    public Date getForecastMonth() {
        return forecastMonth;
    }

    public void setForecastMonth(Date forecastMonth) {
        this.forecastMonth = forecastMonth;
    }

    public int getPredictedBookings() {
        return predictedBookings;
    }

    public void setPredictedBookings(int predictedBookings) {
        this.predictedBookings = predictedBookings;
    }

    public BigDecimal getConfidencePct() {
        return confidencePct;
    }

    public void setConfidencePct(BigDecimal confidencePct) {
        this.confidencePct = confidencePct;
    }

    public BigDecimal getSuggestedMultiplier() {
        return suggestedMultiplier;
    }

    public void setSuggestedMultiplier(BigDecimal suggestedMultiplier) {
        this.suggestedMultiplier = suggestedMultiplier;
    }
    // Business logic: Calculate suggested price
    public BigDecimal calculateSuggestedPrice(BigDecimal basePrice) {

        if (basePrice == null || suggestedMultiplier == null) {
            return null;
        }

        if (basePrice.compareTo(BigDecimal.ZERO) < 0 ||
            suggestedMultiplier.compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalArgumentException(
                "Base price and multiplier must be valid."
            );
        }

        return basePrice.multiply(suggestedMultiplier);
    }
}
