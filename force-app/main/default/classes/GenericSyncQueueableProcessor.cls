public with sharing class GenericSyncQueueableProcessor implements Queueable, Database.AllowsCallouts {
    public GenericSyncQueueableProcessor() {

    }

    private List<Id> allrecoredIds;
    private Integer nextIndx;
    private Integer delayMins = 1;
    private Integer batchSize = 15;

    public GenericSyncQueueableProcessor(List<Id> recordIds, Integer startIndex) {
        this.allrecoredIds = recordIds;
        this.nextIndx = startIndex;
    }

    public void execute(QueueableContext context){
        
    }

}