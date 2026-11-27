package operations;

import java.util.List;
import model.ClaimStatusHistory;

public interface ClaimStatusHistoryOperations {
    void addClaimComment(int claimId, int userId, String comment) throws Exception;
    List<ClaimStatusHistory> getHistoryByClaimId(int claimId, int userId) throws Exception;
}