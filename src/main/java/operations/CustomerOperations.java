
package operations;

import java.sql.SQLException;
import java.util.List;
import model.Customer;

public interface CustomerOperations {

    // Insert new customer
    int insertCustomer(Customer customer) throws SQLException;

    // Update one specific customer field
    boolean updateCustomerField(
        int userId,
        int recordId,
        String fieldName,
        String newValue,
        String ipAddress
    ) throws SQLException;

    // Delete customer
    boolean deleteConsumer(
        int actorId,
        int customerId
    ) throws SQLException;

    // Display all customers
    List<Customer> getAllCustomers() throws SQLException;

    // Search customers
    List<Customer> searchCustomers(
        String keyword
    ) throws SQLException;
}
