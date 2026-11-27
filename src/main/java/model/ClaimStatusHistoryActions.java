package model;

import java.util.List;
import operations.ClaimStatusHistoryOperations;
import implementor.ClaimStatusHistoryImplementor;

public class ClaimStatusHistoryActions {
    private final ClaimStatusHistoryOperations historyDAO = new ClaimStatusHistoryImplementor();

    public void addComment(int claimId, int userId, String comment) throws Exception {
        if (comment == null || comment.trim().isEmpty()) {
            throw new IllegalArgumentException("Comment cannot be empty.");
        }
        if (comment.length() > 255) {
            throw new IllegalArgumentException("Comments cannot exceed 255 characters.");
        }
        historyDAO.addClaimComment(claimId, userId, comment);
    }

    public List<ClaimStatusHistory> getHistory(int claimId, int userId) throws Exception {
        return historyDAO.getHistoryByClaimId(claimId, userId);
    }
}