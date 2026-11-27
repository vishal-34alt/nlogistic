package model;

import java.math.BigDecimal;
/** Read-only Port / Vessel directory record. No database code in JSPs. */
public final class InfrastructureRecord {
    private final int id;
    private final String code, name, city, country, status, ownerName;
    private final Integer ownerCompanyId, capacityTeu;
    private final BigDecimal latitude, longitude;
    private final String location;
    private int activeShipmentCount;
    private int totalShipmentCount;

    public InfrastructureRecord(int id, String code, String name, String location, String status) {
        this(id, code, name, null, null, null, null, status, null, null, null, location);
    }
    private InfrastructureRecord(int id, String code, String name, String city, String country,
            BigDecimal latitude, BigDecimal longitude, String status, Integer ownerCompanyId,
            String ownerName, Integer capacityTeu, String location) {
        this.id=id; this.code=code; this.name=name; this.city=city; this.country=country;
        this.latitude=latitude; this.longitude=longitude; this.status=status;
        this.ownerCompanyId=ownerCompanyId; this.ownerName=ownerName; this.capacityTeu=capacityTeu;
        this.location=location;
    }
    public static InfrastructureRecord port(int id, String code, String name, String city,
            String country, BigDecimal latitude, BigDecimal longitude) {
        String location=(city==null ? "" : city) + ((city!=null && !city.isEmpty() && country!=null && !country.isEmpty()) ? ", " : "") + (country==null ? "" : country);
        return new InfrastructureRecord(id, code, name, city, country, latitude, longitude,
                null, null, null, null, location);
    }
    public static InfrastructureRecord vessel(int id, String imo, String name, Integer ownerId,
            String ownerName, Integer capacityTeu, String status) {
        return new InfrastructureRecord(id, imo, name, null, null, null, null, status,
                ownerId, ownerName, capacityTeu, ownerName==null ? "Unassigned" : ownerName);
    }
    public int getActiveShipmentCount(){return activeShipmentCount;}
    public int getTotalShipmentCount(){return totalShipmentCount;}
    public void setTotalShipmentCount(int count){totalShipmentCount=Math.max(0,count);}
    public void setActiveShipmentCount(int count){activeShipmentCount=Math.max(0,count);}
    public int getId(){return id;}
    public String getCode(){return code;}
    public String getName(){return name;}
    public String getLocation(){return location;}
    public String getStatus(){return status;}
    public String getCity(){return city;}
    public String getCountry(){return country;}
    public BigDecimal getLatitude(){return latitude;}
    public BigDecimal getLongitude(){return longitude;}
    public Integer getOwnerCompanyId(){return ownerCompanyId;}
    public String getOwnerName(){return ownerName;}
    public Integer getCapacityTeu(){return capacityTeu;}
}
