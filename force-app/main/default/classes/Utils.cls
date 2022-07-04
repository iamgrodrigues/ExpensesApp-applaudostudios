public with sharing class Utils {

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
