
package implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.InventoryTurnover;
import operations.InventoryTurnoverOperations;

public class InventoryTurnoverImplementor
        implements InventoryTurnoverOperations {

    @Override
    public List<InventoryTurnover> getInventoryTurnover(Integer sellerCompanyId)
            throws SQLException {

        List<InventoryTurnover> list = new ArrayList<>();

        String sql = "SELECT r.* FROM inventory_turnover_result r JOIN products p ON p.product_id=r.product_id WHERE (? IS NULL OR p.owner_company_id=?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                InventoryTurnover i = new InventoryTurnover();

                i.setResultId(rs.getInt("result_id"));
                i.setProductId(rs.getInt("product_id"));
                i.setPeriodStart(rs.getDate("period_start"));
                i.setPeriodEnd(rs.getDate("period_end"));
                i.setCogs(rs.getBigDecimal("cogs"));
                i.setAvgInventory(rs.getBigDecimal("avg_inventory"));
                i.setTurnoverRatio(rs.getBigDecimal("turnover_ratio"));

                list.add(i);
            }
            }
        }

        return list;
    }
}
