public class ExpensesTriggerHandler {

    private Boolean isExecuting = false;
    private Integer size = 0;
    public static Boolean stopTrigger = false;

    public ExpensesTriggerHandler(boolean isExecuting, Integer size) {
        this.isExecuting = isExecuting;
        this.size = size;
    }

    public void onBeforeInsert(List<Expense__c> newExpenseList) {
        System.debug('onBeforeInsert');
	}

    public void onBeforeUpdate(List<Expense__c> newExpenseList, Map<Id, Expense__c> newExpenseMap, List<Expense__c> oldExpenseList, Map<Id, Expense__c> oldExpenseMap) {
        System.debug('onBeforeUpdate');
	}

    public void onBeforeDelete(List<Expense__c> oldExpenseList, Map<Id, Expense__c> oldExpenseMap) {
        System.debug('onBeforeDelete');
	}

    public void onAfterInsert(List<Expense__c> newExpenseList, Map<Id, Expense__c> newExpenseMap) {
        cloneRecurrentExpenses(newExpenseList);
	}

    public void onAfterUpdate(List<Expense__c> newExpenseList, Map<Id, Expense__c> newExpenseMap, List<Expense__c> oldExpenseList, Map<Id, Expense__c> oldExpenseMap) {
        System.debug('onAfterUpdate');
	}

    public void onAfterDelete(List<Expense__c> oldExpenseList, Map<Id, Expense__c> oldExpenseMap) {
        System.debug('onAfterDelete');
	}

    public void onAfterUndelete(List<Expense__c> newExpenseList, Map<Id, Expense__c> newExpenseMap) {
        System.debug('onAfterUndelete');
	}

    private void cloneRecurrentExpenses(List<Expense__c> newExpenseList) {

        List<Expense__c> clonedExpenses = new List<Expense__c>();
        Expense__c cloneExpense;

        for (Expense__c expense : newExpenseList) {
            if (!expense.isClone()) {
                for (Integer i = 1; i < expense.No_Recurrences__c; i++) {
                    if (Constants.EXPENSE_PERIODICITY_MONTHLY.equals(expense.Recurrence_Periodicity__c)) {
                        cloneExpense = expense.clone(false, false, true, false);
                        cloneExpense.Expense_Date__c = expense.Expense_Date__c
                                                        .addMonths(i)
                                                        .toStartOfMonth()
                                                        .addDays(14);
                        clonedExpenses.add(cloneExpense);
                    } else if (Constants.EXPENSE_PERIODICITY_WEEKLY.equals(expense.Recurrence_Periodicity__c)) {
                        cloneExpense = expense.clone(false, false, true, false);
                        cloneExpense.Expense_Date__c = getWeeklyExpenseDate(expense.Expense_Date__c, i);
                        clonedExpenses.add(cloneExpense);
                    }
                }
            }
        }

        insert clonedExpenses;
    }

    private Date getWeeklyExpenseDate(Date localDate, Integer days) {

        days *= 7;

        Datetime localDateTime = localDate;
        date gmtdate = localDateTime.dateGMT().addDays(days);

        return gmtdate.toStartOfWeek().addDays(5);
    }
}

