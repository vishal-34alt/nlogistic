package model;
import java.util.*;import operations.DirectoryOperations;import implementor.DirectoryImplementor;
/** View-ready live catalogue and directory. IDs are submitted but never displayed as data-entry requirements. */
public final class DirectoryActions {
 private final DirectoryOperations dao=new DirectoryImplementor();
 public List<Map<String,Object>> products(int actor)throws Exception{return dao.availableProducts(actor);}
 public List<Map<String,Object>> ports(int actor)throws Exception{return dao.availablePorts(actor);}
 public List<Map<String,Object>> routes(int actor,int productId,java.sql.Date bookingDate)throws Exception{return dao.availableRoutes(actor,productId,bookingDate);}
 public Map<String,Object> routePage(int actor,int productId,java.sql.Date date,String query,String sort,int page,int size,boolean activeOnly,int originPortId,int destPortId)throws Exception{return dao.routePage(actor,productId,date,query,sort,page,size,activeOnly,originPortId,destPortId);}
}
