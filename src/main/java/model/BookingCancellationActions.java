package model;

import implementor.BookingCancellationImplementor;
import java.sql.SQLException;

/** Shipment cancellation use-case; the Implementor delegates atomic work to MySQL. */
public final class BookingCancellationActions {
    private final BookingCancellationImplementor dao=new BookingCancellationImplementor();

    public boolean eligible(User actor,int shipmentId) throws SQLException {
        if(actor==null||!actor.isActive()||shipmentId<=0||
            !(actor.isConsumer()||actor.isSeller()||actor.isAdmin()))return false;
        return dao.eligible(actor.getUserId(),shipmentId);
    }

    public long cancel(User actor,int shipmentId,String reason) throws SQLException {
        if(actor==null||!actor.isActive()||
            !(actor.isConsumer()||actor.isSeller()||actor.isAdmin()))
            throw new SecurityException("Only an active booking Consumer, owning Seller or Admin may cancel a shipment.");
        if(shipmentId<=0)throw new IllegalArgumentException("Select a valid shipment.");
        if(reason==null||reason.trim().length()<6||reason.trim().length()>255)
            throw new IllegalArgumentException("Please provide a reason of 6 to 255 characters.");
        // The database enforces ownership, BOOKED-only Consumer cancellation,
        // unpaid invoice, item quantities, movement sequence and audit history.
        return dao.cancel(actor.getUserId(),shipmentId,reason.trim());
    }
}
