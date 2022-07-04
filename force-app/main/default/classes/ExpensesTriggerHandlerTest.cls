@isTest
public class ExpensesTriggerHandlerTest {

    @TestSetup
    static void testSetupData() {

        List<Expense__c> expenseBulkList = new List<Expense__c>();

        for (Integer i = 0; i < 100; i++) {
            if (i < 50) {
                Expense__c weeklyExpense = TestUtils.buildExpense(
                    'Weekly Expense Test ' + i,
                    Constants.EXPENSE_CATEGORY_FOOD,
                    130.75,
                    Constants.EXPENSE_PERIODICITY_WEEKLY,
                    4
                );
                expenseBulkList.add(weeklyExpense);
            } else {
                Expense__c monthlyExpense = TestUtils.buildExpense(
                    'Monthly Expense Test ' + i,
                    Constants.EXPENSE_CATEGORY_FOOD,
                    130.75,
                    Constants.EXPENSE_PERIODICITY_MONTHLY,
                    4
                );
                expenseBulkList.add(monthlyExpense);
            }
        }

        insert expenseBulkList;
    }

    @isTest
    static void shouldTestWeeklyRecurrence() {

        List<Expense__c> weeklyExpenseList = [SELECT Id, Expense_Date__c
                                                FROM Expense__c
                                                WHERE Name = 'Weekly Expense Test 1'
                                                ORDER BY Expense_Date__c];

        Datetime today = System.now();
        Date todayGMT = today.dateGMT();

        Date oneWeekFromToday = todayGMT.addDays(7);
        Date twoWeekFromToday = todayGMT.addDays(14);
        Date threeWeekFromToday = todayGMT.addDays(21);

        System.assertEquals(4, weeklyExpenseList.size());
        System.assertEquals(oneWeekFromToday.toStartOfWeek().addDays(5), weeklyExpenseList[1].Expense_Date__c);
        System.assertEquals(twoWeekFromToday.toStartOfWeek().addDays(5), weeklyExpenseList[2].Expense_Date__c);
        System.assertEquals(threeWeekFromToday.toStartOfWeek().addDays(5), weeklyExpenseList[3].Expense_Date__c);
    }

    @isTest
    static void shouldTestMonthlyRecurrence() {

        List<Expense__c> monthlyExpenseList = [SELECT Id, Expense_Date__c
                                                FROM Expense__c
                                                WHERE Name = 'Monthly Expense Test 60'
                                                ORDER BY Expense_Date__c];

        Date today = System.today();

        System.assertEquals(4, monthlyExpenseList.size());
        System.assertEquals(today.addMonths(1).toStartOfMonth().addDays(14), monthlyExpenseList[1].Expense_Date__c);
        System.assertEquals(today.addMonths(2).toStartOfMonth().addDays(14), monthlyExpenseList[2].Expense_Date__c);
        System.assertEquals(today.addMonths(3).toStartOfMonth().addDays(14), monthlyExpenseList[3].Expense_Date__c);

    }

    @isTest
    static void shouldTestUpdate() {

        Expense__c expense = [SELECT Id, Name FROM Expense__c WHERE Name = 'Weekly Expense Test 1' LIMIT 1];
        expense.Name = 'Expense 01';

        Test.startTest();
            update expense;
        Test.stopTest();

        System.assertEquals('Expense 01', expense.Name);
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