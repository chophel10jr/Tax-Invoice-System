import { Controller } from "@hotwired/stimulus";
import { validAmount } from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "amount",
    "amountError",
    "description",
    "submitButton"
  ];

  connect() {
    this.initalAmount = this.amountTarget.value;
    this.initalDescription = this.descriptionTarget.value;
  }

  validateAmount() {
    const isValid = validAmount(this.amountTarget.value) || this.amountTarget.value.trim() === "";
    const message = isValid ? "" : "Invalid Amount";

    this.amountErrorTarget.textContent = message;
    this.submitable()
  }

  validateDescription() {
    this.submitable()
  }

  submitable() {
    const amountChanged = Number(this.initalAmount) !== Number(this.amountTarget.value);
    const descriptionChanged = this.initalDescription.trim() !== this.descriptionTarget.value.trim();
    this.submitButtonTarget.disabled = !(amountChanged || descriptionChanged);
  }
}
