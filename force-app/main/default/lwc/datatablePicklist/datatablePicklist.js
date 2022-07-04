/* eslint-disable @lwc/lwc/no-api-reassignments */
import { LightningElement, api } from 'lwc';

export default class DatatablePicklist extends LightningElement {
    @api label;
    @api placeholder;
    @api options;
    @api value;
    @api context;
    @api variant;
    @api name;
    showPicklist = false;
    picklistValueChanged = false;

    handleChange(event) {
        event.preventDefault();
        this.picklistValueChanged = true;
        this.value = event.detail.value;
        this.showPicklist = false;
        this.dispatchCustomEvent('valuechange', this.context, this.value, this.label, this.name);
    }

    renderedCallback() {

        this.dispatchEvent(
            new CustomEvent('itemregister', {
                bubbles: true,
                composed: true,
                detail: {
                    callbacks: {
                        reset: this.reset,
                    },
                    template: this.template,
                    guid: this.guid,
                    name: 'c-datatable-picklist'
                }
            })
        );
    }

    reset = (context) => {
        if (this.context !== context) {
            this.showPicklist = false;
        }
    }

    handleClick(event) {
        event.preventDefault();
        event.stopPropagation();
        this.showPicklist = true;
        this.dispatchCustomEvent('edit', this.context, this.value, this.label, this.name);
    }

    handleBlur(event) {
        event.preventDefault();
        this.showPicklist = false;
        if (!this.picklistValueChanged)
            this.dispatchCustomEvent('customtblur', this.context, this.value, this.label, this.name);
    }

    dispatchCustomEvent(eventName, context, value, label, name) {
        this.dispatchEvent(new CustomEvent(eventName, {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                data: { context: context, value: value, label: label, name: name }
            }
        }));
    }
}