package model;

import java.util.ArrayList;
import java.util.List;

public class StockImportResult {
    private int rowNumber;
    private String sku, message;
    private boolean success;
    private List<String> errors = new ArrayList<String>();
    public int getRowNumber(){return rowNumber;} public void setRowNumber(int v){rowNumber=v;}
    public String getSku(){return sku;} public void setSku(String v){sku=v;}
    public String getMessage(){return message;} public void setMessage(String v){message=v;}
    public boolean isSuccess(){return success;} public void setSuccess(boolean v){success=v;}
    public List<String> getErrors(){return errors;} public void setErrors(List<String> v){errors=v;}
}
