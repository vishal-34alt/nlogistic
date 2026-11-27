package model;

/** Stock belonging to the shipment, available for a LOSS/DAMAGE/SHORTAGE settlement. */
public final class ClaimStockOption {
    private final int stockId;
    private final String productName;
    private final int quantity;
    private final int damagedQty;
    public ClaimStockOption(int stockId, String productName, int quantity, int damagedQty) {
        this.stockId = stockId;
        this.productName = productName;
        this.quantity = quantity;
        this.damagedQty = damagedQty;
    }
    public int getStockId() { return stockId; }
    public String getProductName() { return productName; }
    public int getQuantity() { return quantity; }
    public int getDamagedQty() { return damagedQty; }
    public int getAvailable() { return quantity - damagedQty; }
    public int getAvailableQuantity() { return getAvailable(); }
}
