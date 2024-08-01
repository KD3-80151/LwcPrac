// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//string tempvar = 'Enter_your_name_here';
//System.debug('Hello World!');
//System.debug('My name is ' + tempvar);

//SalesforceIntegrationUsingRest.accuWeather('Jind');


//get the singleton instance
//SingletonExample single = SingletonExample.getInstance();

//calling a method on singleton instance
//single.calledMethodByInstance();

// Map<String, String> result = GetAccountRest.getAccessTokenDetails();
// System.debug('Access Token: ' + result.get('access_token'));
// System.debug('Instance URL: ' + result.get('instance_url'));

List<Account> accounts = GetAccountRest.getAccounts();
for (Account acc : accounts) {
    System.debug('Account Id: ' + acc.Id + ', Name: ' + acc.Name);
}
