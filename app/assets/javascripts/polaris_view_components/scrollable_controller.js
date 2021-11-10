import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["topEdge", "bottomEdge"]
  static classes = ["topShadow", "bottomShadow"]
  static values = {
    shadow: Boolean,
  }

  initialize() {
    this.topEdgeReached = false
    this.bottomEdgeReached = true
  }

  connect() {
    if (this.shadowValue) {
      this.observer = new IntersectionObserver(this.handleIntersection)
      this.observer.observe(this.topEdgeTarget)
      this.observer.observe(this.bottomEdgeTarget)
    }
  }

  disconnect() {
    if (this.shadowValue) {
      this.observer.disconnect()
    }
  }

  // Private

  handleIntersection = (entries) => {
    entries.forEach(entry => {
      const target = entry.target.dataset.polarisScrollableTarget

      switch (target) {
        case "topEdge":
          this.topEdgeReached = entry.isIntersecting
          break
        case "bottomEdge":
          this.bottomEdgeReached = entry.isIntersecting
          break
      }
    })
    this.updateShadows()
  }

  updateShadows() {
    if (!this.topEdgeReached && !this.bottomEdgeReached) {
      this.element.classList.add(this.topShadowClass, this.bottomShadowClass)
    } else if (this.topEdgeReached && this.bottomEdgeReached) {
      this.element.classList.remove(this.topShadowClass, this.bottomShadowClass)
    } else if (this.topEdgeReached) {
      this.element.classList.remove(this.topShadowClass)
      this.element.classList.add(this.bottomShadowClass)
    } else if (this.bottomEdgeReached) {
      this.element.classList.add(this.topShadowClass)
      this.element.classList.remove(this.bottomShadowClass)
    }
  }
}
