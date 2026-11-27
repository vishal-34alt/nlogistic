package implementor;

import db_config.GetConnection;
import model.ContainerMovementPojo;
import operations.MovementOperations;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class MovementImplementor implements MovementOperations {
    @Override public List<ContainerMovementPojo> search(int userId,Integer shipmentId,
                   String status,LocalDate start,LocalDate end) throws SQLException {
        List<ContainerMovementPojo> results=new ArrayList<>();
        try(Connection conn=GetConnection.getConnection();
            CallableStatement cs=conn.prepareCall("{CALL sp_search_container_movements(?,?,?,?,?)}")) {
            cs.setInt(1,userId);
            if(shipmentId==null)cs.setNull(2,Types.INTEGER);else cs.setInt(2,shipmentId);
            if(status==null)cs.setNull(3,Types.VARCHAR);else cs.setString(3,status);
            if(start==null)cs.setNull(4,Types.DATE);else cs.setDate(4,Date.valueOf(start));
            if(end==null)cs.setNull(5,Types.DATE);else cs.setDate(5,Date.valueOf(end));
            try(ResultSet rs=cs.executeQuery()) {
                while(rs.next()) {
                    ContainerMovementPojo m=new ContainerMovementPojo();
                    m.setMovementId(rs.getLong("movement_id"));
                    m.setShipmentId(rs.getInt("shipment_id"));
                    m.setContainerId(rs.getInt("container_id"));
                    m.setStatus(rs.getString("status"));
                    int port=rs.getInt("port_id");m.setPortId(rs.wasNull()?null:port);
                    m.setLocationText(rs.getString("location_text"));
                    Timestamp ts=rs.getTimestamp("event_time");
                    m.setEventTime(ts==null?null:ts.toLocalDateTime());
                    m.setRemarks(rs.getString("remarks"));
                    int updater=rs.getInt("updated_by");m.setUpdatedBy(rs.wasNull()?null:updater);
                    results.add(m);
                }
            }
        }
        return results;
    }
    @Override public long insert(ContainerMovementPojo event) throws SQLException {
        try(Connection conn=GetConnection.getConnection();
            CallableStatement cs=conn.prepareCall("{CALL sp_insert_container_movement(?,?,?,?,?,?,?)}")) {
            cs.setInt(1,event.getShipmentId());cs.setString(2,event.getStatus());
            if(event.getPortId()==null)cs.setNull(3,Types.INTEGER);else cs.setInt(3,event.getPortId());
            cs.setString(4,event.getLocationText());
            // Use database time for consistent, authoritative timestamps.
            cs.setNull(5,Types.TIMESTAMP);
            cs.setString(6,event.getRemarks());cs.setInt(7,event.getUpdatedBy());
            try(ResultSet rs=cs.executeQuery()) {
                if(rs.next())return rs.getLong("movement_id");
            }
        }
        throw new SQLException("Movement insert did not return an event ID");
    }
    @Override public void deleteLatest(int userId,long movementId,String reason) throws SQLException {
        try(Connection conn=GetConnection.getConnection();
            CallableStatement cs=conn.prepareCall("{CALL sp_delete_container_movement(?,?,?)}")) {
            cs.setInt(1,userId);cs.setLong(2,movementId);cs.setString(3,reason);
            cs.execute();
        }
    }
}
