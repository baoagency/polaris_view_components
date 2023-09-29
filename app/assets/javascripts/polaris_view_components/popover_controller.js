import { Controller } from "@hotwired/stimulus"
import { computePosition, autoUpdate, offset, flip, shift } from "@floating-ui/dom"

export default class extends Controller {
  static targets = ["activator", "popover", "template"]
  static classes = ["open", "closed"]
  static values = {
    appendToBody: Boolean,
    placement: String,
    active: Boolean,
    textFieldActivator: Boolean
  }

  connect() {
    if (this.appendToBodyValue) {
      const clonedTemplate = this.templateTarget.content.cloneNode(true)
      this.target = clonedTemplate.firstElementChild
      document.body.appendChild(clonedTemplate)
    }

    this.target.style.display = 'none'

    if (this.activeValue) {
      this.show()
    }
  }

  disconnect() {
    if (this.cleanup) {
      this.cleanup()
    }
  }

  updatePosition() {
    if (this.cleanup) {
      this.cleanup()
    }
    this.cleanup = autoUpdate(this.activator, this.target, () => {
      computePosition(this.activator, this.target, {
        placement: this.placementValue,
        middleware: [
          offset(5),
          flip(),
          shift({ padding: 5 })
        ]
      }).then(({x, y}) => {
        Object.assign(this.target.style, {
          left: `${x}px`,
          top: `${y}px`,
        })
      })
    })
  }

  toggle() {
    if (this.target.classList.contains(this.openClass)) {
      this.forceHide()
    } else {
      this.show()
    }
  }

  show() {
    this.target.style.display = 'block'
    this.target.classList.remove(this.closedClass)
    this.target.classList.add(this.openClass)
    this.updatePosition()
  }

  hide(event) {
    if (this.element.contains(event.target)) return
    if (this.target.classList.contains(this.closedClass)) return
    if (this.appendToBodyValue && this.target.contains(event.target)) return

    this.forceHide()
  }

  forceHide() {
    this.target.style.display = 'none'
    this.target.classList.remove(this.openClass)
    this.target.classList.add(this.closedClass)
  }

  get activator() {
    if (this.textFieldActivatorValue) {
      return this.activatorTarget.querySelector('[data-controller="polaris-text-field"]')
    } else {
      return this.activatorTarget
    }
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
