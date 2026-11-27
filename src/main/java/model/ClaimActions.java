package model;

import java.math.BigDecimal;
import java.util.List;
import operations.ClaimOperations;
import implementor.ClaimImplementor;

public final class ClaimActions {
    /** Set -Dnlogistic.claim.window.days=45 on Tomcat; no schema changes. */
    public int windowDays(){
        String raw=System.getProperty("nlogistic.claim.window.days", "30");
        try {int days=Integer.parseInt(raw);if(days>=1&&days<=365)return days;}catch(NumberFormatException ignored){}
        throw new IllegalStateException("Invalid nlogistic.claim.window.days; expected 1 to 365");
    }
    private final ClaimOperations claimDAO = new ClaimImplementor();

    public int submitClaim(int userId, int shipmentId, String claimType, String description,
                           BigDecimal claimedAmount, int claimWindowDays) throws Exception {
        if (claimedAmount == null || claimedAmount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Claimed amount must be greater than zero.");
        }
        if (claimedAmount.scale() > 2 || claimedAmount.precision() > 12) {
            throw new IllegalArgumentException("Enter an amount with up to 10 digits and 2 decimal places.");
        }
        if (description == null || description.trim().isEmpty()) {
            throw new IllegalArgumentException("Description is required.");
        }
        if (claimType == null || !("LOSS".equals(claimType) || "DAMAGE".equals(claimType)
                || "DELAY".equals(claimType) || "SHORTAGE".equals(claimType))) {
            throw new IllegalArgumentException("Choose a valid claim type.");
        }
        return claimDAO.submitClaim(userId, shipmentId, claimType, description, claimedAmount, claimWindowDays);
    }
    public void updateClaimField(int userId, int claimId, String fieldName, String newValue) throws Exception {
        if (!"description".equals(fieldName) && !"claim_type".equals(fieldName)
                && !"claimed_amount".equals(fieldName) && !"container_id".equals(fieldName))
            throw new IllegalArgumentException("This claim field cannot be edited.");
        Claim current=claimDAO.getClaimById(claimId, userId);
        if(current==null)throw new SecurityException("Claim is unavailable for this user.");
        if(!"SUBMITTED".equals(current.getStatus()))
            throw new IllegalStateException("Only submitted claims can be edited.");
        if(newValue==null || newValue.trim().isEmpty())
            throw new IllegalArgumentException("An updated value is required.");
        if("description".equals(fieldName) && newValue.length()>10000)
            throw new IllegalArgumentException("Description is too long.");
        if("claim_type".equals(fieldName) && !("LOSS".equals(newValue)||"DAMAGE".equals(newValue)||"DELAY".equals(newValue)||"SHORTAGE".equals(newValue)))
            throw new IllegalArgumentException("Invalid claim type.");
        if("claimed_amount".equals(fieldName)){
            BigDecimal amt;
            try{amt=new BigDecimal(newValue);}catch(NumberFormatException ex){throw new IllegalArgumentException("Enter a valid claimed amount.");}
            if(amt.signum()<=0||amt.scale()>2||amt.precision()>12)throw new IllegalArgumentException("Invalid claimed amount.");
        }
        claimDAO.updateClaimField(userId, claimId, fieldName, newValue);
    }
    /** Withdraw an unreviewed claim from all active views, retaining protected history. */
    public void deleteClaim(int claimId, int userId) throws Exception {
        Claim current=claimDAO.getClaimById(claimId,userId);
        if(current==null||!"SUBMITTED".equals(current.getStatus()))
            throw new IllegalArgumentException("Only your submitted, unreviewed claim can be deleted.");
        claimDAO.deleteClaim(claimId,userId);
    }
    public List<Claim> searchClaims(int userId, String status) throws Exception { return claimDAO.searchClaims(userId, status); }
    public Claim getClaimById(int claimId, int userId) throws Exception { return claimDAO.getClaimById(claimId, userId); }
    public void reviewClaim(int claimId, int userId, String decision, BigDecimal approvedAmount, String remarks) throws Exception {
        if (remarks == null || remarks.trim().isEmpty()) throw new IllegalArgumentException("A reason for the decision is required.");
        claimDAO.reviewClaim(claimId, userId, decision, approvedAmount, remarks);
    }
    public void settleClaim(int claimId, int userId, Integer stockId, Integer quantity, String remarks) throws Exception {
        claimDAO.settleClaim(claimId, userId, stockId, quantity, remarks);
    }
    public List<ClaimShipmentOption> getEligibleShipments(int userId, int windowDays) throws Exception {
        return claimDAO.getEligibleShipments(userId, windowDays);
    }
    public List<ClaimShipmentOption> getClaimCandidateShipments(int userId, int windowDays) throws Exception {
        return claimDAO.getClaimCandidateShipments(userId, windowDays);
    }
    public List<ClaimStockOption> getShipmentStock(int userId, int shipmentId) throws Exception {
        return claimDAO.getShipmentStock(userId, shipmentId);
    }
}
