@isTest
public with sharing class ConstantsTest {

    @isTest
    static void shouldTestConstants(){

        Constants constantsClass = new Constants();

        Test.startTest();
            System.assert(constantsClass != null);
            System.assertEquals('Before_Insert__c', Constants.BEFORE_INSERT);
        Test.stopTest();
    }
}
