
@RestResource(urlMapping='/getAccountIds')
global with sharing class GetAccounts {

    @HttpGet
    global static List<Account> getAccountIds() {
        List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
        List<Id> accountIds = new List<Id>();
        for (Account acc : accounts) {
            accountIds.add(acc.Id);
        }
        return accounts;
    }
}