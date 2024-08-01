public with sharing class TriggerManger {
    public static void handle(ITrigger handler, String metaControlKey){
        if(!Utility.isFunctionalityActive(metaDataControlKey)) return;

        if (Trigger.isBefore) {
            handler.bulkBefore();

            if (Trigger.isDelete) {
                handler.beforeDelete(Trigger.old, Trigger.oldMap);
            }
            else if (Trigger.isInsert) {
                handler.beforeInsert(Trigger.new);
            }
            else if (Trigger.isUpdate) {
                handler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
            }
        }
        else {
            handler.bulkAfter();
            if (Trigger.isDelete) {
                handler.afterDelete(Trigger.old, Trigger.oldMap);
            }
            else if (Trigger.isInsert) {
                handler.afterInsert(Trigger.new, Trigger.newMap);
            }

            else if (Trigger.isUpdate) {
                handler.afterUpdate(Trigger.newMap, Trigger.oldMap);
            }
        }

        handler.andFinally(Trigger.new, Trigger.newMap);
    }
}