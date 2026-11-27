package model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

/** Presentation-ready aggregates of authorized invoice rows, with no database access. */
public final class BillingInvoiceSummary {
 private final BigDecimal total,paid,outstanding;
 private final int count;
 private final Set<Integer> overdue=new HashSet<>();
 public BillingInvoiceSummary(List<Row> records,LocalDate today) {
   BigDecimal billed=BigDecimal.ZERO,received=BigDecimal.ZERO;
   for(Row item:records){
     // CANCELLED bookings retain invoices for audit; they are not receivables.
     if("CANCELLED".equals(item.text("shipment_status")))continue;
     billed=billed.add(item.money("total_amount"));
     received=received.add(item.money("paid_amount"));
     String due=item.text("due_date");
     try {
       if(due!=null&&due.length()>=10 && item.money("balance").signum()>0
          && LocalDate.parse(due.substring(0,10)).isBefore(today))overdue.add(item.id("invoice_id"));
     }catch(java.time.format.DateTimeParseException ignore){/* No date, not classified as overdue. */}
   }
   total=billed;paid=received;outstanding=billed.subtract(received);count=records.size();
 }
 public BigDecimal getTotal(){return total;}
 public BigDecimal getPaid(){return paid;}
 public BigDecimal getOutstanding(){return outstanding;}
 public int getCount(){return count;}
 public int getOverdueCount(){return overdue.size();}
 public boolean isOverdue(int invoiceId){return overdue.contains(invoiceId);}
}
