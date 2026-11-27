package model;

import java.math.BigDecimal;
import java.util.*;

/** JSON chart data assembled from authorized model records; never supplies fictional values. */
public final class AnalyticsChartData {
    private AnalyticsChartData(){}
    private static String decimal(BigDecimal n){return n==null?"0":n.toPlainString();}
    private static void appendJsonString(StringBuilder out,String s){
        out.append('"');
        if(s!=null)for(int i=0;i<s.length();i++){
            char c=s.charAt(i);
            switch(c){
                case '"':out.append("\\\"");break;
                case '\\':out.append("\\\\");break;
                case '<':out.append("\\u003c");break;
                case '>':out.append("\\u003e");break;
                case '&':out.append("\\u0026");break;
                case '\n':out.append("\\n");break;
                case '\r':out.append("\\r");break;
                default:if(c<32)out.append(' ');else out.append(c);
            }
        }
        out.append('"');
    }
    private static void arrayOfStrings(StringBuilder b,Collection<String> items){
        b.append('[');boolean first=true;for(String x:items){if(!first)b.append(',');first=false;appendJsonString(b,x);}b.append(']');
    }
    private static void arrayOfNumbers(StringBuilder b,Collection<BigDecimal> items){
        b.append('[');boolean first=true;for(BigDecimal x:items){if(!first)b.append(',');first=false;b.append(decimal(x));}b.append(']');
    }
    /** FR6.2: revenue and sold-unit volume by month, broken down by the selected
     * route/product/customer category. Chart limits its legend to six leaders
     * plus Other; no sales are dropped, and the full detail remains in the table.
     */
    public static String sales(List<SalesTrend> list){
        TreeMap<String,BigDecimal[]> months=new TreeMap<>();
        Map<String,Map<String,BigDecimal[]>> grouped=new LinkedHashMap<>();
        Map<String,String> labelsByGroup=new LinkedHashMap<>();
        for(SalesTrend row:list)if(row!=null&&row.getPeriodMonth()!=null){
            String month=row.getPeriodMonth().toString().substring(0,7);
            BigDecimal sales=orZero(row.getTotalSales());
            BigDecimal units=BigDecimal.valueOf(row.getTotalQty());
            BigDecimal[] total=months.computeIfAbsent(month,k->new BigDecimal[]{BigDecimal.ZERO,BigDecimal.ZERO});
            total[0]=total[0].add(sales);total[1]=total[1].add(units);
            String key=row.getGroupKey()==null?"all":row.getGroupKey();
            labelsByGroup.putIfAbsent(key,row.getChartLabel()==null?"All sales":row.getChartLabel());
            Map<String,BigDecimal[]> history=grouped.computeIfAbsent(key,k->new HashMap<>());
            BigDecimal[] entry=history.computeIfAbsent(month,k->new BigDecimal[]{BigDecimal.ZERO,BigDecimal.ZERO});
            entry[0]=entry[0].add(sales);entry[1]=entry[1].add(units);
        }
        List<String> keys=new ArrayList<>(grouped.keySet());
        keys.sort((a,b)->{
            BigDecimal ta=BigDecimal.ZERO,tb=BigDecimal.ZERO;
            for(BigDecimal[] r:grouped.get(a).values())ta=ta.add(r[0]);
            for(BigDecimal[] r:grouped.get(b).values())tb=tb.add(r[0]);
            int cmp=tb.compareTo(ta);
            return cmp==0?a.compareTo(b):cmp;
        });
        List<String> dates=new ArrayList<>(months.keySet());
        List<BigDecimal> revenue=new ArrayList<>(),volume=new ArrayList<>();
        for(BigDecimal[] total:months.values()){revenue.add(total[0]);volume.add(total[1]);}
        StringBuilder b=new StringBuilder("{\"labels\":");arrayOfStrings(b,dates);
        b.append(",\"values\":");arrayOfNumbers(b,revenue);
        b.append(",\"volumes\":");arrayOfNumbers(b,volume);
        b.append(",\"groups\":[");
        int limit=Math.min(keys.size(),6);
        for(int idx=0;idx<limit;idx++){
            if(idx>0)b.append(',');
            String key=keys.get(idx);
            appendSalesGroup(b,labelsByGroup.get(key),dates,grouped.get(key));
        }
        if(keys.size()>limit){
            if(limit>0)b.append(',');
            Map<String,BigDecimal[]> other=new HashMap<>();
            for(int i=limit;i<keys.size();i++)for(Map.Entry<String,BigDecimal[]> entry:grouped.get(keys.get(i)).entrySet()){
                BigDecimal[] dest=other.computeIfAbsent(entry.getKey(),k->new BigDecimal[]{BigDecimal.ZERO,BigDecimal.ZERO});
                dest[0]=dest[0].add(entry.getValue()[0]);dest[1]=dest[1].add(entry.getValue()[1]);
            }
            appendSalesGroup(b,"Other categories (combined)",dates,other);
        }
        return b.append("]}").toString();
    }
    private static void appendSalesGroup(StringBuilder b,String label,List<String> months,Map<String,BigDecimal[]> values){
        b.append("{\"label\":");appendJsonString(b,label);
        List<BigDecimal> revenue=new ArrayList<>(),units=new ArrayList<>();
        for(String month:months){
            BigDecimal[] amount=values.get(month);
            revenue.add(amount==null?BigDecimal.ZERO:amount[0]);
            units.add(amount==null?BigDecimal.ZERO:amount[1]);
        }
        b.append(",\"revenue\":");arrayOfNumbers(b,revenue);
        b.append(",\"units\":");arrayOfNumbers(b,units);
        b.append('}');
    }
    /** Both the ABC mix and Pareto chart use the same authorized product records. */
    public static String abc(List<ABCClassification> list){
        Map<String,BigDecimal> counts=new LinkedHashMap<>();
        counts.put("A",BigDecimal.ZERO);counts.put("B",BigDecimal.ZERO);counts.put("C",BigDecimal.ZERO);
        for(ABCClassification x:list){
            String c=x.getAbcClass();
            if(counts.containsKey(c))counts.put(c,counts.get(c).add(BigDecimal.ONE));
        }
        List<ABCClassification> sorted=new ArrayList<>(list);
        sorted.sort((a,b)->orZero(b.getAnnualValue()).compareTo(orZero(a.getAnnualValue())));
        BigDecimal total=BigDecimal.ZERO;
        for(ABCClassification x:sorted)total=total.add(orZero(x.getAnnualValue()));
        List<String> productNames=new ArrayList<>(), classes=new ArrayList<>();
        List<BigDecimal> annual=new ArrayList<>(), cumulative=new ArrayList<>();
        BigDecimal running=BigDecimal.ZERO;
        for(ABCClassification x:sorted){
            running=running.add(orZero(x.getAnnualValue()));
            if(productNames.size()>=12)continue;
            productNames.add("Product "+x.getProductId());
            classes.add(x.getAbcClass()==null?"?":x.getAbcClass());
            annual.add(orZero(x.getAnnualValue()));
            cumulative.add(total.signum()==0?BigDecimal.ZERO:
                running.multiply(new BigDecimal("100")).divide(total,2,java.math.RoundingMode.HALF_UP));
        }
        StringBuilder b=new StringBuilder("{\"labels\":");arrayOfStrings(b,counts.keySet());
        b.append(",\"values\":");arrayOfNumbers(b,counts.values());
        b.append(",\"products\":");arrayOfStrings(b,productNames);
        b.append(",\"annualValues\":");arrayOfNumbers(b,annual);
        b.append(",\"cumulative\":");arrayOfNumbers(b,cumulative);
        b.append(",\"classes\":");arrayOfStrings(b,classes);
        return b.append('}').toString();
    }
    public static String profit(List<AnalyticsProfitLoss> list){
        TreeMap<String,BigDecimal[]> byMonth=new TreeMap<>();
        for(AnalyticsProfitLoss x:list)if(x.getPeriodMonth()!=null){
            String month=x.getPeriodMonth().toString().substring(0,7);
            BigDecimal[] row=byMonth.computeIfAbsent(month,k->new BigDecimal[]{BigDecimal.ZERO,BigDecimal.ZERO,BigDecimal.ZERO});
            row[0]=row[0].add(x.getRevenue()==null?BigDecimal.ZERO:x.getRevenue());
            row[1]=row[1].add(orZero(x.getFreightCost())).add(orZero(x.getPortCost())).add(orZero(x.getHandlingCost())).add(orZero(x.getClaimLoss()));
            row[2]=row[2].add(orZero(x.getNetProfit()));
        }
        StringBuilder b=new StringBuilder("{\"labels\":");arrayOfStrings(b,byMonth.keySet());
        String[] keys={"revenue","cost","profit"};
        for(int col=0;col<3;col++){b.append(',');appendJsonString(b,keys[col]);b.append(':');List<BigDecimal> vals=new ArrayList<>();for(BigDecimal[] item:byMonth.values())vals.add(item[col]);arrayOfNumbers(b,vals);}
        return b.append('}').toString();
    }
    /** A small readable preview from actual inventory-turnover result records. */
    public static String inventory(List<InventoryTurnover> list){
        List<String> labels=new ArrayList<>();
        List<BigDecimal> costs=new ArrayList<>(),average=new ArrayList<>(),ratios=new ArrayList<>();
        for(InventoryTurnover x:list){
            if(labels.size()>=12)break;
            String time=x.getPeriodEnd()==null?"": " · "+x.getPeriodEnd().toString().substring(0,7);
            labels.add("Product "+x.getProductId()+time);
            costs.add(orZero(x.getCogs()));average.add(orZero(x.getAvgInventory()));ratios.add(orZero(x.getTurnoverRatio()));
        }
        StringBuilder b=new StringBuilder("{\"labels\":");arrayOfStrings(b,labels);
        b.append(",\"cogs\":");arrayOfNumbers(b,costs);
        b.append(",\"average\":");arrayOfNumbers(b,average);
        b.append(",\"ratio\":");arrayOfNumbers(b,ratios);
        return b.append('}').toString();
    }
    /** Product revenue, costs and margin from precisely the same visible profitability rows. */
    public static String profitability(List<Profitability> list){
        List<String> labels=new ArrayList<>();
        List<BigDecimal> revenues=new ArrayList<>(),costs=new ArrayList<>(),margins=new ArrayList<>();
        for(Profitability x:list){
            if(labels.size()>=12)break;
            String time=x.getPeriodMonth()==null?"":" · "+x.getPeriodMonth().toString().substring(0,7);
            labels.add("Product "+x.getProductId()+time);
            revenues.add(orZero(x.getRevenue()));costs.add(orZero(x.getCost()));margins.add(orZero(x.getMarginPct()));
        }
        StringBuilder b=new StringBuilder("{\"labels\":");arrayOfStrings(b,labels);
        b.append(",\"revenue\":");arrayOfNumbers(b,revenues);
        b.append(",\"cost\":");arrayOfNumbers(b,costs);
        b.append(",\"margin\":");arrayOfNumbers(b,margins);
        return b.append('}').toString();
    }
    /** Forecast chart shows recorded forecast rows; port labels come from authorized directory data. */
    public static String forecast(List<DemandForecast> list,List<Map<String,Object>> ports){
        Map<Integer,String> portLabels=new HashMap<>();
        if(ports!=null)for(Map<String,Object> p:ports){
            Object id=p.get("id"),label=p.get("label");
            if(id!=null&&label!=null)try{portLabels.put(Integer.valueOf(String.valueOf(id)),String.valueOf(label));}
            catch(NumberFormatException ignored){}
        }
        List<String> labels=new ArrayList<>();
        List<BigDecimal> bookings=new ArrayList<>(),confidence=new ArrayList<>(),multiplier=new ArrayList<>();
        for(DemandForecast x:list){
            if(labels.size()>=12)break;
            String origin=portLabels.getOrDefault(x.getOriginPortId(),"Port "+x.getOriginPortId());
            String destination=portLabels.getOrDefault(x.getDestPortId(),"Port "+x.getDestPortId());
            String month=x.getForecastMonth()==null?"":" · "+x.getForecastMonth().toString().substring(0,7);
            labels.add(origin+" → "+destination+" · "+x.getContainerType()+month);
            bookings.add(BigDecimal.valueOf(x.getPredictedBookings()));
            confidence.add(x.getConfidencePct());multiplier.add(x.getSuggestedMultiplier());
        }
        StringBuilder b=new StringBuilder("{\"labels\":");arrayOfStrings(b,labels);
        b.append(",\"bookings\":");arrayOfNumbers(b,bookings);
        b.append(",\"confidence\":");arrayOfNullableNumbers(b,confidence);
        b.append(",\"multiplier\":");arrayOfNullableNumbers(b,multiplier);
        return b.append('}').toString();
    }
    private static void arrayOfNullableNumbers(StringBuilder b,Collection<BigDecimal> items){
        b.append('[');boolean first=true;
        for(BigDecimal x:items){if(!first)b.append(',');first=false;b.append(x==null?"null":x.toPlainString());}
        b.append(']');
    }
    private static BigDecimal orZero(BigDecimal b){return b==null?BigDecimal.ZERO:b;}
}
