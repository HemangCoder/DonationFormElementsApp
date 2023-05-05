import { LightningElement ,api} from 'lwc';

export default class DonateButton extends LightningElement {
  @api donateButtonVariant;
  @api donateButtonLabel;
  @api donateButtonIconName ;

  handleClick() {
    this.dispatchEvent(new CustomEvent('submit'));
    
  }
}