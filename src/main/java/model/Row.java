package model;
import java.util.LinkedHashMap;
import java.math.BigDecimal;
public class Row extends LinkedHashMap<String,Object> {
 private static final long serialVersionUID=1L;
 public String text(String key){Object v=get(key);return v==null?"":v.toString();}
 public int id(String key){return Integer.parseInt(text(key));}
 public BigDecimal money(String key){return new BigDecimal(text(key));}
}
