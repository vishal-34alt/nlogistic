
package operations;

import java.util.List;
import model.Container;

public interface ContainerOperations {

    int insertContainer(Container container) throws Exception;

    List<Container> getContainersBySeller(Integer sellerId)
            throws Exception;

    List<Container> searchContainers(int actor,int seller,String query,String status)throws Exception;
    void deleteEligibleContainer(int actor,int seller,int containerId)throws Exception;
    Container updateContainerField(
            int userId,
            int containerId,
            String fieldName,
            String newValue,
            String ipAddress
    ) throws Exception;
}
