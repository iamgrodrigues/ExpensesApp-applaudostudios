@isTest
public class TestUtils {

    public static Expense__c buildExpense(){
        return buildExpense(null, null, null, null, null);
    }

    public static Expense__c buildExpense(String name, String category, Decimal amount, String rePeriodicity, Integer noRecurrence){

        if (String.isBlank(name)) {
            name = 'Expense';
        }
        if (String.isBlank(category)) {
            category = 'Food';
        }
        if (amount == null) {
            amount = 10.5;
        }
        if (String.isBlank(rePeriodicity)) {
            rePeriodicity = 'Monthly';
        }
        if (noRecurrence == null) {
            noRecurrence = 12;
        }

        Expense__c expense = new Expense__c(
            Name = name,
            Category__c = category,
            Amount__c = amount,
            Recurrence_Periodicity__c = rePeriodicity,
            No_Recurrences__c = noRecurrence
        );

        return expense;
    }
}
