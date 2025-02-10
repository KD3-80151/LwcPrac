public class ContactController {
    @AuraEnabled
    public static List<Contact> getContact(){
        try {
            return[select Id, Name, Email, Phone, Title from Contact];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}