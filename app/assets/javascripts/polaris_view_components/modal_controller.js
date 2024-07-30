import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["hidden", "backdrop"]
  static values = {
    open: Boolean
  }

  connect() {
    if (this.openValue) {
      this.open()
    }
  }

  open() {
    this.element.classList.remove(this.hiddenClass)
    const dropElement = `<div class="${this.backdropClass}" data-controller="polaris" data-target="#${this.element.id}" data-action="click->polaris#closeModal"></div>`
    this.element.insertAdjacentHTML('afterend', dropElement)
    this.backdrop = this.element.nextElementSibling
  }

  close() {
    this.element.classList.add(this.hiddenClass)
    this.backdrop.remove()
  }
}
