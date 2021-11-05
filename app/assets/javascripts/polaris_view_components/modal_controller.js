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
    this.element.insertAdjacentHTML('afterend', `<div class="${this.backdropClass}"></div>`)
    this.backdrop = this.element.nextElementSibling
  }

  close() {
    this.element.classList.add(this.hiddenClass)
    this.backdrop.remove()
  }
}
