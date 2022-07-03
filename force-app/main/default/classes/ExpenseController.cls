public with sharing class ExpenseController {

    @AuraEnabled(cacheable=true)
    public static List<Expense__c> getExpenseList() {

        return [SELECT Id, Name, Amount__c, Category__c, Expense_Date__c
                        , Is_Recurrent__c
                        , Recurrence_Periodicity__c
                    FROM Expense__c];
    }

    @AuraEnabled
    public static void updateExpenses(Object data) {
        List<Expense__c> expensesToUpdate = (List<Expense__c>) JSON.deserialize(
            JSON.serialize(data),
            List<Expense__c>.class
        );
        update expensesToUpdate;
    }

    @AuraEnabled(cacheable=true)
    public static List<DataSet> getExpensesByMonth(Integer month){

        List<AggregateResult> result = [SELECT SUM(Amount__c) Total, Category__c
                                            FROM Expense__c
                                            WHERE CALENDAR_MONTH(Expense_Date__c) = :month
                                            GROUP BY Category__c];

        List<DataSet> dataSet = new List<DataSet>();

        for(AggregateResult ar:result){
            String category = (String)ar.get('Category__c') ;
            Decimal total = (Decimal)ar.get('Total');
            dataSet.add(new DataSet(category, total));
        }
        return dataSet;
    }

    public class DataSet {

        public DataSet(String label, Decimal total){
            this.label  = label;
            this.total = total;
        }

        @AuraEnabled
        public String label {get;set;}

        @AuraEnabled
        public Decimal  total {get;set;}
    }
}
