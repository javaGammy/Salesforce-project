public class CallForOpptyTriggerDispatcher {
    
    private static boolean isFirstRun = true;

    public static void TriggerDispatch(Boolean isExecuting, Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<Product2> oldList, List<Product2> newList, Map<Id, Product2> oldMap, Map<Id, Product2> newMap){
        try {
            system.debug('start: CallForOpptyTriggerDispatcher.isFirstRun: ' + isFirstRun);
            
            List<Opportunity> oppList = new List<Opportunity>([SELECT Id, OwnerId, Account.Phone FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM OpportunityLineItem WHERE Product2Id IN : Trigger.New )]);    
    
            List<Product2> prodList = new List<Product2>([SELECT Id, IsActive FROM Product2 WHERE Id IN : Trigger.New]);

            List<Task> oTask = new List<Task>();
    
           for (Opportunity oppty : oppList){
        
            for(Product2 prod : prodList){
           
                system.debug('isExecuting ' +isExecuting);
                
                if (isExecuting) { 
                    system.debug('isAfter ' + isAfter);
                    
                    if (isAfter) {
                         
                        if(prod.IsActive == False){          
                     
                        oTask.add(new Task(Subject= 'Call', Status='New', AutoCreated__c = True, ActivityDate=Date.today() + 31, Priority = 'Hight', WhatId=oppty.Id, OwnerId=Oppty.OwnerId));
                    }
                  }
               }
            }
          }

            if (oTask.size() > 0) insert oTask;

            if (isFirstRun) isFirstRun(false); 
            system.debug('end: CallForOpptyTriggerDispatcher');
        } 
        catch (Exception Ex) {
            throw(Ex);
        }
        }
    
   
    public static void isFirstRun(Boolean isRun) {
        
        CallForOpptyTriggerDispatcher.isFirstRun = isRun;
    }

}