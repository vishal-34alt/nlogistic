
package model;

public class BookingItem {

    private int bookingItemId;
    private int bookingId;
    private int productId;
    private int quantity;
    private double unitCbm;

    public BookingItem() {
    }

    public BookingItem(int productId, int quantity, double unitCbm) {
        setProductId(productId);
        setQuantity(quantity);
        setUnitCbm(unitCbm);
    }

    public int getBookingItemId() {
        return bookingItemId;
    }

    public void setBookingItemId(int bookingItemId) {
        this.bookingItemId = bookingItemId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        if (productId <= 0)
            throw new IllegalArgumentException("Invalid product ID.");

        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        if (quantity <= 0)
            throw new IllegalArgumentException("Quantity must be positive.");

        this.quantity = quantity;
    }

    public double getUnitCbm() {
        return unitCbm;
    }

    public void setUnitCbm(double unitCbm) {
        if (!Double.isFinite(unitCbm) || unitCbm <= 0)
            throw new IllegalArgumentException("Invalid unit CBM.");

        this.unitCbm = unitCbm;
    }
}
