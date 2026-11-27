
package model;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import operations.BookingOperations;
import implementor.BookingImplementor;

public class Booking {

    // Booking attributes
    private int bookingId;
    private int userId;
    private int originPortId;
    private int destPortId;
    private Date bookingDate;
    private Date dueDate;
    private String bookingStatus;
    private java.math.BigDecimal totalAmount;

    // DAO interface
    private BookingOperations bookingDAO;

    // Default constructor
    public Booking() {
        this(new BookingImplementor());
    }

    // Constructor with DAO injection
    public Booking(BookingOperations bookingDAO) {
        if (bookingDAO == null) {
            throw new IllegalArgumentException(
                    "Booking DAO cannot be null.");
        }
        this.bookingDAO = bookingDAO;
    }

    // Parameterized constructor
    public Booking(int userId, int originPortId,
                   int destPortId, Date bookingDate) {

        this();
        this.userId = userId;
        this.originPortId = originPortId;
        this.destPortId = destPortId;
        this.bookingDate = bookingDate;
    }

    public static void validateDueDate(Date bookingDate,Date due) {
        if(bookingDate==null||due==null||due.before(bookingDate))
            throw new IllegalArgumentException("Due date must be on or after booking date");
    }
    /** Immutable booking inputs are compared when the quotation is finally confirmed. */
    public static String quoteFingerprint(int user,int origin,int destination,Date bookingDate,
                                    Date due,List<BookingItem> items){
        StringBuilder b=new StringBuilder().append(user).append('|').append(origin).append('|')
            .append(destination).append('|').append(bookingDate).append('|').append(due);
        for(BookingItem i:items)b.append('|').append(i.getProductId()).append(':')
            .append(i.getQuantity()).append(':').append(java.math.BigDecimal.valueOf(i.getUnitCbm()).stripTrailingZeros().toPlainString());
        return b.toString();
    }


    /** Convert database availability errors into practical next steps for the Consumer. */
    public static String explainFailure(Exception failure) {
        String raw=failure==null?"":String.valueOf(failure.getMessage());
        String normalized=raw.toLowerCase(java.util.Locale.ROOT);
        if(normalized.contains("booking_invoice_sync_failed"))
            return "The booking may have been created, but its goods-inclusive invoice could not be finalized. "
                + "Do not submit the booking again. Check your recent shipments and invoice details, "
                + "then ask the Seller or administrator to verify the invoice total.";
        if(normalized.contains("no available container") ||
                (normalized.contains("sufficient") && (normalized.contains("cbm")||normalized.contains("kg")))) {
            return "No container can currently carry this order on the selected route at an active price. "
                + "Check the cargo weight and packed volume, reduce the quantity, or choose different ports. "
                + "If the route is correct, ask the Seller to check available containers and pricing rules.";
        }
        if(normalized.contains("stock") || normalized.contains("quantity"))
            return "Available stock cannot cover the requested quantity. Select fewer units or a different product, then try again.";
        if(normalized.contains("price") || normalized.contains("pricing"))
            return "An active price could not be found for the route and container type. Change the route or ask the Seller to review pricing rules.";
        if(raw!=null && !raw.trim().isEmpty() && failure instanceof java.sql.SQLException
                && "45000".equals(((java.sql.SQLException)failure).getSQLState()))return raw;
        return "The quotation could not be confirmed. Please check the selected product, route, date, and container availability, then retry.";
    }

    // Calculate booking quotation
    public Map<String, Object> calculateQuote(
            List<BookingItem> items) throws Exception {

        validateBooking();

        return includeGoodsInFreight(bookingDAO.calculateQuote(
                userId,
                originPortId,
                destPortId,
                bookingDate,
                items
        ));
    }

    // Confirm booking
    public Map<String, Object> confirmBooking(
            Date dueDate,
            List<BookingItem> items) throws Exception {

        validateBooking();

        if (dueDate == null) {
            throw new IllegalArgumentException(
                    "Due date is required.");
        }

        if (dueDate.before(bookingDate)) {
            throw new IllegalArgumentException(
                    "Due date cannot be before booking date.");
        }

        this.dueDate = dueDate;

        Map<String, Object> booked = bookingDAO.confirmBooking(
                userId,
                originPortId,
                destPortId,
                bookingDate,
                dueDate,
                items
        );
        if (booked == null) {
            throw new IllegalStateException("The booking did not return its confirmed invoice.");
        }
        // The database confirms stock, shipment, goods-inclusive invoice, and
        // GST at its own configured rate in ONE transaction. No post-commit rewrite.
        return includeGoodsInFreight(booked);
    }

    /**
     * Verify the SQL-derived commercial breakdown; never choose a GST rate in
     * the Model. sp_process_booking returns the current database GST setting
     * with the quote, so a later DB policy change requires no Java redeploy.
     */
    public static Map<String, Object> includeGoodsInFreight(Map<String, Object> quote) {
        if (quote == null) return null;
        if (Boolean.TRUE.equals(quote.get("goodsIncludedInFreight"))) return quote;
        java.math.BigDecimal goods = bookingMoney(quote, "goodsValue");
        java.math.BigDecimal shipping = bookingMoney(quote, "shippingFreightOnly");
        java.math.BigDecimal freight = bookingMoney(quote, "freightAmount");
        java.math.BigDecimal handling = bookingMoney(quote, "handlingAmount");
        java.math.BigDecimal tax = bookingMoney(quote, "taxAmount");
        java.math.BigDecimal total = bookingMoney(quote, "quotationTotal");
        java.math.BigDecimal rate = bookingMoney(quote, "taxRatePercent");
        java.math.BigDecimal taxable = freight.add(handling).setScale(2);
        java.math.BigDecimal expectedTax = taxable.multiply(rate).movePointLeft(2)
                .setScale(2, java.math.RoundingMode.HALF_UP);
        if (goods.signum() < 0 || shipping.signum() < 0 || handling.signum() < 0 ||
                rate.signum() < 0 || rate.compareTo(new java.math.BigDecimal("100")) > 0 ||
                freight.compareTo(goods.add(shipping)) != 0 ||
                tax.compareTo(expectedTax) != 0 ||
                total.compareTo(taxable.add(tax)) != 0) {
            throw new IllegalStateException("The database quotation and GST totals do not reconcile.");
        }
        quote.put("taxableAmount", taxable);
        quote.put("goodsIncludedInFreight", Boolean.TRUE);
        return quote;
    }

    private static java.math.BigDecimal bookingMoney(Map<String, Object> quote, String key) {
        Object value = quote.get(key);
        if (value == null) throw new IllegalStateException("Missing quotation component: " + key);
        try {
            return new java.math.BigDecimal(String.valueOf(value)).setScale(2, java.math.RoundingMode.HALF_UP);
        } catch (NumberFormatException ex) {
            throw new IllegalStateException("Invalid quotation component: " + key, ex);
        }
    }

    // Validate booking details
    private void validateBooking() {

        if (userId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid user.");
        }

        if (originPortId <= 0 || destPortId <= 0) {
            throw new IllegalArgumentException(
                    "Please select valid origin and destination ports.");
        }

        if (originPortId == destPortId) {
            throw new IllegalArgumentException(
                    "Origin and destination ports cannot be the same.");
        }

        if (bookingDate == null) {
            throw new IllegalArgumentException(
                    "Booking date is required.");
        }
    }

    // Getters and setters

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getOriginPortId() {
        return originPortId;
    }

    public void setOriginPortId(int originPortId) {
        this.originPortId = originPortId;
    }

    public int getDestPortId() {
        return destPortId;
    }

    public void setDestPortId(int destPortId) {
        this.destPortId = destPortId;
    }

    public Date getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Date bookingDate) {
        this.bookingDate = bookingDate;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public java.math.BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(java.math.BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
}
