/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 28/09/2024
 * Last Modified Date: 
 * Purpose: To get all Opportunity with their related account
 * -----------------------------------------------------------------------------------------------------
 */

 public class AccountWithOpportunities {
    public static Map<Id, List<Opportunity>> MapAcntWithOpp(List<Id> accountIdList){
        Map<Id, List<Opportunity>> acntMap = new Map<Id, List<Opportunity>>();
         List<Opportunity> oppo = [SELECT Id, Name, AccountId FROM Opportunity WHERE AccountId IN :accountIdList];
         
        for (Opportunity opp : oppo) {
            if (!acntMap.containsKey(opp.AccountId)) {
                acntMap.put(opp.AccountId, new List<Opportunity>());
            }
            acntMap.get(opp.AccountId).add(opp);
        }
        
        for (Id accId : accountIdList) {
            if (!acntMap.containsKey(accId)) {
                acntMap.put(accId, new List<Opportunity>());
            }
        }
        return acntMap;
    }



    public static Map<Id, List<Opportunity>> getOppwithAccnt(List<Id> accntList){
         
        // to store the results.
        Map<Id, List<Opportunity>> accntMap = new Map<Id, List<Opportunity>>(); 
        List<Opportunity> oppList = [select Id, Name, AccountId from Opportunity where AccountId IN: accntList];

        for (Opportunity opp : oppList) {
            if (!accntMap.containsKey(opp.AccountId)) {
                accntMap.put(opp.AccountId, new List<Opportunity>());
            }
            accntMap.get(opp.AccountId).add(opp);
        }

        //Handling Accounts with No Opportunities:
        for (Id accntId : accountIdList) {
            if (!accntMap.containsKey(accntId)) {
                accntMap.put(Id, new List<Opportunity>());
            }
        }

    }



}

// AccountWithOpportunities.MapAcntWithOpp()