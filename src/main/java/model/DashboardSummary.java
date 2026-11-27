package model;
import java.math.BigDecimal;
import java.util.*;
/** Role-scoped overview numbers. Values only originate from actual DB rows. */
public final class DashboardSummary {
    private int activeShipments,openInvoices,openClaims,availableContainers;
    private int registeredUsers, registeredCompanies, registeredCustomers, registeredPorts, registeredVessels, maintenanceVessels, auditEvents;
    public int getRegisteredUsers(){return registeredUsers;}
    public void setRegisteredUsers(int n){registeredUsers=n;}
    public int getRegisteredCompanies(){return registeredCompanies;}
    public void setRegisteredCompanies(int n){registeredCompanies=n;}
    public int getRegisteredCustomers(){return registeredCustomers;}
    public void setRegisteredCustomers(int n){registeredCustomers=n;}
    public int getRegisteredPorts(){return registeredPorts;}
    public void setRegisteredPorts(int n){registeredPorts=n;}
    public int getRegisteredVessels(){return registeredVessels;}
    public void setRegisteredVessels(int n){registeredVessels=n;}
    public int getMaintenanceVessels(){return maintenanceVessels;}
    public void setMaintenanceVessels(int n){maintenanceVessels=n;}
    public int getAuditEvents(){return auditEvents;}
    public void setAuditEvents(int n){auditEvents=n;}
    public int getAvailableContainers(){return availableContainers;}
    public void setAvailableContainers(int value){availableContainers=value;}
    private BigDecimal recordedPayments=BigDecimal.ZERO;
    private final Map<String,Integer> shipmentStatuses=new LinkedHashMap<>();
    private final List<String> recentActions=new ArrayList<>();
    public int getActiveShipments(){return activeShipments;}
    public void setActiveShipments(int value){activeShipments=value;}
    public int getOpenInvoices(){return openInvoices;}
    public void setOpenInvoices(int value){openInvoices=value;}
    public int getOpenClaims(){return openClaims;}
    public void setOpenClaims(int value){openClaims=value;}
    public BigDecimal getRecordedPayments(){return recordedPayments;}
    public void setRecordedPayments(BigDecimal value){recordedPayments=value==null?BigDecimal.ZERO:value;}
    public Map<String,Integer> getShipmentStatuses(){return shipmentStatuses;}
    public List<String> getRecentActions(){return recentActions;}
}
