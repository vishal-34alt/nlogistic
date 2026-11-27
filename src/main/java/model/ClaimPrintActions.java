package model;

import operations.ClaimPrintContextOperations;
import implementor.ClaimPrintContextImplementor;
import java.util.*;

/** Only authorized claim records may be assembled for printing. */
public final class ClaimPrintActions {
    private final ClaimActions claims = new ClaimActions();
    public static final class Report {
        public final Claim claim;
        public final Row context;
        public final List<ClaimDocument> docs;
        public final List<ClaimStatusHistory> timeline;
        Report(Claim claim, Row context,List<ClaimDocument> docs,List<ClaimStatusHistory> timeline) {
            this.claim=claim;this.context=context;this.docs=docs;this.timeline=timeline;
        }
    }
    public Report load(int claimId,int actor) throws Exception {
        Claim claim=claims.getClaimById(claimId,actor); // Approved stored routine enforces permission.
        if(claim==null)throw new SecurityException("Claim not found or access denied.");
        ClaimPrintContextOperations printer=new ClaimPrintContextImplementor();
        Row context=printer.findByShipment(claim.getShipmentId());
        return new Report(claim,context,
                new ClaimDocumentActions().getDocuments(claimId,actor),
                new ClaimStatusHistoryActions().getHistory(claimId,actor));
    }
    public byte[] pdf(int claimId,int actor)throws Exception {
        return ClaimPdfBuilder.build(load(claimId,actor));
    }
}
