import { Controller } from "@hotwired/stimulus"
import { debounce } from "./utils"

export default class extends Controller {
  connect() {
    this.handleMouseOver = debounce(this.handleMouseOver.bind(this), 50)
    this.handleMouseOut = debounce(this.handleMouseOut.bind(this), 50)

    this.element.addEventListener("mouseover", this.handleMouseOver)
    this.element.addEventListener("mouseout", this.handleMouseOut)
  }

  disconnect() {
    this.element.removeEventListener("mouseover", this.handleMouseOver)
    this.element.removeEventListener("mouseout", this.handleMouseOut)
  }

  handleMouseOver(event) {
    const row = event.target.closest(".Polaris-DataTable--hoverable")
    if (row && row !== this.hoveredRow) {
      this.clearHoveredRow()
      this.hoveredRow = row
      row.querySelectorAll(".Polaris-DataTable__Cell").forEach(cell => {
        cell.classList.add("Polaris-DataTable__Cell--hovered")
      })
    }
  }

  handleMouseOut(event) {
    const row = event.target.closest(".Polaris-DataTable--hoverable")
    if (row && !row.contains(event.relatedTarget)) {
      this.clearHoveredRow()
    }
  }

  clearHoveredRow() {
    if (this.hoveredRow) {
      this.hoveredRow.querySelectorAll(".Polaris-DataTable__Cell").forEach(cell => {
        cell.classList.remove("Polaris-DataTable__Cell--hovered")
      })
      this.hoveredRow = null
    }
  }
}
