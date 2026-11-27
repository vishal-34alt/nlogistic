
package implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.AnalyticsProfitLoss;
import operations.AnalyticsProfitLossOperations;

public class AnalyticsProfitLossImplementor implements AnalyticsProfitLossOperations {

    @Override
    public List<AnalyticsProfitLoss> getProfitLoss(Integer sellerCompanyId) throws SQLException {

        List<AnalyticsProfitLoss> list = new ArrayList<>();

        String sql = "SELECT * FROM profit_loss WHERE (? IS NULL OR seller_id=?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                AnalyticsProfitLoss p = new AnalyticsProfitLoss();

                p.setPlId(rs.getInt("pl_id"));
                p.setShipmentId(rs.getInt("shipment_id"));
                p.setSellerId(rs.getInt("seller_id"));
                p.setPeriodMonth(rs.getDate("period_month"));
                p.setRevenue(rs.getBigDecimal("revenue"));
                p.setFreightCost(rs.getBigDecimal("freight_cost"));
                p.setPortCost(rs.getBigDecimal("port_cost"));
                p.setHandlingCost(rs.getBigDecimal("handling_cost"));
                p.setClaimLoss(rs.getBigDecimal("claim_loss"));
                p.setNetProfit(rs.getBigDecimal("net_profit"));

                list.add(p);
            }
            }
        }

        return list;
    }
}
