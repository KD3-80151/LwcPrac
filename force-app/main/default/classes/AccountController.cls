/**
 * ----------------------------------------------------------------------------------------------------
 * Name: Sagar Kumar
 * Created Date: 27/06/2024
 * Last Modified Date: 
 * Purpose: Get related Opportunity, Task of an Account
 * -----------------------------------------------------------------------------------------------------
 */

public with sharing class AccountController {
    
    @AuraEnabled(cacheable=true)
public static List<Account> getAccountLwc(){
    try {
        return [SELECT Id, Name FROM Account LIMIT 5];
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}

    
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name FROM Account WHERE Name LIKE :key];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccountId(Id accountId) {
        return [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :accountId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunitiesByAccountId(String accountId) {
        return [SELECT Id, Name, StageName, Amount, CloseDate FROM Opportunity WHERE AccountId = :accountId];
    }

    @AuraEnabled
    public static void updateOpportunity(Opportunity opportunity) {
        update opportunity;
    }

    //
    @AuraEnabled(cacheable=true)
    public static List<Task> getTaskByAccountId(String accountId){
        try {
            return [SELECT Id, Subject, Status, Priority, ActivityDate from Task WHERE AccountId = :accountId];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateTask(Task task) {
        update task;
    }


}