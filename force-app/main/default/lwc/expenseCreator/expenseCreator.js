import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import NAME_FIELD from '@salesforce/schema/Expense__c.Name';
import AMOUNT_FIELD from '@salesforce/schema/Expense__c.Amount__c';
import CATEGORY_FIELD from '@salesforce/schema/Expense__c.Category__c';
import EXPENSE_DATE_FIELD from '@salesforce/schema/Expense__c.Expense_Date__c';
import RECURRENCE_PERIODICITY_FIELD from '@salesforce/schema/Expense__c.Recurrence_Periodicity__c';
import NO_RECURRENCES_FIELD from '@salesforce/schema/Expense__c.No_Recurrences__c';


export default class ExpenseCreator extends NavigationMixin(LightningElement) {

    @api objectApiName;

    fields = [NAME_FIELD, RECURRENCE_PERIODICITY_FIELD, CATEGORY_FIELD,
                , NO_RECURRENCES_FIELD, AMOUNT_FIELD, EXPENSE_DATE_FIELD];

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Expense created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: 'Expense__c',
                actionName: 'view'
            }
        });
    }
}
