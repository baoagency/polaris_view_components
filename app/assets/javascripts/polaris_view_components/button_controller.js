import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { disabled: Boolean }

  disable(event) {
    if (this.disabledValue) {
      if (event) event.preventDefault()
    } else {
      this.disabledValue = true
      this.button.classList.add("Polaris-Button--disabled", "Polaris-Button--loading")
      this.button.insertAdjacentHTML("afterbegin", this.spinnerHTML)
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
      <span class="Polaris-Button__Spinner" role="status" aria-label="Loading">
        <svg viewBox="0 0 44 44" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
          <circle class="Polaris-Button__SpinnerTrack" r="14" stroke-width="3" cx="22" cy="22"></circle>
          <circle class="Polaris-Button__SpinnerIndicator" pathLength="10" r="14" stroke-width="3" cx="22" cy="22"></circle>
        </svg>
      </span>
    `
  }
}
