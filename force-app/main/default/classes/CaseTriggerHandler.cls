public class CaseTriggerHandler {
    public static void handleAfter(List<Case> newCase, Map<Id, Case> oldMap){
		List<Task> insertTask = new List<Task>();
		
        for(Case cs : newCase){
            Case oldCs = oldMap != null ? oldMap.get(cs.Id) : null; // updated record came here oldCs Id
            Boolean isHighPrio = (cs.Priority == 'High' && cs.Status == 'New');
            Boolean wasNewHigh = oldCs != null && oldCs.Priority == 'High' && oldCs.Status == 'New'; 
            
            if(isHighPrio && !wasNewHigh){
                insertTask.add(new Task(
                	WhatId = cs.Id,
                    OwnerId =cs.OwnerId ,
                    Subject = 'follow up on high priority task',
                    Status = 'Not Started',
                    Priority = 'High'
                ));
            }
        }        
    }
}