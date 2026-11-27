
package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class StockSummary {

    private int shipmentId;
    private BigDecimal totalQuantity = BigDecimal.ZERO;
    private BigDecimal totalValue = BigDecimal.ZERO;

    private List<Line> lines = new ArrayList<>();

    public int getShipmentId() {
        return shipmentId;
    }

    public void setShipmentId(int shipmentId) {
        this.shipmentId = shipmentId;
    }

    public BigDecimal getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(BigDecimal totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public BigDecimal getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(BigDecimal totalValue) {
        this.totalValue = totalValue;
    }

    public List<Line> getLines() {
        return lines;
    }

    public void setLines(List<Line> lines) {
        this.lines = lines;
    }

    public static class Line {

        private String sku;
        private String productName;

        private BigDecimal quantity = BigDecimal.ZERO;
        private BigDecimal unitPrice = BigDecimal.ZERO;
        private BigDecimal stockValue = BigDecimal.ZERO;

        public String getSku() {
            return sku;
        }

        public void setSku(String sku) {
            this.sku = sku;
        }

        public String getProductName() {
            return productName;
        }

        public void setProductName(String productName) {
            this.productName = productName;
        }

        public BigDecimal getQuantity() {
            return quantity;
        }

        public void setQuantity(BigDecimal quantity) {
            this.quantity = quantity;
        }

        public BigDecimal getUnitPrice() {
            return unitPrice;
        }

        public void setUnitPrice(BigDecimal unitPrice) {
            this.unitPrice = unitPrice;
        }

        public BigDecimal getStockValue() {
            return stockValue;
        }

        public void setStockValue(BigDecimal stockValue) {
            this.stockValue = stockValue;
        }
    }
}
