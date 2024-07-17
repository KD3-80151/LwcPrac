public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name FROM Account WHERE Name LIKE :key];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesByAccountId(String accountId) {
        return [SELECT Id, Name, StageName, Amount, CloseDate FROM Opportunity WHERE AccountId = :accountId];
    }

    @AuraEnabled
    public static void updateOpportunity(Opportunity opportunity) {
        update opportunity;
    }

    


}
