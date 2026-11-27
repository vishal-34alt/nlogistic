package model;
import java.util.ArrayList;
import java.util.List;
public class StockImportReport {
    private List<StockImportResult> rows = new ArrayList<StockImportResult>();
    public List<StockImportResult> getRows(){return rows;} public void setRows(List<StockImportResult> v){rows=v;}
    public int getSuccessCount(){int n=0; for(StockImportResult r:rows) if(r.isSuccess()) n++; return n;}
    public int getErrorCount(){return rows.size()-getSuccessCount();}
}
