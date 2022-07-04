public with sharing class Constants {

    //Expense Recurrence Periodicity types
	public static final String EXPENSE_PERIODICITY_WEEKLY = 'Weekly';
	public static final String EXPENSE_PERIODICITY_MONTHLY = 'Monthly';

    //Expense Category types
	public static final String EXPENSE_CATEGORY_HOUSING = 'Housing';
	public static final String EXPENSE_CATEGORY_TRANSPORTATION = 'Transportation';
	public static final String EXPENSE_CATEGORY_FOOD = 'Food';
	public static final String EXPENSE_CATEGORY_MEDICAL_HEALTHCARE = 'Medical Healthcare';
	public static final String EXPENSE_CATEGORY_OTHERS = 'Others';

    //Trigger Event types
	public static final String BEFORE_INSERT = 'Before_Insert__c';
	public static final String BEFORE_UPDATE = 'Before_Update__c';
	public static final String BEFORE_DELETE = 'Before_Delete__c';
    public static final String AFTER_INSERT = 'After_Insert__c';
	public static final String AFTER_UPDATE  = 'After_Update__c';
	public static final String AFTER_DELETE  = 'After_Delete__c';
	public static final String AFTER_UNDELETE = 'After_Undelete__c';
}
