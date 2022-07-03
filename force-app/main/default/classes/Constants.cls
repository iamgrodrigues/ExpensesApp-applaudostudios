public with sharing class Constants {

    //Expense Recurrence Periodicity types
	public static final String EXPENSE_PERIODICITY_WEEKLY = 'Weekly';
	public static final String EXPENSE_PERIODICITY_MONTHLY = 'Monthly';

    //Trigger Event types
	public static final String BEFORE_INSERT = 'Before_Insert__c';
	public static final String BEFORE_UPDATE = 'Before_Update__c';
	public static final String BEFORE_DELETE = 'Before_Delete__c';
    public static final String AFTER_INSERT = 'After_Insert__c';
	public static final String AFTER_UPDATE  = 'After_Update__c';
	public static final String AFTER_DELETE  = 'After_Delete__c';
	public static final String AFTER_UNDELETE = 'After_Undelete__c';
}
