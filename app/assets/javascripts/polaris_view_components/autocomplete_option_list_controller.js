import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { selectEventRef: String }

  select(event) {
    const input = event.target

    const selectedEvent = new CustomEvent(this.selectEventRefValue, {
      bubbles: true,
      detail: {
        input: input,
        label: input.closest('li').dataset.label,
        value: input.value,
        selected: input.checked
      }
    });

    document.dispatchEvent(selectedEvent);
  }
}
