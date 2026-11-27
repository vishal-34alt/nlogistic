package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ClaimDocument implements Serializable {
    private static final long serialVersionUID = 1L;

    private int cdocId;
    private int claimId;
    private String fileName;
    private String filePath;
    private String fileType;
    private Timestamp uploadedAt;

    public ClaimDocument() {}

    public int getCdocId() { return cdocId; }
    public void setCdocId(int cdocId) { this.cdocId = cdocId; }

    public int getClaimId() { return claimId; }
    public void setClaimId(int claimId) { this.claimId = claimId; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}