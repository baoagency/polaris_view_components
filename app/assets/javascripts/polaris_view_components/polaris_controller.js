import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  openModal() {
    const targetId = this.element.dataset.target.replace("#", "")
    const target = document.getElementById(targetId)
    const modal = this.application.getControllerForElementAndIdentifier(target, "polaris-modal")
    modal.open()
  }
}
