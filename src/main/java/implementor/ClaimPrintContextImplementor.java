package implementor;
import db_config.GetConnection;
import java.sql.*;
import model.Row;
import operations.ClaimPrintContextOperations;
/** Reporting SELECT is restricted to the Implementor layer. Ownership checked before invoking. */
public final class ClaimPrintContextImplementor implements ClaimPrintContextOperations {
    @Override public Row findByShipment(int shipmentId) throws Exception {
        String sql="SELECT sc.company_name AS seller_name,cc.company_name AS consumer_company, "
           +"cu.contact_person AS consumer_contact,ct.container_number, "
           +"p1.port_name AS origin_name,p2.port_name AS destination_name, "
           +"s.cargo_description,s.quoted_price "
           +"FROM shipment s JOIN companies sc ON sc.company_id=s.seller_id "
           +"JOIN customers cu ON cu.customer_id=s.consumer_id "
           +"JOIN companies cc ON cc.company_id=cu.company_id "
           +"LEFT JOIN containers ct ON ct.container_id=s.container_id "
           +"LEFT JOIN ports p1 ON p1.port_id=s.origin_port_id "
           +"LEFT JOIN ports p2 ON p2.port_id=s.dest_port_id WHERE s.shipment_id=?";
        Row context=new Row();
        try(Connection con=GetConnection.getConnection();PreparedStatement ps=con.prepareStatement(sql)) {
            ps.setInt(1,shipmentId);
            try(ResultSet rs=ps.executeQuery()) {
                if(rs.next()) {
                    ResultSetMetaData meta=rs.getMetaData();
                    for(int i=1;i<=meta.getColumnCount();i++)context.put(meta.getColumnLabel(i),rs.getObject(i));
                }
            }
        }
        return context;
    }
}
