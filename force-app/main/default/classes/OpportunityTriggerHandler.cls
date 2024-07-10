public class OpportunityTriggerHandler {
    public static void OpportunityClosed(List<Opportunity> oppoList){
        
        Profile prof = [Select Id From Profile where Name = 'System Administrator' LIMIT 1];
        
        for(Opportunity oppo: oppoList){
            if(System.UserInfo.getProfileId() != prof.Id && (oppo.StageName =='Closed Won' || oppo.StageName =='Closed Lost')){
                oppo.addError('You are not admin and so you cannot delete it ');

            }
        }

    }

}