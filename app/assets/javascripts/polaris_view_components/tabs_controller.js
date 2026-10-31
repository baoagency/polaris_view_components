import { Controller } from '@hotwired/stimulus'

// eslint-disable-next-line import/no-default-export
export default class extends Controller {
  connect () {
    const selectedTab = this.element.querySelector('.Polaris-LegacyTabs__Tab--selected')
    if (!selectedTab) return

    // Scrolls only the tab list, while scrollIntoView could also move the page
    const list = this.element.getBoundingClientRect()
    const tab = selectedTab.getBoundingClientRect()
    this.element.scrollLeft += tab.left - list.left - (list.width - tab.width) / 2
  }
}
