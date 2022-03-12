import { Controller } from "@hotwired/stimulus"
import { useTransition } from "./utils"

export default class extends Controller {
  static targets = ["navigationOverlay", "navigation", "saveBar"]

  connect() {
    if (!this.hasNavigationTarget) { return }

    useTransition(this, {
      element: this.navigationTarget,
      enterFrom: "Polaris-Frame__Navigation--enter",
      enterTo: "Polaris-Frame__Navigation--visible Polaris-Frame__Navigation--enterActive",
      leaveActive: "Polaris-Frame__Navigation--exitActive",
      leaveFrom: "Polaris-Frame__Navigation--exit",
      leaveTo: "",
      removeToClasses: false,
      hiddenClass: false,
    })
  }

  // Actions

  openMenu() {
    this.enter()
    this.navigationOverlayTarget.classList.add("Polaris-Backdrop", "Polaris-Backdrop--belowNavigation")
  }

  closeMenu() {
    this.leave()
    this.navigationOverlayTarget.classList.remove("Polaris-Backdrop", "Polaris-Backdrop--belowNavigation")
  }

  showSaveBar() {
    this.saveBarTarget.classList.add("Polaris-Frame-CSSAnimation--endFade")
  }

  hideSaveBar() {
    this.saveBarTarget.classList.remove("Polaris-Frame-CSSAnimation--endFade")
  }
}
