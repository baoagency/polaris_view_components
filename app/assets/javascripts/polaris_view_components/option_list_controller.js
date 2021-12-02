import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radioButton"]
  static classes = ["selected"]

  connect() {
    this.updateSelected()
  }

  // Actions

  update() {
    this.updateSelected()
  }

  // Private

  updateSelected() {
    this.radioButtonTargets.forEach(element => {
      const input = element.querySelector("input[type=radio]")
      if (input.checked) {
        element.classList.add(this.selectedClass)
      } else {
        element.classList.remove(this.selectedClass)
      }
    })
  }
}
