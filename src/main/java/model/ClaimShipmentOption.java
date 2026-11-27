package model;

import java.math.BigDecimal;
import java.sql.Date;

/** Read-only, Consumer-scoped context for the claim form. No database schema changes. */
public final class ClaimShipmentOption {
    private final int shipmentId;
    private final String shipmentNo;
    private final String status;
    private final Date actualArrival;
    private final boolean selectable;
    private final String ineligibilityReason;
    private final BigDecimal cargoValue;
    private final BigDecimal bookingQuote;
    private final BigDecimal invoiceTotal;
    private final Integer cargoUnits;
    private final String originName;
    private final String destinationName;
    private final String sellerName;
    private final String containerNumber;

    public ClaimShipmentOption(int shipmentId, String shipmentNo, String status, Date actualArrival) {
        this(shipmentId, shipmentNo, status, actualArrival, true, null);
    }

    public ClaimShipmentOption(int shipmentId, String shipmentNo, String status, Date actualArrival,
                               boolean selectable, String ineligibilityReason) {
        this(shipmentId, shipmentNo, status, actualArrival, selectable, ineligibilityReason,
             null, null, null, null, null, null, null, null);
    }

    public ClaimShipmentOption(int shipmentId, String shipmentNo, String status, Date actualArrival,
                               boolean selectable, String ineligibilityReason, BigDecimal cargoValue,
                               BigDecimal bookingQuote, BigDecimal invoiceTotal, Integer cargoUnits,
                               String originName, String destinationName, String sellerName,
                               String containerNumber) {
        this.shipmentId = shipmentId;
        this.shipmentNo = shipmentNo;
        this.status = status;
        this.actualArrival = actualArrival;
        this.selectable = selectable;
        this.ineligibilityReason = ineligibilityReason;
        this.cargoValue = cargoValue;
        this.bookingQuote = bookingQuote;
        this.invoiceTotal = invoiceTotal;
        this.cargoUnits = cargoUnits;
        this.originName = originName;
        this.destinationName = destinationName;
        this.sellerName = sellerName;
        this.containerNumber = containerNumber;
    }

    public int getShipmentId() { return shipmentId; }
    public String getShipmentNo() { return shipmentNo; }
    public String getStatus() { return status; }
    public Date getActualArrival() { return actualArrival; }
    public boolean isSelectable() { return selectable; }
    public String getIneligibilityReason() { return ineligibilityReason; }
    /** Sum of shipment_items.amount; merchandise value, not a claims entitlement. */
    public BigDecimal getCargoValue() { return cargoValue; }
    public BigDecimal getBookingQuote() { return bookingQuote; }
    public BigDecimal getInvoiceTotal() { return invoiceTotal; }
    public Integer getCargoUnits() { return cargoUnits; }
    public String getOriginName() { return originName; }
    public String getDestinationName() { return destinationName; }
    public String getSellerName() { return sellerName; }
    public String getContainerNumber() { return containerNumber; }
}
