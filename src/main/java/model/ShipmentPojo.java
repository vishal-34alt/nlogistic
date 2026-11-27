package model;

import implementor.ShipmentImplementor;
import operations.ShipmentOperations;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/** Data + shipment domain behavior: no SQL, no Servlet objects, no service package. */
public class ShipmentPojo {
    private static final ShipmentOperations DATA = new ShipmentImplementor();
    public static final List<String> STATUSES = Collections.unmodifiableList(Arrays.asList(
        "BOOKED", "LOADED", "DEPARTED", "IN_TRANSIT", "ARRIVED", "CUSTOMS_CLEARED", "DELIVERED", "CANCELLED"));

    private int shipmentId, consumerId, sellerId;
    private Integer containerId, vesselId, originPortId, destPortId;
    private String shipmentNo, containerNumber, originPortName, destPortName, status, cargoDescription;
    private BigDecimal cargoWeightKg, cargoVolumeCbm, quotedPrice;
    private LocalDate etd, eta, actualArrival;
    // Enriched read-only booking details, loaded by ShipmentImplementor after an access check.
    private String consumerName, sellerCompanyName, vesselName, containerType;
    private String invoiceNo, invoiceStatus, latestEventStatus, latestEventLocation, latestEventRemarks;
    private java.math.BigDecimal invoiceTotal, invoicePaid;
    private String bookedAt, latestEventTime;
    private final List<CargoLine> cargoLines = new ArrayList<>();

    /** Delay reports use existing audit JSON; no new domain class or project file. */
    private final List<java.util.Map<String,String>> delayNotices = new ArrayList<>();
    public void addDelayNotice(LocalDate previousEta, LocalDate revisedEta,
                               String reason, String reportedAt) {
        java.util.Map<String,String> notice=new java.util.LinkedHashMap<>();
        notice.put("previous_eta",previousEta==null?"":previousEta.toString());
        notice.put("revised_eta",revisedEta==null?"":revisedEta.toString());
        notice.put("reason",reason==null?"":reason);
        notice.put("reported_at",reportedAt==null?"":reportedAt);
        delayNotices.add(Collections.unmodifiableMap(notice));
    }
    public List<java.util.Map<String,String>> getDelayNotices() { return Collections.unmodifiableList(delayNotices); }
    public java.util.Map<String,String> getLatestDelayNotice() { return delayNotices.isEmpty()?null:delayNotices.get(0); }
    public boolean hasReportedDelay() { return !delayNotices.isEmpty(); }
    public void clearDelayNotices() { delayNotices.clear(); }
    public boolean hasActiveDelayReport() { return hasReportedDelay() && !isTerminal(); }
    public boolean hasDelayAlert() { return isDelayed() || hasActiveDelayReport(); }
    private int totalBookedUnits;

    public static final class CargoLine {
        private final String sku, productName;
        private final int quantity;
        private final BigDecimal unitPrice, amount, weightKg, volumeCbm;
        public CargoLine(String sku, String productName, int quantity,
                BigDecimal unitPrice, BigDecimal amount, BigDecimal weightKg, BigDecimal volumeCbm) {
            this.sku=sku; this.productName=productName; this.quantity=quantity;
            this.unitPrice=unitPrice; this.amount=amount; this.weightKg=weightKg; this.volumeCbm=volumeCbm;
        }
        public String getSku() { return sku; }
        public String getProductName() { return productName; }
        public int getQuantity() { return quantity; }
        public BigDecimal getUnitPrice() { return unitPrice; }
        public BigDecimal getAmount() { return amount; }
        public BigDecimal getWeightKg() { return weightKg; }
        public BigDecimal getVolumeCbm() { return volumeCbm; }
    }
    public void addCargoLine(CargoLine line) { if(line!=null){cargoLines.add(line);totalBookedUnits+=line.getQuantity();} }
    public List<CargoLine> getCargoLines() { return Collections.unmodifiableList(cargoLines); }
    public int getTotalBookedUnits() { return totalBookedUnits; }
    public String getConsumerName() { return consumerName; }
    public void setConsumerName(String v) { consumerName=v; }
    public String getSellerCompanyName() { return sellerCompanyName; }
    public void setSellerCompanyName(String v) { sellerCompanyName=v; }
    public String getVesselName() { return vesselName; }
    public void setVesselName(String v) { vesselName=v; }
    public String getContainerType() { return containerType; }
    public void setContainerType(String v) { containerType=v; }
    public String getInvoiceNo() { return invoiceNo; }
    public void setInvoiceNo(String v) { invoiceNo=v; }
    public String getInvoiceStatus() { return invoiceStatus; }
    public void setInvoiceStatus(String v) { invoiceStatus=v; }
    public BigDecimal getInvoiceTotal() { return invoiceTotal; }
    public void setInvoiceTotal(BigDecimal v) { invoiceTotal=v; }
    public BigDecimal getInvoicePaid() { return invoicePaid; }
    public void setInvoicePaid(BigDecimal v) { invoicePaid=v; }
    public String getBookedAt() { return bookedAt; }
    public void setBookedAt(String v) { bookedAt=v; }
    public String getLatestEventTime() { return latestEventTime; }
    public void setLatestEventTime(String v) { latestEventTime=v; }
    public String getLatestEventStatus() { return latestEventStatus; }
    public void setLatestEventStatus(String v) { latestEventStatus=v; }
    public String getLatestEventLocation() { return latestEventLocation; }
    public void setLatestEventLocation(String v) { latestEventLocation=v; }
    public String getLatestEventRemarks() { return latestEventRemarks; }
    public void setLatestEventRemarks(String v) { latestEventRemarks=v; }


    public User verifiedUser(int id) throws SQLException {
        if (id <= 0) throw new SecurityException("Please sign in first");
        User u = DATA.findActiveUser(id);
        if (u == null) throw new SecurityException("Account is unavailable or inactive");
        return u;
    }
    public List<ShipmentPojo> search(User user, String container, Integer id,
                                      Integer port, String status) throws SQLException {
        requireUser(user);
        if (container != null && container.trim().length() > 15)
            throw new IllegalArgumentException("Container number is too long");
        if (status != null && !status.isEmpty() && !STATUSES.contains(status))
            throw new IllegalArgumentException("Unknown shipment status");
        return DATA.search(user.getUserId(), trimToNull(container), id, port, trimToNull(status));
    }
    public ShipmentPojo get(User user, int id) throws SQLException {
        if (id <= 0) throw new IllegalArgumentException("Invalid shipment ID");
        List<ShipmentPojo> results = search(user, null, id, null, null);
        if (results.isEmpty()) return null;
        ShipmentPojo result = results.get(0);
        DATA.enrichDetails(result);
        return result;
    }
    public List<PortPojo> listPorts(User user) throws SQLException {
        requireUser(user);
        return DATA.listPorts();
    }
    public void updateField(User user, int shipmentId, String field, String rawValue)
            throws SQLException {
        user.requireStaff();
        ShipmentPojo record = get(user, shipmentId);
        if (record == null) throw new IllegalArgumentException("Shipment not found");
        if (!user.canUpdateShipment(record.getSellerId())) throw new SecurityException("Shipment belongs to another Seller");
        if ("DELIVERED".equals(record.status) || "CANCELLED".equals(record.status))
            throw new IllegalArgumentException("Closed shipments cannot be edited");
        String value = rawValue == null ? "" : rawValue.trim();
        if ("cargo_description".equals(field)) {
            if (value.isEmpty() || value.length() > 255) throw new IllegalArgumentException("Enter a cargo description (max 255 characters)");
        } else if ("vessel_id".equals(field)) {
            if (!value.matches("[1-9][0-9]{0,9}")) throw new IllegalArgumentException("Enter a valid positive vessel ID");
        } else if ("eta".equals(field) || "etd".equals(field)) {
            try { LocalDate.parse(value); }
            catch (Exception ex) { throw new IllegalArgumentException("Date must be YYYY-MM-DD"); }
        } else {
            throw new IllegalArgumentException("Unsupported shipment field");
        }
        DATA.updateField(user.getUserId(), shipmentId, field, value);
    }
    /** Persist both expected dates together; date rules belong to the model. */
    public void updateSchedule(User user, int shipmentId, String etdText, String etaText)
            throws SQLException {
        user.requireSeller();
        ShipmentPojo record=get(user, shipmentId);
        if(record==null)throw new IllegalArgumentException("Shipment not found");
        if(!user.canUpdateShipment(record.getSellerId()))
            throw new SecurityException("Shipment belongs to another Seller");
        if(record.isTerminal())throw new IllegalArgumentException("Closed shipments cannot be rescheduled");
        LocalDate departure,arrival;
        try {
            departure=LocalDate.parse(etdText==null?"":etdText.trim());
            arrival=LocalDate.parse(etaText==null?"":etaText.trim());
        } catch(Exception ex) {
            throw new IllegalArgumentException("Choose both departure and arrival dates (YYYY-MM-DD)");
        }
        if(arrival.isBefore(departure))
            throw new IllegalArgumentException("Expected arrival cannot be earlier than expected departure");
        DATA.updateSchedule(user.getUserId(),shipmentId,departure,arrival);
    }

    /** Report a delay without changing the movement checkpoint/status. */
    public void reportDelay(User user, int shipmentId, String revisedEtaText, String delayReason)
            throws SQLException {
        user.requireSeller();
        ShipmentPojo record=get(user,shipmentId);
        if(record==null)throw new IllegalArgumentException("Shipment not found or access denied");
        if(!user.canUpdateShipment(record.getSellerId()))
            throw new SecurityException("Only the owning Seller can report a delay");
        if(record.isTerminal() || "ARRIVED".equals(record.status) || "CUSTOMS_CLEARED".equals(record.status))
            throw new IllegalArgumentException("Delay reports are only available before arrival");
        if(record.eta==null)throw new IllegalArgumentException("Save an original expected arrival date first");
        LocalDate revised;
        try { revised=LocalDate.parse(revisedEtaText==null?"":revisedEtaText.trim()); }
        catch(Exception ex) { throw new IllegalArgumentException("Choose a valid revised arrival date (YYYY-MM-DD)"); }
        if(!revised.isAfter(record.eta))
            throw new IllegalArgumentException("Revised arrival must be later than the current ETA ("+record.eta+")");
        if(record.etd!=null&&revised.isBefore(record.etd))
            throw new IllegalArgumentException("Revised arrival cannot be before departure");
        String reason=delayReason==null?"":delayReason.trim().replaceAll("\\s+"," ");
        if(reason.length()<10 || reason.length()>255)
            throw new IllegalArgumentException("Provide a delay reason between 10 and 255 characters");
        DATA.reportDelay(user.getUserId(),shipmentId,revised,reason);
    }
    public List<String> getNextStatuses() {
        if (status == null) return Collections.emptyList();
        List<String> next = new ArrayList<>();
        switch (status) {
            case "BOOKED": next.add("LOADED"); next.add("CANCELLED"); break;
            case "LOADED": next.add("DEPARTED"); next.add("CANCELLED"); break;
            case "DEPARTED": next.add("IN_TRANSIT"); break;
            case "IN_TRANSIT": next.add("ARRIVED"); break;
            case "ARRIVED": next.add("CUSTOMS_CLEARED"); break;
            case "CUSTOMS_CLEARED": next.add("DELIVERED"); break;
            default: break;
        }
        return next;
    }
    /** Presentation-ready status sequence; CANCELLED remains a separate terminal branch. */
    public static final class ProgressStep {
        private final String code,label;
        private final boolean completed,current;
        public ProgressStep(String code,String label,boolean completed,boolean current){
            this.code=code;this.label=label;this.completed=completed;this.current=current;
        }
        public String getCode(){return code;}
        public String getLabel(){return label;}
        public boolean isCompleted(){return completed;}
        public boolean isCurrent(){return current;}
    }
    public List<ProgressStep> getProgressSteps() {
        List<String> route=STATUSES.subList(0,7);
        int currentIndex=route.indexOf(status);
        List<ProgressStep> progress=new ArrayList<>();
        for(int i=0;i<route.size();i++) {
            String code=route.get(i);
            progress.add(new ProgressStep(code,code.replace('_',' '),currentIndex>=0&&i<currentIndex,currentIndex>=0&&i==currentIndex));
        }
        return progress;
    }
    public boolean isDelayed() {
        if (eta == null || "CANCELLED".equals(status)) return false;
        if (actualArrival != null) return actualArrival.isAfter(eta);
        return !"DELIVERED".equals(status) && LocalDate.now().isAfter(eta);
    }
    public boolean isTerminal() { return "DELIVERED".equals(status) || "CANCELLED".equals(status); }
    public String getStatusLabel() { return status == null ? "Unknown" : status.replace('_', ' '); }
    /** Short, nontechnical context for shipment status on the management cards. */
    public String getStatusSummary() {
        if (status == null) return "Status information is not yet available";
        switch (status) {
            case "BOOKED": return "Booking confirmed; awaiting collection";
            case "LOADED": return "Cargo loaded and ready for departure";
            case "DEPARTED": return "Shipment has left its origin port";
            case "IN_TRANSIT": return "Shipment is travelling to its destination";
            case "ARRIVED": return "Shipment arrived at the destination port";
            case "CUSTOMS_CLEARED": return "Customs cleared; delivery is next";
            case "DELIVERED": return "Delivery completed";
            case "CANCELLED": return "This booking was cancelled";
            default: return "View tracking for the latest updates";
        }
    }

    /** 1..7 for the normal delivery journey; zero for cancelled/unknown. */
    public int getProgressStepNumber() {
        int index = STATUSES.subList(0, 7).indexOf(status);
        return index >= 0 ? index + 1 : 0;
    }
    private static void requireUser(User user) {
        if (user == null) throw new SecurityException("Authentication required");
    }
    public static String trimToNull(String s) { return s == null || s.trim().isEmpty() ? null : s.trim(); }

    public int getShipmentId() { return shipmentId; }
    public void setShipmentId(int value) { shipmentId = value; }
    public int getConsumerId() { return consumerId; }
    public void setConsumerId(int value) { consumerId = value; }
    public int getSellerId() { return sellerId; }
    public void setSellerId(int value) { sellerId = value; }
    public Integer getContainerId() { return containerId; }
    public void setContainerId(Integer value) { containerId = value; }
    public Integer getVesselId() { return vesselId; }
    public void setVesselId(Integer value) { vesselId = value; }
    public Integer getOriginPortId() { return originPortId; }
    public void setOriginPortId(Integer value) { originPortId = value; }
    public Integer getDestPortId() { return destPortId; }
    public void setDestPortId(Integer value) { destPortId = value; }
    public String getShipmentNo() { return shipmentNo; }
    public void setShipmentNo(String value) { shipmentNo = value; }
    public String getContainerNumber() { return containerNumber; }
    public void setContainerNumber(String value) { containerNumber = value; }
    public String getOriginPortName() { return originPortName; }
    public void setOriginPortName(String value) { originPortName = value; }
    public String getDestPortName() { return destPortName; }
    public void setDestPortName(String value) { destPortName = value; }
    public String getStatus() { return status; }
    public void setStatus(String value) { status = value; }
    public String getCargoDescription() { return cargoDescription; }
    public void setCargoDescription(String value) { cargoDescription = value; }
    public BigDecimal getCargoWeightKg() { return cargoWeightKg; }
    public void setCargoWeightKg(BigDecimal value) { cargoWeightKg = value; }
    public BigDecimal getCargoVolumeCbm() { return cargoVolumeCbm; }
    public void setCargoVolumeCbm(BigDecimal value) { cargoVolumeCbm = value; }
    public BigDecimal getQuotedPrice() { return quotedPrice; }
    public void setQuotedPrice(BigDecimal value) { quotedPrice = value; }
    public LocalDate getEtd() { return etd; }
    public void setEtd(LocalDate value) { etd = value; }
    public LocalDate getEta() { return eta; }
    public void setEta(LocalDate value) { eta = value; }
    public LocalDate getActualArrival() { return actualArrival; }
    public void setActualArrival(LocalDate value) { actualArrival = value; }
}
