package model;

import implementor.InfrastructureImplementor;
import operations.InfrastructureOperations;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

/** Business validation for Admin port and vessel administration. */
public final class InfrastructureActions {
    private final InfrastructureOperations operations = new InfrastructureImplementor();
    public List<InfrastructureRecord> ports(int actor) throws SQLException {return operations.ports(actor);}
    public List<InfrastructureRecord> vessels(int actor) throws SQLException {return operations.vessels(actor);}
    public List<Company> sellers(int actor) throws SQLException {return operations.sellerCompanies(actor);}

    public void addPort(int actor,String code,String name,String city,String country) throws SQLException {
        addPort(actor,code,name,city,country,"","");
    }
    public void addPort(int actor,String code,String name,String city,String country,String lat,String lon) throws SQLException {
        checkPort(code,name,city,country,lat,lon);
        operations.createPortWithCoordinates(actor,code.trim().toUpperCase(java.util.Locale.ROOT),name.trim(),
            nullIfBlank(city),nullIfBlank(country),lat,lon);
    }
    public void updatePortDetails(int actor,int id,String code,String name,String city,String country,
                                  String lat,String lon) throws SQLException {
        if(id<=0)throw new IllegalArgumentException("Choose a port to edit.");
        checkPort(code,name,city,country,lat,lon);
        operations.updatePortDetails(actor,id,code.trim().toUpperCase(java.util.Locale.ROOT),name.trim(),
            nullIfBlank(city),nullIfBlank(country),lat,lon);
    }
    private void checkPort(String code,String name,String city,String country,String lat,String lon) {
        if(empty(code) || !code.trim().matches("[A-Za-z0-9]{2,10}"))
            throw new IllegalArgumentException("Port code must be 2–10 letters or numbers (for example INBOM).");
        if(empty(name) || name.trim().length()>100) throw new IllegalArgumentException("Enter a port name (up to 100 characters).");
        if(len(city)>60 || len(country)>60) throw new IllegalArgumentException("City and country must each fit within 60 characters.");
        checkCoordinate("latitude",lat);checkCoordinate("longitude",lon);
    }
    private void checkCoordinate(String field,String input) {
        if(empty(input))return;
        try {
            BigDecimal n=new BigDecimal(input.trim());
            BigDecimal bound=new BigDecimal(field.equals("latitude")?"90":"180");
            if(n.scale()>6 || n.abs().compareTo(bound)>0)throw new IllegalArgumentException(
              "Enter a valid "+field+" (up to six decimal places).");
        }catch(NumberFormatException ex){throw new IllegalArgumentException("Enter a valid "+field+" number.");}
    }
    public void editPort(int actor,int id,String field,String value) throws SQLException {
        if(id<=0 || !Arrays.asList("port_code","port_name","city","country","latitude","longitude").contains(field))
            throw new IllegalArgumentException("Choose a valid port field.");
        if("latitude".equals(field)||"longitude".equals(field)) checkCoordinate(field,value);
        else if(empty(value))throw new IllegalArgumentException("The updated port value cannot be blank.");
        operations.updatePort(actor,id,field,value);
    }
    public void deletePort(int actor,int id) throws SQLException {
        if(id<=0)throw new IllegalArgumentException("Choose a port.");operations.deletePort(actor,id);
    }
    public void addVessel(int actor,String name,String imo,Integer owner,Integer capacity) throws SQLException {
        checkVessel(name,imo,capacity);
        operations.createVessel(actor,name.trim(),nullIfBlank(imo),owner,capacity);
    }
    /** One business operation creates the Seller and Vessel together, or neither. */
    public void addVesselWithNewSeller(int actor,String vesselName,String imo,Integer capacity,
                String companyName,String gst,String iec,String address,String city,String country) throws SQLException {
        checkVessel(vesselName,imo,capacity);
        if(empty(companyName)||companyName.trim().length()>150)
            throw new IllegalArgumentException("Enter the new Seller company name (up to 150 characters).");
        if(len(gst)>20||len(iec)>15||len(city)>60||len(country)>60||len(address)>10000)
            throw new IllegalArgumentException("One or more Seller details are too long.");
        operations.createVesselWithNewSeller(actor,vesselName.trim(),nullIfBlank(imo),capacity,
            companyName.trim(),nullIfBlank(gst),nullIfBlank(iec),nullIfBlank(address),nullIfBlank(city),nullIfBlank(country));
    }
    public void updateVesselDetails(int actor,int id,String name,String imo,Integer owner,Integer capacity,String status) throws SQLException {
        if(id<=0)throw new IllegalArgumentException("Choose a vessel to edit.");
        checkVessel(name,imo,capacity);
        if(!"ACTIVE".equals(status)&&!"MAINTENANCE".equals(status))
            throw new IllegalArgumentException("Choose Active or Maintenance as the vessel status.");
        operations.updateVesselDetails(actor,id,name.trim(),nullIfBlank(imo),owner,capacity,status);
    }
    private void checkVessel(String name,String imo,Integer capacity) {
        if(empty(name)||name.trim().length()>100)throw new IllegalArgumentException("Enter a vessel name (up to 100 characters).");
        if(capacity!=null && capacity<=0)throw new IllegalArgumentException("Capacity must be greater than zero TEU.");
        if(!empty(imo)) {
            String digits=imo.trim();
            if(!digits.matches("[0-9]{7}")) throw new IllegalArgumentException("IMO number must have exactly seven digits.");
            int sum=0;for(int i=0;i<6;i++)sum+=(digits.charAt(i)-'0')*(7-i);
            if(sum%10 != digits.charAt(6)-'0')
                throw new IllegalArgumentException("IMO check digit is invalid. Check the seven-digit vessel identifier.");
        }
    }
    public void editVessel(int actor,int id,String field,String value) throws SQLException {
        if(id<=0 || !Arrays.asList("vessel_name","imo_number","capacity_teu","status").contains(field))
            throw new IllegalArgumentException("Choose a valid vessel field.");
        if("status".equals(field)) {
            if(!"ACTIVE".equals(value)&&!"MAINTENANCE".equals(value))
                throw new IllegalArgumentException("Vessel status must be Active or Maintenance.");
        }else if("imo_number".equals(field))checkVessel("Validation",value,null);
        else if(empty(value))throw new IllegalArgumentException("The updated vessel value cannot be blank.");
        operations.updateVessel(actor,id,field,value);
    }
    public void setVesselStatus(int actor,int id,String status) throws SQLException {
        editVessel(actor,id,"status",status);
    }
    public void deleteVessel(int actor,int id) throws SQLException {
        if(id<=0)throw new IllegalArgumentException("Choose a vessel.");operations.deleteVessel(actor,id);
    }
    private static String nullIfBlank(String s){return empty(s)?null:s.trim();}
    private static boolean empty(String s){return s==null||s.trim().isEmpty();}
    private static int len(String s){return s==null?0:s.trim().length();}
}
