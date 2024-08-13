trigger ContactTrigger on Contact (after insert, before insert,after delete, before delete,after update, before update) {
//   if(trigger.isInsert && trigger.isAfter)    ContactTriggerHandler.handlerContact(Trigger.new);
  
    // if(trigger.isDelete && trigger.isAfter){
    //     ContactTriggerCrudHandler.isContactDeleted(Trigger.old);
    // }
    
    // if(trigger.isUpdate && trigger.isAfter){
    //     ContactTriggerCrudHandler.IsContactUpdated(Trigger.new, Trigger.oldMap);
    // }
    
    // if(trigger.isInsert && trigger.isAfter){
    //     ContactTriggerCrudHandler.IsContactCreated(Trigger.new);
    // }
    
   
//    if(trigger.isInsert && trigger.isAfter)
//        ContactCreatedWithAccountHandler.ContactCreated(Trigger.new);

    // if(trigger.isInsert && trigger.isAfter){
    //     UpdateAccountTotalFields.insertContact(Trigger.new);
    // }

    // if (trigger.isUpdate && trigger.isAfter) {
    //     UpdateAccountTotalFields.updateContact(Trigger.new, Trigger.oldMap);
    // }

    // if (trigger.isDelete && trigger.isAfter) {
    //     UpdateAccountTotalFields.deleteContact(Trigger.old);
    // }

}