import { Controller } from 'stimulus'

// eslint-disable-next-line import/no-default-export
export default class extends Controller {
  handleCloseClick () {
    this.isInStack
      ? this.stackItem.remove()
      : this.element.remove()
  }

  get isInStack () {
    if (!this.stackItem) return false

    return [...this.stackItem.childNodes]
      .some(el => el === this.element)
  }

  get stackItem () {
    return this.element.closest('.Polaris-Stack__Item')
  }
}
