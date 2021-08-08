import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['input', 'clearButton', 'characterCount']
  static classes = ['hasValue', 'clearButtonHidden']
  static values = {
    value: String,
    labelTemplate: String,
    textTemplate: String,
  }

  connect() {
    this.syncValue()
  }

  // Actions

  syncValue() {
    this.valueValue = this.inputTarget.value
  }

  clear() {
    this.value = null
  }

  // Callbacks

  valueValueChanged() {
    this.toggleHasValueClass()
    if (this.hasClearButtonTarget) {
      this.toggleClearButton()
    }
    if (this.hasCharacterCountTarget) {
      this.updateCharacterCount()
    }
  }

  // Private

  get value() {
    return this.valueValue
  }

  set value(newValue) {
    this.inputTarget.value = newValue
    this.syncValue()
  }

  toggleHasValueClass() {
    if (this.value.length > 0) {
      this.element.classList.add(this.hasValueClass)
    } else {
      this.element.classList.remove(this.hasValueClass)
    }
  }

  toggleClearButton() {
    if (this.value.length > 0) {
      this.clearButtonTarget.classList.remove(this.clearButtonHiddenClass)
    } else {
      this.clearButtonTarget.classList.add(this.clearButtonHiddenClass)
    }
  }

  updateCharacterCount() {
    this.characterCountTarget.textContent = this.textTemplateValue
      .replace(`{count}`, this.value.length)

    this.characterCountTarget.setAttribute(
      'aria-label',
      this.labelTemplateValue.replace(`{count}`, this.value.length)
    )
  }
}
