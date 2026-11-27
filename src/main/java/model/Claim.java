package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class Claim implements Serializable {
    private static final long serialVersionUID = 1L;

    private int claimId;
    private String claimNo;
    private int shipmentId;
    private String shipmentNo;
    private Integer containerId;
    private int consumerId;
    private String claimType; // LOSS, DAMAGE, DELAY, SHORTAGE
    private String description;
    private BigDecimal claimedAmount;
    private BigDecimal approvedAmount;
    private String status;    // SUBMITTED, UNDER_REVIEW, APPROVED, PARTIALLY_APPROVED, REJECTED, SETTLED
    private String sellerRemarks;
    private Timestamp raisedAt;
    private Timestamp settledAt;

    public Claim() {}

    public int getClaimId() { return claimId; }
    public void setClaimId(int claimId) { this.claimId = claimId; }

    public String getClaimNo() { return claimNo; }
    public void setClaimNo(String claimNo) { this.claimNo = claimNo; }

    public int getShipmentId() { return shipmentId; }
    public void setShipmentId(int shipmentId) { this.shipmentId = shipmentId; }

    public String getShipmentNo() { return shipmentNo; }
    public void setShipmentNo(String shipmentNo) { this.shipmentNo = shipmentNo; }

    public Integer getContainerId() { return containerId; }
    public void setContainerId(Integer containerId) { this.containerId = containerId; }

    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int consumerId) { this.consumerId = consumerId; }

    public String getClaimType() { return claimType; }
    public void setClaimType(String claimType) { this.claimType = claimType; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getClaimedAmount() { return claimedAmount; }
    public void setClaimedAmount(BigDecimal claimedAmount) { this.claimedAmount = claimedAmount; }

    public BigDecimal getApprovedAmount() { return approvedAmount; }
    public void setApprovedAmount(BigDecimal approvedAmount) { this.approvedAmount = approvedAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSellerRemarks() { return sellerRemarks; }
    public void setSellerRemarks(String sellerRemarks) { this.sellerRemarks = sellerRemarks; }

    public Timestamp getRaisedAt() { return raisedAt; }
    public void setRaisedAt(Timestamp raisedAt) { this.raisedAt = raisedAt; }

    public Timestamp getSettledAt() { return settledAt; }
    public void setSettledAt(Timestamp settledAt) { this.settledAt = settledAt; }
}