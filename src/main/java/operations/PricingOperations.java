
package operations;

import java.util.List;
import java.util.Map;

import model.PricingRule;

public interface PricingOperations {

    int insertPricingRule(
            int userId,
            int sellerId,
            PricingRule rule
    ) throws Exception;

    Map<String, Object> updatePricingRuleField(
            int userId,
            int ruleId,
            String fieldName,
            String newValue
    ) throws Exception;

    // Full pricing-only edit using the approved sp_update_pricing_rule procedure.
    void editPricingRule(int userId, int ruleId, PricingRule rule) throws Exception;

    // Delete from the seller's working directory without destroying pricing audit history.
    void archivePricingRule(int userId, int sellerId, int ruleId) throws Exception;

    void deactivatePricingRule(
            int userId,
            int ruleId
    ) throws Exception;

    List<Map<String, Object>> searchPricingRules(int actor,int seller,String query)throws Exception;
    List<Map<String, Object>> getPricingRules(
            Integer sellerId
    ) throws Exception;

    List<Map<String, Object>> getPricingAudit(
            Integer ruleId
    ) throws Exception;
}
