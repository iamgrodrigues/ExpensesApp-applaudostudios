public with sharing class Utils {

    public static List<Map<String,String>> getPicklistValues(String objectName, String fieldApiName){

        List<Map<String,String>> listToReturn = new List<Map<String,String>>();
        List<String> pickListValuesList= new List<String>();

        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
                                            .get(objectName).getDescribe();

        DescribeFieldResult fieldResult = objResult.fields.getMap()
                                            .get(fieldApiName).getDescribe();

		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		for (Schema.PicklistEntry pickListVal : ple){
            listToReturn.add(
                new Map<String, String>{
                    'label' => pickListVal.getLabel(),
                    'value' => pickListVal.getValue()
                }
            );
		}

        return listToReturn;
    }

    public static Boolean checkDisabledTriggerEvent(String triggerControllerName, String event) {
		boolean isDisabled = false;

        Trigger_Controller__mdt triggerController = Trigger_Controller__mdt.getInstance(triggerControllerName);

        if (triggerController != null) {
            if (triggerController.IsActive__c) {
                if (triggerController.get(event) != true) {
                    isDisabled = true;
                }
            } else {
                isDisabled = true;
            }
        }
        return isDisabled;
    }
}
