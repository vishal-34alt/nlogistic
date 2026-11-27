
package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Map;

import operations.PricingOperations;
import implementor.PricingImplementor;

public class PricingRule {

    private int ruleId;
    private int originPortId;
    private int destPortId;
    private String containerType;
    private BigDecimal baseRate;
    private BigDecimal ratePerKg;
    private BigDecimal ratePerCbm;
    private BigDecimal seasonMultiplier;
    private BigDecimal demandMultiplier;
    private Date validFrom;
    private Date validTo;
    private String status;

    private PricingOperations pricingDAO;

    public PricingRule() {
        this(new PricingImplementor());
    }

    public PricingRule(PricingOperations pricingDAO) {
        if (pricingDAO == null) {
            throw new IllegalArgumentException("Pricing DAO cannot be null.");
        }
        this.pricingDAO = pricingDAO;
    }

    // INSERT PRICING RULE
    public int insertPricingRule(
            int userId,
            int sellerId,
            int originPortId,
            int destPortId,
            String containerType,
            BigDecimal baseRate,
            BigDecimal ratePerKg,
            BigDecimal ratePerCbm,
            BigDecimal seasonMultiplier,
            BigDecimal demandMultiplier,
            Date validFrom,
            Date validTo) throws Exception {

        this.originPortId = originPortId;
        this.destPortId = destPortId;
        this.containerType = containerType;
        this.baseRate = baseRate;
        this.ratePerKg = ratePerKg;
        this.ratePerCbm = ratePerCbm;
        this.seasonMultiplier = seasonMultiplier;
        this.demandMultiplier = demandMultiplier;
        this.validFrom = validFrom;
        this.validTo = validTo;

        validate();

        return pricingDAO.insertPricingRule(userId, sellerId, this);
    }

    // UPDATE A SPECIFIC PRICING FIELD
    public Map<String, Object> updatePricingRuleField(
            int userId,
            int ruleId,
            String fieldName,
            String newValue) throws Exception {

        if (userId <= 0 || ruleId <= 0) {
            throw new IllegalArgumentException("Invalid user or rule ID.");
        }

        if (fieldName == null || fieldName.trim().isEmpty()) {
            throw new IllegalArgumentException("Field name is required.");
        }

        if (newValue == null || newValue.trim().isEmpty()) {
            throw new IllegalArgumentException("New value is required.");
        }

        return pricingDAO.updatePricingRuleField(
                userId, ruleId, fieldName, newValue
        );
    }

    // EDIT all price and validity fields in one audited transaction.
    // Route and container type remain unchanged because the approved SRS procedure
    // only permits editing price values, multipliers and validity dates.
    public void editPricingRule(int userId, int ruleId,
            BigDecimal baseRate, BigDecimal ratePerKg, BigDecimal ratePerCbm,
            BigDecimal seasonMultiplier, BigDecimal demandMultiplier,
            Date validFrom, Date validTo) throws Exception {
        if (userId <= 0 || ruleId <= 0) {
            throw new IllegalArgumentException("Invalid user or pricing rule ID.");
        }
        if (baseRate == null || baseRate.signum() < 0
                || ratePerKg == null || ratePerKg.signum() < 0
                || ratePerCbm == null || ratePerCbm.signum() < 0) {
            throw new IllegalArgumentException("Rates must be zero or positive.");
        }
        if (seasonMultiplier == null || seasonMultiplier.signum() <= 0
                || demandMultiplier == null || demandMultiplier.signum() <= 0) {
            throw new IllegalArgumentException("Pricing multipliers must be positive.");
        }
        if (validFrom == null || (validTo != null && validTo.before(validFrom))) {
            throw new IllegalArgumentException("Select a valid pricing date range.");
        }
        this.baseRate = baseRate;
        this.ratePerKg = ratePerKg;
        this.ratePerCbm = ratePerCbm;
        this.seasonMultiplier = seasonMultiplier;
        this.demandMultiplier = demandMultiplier;
        this.validFrom = validFrom;
        this.validTo = validTo;
        pricingDAO.editPricingRule(userId, ruleId, this);
    }

    // Soft delete / archive: never remove the SRS pricing audit or historical rule.
    public void archivePricingRule(int userId, int sellerId, int ruleId) throws Exception {
        if (userId <= 0 || sellerId <= 0 || ruleId <= 0) {
            throw new IllegalArgumentException("Invalid seller or pricing rule ID.");
        }
        pricingDAO.archivePricingRule(userId, sellerId, ruleId);
    }

    // DEACTIVATE PRICING RULE
    public void deactivatePricingRule(
            int userId, int ruleId) throws Exception {

        if (userId <= 0 || ruleId <= 0) {
            throw new IllegalArgumentException("Invalid user or rule ID.");
        }

        pricingDAO.deactivatePricingRule(userId, ruleId);
    }

    // DISPLAY PRICING RULES
    public List<Map<String,Object>> searchPricingRules(int actor,int seller,String query)throws Exception {
        return pricingDAO.searchPricingRules(actor,seller,query);
    }
    public List<Map<String, Object>> getPricingRules(
            Integer sellerId) throws Exception {

        return pricingDAO.getPricingRules(sellerId);
    }

    // DISPLAY PRICING AUDIT
    public List<Map<String, Object>> getPricingAudit(
            Integer ruleId) throws Exception {

        if (ruleId != null && ruleId <= 0) {
            throw new IllegalArgumentException("Invalid pricing rule ID.");
        }

        return pricingDAO.getPricingAudit(ruleId);
    }

    private void validate() {

        if (originPortId <= 0 || destPortId <= 0
                || originPortId == destPortId) {
            throw new IllegalArgumentException(
                    "Select valid different ports.");
        }

        if (containerType == null || containerType.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Container type is required.");
        }

        if (baseRate == null || baseRate.signum() < 0
                || ratePerKg == null || ratePerKg.signum() < 0
                || ratePerCbm == null || ratePerCbm.signum() < 0) {
            throw new IllegalArgumentException("Invalid pricing rates.");
        }

        if (seasonMultiplier == null || seasonMultiplier.signum() <= 0
                || demandMultiplier == null || demandMultiplier.signum() <= 0) {
            throw new IllegalArgumentException(
                    "Multipliers must be positive.");
        }

        if (validFrom == null) {
            throw new IllegalArgumentException(
                    "Valid-from date is required.");
        }

        if (validTo != null && validTo.before(validFrom)) {
            throw new IllegalArgumentException(
                    "Invalid pricing date range.");
        }
    }

    // GETTERS AND SETTERS

    public int getRuleId() {
        return ruleId;
    }

    public void setRuleId(int ruleId) {
        this.ruleId = ruleId;
    }

    public int getOriginPortId() {
        return originPortId;
    }

    public void setOriginPortId(int id) {
        this.originPortId = id;
    }

    public int getDestPortId() {
        return destPortId;
    }

    public void setDestPortId(int id) {
        this.destPortId = id;
    }

    public String getContainerType() {
        return containerType;
    }

    public void setContainerType(String type) {
        this.containerType = type;
    }

    public BigDecimal getBaseRate() {
        return baseRate;
    }

    public void setBaseRate(BigDecimal rate) {
        this.baseRate = rate;
    }

    public BigDecimal getRatePerKg() {
        return ratePerKg;
    }

    public void setRatePerKg(BigDecimal rate) {
        this.ratePerKg = rate;
    }

    public BigDecimal getRatePerCbm() {
        return ratePerCbm;
    }

    public void setRatePerCbm(BigDecimal rate) {
        this.ratePerCbm = rate;
    }

    public BigDecimal getSeasonMultiplier() {
        return seasonMultiplier;
    }

    public void setSeasonMultiplier(BigDecimal value) {
        this.seasonMultiplier = value;
    }

    public BigDecimal getDemandMultiplier() {
        return demandMultiplier;
    }

    public void setDemandMultiplier(BigDecimal value) {
        this.demandMultiplier = value;
    }

    public Date getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(Date date) {
        this.validFrom = date;
    }

    public Date getValidTo() {
        return validTo;
    }

    public void setValidTo(Date date) {
        this.validTo = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
