
package implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.Profitability;
import operations.ProfitabilityOperations;

public class ProfitabilityImplementor implements ProfitabilityOperations {

    @Override
    public List<Profitability> getProfitability(Integer sellerCompanyId)
            throws SQLException {

        List<Profitability> list = new ArrayList<>();

        String sql = "SELECT r.* FROM profitability_result r JOIN products p ON p.product_id=r.product_id WHERE (? IS NULL OR p.owner_company_id=?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Profitability p = new Profitability();

                p.setResultId(rs.getInt("result_id"));
                p.setProductId(rs.getInt("product_id"));
                p.setPeriodMonth(rs.getDate("period_month"));
                p.setRevenue(rs.getBigDecimal("revenue"));
                p.setCost(rs.getBigDecimal("cost"));
                p.setMarginPct(rs.getBigDecimal("margin_pct"));

                list.add(p);
            }
            }
        }

        return list;
    }
}
