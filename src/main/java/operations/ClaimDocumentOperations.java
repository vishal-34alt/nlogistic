package operations;

import java.util.List;
import model.ClaimDocument;

public interface ClaimDocumentOperations {
    int addClaimDocument(int claimId, int userId, String fileName, String filePath, String fileType) throws Exception;
    void updateClaimDocument(int userId, int cdocId, String fieldName, String newValue) throws Exception;
    void deleteClaimDocument(int userId, int cdocId) throws Exception;
    List<ClaimDocument> getDocumentsByClaimId(int claimId, int userId) throws Exception;
}