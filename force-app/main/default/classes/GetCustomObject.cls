public with sharing class GetCustomObject {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCustomObject() {
        List<Map<String, String>> customObjects = new List<Map<String, String>>();

        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

        for (Schema.SObjectType sObjectType : globalDescribe.values()) {
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();

            if (describeResult.isCustom() && !describeResult.isCustomSetting()) {
                Map<String, String> objectInfo = new Map<String, String>();
                objectInfo.put('apiName', describeResult.getName());
                objectInfo.put('label', describeResult.getLabel());
                customObjects.add(objectInfo);
            }
        }

        return customObjects;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getFields(String objectName) {
        List<Map<String, String>> fieldsList = new List<Map<String, String>>();
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
        if (sObjectType != null) {
            Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
            for (Schema.SObjectField field : fieldsMap.values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                Map<String, String> fieldInfo = new Map<String, String>();
                fieldInfo.put('apiName', fieldDescribe.getName());
                fieldInfo.put('label', fieldDescribe.getLabel());
                
                String fieldType = fieldDescribe.getType().name();
                if (fieldType == 'REFERENCE') {
                    fieldType = 'TEXT';
                }
                fieldInfo.put('type', fieldType);
                fieldsList.add(fieldInfo);
            }
        }
        return fieldsList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRecords(String objectName, List<String> fieldNames) {
        List<Map<String, Object>> records = new List<Map<String, Object>>();
        String query = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM ' + objectName + ' LIMIT 100';
        List<SObject> sObjectRecords = Database.query(query);
        for (SObject record : sObjectRecords) {
            Map<String, Object> recordMap = new Map<String, Object>();
            for (String fieldName : fieldNames) {
                recordMap.put(fieldName, record.get(fieldName));
            }
            records.add(recordMap);
        }
        System.debug(records);
        return records;
    }
}