public with sharing class DuplicateLeadsManager {

    public class LeadDTO{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        @AuraEnabled public String company;
        @AuraEnabled public String phone;
        @AuraEnabled public String leadSource;
    }

    
    public static void getDupLeads(){

    }
}