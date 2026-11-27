package implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.DemandForecast;
import operations.DemandForecastOperations;

public class DemandForecastImplementor implements DemandForecastOperations {

    @Override
    public List<DemandForecast> getDemandForecast(Integer sellerCompanyId)
            throws SQLException {

        List<DemandForecast> list = new ArrayList<>();

        String sql = "SELECT d.* FROM demand_forecast d WHERE (? IS NULL OR EXISTS (SELECT 1 FROM pricing_rules pr WHERE pr.seller_id=? AND pr.origin_port_id=d.origin_port_id AND pr.dest_port_id=d.dest_port_id AND pr.container_type=d.container_type)) ORDER BY d.forecast_month DESC, d.forecast_id DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                DemandForecast d = new DemandForecast();

                d.setForecastId(rs.getInt("forecast_id"));
                d.setOriginPortId(rs.getInt("origin_port_id"));
                d.setDestPortId(rs.getInt("dest_port_id"));
                d.setContainerType(rs.getString("container_type"));
                d.setForecastMonth(rs.getDate("forecast_month"));
                d.setPredictedBookings(rs.getInt("predicted_bookings"));
                d.setConfidencePct(rs.getBigDecimal("confidence_pct"));
                d.setSuggestedMultiplier(rs.getBigDecimal("suggested_multiplier"));

                list.add(d);
            }
            }
        }

        return list;
    }
}