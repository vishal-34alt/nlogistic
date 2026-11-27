
package model;

import java.math.BigDecimal;
import java.util.List;

import operations.ContainerOperations;
import implementor.ContainerImplementor;

public class Container {

    // Container attributes
    private int containerId;
    private String containerNumber;
    private int sellerId;
    private String containerType;
    private int sizeFt;
    private BigDecimal maxWeightKg;
    private BigDecimal maxVolumeCbm;
    private int currentPortId;
    private String status;
    // Transient presentation state, never a database column.
    private boolean shipmentHistory;

    public boolean hasShipmentHistory(){ return shipmentHistory; }
    public void setShipmentHistory(boolean shipmentHistory){ this.shipmentHistory=shipmentHistory; }

    // DAO interface
    private ContainerOperations containerDAO;

    // Default constructor
    public Container() {
        this(new ContainerImplementor());
    }

    // Constructor with DAO injection
    public Container(ContainerOperations containerDAO) {

        if (containerDAO == null) {
            throw new IllegalArgumentException(
                    "Container DAO cannot be null.");
        }

        this.containerDAO = containerDAO;
    }

    // Insert a new container
    public int insertContainer() throws Exception {

        validateContainer();

        return containerDAO.insertContainer(this);
    }

    // Retrieve containers by seller
    public List<Container> getContainersBySeller(
            Integer sellerId) throws Exception {

        if (sellerId == null || sellerId <= 0) {
            throw new IllegalArgumentException(
                    "Valid seller ID is required.");
        }

        return containerDAO.getContainersBySeller(sellerId);
    }

    public java.util.List<Container> searchContainers(int actor,int seller,String q,String status)throws Exception{
        return containerDAO.searchContainers(actor,seller,q,status);
    }
    public void deleteEligibleContainer(int actor,int seller,int id)throws Exception{
        if(actor<=0||seller<=0||id<=0)throw new IllegalArgumentException("Invalid container identifiers");
        containerDAO.deleteEligibleContainer(actor,seller,id);
    }
    // Update a specific container field
    public Container updateContainerField(
            int userId,
            int containerId,
            String fieldName,
            String newValue,
            String ipAddress) throws Exception {

        if (userId <= 0 || containerId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid user or container ID.");
        }

        if (fieldName == null || fieldName.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Field name is required.");
        }

        if (newValue == null) {
            throw new IllegalArgumentException(
                    "New value is required.");
        }

        return containerDAO.updateContainerField(
                userId,
                containerId,
                fieldName,
                newValue,
                ipAddress
        );
    }

    // Validate container details
    private void validateContainer() {

        if (containerNumber == null ||
                containerNumber.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Container number is required.");
        }

        if (sellerId <= 0) {
            throw new IllegalArgumentException(
                    "Valid seller ID is required.");
        }

        if (containerType == null ||
                containerType.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Container type is required.");
        }

        if (sizeFt <= 0) {
            throw new IllegalArgumentException(
                    "Container size must be positive.");
        }

        if (maxWeightKg == null ||
                maxWeightKg.signum() <= 0) {
            throw new IllegalArgumentException(
                    "Maximum weight must be positive.");
        }

        if (maxVolumeCbm == null ||
                maxVolumeCbm.signum() <= 0) {
            throw new IllegalArgumentException(
                    "Maximum volume must be positive.");
        }

        if (currentPortId <= 0) {
            throw new IllegalArgumentException(
                    "Valid current port is required.");
        }
    }

    // Getters and setters

    public int getContainerId() {
        return containerId;
    }

    public void setContainerId(int containerId) {
        this.containerId = containerId;
    }

    public String getContainerNumber() {
        return containerNumber;
    }

    public void setContainerNumber(String containerNumber) {
        this.containerNumber = containerNumber;
    }

    public int getSellerId() {
        return sellerId;
    }

    public void setSellerId(int sellerId) {
        this.sellerId = sellerId;
    }

    public String getContainerType() {
        return containerType;
    }

    public void setContainerType(String containerType) {
        this.containerType = containerType;
    }

    public int getSizeFt() {
        return sizeFt;
    }

    public void setSizeFt(int sizeFt) {
        this.sizeFt = sizeFt;
    }

    public BigDecimal getMaxWeightKg() {
        return maxWeightKg;
    }

    public void setMaxWeightKg(BigDecimal maxWeightKg) {
        this.maxWeightKg = maxWeightKg;
    }

    public BigDecimal getMaxVolumeCbm() {
        return maxVolumeCbm;
    }

    public void setMaxVolumeCbm(BigDecimal maxVolumeCbm) {
        this.maxVolumeCbm = maxVolumeCbm;
    }

    public int getCurrentPortId() {
        return currentPortId;
    }

    public void setCurrentPortId(int currentPortId) {
        this.currentPortId = currentPortId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
