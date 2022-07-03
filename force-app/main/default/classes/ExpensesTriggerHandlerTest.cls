@isTest
public class ExpensesTriggerHandlerTest {

    @TestSetup
    static void testSetupData() {

    }

    @isTest
    static void shouldTestInsert() {

    }

    @isTest
    static void shouldTestUpdate() {

    }

    @isTest
    static void shouldTestDeleteAndUndelete() {

        Expense__c expenseToDelete = [SELECT Id FROM Expense__c LIMIT 1];

        Test.startTest();
            delete expenseToDelete;
        Test.stopTest();

        Map<Id, Expense__c> expenseMap = new Map<Id, Expense__c>([SELECT Id FROM Expense__c]);

        System.assertEquals(false, expenseMap.containsKey(expenseToDelete.Id));

        Expense__c expenseToUndelete = [SELECT Id FROM Expense__c
                                                        WHERE Id = :expenseToDelete.Id
                                                            AND isDeleted = true ALL ROWS];

        undelete expenseToUndelete;

        Map<Id, Expense__c> undeleteExpenseMap = new Map<Id, Expense__c>([SELECT Id FROM Expense__c]);

        System.assertEquals(true, undeleteExpenseMap.containsKey(expenseToUndelete.Id));
    }
}