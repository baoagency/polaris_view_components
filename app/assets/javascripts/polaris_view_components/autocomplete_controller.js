import { Controller } from '@hotwired/stimulus'
import { get } from '@rails/request.js'
import { debounce } from './utils'

export default class extends Controller {
  static targets = ['popover', 'input', 'results', 'option', 'emptyState']
  static values = { url: String }

  connect() {
    this.inputTarget.addEventListener("input", this.onInputChange)
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.onInputChange)
  }

  // Actions

  toggle() {
    if (this.visibleOptions.length > 0) {
      this.hideEmptyState()
      this.popoverController.show()
    } else if (this.value.length > 0 && this.hasEmptyStateTarget) {
      this.showEmptyState()
    } else {
      this.popoverController.forceHide()
    }
  }

  select(event) {
    const input = event.currentTarget
    const label = input.closest('li').dataset.label
    const changeEvent = new CustomEvent('polaris-autocomplete:change', {
      detail: { value: input.value, label, selected: input.checked }
    })

    this.element.dispatchEvent(changeEvent)
  }

  onInputChange = debounce(() => {
    if (this.isRemote) {
      this.fetchResults()
    } else {
      this.filterOptions()
    }
  }, 200)


  // Private

  get isRemote() {
    return this.urlValue.length > 0
  }

  get popoverController() {
    return this.application.getControllerForElementAndIdentifier(this.popoverTarget, 'polaris-popover')
  }

  get value() {
    return this.inputTarget.value
  }

  get visibleOptions() {
    return this.optionTargets.filter(option => {
      return !option.classList.contains('Polaris--hidden')
    })
  }

  filterOptions() {
    if (this.value === '') {
      this.optionTargets.forEach(option => {
        option.classList.remove('Polaris--hidden')
      })
    } else {
      const filterRegex = new RegExp(this.value, 'i')
      this.optionTargets.forEach(option => {
        if (option.dataset.label.match(filterRegex)) {
          option.classList.remove('Polaris--hidden')
        } else {
          option.classList.add('Polaris--hidden')
        }
      })
    }
    this.toggle()
  }

  async fetchResults() {
    const response = await get(this.urlValue, {
      query: { q: this.value }
    })
    if (response.ok) {
      const results = await response.html
      this.resultsTarget.innerHTML = results
      this.toggle()
    }
  }

  showEmptyState() {
    if (this.hasEmptyStateTarget) {
      this.resultsTarget.classList.add('Polaris--hidden')
      this.emptyStateTarget.classList.remove('Polaris--hidden')
    }
  }

  hideEmptyState() {
    if (this.hasEmptyStateTarget) {
      this.emptyStateTarget.classList.add('Polaris--hidden')
      this.resultsTarget.classList.remove('Polaris--hidden')
    }
  }
}
