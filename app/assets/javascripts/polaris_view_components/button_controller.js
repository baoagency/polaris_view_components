import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { disabled: Boolean }

  disable(event) {
    if (this.disabledValue) {
      if (event) event.preventDefault()
    } else {
      this.disabledValue = true
      this.button.classList.add("Polaris-Button--disabled", "Polaris-Button--loading")
      this.buttonContent.insertAdjacentHTML("afterbegin", this.spinnerHTML)
    }
  }

  disableWithoutLoader(event) {
    if (this.disabledValue) {
      if (event) event.preventDefault()
    } else {
      this.disabledValue = true
      this.button.classList.add("Polaris-Button--disabled")
    }
  }

  enable() {
    if (this.disabledValue) {
      this.disabledValue = false
      this.button.classList.remove("Polaris-Button--disabled", "Polaris-Button--loading")
      if (this.spinner) this.spinner.remove()
    }
  }

  // Private

  get button() {
    return this.element
  }

  get buttonContent() {
    return this.button.querySelector(".Polaris-Button__Content")
  }

  get spinner() {
    return this.button.querySelector(".Polaris-Button__Spinner")
  }

  get spinnerHTML() {
    return `
      <span class="Polaris-Button__Spinner">
        <span class="Polaris-Spinner Polaris-Spinner--sizeSmall">
          <svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
            <path d="M7.229 1.173a9.25 9.25 0 1011.655 11.412 1.25 1.25 0 10-2.4-.698 6.75 6.75 0 11-8.506-8.329 1.25 1.25 0 10-.75-2.385z"></path>
          </svg>
        </span>
      </span>
    `
  }
}
