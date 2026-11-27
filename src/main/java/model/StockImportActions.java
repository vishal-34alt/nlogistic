package model;

import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;

/** Stock import orchestration lives in the model, never in the Servlet. */
public final class StockImportActions {
    private final StockActions stock;
    public StockImportActions(StockActions stock){this.stock=stock;}
    public StockImportReport importFile(String filename,InputStream input,int actor,int company)throws Exception{
        List<Map<String,String>> rows=StockImportParser.parse(filename,input);
        StockImportReport report=new StockImportReport();
        Set<String> knownSkus=new HashSet<>();
        for(Product entry:stock.products(actor,company))knownSkus.add(entry.getSku().trim().toLowerCase(Locale.ROOT));
        for(Map<String,String> row:rows){
            StockImportResult result=new StockImportResult();
            result.setRowNumber(Integer.parseInt(row.get("_row")));
            result.setSku(row.get("sku"));
            try{
                String sku=row.get("sku");if(sku==null||sku.trim().isEmpty())throw new IllegalArgumentException("SKU required");
                int qty=Integer.parseInt(row.get("quantity"));
                if(qty<=0)throw new IllegalArgumentException("Positive integer quantity required");
                if(knownSkus.contains(sku.trim().toLowerCase(Locale.ROOT)))
                    throw new IllegalArgumentException("Duplicate SKU: " + sku + ". Use Add stock for existing products.");
                Product prod=new Product();prod.setSku(sku);
                prod.setProductName(row.get("product_name"));prod.setCategory(row.get("category"));
                prod.setHsCode(row.get("hs_code"));prod.setUnit(row.get("unit"));
                prod.setUnitWeightKg(new BigDecimal(row.get("unit_weight_kg")));
                prod.setUnitPrice(new BigDecimal(row.get("unit_price")));
                stock.createProduct(prod,actor,company);
                Integer id=null;
                for(Product candidate:stock.products(actor,company))if(sku.trim().equalsIgnoreCase(candidate.getSku().trim())){id=candidate.getProductId();break;}
                if(id==null)throw new SQLException("Created product could not be located");
                knownSkus.add(sku.trim().toLowerCase(Locale.ROOT));
                stock.addStock(id,qty,actor,company);
                result.setSuccess(true);result.setMessage("Imported "+qty+" units");
            }catch(Exception failure){
                result.setSuccess(false);
                if(failure instanceof IllegalArgumentException || failure instanceof NumberFormatException){result.setMessage(failure.getMessage());}
                else if(failure instanceof SQLException && "45000".equals(((SQLException)failure).getSQLState()))result.setMessage(failure.getMessage());
                else result.setMessage("This row could not be imported. Check product details and stock rules.");
            }
            report.getRows().add(result);
        }
        return report;
    }
}
