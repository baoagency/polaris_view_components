import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static activeClass = 'Polaris-Frame-ToastManager--toastWrapperEnterDone'
  static defaultDuration = 5000
  static defaultDurationWithAction = 10000
  static values = { hidden: Boolean,  duration: Number, hasAction: Boolean }

  connect() {
    if (!this.hiddenValue) {
      this.show()
    }
  }

  show = () => {
    this.element.dataset.position = this.position
    this.element.style.cssText = this.getStyle(this.position)
    this.element.classList.add(this.constructor.activeClass)
    setTimeout(this.close, this.timeoutDuration)
  }

  close = () => {
    this.element.classList.remove(this.constructor.activeClass)
    this.element.addEventListener('transitionend', this.updatePositions, false)
  }

  updatePositions = () => {
    this.visibleToasts
      .sort((a, b) => parseInt(a.dataset.position) - parseInt(b.dataset.position))
      .forEach((toast, index) => {
        const position = index + 1
        toast.dataset.position = position
        toast.style.cssText = this.getStyle(position)
      })

    this.element.removeEventListener('transitionend', this.updatePositions, false)
  }

  getStyle(position) {
    const height = this.element.offsetHeight + this.heightOffset
    const translateIn = height * -1
    const translateOut = 150 - height

    return `--pc-toast-manager-translate-y-in: ${translateIn}px; --pc-toast-manager-translate-y-out: ${translateOut}px;`
  }

  get timeoutDuration() {
    if (this.durationValue > 0) {
      return this.durationValue
    } else if (this.hasActionValue) {
      return this.constructor.defaultDurationWithAction
    } else {
      return this.constructor.defaultDuration
    }
  }

  get toastManager() {
    return this.element.closest('.Polaris-Frame-ToastManager')
  }

  get visibleToasts() {
    return [
      ...this.toastManager.querySelectorAll(`.${this.constructor.activeClass}`)
    ]
  }

  get position() {
    return this.visibleToasts.filter(el => !this.element.isEqualNode(el)).length + 1
  }

  get heightOffset() {
    return this.visibleToasts
      .filter(el => {
        return !this.element.isEqualNode(el) && this.element.dataset.position > el.dataset.position
      })
      .map(el => el.offsetHeight)
      .reduce((a, b) => a + b, 0)
  }
}
