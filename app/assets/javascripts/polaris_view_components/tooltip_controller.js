import { Controller } from "@hotwired/stimulus";
import { createPopper } from "@popperjs/core/dist/esm";

export default class extends Controller {
  static targets = ["template"];
  static values = { active: Boolean, position: String }

  initialize() {
    this.shownTooltip = null;
  }

  getOffset() {
    switch (this.positionValue) {
      case "top", "bottom":
        return [0, 8]
      case "left", "right":
        return [0, 6]
      default:
        return [0, 8]
    }
  }

  show(event) {
    if (!this.activeValue) return;

    const popperOptions = {
      placement: this.positionValue,
      modifiers: [
        {
          name: 'offset',
          options: {
            offset: this.getOffset(),
          },
        }
      ],
    };

    const element = event.currentTarget;

    let tooltip = document.createElement("div");
    tooltip.className = "Polaris-Tooltip"
    tooltip.innerHTML = this.templateTarget.innerHTML;

    this.shownTooltip = element.appendChild(tooltip);

    this.popper = createPopper(element, this.shownTooltip, popperOptions);
  }

  hide() {
    if (this.shownTooltip) {
      this.shownTooltip.remove();
    }
  }
}
