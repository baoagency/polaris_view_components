import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  openModal() {
    this.findElement("modal").open()
  }

  closeModal() {
    this.findElement("modal").close()
  }

  disableButton() {
    this.findElement("button").disable()
  }

  disableButtonWithoutLoader() {
    this.findElement("button").disableWithoutLoader()
  }

  enableButton() {
    this.findElement("button").enable()
  }

  showToast() {
    this.findElement("toast").show()
  }

  toggleCollapsible() {
    this.findElement("collapsible").toggle()
  }

  // Private

  findElement(type) {
    const targetId = this.element.dataset.target.replace("#", "")
    const target = document.getElementById(targetId)
    const controllerName = `polaris-${type}`
    return this.application.getControllerForElementAndIdentifier(target, controllerName)
  }
}
