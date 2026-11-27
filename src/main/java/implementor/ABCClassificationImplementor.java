
package implementor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.ABCClassification;
import operations.ABCClassificationOperations;

public class ABCClassificationImplementor
        implements ABCClassificationOperations {

    @Override
    public List<ABCClassification> getABCClassification(Integer sellerCompanyId)
            throws SQLException {

        List<ABCClassification> list = new ArrayList<>();

        String sql = "SELECT r.* FROM abc_classification_result r JOIN products p ON p.product_id=r.product_id WHERE (? IS NULL OR p.owner_company_id=?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if(sellerCompanyId==null){ps.setNull(1,java.sql.Types.INTEGER);ps.setNull(2,java.sql.Types.INTEGER);}else{ps.setInt(1,sellerCompanyId);ps.setInt(2,sellerCompanyId);}
            try(ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                ABCClassification a = new ABCClassification();

                a.setResultId(rs.getInt("result_id"));
                a.setProductId(rs.getInt("product_id"));
                a.setAnnualValue(rs.getBigDecimal("annual_value"));
                a.setCumulativePct(rs.getBigDecimal("cumulative_pct"));
                a.setAbcClass(rs.getString("abc_class"));
                a.setCalculatedOn(rs.getDate("calculated_on"));

                list.add(a);
            }
            }
        }

        return list;
    }
}
