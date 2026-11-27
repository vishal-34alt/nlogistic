package model;
import java.io.*;import java.nio.charset.StandardCharsets;import java.util.*;import java.util.zip.*;
import javax.xml.XMLConstants;import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.*;
/** CSV (including multiline quoted fields) and standards-based .xlsx, no external spreadsheet dependency. */
public final class StockImportParser {
 private StockImportParser(){}
 /** Downloadable template generated in memory; no static asset is required. */
 public static String csvTemplate(){
  return "sku,product_name,category,hs_code,unit,unit_weight_kg,unit_price,quantity\r\n";
 }
 public static List<Map<String,String>> parse(String name,InputStream input)throws Exception {
  String suffix=name==null?"":name.toLowerCase(Locale.ROOT).trim();
  List<List<String>> table;
  if(suffix.endsWith(".csv"))table=csv(input);
  else if(suffix.endsWith(".xlsx"))table=xlsx(input);
  else throw new IllegalArgumentException("Upload a CSV or XLSX file (convert legacy XLS to XLSX first)");
  if(table.isEmpty())throw new IllegalArgumentException("The import file is empty");
  List<String> keys=new ArrayList<>();for(String x:table.get(0))keys.add(x.replace("\ufeff", "").trim().toLowerCase(Locale.ROOT).replace(' ','_').replace('-','_'));
  for(String col:new String[]{"sku","product_name","category","hs_code","unit","unit_weight_kg","unit_price","quantity"})if(!keys.contains(col))throw new IllegalArgumentException("Missing required column: "+col);
  List<Map<String,String>> rows=new ArrayList<>();
  for(int i=1;i<table.size();i++){
   List<String> source=table.get(i);if(source.stream().allMatch(String::isEmpty))continue;
   if(rows.size()>=5000)throw new IllegalArgumentException("Import limit: 5000 rows");
   Map<String,String> map=new LinkedHashMap<>();for(int j=0;j<keys.size();j++)map.put(keys.get(j),j<source.size()?source.get(j).trim():"");
   map.put("_row",Integer.toString(i+1));rows.add(map);
  }
  return rows;
 }
 private static List<List<String>> csv(InputStream input)throws Exception {
  List<List<String>> out=new ArrayList<>();try(Reader r=new BufferedReader(new InputStreamReader(input,StandardCharsets.UTF_8))){
   List<String> line=new ArrayList<>();StringBuilder cell=new StringBuilder();boolean quoted=false;boolean any=false;
   for(int ch;(ch=r.read())!=-1;){char c=(char)ch;any=true;
    if(c=='"'){
     if(quoted){r.mark(1);int nxt=r.read();if(nxt=='"')cell.append('"');else{quoted=false;if(nxt!=-1){if(r.markSupported())r.reset();else throw new IOException("Unsupported CSV reader");}}}
     else if(cell.length()==0)quoted=true;else throw new IOException("Unexpected quote in CSV");
    }else if(c==','&&!quoted){line.add(cell.toString());cell.setLength(0);}
    else if((c=='\r'||c=='\n')&&!quoted){if(c=='\r'){r.mark(1);int n=r.read();if(n!='\n'&&n!=-1)r.reset();}line.add(cell.toString());out.add(line);line=new ArrayList<>();cell.setLength(0);any=false;}
    else cell.append(c);
   }
   if(quoted)throw new IOException("Unclosed quoted CSV field");
   if(any||cell.length()>0||!line.isEmpty()){line.add(cell.toString());out.add(line);}
  }return out;
 }
 private static Document xml(byte[] data)throws Exception {
  DocumentBuilderFactory f=DocumentBuilderFactory.newInstance();
  f.setFeature("http://apache.org/xml/features/disallow-doctype-decl",true);f.setFeature("http://xml.org/sax/features/external-general-entities",false);f.setFeature("http://xml.org/sax/features/external-parameter-entities",false);
  f.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING,true);f.setXIncludeAware(false);f.setExpandEntityReferences(false);
  return f.newDocumentBuilder().parse(new ByteArrayInputStream(data));
 }
 private static String val(Element e,String tag){NodeList n=e.getElementsByTagName(tag);return n.getLength()==0?"":n.item(0).getTextContent();}
 private static List<List<String>> xlsx(InputStream input)throws Exception {
  Map<String,byte[]> entries=new HashMap<>();int total=0;
  try(ZipInputStream z=new ZipInputStream(input)){for(ZipEntry e;(e=z.getNextEntry())!=null;){String n=e.getName();if(e.isDirectory())continue;ByteArrayOutputStream b=new ByteArrayOutputStream();byte[] buf=new byte[8192];for(int x;(x=z.read(buf))!=-1;){total+=x;if(total>25_000_000)throw new IOException("Expanded XLSX too large");b.write(buf,0,x);}if(n.equals("xl/sharedStrings.xml")||n.equals("xl/worksheets/sheet1.xml"))entries.put(n,b.toByteArray());}}
  byte[] sheet=entries.get("xl/worksheets/sheet1.xml");if(sheet==null)throw new IOException("First XLSX worksheet not found");
  List<String> shared=new ArrayList<>();byte[] ss=entries.get("xl/sharedStrings.xml");if(ss!=null){Document d=xml(ss);NodeList nodes=d.getElementsByTagName("si");for(int i=0;i<nodes.getLength();i++)shared.add(nodes.item(i).getTextContent());}
  Document d=xml(sheet);NodeList rows=d.getElementsByTagName("row");List<List<String>> result=new ArrayList<>();int last=0;
  for(int i=0;i<rows.getLength();i++){Element e=(Element)rows.item(i);int rowNumber;try{rowNumber=Integer.parseInt(e.getAttribute("r"));}catch(Exception x){rowNumber=last+1;}if(rowNumber-last>5100)throw new IOException("XLSX has too many blank rows");while(last<rowNumber-1){result.add(new ArrayList<>());last++;}
   ArrayList<String> cells=new ArrayList<>();NodeList cn=e.getElementsByTagName("c");for(int j=0;j<cn.getLength();j++){Element c=(Element)cn.item(j);String coord=c.getAttribute("r");int col=0;for(int k=0;k<coord.length()&&Character.isLetter(coord.charAt(k));k++)col=col*26+Character.toUpperCase(coord.charAt(k))-'A'+1;
    if(col<1)col=j+1;if(col>100)throw new IOException("Too many XLSX columns");while(cells.size()<col)cells.add("");String value=val(c,"v");if("s".equals(c.getAttribute("t"))&&!value.isEmpty()){int idx=Integer.parseInt(value);if(idx<0||idx>=shared.size())throw new IOException("Bad XLSX string index");value=shared.get(idx);}else if("inlineStr".equals(c.getAttribute("t"))){value=val(c,"is");}cells.set(col-1,value);
   }result.add(cells);last=rowNumber;
   if(result.size()>5100)throw new IOException("XLSX row limit exceeded");
  }return result;
 }
}