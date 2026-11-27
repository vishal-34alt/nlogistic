package implementor;

import db_config.GetConnection;
import model.Company;
import model.InfrastructureRecord;
import operations.InfrastructureOperations;
import java.sql.*;
import java.util.*;

/** JDBC-only port/vessel operations; all SQL remains out of the JSP and controller. */
public final class InfrastructureImplementor implements InfrastructureOperations {
    private static void requireAdmin(Connection c,int actor) throws SQLException {
        try(PreparedStatement ps=c.prepareStatement("SELECT 1 FROM users WHERE user_id=? AND role='ADMIN' AND status='ACTIVE'")) {
            ps.setInt(1,actor);try(ResultSet r=ps.executeQuery()){
                if(!r.next())throw new SQLException("An active administrator is required.","28000");
            }
        }
    }
    @Override public List<InfrastructureRecord> ports(int actor) throws SQLException {
        List<InfrastructureRecord> rows=new ArrayList<>();
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            try(PreparedStatement ps=c.prepareStatement("SELECT p.port_id,p.port_code,p.port_name,p.city,p.country,p.latitude,p.longitude,(" +
                    "SELECT COUNT(*) FROM shipment sh WHERE (sh.origin_port_id=p.port_id OR sh.dest_port_id=p.port_id) " +
                    "AND sh.status NOT IN ('DELIVERED','CANCELLED')) AS current_shipments " +
                    "FROM ports p ORDER BY p.port_name");
                ResultSet r=ps.executeQuery()) {
                while(r.next()){
                    InfrastructureRecord record=InfrastructureRecord.port(r.getInt(1),r.getString(2),r.getString(3),
                        r.getString(4),r.getString(5),r.getBigDecimal(6),r.getBigDecimal(7));
                    record.setActiveShipmentCount(r.getInt(8));rows.add(record);
                }
            }
        }
        return rows;
    }
    @Override public List<InfrastructureRecord> vessels(int actor) throws SQLException {
        List<InfrastructureRecord> rows=new ArrayList<>();
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            String sql="SELECT v.vessel_id,v.imo_number,v.vessel_name,v.owner_company_id,c.company_name,v.capacity_teu,v.status, " +
                       "COALESCE(active_counts.active_shipments,0) AS active_shipments, " +
                       "(SELECT COUNT(*) FROM shipment sh WHERE sh.vessel_id=v.vessel_id) AS history_shipments " +
                       "FROM vessels v LEFT JOIN companies c ON c.company_id=v.owner_company_id " +
                       "LEFT JOIN (SELECT vessel_id,COUNT(*) AS active_shipments FROM shipment " +
                       "WHERE vessel_id IS NOT NULL AND status NOT IN ('CANCELLED','DELIVERED') " +
                       "GROUP BY vessel_id) active_counts ON active_counts.vessel_id=v.vessel_id ORDER BY v.vessel_name";
            try(PreparedStatement ps=c.prepareStatement(sql);ResultSet r=ps.executeQuery()) {
                while(r.next()) {
                    int owner=r.getInt(4);Integer id=r.wasNull()?null:owner;
                    int cap=r.getInt(6);Integer capacity=r.wasNull()?null:cap;
                    InfrastructureRecord record=InfrastructureRecord.vessel(r.getInt(1),r.getString(2),r.getString(3),
                            id,r.getString(5),capacity,r.getString(7));
                    record.setActiveShipmentCount(r.getInt(8));
                    record.setTotalShipmentCount(r.getInt(9));
                    rows.add(record);
                }
            }
        }
        return rows;
    }
    @Override public List<Company> sellerCompanies(int actor) throws SQLException {
        List<Company> result=new ArrayList<>();
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            try(PreparedStatement ps=c.prepareStatement("SELECT company_id,company_name FROM companies WHERE company_type='SELLER' ORDER BY company_name");
                ResultSet r=ps.executeQuery()) {
                while(r.next()){Company row=new Company();row.setCompanyId(r.getInt(1));row.setCompanyName(r.getString(2));
                    row.setCompanyType("SELLER");result.add(row);}
            }
        }
        return result;
    }
    private static void checkSeller(Connection c,Integer companyId) throws SQLException {
        if(companyId==null)return;
        try(PreparedStatement ps=c.prepareStatement("SELECT 1 FROM companies WHERE company_id=? AND company_type='SELLER'")) {
            ps.setInt(1,companyId);try(ResultSet r=ps.executeQuery()){
                if(!r.next())throw new SQLException("Select an existing Seller company from the dropdown.","45000");
            }
        }
    }
    private static void recordUpdate(Connection c,int actor,String table,int id,String fields) throws SQLException {
        // Reuse the approved audit stored procedure, without adding tables/columns.
        try(PreparedStatement ps=c.prepareStatement(
                "CALL sp_record_audit_action(?, 'UPDATE', ?, ?, NULL, JSON_OBJECT('fields', ?), NULL)")) {
            ps.setInt(1,actor);ps.setString(2,table);ps.setInt(3,id);ps.setString(4,fields);
            ps.execute();
        }
    }
    private static void coord(PreparedStatement ps,int index,String raw) throws SQLException {
        if(raw==null||raw.trim().isEmpty())ps.setNull(index,Types.DECIMAL);
        else ps.setBigDecimal(index,new java.math.BigDecimal(raw.trim()));
    }
    private static void nullable(PreparedStatement ps,int index,String value) throws SQLException {
        if(value==null||value.trim().isEmpty())ps.setNull(index,Types.VARCHAR);
        else ps.setString(index,value.trim());
    }
    private static void integer(PreparedStatement ps,int index,Integer value) throws SQLException {
        if(value==null)ps.setNull(index,Types.INTEGER);else ps.setInt(index,value);
    }
    @Override public void createPort(int actor,String code,String name,String city,String country) throws SQLException {
        createPortWithCoordinates(actor,code,name,city,country,null,null);
    }
    @Override public void createPortWithCoordinates(int actor,String code,String name,String city,String country,
            String latitude,String longitude) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            try(PreparedStatement ps=c.prepareStatement("INSERT INTO ports(port_code,port_name,city,country,latitude,longitude) VALUES(?,?,?,?,?,?)")) {
                ps.setString(1,code);ps.setString(2,name);nullable(ps,3,city);nullable(ps,4,country);
                coord(ps,5,latitude);coord(ps,6,longitude);ps.executeUpdate();
            }
        }
    }
    @Override public void updatePortDetails(int actor,int id,String code,String name,String city,String country,
            String latitude,String longitude) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);c.setAutoCommit(false);
            try {
                try(PreparedStatement ps=c.prepareStatement("UPDATE ports SET port_code=?,port_name=?,city=?,country=?,latitude=?,longitude=? WHERE port_id=?")) {
                    ps.setString(1,code);ps.setString(2,name);nullable(ps,3,city);nullable(ps,4,country);
                    coord(ps,5,latitude);coord(ps,6,longitude);ps.setInt(7,id);
                    if(ps.executeUpdate()!=1)throw new SQLException("Port not found (or no changes to save).","45000");
                }
                recordUpdate(c,actor,"ports",id,"port_code,port_name,city,country,latitude,longitude");
                c.commit();
            }catch(SQLException|RuntimeException ex){try{c.rollback();}catch(SQLException rb){ex.addSuppressed(rb);}throw ex;}
        }
    }
    @Override public void updatePort(int actor,int id,String field,String value) throws SQLException {
        if(!Arrays.asList("port_code","port_name","city","country","latitude","longitude").contains(field))
            throw new IllegalArgumentException("Unsupported port field.");
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            try(PreparedStatement ps=c.prepareStatement("UPDATE ports SET "+field+"=? WHERE port_id=?")) {
                if(field.equals("latitude")||field.equals("longitude"))coord(ps,1,value);else nullable(ps,1,value);
                ps.setInt(2,id);if(ps.executeUpdate()!=1)throw new SQLException("Port not found.","45000");
            }
        }
    }
    @Override public void deletePort(int actor,int id) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);c.setAutoCommit(false);
            try {
                int shipmentRefs=0, containerRefs=0;
                try(PreparedStatement ps=c.prepareStatement("SELECT (SELECT COUNT(*) FROM shipment WHERE origin_port_id=? OR dest_port_id=?) AS shipment_refs, (SELECT COUNT(*) FROM containers WHERE current_port_id=?) AS container_refs")) {
                    ps.setInt(1,id);ps.setInt(2,id);ps.setInt(3,id);
                    try(ResultSet r=ps.executeQuery()){
                        if(r.next()){shipmentRefs=r.getInt("shipment_refs");containerRefs=r.getInt("container_refs");}
                    }
                }
                if(shipmentRefs>0 || containerRefs>0)
                    throw new SQLException("Port is already used by shipments or containers and cannot be deleted.","45000");
                try(PreparedStatement clearOrigin=c.prepareStatement("UPDATE pricing_rules SET origin_port_id=NULL WHERE origin_port_id=?")) {
                    clearOrigin.setInt(1,id);clearOrigin.executeUpdate();
                }
                try(PreparedStatement clearDestination=c.prepareStatement("UPDATE pricing_rules SET dest_port_id=NULL WHERE dest_port_id=?")) {
                    clearDestination.setInt(1,id);clearDestination.executeUpdate();
                }
                try(PreparedStatement ps=c.prepareStatement("DELETE FROM ports WHERE port_id=?")) {
                    ps.setInt(1,id);if(ps.executeUpdate()!=1)throw new SQLException("Port was not found.","45000");
                }
                try(CallableStatement audit=c.prepareCall("{CALL sp_record_audit_action(?,?,?,?,?,?,?)}")) {
                    audit.setInt(1,actor);audit.setString(2,"DELETE");audit.setString(3,"ports");audit.setInt(4,id);
                    audit.setNull(5,Types.VARCHAR);audit.setString(6,"{\"message\":\"Port deleted; pricing rules detached automatically if present.\"}");audit.setNull(7,Types.VARCHAR);audit.execute();
                }
                c.commit();
            } catch(SQLException|RuntimeException ex) {
                try{c.rollback();}catch(SQLException rollback){ex.addSuppressed(rollback);}throw ex;
            }
        }
    }
    @Override public void createVessel(int actor,String name,String imo,Integer owner,Integer capacity) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);checkSeller(c,owner);
            try(PreparedStatement ps=c.prepareStatement("INSERT INTO vessels(vessel_name,imo_number,owner_company_id,capacity_teu,status) VALUES(?,?,?,?,'ACTIVE')")) {
                ps.setString(1,name);nullable(ps,2,imo);integer(ps,3,owner);integer(ps,4,capacity);
                try {ps.executeUpdate();}
                catch(SQLIntegrityConstraintViolationException conflict){
                    throw new SQLException("Vessel could not be added: that IMO may already exist, or a linked Seller was changed. Check the IMO and choose an existing Seller.","45000",conflict);
                }
            }
        }
    }
    @Override public void createVesselWithNewSeller(int actor,String vesselName,String imo,Integer capacity,
            String companyName,String gst,String iec,String address,String city,String country) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            c.setAutoCommit(false);
            try {
                // Avoid re-creating an existing Seller under a different case.
                try(PreparedStatement check=c.prepareStatement(
                        "SELECT company_id FROM companies WHERE LOWER(TRIM(company_name))=LOWER(?) LIMIT 1 FOR UPDATE")) {
                    check.setString(1,companyName);
                    try(ResultSet rs=check.executeQuery()){
                        if(rs.next()) throw new SQLException("That company already exists. Select it from the Seller suggestions.","45000");
                    }
                }
                int sellerId;
                try(PreparedStatement ps=c.prepareStatement(
                    "INSERT INTO companies(company_name,company_type,gst_number,iec_code,address,city,country) VALUES(?,'SELLER',?,?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1,companyName);nullable(ps,2,gst);nullable(ps,3,iec);
                    nullable(ps,4,address);nullable(ps,5,city);nullable(ps,6,country);
                    if(ps.executeUpdate()!=1)throw new SQLException("Unable to create Seller company.");
                    try(ResultSet keys=ps.getGeneratedKeys()){
                        if(!keys.next())throw new SQLException("New Seller company ID unavailable.");sellerId=keys.getInt(1);
                    }
                }
                int vesselId;
                try(PreparedStatement ps=c.prepareStatement(
                    "INSERT INTO vessels(vessel_name,imo_number,owner_company_id,capacity_teu,status) VALUES(?,?,?,?,'ACTIVE')",
                    Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1,vesselName);nullable(ps,2,imo);ps.setInt(3,sellerId);integer(ps,4,capacity);
                    if(ps.executeUpdate()!=1)throw new SQLException("Unable to create vessel.");
                    try(ResultSet keys=ps.getGeneratedKeys()){
                        if(!keys.next())throw new SQLException("New vessel ID unavailable.");vesselId=keys.getInt(1);
                    }
                }
                try(CallableStatement audit=c.prepareCall("{CALL sp_record_audit_action(?,?,?,?,?,?,?)}")) {
                    audit.setInt(1,actor);audit.setString(2,"INSERT");audit.setString(3,"companies");audit.setInt(4,sellerId);
                    audit.setNull(5,Types.VARCHAR);audit.setString(6,"{\"company_type\":\"SELLER\"}");audit.setNull(7,Types.VARCHAR);audit.execute();
                }
                try(CallableStatement audit=c.prepareCall("{CALL sp_record_audit_action(?,?,?,?,?,?,?)}")) {
                    audit.setInt(1,actor);audit.setString(2,"INSERT");audit.setString(3,"vessels");audit.setInt(4,vesselId);
                    audit.setNull(5,Types.VARCHAR);audit.setString(6,"{\"status\":\"ACTIVE\"}");audit.setNull(7,Types.VARCHAR);audit.execute();
                }
                c.commit();
            } catch(SQLException|RuntimeException ex) {
                try{c.rollback();}catch(SQLException rollback){ex.addSuppressed(rollback);}throw ex;
            }
        }
    }
    @Override public void updateVesselDetails(int actor,int id,String name,String imo,Integer owner,Integer capacity,String status) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);checkSeller(c,owner);c.setAutoCommit(false);
            try {
                String previous=null;
                try(PreparedStatement current=c.prepareStatement("SELECT status FROM vessels WHERE vessel_id=? FOR UPDATE")){
                    current.setInt(1,id);try(ResultSet row=current.executeQuery()){if(row.next())previous=row.getString(1);}
                }
                if(previous==null)throw new SQLException("Vessel was not found.","45000");
                try(PreparedStatement ps=c.prepareStatement("UPDATE vessels SET vessel_name=?,imo_number=?,owner_company_id=?,capacity_teu=?,status=? WHERE vessel_id=?")) {
                    ps.setString(1,name);nullable(ps,2,imo);integer(ps,3,owner);integer(ps,4,capacity);ps.setString(5,status);ps.setInt(6,id);
                    if(ps.executeUpdate()!=1)throw new SQLException("Vessel not found (or no changes to save).","45000");
                }
                recordUpdate(c,actor,"vessels",id,"vessel_name,imo_number,owner_company_id,capacity_teu,status");
                c.commit();
            }catch(SQLException|RuntimeException ex){try{c.rollback();}catch(SQLException rb){ex.addSuppressed(rb);}throw ex;}
        }
    }
    @Override public void updateVessel(int actor,int id,String field,String value) throws SQLException {
        if(!Arrays.asList("vessel_name","imo_number","capacity_teu","status").contains(field))
            throw new IllegalArgumentException("Unsupported vessel field.");
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            c.setAutoCommit(false);
            try {
                // Lock and verify the actual vessel. A status change is not blocked
                // merely because earlier shipments reference this vessel.
                if("status".equals(field)) {
                    String oldStatus=null;
                    try(PreparedStatement lock=c.prepareStatement("SELECT status FROM vessels WHERE vessel_id=? FOR UPDATE")) {
                        lock.setInt(1,id);
                        try(ResultSet r=lock.executeQuery()){if(r.next())oldStatus=r.getString(1);}
                    }
                    if(oldStatus==null)throw new SQLException("Vessel not found. Refresh the directory.","45000");
                    if(oldStatus.equals(value))throw new SQLException("This vessel is already "+
                            ("MAINTENANCE".equals(value)?"in Maintenance.":"Active."),"45000");
                }
                try(PreparedStatement ps=c.prepareStatement("UPDATE vessels SET "+field+"=? WHERE vessel_id=?")) {
                    if(field.equals("capacity_teu"))ps.setInt(1,Integer.parseInt(value));
                    else nullable(ps,1,value);
                    ps.setInt(2,id);
                    if(ps.executeUpdate()!=1)throw new SQLException("Vessel not found or update was rejected.","45000");
                }
                if("status".equals(field)) {
                    try(PreparedStatement check=c.prepareStatement("SELECT status FROM vessels WHERE vessel_id=?")) {
                        check.setInt(1,id);
                        try(ResultSet r=check.executeQuery()) {
                            if(!r.next()||!value.equals(r.getString(1)))
                                throw new SQLException("The requested vessel status was not saved.","45000");
                        }
                    }
                }
                recordUpdate(c,actor,"vessels",id,field);
                c.commit();
            }catch(SQLException|RuntimeException ex){try{c.rollback();}catch(SQLException rb){ex.addSuppressed(rb);}throw ex;}
        }
    }
    @Override public void deleteVessel(int actor,int id) throws SQLException {
        try(Connection c=GetConnection.getConnection()) {
            requireAdmin(c,actor);
            c.setAutoCommit(false);
            try {
                // The approved shipment.vessel_id foreign key protects referenced vessels.
                // Lock before checking, so deletion never silently detaches shipment history.
                boolean exists=false;
                try(PreparedStatement lock=c.prepareStatement("SELECT vessel_id FROM vessels WHERE vessel_id=? FOR UPDATE")) {
                    lock.setInt(1,id);
                    try(ResultSet r=lock.executeQuery()){exists=r.next();}
                }
                if(!exists)throw new SQLException("Vessel was not found; refresh the directory.","45000");
                int referenced=0;
                try(PreparedStatement check=c.prepareStatement("SELECT COUNT(*) FROM shipment WHERE vessel_id=?")) {
                    check.setInt(1,id);
                    try(ResultSet r=check.executeQuery()){if(r.next())referenced=r.getInt(1);}
                }
                if(referenced>0)throw new SQLException("Cannot delete: this vessel is referenced by "+referenced+
                        " shipment(s). Move it to Maintenance to preserve shipment history.","45000");
                try(PreparedStatement ps=c.prepareStatement("DELETE FROM vessels WHERE vessel_id=?")) {
                    ps.setInt(1,id);
                    if(ps.executeUpdate()!=1)throw new SQLException("Vessel was not deleted. Refresh and retry.","45000");
                }
                // Record the successful deletion in the existing approved audit log.
                try(PreparedStatement audit=c.prepareStatement(
                        "CALL sp_record_audit_action(?, 'DELETE', 'vessels', ?, NULL, NULL, NULL)")) {
                    audit.setInt(1,actor);audit.setInt(2,id);audit.execute();
                }
                c.commit();
            }catch(SQLException ex){
                try{c.rollback();}catch(SQLException rb){ex.addSuppressed(rb);}
                if("23000".equals(ex.getSQLState()))
                    throw new SQLException("Cannot delete a vessel referenced by existing records. Move it to Maintenance.","45000",ex);
                throw ex;
            }catch(RuntimeException ex){try{c.rollback();}catch(SQLException rb){ex.addSuppressed(rb);}throw ex;}
        }
    }
}
