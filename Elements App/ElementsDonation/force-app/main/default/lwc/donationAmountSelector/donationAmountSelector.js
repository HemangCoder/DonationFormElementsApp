import { LightningElement, api, track } from 'lwc';

export default class DonationAmountSelector extends LightningElement {
  @api donationType;
  @track previousDonationType;
  @track selectedAmount;
  @track otherAmount;
     
  get amountOptions() {
    let options;
    switch (this.donationType) {
      case 'Monthly':
        options = [10, 20, 30, 40, 50];
        break;
      case 'One-Time':
        options = [25, 50, 75, 100, 500];
        break;
      case 'Annually':
        options = [100, 200, 300, 400, 500];
        break;

    }
    return options.map(option => ({ label: `$${option}`, value: option, variant:"success" }));
  
  }

  handleAmountChange(event) {
    this.selectedAmount = event.target.value;
    this.dispatchEvent(new CustomEvent('amountchange', { detail: this.selectedAmount }));
  }

  handleOtherAmountChange(event) {
    this.otherAmount = Number(event.detail.value);   
    this.dispatchEvent(new CustomEvent('amountchange', { detail: this.otherAmount }));
  }

  //To reset amount details
  @api resetAmountDetails() {
    this.template.querySelectorAll('lightning-input').forEach(each => { each.value = ''; });
    this.selectedAmount = ' ';
    this.otherAmount = undefined;
  }
}