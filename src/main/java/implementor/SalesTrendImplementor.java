package implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import db_config.GetConnection;
import model.SalesTrend;
import operations.SalesTrendOperations;

public class SalesTrendImplementor implements SalesTrendOperations {

    // ==========================================
    // EXISTING SALES TREND
    // ==========================================

    @Override
    public List<SalesTrend> getSalesTrends(Integer sellerCompanyId) throws SQLException {
        return getSalesTrends(sellerCompanyId, "route", null, null);
    }

    /** SQL and category grouping stay in the Implementor. A fixed whitelist
     * prevents arbitrary user input from becoming a SQL identifier. */
    @Override
    public List<SalesTrend> getSalesTrends(Integer sellerCompanyId, String trendBy,
                                           Integer originPortId, Integer destPortId) throws SQLException {
        if (!"route".equals(trendBy) && !"product".equals(trendBy) && !"customer".equals(trendBy))
            throw new IllegalArgumentException("Select Route, Product or Customer for Sales Trend");

        String month = "STR_TO_DATE(DATE_FORMAT(st.sale_date,'%Y-%m-01'),'%Y-%m-%d')";
        String code, name, groupKey, chartLabel, joins = "";
        StringBuilder groupBy = new StringBuilder(month);
        if ("route".equals(trendBy)) {
            joins = " JOIN ports op ON op.port_id=sh.origin_port_id"
                  + " JOIN ports dp ON dp.port_id=sh.dest_port_id";
            groupKey = "CONCAT('route:',sh.origin_port_id,':',sh.dest_port_id)";
            code = "CONCAT(op.port_code,' · ',op.port_name)";
            name = "CONCAT(dp.port_code,' · ',dp.port_name)";
            chartLabel = "CONCAT(op.port_code,' → ',dp.port_code)";
            groupBy.append(", sh.origin_port_id, sh.dest_port_id, op.port_code, op.port_name, dp.port_code, dp.port_name");
        } else if ("product".equals(trendBy)) {
            joins = " JOIN products p ON p.product_id=st.product_id";
            groupKey = "CONCAT('product:',st.product_id)";
            code = "p.sku";
            name = "p.product_name";
            chartLabel = "CONCAT(p.sku,' · ',p.product_name)";
            groupBy.append(", st.product_id, p.sku, p.product_name");
        } else {
            joins = " JOIN customers cu ON cu.customer_id=sh.consumer_id"
                  + " JOIN companies cc ON cc.company_id=cu.company_id";
            groupKey = "CONCAT('customer:',sh.consumer_id)";
            code = "CAST(sh.consumer_id AS CHAR)";
            name = "cc.company_name";
            chartLabel = "CONCAT('Customer #',sh.consumer_id,' · ',cc.company_name)";
            groupBy.append(", sh.consumer_id, cc.company_name");
        }
        StringBuilder query = new StringBuilder("SELECT ").append(month).append(" AS period_month, ")
            .append(groupKey).append(" AS group_key, ")
            .append(code).append(" AS group_code, ")
            .append(name).append(" AS group_name, ")
            .append(chartLabel).append(" AS chart_label, ")
            .append("SUM(st.total_amount) AS total_sales, SUM(st.quantity) AS total_qty ")
            .append("FROM sales_transactions st JOIN shipment sh ON sh.shipment_id=st.shipment_id")
            .append(joins).append(" WHERE sh.status<>'CANCELLED'");
        if (sellerCompanyId != null) query.append(" AND sh.seller_id=?");
        if (originPortId != null) query.append(" AND sh.origin_port_id=?");
        if (destPortId != null) query.append(" AND sh.dest_port_id=?");
        query.append(" GROUP BY ").append(groupBy).append(" ORDER BY period_month, group_name, group_code");

        List<SalesTrend> result = new ArrayList<>();
        try (Connection con=GetConnection.getConnection();
             PreparedStatement ps=con.prepareStatement(query.toString())) {
            int param=1;
            if (sellerCompanyId!=null) ps.setInt(param++, sellerCompanyId);
            if (originPortId!=null) ps.setInt(param++, originPortId);
            if (destPortId!=null) ps.setInt(param++, destPortId);
            try (ResultSet rs=ps.executeQuery()) {
                while (rs.next()) {
                    SalesTrend row=new SalesTrend();
                    row.setPeriodMonth(rs.getDate("period_month"));
                    row.setGroupKey(rs.getString("group_key"));
                    row.setGroupCode(rs.getString("group_code"));
                    row.setGroupName(rs.getString("group_name"));
                    row.setChartLabel(rs.getString("chart_label"));
                    row.setTotalSales(rs.getBigDecimal("total_sales"));
                    row.setTotalQty(rs.getInt("total_qty"));
                    result.add(row);
                }
            }
        }
        return result;
    }

    // ==========================================
    // SALES BY ROUTE
    // ==========================================

    @Override
    public List<Map<String, Object>> getSalesByRoute(Integer sellerCompanyId)
            throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            "SELECT CONCAT(op.port_name, ' - ', dp.port_name) AS label, " +
            "SUM(st.total_amount) AS total_sales " +
            "FROM sales_transactions st " +
            "JOIN shipment s ON st.shipment_id = s.shipment_id " +
            "JOIN ports op ON s.origin_port_id = op.port_id " +
            "JOIN ports dp ON s.dest_port_id = dp.port_id " +
            "WHERE s.status <> 'CANCELLED' AND (? IS NULL OR s.seller_id=?) " +
            "GROUP BY s.origin_port_id, s.dest_port_id, " +
            "op.port_name, dp.port_name " +
            "ORDER BY total_sales DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row = new HashMap<>();

                row.put("label", rs.getString("label"));
                row.put("totalSales", rs.getBigDecimal("total_sales"));

                list.add(row);
            }
            }
        }

        return list;
    }

    // ==========================================
    // SALES BY DATE
    // ==========================================

    @Override
    public List<Map<String, Object>> getSalesByDate(Integer sellerCompanyId)
            throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            "SELECT st.sale_date AS label, " +
            "SUM(st.total_amount) AS total_sales " +
            "FROM sales_transactions st " +
            "JOIN shipment s ON st.shipment_id = s.shipment_id " +
            "WHERE s.status <> 'CANCELLED' AND (? IS NULL OR s.seller_id=?) " +
            "GROUP BY st.sale_date " +
            "ORDER BY st.sale_date";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row = new HashMap<>();

                row.put("label", rs.getDate("label").toString());
                row.put("totalSales", rs.getBigDecimal("total_sales"));

                list.add(row);
            }
            }
        }

        return list;
    }

    // ==========================================
    // SALES BY COMPANY
    // ==========================================

    @Override
    public List<Map<String, Object>> getSalesByCompany(Integer sellerCompanyId)
            throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
            "SELECT c.company_name AS label, " +
            "SUM(st.total_amount) AS total_sales " +
            "FROM sales_transactions st " +
            "JOIN shipment s ON st.shipment_id = s.shipment_id " +
            "JOIN companies c ON s.seller_id = c.company_id " +
            "WHERE s.status <> 'CANCELLED' AND (? IS NULL OR s.seller_id=?) " +
            "GROUP BY s.seller_id, c.company_name " +
            "ORDER BY total_sales DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> row = new HashMap<>();

                row.put("label", rs.getString("label"));
                row.put("totalSales", rs.getBigDecimal("total_sales"));

                list.add(row);
            }
            }
        }

        return list;
    }
}