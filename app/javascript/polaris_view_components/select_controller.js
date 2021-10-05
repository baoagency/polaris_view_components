import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['selectedOption']

  update(event) {
    const select = event.currentTarget
    const option = select.options[select.selectedIndex]

    this.selectedOptionTarget.innerText = option.text
  }
}
