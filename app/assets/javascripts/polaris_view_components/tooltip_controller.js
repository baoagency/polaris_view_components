import { Controller } from "@hotwired/stimulus"
import { computePosition, autoUpdate, offset, flip, shift, arrow } from "@floating-ui/dom"

export default class extends Controller {
  static targets = ["template"]
  static values = { active: Boolean, position: String }

  show(event) {
    if (!this.activeValue) return;

    const element = event.currentTarget;

    let tooltip = document.createElement("span");
    tooltip.className = "Polaris-Tooltip"
    tooltip.innerHTML = this.templateTarget.innerHTML;
    this.tooltip = element.appendChild(tooltip);

    const arrowElement = element.querySelector("[data-tooltip-arrow]");

    computePosition(element, this.tooltip, {
      placement: this.positionValue,
      middleware: [
        offset(this.offsetValue),
        flip(),
        shift({ padding: 5 }),
        arrow({ element: arrowElement })
      ]
    }).then(({x, y, placement, middlewareData}) => {
      Object.assign(this.tooltip.style, {
        left: `${x}px`,
        top: `${y}px`,
      })

      const {x: arrowX, y: arrowY} = middlewareData.arrow;

      const staticSide = {
        top: 'bottom',
        right: 'left',
        bottom: 'top',
        left: 'right',
      }[placement.split('-')[0]];

      Object.assign(arrowElement.style, {
        left: arrowX != null ? `${arrowX}px` : '',
        top: arrowY != null ? `${arrowY}px` : '',
        right: '',
        bottom: '',
        [staticSide]: '-4px',
      });
    })
  }

  hide() {
    if (this.tooltip) {
      this.tooltip.remove();
    }
  }

  get offsetValue() {
    switch (this.positionValue) {
      case "top": case "bottom": case "left":
        return 8
      case "right":
        return 6
    }
  }
}
