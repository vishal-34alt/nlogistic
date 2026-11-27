package operations;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import model.SalesTrend;

public interface SalesTrendOperations {

    // Existing sales trend
    List<SalesTrend> getSalesTrends(Integer sellerCompanyId) throws SQLException;
    // Authorized monthly sales grouped by route, product or customer and filtered by shipment route.
    List<SalesTrend> getSalesTrends(Integer sellerCompanyId, String trendBy,
                                   Integer originPortId, Integer destPortId) throws SQLException;

    // Sales by route
    List<Map<String, Object>> getSalesByRoute(Integer sellerCompanyId) throws SQLException;

    // Sales by date
    List<Map<String, Object>> getSalesByDate(Integer sellerCompanyId) throws SQLException;

    // Sales by company
    List<Map<String, Object>> getSalesByCompany(Integer sellerCompanyId) throws SQLException;
}