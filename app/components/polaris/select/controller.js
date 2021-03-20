import { Controller } from 'stimulus'

// eslint-disable-next-line import/no-default-export
export default class extends Controller {
  static targets = ['currentLabel']

  onChange (e) {
    this.currentLabelTargets.forEach(el => (
      el.textContent = e.target.options[e.target.selectedIndex].label),
    )
  }
}
