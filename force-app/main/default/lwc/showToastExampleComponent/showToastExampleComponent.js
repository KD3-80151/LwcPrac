import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ShowToastExampleComponent extends LightningElement {
    @api toastTitle;
    @api toastMessage;

    @api invoke(){
        this.dispatchEvent(
            new ShowToastEvent({
                title: this.toastTitle,
                message: this.toastMessage,
                variant: 'success'
            }),
        );
    }
}