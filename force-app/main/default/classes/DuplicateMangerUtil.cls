public with sharing class DuplicateMangerUtil {
    public class LeadDto{
        @Auraenabled public Id id;
        @Auraenabled public String name;
        @Auraenabled public String email;
        @Auraenabled public String phone;
        @Auraenabled public String leadSource;
        @Auraenabled public String createdDate;
    }


    public class ClusterDto implements Comparable{
        @Auraenabled public String Id;
        @Auraenabled public List<String> emails;
        @Auraenabled public List<String> phones;
        @Auraenabled public List<LeadDto> leadList;

        public Integer compareTo(Object compareTo){
            ClusterDto clusterDto = (ClusterDto) compareTo;
        }
    }
    

}