public with sharing class DuplicateManger {
    

    
    public class LeadDTO{
        @AuraEnabled public Id leadId;
        @AuraEnabled public String leadName;
        @AuraEnabled public String leadCompany;
        @AuraEnabled public String leadEmail;
        @AuraEnabled public String leadPhone;
        @AuraEnabled public String leadStatus;
        @AuraEnabled public String leadSource;
        @AuraEnabled public String leadOwner;
        @AuraEnabled public String createdDate;
    }

    public class ClusterDTO implements Comparable{
        @AuraEnaled public String Id;
        @AuraEnabled public List<Emails> emailsList;
        @AuraEnabled public List<Phones> phonesList;
        @AuraEmaled public List<LeadDTO> leadsList;
    }

    public static List<ClusterDTO> getDuplicateLeads(){

        for(AggregateResult getDupEmails : [select Id, Email e, count(Id) c from Lead where  ])
    }
    
}