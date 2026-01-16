import { Controller } from "@hotwired/stimulus";
import { validAmount } from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "amount",
    "amountError",
    "submitButton"
  ];

  connect() {
    this.initalAmount = this.amountTarget.value;
  }

  validateAmount() {
    const isValid = validAmount(this.amountTarget.value);
    const message = isValid ? "" : "Invalid Amount";

    this.amountErrorTarget.textContent = message;
    this.submitable()
  }

  submitable() {
    const amountChanged = Number(this.initalAmount) !== Number(this.amountTarget.value);
    this.submitButtonTarget.disabled = !amountChanged;
  }
}
