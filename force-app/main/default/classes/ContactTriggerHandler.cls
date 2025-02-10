public class ContactTriggerHandler {
    
    public static void handlerContact(List<Contact> contList) {
       Map<Id, Account> acctUp;
       Set<Id> accountIdSet = new Set<Id>();
       List<Account> accListToBeUpdated = new List<Account>(); 
        
       for (Contact c : contList) {
          if (c.AccountId != null && c.LastName != null) {
              accountIdSet.add(c.AccountId);
          }
       }
        
        if(!accountIdSet.isEmpty()) {
            acctUp = new Map<Id, Account>([Select Id, Name from Account where Id In: accountIdSet]);
        }
        
        for(Contact contactObj : contList){
            if(contactObj.AccountId != null && acctUp.containsKey(contactObj.AccountId)) {
                Account accountObj = acctUp.get(contactObj.AccountId);
                accountObj.Name = contactObj.LastName;
                accListToBeUpdated.add(accountObj);
            }
        }
        
               
        if (!accListToBeUpdated.isEmpty()) {
            update accListToBeUpdated;
        }
  }
}