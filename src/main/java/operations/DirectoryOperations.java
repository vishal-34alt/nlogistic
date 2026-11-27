package operations;
import java.util.List;import java.util.Map;
public interface DirectoryOperations {
 List<Map<String,Object>> availableProducts(int userId)throws Exception;
 List<Map<String,Object>> availablePorts(int userId)throws Exception;
 List<Map<String,Object>> availableRoutes(int userId,int productId,java.sql.Date bookingDate)throws Exception;
 Map<String,Object> routePage(int userId,int productId,java.sql.Date bookingDate,String query,String sort,int page,int pageSize,boolean activeOnly,int originPortId,int destPortId)throws Exception;
}
