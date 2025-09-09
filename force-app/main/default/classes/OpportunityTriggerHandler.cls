public class OpportunityTriggerHandler {
    public static void OpportunityClosed(List<Opportunity> oppoList){
        
        Profile prof = [Select Id From Profile where Name = 'System Administrator' LIMIT 1];
        
        for(Opportunity oppo: oppoList){
            if(System.UserInfo.getProfileId() != prof.Id && (oppo.StageName =='Closed Won' || oppo.StageName =='Closed Lost')){
                oppo.addError('You are not admin and so you cannot delete it ');
                
            }
        }
        
    }
    
    private static boolean isExecuting = false; //prevent recursive trigger executions
    
    public static void updateAccountRollup(Set<Id> opportunityIds){
        if(isExecuting || opportunityIds.isEmpty()) return;
        isExecuting = true;
        try{
            //getRelateds ids of an account
            Set<Id> accntIds = new Set<Id>();
            List<Opportunity> oppList = [select Id, AccountId from Opportunity where Id IN :opportunityIds];
            for(Opportunity opp : oppList){
                if(opp.AccountId != null) accntIds.add(opp.AccountId);
            }
            if(accntIds.isEmpty()) return;
            
            //query aggregate data for each account
            AggregateResult[] ar = [select SUM(Amount) sAmt, COUNT(Id) cId, AccountId from Opportunity where AccountId IN: accntIds group by AccountId, StageName];
                Map<Id, Decimal> totalClosWonOpp = new Map<Id, Decimal>();
                Map<Id, Integer> totaOpenCount =  new Map<Id, Integer>();
            
            for(AggregateResult ar1: ar){
                Id accId = (Id)ar1.get('AccountId'); //The get() method of AggregateResult always returns an Object type. so typecaste
                //ar1.get('AccountId') → returns an Object (e.g. "001XXXXXXXXXXXX").
                //(Id) → tells Apex: “Treat this Object as an Id type.”
                //Now accId is strongly typed as Id, so you can use it in queries, sets, or comparisons.
                String stage = (String)ar1.get('StageName');
                
                if(stage == 'Closed Won'){ totalClosWonOpp.put(accId, (Decimal)ar1.get('sAmt')); }
                else{ Integer currentCount = totaOpenCount.containsKey(accId) ? totaOpenCount.get(accId) : 0;
                      totaOpenCount.put(accId, currentCount + Integer.valueOf(ar1.get('cId')));
                    }
                
                //to fetch parent hierarchy
                Map<Id, Account> fetchParent = new Map<Id, Account>([select Id, ParentId from Account where Id IN :accntIds]);
                //prepare accounts for update
                List<Account> acntsToUpdate = new List<Account>();
                for(Id acId : accntIds){
                    Account acc = new Account(Id = acId);
                    acc.Total_Closed_Won_Amount__c = totalClosWonOpp.containsKey(acId) ? totalClosWonOpp.get(acId) : 0;
                    acc.Total_Open_Opportunity_Count__c = totaOpenCount.containsKey(acId) ? totaOpenCount.get(acId) : 0;
                    acntsToUpdate.add(acc);
                    
                    //update parent hierarchy 
                    if(fetchParent.get(acId).ParentId != null){
                        Id parent = fetchParent.get(acId).ParentId;
                        Account parentAccount = new Account(Id = acId);
                        parentAccount.Total_Closed_Won_Amount__c = acc.Total_Closed_Won_Amount__c;//totalClosWonOpp.containsKey(acId) ? totalClosWonOpp.get(acId) : 0;
                        parentAccount.Total_Open_Opportunity_Count__c = acc.Total_Open_Opportunity_Count__c; //totaOpenCount.containsKey(acId) ? totaOpenCount(acId) : 0;
                        acntsToUpdate.add(parentAccount);
                    }
                    
                    
                }
                if(!acntsToUpdate.isEmpty()){
                    update acntsToUpdate;
                }
                
            }
            
        }
         catch(Exception e){
                System.debug('At line issue ::>>' + e.getLineNumber() + 'stacktrace::>>' + e.getStackTraceString());
            }
            
            finally {
                isExecuting = false;
            }
    }
        
    }