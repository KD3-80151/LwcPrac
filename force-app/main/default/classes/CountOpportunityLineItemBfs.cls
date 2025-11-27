public with sharing class CountOpportunityLineItemBfs {
    
    public static void updateCountValues(List<OpportunityLineItem> newOpplIstToCount){
        if(newOpplIstToCount == null && newOpplIstToCount.isEmpty()) return;
        set<Id> newSetToCountForIncmgRecords = new set<Id>();
        for (OpportunityLineItem oliToCount : newOpplIstToCount) {
            if (oliToCount.OpportunityId != null && oliToCount.IntegerCountTen__c != null) {
                newSetToCountForIncmgRecords.add(oliToCount.OpportunityId);
            }
        }

    }
}