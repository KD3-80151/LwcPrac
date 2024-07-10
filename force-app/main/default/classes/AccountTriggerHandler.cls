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

}