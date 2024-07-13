 trigger AccountTrigger on Account (after insert, before insert, after update, before update, after delete, before delete) {
// if(trigger.isInsert && trigger.isAfter) 
//     AccountTriggerHandler.AccountTriggerContact(Trigger.new);
//     if(trigger.isAfter && trigger.isInsert){
//         CreateOpportunityOnAgricultureHandler.OpportunityIndustry(trigger.new);
//     }
//     if(trigger.isAfter && trigger.isUpdate){
//         CreateOpportunityOnAgricultureHandler.OpportunityIndustry(trigger.new);
//     }
//     if (Trigger.isUpdate && Trigger.isBefore) {
//         AccountOwnerTriggerHandler.AccountTriggerOwner(Trigger.new, Trigger.oldMap);
//     }
    
//     if(Trigger.isDelete && Trigger.isBefore){
// 		ErrorAccountDelete.AccountContactError(Trigger.old);
//     }
    
//     if(trigger.isUpdate && trigger.isAfter)
//         FutureClass.CallTheFutureMethod(Trigger.new , Trigger.oldMap);
    
//     if(trigger.isUpdate && trigger.isAfter){
//         UpdateMailingCity.MailCity(Trigger.new, Trigger.oldMap);
//     }
        
        if(trigger.isAfter && trigger.isInsert){
            PhoneNumberController.PhoneNoRequired(Trigger.new);
        }

 }