@isTest
public with sharing class UtilsTest {

    @isTest
    static void shouldCheckDisabledTriggerEvent(){

        Test.startTest();
            Boolean isDisabled = Utils.checkDisabledTriggerEvent('ExpensesTrigger', 'Before_Insert__c');
        Test.stopTest();
    }
}
