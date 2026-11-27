
package implementor;

import db_config.GetConnection;
import model.Customer;
import operations.CustomerOperations;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CustomerImplementor implements CustomerOperations {

    @Override
    public int insertCustomer(Customer customer) throws SQLException {

        String sql = "{CALL sp_insert_customer(?, ?, ?, ?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, customer.getUserId());
            cs.setInt(2, customer.getCompanyId());
            cs.setString(3, customer.getContactPerson());
            cs.setString(4, customer.getBillingAddress());

            if (customer.getCreditLimit() == null) {
                cs.setNull(5, Types.DECIMAL);
            } else {
                cs.setBigDecimal(5, customer.getCreditLimit());
            }

            boolean hasResult = cs.execute();

            if (hasResult) {
                try (ResultSet rs = cs.getResultSet()) {
                    if (rs.next()) {
                        return rs.getInt("customer_id");
                    }
                }
            }
        }

        return 0;
    }

    @Override
    public boolean updateCustomerField(
            int userId,
            int recordId,
            String fieldName,
            String newValue,
            String ipAddress) throws SQLException {

        String sql = "{CALL sp_update_customer_field(?, ?, ?, ?, ?)}";

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
    public boolean deleteConsumer(
            int actorId,
            int customerId) throws SQLException {

        String sql = "{CALL sp_delete_consumer(?, ?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, actorId);
            cs.setInt(2, customerId);

            cs.execute();

            return true;
        }
    }

    @Override
    public List<Customer> getAllCustomers() throws SQLException {

        List<Customer> customers = new ArrayList<>();

        String sql = "{CALL sp_show_customers()}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                customers.add(mapCustomer(rs));
            }
        }

        return customers;
    }

    @Override
    public List<Customer> searchCustomers(String keyword)
            throws SQLException {

        List<Customer> customers = new ArrayList<>();

        String sql = "{CALL sp_search_customers(?)}";

        try (Connection con = GetConnection.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            if (keyword == null || keyword.trim().isEmpty()) {
                cs.setNull(1, Types.VARCHAR);
            } else {
                cs.setString(1, keyword);
            }

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapCustomer(rs));
                }
            }
        }

        return customers;
    }

    private Customer mapCustomer(ResultSet rs) throws SQLException {

        Customer customer = new Customer();

        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setUserId(rs.getInt("user_id"));
        customer.setCompanyId(rs.getInt("company_id"));
        customer.setContactPerson(rs.getString("contact_person"));
        customer.setBillingAddress(rs.getString("billing_address"));
        customer.setCreditLimit(rs.getBigDecimal("credit_limit"));

        return customer;
    }
}
