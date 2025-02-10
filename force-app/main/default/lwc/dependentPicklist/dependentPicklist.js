import getAllObjects from '@salesforce/apex/CommonMethods.getAllObjects';
import getPicklistTypeFields from '@salesforce/apex/PicklistController.getPicklistTypeFields';
import getPickListvaluesByFieldName from '@salesforce/apex/PicklistController.getPickListvaluesByFieldName';
import { LightningElement, track } from 'lwc';

export default class DependentPicklist extends LightningElement {
    @track objectList = [];
    objectName = '';
    @track lstOfPicklistFields = [];
    @track objectFieldOptionsList = [];
    @track picklistFieldsLabel = '';
    fieldSelectedToGetPicklistTypeField = '';

    connectedCallback() {
        this.loadObjects();
    }

    loadObjects() {
        getAllObjects()
            .then((result) => {
                if (result) {
                    this.objectList = [];
                    for (let key in result) {
                        this.objectList.push({ label: result[key], value: key });
                    }
                } else {
                    console.error('Error in getting object');
                }
            })
            .catch((error) => {
                console.error('Catch error in getting object', error);
            });
    }

    onObjectChange(event) {
        this.objectName = event.detail.value;
        this.picklistFieldsLabel = this.objectName + ' Picklist Fields';
        this.handleGetPicklistFields();
    }

    handleGetPicklistFields() {
        getPicklistTypeFields({ strObjectName: this.objectName })
            .then((result) => {
                this.lstOfPicklistFields = [];
                for (let key in result) {
                    this.lstOfPicklistFields.push({ label: key, value: key });
                }
            })
            .catch((error) => {
                console.error('Error in getting picklist fields', error);
            });
    }

    getPicklistFieldsOptions(event) {
        this.fieldSelectedToGetPicklistTypeField = event.detail.value;
        this.getPicklistValuesForSelectedPicklistField();
    }

    getPicklistValuesForSelectedPicklistField() {
        getPickListvaluesByFieldName({ objectName: this.objectName, pickListFieldName: this.fieldSelectedToGetPicklistTypeField })
            .then((result) => {
                if (result) {
                    this.objectFieldOptionsList = [];
                    for (let key in result) {
                        this.objectFieldOptionsList.push({ label: result[key], value: result[key] });
                    }
                    console.log('Picklist values:', this.objectFieldOptionsList); // Debugging statement
                } else {
                    console.error('No result from getPickListvaluesByFieldName');
                }
            })
            .catch((error) => {
                console.error('Error in getting picklist values', error);
            });
    }
}