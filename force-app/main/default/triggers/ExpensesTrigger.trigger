trigger ExpensesTrigger on Expense__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    ExpensesTriggerHandler triggerHandler = new ExpensesTriggerHandler(Trigger.isExecuting, Trigger.size);

    if (!ExpensesTriggerHandler.stopTrigger) {
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                if (!Utils.checkDisabledTriggerEvent('ExpensesTrigger', Constants.BEFORE_INSERT)) {
                    triggerHandler.onBeforeInsert(Trigger.new);
                }
            }
            when BEFORE_UPDATE {
                if (!Utils.checkDisabledTriggerEvent('ExpensesTrigger', Constants.BEFORE_UPDATE)) {
                    triggerHandler.onBeforeUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
                }
            }
            when BEFORE_DELETE {
                if (!Utils.checkDisabledTriggerEvent('ExpensesTrigger', Constants.BEFORE_DELETE)) {
                    triggerHandler.onBeforeDelete(Trigger.old, Trigger.oldMap);
                }
            }
            when AFTER_INSERT {
                if (!Utils.checkDisabledTriggerEvent('ExpensesTrigger', Constants.AFTER_INSERT)) {
                    triggerHandler.onAfterInsert(Trigger.new, Trigger.newMap);
                }
            }
            when AFTER_UPDATE {
                if (!Utils.checkDisabledTriggerEvent('ExpensesTrigger', Constants.AFTER_UPDATE)) {
                    triggerHandler.onAfterUpdate(Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
                }
            }
            when AFTER_DELETE {
                if (!Utils.checkDisabledTriggerEvent('ExpensesTrigger', Constants.AFTER_DELETE)) {
                    triggerHandler.onAfterDelete(Trigger.old, Trigger.oldMap);
                }
            }
            when AFTER_UNDELETE {
                if (!Utils.checkDisabledTriggerEvent('ExpensesTrigger', Constants.AFTER_UNDELETE)) {
                    triggerHandler.onAfterUndelete(Trigger.new, Trigger.newMap);
                }
            }
        }
    }
}