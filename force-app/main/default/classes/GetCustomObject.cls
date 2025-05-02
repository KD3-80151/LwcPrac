public with sharing class GetCustomObject {
   
/*
    //remove this method when deploying
    public static List<map<String, String>> getCustomObejct(){ //! 1. to take Id and api name 

        List<Map<String, String>> customObjects = new List<Map<String, String>>(); //!2 list store Object and map will take Id  
        Map<String, Schema.SObjectType> globalCustomObject = Schema.getGlobalDescribe(); //!3 to store list of objects 
        
        for (Schema.SObjectType sObjectType : globalCustomObject.values()) { // !4 to iterate each object 
            Schema.DescribeSObjectResult describeSResult = sObjectType.getDescribe(); //!5 to store particular object metadata
            if (describe.isCustom() && !describe.isCustomSetting()) { //!6 to check is this custom object or custom setting 
                Map<String, String> objectData = new Map<String, String>(); //!7 to store data of each object
                objectData.put('apiName', describeResult.getName()); //!8 to get api name
                objectData.put('label', describeResult.getLabel());
                customObjects.add(objectData);
            }
        }
        return customObjects;
        }



        //to get lookup object and its child object
        public Schema.ChildRelationShip getChildRelationship(String objName, String childName){
            for(Schema.ChildRelationship child: Schema.getGlobalDescribe().get(objName).getDescribe().getChildRelationships()){
                if(child.getChildSObject().getDescribe().getName() == childName){
                    return child;
                }
            }
        Id newId = Id.valueOf(recordId);
        String targetObjectApiName = newId.getSobjectType().getDescribe().getName();
        String query = String.format('SELECT Id, Name FROM {0} WHERE Id =: recordId LIMIT 1',new List<String>{targetObjectApiName});
        SObject record = Database.query(query);

       
    }

    //remove this method when deploying 
    public static List<Map<String, String>> getCustomFields(String objectyAPIName){
        List<Map<string, string>> getFieldsAPIname = new List<Map<string, string>>();
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe.get(objectyAPIName);
        if (sObjectType != null) {
            Map<String, Schema.SObjectField> getFieldsofObject = new Map<String, Schema.SObjectField>();
            for (Schema.SObjectField fieldsValue : getFieldsofObject.values() ) {
                Schema.DescribeFieldResult fD = fieldsvalue.values();
                Map<String, String> fiedsMap = new Map<String, String>();
                fieldsMap.put('apiName', fd.getName());
                fieldsMap.put('label', fd.getLabel());
                
                String fieldType = fd.getType().name();
                if(fieldType == 'REFERENCE'){
                    fieldType = 'TEXT'
                }
            }
        }
    }

    */
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getCustomObject() {
        List<Map<String, String>> customObjects = new List<Map<String, String>>();

        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        //Schema.getGlobalDescribe -> return a Map of String(api name) and Sobject

        for (Schema.SObjectType sObjectType : globalDescribe.values()) {  
            Schema.DescribeSObjectResult describeResult = sObjectType.getDescribe();
            System.debug('describeResult'+ describeResult); 

            if (describeResult.isCustom() && !describeResult.isCustomSetting()) {
                Map<String, String> objectInfo = new Map<String, String>();
                System.debug('objectInfo'+ objectInfo);
                objectInfo.put('apiName', describeResult.getName());
                objectInfo.put('label', describeResult.getLabel());
                System.debug('describeResult.getName()'+ describeResult.getName());
                customObjects.add(objectInfo);
            }
        }
        return customObjects;
    }

    
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> getFields(String objectName) {
        List<Map<String, String>> fieldsList = new List<Map<String, String>>();
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
        System.debug('sObjectType'+ sObjectType);
        if (sObjectType != null) {
            Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
            System.debug('fieldsMap'+ fieldsMap);
            for (Schema.SObjectField field : fieldsMap.values()) {
                Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
                Map<String, String> fieldInfo = new Map<String, String>();
                fieldInfo.put('apiName', fieldDescribe.getName());
                fieldInfo.put('label', fieldDescribe.getLabel());
                System.debug('fieldInfo'+ fieldInfo);
                
                String fieldType = fieldDescribe.getType().name();
                if (fieldType == 'REFERENCE') {
                    fieldType = 'TEXT';
                }
                System.debug('fieldType'+ fieldType);
                fieldInfo.put('type', fieldType);
                fieldsList.add(fieldInfo);
            }
        }
        return fieldsList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getRecords(String objectName, List<String> fieldNames) {
        List<Map<String, Object>> records = new List<Map<String, Object>>();
        System.debug('objectName'+ objectName);
        System.debug('fieldNames'+ fieldNames);

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