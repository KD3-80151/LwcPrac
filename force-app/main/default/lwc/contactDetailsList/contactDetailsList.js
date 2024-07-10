import { LightningElement, track } from 'lwc';
import getContact from '@salesforce/apex/ContactDetailsList.getContacts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactDetailsList extends LightningElement {
    @track contacts;
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' },
        { label: ' Update Account Name', fieldName: 'AccountId'}
    ];


    handleSearch(event) {
        const searchKey = event.target.value;
        if (searchKey) {
            debugger;
            console.log(searchKey);
            
            getContact({ searchKey })
                .then(result => {
                    this.contacts = result;
                    console.log(searchKey);
                    console.log(result);
                    if (result.length === 0) {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'No Contacts Found',
                                message: 'No contacts found ',
                                variant: 'info'
                            })
                        );
                    }
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error'
                        })
                    );
                });
        } else {
            this.contacts = [];
        }
    }
}

