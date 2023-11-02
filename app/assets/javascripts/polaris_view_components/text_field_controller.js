import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'clearButton', 'characterCount']
  static classes = ['hasValue', 'clearButtonHidden']
  static values = {
    value: String,
    labelTemplate: String,
    textTemplate: String,
    step: Number,
    min: Number,
    max: Number,
  }

  connect() {
    this.syncValue()
    this.stepValue = this.inputTarget.getAttribute('step')
    this.minValue = this.inputTarget.getAttribute('min')
    this.maxValue = this.inputTarget.getAttribute('max')
  }

  // Actions

  syncValue() {
    this.valueValue = this.inputTarget.value
  }

  clear() {
    const oldValue = this.value
    this.value = null

    if (this.value != oldValue) {
      this.inputTarget.dispatchEvent(new Event('change'))
    }
  }

  clearErrorMessages() {
    const wrapper = this.inputTarget.parentElement
    const inlineError = this.inputTarget.closest(".polaris-text-field-wrapper").querySelector(".Polaris-InlineError")

    if (wrapper) {
      wrapper.classList.remove("Polaris-TextField--error")
    }
    if (inlineError) {
      inlineError.remove()
    }
  }

  increase() {
    this.changeNumber(1)
  }

  decrease() {
    this.changeNumber(-1)
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
      this.clearButtonTarget.setAttribute('tab-index', '-')
    } else {
      this.clearButtonTarget.classList.add(this.clearButtonHiddenClass)
      this.clearButtonTarget.setAttribute('tab-index', '-1')
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

  changeNumber(steps) {
    // Returns the length of decimal places in a number
    const dpl = num => (num.toString().split('.')[1] || []).length
    const numericValue = this.value ? parseFloat(this.value) : 0

    if (isNaN(numericValue)) {
      return
    }

    // Making sure the new value has the same length of decimal places as the
    // step / value has.
    const decimalPlaces = Math.max(dpl(numericValue), dpl(this.stepValue))

    const oldValue = this.value
    const newValue = Math.min(
      Number(this.maxValue),
      Math.max(numericValue + steps * this.stepValue, Number(this.minValue)),
    )

    this.value = String(newValue.toFixed(decimalPlaces))
    if (this.value != oldValue) {
      this.inputTarget.dispatchEvent(new Event('change'))
    }
  }
}
