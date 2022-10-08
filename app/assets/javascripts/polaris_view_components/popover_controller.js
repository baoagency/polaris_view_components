import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core/dist/esm"

export default class extends Controller {
  static targets = ["activator", "popover", "template"]
  static classes = ["open", "closed"]
  static values = {
    appendToBody: Boolean,
    placement: String,
    active: Boolean
  }

  connect() {
    const popperOptions = {
      placement: this.placementValue,
      modifiers: [
        {
          name: 'offset',
          options: {
            offset: [0, 5],
          },
        },
        {
          name: 'flip',
          options: {
            allowedAutoPlacements: ['top-start', 'bottom-start', 'top-end', 'bottom-end']
          },
        }
      ]
    }

    if (this.appendToBodyValue) {
      const clonedTemplate = this.templateTarget.content.cloneNode(true)
      this.target = clonedTemplate.firstElementChild
      popperOptions['strategy'] = 'fixed'

      document.body.appendChild(clonedTemplate)
    }

    this.popper = createPopper(this.activatorTarget, this.target, popperOptions)
    if (this.activeValue) {
      this.show()
    }
  }

  async toggle() {
    this.target.classList.toggle(this.closedClass)
    this.target.classList.toggle(this.openClass)
    await this.popper.update()
  }

  async show() {
    this.target.classList.remove(this.closedClass)
    this.target.classList.add(this.openClass)
    await this.popper.update()
  }

  hide(event) {
    if (this.element.contains(event.target)) return
    if (this.target.classList.contains(this.closedClass)) return
    if (this.appendToBodyValue && this.target.contains(event.target)) return

    this.forceHide()
  }

  forceHide() {
    this.target.classList.remove(this.openClass)
    this.target.classList.add(this.closedClass)
  }

  get target() {
    if (this.hasPopoverTarget) {
      return this.popoverTarget
    } else {
      return this._target
    }
  }

  set target(value) {
    this._target = value
  }
}
