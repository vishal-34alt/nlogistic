package implementor;

import db_config.GetConnection;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Single source of truth for cancellation is the approved database routine.
 *
 * This Implementor does NOT reverse stock, change shipment status, release
 * containers or delete invoices itself. sp_delete_shipment performs all those
 * actions atomically, including movement and ledger audit events.
 */
public final class BookingCancellationImplementor {
    /**
     * Preview eligibility only. The stored procedure revalidates everything
     * under row locks at POST time, so hiding a button is never authorization.
     */
    private static final String ELIGIBLE_SQL =
        "SELECT 1 FROM shipment s "
        + "JOIN users actor ON actor.user_id=? AND actor.status='ACTIVE' "
        + "LEFT JOIN customers owned ON owned.user_id=actor.user_id "
        + "JOIN billing_invoices i ON i.shipment_id=s.shipment_id "
        + "WHERE s.shipment_id=? AND "
        + "((actor.role='CONSUMER' AND owned.customer_id=s.consumer_id AND s.status='BOOKED') "
        + "OR (actor.role='SELLER' AND actor.company_id=s.seller_id AND s.status IN ('BOOKED','LOADED')) "
        + "OR (actor.role='ADMIN' AND s.status IN ('BOOKED','LOADED'))) "
        + "AND i.status='UNPAID' AND i.paid_amount=0 "
        + "AND NOT EXISTS (SELECT 1 FROM payments p WHERE p.invoice_id=i.invoice_id) "
        + "AND NOT EXISTS (SELECT 1 FROM claims cl WHERE cl.shipment_id=s.shipment_id) "
        + "AND NOT EXISTS (SELECT 1 FROM shipment other WHERE other.container_id=s.container_id "
        + "AND other.shipment_id<>s.shipment_id AND other.status NOT IN ('CANCELLED','DELIVERED')) "
        + "AND EXISTS (SELECT 1 FROM shipment_items si WHERE si.shipment_id=s.shipment_id) "
        + "AND EXISTS (SELECT 1 FROM stock st WHERE st.shipment_id=s.shipment_id AND st.quantity>0) "
        + "LIMIT 1";

    public boolean eligible(int actorUserId, int shipmentId) throws SQLException {
        Connection connection=GetConnection.getConnection();
        if(connection==null)throw new SQLException("Database connection unavailable.","08001");
        try (Connection con=connection;
             PreparedStatement ps=con.prepareStatement(ELIGIBLE_SQL)) {
            ps.setInt(1,actorUserId);
            ps.setInt(2,shipmentId);
            try (ResultSet rs=ps.executeQuery()) { return rs.next(); }
        }
    }

    /**
     * Invoke the database's three-parameter cancellation transaction once.
     * No Java-side DML is permitted: it would conflict with trigger-driven
     * state changes and could discard invoice, sales or audit history.
     *
     * @return number of reserved units restored by the database.
     */
    public long cancel(int actorUserId, int shipmentId, String reason) throws SQLException {
        Connection connection=GetConnection.getConnection();
        if(connection==null)throw new SQLException("Database connection unavailable.","08001");
        try (Connection con=connection;
             CallableStatement call=con.prepareCall("{CALL sp_delete_shipment(?,?,?)}")) {
            call.setInt(1,actorUserId);
            call.setInt(2,shipmentId);
            call.setString(3,reason);
            boolean results=call.execute();
            boolean confirmed=false;
            long returned=-1;
            while (true) {
                if (results) {
                    try (ResultSet rs=call.getResultSet()) {
                        while (rs!=null && rs.next()) {
                            String state=rs.getString("shipment_status");
                            if ("CANCELLED".equals(state) && rs.getInt("shipment_id")==shipmentId) {
                                returned=rs.getLong("returned_stock_units");
                                confirmed=true;
                            }
                        }
                    }
                } else if (call.getUpdateCount()==-1) {
                    break;
                }
                results=call.getMoreResults();
            }
            if (!confirmed || returned<=0) {
                throw new SQLException("The database did not confirm stock restoration and cancellation.","45000");
            }
            return returned;
        } catch (SQLException ex) {
            // MySQL 1442 occurs when the database used INSERT...SELECT FROM shipment
            // in the cancellation procedure while the movement trigger updates shipment.
            // This is a database routine deployment issue, not a user input error.
            if (ex.getErrorCode()==1442) {
                throw new SQLException(
                    "The installed cancellation procedure conflicts with the movement trigger. "
                    + "Import DB_PATCH_v17.9_Fix_MySQL_1442.sql into n_logistic_test_db and retry. "
                    + "No cancellation changes were saved.", "45000",ex);
            }
            // Error 1305 can also mean a nested dependency is missing; avoid an
            // inaccurate 'procedure not installed' message for any nested routine.
            if (ex.getErrorCode()==1305) {
                String message=ex.getMessage()==null?"":ex.getMessage();
                if (message.contains("sp_delete_shipment")) {
                    throw new SQLException(
                        "sp_delete_shipment is missing from the connected database. "
                        + "Install the v17.9 database patch into n_logistic_test_db.",
                        "45000",ex);
                }
                throw new SQLException(
                    "A database routine used by cancellation is missing: " + message,
                    "45000",ex);
            }
            throw ex;
        }
    }
}
