import { Controller } from "@hotwired/stimulus"
import { computePosition, autoUpdate, offset, flip, shift, arrow } from "@floating-ui/dom"

export default class extends Controller {
  static targets = ["template"]
  static values = { active: Boolean, position: String }

  show(event) {
    if (!this.activeValue) return;

    const element = event.currentTarget;

    let tooltip = document.createElement("span");
    tooltip.className = "Polaris-Tooltip";
    tooltip.innerHTML = this.templateTarget.innerHTML;
    document.body.appendChild(tooltip); // Append tooltip to body for better positioning control
    this.tooltip = tooltip;

    const arrowElement = this.tooltip.querySelector(".Polaris-Tooltip-Arrow");

    computePosition(element, this.tooltip, {
      placement: this.positionValue,
      middleware: [
        offset(10),
        flip(),
        shift({ padding: 5 }),
        arrow({ element: arrowElement }),
      ],
    }).then(({ x, y, placement, middlewareData }) => {
      Object.assign(this.tooltip.style, {
        left: `${x}px`,
        top: `${y}px`,
      });

      // Reset any previously set styles on the arrow
      Object.assign(arrowElement.style, {
        left: '',
        top: '',
        right: '',
        bottom: '',
      });

      const { x: arrowX, y: arrowY } = middlewareData.arrow || {};
      const primaryPlacement = placement.split('-')[0];

      switch (primaryPlacement) {
        case 'top':
          Object.assign(arrowElement.style, {
            left: arrowX ? `${arrowX}px` : '',
            bottom: '-4px', // Aligns arrow to the bottom edge of the tooltip
          });
          break;
        case 'bottom':
          Object.assign(arrowElement.style, {
            left: arrowX ? `${arrowX}px` : '',
            top: '-4px', // Aligns arrow to the top edge of the tooltip
          });
          break;
        case 'left':
          Object.assign(arrowElement.style, {
            top: arrowY ? `${arrowY}px` : '',
            right: '-4px', // Aligns arrow to the right edge of the tooltip
          });
          break;
        case 'right':
          Object.assign(arrowElement.style, {
            top: arrowY ? `${arrowY}px` : '',
            left: '-4px', // Aligns arrow to the left edge of the tooltip
          });
          break;
      }
    });
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
