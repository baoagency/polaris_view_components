import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row"]

  connect() {
    this.rowTargets.forEach(row => {
      row.addEventListener("mouseover", () => this.handleHover(row))
      row.addEventListener("mouseout", () => this.handleLeave(row))
    })
  }

  disconnect() {
    this.rowTargets.forEach(row => {
      row.removeEventListener("mouseover", () => this.handleHover(row))
      row.removeEventListener("mouseout", () => this.handleLeave(row))
    })
  }

  handleHover(row) {
    const cells = row.querySelectorAll(".Polaris-DataTable__Cell")
    cells.forEach(cell => {
      cell.classList.add("Polaris-DataTable__Cell--hovered")
    })
  }

  handleLeave(row) {
    const cells = row.querySelectorAll(".Polaris-DataTable__Cell")
    cells.forEach(cell => {
      cell.classList.remove("Polaris-DataTable__Cell--hovered")
    })
  }
}
