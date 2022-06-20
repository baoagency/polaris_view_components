import { Controller } from '@hotwired/stimulus'
import { get } from '@rails/request.js'
import { debounce } from './utils'

export default class extends Controller {
  static targets = ['popover', 'input']
  static values = { multiple: Boolean, url: String, selected: Array, selectEventRef: String }

  connect() {
    this.inputTarget.addEventListener("input", this.onInputChange)

    document.addEventListener(this.selectEventRefValue, this.select);
  }

  disconnect() {
    this.inputTarget.removeEventListener("input", this.onInputChange)

    document.removeEventListener(this.selectEventRefValue, this.select);
  }

  // Actions

  toggle() {
    if (this.isRemote && this.visibleOptions.length == 0 && this.value.length == 0) {
      this.fetchResults()
    } else {
      this.handleResults()
    }
  }

  select = (event) => {
    const changeEvent = new CustomEvent('polaris-autocomplete:change', {
      detail: event.detail
    })

    this.element.dispatchEvent(changeEvent)

    if (!this.multipleValue) {
      this.popoverController.forceHide()
      this.inputTarget.value = event.detail.label
    }
  }

  onInputChange = debounce(() => {
    if (this.isRemote) {
      this.fetchResults()
    } else {
      this.filterOptions()
    }
  }, 200)

  reset() {
    this.inputTarget.value = ''
    this.optionTargets.forEach(option => {
      option.classList.add('Polaris--hidden')
    })
    this.handleResults()
  }

  // Private

  get isRemote() {
    return this.urlValue.length > 0
  }

  get popoverController() {
    return this.application.getControllerForElementAndIdentifier(this.popoverTarget, 'polaris-popover')
  }

  get resultsTarget() {
    return this.popoverController.popoverTarget.querySelector('[data-target="results"]')
  }

  get optionTargets() {
    return this.popoverController.popoverTarget.querySelectorAll('[data-target="option"]')
  }

  get optionInputTargets() {
    return this.popoverController.popoverTarget.querySelectorAll('[data-target="option"] input')
  }

  get emptyStateTarget() {
    return this.popoverController.popoverTarget.querySelector('[data-target="emptyState"]')
  }

  get hasEmptyStateTarget() {
    return this.emptyStateTarget !== null
  }

  get value() {
    return this.inputTarget.value
  }

  get visibleOptions() {
    return [...this.optionTargets].filter(option => {
      return !option.classList.contains('Polaris--hidden')
    })
  }

  handleResults() {
    if (this.visibleOptions.length > 0) {
      this.hideEmptyState()
      this.popoverController.show()
      this.checkSelected()
    } else if (this.value.length > 0 && this.hasEmptyStateTarget) {
      this.showEmptyState()
    } else {
      this.popoverController.forceHide()
    }
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
    this.handleResults()
  }

  async fetchResults() {
    const response = await get(this.urlValue, {
      query: { q: this.value }
    })
    if (response.ok) {
      const results = await response.html
      this.resultsTarget.innerHTML = results
      this.handleResults()
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

  checkSelected() {
    this.visibleOptions.forEach(option => {
      const input = option.querySelector('input')
      if (!input) return

      input.checked = this.selectedValue.includes(input.value)
    })
  }
}
