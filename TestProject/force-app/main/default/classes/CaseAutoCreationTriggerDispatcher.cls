public class CaseAutoCreationTriggerDispatcher {

    private static boolean isFirstRun = true;

    public static void TriggerDispatch(Boolean isExecuting, Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isDelete, List<Contact> oldList, List<Contact> newList, Map<Id, Contact> oldMap, Map<Id, Contact> newMap){
        try {
            system.debug('start: CaseAutoCreationTriggerDispatcher: ' + isFirstRun);
            
            List<String> accountId = new List<String>();
            
            for(Contact con : Trigger.New){
                accountId.add(con.AccountId);
            }
            
            
            List<Account> accList = new List<Account>([SELECT Id, OwnerId FROM Account WHERE Id IN : accountId]);

            List<Case> caseList = new List<Case>();
    
           for (Contact cont : Trigger.New){
        
            for(Account acc : accList){
            
                String casePriority;
                
                system.debug('isExecuting ' +isExecuting);
                
                if (isExecuting) { 
                    system.debug('isAfter ' + isAfter);
                    
                    if (isAfter) {
                         
                        if(cont.Level__c == 'Primary'){
                            casePriority = 'High';
                        } else if(cont.Level__c == 'Secondary'){
                            casePriority = 'Medium';
                        } else {
                            casePriority = 'Low';
                        }
                     
                            caseList.add(new Case(Status= 'Working', Origin = 'New Contact',  Priority = casePriority, AccountId=acc.Id, OwnerId=acc.OwnerId, ContactId = cont.Id));
                    
                  }
               }
            }
          }

            if (caseList.size() > 0) insert caseList;

            if (isFirstRun) isFirstRun(false); 
            system.debug('end: CaseAutoCreationTriggerDispatcher');
        } 
        catch (Exception Ex) {
            throw(Ex);
        }
        }
    
   
    public static void isFirstRun(Boolean isRun) {
        
        CaseAutoCreationTriggerDispatcher.isFirstRun = isRun;
    }

}