import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  openModal() {
    this.findElement("modal").open()
  }

  disableButton() {
    this.findElement("button").disable()
  }

  enableButton() {
    this.findElement("button").enable()
  }

  // Private

  findElement(type) {
    const targetId = this.element.dataset.target.replace("#", "")
    const target = document.getElementById(targetId)
    const controllerName = `polaris-${type}`
    return this.application.getControllerForElementAndIdentifier(target, controllerName)
  }
}
