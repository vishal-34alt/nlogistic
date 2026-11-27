
package operations;

import java.sql.SQLException;
import java.util.List;
import model.Company;

public interface CompanyOperations {

    // Insert new company
    int insertCompany(Company company) throws SQLException;

    // Update one specific company field
    boolean updateCompanyField(
        int userId,
        int recordId,
        String fieldName,
        String newValue,
        String ipAddress
    ) throws SQLException;

    // Delete company
    boolean deleteCompany(int companyId) throws SQLException;

    // Display all companies
    List<Company> getAllCompanies() throws SQLException;

    // Search companies
    List<Company> searchCompanies(
        String keyword,
        String companyType
    ) throws SQLException;
}
