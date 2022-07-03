import { LightningElement, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/utils';
import getExpenses from '@salesforce/apex/ExpenseController.getExpenseList';
import updateExpenses from '@salesforce/apex/ExpenseController.updateExpenses';

const columns = [
    { label: 'Name', fieldName: 'linkName', type: 'url',
        typeAttributes: {
            label: { fieldName: 'Name' },
            target: '_self'
        }
    },
    { label: 'Amount', fieldName: 'Amount__c', type: 'currency', editable: true},
    { label: 'Category', fieldName: 'Category__c', type: 'picklist',
        typeAttributes: {
            placeholder: 'Choose Category',
            options: [
                { label: 'Housing', value: 'Housing' },
                { label: 'Transportation', value: 'Transportation' },
                { label: 'Food', value: 'Food' },
                { label: 'Medical Healthcare', value: 'Medical Healthcare' },
                { label: 'Others', value: 'Others' }
            ],
            value: { fieldName: 'Category__c' },
            context: { fieldName: 'Id' },
            variant: 'label-hidden',
            name: 'Category',
            label: 'Category'
        }
    },
    { label: 'Expense Date', fieldName: 'Expense_Date__c', type: 'date-local', editable: true, },
    { label: 'Is Recurrent', fieldName: 'Is_Recurrent__c', type: 'boolean', editable: true, },
    { label: 'Recurrence Periodicity', fieldName: 'Recurrence_Periodicity__c', type: 'picklist',
        typeAttributes: {
            placeholder: 'Choose Recurrence Periodicity',
            options: [
                { label: 'Weekly', value: 'Weekly' },
                { label: 'Monthly', value: 'Monthly' },
            ],
            value: { fieldName: 'Recurrence_Periodicity__c' },
            context: { fieldName: 'Id' },
            variant: 'label-hidden',
            name: 'Recurrence Periodicity',
            label: 'Recurrence Periodicity'
        }
    },
];

export default class ExpenseList extends LightningElement {
    columns = columns;
    records;
    lastSavedData;
    error;
    expenses;
    showSpinner = false;
    draftValues = [];
    privateChildren = {};
    showPositionCreateModal = false;

    toggleModal(){
        this.showPositionCreateModal = !this.showPositionCreateModal;
    }

    renderedCallback() {
        if (!this.isComponentLoaded) {
            window.addEventListener('click', (evt) => {
                this.handleWindowOnclick(evt);
            });
            this.isComponentLoaded = true;
        }
    }

    disconnectedCallback() {
        window.removeEventListener('click', () => { });
    }

    handleWindowOnclick(context) {
        this.resetPopups('c-datatable-picklist', context);
    }

    resetPopups(markup, context) {
        let elementMarkup = this.privateChildren[markup];
        if (elementMarkup) {
            Object.values(elementMarkup).forEach((element) => {
                element.callbacks.reset(context);
            });
        }
    }

    @wire(getExpenses)
    wiredRelatedRecords(result) {
        this.expenses = result;
        const { data, error } = result;
        if (data) {
            this.records = JSON.parse(JSON.stringify(data));
            this.records.forEach(record => {
                record.linkName = '/' + record.Id;
            });
            this.error = undefined;
        } else if (error) {
            this.records = undefined;
            this.error = error;
        } else {
            this.error = undefined;
            this.records = undefined;
        }
        this.lastSavedData = this.records;
        this.showSpinner = false;
    }

    handleItemRegister(event) {
        event.stopPropagation();
        const item = event.detail;
        if (!this.privateChildren.hasOwnProperty(item.name))
            this.privateChildren[item.name] = {};
        this.privateChildren[item.name][item.guid] = item;
    }

    handleChange(event) {
        event.preventDefault();
        this.showSpinner = true;
    }

    handleCancel(event) {
        event.preventDefault();
        this.records = JSON.parse(JSON.stringify(this.lastSavedData));
        this.handleWindowOnclick('reset');
        this.draftValues = [];
    }

	handleCellChange(event) {
        event.preventDefault();
        this.updateDraftValues(event.detail.draftValues[0]);
    }

    handleValueChange(event) {
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        let updatedItem;
        switch (dataRecieved.label) {
            case 'Category':
                updatedItem = {
                    Id: dataRecieved.context,
                    Category__c: dataRecieved.value
                };
                break;
            case 'Recurrence Periodicity':
                updatedItem = {
                    Id: dataRecieved.context,
                    Recurrence_Periodicity__c: dataRecieved.value
                };
                break;
            default:
                break;
        }
        this.updateDraftValues(updatedItem);
        this.updateDataValues(updatedItem);
    }

    updateDataValues(updateItem) {
        let copyData = JSON.parse(JSON.stringify(this.records));
        copyData.forEach((item) => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
        this.records = [...copyData];
    }

    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = JSON.parse(JSON.stringify(this.draftValues));
        copyDraftValues.forEach((item) => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });
        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }

    handleEdit(event) {
        event.preventDefault();
    }

    handleSave(event) {
        event.preventDefault();
        this.showSpinner = true;
        updateExpenses({ data: this.draftValues })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Expenses updated successfully',
                        variant: 'success'
                    })
                );
                refreshApex(this.expenses).then(() => {
                    this.draftValues = [];
                });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating expenses',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
                this.showSpinner = false;
            });
    }
}