
package operations;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import model.BookingItem;

public interface BookingOperations {

    Map<String, Object> calculateQuote(
            int userId,
            int originPortId,
            int destPortId,
            Date bookingDate,
            List<BookingItem> items
    ) throws Exception;

    Map<String, Object> confirmBooking(
            int userId,
            int originPortId,
            int destPortId,
            Date bookingDate,
            Date dueDate,
            List<BookingItem> items
    ) throws Exception;
}
