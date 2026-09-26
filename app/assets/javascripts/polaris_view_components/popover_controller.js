import { Controller } from "@hotwired/stimulus";
import {
  computePosition,
  autoUpdate,
  offset,
  flip,
  shift,
} from "@floating-ui/dom";

export default class extends Controller {
  static targets = ["activator", "popover", "template"];
  static classes = ["open", "closed"];
  static values = {
    appendToBody: Boolean,
    placement: String,
    active: Boolean,
    textFieldActivator: Boolean,
  };

  connect() {
    // Popovers appended to the body are created on first open, so long lists don't add a popover per row up front.
    if (!this.appendToBodyValue) {
      this.target.style.display = "none";
    }

    if (this.activeValue) {
      this.show();
    }
  }

  ensureTarget() {
    if (this.appendToBodyValue && !this._target) {
      const clonedTemplate = this.templateTarget.content.cloneNode(true);
      this.target = clonedTemplate.firstElementChild;
      this.target.style.display = "none";
      document.body.appendChild(clonedTemplate);
    }

    return this.target;
  }

  disconnect() {
    if (this.cleanup) {
      this.cleanup();
    }
    if (this.target && this.appendToBodyValue) {
      this.target.remove();
    }
    this._target = null;
  }
  updatePosition() {
    if (this.cleanup) {
      this.cleanup();
    }
    this.cleanup = autoUpdate(this.activator, this.target, () => {
      computePosition(this.activator, this.target, {
        placement: this.placementValue,
        middleware: [
          offset(5),
          // Only flip to opposite side if there's not enough space
          flip({
            fallbackPlacements: [this.placementValue],
            fallbackStrategy: "bestFit",
          }),
          shift({ padding: 5 }),
        ],
      }).then(({ x, y }) => {
        Object.assign(this.target.style, {
          left: `${x}px`,
          top: `${y}px`,
        });
      });
    });
  }

  toggle() {
    this.ensureTarget();

    if (this.target.classList.contains(this.openClass)) {
      this.forceHide();
    } else {
      this.show();
    }
  }

  show() {
    this.ensureTarget();
    this.target.style.display = "block";
    this.target.classList.remove(this.closedClass);
    this.target.classList.add(this.openClass);
    this.updatePosition();
  }

  hide(event) {
    if (!this.target) return;
    if (this.element.contains(event.target)) return;
    if (this.target.classList.contains(this.closedClass)) return;
    if (this.appendToBodyValue && this.target.contains(event.target)) return;

    this.forceHide();
  }

  forceHide() {
    if (!this.target) return;

    this.target.style.display = "none";
    this.target.classList.remove(this.openClass);
    this.target.classList.add(this.closedClass);
  }

  get activator() {
    if (this.textFieldActivatorValue) {
      return this.activatorTarget.querySelector(
        '[data-controller="polaris-text-field"]'
      );
    } else {
      return this.activatorTarget;
    }
  }

  get target() {
    if (this.hasPopoverTarget) {
      return this.popoverTarget;
    } else {
      return this._target;
    }
  }

  set target(value) {
    this._target = value;
  }
}
