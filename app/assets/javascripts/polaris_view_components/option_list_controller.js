import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["radioButton"]
  static classes = ["selected"]

  connect() {
    this.updateSelected()
  }

  // Actions

  update(event) {
    const target = event.currentTarget
    target.classList.add(this.selectedClass)
    this.deselectAll(target)
  }

  // Private

  updateSelected() {
    this.radioButtonTargets.forEach(element => {
      const input = element.querySelector('input[type=radio]')
      if (input.checked) {
        element.classList.add(this.selectedClass)
      } else {
        element.classList.remove(this.selectedClass)
      }
    })
  }

  deselectAll(target) {
    this.radioButtonTargets.forEach(element => {
      if (!element.isEqualNode(target)) {
        const input = element.querySelector('input[type=radio]')
        input.checked = false
        element.classList.remove(this.selectedClass)
      }
    })
  }
}
