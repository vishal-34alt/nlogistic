
package implementor;

import db_config.GetConnection;
import model.Company;
import operations.CompanyOperations;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CompanyImplementor implements CompanyOperations {

    private static void optionalText(CallableStatement cs, int index, String text) throws SQLException {
        if (text == null || text.trim().isEmpty()) cs.setNull(index, Types.VARCHAR);
        else cs.setString(index, text.trim());
    }

    @Override
    public int insertCompany(Company company) throws SQLException {

        String sql = "{CALL sp_insert_company(?, ?, ?, ?, ?, ?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, company.getCompanyName().trim());
            cs.setString(2, company.getCompanyType().trim().toUpperCase(java.util.Locale.ROOT));
            optionalText(cs, 3, company.getGstNumber());
            optionalText(cs, 4, company.getIecCode());
            optionalText(cs, 5, company.getAddress());
            optionalText(cs, 6, company.getCity());
            optionalText(cs, 7, company.getCountry());

            boolean hasResult = cs.execute();

            if (hasResult) {
                try (ResultSet rs = cs.getResultSet()) {
                    if (rs.next()) {
                        return rs.getInt("company_id");
                    }
                }
            }
        }

        return 0;
    }

    @Override
    public boolean updateCompanyField(
            int userId,
            int recordId,
            String fieldName,
            String newValue,
            String ipAddress) throws SQLException {

        String sql = "{CALL sp_update_company_field(?, ?, ?, ?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, userId);
            cs.setInt(2, recordId);
            cs.setString(3, fieldName);
            cs.setString(4, newValue);
            cs.setString(5, ipAddress);

            cs.execute();

            return true;
        }
    }

    @Override
    public boolean deleteCompany(int companyId) throws SQLException {
        // The DB's FK constraints are authoritative. No CASCADE or disabling foreign keys.
        try(Connection con=GetConnection.getConnection()){
            con.setAutoCommit(false);
            try {
                try(java.sql.PreparedStatement refs=con.prepareStatement("SELECT (SELECT COUNT(*) FROM users WHERE company_id=?) + (SELECT COUNT(*) FROM containers WHERE seller_id=?) + (SELECT COUNT(*) FROM products WHERE owner_company_id=?) + (SELECT COUNT(*) FROM customers WHERE company_id=?) + (SELECT COUNT(*) FROM shipment WHERE seller_id=?) + (SELECT COUNT(*) FROM vessels WHERE owner_company_id=?) + (SELECT COUNT(*) FROM pricing_rules WHERE seller_id=?)")){
                    for(int i=1;i<=7;i++)refs.setInt(i,companyId);
                    try(ResultSet rs=refs.executeQuery()){rs.next();if(rs.getLong(1)>0)throw new SQLException("Company is referenced by users, inventory, pricing or shipment history. Deletion is blocked.","45000");}
                }
                try(java.sql.PreparedStatement s=con.prepareStatement("DELETE FROM companies WHERE company_id=?")){
                    s.setInt(1,companyId);if(s.executeUpdate()!=1)throw new SQLException("Company not found","45000");
                }
                con.commit();return true;
            }catch(SQLException|RuntimeException e){con.rollback();throw e;}finally{con.setAutoCommit(true);}
        }
    }

    @Override
    public List<Company> getAllCompanies() throws SQLException {

        List<Company> companies = new ArrayList<>();

        String sql = "{CALL sp_show_companies()}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                companies.add(mapCompany(rs));
            }
        }

        return companies;
    }

    @Override
    public List<Company> searchCompanies(
            String keyword,
            String companyType) throws SQLException {

        List<Company> companies = new ArrayList<>();

        String sql = "{CALL sp_search_companies(?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            if (keyword == null || keyword.trim().isEmpty()) {
                cs.setNull(1, Types.VARCHAR);
            } else {
                cs.setString(1, keyword);
            }

            if (companyType == null || companyType.trim().isEmpty()) {
                cs.setNull(2, Types.VARCHAR);
            } else {
                cs.setString(2, companyType);
            }

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    companies.add(mapCompany(rs));
                }
            }
        }

        return companies;
    }

    private Company mapCompany(ResultSet rs) throws SQLException {

        Company company = new Company();

        company.setCompanyId(rs.getInt("company_id"));
        company.setCompanyName(rs.getString("company_name"));
        company.setCompanyType(rs.getString("company_type"));
        company.setGstNumber(rs.getString("gst_number"));
        company.setIecCode(rs.getString("iec_code"));
        company.setAddress(rs.getString("address"));
        company.setCity(rs.getString("city"));
        company.setCountry(rs.getString("country"));

        return company;
    }
}
