public class AccountTriggerHandler {
    public static void AccountTriggerContact(List<Account> accountList){
        
        List<Contact> contactList = new List<Contact>();
        //Set<Id> contactIdSet = new Set<Id>();
        
        for(Account a: accountList){
            Contact c = new Contact();
            c.LastName = a.Name;
            c.AccountId = a.Id;
            contactList.add(c);
            
        }
        if (!contactList.isEmpty()) {
            insert contactList;
        }
        
    }
    
    //If the Industry changes, all related Open Opportunities should update their Industry__c field.
    public static void handleIndustryChanges(list<Account> accList, Map<Id,	Account> oldMap){
        Set<Id> accIdsforOppUpdate = new Set<Id>();
        Set<Id> accIdsforTask = new Set<Id>();
        
        if(accList != null){
            for(Account acc: accList){
                Account oldAcc = oldMap.get(acc.Id);
                if(acc.Industry != oldAcc.Industry){
                    accIdsforOppUpdate.add(acc.Id);
                }
                
                //If the Account Rating becomes High, automatically assign follow-up Tasks to all related Contacts.
                if(acc.Rating == 'High' && oldAcc.Rating != 'High'){
                    accIdsforTask.add(acc.Id);
                }
            }
            if(!accIdsforOppUpdate.isEmpty()){
                updateOpp(accIdsforOppUpdate, accList);
            }
            //if(!accIdsforTask.isEmpty()){
             //   System.enqueJob(new AssignTaskQueueable(new List<Id>(accIdsforTask))
            //}
        }
        
    }
    
    //accIdsforOppUpdate, accList
    private static void updateOpp(Set<Id> accIds, List<Account> accList){
        Map<Id, String> accIndustryMap = new Map<Id, String>(); // to take picklist values and update the opp
        for(Account acc: accList){
            if(accIds.contains(acc.Id)){
                accIndustryMap.put(acc.Id, acc.Industry);
            }
        }
        
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<Opportunity> oppList = [select Id, Name, Industry__c from Opportunity where AccountId IN :accIds and StageName != 'Closed Won'];
        
        for(Opportunity opp: oppList){
            String newIndustry = accIndustryMap.get(opp.AccountId);
            if(newIndustry != null && opp.Industry__c != newIndustry){
				opp.Industry__c = newIndustry;
                oppsToUpdate.add(opp);
            }
        }
        
        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }
    }
    
}