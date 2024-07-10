public with sharing class OpportunityTotalAmountOnAccount {
    public static void OpportunityTotalAmountOnAccount(List<Opportunity> newOpp, Map<Id,Opportunity> oldOpp) {
        Set<Id> accountIds = new Set<Id>();

        for (Opportunity opp : newOpp) {
            accountIds.add(opp.AccountId);
        }

        if (oldOpp != null) {
            for (Opportunity oldO : oldOpp.values()) {
                accountIds.add(oldO.AccountId);
            }
        }
        updateAccountTotalOpp(accountIds);

    }

    
    public static void updateAccountTotalOpp(Set<Id> accountIds){
        if (accountIds.isEmpty()) {
            return;
        }

        List<Opportunity> opps = [select AccountId, Amount from Opportunity where AccountId IN : accountIds and IsClosed 
        = TRUE and IsWon = TRUE];

        Map<Id,Decimal> accountOppSum = new Map<Id,Decimal>();
        for (Opportunity opp : opps) {
            if (accountOppSum.containsKey(opp.AccountId)) {
                accountOppSum.put(opp.AccountId, accountOppSum.get(opp.AccountId) + opp.Amount);
                
            }
            else {
                accountOppSum.put(opp.AccountId, opp.Amount);
            }
        }

        List<Account> accListUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Decimal totalOppAmount = accountOppSum.get(accountId);
            Account accToUpdate = new Account(Id = accountId, Total_Opportunity_Amount__c= (totalOppAmount != null ) ? totalOppAmount:0);
            accListUpdate.add(accToUpdate);
        }

        if (!accListUpdate.isEmpty()) {
            update accListUpdate;
        }







    }
}