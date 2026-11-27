package model;

import java.util.List;
import operations.ClaimDocumentOperations;
import implementor.ClaimDocumentImplementor;

public class ClaimDocumentActions {
    private final ClaimDocumentOperations documentDAO = new ClaimDocumentImplementor();

    public int addDocument(int claimId, int userId, String fileName, String filePath, String fileType) throws Exception {
        return documentDAO.addClaimDocument(claimId, userId, fileName, filePath, fileType);
    }

    public void updateDocument(int userId, int cdocId, String fieldName, String newValue) throws Exception {
        documentDAO.updateClaimDocument(userId, cdocId, fieldName, newValue);
    }

    public void deleteDocument(int userId, int cdocId) throws Exception {
        documentDAO.deleteClaimDocument(userId, cdocId);
    }

    public List<ClaimDocument> getDocuments(int claimId, int userId) throws Exception {
        return documentDAO.getDocumentsByClaimId(claimId, userId);
    }
}