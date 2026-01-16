import { Controller } from "@hotwired/stimulus";
import { 
  validMandatory, validCID, validPhone, validEmail 
} from "services/field-validation_services";

export default class extends Controller {
  static targets = [
    "name",
    "nameError",
    "cid",
    "cidError",
    "email",
    "emailError",
    "phone",
    "phoneError",
    "address",
    "addressError",
    "submitButton"
  ];

  connect() {
    this.initalName = this.nameTarget.value;
    this.initalCID = this.cidTarget.value;
    this.initalEmail = this.emailTarget.value;
    this.initalPhone = this.phoneTarget.value;
    this.initalAddress = this.addressTarget.value;
  }

  validateName() {
    const isValid = validMandatory(this.nameTarget.value);
    const message = isValid ? "" : "Invalid Name";

    this.nameErrorTarget.textContent = message;
    this.submitable()
  }

  validateCID() {
    const isValid = validCID(this.cidTarget.value);
    const message = isValid ? "" : "Invalid CID";

    this.cidErrorTarget.textContent = message;
    this.submitable()
  }

  validateEmail() {
    const isValid = validEmail(this.emailTarget.value);
    const message = isValid ? "" : "Invalid Email";

    this.emailErrorTarget.textContent = message;
    this.submitable()
  }

  validatePhone() {
    const isValid = validPhone(this.phoneTarget.value);
    const message = isValid ? "" : "Invalid Phone";

    this.phoneErrorTarget.textContent = message;
    this.submitable()
  }

  validateAddress() {
    const isValid = validMandatory(this.addressTarget.value);
    const message = isValid ? "" : "Invalid Address";

    this.addressErrorTarget.textContent = message;
    this.submitable()
  }

  submitable() {
    const nameChanged = this.initalAmount !== this.nameTarget.value;
    const cidChanged = this.initalAmount !== this.cidTarget.value;
    const emailChanged = this.initalAmount !== this.emailTarget.value;
    const phoneChanged = this.initalAmount !== this.phoneTarget.value;
    const addressChanged = this.initalAmount !== this.addressTarget.value;

    this.submitButtonTarget.disabled = !(nameChanged || cidChanged || emailChanged || phoneChanged || addressChanged);
  }
}
