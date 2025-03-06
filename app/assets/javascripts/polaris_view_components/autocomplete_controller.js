import { Controller } from '@hotwired/stimulus'
import { get } from '@rails/request.js'
import { debounce } from './utils'

export default class extends Controller {
  static targets = ['popover', 'input', 'hiddenInput', 'results', 'option', 'emptyState', 'fetchingState']
  static values = { multiple: Boolean, url: String, selected: Array, addInputEventListener: Boolean }

  connect() {
    if (this.addInputEventListener) {
      this.inputTarget.addEventListener("input", this.onInputChange)
    }
  }

  disconnect() {
    if (this.addInputEventListener) {
      this.inputTarget.removeEventListener("input", this.onInputChange)
    }
  }

  // Actions

  toggle() {
    if (this.visibleOptions.length > 0) {
      this.handleResults()
    }
  }

  select(event) {
    const input = event.currentTarget
    const label = input.closest('li').dataset.label
    const changeEvent = new CustomEvent('polaris-autocomplete:change', {
      detail: { value: input.value, label, selected: input.checked }
    })

    this.element.dispatchEvent(changeEvent)

    if (!this.multipleValue) {
      this.popoverController.forceHide()
      this.inputTarget.value = label
      if (this.hasHiddenInputTarget)
        this.hiddenInputTarget.value = input.value
    }
  }

  onInputChange = debounce(() => {
    if (this.isRemote) {
      if (this.value.length > 0) {
        this.fetchResults()
      } else {
        this.popoverController.forceHide()
      }
    } else {
      this.filterOptions()
    }
  }, 500)

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
      this.popoverController.show()
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
      const searchTerms = this.value.toLowerCase().trim().split(/\s+/);
      this.optionTargets.forEach(option => {
        const label = option.dataset.label.toLowerCase();
        
        // Check if all search terms are present in the label
        const allTermsMatch = searchTerms.every(term => {
          // Allow for some fuzzy matching by checking if term is at least
          // partially contained in any word in the label
          return label.includes(term);
        });
        
        if (allTermsMatch) {
          option.classList.remove('Polaris--hidden');
        } else {
          option.classList.add('Polaris--hidden');
        }
      });
    }

    this.handleResults()
  }

  async fetchResults() {
    if (this.hasFetchingStateTarget) {
      this.popoverController.show()
      this.showFetchingState()
    }

    const response = await get(this.urlValue, {
      query: { q: this.value }
    })
    if (response.ok) {
      if (this.hasFetchingStateTarget) {
        this.popoverController.forceHide()
        this.hideFetchingState()
      }

      const results = await response.html
      this.resultsTarget.innerHTML = results
      this.handleResults()
    }
  }

  showEmptyState() {
    if (this.hasEmptyStateTarget) {
      this.resultsTarget.classList.add('Polaris--hidden')
      this.fetchingStateTarget.classList.add('Polaris--hidden')
      this.emptyStateTarget.classList.remove('Polaris--hidden')
    }
  }

  showFetchingState() {
    if (this.hasFetchingStateTarget) {
      this.fetchingStateTarget.classList.remove('Polaris--hidden')
      this.emptyStateTarget.classList.add('Polaris--hidden')
      this.resultsTarget.classList.add('Polaris--hidden')
    }
  }

  hideFetchingState() {
    if (this.hasFetchingStateTarget) {
      this.fetchingStateTarget.classList.add('Polaris--hidden')
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
