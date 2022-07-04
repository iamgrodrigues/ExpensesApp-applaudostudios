@isTest
public class ExpenseControllerTest {

    @TestSetup
    static void testSetupData() {

        List<Expense__c> expenseBulkList = new List<Expense__c>();

        for (Integer i = 0; i < 100; i++) {
            if (i < 50) {
                Expense__c weeklyExpense = TestUtils.buildExpense(
                    'Weekly Expense Test ' + i,
                    Constants.EXPENSE_CATEGORY_FOOD,
                    130.75,
                    null,
                    null
                );
                expenseBulkList.add(weeklyExpense);
            } else {
                Expense__c monthlyExpense = TestUtils.buildExpense(
                    'Monthly Expense Test ' + i,
                    Constants.EXPENSE_CATEGORY_FOOD,
                    130.75,
                    null,
                    null
                );
                expenseBulkList.add(monthlyExpense);
            }
        }

        insert expenseBulkList;
    }

    @isTest
    static void shouldGetExpenseList() {

        Test.startTest();
            List<Expense__c> expenseList = ExpenseController.getExpenseList();
        Test.stopTest();

        System.assertEquals(100, expenseList.size());
    }

    @isTest
    static void shouldGetExpensesByMonth() {

        Integer todayMonth = System.today().month();

        Test.startTest();
            List<ExpenseController.DataSet> expenseDataSetList = ExpenseController.getExpensesByMonth(todayMonth);
        Test.stopTest();

        List<AggregateResult> result = [SELECT SUM(Amount__c) Total
                                            FROM Expense__c];

        System.assertEquals(1, expenseDataSetList.size());
        System.assertEquals(Constants.EXPENSE_CATEGORY_FOOD, expenseDataSetList[0].label);
        System.assertEquals(result[0].get('Total'), expenseDataSetList[0].total);
    }
}