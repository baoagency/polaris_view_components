import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    if (this.isClosed) {
      this.element.style.maxHeight = "none"
      this.element.style.overflow = "visible"
      this.element.classList.remove("Polaris-Collapsible--isFullyClosed")
    } else {
      this.element.style.maxHeight = "0px"
      this.element.style.overflow = "hidden"
      this.element.classList.add("Polaris-Collapsible--isFullyClosed")
    }
  }

  get isClosed() {
    return this.element.classList.contains("Polaris-Collapsible--isFullyClosed")
  }
}
