public class TriggerManager {
    public static void handle(ITrigger handler/*String metaDataControlKey */) {

        // if in custom meta data trigger is disabled then 
       // if(!Utility.isFunctionalityActive(metaDataControlKey)) return;

        // Before Trigger 
        if (Trigger.isBefore) {
            handler.bulkBefore();
            if (Trigger.isDelete) {
                handler.beforeDelete(Trigger.old, Trigger.oldMap);
            } else if (Trigger.isInsert) {
                handler.beforeInsert(Trigger.new); 
            } else if (Trigger.isUpdate) {
                handler.beforeUpdate(Trigger.oldMap, Trigger.newMap);
            }
        } else {
            handler.bulkAfter();
            if (Trigger.isDelete) {
                handler.afterDelete(Trigger.old, Trigger.oldMap);
            } else if (Trigger.isInsert) {
                handler.afterInsert(Trigger.new, Trigger.newMap);
            } else if (Trigger.isUpdate) {
                handler.afterUpdate(Trigger.oldMap, Trigger.newMap);
            }
        }

        handler.andFinally(Trigger.new, Trigger.newMap);
    }
}