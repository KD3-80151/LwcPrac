public with sharing class CreateOpportunityonAccountCreation {

    public static void createOpportunity(List<Account> accntList) {
        List<Opportunity> oppList = new List<Opportunity>();

        for (Account acc : accntList) {
            for (Integer i = 0; i < 2; i++) {
                Opportunity opp = new Opportunity();
                opp.Name = 'Test ' + (i + 1);
                opp.AccountId = acc.Id;
                opp.StageName = 'Prospecting';
                opp.CloseDate = Date.today().addMonths(1);
                oppList.add(opp);
            }
        }
        insert oppList;
    }
}
