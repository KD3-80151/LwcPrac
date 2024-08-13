trigger OpportunityTrigger on Opportunity (after insert, before insert, after update, before update, after delete, before delete) {
//     if(Trigger.isBefore && Trigger.isDelete){
//        OpportunityTriggerHandler.OpportunityClosed(Trigger.old);
//    }
    
//     if(Trigger.isAfter && Trigger.isInsert){
//         OpportunityCrudHandler.isInserted(Trigger.new);
//     }
    	
//     if(Trigger.isAfter && Trigger.isUpdate){
//         OpportunityCrudHandler.isUpdated(Trigger.new, Trigger.oldMap);
//     }
//     if(Trigger.isAfter && Trigger.isDelete){
//         OpportunityCrudHandler.isDeleted(Trigger.old);
//     }

    // if(Trigger.isAfter && Trigger.isUpdate){
    //     OpportunityTotalAmountOnAccount.OpportunityTotalAmountOnAccount(Trigger.new, Trigger.oldMap);
    // }

    // if(Trigger.isBefore && Trigger.isUpdate){
    //     OpportunityValidationTrigger.opportunityValidation(Trigger.new, Trigger.oldMap);
    // }


    // if(Trigger.isInsert && Trigger.isAfter){
    //     OpportunityCountHandler.onInsertionOpportunityUpdateCountInAccount(Trigger.new);
    // }


    //     if(Trigger.isUpdate && Trigger.isAfter){
    //     OpportunityCountHandler.onUpdationOpportunityUpdateCountInAccount(Trigger.newMap,Trigger.old);
    // }

    //     if(Trigger.isDelete && Trigger.isAfter){
    //     OpportunityCountHandler.onDeletionOpportunityUpdateCountInAccount(Trigger.old);
    // }

    // if (Trigger.isUpdate && Trigger.isAfter) {
    //     OpportunityTotalAmountOnAccount.calculateTotalOppSumRelWithAccnt(Trigger.new, Trigger.oldMap);
    // }
 }