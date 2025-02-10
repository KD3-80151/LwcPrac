public class RestAccountFetch {
    private static final String CLIENT_ID = '3MVG9GCMQoQ6rpzTbF2ZrTVMkPyPSqA1ABF8wzmqlLvsRdn_.fDbKkAnMWWVX9ts6.RW9BE1gp8yKlbnxLgyI';  
    private static final String CLIENT_SECRET = '52ECBB52AFEFD4282108490C9B8B2090858753F20BE5069DABCC1C1CBDC9DEC9';  
    private static final String USERNAME = 'sagarkum8@gmail.com';  
    private static final String PASSWORD = 'Supersales26@';  
    private static final String TOKEN_URL = 'https://login.salesforce.com/services/oauth2/token';  
    private static final String ORG_A_API_URL = 'https://test-5fb-dev-ed.develop.my.salesforce.com/services/data/v58.0/query/?q=';  

    public static String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(TOKEN_URL);
        req.setMethod('POST'); // to get access token
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String requestBody = 'grant_type=password'
            + '&client_id=' + CLIENT_ID
            + '&client_secret=' + CLIENT_SECRET
            + '&username=' + USERNAME
            + '&password=' + PASSWORD;
        
        req.setBody(requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) resultMap.get('access_token');
        } else {
            System.debug('Failed to get access token: ' + res.getBody());
            throw new CalloutException('Failed to obtain access token.');
        }
    }

    public static List<Account> fetchAccounts() {
        List<Account> accounts = new List<Account>();

        String accessToken = getAccessToken();
        if (String.isBlank(accessToken)) {
            return accounts;
        }
        

        // SOQL query to fetch 10 Account records
        String query = 'SELECT Id, Name FROM Account LIMIT 10';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(ORG_A_API_URL + EncodingUtil.urlEncode(query, 'UTF-8')); 
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            System.debug('Response Body: ' + res.getBody());

            if (resultMap.containsKey('records')) {
                List<Object> records = (List<Object>) resultMap.get('records');

                if (records != null && !records.isEmpty()) {
                    for (Object obj : records) {
                        Map<String, Object> recordMap = (Map<String, Object>) obj;
                        Account acc = new Account();
                        acc.Id = (String) recordMap.get('Id');
                        acc.Name = (String) recordMap.get('Name');
                        accounts.add(acc);
                    }
                } else {
                    System.debug('No records found in the response.');
                }
            } else {
                System.debug('Records field is missing in the response.');
            }
        } else {
            System.debug('Failed to fetch accounts: ' + res.getBody());
        }

        return accounts;
    }

    public static void insertAccounts(String jsonAccountData) {
    // Deserialize JSON input into a List of Objects
    List<Object> accountDataList = (List<Object>) JSON.deserializeUntyped(jsonAccountData);
    List<Account> accountsToInsert = new List<Account>();

    // Loop through the list and create Account records
    for (Object obj : accountDataList) {
        // Cast each Object to a Map<String, Object>
        Map<String, Object> accountData = (Map<String, Object>) obj;
        Account acc = new Account();

        if (accountData.containsKey('Name')) {
            acc.Name = (String) accountData.get('Name');
        }
        if (accountData.containsKey('Email')) {
            acc.Account_Email__c = (String) accountData.get('Email');
        }

        accountsToInsert.add(acc);
    }

    // Insert all Accounts in a single DML operation
    if (!accountsToInsert.isEmpty()) {
        try {
            insert accountsToInsert;
            System.debug('Accounts inserted successfully');
        } catch (DmlException e) {
            System.debug('Error inserting accounts: ' + e.getMessage());
        }
    }
}

}

/*
Executing from anonymous  

List<Account> accounts = RestAccountFetch.fetchAccounts();
for (Account acc : accounts) {
    System.debug('Account Name: ' + acc.Name + ', Account ID: ' + acc.Id);
}


String jsonData = '[{"Name": "Account 1", "Email": "account1@example.com"},'
                + '{"Name": "Account 2", "Email": "account2@example.com"},'
                + '{"Name": "Account 3", "Email": "account3@example.com"}]';


RestAccountFetch.insertAccounts(jsonData);



*/