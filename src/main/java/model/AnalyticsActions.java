package model;
import java.sql.SQLException;
import java.util.*;
import implementor.*;
import operations.*;
/** Scoped dashboard queries are coordinated by the model, not by the Servlet. */
public final class AnalyticsActions {
 private final SalesTrendOperations sales=new SalesTrendImplementor();
 private final ABCClassificationOperations abc=new ABCClassificationImplementor();
 private final InventoryTurnoverOperations inventory=new InventoryTurnoverImplementor();
 private final ProfitabilityOperations profit=new ProfitabilityImplementor();
 private final DemandForecastOperations forecast=new DemandForecastImplementor();
 private final AnalyticsProfitLossOperations ledger=new AnalyticsProfitLossImplementor();
 private final UserOperations accounts=new UserImplementor();
 private final AnalyticsMaintenanceOperations maintenance=new AnalyticsMaintenanceImplementor();
 private final PricingOperations pricing=new PricingImplementor();
 public int refreshSalesCache(int actor)throws SQLException{return maintenance.refreshSalesCache(actor);}
 public int baselineForecast(int actor,int origin,int dest,String containerType,String month)throws SQLException {
    java.time.LocalDate date;
    try{date=java.time.LocalDate.parse(month);}catch(Exception e){throw new IllegalArgumentException("Forecast month must be a date");}
    return maintenance.generateBaselineForecast(actor,origin,dest,containerType,date);
 }
 public void applySuggestedMultiplier(int actor,int ruleId,int forecastId)throws Exception{
  User user=accounts.getUserById(actor);
  if(user==null||!"SELLER".equals(user.getRole())||user.getCompanyId()==null)throw new SecurityException("Seller account required");
  DemandForecast chosen=null;
  for(DemandForecast f:forecast.getDemandForecast(user.getCompanyId()))if(f.getForecastId()==forecastId)chosen=f;
  if(chosen==null||chosen.getSuggestedMultiplier()==null||chosen.getSuggestedMultiplier().compareTo(java.math.BigDecimal.ZERO)<=0||chosen.getSuggestedMultiplier().compareTo(new java.math.BigDecimal("99.99"))>0)throw new IllegalArgumentException("No valid forecast multiplier available");
  boolean eligible=false;
  for(java.util.Map<String,Object> rule:pricing.getPricingRules(user.getCompanyId())){
   if(rule.get("rule_id") instanceof Number&&((Number)rule.get("rule_id")).intValue()==ruleId){
    eligible=chosen.getOriginPortId()==((Number)rule.get("origin_port_id")).intValue()&&chosen.getDestPortId()==((Number)rule.get("dest_port_id")).intValue()&&chosen.getContainerType().equals(String.valueOf(rule.get("container_type")));
    break;
   }
  }
  if(!eligible)throw new SecurityException("Forecast and pricing rule must match your seller company and route");
  pricing.updatePricingRuleField(actor,ruleId,"demand_multiplier",chosen.getSuggestedMultiplier().toPlainString());
 }

 /** Only the active actor's DB role/company determines the permitted analytics scope. */
 public Map<String,Object> dashboard(int actorId,String fromRaw,String toRaw)throws SQLException {
    return dashboard(actorId,fromRaw,toRaw,null,null,null,"route");
 }
 public Map<String,Object> dashboard(int actorId,String fromRaw,String toRaw,Integer origin,Integer dest,Integer companyFilter)throws SQLException {
  return dashboard(actorId,fromRaw,toRaw,origin,dest,companyFilter,"route");
 }
 public Map<String,Object> dashboard(int actorId,String fromRaw,String toRaw,Integer origin,Integer dest,Integer companyFilter,String trendBy)throws SQLException {
  if(trendBy==null||trendBy.trim().isEmpty())trendBy="route";
  if(!"route".equals(trendBy)&&!"product".equals(trendBy)&&!"customer".equals(trendBy))
   throw new IllegalArgumentException("Sales Trend must be grouped by Route, Product or Customer");
  User actor=accounts.getUserById(actorId);
  if(actor==null)throw new SecurityException("Active account required");
  String role=actor.getRole();
  if(!"ADMIN".equals(role)&&!"SELLER".equals(role))throw new SecurityException("Analytics are restricted to authorized roles");
  Integer companyId="SELLER".equals(role)?actor.getCompanyId():companyFilter;
  if(companyFilter!=null&&companyFilter<=0||origin!=null&&origin<=0||dest!=null&&dest<=0)throw new IllegalArgumentException("Invalid route or company ID");
  if("ADMIN".equals(role)&&companyFilter!=null){
   boolean found=false;
   for(Company c:new CompanyImplementor().getAllCompanies())if(c.getCompanyId()==companyFilter&&"SELLER".equals(c.getCompanyType()))found=true;
   if(!found)throw new IllegalArgumentException("Choose a valid seller company");
  }
  if("SELLER".equals(role)&&companyId==null)throw new SecurityException("Seller company missing");
  java.time.LocalDate from=date(fromRaw),to=date(toRaw);
  if(from!=null&&to!=null&&from.isAfter(to))throw new IllegalArgumentException("Start date must not be after end date");
  Map<String,Object> result=new LinkedHashMap<>();
  // Detailed monthly groups come from authorized, route-scoped sales records.
  // Compute growth against the SAME category in the preceding calendar month
  // before date filters, so January can compare correctly against December.
  List<SalesTrend> salesList=groupedSales(sales.getSalesTrends(companyId,trendBy,origin,dest));
  salesList.removeIf(x->!between(x.getPeriodMonth(),from,to));
  List<AnalyticsProfitLoss> profitList=new ArrayList<>(ledger.getProfitLoss(companyId));
  profitList.removeIf(x->!between(x.getPeriodMonth(),from,to));
  if(origin!=null||dest!=null){
   Set<Integer> shipmentIds=maintenance.shipmentIdsForRoute(companyId,origin,dest);
   profitList.removeIf(x->!shipmentIds.contains(x.getShipmentId()));
  }
  List<Profitability> productProfit=new ArrayList<>(profit.getProfitability(companyId));
  productProfit.removeIf(x->!between(x.getPeriodMonth(),from,to));
  List<InventoryTurnover> stockTurnover=new ArrayList<>(inventory.getInventoryTurnover(companyId));
  stockTurnover.removeIf(x->!between(x.getPeriodEnd(),from,to));
  List<ABCClassification> abcList=abc.getABCClassification(companyId);
  result.put("salesList",salesList);
  result.put("salesTrendBy",trendBy);
  result.put("salesTrendRouteSelected","route".equals(trendBy)?"selected=\"selected\"":"");
  result.put("salesTrendProductSelected","product".equals(trendBy)?"selected=\"selected\"":"");
  result.put("salesTrendCustomerSelected","customer".equals(trendBy)?"selected=\"selected\"":"");
  result.put("salesTrendFirstLabel","route".equals(trendBy)?"Origin port":"product".equals(trendBy)?"SKU":"Customer ID");
  result.put("salesTrendSecondLabel","route".equals(trendBy)?"Destination port":"product".equals(trendBy)?"Product name":"Customer company");
  result.put("salesTrendTitle","route".equals(trendBy)?"Route-wise":"product".equals(trendBy)?"Product-wise":"Customer-wise");
  result.put("salesRouteList",(origin==null&&dest==null)?sales.getSalesByRoute(companyId):java.util.Collections.emptyList());
  result.put("salesDateList",(origin==null&&dest==null&&from==null&&to==null)?sales.getSalesByDate(companyId):java.util.Collections.emptyList());
  result.put("salesCompanyList",(origin==null&&dest==null)?sales.getSalesByCompany(companyId):java.util.Collections.emptyList());
  result.put("abcList",abcList);
  result.put("inventoryList",stockTurnover);
  result.put("profitabilityList",productProfit);
  List<DemandForecast> forecasts=new ArrayList<>(forecast.getDemandForecast(companyId));
  forecasts.removeIf(x->origin!=null&&x.getOriginPortId()!=origin||dest!=null&&x.getDestPortId()!=dest);
  result.put("forecastList",forecasts);
  result.put("analyticsRole",role);
  result.put("analyticsCompany",companyFilter==null?"":companyFilter);
  result.put("analyticsOrigin",origin==null?"":origin);
  result.put("analyticsDest",dest==null?"":dest);
  result.put("kpiSummary",new DashboardActions().summary(actorId));
  if("SELLER".equals(role))result.put("pricingChoices",pricingChoices(actorId,companyId));
  result.put("profitLossList",profitList);
  result.put("salesChartJson",AnalyticsChartData.sales(salesList));
  result.put("abcChartJson",AnalyticsChartData.abc(abcList));
  result.put("profitChartJson",AnalyticsChartData.profit(profitList));
  result.put("reportFrom",fromRaw==null?"":fromRaw.trim());
  result.put("reportTo",toRaw==null?"":toRaw.trim());
  return result;
 }
 /** Category-wise MoM: a route compares with itself, a product with itself,
  * and a customer with itself. A missing immediately preceding month is N/A.
  */
 static List<SalesTrend> groupedSales(List<SalesTrend> source){
  java.util.Map<String,java.util.TreeMap<java.time.LocalDate,SalesTrend>> byGroup=new java.util.LinkedHashMap<>();
  if(source!=null)for(SalesTrend row:source){
   if(row==null||row.getPeriodMonth()==null||row.getGroupKey()==null)continue;
   java.time.LocalDate month=row.getPeriodMonth().toLocalDate().withDayOfMonth(1);
   java.util.TreeMap<java.time.LocalDate,SalesTrend> history=byGroup.computeIfAbsent(row.getGroupKey(),k->new java.util.TreeMap<>());
   SalesTrend previous=history.putIfAbsent(month,row);
   if(previous!=null){ // Defensive merger for duplicate source-group-month rows.
    previous.setTotalSales((previous.getTotalSales()==null?java.math.BigDecimal.ZERO:previous.getTotalSales())
      .add(row.getTotalSales()==null?java.math.BigDecimal.ZERO:row.getTotalSales()));
    previous.setTotalQty(previous.getTotalQty()+row.getTotalQty());
   }
  }
  List<SalesTrend> rows=new ArrayList<>();
  for(java.util.TreeMap<java.time.LocalDate,SalesTrend> history:byGroup.values())
   for(java.util.Map.Entry<java.time.LocalDate,SalesTrend> entry:history.entrySet()){
    SalesTrend row=entry.getValue();
    SalesTrend prior=history.get(entry.getKey().minusMonths(1));
    row.setGrowthPct(prior==null?null:row.calculateGrowthPct(prior.getTotalSales()));
    rows.add(row);
   }
  rows.sort(java.util.Comparator.comparing(SalesTrend::getPeriodMonth)
       .thenComparing(r->r.getGroupName()==null?"":r.getGroupName())
       .thenComparing(r->r.getGroupCode()==null?"":r.getGroupCode()));
  return rows;
 }
 private List<Map<String,Object>> pricingChoices(int actor,int company)throws SQLException{
    try{return pricing.getPricingRules(company);}catch(Exception e){
      if(e instanceof SQLException)throw (SQLException)e;
      throw new SQLException("Unable to load pricing options",e);
    }
 }
 private static java.time.LocalDate date(String raw){
   if(raw==null||raw.trim().isEmpty())return null;
   try{return java.time.LocalDate.parse(raw.trim());}
   catch(java.time.format.DateTimeParseException ex){throw new IllegalArgumentException("Invalid report date (use YYYY-MM-DD)");}
 }
 private static boolean between(java.sql.Date day,java.time.LocalDate from,java.time.LocalDate to){
   if(day==null)return from==null&&to==null;
   java.time.LocalDate date=day.toLocalDate();
   return (from==null||!date.isBefore(from))&&(to==null||!date.isAfter(to));
 }
}
