import { Controller } from "@hotwired/stimulus";
import { validTransactionReferenceNumber } from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "container",
    "addTransactionButton",
    "submitButton",
    "transactionReferenceNumber"
  ];

  connect() {
    this.transactionCount = 1;
    this.maxTransaction = 5;
    this.updateRemoveButtons();
  }

  validateTransactionReferenceNumber(event) {
    const input = event.target;
    const isValid = validTransactionReferenceNumber(input.value.trim());

    input.classList.toggle("input-error", !isValid);
    this.validateAllTransactions();
  }

  validateAllTransactions() {
    const allValid = this.transactionReferenceNumberTargets.every((input) => {
      const value = input.value.trim();
      return validTransactionReferenceNumber(value);
    });

    this.submitButtonTarget.disabled = !allValid;
  }

  updateRemoveButtons() {
    const removeButtons =
      this.containerTarget.querySelectorAll(".remove-transaction");
    removeButtons.forEach((button) => {
      button.style.display = this.transactionCount === 1 ? "none" : "inline-block";
    });
  }

  addTransaction() {
    if (this.transactionCount < this.maxTransaction) {
      this.transactionCount++;

      const original = this.containerTarget.querySelector(".transaction-form");
      const clone = original.cloneNode(true);

      // Clear input fields in the cloned form
      const inputs = clone.querySelectorAll("input, select");
      inputs.forEach((input) => {
        input.value = input.getAttribute("type") === "number" ? 0 : "";
        input.classList.remove("input-error");
      });

      this.containerTarget.appendChild(clone);
      this.updateRemoveButtons();
      this.validateAllTransactions();

      if (this.transactionCount === this.maxTransaction) {
        this.addTransactionButtonTarget.disabled = true;
      }
    }
  }

  removeTransaction(event) {
    if (event.target.classList.contains("remove-transaction")) {
      const transactionForm = event.target.closest(".transaction-form");
      transactionForm.remove();
      this.transactionCount--;

      this.updateRemoveButtons();
      this.validateAllTransactions();

      if (this.transactionCount < this.maxTransaction) {
        this.addTransactionButtonTarget.disabled = false;
      }
    }
  }
}
