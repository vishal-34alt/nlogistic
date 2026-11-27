
package model;

public class AuditLog {

    private long logId;
    private Integer userId;
    private String action;
    private String tableName;
    private Long recordId;
    private String oldValue;
    private String newValue;
    private String ipAddress;
    private String actorName;

    // Default Constructor
    public AuditLog() {
    }

    // Parameterized Constructor
    public AuditLog(long logId, Integer userId, String action,
                    String tableName, Long recordId,
                    String oldValue, String newValue,
                    String ipAddress) {

        this.logId = logId;
        this.userId = userId;
        this.action = action;
        this.tableName = tableName;
        this.recordId = recordId;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.ipAddress = ipAddress;
    }

    // Getters and Setters

    public long getLogId() {
        return logId;
    }

    public void setLogId(long logId) {
        this.logId = logId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public Long getRecordId() {
        return recordId;
    }

    public void setRecordId(Long recordId) {
        this.recordId = recordId;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void setOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    /** Display-only name resolved in the implementation layer; the audit record itself stays immutable. */
    public String getActorName(){ return actorName; }
    public void setActorName(String name){ this.actorName=name; }

    // Business Validation Methods

    public boolean isValidAuditLog() {
        return action != null && !action.trim().isEmpty();
    }

    public boolean hasUser() {
        return userId != null && userId > 0;
    }

    public boolean isValidLogId() {
        return logId > 0;
    }
}
