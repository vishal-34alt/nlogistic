package operations;

import java.math.BigDecimal;
import java.util.List;
import model.Claim;
import model.ClaimShipmentOption;
import model.ClaimStockOption;

public interface ClaimOperations {
    /** Returns the ID returned directly by sp_submit_claim (never guess from search order). */
    int submitClaim(int userId, int shipmentId, String claimType, String description,
                    BigDecimal claimedAmount, int claimWindowDays) throws Exception;
    void updateClaimField(int userId, int claimId, String fieldName, String newValue) throws Exception;
    void deleteClaim(int claimId, int userId) throws Exception;
    List<Claim> searchClaims(int userId, String status) throws Exception;
    Claim getClaimById(int claimId, int userId) throws Exception;
    void reviewClaim(int claimId, int userId, String decision, BigDecimal approvedAmount, String remarks) throws Exception;
    void settleClaim(int claimId, int userId, Integer stockId, Integer quantity, String remarks) throws Exception;
    List<ClaimShipmentOption> getEligibleShipments(int userId, int windowDays) throws Exception;
    /** For the form: show owned ARRIVED/DELIVERED shipments and explain unavailable ones. */
    List<ClaimShipmentOption> getClaimCandidateShipments(int userId, int windowDays) throws Exception;
    List<ClaimStockOption> getShipmentStock(int userId, int shipmentId) throws Exception;
}
