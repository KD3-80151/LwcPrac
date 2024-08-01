public with sharing class AccountTriggerHandlerService implements ITriggerService {
    

    public static void updateContactOwners(List<Id> accountIds, Map<Id, SObject> newRecordMap) {
        List<Contact> contactsToUpdate = new List<Contact>();
        Map<Id, List<Contact>> accountContactsMap = AccountTriggerHandlerModel.getContactsByAccountIds(accountIds);

        for (Id accountId : accountContactsMap.keySet()) {
            List<Contact> contacts = accountContactsMap.get(accountId);
            Account account = (Account) newRecordMap.get(accountId);
            for (Contact contact : contacts) {
                contact.OwnerId = account.OwnerId;
                contactsToUpdate.add(contact);
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}
