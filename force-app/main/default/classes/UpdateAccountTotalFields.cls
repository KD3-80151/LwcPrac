public class UpdateAccountTotalFields {
    public static void updateAccount(Id acntId){
	Account acnt = [select Id, Name from Account where Id =:acntId];
        if(acnt !=null){
		Integer opCount = [select count() from Opportunity where AccountId =: acntId];
        Integer contCount = [select count() from Contact where AccountId =: acntId];
            acnt.Total_No_of_Opportunities__c = opCount;
            acnt.Total_No_of_Contacts__c = contCount;
            
            update acnt;
            System.debug('Found with id-> ' + acntId+ 'opp count '+ acnt.Total_No_of_Opportunities__c 
                         +'contact count is '+acnt.Total_No_of_Contacts__c);
        } 
        else{
            System.debug('not found');

        }
    
    }
}