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
}
