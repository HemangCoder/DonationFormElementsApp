import { LightningElement ,api} from 'lwc';

export default class ResetButton extends LightningElement {
    handleClick() {
        this.dispatchEvent(new CustomEvent('reset'));
      }
}