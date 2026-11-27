package operations;

import java.sql.SQLException;
import java.util.List;
import model.Company;
import model.InfrastructureRecord;

public interface InfrastructureOperations {
    List<InfrastructureRecord> ports(int admin) throws SQLException;
    List<InfrastructureRecord> vessels(int admin) throws SQLException;
    List<Company> sellerCompanies(int admin) throws SQLException;
    void createPort(int admin, String code, String name, String city, String country) throws SQLException;
    void createPortWithCoordinates(int admin, String code, String name, String city, String country,
                                   String latitude, String longitude) throws SQLException;
    void updatePort(int admin, int id, String field, String value) throws SQLException;
    void updatePortDetails(int admin, int id, String code, String name, String city, String country,
                           String latitude, String longitude) throws SQLException;
    void deletePort(int admin, int id) throws SQLException;
    void createVessel(int admin, String name, String imo, Integer owner, Integer capacity) throws SQLException;
    void createVesselWithNewSeller(int admin, String vesselName, String imo, Integer capacity,
                                   String companyName, String gst, String iec, String address,
                                   String city, String country) throws SQLException;
    void updateVessel(int admin, int id, String field, String value) throws SQLException;
    void updateVesselDetails(int admin, int id, String name, String imo, Integer owner, Integer capacity, String status) throws SQLException;
    void deleteVessel(int admin, int id) throws SQLException;
}
