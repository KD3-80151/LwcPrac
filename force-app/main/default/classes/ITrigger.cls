public interface ITrigger {
    
    void bulkBefore();
    void bulkAfter();
    void beforeInsert(List<SObject> newRecords);
    void beforeUpdate(Map<Id, SObject> oldRecordMap,Map<Id, SObject> newRecordMap);
    void beforeDelete(List<SObject> oldRecords, Map<Id,SObject> oldRecordMap);
    void afterInsert(List<SObject> newRecord, Map<Id,SObject> newRecordMap);
    void afterUpdate(Map<Id,SObject> oldRecordMap, Map<Id,SObject> newRecordMap);
    void afterDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap);
    void andFinally(List<SObject> newRecords, Map<ID, SObject> newRecordMap);



}