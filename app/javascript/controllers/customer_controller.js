import { Controller } from "@hotwired/stimulus";
import {
  validMandatory,
  validCID,
  validPhone,
  validEmail
} from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "name", "nameError",
    "cid", "cidError",
    "email", "emailError",
    "phone", "phoneError",
    "address", "addressError",
    "submitButton"
  ];

  connect() {
    this.initialValues = {
      name: this.nameTarget.value.trim(),
      cid: this.cidTarget.value.trim(),
      email: this.emailTarget.value.trim(),
      phone: this.phoneTarget.value.trim(),
      address: this.addressTarget.value.trim()
    };
  }

  validateName() {
    this.validateField(
      this.nameTarget,
      this.nameErrorTarget,
      validMandatory,
      "Invalid Name"
    );
  }

  validateCID() {
    this.validateOptionalField(
      this.cidTarget,
      this.cidErrorTarget,
      validCID,
      "Invalid CID"
    );
  }

  validateEmail() {
    this.validateOptionalField(
      this.emailTarget,
      this.emailErrorTarget,
      validEmail,
      "Invalid Email"
    );
  }

  validatePhone() {
    this.validateOptionalField(
      this.phoneTarget,
      this.phoneErrorTarget,
      validPhone,
      "Invalid Phone"
    );
  }

  validateAddress() {
    this.validateField(
      this.addressTarget,
      this.addressErrorTarget,
      validMandatory,
      "Invalid Address"
    );
  }

  validateField(field, errorTarget, validator, message) {
    const isValid = validator(field.value);
    errorTarget.textContent = isValid ? "" : message;
    this.updateSubmitState();
  }

  validateOptionalField(field, errorTarget, validator, message) {
    const value = field.value.trim();
    const isValid = value === "" || validator(value);
    errorTarget.textContent = isValid ? "" : message;
    this.updateSubmitState();
  }

  updateSubmitState() {
    this.submitButtonTarget.disabled = !(
      this.hasDataChanged() && this.isDataValid()
    );
  }

  hasDataChanged() {
    return Object.keys(this.initialValues).some(key => {
      return this.initialValues[key] !== this[`${key}Target`].value.trim();
    });
  }

  isDataValid() {
    return (
      validMandatory(this.nameTarget.value) &&
      (this.cidTarget.value.trim() === "" || validCID(this.cidTarget.value)) &&
      (this.emailTarget.value.trim() === "" || validEmail(this.emailTarget.value)) &&
      (this.phoneTarget.value.trim() === "" || validPhone(this.phoneTarget.value)) &&
      validMandatory(this.addressTarget.value)
    );
  }
}
