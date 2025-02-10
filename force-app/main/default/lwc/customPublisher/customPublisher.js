import { LightningElement, track } from 'lwc';

export default class CustomPublisher extends LightningElement {
    @track commentText;
    @track showComment;
    @track msg;
}