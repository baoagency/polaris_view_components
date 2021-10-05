import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['link']

  open(event) {
    if (this.hasLinkTarget && this.targetNotClickable(event.target)) {
      this.linkTarget.click()
    }
  }

  targetNotClickable(element) {
    return !element.closest('a') && !element.closest('button') && element.nodeName !== "INPUT"
  }
}
