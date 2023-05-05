import { LightningElement, track } from 'lwc';

export default class DonationTypeSelector extends LightningElement {
  @track selectedValue = 'Monthly';

  get options() {
    return [
      { label: 'Monthly', value: 'Monthly' },
      { label: 'One-Time', value: 'One-Time' },
      { label: 'Annually', value: 'Annually' }
    ];
  }

  handleChange(event) {
    this.selectedValue = event.detail.value;
    this.dispatchEvent(new CustomEvent('typechange', { detail: this.selectedValue }));
  }
}