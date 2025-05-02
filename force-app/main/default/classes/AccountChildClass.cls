public class AccountChildClass {
    // public static void linkParentWithChild(List<Account> newAccounts) {
    //     Set<String> accEmails = new Set<String>();
    //     Map<String, Id> emailToAccountIdMap = new Map<String, Id>();

    //     if(!newAccounts.isEmpty()){
    //         for (Account acc : newAccounts) {
    //         if (acc.Account_Email__c != null) {
    //             accEmails.add(acc.Account_Email__c);
    //             emailToAccountIdMap.put(acc.Account_Email__c, acc.Id);
    //         }
    //     }
    //      System.debug('accEmail==>'+accEmails);
    //         System.debug('emailToAccountIdMap=>'+emailToAccountIdMap);

    //     List<Contact> contactQuery = [SELECT Id, Email, Email__c FROM Contact WHERE Email IN :accEmails AND Email__c = true];
    //     List<Contact> contactsToUpdate = new List<Contact>();

    //         if(!contactQuery.isEmpty()){
    //             for (Contact con : contactQuery) {
    //                     if (!emailToAccountIdMap.containsKey(con.Email)) {
    //                         Contact updatedCon = new Contact();
    //                         updatedCon.Id = con.Id;
    //                         updatedCon.AccountId = emailToAccountIdMap.get(con.Email);
    //                         contactsToUpdate.add(updatedCon);
    //                 }
    //             }

    //             if (!contactsToUpdate.isEmpty()) {
    //                 update contactsToUpdate;
    //             }
    //         }

    //     }
        
    // }


    public static void linkAgainChildContact(List<Account> newAccounts){
        Set<String> accEmails = new Set<String>();
        Map<Id, String> accIdEmailMap = new Map<Id, String>();

        if (!accEmail.isEmpty()) {
            for (Account a : newAccounts) {
                if (a.Account_Email__c != null) {
                    accEmails.add(a.Account_Email__c);
                    accIdEmailMap.put(a.Id, a.Account_Email__c);
                }
            }
        }

        List<Contact> emailContact = [select Id, Email, Email__c, AccountId from Contact where Email IN :accEmails and Email__c = true];
        List<Contact> updatedContacts = new List<Contact>();

        if (!emailContact.isEmpty()) {
            for (Contact con : emailContact) {
                if(!accIdEmailMap.containsKey(con.AccountId)){
                    Contact updatedCon = new Contact();
                    updatedCon.Id = con.Id;
                    updatedCon.AccountId = accIdEmailMap.get(con.AccountId);
                    updatedContacts.add(updatedCon);
                }
            }

            if(!updatedContacts.isEmpty()){
                update updatedContacts;
            }
        }


    }
}