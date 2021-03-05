trigger CallForOpptyTriggerMainEntry on Product2 (before insert, after insert, before update, after update) {

    CallForOpptyTriggerDispatcher.TriggerDispatch(
        Trigger.isExecuting, Trigger.isBefore, Trigger.isAfter,
        Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete,
        Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
}