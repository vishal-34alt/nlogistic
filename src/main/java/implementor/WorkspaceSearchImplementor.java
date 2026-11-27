package implementor;

import db_config.GetConnection;
import model.WorkspaceSearchHit;
import operations.WorkspaceSearchOperations;
import java.sql.*;
import java.util.*;

/** Role-scoped workspace lookup; never trusts the session role or a client-supplied company ID. */
public final class WorkspaceSearchImplementor implements WorkspaceSearchOperations {
    private static final int MAX_PER_TYPE=15;
    @Override public List<WorkspaceSearchHit> search(int userId,String raw) throws SQLException {
        List<WorkspaceSearchHit> hits=new ArrayList<>();
        final String term=raw==null?"":raw.trim();
        final String like="%"+term.replace("!","!!").replace("%","!%").replace("_","!_")+"%";
        String role=null;
        try(Connection c=GetConnection.getConnection()) {
            Integer company=null,customer=null;
            try(PreparedStatement p=c.prepareStatement("SELECT role,company_id FROM users WHERE user_id=? AND status='ACTIVE'")) {
                p.setInt(1,userId);
                try(ResultSet r=p.executeQuery()) {
                    if(!r.next())throw new SQLException("Inactive account","28000");
                    role=r.getString("role");int id=r.getInt("company_id");if(!r.wasNull())company=id;
                }
            }
            if("CONSUMER".equals(role)) {
                try(PreparedStatement p=c.prepareStatement("SELECT customer_id FROM customers WHERE user_id=?")) {
                    p.setInt(1,userId);try(ResultSet r=p.executeQuery()){if(r.next())customer=r.getInt(1);}
                }
            }
            if(!"ADMIN".equals(role)&&!"SELLER".equals(role)&&!"CONSUMER".equals(role))throw new SQLException("Unauthorized role","28000");
            if(("SELLER".equals(role)&&company==null)||("CONSUMER".equals(role)&&customer==null))return navigationHits(role,term);
            // Every search deriving from a shipment reuses the same authorized ownership condition.
            String scope="ADMIN".equals(role)?"":"SELLER".equals(role)?" AND s.seller_id=?":" AND s.consumer_id=?";
            Integer owner="SELLER".equals(role)?company:customer;
            String shipments="SELECT s.shipment_id,s.shipment_no,c.container_number,s.status,op.port_name AS origin,dp.port_name AS destination "
                +"FROM shipment s JOIN containers c ON c.container_id=s.container_id "
                +"JOIN ports op ON op.port_id=s.origin_port_id JOIN ports dp ON dp.port_id=s.dest_port_id "
                +"WHERE (s.shipment_no LIKE ? ESCAPE '!' OR CAST(s.shipment_id AS CHAR) LIKE ? ESCAPE '!' "
                +"OR c.container_number LIKE ? ESCAPE '!')"+scope+" ORDER BY s.shipment_id DESC LIMIT "+MAX_PER_TYPE;
            try(PreparedStatement p=c.prepareStatement(shipments)) {
                p.setString(1,like);p.setString(2,like);p.setString(3,like);scope(p,role,owner,4);
                try(ResultSet r=p.executeQuery()){while(r.next()){
                    String status=r.getString("status");int id=r.getInt("shipment_id");
                    hits.add(new WorkspaceSearchHit("BOOKED".equals(status)?"Booking":"Shipment",r.getString("shipment_no"),
                        r.getString("origin")+" to "+r.getString("destination")+" • "+status,
                        "/containerMovement?action=shipmentDetails&shipmentId="+id));
                }}
            }
            // Consumers may discover only containers belonging to their own bookings;
            // Seller results are their owned containers; Admin may locate a container through a shipment.
            if("SELLER".equals(role)) {
                String containers="SELECT c.container_number,c.status FROM containers c WHERE c.seller_id=? "
                    +"AND c.container_number LIKE ? ESCAPE '!' ORDER BY c.container_id DESC LIMIT "+MAX_PER_TYPE;
                try(PreparedStatement p=c.prepareStatement(containers)){
                    p.setInt(1,company);p.setString(2,like);
                    try(ResultSet r=p.executeQuery()){while(r.next())hits.add(new WorkspaceSearchHit("Container",r.getString("container_number"),
                        "Owned container • "+r.getString("status"),"/ContainerAllocationPricingController?module=container"));}
                }
                String products="SELECT sku,product_name FROM products WHERE owner_company_id=? "
                    +"AND (sku LIKE ? ESCAPE '!' OR product_name LIKE ? ESCAPE '!') ORDER BY product_id DESC LIMIT "+MAX_PER_TYPE;
                try(PreparedStatement p=c.prepareStatement(products)){
                    p.setInt(1,company);p.setString(2,like);p.setString(3,like);
                    try(ResultSet r=p.executeQuery()){while(r.next())hits.add(new WorkspaceSearchHit("Product",r.getString("sku"),
                        r.getString("product_name"),"/stock?q="+java.net.URLEncoder.encode(r.getString("sku"),java.nio.charset.StandardCharsets.UTF_8)));}
                }
            } else {
                String containers="SELECT DISTINCT s.shipment_id,c.container_number,s.status FROM shipment s "
                    +"JOIN containers c ON c.container_id=s.container_id WHERE c.container_number LIKE ? ESCAPE '!'"
                    +scope+" ORDER BY s.shipment_id DESC LIMIT "+MAX_PER_TYPE;
                try(PreparedStatement p=c.prepareStatement(containers)){
                    p.setString(1,like);scope(p,role,owner,2);
                    try(ResultSet r=p.executeQuery()){while(r.next())hits.add(new WorkspaceSearchHit("Container",r.getString("container_number"),
                        "Linked shipment • "+r.getString("status"),"/containerMovement?action=shipmentDetails&shipmentId="+r.getInt("shipment_id")));}
                }
            }
            String invoices="SELECT i.invoice_id,i.invoice_no,i.status,s.shipment_no FROM billing_invoices i "
                +"JOIN shipment s ON s.shipment_id=i.shipment_id WHERE (i.invoice_no LIKE ? ESCAPE '!' "
                +"OR s.shipment_no LIKE ? ESCAPE '!')"+scope+" ORDER BY i.invoice_id DESC LIMIT "+MAX_PER_TYPE;
            try(PreparedStatement p=c.prepareStatement(invoices)) {
                p.setString(1,like);p.setString(2,like);scope(p,role,owner,3);
                try(ResultSet r=p.executeQuery()){while(r.next())hits.add(new WorkspaceSearchHit("Invoice",r.getString("invoice_no"),
                    "Shipment "+r.getString("shipment_no")+" • "+r.getString("status"),"/billing?action=details&invoice="+r.getInt("invoice_id")));}
            }
            String claims="SELECT cl.claim_id,cl.claim_no,cl.status,s.shipment_no FROM claims cl "
                +"JOIN shipment s ON s.shipment_id=cl.shipment_id WHERE (cl.claim_no LIKE ? ESCAPE '!' "
                +"OR s.shipment_no LIKE ? ESCAPE '!') AND NOT EXISTS(SELECT 1 FROM audit_log aw WHERE aw.table_name='claims' AND aw.action='WITHDRAW_CLAIM' AND aw.record_id=cl.claim_id)"+scope+" ORDER BY cl.claim_id DESC LIMIT "+MAX_PER_TYPE;
            try(PreparedStatement p=c.prepareStatement(claims)) {
                p.setString(1,like);p.setString(2,like);scope(p,role,owner,3);
                try(ResultSet r=p.executeQuery()){while(r.next())hits.add(new WorkspaceSearchHit("Claim",r.getString("claim_no"),
                    "Shipment "+r.getString("shipment_no")+" • "+r.getString("status"),"/ClaimController?action=view&claim_id="+r.getInt("claim_id")));}
            }
        }
        // Cross-module navigation is indexed separately from database records. Both
        // sets respect the signed-in role; these links do not bypass controller checks.
        hits.addAll(0, navigationHits(role,term));
        return hits;
    }
    private static final class Destination {
        final String title,description,url,allowed,keywords;
        Destination(String title,String description,String url,String allowed,String keywords){
            this.title=title;this.description=description;this.url=url;this.allowed=allowed;this.keywords=keywords;
        }
    }
    private static final Destination[] NAVIGATION={
        new Destination("Overview dashboard","Workspace metrics and shortcuts","/Module1Controller?action=dashboard","ASC","dashboard home overview kpi"),
        new Destination("Shipment management","Search shipments and track bookings","/containerMovement?action=shipments","ASC","shipments shipment tracking delivery cargo container"),
        new Destination("Movement history","Shipment movement events and timeline","/containerMovement?action=movements","ASC","movement tracking history status timeline"),
        new Destination("Profit and loss report","Shipment-wise P&L revenue, expenses and net profit","/containerMovement?action=profitLoss","AS","p&l pnl profit loss income freight financial report"),
        new Destination("Manage users","Create, update and deactivate user accounts","/Module1Controller?action=users","A","admin accounts users people permissions"),
        new Destination("Companies","Company administration","/Module1Controller?action=companies","A","companies organizations sellers consumers"),
        new Destination("Customers","Customer profiles","/Module1Controller?action=customers","A","customers customer profiles"),
        new Destination("Ports and vessels","Port directory and vessel management","/adminInfrastructure","A","ports vessels ships coordinates latitude longitude"),
        new Destination("Audit trail","Activity and change history","/Module1Controller?action=auditLogs","A","audit log history changes security"),
        new Destination("Container inventory","Manage available containers","/ContainerAllocationPricingController?module=container","S","containers maintenance allocation inventory"),
        new Destination("Pricing rules","Manage seller route pricing","/ContainerAllocationPricingController?module=pricing","S","pricing rates rules multiplier"),
        new Destination("Book a container","Choose products and request a quotation","/ContainerAllocationPricingController?module=booking","C","booking quotation goods products order"),
        new Destination("Inventory and products","Stock quantities, products and availability","/stock","S","inventory stock products sku quantity"),
        new Destination("Inventory ledger","Stock transaction history","/stock?action=ledger","S","ledger stock transactions movements"),
        new Destination("Sales history","Product sales transaction records","/stock?action=sales","S","sales history products transaction"),
        new Destination("Invoices","Manage billing and invoices","/billing?action=invoices","ASC","billing invoices tax payment"),
        new Destination("Outstanding invoices","Invoices awaiting payment","/billing?action=outstanding","ASC","unpaid pending outstanding invoices"),
        new Destination("Payment history","Recorded full and partial payments","/billing?action=payments","ASC","payments UPI bank cheque cash paid"),
        new Destination("Business analytics","Operational metrics and charts","/analytics","AS","analytics kpi charts dashboard"),
        new Destination("ABC classification","Product classification by contribution","/analytics#abc-classification","AS","abc pareto classification products"),
        new Destination("Inventory turnover","Turnover ratios by product","/analytics#inventory-turnover","AS","turnover ratio inventory analytics"),
        new Destination("Sales trends","Monthly sales and route analysis","/analytics#sales-trends","AS","sales trends charts routes customer revenue"),
        new Destination("Demand forecast","Forecasted route and container demand","/analytics#demand-forecast","AS","forecast prediction demand pricing"),
        new Destination("Product profitability","Revenue, cost and margin analysis","/analytics#profitability","AS","profitability margin products analytics"),
        new Destination("Claims register","Review claim status and evidence","/ClaimController?action=list","ASC","claims damage loss settlement documents"),
        new Destination("Submit a claim","File a shipment loss or damage claim","/ClaimController?action=new","C","raise claim submit loss damage"),
        new Destination("Account settings","Edit profile and account security","/Module1Controller?action=viewProfile","ASC","my profile password account settings sign in")
    };
    private static List<WorkspaceSearchHit> navigationHits(String role,String raw) {
        List<WorkspaceSearchHit> pages=new ArrayList<>();
        if(raw==null || raw.trim().isEmpty() || role==null)return pages;
        String q=raw.toLowerCase(Locale.ROOT).trim().replaceAll("\\s+"," ");
        if(q.length()>64)q=q.substring(0,64);
        String code="ADMIN".equals(role)?"A":"SELLER".equals(role)?"S":"C";
        for(Destination d:NAVIGATION){
            if(!d.allowed.contains(code))continue;
            String text=(d.title+" "+d.keywords).toLowerCase(Locale.ROOT);
            boolean match=text.contains(q);
            if(!match && q.contains(" ")){
                match=true;
                for(String word:q.split(" "))if(word.length()>1 && !text.contains(word)){match=false;break;}
            }
            if(match){pages.add(new WorkspaceSearchHit("Workspace page",d.title,d.description,d.url));
                if(pages.size()>=10)break;
            }
        }
        return pages;
    }
    private static void scope(PreparedStatement p,String role,Integer owner,int index) throws SQLException{
        if(!"ADMIN".equals(role))p.setInt(index,owner);
    }
}
