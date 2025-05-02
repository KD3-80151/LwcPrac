public class AccountTriggerHelper {
    public static void linkContactToAccount(List<Account> accList){
        Set<String> accEmail = new Set<String>();
        Map<String,Id> emailMap = new Map<String,Id>();
        if(!accList.isEmpty()){
            for(Account a : accList){
                if(a.Account_Email__c != null){
                    accEmail.add(a.Account_Email__c);
                    emailMap.put(a.Account_Email__c,a.Id);
                }
            }
            System.debug('accEmail==>'+accEmail);
            System.debug('emailMap=>'+emailMap);
            
            List<Contact> contactList = [Select Id, Email__c, Email,AccountId from Contact where Email IN :accEmail AND Email__c = True];
            System.debug('Contact List==>'+contactList);
            List<Contact> contactsToUpdate = new List<Contact>();
            if(!contactList.isEmpty()){
                for(Contact c : contactList){
                    if(emailMap.containsKey(c.Email)){
                        Contact cc = new Contact();
                        cc.Id = c.Id;
                        cc.AccountId = emailMap.get(c.Email);
                        contactsToUpdate.add(cc);
                       
                    }
                }
                if(!contactsToUpdate.isEmpty()){
                    update contactsToUpdate;
                }
            }
        }
    }
}