global class UpdateOppty implements Database.Batchable<sObject>, Schedulable {    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT ID, CloseDate FROM Opportunity Where CloseDate = THIS_MONTH And StageName != \'ClosedWon\' And StageName != \'ClosedLose\'');
    }
    
     global void execute(Database.BatchableContext bc, List<Opportunity> scope){                  
         
         List<Opportunity> resultOppty = new List<Opportunity>();
         
         for (Opportunity oppty : scope){
             
             oppty.StageName = 'ClosedLost';   
             
             if(oppty.CloseDate != date.today())
                 oppty.CloseDate = date.today();
             
             resultOppty.add(oppty);
             
         }
         
         update resultOppty;
         
         
     }
         global void finish(Database.BatchableContext bc)
    {
    }
    
    global void execute(SchedulableContext ctx) {
        UpdateOppty updateOppty = new UpdateOppty();
        database.executebatch(updateOppty);
    }
    
    
}