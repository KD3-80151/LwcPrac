public class ContactTriggerCrudHandler {
    
    public static void IsContactCreated(List<Contact> contactList) {
        Set<Id> accountSet = new Set<Id>();
        for (Contact c : contactList) {
            if (c.AccountId != null) {
                accountSet.add(c.AccountId);
            }
        }
        System.debug('create------'+accountSet);
        ContactCountUpdate(accountSet);
    }
    
    public static void IsContactUpdated(List<Contact> updatedContacts, Map<Id, Contact> oldContact) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : updatedContacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
            
            if (oldContact.get(c.Id).AccountId != null && oldContact.get(c.Id).AccountId != c.AccountId) {
                accountIds.add(oldContact.get(c.Id).AccountId);
            }
        }
        System.debug('update------'+accountIds);
        ContactCountUpdate(accountIds);
    }
    
    public static void isContactDeleted(List<Contact> deletedContacts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : deletedContacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        System.debug('delete------'+accountIds);
        ContactCountUpdate(accountIds);
    }
    
    private static void ContactCountUpdate(Set<Id> accountIds){
        
        Map<Id, Integer> accm = new Map<Id, Integer>();
        
        for (Id accountId : accountIds) {
            accm.put(accountId, 0);
        }
        
        for (Contact cont : [select AccountId from Contact where AccountId IN :accountIds]) {
            if (accm.containsKey(cont.AccountId)) {
                accm.put(cont.AccountId, accm.get(cont.AccountId) + 1);
            }
        }
        
        List<Account> accountsToUpdate = new List<Account>();
        Map<Id, Account> noOfCountExisted = new Map<Id, Account>
            ([SELECT Id, Contact_Count__c FROM Account WHERE Id IN :accountIds]);
        for (Id accountId : accountIds) {
            
            Account acc1 = noOfCountExisted.get(accountId);
            Integer contactCount = accm.get(accountId);
            
            if(acc1.Contact_Count__c != null){
                acc1.Contact_Count__c = contactCount;
                
            }
            else{
                // Account acc = new Account(Id = accountId, Contact_Count__c = accm.get(accountId));
                acc1.Contact_Count__c = 0;
                
            }
            accountsToUpdate.add(acc1);
            
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}