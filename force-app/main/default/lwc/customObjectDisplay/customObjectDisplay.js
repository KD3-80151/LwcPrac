// customObjectDisplay.js
import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getCustomObjects from '@salesforce/apex/SchemaObject.getCustomObjects';

const COLUMNS = [
    { 
        label: 'Custom Object Label', 
        fieldName: 'label', 
        type: 'button', 
        typeAttributes: { 
            label: { fieldName: 'label' }, 
            name: 'view', 
            variant: 'base' 
        } 
    }
];


export default class CustomObjectDisplay extends NavigationMixin(LightningElement) {
    columns = COLUMNS;
    customObjects;

    @wire(getCustomObjects)
    wiredCustomObjects({ error, data }) {
        if (data) {
            this.customObjects = data;
        } else if (error) {
            console.error('Error fetching custom objects:', error);
        }
    }

    handleRowAction(event) {
        const apiName = event.detail.row.apiName;

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: apiName,
                actionName: 'home'
            }
        });
    }
}
