public class AccountOwnerTriggerHandler {
    public static void AccountTriggerOwner(List<Account> accountList, Map<Id, Account> mapAccount){
        List<Contact> contactListUpdate = new List<Contact>();
        
        for(Account acc:accountList){
			Account oldAcc = mapAccount.get(acc.Id);
            if(acc.OwnerId != oldAcc.OwnerId){
                List<Contact> contList = [select Id, OwnerId from Contact where AccountId= :acc.Id];
	
                for (Contact contact : contList) {
                    contact.OwnerId = acc.OwnerId;
                    contactListUpdate.add(contact);
                }
            	}    
        }

       
        if (!contactListUpdate.isEmpty()) {
            update contactListUpdate;
        }  
}
}