package model;

import implementor.MovementImplementor;
import operations.MovementOperations;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;

import java.util.Comparator;
import java.util.List;

/** Movement record plus business validation formerly placed in a service. */
public class ContainerMovementPojo {
    private static final MovementOperations DATA = new MovementImplementor();
    private long movementId;
    private int shipmentId, containerId;
    private Integer portId, updatedBy;
    private String status, locationText, remarks;
    private LocalDateTime eventTime;

    public List<ContainerMovementPojo> search(User user,Integer shipmentId,
                                               String status,LocalDate start,LocalDate end) throws SQLException {
        if(user==null) throw new SecurityException("Authentication required");
        if(status!=null && !status.isEmpty() && !ShipmentPojo.STATUSES.contains(status))
            throw new IllegalArgumentException("Unknown movement status");
        if(start!=null && end!=null && start.isAfter(end))
            throw new IllegalArgumentException("Start date must be on or before end date");
        return DATA.search(user.getUserId(),shipmentId,
            ShipmentPojo.trimToNull(status),start,end);
    }
    public List<ContainerMovementPojo> timeline(User user,int shipmentId) throws SQLException {
        if(shipmentId<=0)throw new IllegalArgumentException("Invalid shipment ID");
        List<ContainerMovementPojo> events=search(user,shipmentId,null,null,null);
        events.sort(Comparator.comparingLong(ContainerMovementPojo::getMovementId)); // Database considers highest movement ID the latest checkpoint
        return events;
    }
    public long add(User user,ShipmentPojo shipment,String newStatus,
                    Integer portId,String location,String remarks) throws SQLException {
        user.requireSeller();
        if(shipment==null)throw new IllegalArgumentException("Shipment was not found");
        if(!user.canUpdateShipment(shipment.getSellerId()))
            throw new SecurityException("Only the shipment Seller or Admin may update its movement");
        if(!shipment.getNextStatuses().contains(newStatus))
            throw new IllegalArgumentException("Invalid next status for "+shipment.getStatusLabel());
        String loc=location==null?"":location.trim();
        String msg=remarks==null?"":remarks.trim();
        if(loc.isEmpty()||loc.length()>150)
            throw new IllegalArgumentException("Enter a location (max 150 characters)");
        if(msg.length()>255)throw new IllegalArgumentException("Remarks cannot exceed 255 characters");
        if(portId!=null&&portId<=0)throw new IllegalArgumentException("Invalid port ID");
        ContainerMovementPojo event=new ContainerMovementPojo();
        event.setShipmentId(shipment.getShipmentId());
        event.setStatus(newStatus);
        event.setPortId(portId);
        event.setLocationText(loc);
        event.setRemarks(msg.isEmpty()?null:msg);
        event.setUpdatedBy(user.getUserId());
        // DB procedure uses NOW() and trigger enforces the transition atomically.
        return DATA.insert(event);
    }
    public void correctLatest(User user,long movementId,String reason) throws SQLException {
        user.requireSeller();
        if(movementId<=0)throw new IllegalArgumentException("Invalid movement event ID");
        if(reason==null||reason.trim().isEmpty()||reason.trim().length()>255)
            throw new IllegalArgumentException("Provide a correction reason (max 255 characters)");
        // Stored procedure enforces ownership, terminal-state rules, latest event,
        // claim lock, audit trail and rollback: never delete rows directly.
        DATA.deleteLatest(user.getUserId(),movementId,reason.trim());
    }
    /** Correct exactly one latest, non-terminal checkpoint for the owning Seller.
     *  The approved stored procedure rechecks these constraints atomically and audits the correction.
     *  Returns the prior checkpoint label for a visible success message.
     */
    public String correctLatest(User user, ShipmentPojo shipment, long movementId, String reason)
            throws SQLException {
        if (user == null) throw new SecurityException("Please sign in to correct a checkpoint");
        user.requireSeller();
        if (shipment == null || shipment.getShipmentId() <= 0)
            throw new IllegalArgumentException("Select the shipment whose checkpoint you want to correct");
        if (!user.canUpdateShipment(shipment.getSellerId()))
            throw new SecurityException("Only the owning Seller can undo a shipment checkpoint");
        if (shipment.isTerminal())
            throw new IllegalArgumentException("This shipment is closed. Its checkpoints cannot be undone");
        if (movementId <= 0)
            throw new IllegalArgumentException("Select a valid checkpoint to undo");
        if (reason == null || reason.trim().isEmpty() || reason.trim().length() > 255)
            throw new IllegalArgumentException("Enter a correction reason (up to 255 characters)");

        List<ContainerMovementPojo> history = timeline(user, shipment.getShipmentId());
        if (history.size() < 2)
            throw new IllegalArgumentException("The original booking checkpoint cannot be undone");
        ContainerMovementPojo latest = history.get(history.size() - 1);
        ContainerMovementPojo previous = history.get(history.size() - 2);
        if (latest.getMovementId() != movementId)
            throw new IllegalArgumentException("A newer checkpoint was recorded. Refresh the timeline and try again");
        if ("BOOKED".equals(latest.getStatus()) || "DELIVERED".equals(latest.getStatus())
                || "CANCELLED".equals(latest.getStatus()))
            throw new IllegalArgumentException("This checkpoint is protected and cannot be undone");
        if (!latest.getStatus().equals(shipment.getStatus()))
            throw new IllegalArgumentException("Shipment status changed. Refresh before correcting the checkpoint");

        DATA.deleteLatest(user.getUserId(), movementId, reason.trim());
        return previous.getStatusLabel();
    }
    public String getStatusLabel(){return status==null?"Unknown":status.replace('_',' ');}
    public long getMovementId(){return movementId;}
    public void setMovementId(long value){movementId=value;}
    public int getShipmentId(){return shipmentId;}
    public void setShipmentId(int value){shipmentId=value;}
    public int getContainerId(){return containerId;}
    public void setContainerId(int value){containerId=value;}
    public Integer getPortId(){return portId;}
    public void setPortId(Integer value){portId=value;}
    public Integer getUpdatedBy(){return updatedBy;}
    public void setUpdatedBy(Integer value){updatedBy=value;}
    public String getStatus(){return status;}
    public void setStatus(String value){status=value;}
    public String getLocationText(){return locationText;}
    public void setLocationText(String value){locationText=value;}
    public String getRemarks(){return remarks;}
    public void setRemarks(String value){remarks=value;}
    public LocalDateTime getEventTime(){return eventTime;}
    public void setEventTime(LocalDateTime value){eventTime=value;}
}
