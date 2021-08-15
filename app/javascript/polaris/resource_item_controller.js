import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['link']

  open(event) {
    if (this.hasLinkTarget && this.targetIsNotLink(event.target)) {
      this.linkTarget.click()
    }
  }

  targetIsNotLink(element) {
    return !element.closest('a') && !element.closest('button')
  }
}
