public class ContactDetailsList {
    @AuraEnabled
    public static List<Contact> getContacts(String searchKey) {
        String searchPattern = '%' + searchKey + '%';
        return [SELECT Id, Name, Email,     Phone, AccountId FROM Contact WHERE Name LIKE :searchPattern];
    }
}
