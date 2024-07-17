import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    handleCLick(){
        this.template.querySelector("c-child-component").handleChangeValue();
    }
}