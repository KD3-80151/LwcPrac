public class OpportunityCrudHandler { //OppoCount__c
    public static void isInserted(List<Opportunity> oppList){
        Set<Id> oppSet = new Set<Id>();
        for(Opportunity opp: oppList){
            if(opp.AccountId != null){
                oppSet.add(opp.AccountId);
            }
        }
        updatedOppo(oppSet);
    }
    public static void isUpdated(List<Opportunity> oppList, Map<Id, Opportunity> oldOppo){
        Set<Id> setId = new Set<Id>(); //to store the unique AccountIds affected by the update.
        for(Opportunity opp: oppList){
            if(opp.AccountId != null){
                setId.add(opp.AccountId);
            }
            //checks if the AccountId of the opportunity has changed by comparing the old AccountId 
            //(from oldOppo map) with the new AccountId
            if(oldOppo.get(opp.Id).AccountId !=null && oldOppo.get(opp.Id).AccountId != opp.AccountId){
                setId.add(oldOppo.get(opp.Id).AccountId); // adds the old AccountId to the set setId
            }
        }
        updatedOppo(setId);
        
    }
    public static void isDeleted(List<Opportunity> oppoList){
        Set<Id> setId = new Set<Id>();
        for(Opportunity opp: oppoList ){
            if(opp.AccountId!=null){
                setId.add(opp.AccountId);
            }
        }
        updatedOppo(setId);
        
    }

    //key idea is that the updatedOppo method always recalculates the counts based on the current state of the database,
    // ensuring that the OppoCount__c field is always accurate.
    public static void updatedOppo(Set<Id> oppSet){
        
        //map to hold the count of opportunities per account
        Map<Id, Integer> mapId = new Map<Id, Integer>();

         // Initialize the map with Account IDs
        for(Id accntId: oppSet){
            mapId.put(accntId, 0);  // Initialize the count to 0 for each account
        }

        // Count opportunities for each Account ID
        //Query all opportunities that are associated with the accounts in oppSet
        for(Opportunity cont :[select AccountId from Opportunity where AccountId IN: oppSet]){
            if(mapId.containsKey(cont.AccountId)){
                mapId.put(cont.AccountId, mapId.get(cont.AccountId)+1); // Increment the count for each account
            }
        }
        
         // Step 3: Prepare a list to store accounts that need to be updated
        List<Account> acc= new List<Account>();

        // Step 4: Query the current opportunity counts for the accounts in oppSet
        Map<Id, Account> currentCount = new Map<Id, Account>([select Id, OppoCount__c from Account where Id IN: oppSet]);
        
        // Step 5: Update the opportunity count for each account
        for(Id acntId: oppSet){
            Account acc1 = currentCount.get(acntId); // Get the account record
            Integer newOppoCount = mapId.get(acntId);// Get the new opportunity count
            
            if(acc1.OppoCount__c != null){
                acc1.OppoCount__c = newOppoCount; // Update the opportunity count field
            }
            else{
                acc1.OppoCount__c=0; // Set the value to 0
            }
            acc.add(acc1);  // Add the account to the list of accounts to be updated
        }
        
        if(!acc.isEmpty()){
            update acc;
        }

    }

}