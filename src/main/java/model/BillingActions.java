package model;

import java.sql.Date;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import operations.BillingOperations;
import implementor.BillingImplementor;

/** Billing use-cases and validation. No SQL or JDBC statement handling in controllers. */
public final class BillingActions {
    private final BillingOperations db;
    public BillingActions(){this(new BillingImplementor());}
    public BillingActions(BillingOperations db){this.db=db;}

    public Row activeUser(int userId)throws SQLException {
        List<Row> records=db.findActiveUser(userId);
        if(records.isEmpty())throw new SecurityException("Active account required");
        return records.get(0);
    }
    public List<Row> eligibleShipments(int companyId)throws SQLException { return db.unbilledSellerShipments(companyId); }
    public int createInvoice(int actor,int shipment,Date due,BigDecimal freight,BigDecimal handling,BigDecimal customs,BigDecimal insurance,String ip)throws SQLException {
        List<Row> rows=db.call("sp_insert_invoice",actor,shipment,due,freight,handling,customs,insurance,ip);
        if(rows.isEmpty())throw new IllegalStateException("Invoice creation returned no result");
        return rows.get(0).id("invoice_id");
    }
    private void requireEditableInvoice(int actor,int invoice)throws SQLException {
        String state=db.invoiceShipmentStatus(actor,invoice);
        if(state==null)throw new SecurityException("Invoice not accessible");
        if("CANCELLED".equals(state))
            throw new IllegalArgumentException("Cancelled booking invoices are retained for audit and cannot be changed or deleted.");
    }
    private void requireEditableLineItem(int actor,int itemId)throws SQLException {
        Integer invoice=db.invoiceForLineItem(actor,itemId);
        if(invoice==null)throw new SecurityException("Invoice item not accessible");
        requireEditableInvoice(actor,invoice);
    }
    public void editDueDate(int actor,int invoice,Date due,String ip)throws SQLException{requireEditableInvoice(actor,invoice);db.call("sp_update_invoice_field",actor,invoice,"due_date",due.toString(),ip);}
    public void deleteInvoice(int actor,int invoice,String ip)throws SQLException{requireEditableInvoice(actor,invoice);db.call("sp_delete_invoice",actor,invoice,ip);}
    public void addNote(int actor,int invoice,String desc,String ip)throws SQLException{requireEditableInvoice(actor,invoice);db.call("sp_insert_invoice_line_item",actor,invoice,desc,ip);}
    public void editNote(int actor,int item,String desc,String ip)throws SQLException{requireEditableLineItem(actor,item);db.call("sp_update_invoice_line_item_field",actor,item,"description",desc,ip);}
    public void deleteNote(int actor,int item,String ip)throws SQLException{requireEditableLineItem(actor,item);db.call("sp_delete_invoice_line_item",actor,item,ip);}
    /** Validate both payment modes against the real outstanding balance before recording.
     * The database's existing sp_record_payment procedure remains the authority for
     * transactional recording and automatic invoice-status updates.
     */
    public void recordPayment(int actor,int invoice,BigDecimal amount,String paymentType,String mode,String reference,Date paymentDate)throws SQLException{
        if(actor<=0||invoice<=0)throw new IllegalArgumentException("A valid invoice is required");
        if(amount==null||amount.signum()<=0||amount.scale()>2)throw new IllegalArgumentException("Payment must be a positive amount with at most two decimal places");
        if(!"FULL".equals(paymentType)&&!"PARTIAL".equals(paymentType))throw new IllegalArgumentException("Choose full or partial payment");
        if(!Arrays.asList("BANK","UPI","CHEQUE","CASH").contains(mode))throw new IllegalArgumentException("Invalid payment method");
        if(paymentDate==null||paymentDate.toLocalDate().isAfter(LocalDate.now()))throw new IllegalArgumentException("Payment date cannot be in the future");
        if(reference!=null&&reference.length()>50)throw new IllegalArgumentException("Payment reference is too long");
        List<Row> rows=invoiceDetails(actor,invoice);
        if(rows.isEmpty())throw new SecurityException("Invoice is not accessible");
        if("CANCELLED".equals(rows.get(0).text("shipment_status")))
            throw new IllegalArgumentException("This booking is cancelled. Its invoice is archived and cannot be paid.");
        BigDecimal balance=rows.get(0).money("balance");
        if(balance.signum()<=0)throw new IllegalArgumentException("This invoice has no outstanding balance");
        if(amount.compareTo(balance)>0)throw new IllegalArgumentException("Payment cannot exceed the outstanding balance");
        if("FULL".equals(paymentType)&&amount.compareTo(balance)!=0)throw new IllegalArgumentException("Full payment must equal the outstanding balance");
        if("PARTIAL".equals(paymentType)&&amount.compareTo(balance)>=0)throw new IllegalArgumentException("Partial payment must be less than the outstanding balance");
        db.call("sp_record_payment",invoice,amount,mode,reference,paymentDate,actor);
    }
    public void choosePayOnDelivery(int actor,int invoice,String ip)throws SQLException {
        if(actor<=0||invoice<=0)throw new IllegalArgumentException("Choose a valid invoice");
        db.recordDeliveryArrangement(actor,invoice,ip);
    }
    public boolean payOnDeliverySelected(int actor,int invoice)throws SQLException {
        return db.hasDeliveryArrangement(actor,invoice);
    }
    /** The Implementor enforces that the active Consumer owns this invoice. */
    public Integer shipmentForInvoice(int consumerUserId,int invoiceId)throws SQLException {
        if(consumerUserId<=0||invoiceId<=0)throw new IllegalArgumentException("Valid invoice required");
        return db.shipmentIdForInvoice(consumerUserId,invoiceId);
    }
    public Integer invoiceForShipment(int actor,int shipment)throws SQLException {
        if(actor<=0||shipment<=0)throw new IllegalArgumentException("Valid shipment required");
        return db.invoiceIdForShipment(actor,shipment);
    }
    public List<Row> invoices(int actor,String status,boolean outstanding,String keyword)throws SQLException {
        List<Row> rows=new ArrayList<>(db.call("sp_search_invoices",actor,status));
        Map<Integer,String> states=db.invoiceShipmentStatuses(actor);
        for(Row row:rows)row.put("shipment_status",states.getOrDefault(row.id("invoice_id"),""));
        if(outstanding)rows.removeIf(x->"PAID".equals(x.text("status")) ||
            "CANCELLED".equals(x.text("shipment_status")));
        final String q=keyword==null?"":keyword.trim().toLowerCase(Locale.ROOT);
        rows.removeIf(x->!(x.text("invoice_no")+" "+x.text("shipment_no")).toLowerCase(Locale.ROOT).contains(q));
        return rows;
    }
    public BillingInvoiceSummary summarizeInvoices(List<Row> rows){
        return new BillingInvoiceSummary(rows,java.time.LocalDate.now());
    }
    public List<Row> payments(int actor,String reference,Date from,Date to)throws SQLException {
        return db.call("sp_search_payments",actor,null,reference,from,to);
    }
    public List<Row> invoiceDetails(int actor,int invoice)throws SQLException {
        List<Row> rows=db.call("sp_generate_invoice_details",actor,invoice);
        String shipmentStatus=db.invoiceShipmentStatus(actor,invoice);
        for(Row row:rows)row.put("shipment_status",shipmentStatus==null?"":shipmentStatus);
        return rows;
    }
    public List<Row> paymentHistory(int invoice)throws SQLException { return db.call("sp_get_payment_history",invoice); }
    public void logout(int actor)throws SQLException {db.call("sp_logout",actor);}
}
