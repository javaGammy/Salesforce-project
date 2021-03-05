trigger CaseAutoCreationTriggerMainEntry on Contact (before insert, after insert, before update, after update) {

    CaseAutoCreationTriggerDispatcher.TriggerDispatch(
       Trigger.isExecuting, Trigger.isBefore, Trigger.isAfter,
       Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
       Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
}