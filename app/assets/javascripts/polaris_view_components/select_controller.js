import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "selectedOption"]

  connect() {
    this.update()
  }

  update() {
    const option = this.selectTarget.options[this.selectTarget.selectedIndex]
    this.selectedOptionTarget.innerText = option.text
  }

  clearErrorMessages() {
    const polarisSelect = this.selectTarget.closest(".Polaris-Select")
    const wrapper = polarisSelect.parentElement
    const inlineError = wrapper.querySelector(".Polaris-InlineError")

    if (polarisSelect) {
      polarisSelect.classList.remove("Polaris-Select--error")
    }
    if (inlineError) {
      inlineError.remove()
    }
  }
}
