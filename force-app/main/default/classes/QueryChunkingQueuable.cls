public with sharing class QueryChunkingQueuable implements Queueable {

    private Database.Cursor locator;
    private Integer positions;

    //to initialise the cursor and resets position
    public QueryChunkingQueuable() {
        //1. Initialize the cursor with a query
        locator = Database.getCursor('SELECT Id FROM Contact WHERE LastActivityDate = LAST_N_DAYS:400');
        //2. Reset the position to 0
        positions = 0;
        
    }

    //execute method to process the records in chunks
    public void execute(QueueableContext context) {
        //3. Process the records in chunks
        List<Contact> scope = locator.fetch(positions, 200);
        positions += scope.size();

        //logic to process the scope
        if (positions < locator.getNumRecords()) {
            System.enqueueJob(this);
        }
    }


}