public class ErrorAccountDelete {
    public static void AccountContactError(List<Account> accountList){
        Set<Id> accountIds = new Set<Id>();
        for(Account acc: accountList){
            accountIds.add(acc.Id);

        }
        List<Contact> contactList = [select Id from Contact where AccountId IN: accountIds];
       
        if(!contactList.isEmpty()){
            String message = ' Account with associated Contact can not be deleted.';
            for(Account a:accountList){
                a.addError(message);

            }
            
        }
    }

}