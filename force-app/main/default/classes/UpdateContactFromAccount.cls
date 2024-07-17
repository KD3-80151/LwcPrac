public with sharing class UpdateContactFromAccount {
    @AuraEnabled
    public static void updateContact(String firstName, String lastName, String email, String phone, Id accountId){
        try {
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Phone = phone,
                AccountId = accountId
            );
            insert newContact;
            return newContact.Id;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}