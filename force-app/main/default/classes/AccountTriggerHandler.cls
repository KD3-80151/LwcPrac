/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 29/07/2024
 * Last Modified Date:  
 * Purpose: Setting Name of contact as Account Name 
 * -----------------------------------------------------------------------------------------------------
 */
public with sharing class AccountTriggerHandler implements ITrigger {
    public static Boolean RUN_TRIGGER = true;

    public void bulkBefore() {
    }

    public void bulkAfter() {
    }

    public void beforeInsert(List<SObject> newRecords) {
        
    }

    public void beforeUpdate(Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
        
    }

    public void beforeDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap) {
        
    }

    public void afterInsert(List<SObject> newRecords, Map<Id, SObject> newRecordMap) {
        
    }

    public void afterUpdate(Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
        List<Id> accountIds = new List<Id>();
        for (Id accountId : newRecordMap.keySet()) {
            Account oldAccount = (Account) oldRecordMap.get(accountId);
            Account newAccount = (Account) newRecordMap.get(accountId);
            if (oldAccount.OwnerId != newAccount.OwnerId) {
                accountIds.add(accountId);
            }
        }
        
        if (!accountIds.isEmpty()) {
            AccountTriggerHandlerService.updateContactOwners(accountIds, newRecordMap);
        }
    }

    public void afterDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap) {
     
    }

    public void andFinally(List<SObject> newRecords, Map<Id, SObject> newRecordMap) {
       
    }
}


    //public static void AccountTriggerContact(List<Account> accountList){



        // List<Contact> contactList = new List<Contact>();
        // //Set<Id> contactIdSet = new Set<Id>();
        
        // for(Account a: accountList){
        //     Contact c = new Contact();
        //     c.LastName = a.Name;
        //     c.AccountId = a.Id;
        //     contactList.add(c);
            
        // }
        // if (!contactList.isEmpty()) {
        //     insert contactList;
        // }

    //}