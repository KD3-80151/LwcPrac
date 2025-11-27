public with sharing class CalloutQueueable implements Queueable, Database.AllowsCallouts {
    
    private string requestId;
    private Integer retryCount;
    private static final Integer MAX_RETRIES = 3;
    private static final Integer TIMEOUT_MS= 10;

    public CalloutQueueable(string requestId, Integer retryCount) {
        this.requestId = requestId;
        this.retryCount = retryCount;
    }

    public void execute(QueueableContext context){
        
    }


}