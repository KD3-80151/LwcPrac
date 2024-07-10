public class AccountBatchUpdate implements Database.Batchable<sObject>, Database.Stateful{
    public Database.QueryLocator start (Database.BatchableContext bc){
        return Database.getQueryLocator ('select Id, Name, from Account');
    }
    
    public void execute (Database.BatchableContext bc, List<Account> scope){
        for(Account acc: scope){
            acc.Description = 'Updated by batch process';
        }
        update scope;
    }
    
    public void finish (Database.BatchableContext bc){
        Database.executeBatch(new AccountBatchTwoUpdate());
    }
    
        

}