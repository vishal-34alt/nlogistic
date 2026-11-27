
package implementor;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import operations.ContainerOperations;
import db_config.GetConnection;
import model.Container;

public class ContainerImplementor implements ContainerOperations {

    private Connection openConnection() throws Exception {

        Connection connection = GetConnection.getConnection();

        if (connection == null) {
            throw new Exception("Unable to connect to n_logistic_db");
        }

        return connection;
    }

    // Convert database row into Container object
    private Container mapContainer(ResultSet rs) throws Exception {

        Container container = new Container();

        container.setContainerId(rs.getInt("container_id"));
        container.setContainerNumber(rs.getString("container_number"));
        container.setSellerId(rs.getInt("seller_id"));
        container.setContainerType(rs.getString("container_type"));
        container.setSizeFt(rs.getInt("size_ft"));
        container.setMaxWeightKg(rs.getBigDecimal("max_weight_kg"));
        container.setMaxVolumeCbm(rs.getBigDecimal("max_volume_cbm"));
        container.setCurrentPortId(rs.getInt("current_port_id"));
        container.setStatus(rs.getString("status"));

        return container;
    }

    // 1. Insert container
    @Override
    public int insertContainer(Container container) throws Exception {

        if (container == null) {
            throw new IllegalArgumentException(
                    "Container cannot be null.");
        }

        String sql = "{CALL sp_insert_container(?,?,?,?,?,?,?)}";

        try (Connection con = openConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, container.getContainerNumber());
            cs.setInt(2, container.getSellerId());
            cs.setString(3, container.getContainerType());
            cs.setInt(4, container.getSizeFt());
            cs.setBigDecimal(5, container.getMaxWeightKg());
            cs.setBigDecimal(6, container.getMaxVolumeCbm());
            cs.setInt(7, container.getCurrentPortId());

            try (ResultSet rs = cs.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt("container_id");
                }
            }
        }

        return 0;
    }

    // 2. Retrieve containers by seller
    @Override
    public List<Container> getContainersBySeller(
            Integer sellerId) throws Exception {

        if (sellerId == null || sellerId <= 0) {
            throw new IllegalArgumentException(
                    "Valid seller ID is required.");
        }

        List<Container> containerList = new ArrayList<>();

        String sql = "{CALL sp_show_containers(?)}";

        try (Connection con = openConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, sellerId);

            try (ResultSet rs = cs.executeQuery()) {

                while (rs.next()) {
                    containerList.add(mapContainer(rs));
                }
            }
        }

        // Mark reference history without changing approved database columns.
        annotateShipmentHistory(containerList, sellerId);
        return containerList;
    }

    private void annotateShipmentHistory(List<Container> rows, int sellerId) throws Exception {
        if (rows==null || rows.isEmpty()) return;
        java.util.Set<Integer> referenced = new java.util.HashSet<>();
        String sql="SELECT DISTINCT s.container_id FROM shipment s JOIN containers c "
            + "ON c.container_id=s.container_id WHERE c.seller_id=?";
        try(Connection con=openConnection(); java.sql.PreparedStatement ps=con.prepareStatement(sql)) {
            ps.setInt(1,sellerId);
            try(ResultSet rs=ps.executeQuery()) {
                while(rs.next()) referenced.add(rs.getInt(1));
            }
        }
        for(Container c:rows) c.setShipmentHistory(referenced.contains(c.getContainerId()));
    }

    @Override public List<Container> searchContainers(int actor,int seller,String query,String status)throws Exception {
        List<Container> rows=new ArrayList<>();
        String sql="SELECT c.* FROM containers c JOIN users u ON u.user_id=? AND u.role='SELLER' AND u.status='ACTIVE' AND u.company_id=c.seller_id WHERE c.seller_id=? AND (?='' OR c.container_number LIKE ? OR CAST(c.container_id AS CHAR) LIKE ?) AND (?='' OR c.status=?) ORDER BY c.container_id DESC";
        String q=query==null?"":query.trim();String st=status==null?"":status.trim();
        if(!st.isEmpty()&&!java.util.Arrays.asList("AVAILABLE","ALLOCATED","IN_TRANSIT","MAINTENANCE").contains(st))throw new IllegalArgumentException("Invalid container status");
        try(Connection c=openConnection();java.sql.PreparedStatement ps=c.prepareStatement(sql)){
            ps.setInt(1,actor);ps.setInt(2,seller);ps.setString(3,q);ps.setString(4,"%"+q+"%");ps.setString(5,"%"+q+"%");ps.setString(6,st);ps.setString(7,st);
            try(ResultSet rs=ps.executeQuery()){while(rs.next())rows.add(mapContainer(rs));}
        }
        annotateShipmentHistory(rows,seller);
        return rows;
    }
    @Override public void deleteEligibleContainer(int actor,int seller,int containerId)throws Exception {
        // Never delete a container linked to a shipment, even a cancelled shipment.
        String sql="DELETE c FROM containers c JOIN users u ON u.user_id=? AND u.company_id=c.seller_id AND u.role='SELLER' AND u.status='ACTIVE' WHERE c.seller_id=? AND c.container_id=? AND c.status IN ('AVAILABLE','MAINTENANCE') AND NOT EXISTS (SELECT 1 FROM shipment s WHERE s.container_id=c.container_id)";
        try(Connection c=openConnection();java.sql.PreparedStatement ps=c.prepareStatement(sql)){
            ps.setInt(1,actor);ps.setInt(2,seller);ps.setInt(3,containerId);
            if(ps.executeUpdate()!=1)throw new java.sql.SQLException("Only unreferenced available/maintenance containers may be removed","45000");
        }
    }

    // 3. Update container field
    @Override
    public Container updateContainerField(
            int userId,
            int containerId,
            String fieldName,
            String newValue,
            String ipAddress) throws Exception {

        if (userId <= 0 || containerId <= 0) {
            throw new IllegalArgumentException(
                    "Valid user ID and container ID are required.");
        }

        if (fieldName == null || fieldName.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Field name cannot be empty.");
        }

        if (newValue == null) {
            throw new IllegalArgumentException(
                    "New value cannot be null.");
        }

        String sql = "{CALL sp_update_container_field(?,?,?,?,?)}";

        try (Connection con = openConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.setInt(2, containerId);
            cs.setString(3, fieldName);
            cs.setString(4, newValue);
            cs.setString(5, ipAddress);

            try (ResultSet rs = cs.executeQuery()) {

                if (rs.next()) {
                    return mapContainer(rs);
                }
            }
        }

        return null;
    }
}
