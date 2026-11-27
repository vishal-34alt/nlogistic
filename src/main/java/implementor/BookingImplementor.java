
package implementor;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.PreparedStatement;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import operations.BookingOperations;
import db_config.GetConnection;
import model.BookingItem;

public class BookingImplementor implements BookingOperations {

    @Override
    public Map<String, Object> calculateQuote(
            int userId,
            int originPortId,
            int destPortId,
            Date bookingDate,
            List<BookingItem> items) throws Exception {

        String sql = "{CALL sp_calculate_quote(?,?,?,?,?)}";

        return executeBookingProcedure(
                sql, false, userId, originPortId,
                destPortId, bookingDate, null, items
        );
    }

    @Override
    public Map<String, Object> confirmBooking(
            int userId,
            int originPortId,
            int destPortId,
            Date bookingDate,
            Date dueDate,
            List<BookingItem> items) throws Exception {

        String sql = "{CALL sp_confirm_booking(?,?,?,?,?,?)}";

        return executeBookingProcedure(
                sql, true, userId, originPortId,
                destPortId, bookingDate, dueDate, items
        );
    }

    private Map<String, Object> executeBookingProcedure(
            String sql,
            boolean confirmation,
            int userId,
            int originPortId,
            int destPortId,
            Date bookingDate,
            Date dueDate,
            List<BookingItem> items) throws Exception {

        if (bookingDate == null) {
            throw new IllegalArgumentException(
                    "Booking date is required.");
        }

        if (confirmation && dueDate == null) {
            throw new IllegalArgumentException(
                    "Due date is required.");
        }

        String itemsJson = convertItemsToJson(items);

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.setInt(2, originPortId);
            cs.setInt(3, destPortId);
            cs.setDate(4, bookingDate);
            cs.setString(5, itemsJson);

            if (confirmation) {
                cs.setDate(6, dueDate);
            }

            try (ResultSet rs = cs.executeQuery()) {

                if (rs.next()) {

                    Map<String, Object> result =
                            new LinkedHashMap<>();

                    result.put("bookingAction",
                            rs.getString("booking_action"));

                    result.put("sellerId",
                            rs.getObject("seller_id"));

                    result.put("containerId",
                            rs.getObject("container_id"));

                    result.put("containerType",
                            rs.getString("container_type"));

                    result.put("ruleId",
                            rs.getObject("rule_id"));

                    result.put("cargoWeightKg",
                            rs.getBigDecimal("cargo_weight_kg"));

                    result.put("cargoVolumeCbm",
                            rs.getBigDecimal("cargo_volume_cbm"));

                    result.put("goodsValue",
                            rs.getBigDecimal("goods_value"));
                    result.put("shippingFreightOnly",
                            rs.getBigDecimal("shipping_freight_only"));
                    result.put("taxRatePercent",
                            rs.getBigDecimal("tax_rate_percent"));

                    result.put("freightAmount",
                            rs.getBigDecimal("freight_amount"));

                    result.put("handlingAmount",
                            rs.getBigDecimal("handling_amount"));

                    result.put("taxAmount",
                            rs.getBigDecimal("tax_amount"));

                    result.put("quotationTotal",
                            rs.getBigDecimal("quotation_total"));

                    result.put("shipmentId",
                            rs.getObject("shipment_id"));

                    result.put("shipmentNo",
                            rs.getString("shipment_no"));

                    result.put("shipmentStatus",
                            rs.getString("shipment_status"));

                    result.put("invoiceId",
                            rs.getObject("invoice_id"));

                    result.put("invoiceNo",
                            rs.getString("invoice_no"));
                    // Actual capacity from the allocated/available container; never estimate it in a JSP.
                    Object containerKey=result.get("containerId");
                    if(containerKey instanceof Number){
                        try(Connection capacityConnection=GetConnection.getConnection();
                            PreparedStatement cap=capacityConnection.prepareStatement(
                                "SELECT container_number,max_weight_kg,max_volume_cbm,status FROM containers WHERE container_id=?")){
                            cap.setInt(1,((Number)containerKey).intValue());
                            try(ResultSet rows=cap.executeQuery()){
                                if(rows.next()){
                                    result.put("containerNumber",rows.getString("container_number"));
                                    result.put("maxWeightKg",rows.getBigDecimal("max_weight_kg"));
                                    result.put("maxVolumeCbm",rows.getBigDecimal("max_volume_cbm"));
                                    result.put("containerAvailability",rows.getString("status"));
                                }
                            }
                        }
                    }
                    return result;
                }
            }
        }

        return null;
    }

    private String convertItemsToJson(List<BookingItem> items) {

        if (items == null || items.isEmpty()) {
            throw new IllegalArgumentException(
                    "At least one booking item is required.");
        }

        StringBuilder json = new StringBuilder("[");

        for (int i = 0; i < items.size(); i++) {

            BookingItem item = items.get(i);

            if (item == null) {
                throw new IllegalArgumentException(
                        "Booking item cannot be null.");
            }

            int productId = item.getProductId();
            int quantity = item.getQuantity();

            BigDecimal unitCbm;

            try {
                unitCbm = new BigDecimal(
                        String.valueOf(item.getUnitCbm()));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException(
                        "Invalid product unit CBM.");
            }

            if (productId <= 0 || quantity <= 0
                    || unitCbm.signum() <= 0) {
                throw new IllegalArgumentException(
                        "Product ID, quantity and unit CBM must be positive.");
            }

            if (i > 0) {
                json.append(",");
            }

            json.append("{")
                .append("\"product_id\":").append(productId)
                .append(",\"quantity\":").append(quantity)
                .append(",\"unit_cbm\":")
                .append(unitCbm.toPlainString())
                .append("}");
        }

        json.append("]");

        return json.toString();
    }
}
