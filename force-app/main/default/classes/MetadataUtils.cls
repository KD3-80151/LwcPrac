public with sharing class MetadataUtils implements Metadata.DeployCallback{
    public MetadataUtils() {

    }
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        // Handle the deployment result
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug('Deployment succeeded');
        } else {
            System.debug('Deployment failed: ' + result.getErrorMessage());
        }
    }

    public static void createUpdateMetadata(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;

        for (String key : fieldWithValuesMap.keySet()) {
            Metadata.CustomMetadataValue value = new Metadata.CustomMetadataValue();
            value.field = key;
            value.value = String.valueOf(fieldWithValuesMap.get(key));
            customMetadata.values.add(value);
            
        }
    }

    
}