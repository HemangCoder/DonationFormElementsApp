import { LightningElement, track } from 'lwc';
import submitDonation from '@salesforce/apex/DonationController.submitDonation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DonationForm extends LightningElement {
  @track donationType = 'Monthly';
  @track donateButtonIconName = 'action:update';
  @track donateButtonLabel = 'Donate';
  @track donateButtonVariant = 'brand';
  @track isDonateButtonDisabled = 'false';
  @track donationAmount;
  @track contactDetails;
  @track paymentDetails;
  @track includeTransactionFee = false;

  handleDonationTypeChange(event) {
    this.donationType = event.detail;
  }

  handleDonationAmountChange(event) {
    this.donationAmount = event.detail;
  }

  handleContactDetailsChange(event) {
    this.contactDetails = event.detail;
  }

  handlePaymentDetailsChange(event) {
    this.paymentDetails = event.detail;
  }

  handleReset(event)
  {
    this.template.querySelector('c-contact-details').resetContactDetails();
    this.template.querySelector('c-donation-amount-selector').resetAmountDetails();
    this.contactDetails.clear();
    this.donationAmount = undefined;
  }

  async handleSubmit(event) {
    // Gather data from child components
    const donationData = {
      donationType: this.donationType,
      donationAmount: this.donationAmount,
      contactDetails: this.contactDetails,
      paymentDetails: this.paymentDetails,
      includeTransactionFee: this.includeTransactionFee
    };

    // Call the submitDonation Apex method
    try {
      await submitDonation({ donationData: JSON.stringify(donationData) })
        .then((result) => {
          this.donateButtonIconName= 'action:check';
          if(this.donationAmount != undefined)
          {
            this.donateButtonLabel = '$ ' + this.donationAmount + ' Donated';
          }else{
            this.donateButtonLabel = ' Donated';
          }
          
           this.donateButtonVariant = 'Success';
          window.open(result);

        })
        .catch(error => {
          this.donateButtonIconName = 'action:update';
          this.donateButtonLabel = 'Donate';
          this.donateButtonVariant = 'brand';
          console.log(JSON.stringify(error));
          this.dispatchEvent(
            new ShowToastEvent({
              title: 'Error',
              message: 'Error on Processing Payment',
              variant: 'error',
              mode: 'dismissable'
            })      
          );
        });
      this.dispatchEvent(new CustomEvent('success'));
    } catch (error) {
      this.dispatchEvent(new CustomEvent('error', { detail: error }));
    }
  }
};