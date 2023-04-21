import { Controller } from "@hotwired/stimulus";
import { createPopper } from "@popperjs/core/dist/esm";

export default class extends Controller {
  static targets = ["template"];

  initialize() {
    this.shownTooltip = null;
  }

  show(event) {
    const popperOptions = {
      placement: "bottom-start",
      modifiers: [
        {
          name: "sameWidth",
          enabled: true,
          fn: ({ state }) => {
            state.styles.popper.width = `${state.rects.reference.offsetWidth}px`;
          },
          effect({ state }) {
            state.elements.popper.style.width = `${state.elements.reference.offsetWidth}px`;
          },
          phase: "beforeWrite",
          requires: ["computeStyles"],
        },
      ],
    };

    const element = event.currentTarget;

    let tooltip = document.createElement("div");
    tooltip.innerHTML = this.templateTarget.innerHTML;

    this.shownTooltip = element.appendChild(tooltip);

    this.popper = createPopper(element, this.shownTooltip, popperOptions);
  }

  hide() {
    this.shownTooltip.remove();
  }
}
