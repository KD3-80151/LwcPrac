import { api, LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

export default class ContactCreation extends LightningElement {
    
    @api recordId;

    @track contact={
        firstName:'',
        lastName: '',
        email: '',
        phone: ''
    }

    handleChange(event){
        const {name , value} = event.target; // array destructuring
        //debugger;
        
        console.log('Name:', name);
        console.log('Value:', value);
        this.contact = {...this.contact, [name]: value } // ...this.contact initial value is null
        console.log('Updated Contact:', this.contact);
    }

    createContact(){
        debugger;
        const fields = {};
        console.log('Creating contact...');

        fields[FIRSTNAME_FIELD.fieldApiName] = this.contact.firstName;
        fields[LASTNAME_FIELD.fieldApiName] = this.contact.lastName;
        fields[EMAIL_FIELD.fieldApiName] = this.contact.email;
        fields[PHONE_FIELD.fieldApiName] = this.contact.phone;
        fields['AccountId'] = this.recordId;

        const input = {apiName: CONTACT_OBJECT.objectApiName, fields };
        //constructs the recordInput object with the necessary data (apiName and fields)
        // required for creating a new Contact record using the createRecord function.
        //can access the API name of the Contact object using CONTACT_OBJECT.objectApiName
        console.log('Inputs:::::::::' + input);
        console.log('Fields:::::::::' + fields);
        createRecord(input)
            .then(()=> {
                this.showToast('Success', 'Contact created', 'success');
                this.resetForm();
            })
            .catch(error)
                this.showToast('Error', 'Contact not created', 'error');
            ; 
    }
    
    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }

    resetForm(){
        this.contact = {
            firstName: '',
            lastName: '',
            email: '',
            phone: ''

        }
    }


    


    
}