import { LightningElement, track, api } from 'lwc';

export default class ContactDetails extends LightningElement {
  @track firstName;
  @track lastName;
  @track email;
  @track phone;
  @track address;

  handleFirstNameChange(event) {
    this.firstName = event.detail.value;
    this.dispatchContactChangeEvent();
  }

  handleLastNameChange(event) {
    this.lastName = event.detail.value;
    this.dispatchContactChangeEvent();
  }

  handleEmailChange(event) {
    this.email = event.detail.value;
    this.dispatchContactChangeEvent();
  }

  handlePhoneChange(event) {
    this.phone = event.detail.value;
    this.dispatchContactChangeEvent();
  }

  handleAddressChange(event) {
    this.address = event.detail.value;
    this.dispatchContactChangeEvent();
  }

  dispatchContactChangeEvent() {
    this.dispatchEvent(
      new CustomEvent('contactchange', {
        detail: {
          firstName: this.firstName,
          lastName: this.lastName,
          email: this.email,
          phone: this.phone,
          address: this.address
        }
      })
    );
  }

  handleInputFocus(event) 
  {
    // modify parent to properly highlight visually
    const classList = event.target.parentNode.classList;
    classList.add('lgc-highlight');
  }

  handleInputBlur(event) 
  {
    // modify parent to properly remove highlight
    const classList = event.target.parentNode.classList;
    classList.remove('lgc-highlight');
  }

  //To reset contact details
  @api resetContactDetails() {
    this.template.querySelectorAll('lightning-input').forEach(each => { each.value = ''; });
    this.firstName = ' ';
    this.lastName = undefined;
    this.email = undefined;
    this.phone = undefined;
    this.address = undefined;
  }
}