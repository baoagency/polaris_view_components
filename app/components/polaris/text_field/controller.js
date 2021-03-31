import { Controller } from 'stimulus'

// eslint-disable-next-line import/no-default-export
export default class extends Controller {
  static targets = ['input']
  static values = {
    min: Number,
    max: Number,
    value: String,
  }

  connect () {
    console.log(this)
  }

  valueValueChanged () {
    this.inputTarget.value = this.valueValue
  }

  handleInput (e) {
    this.valueValue = e.currentTarget.value
  }

  handleNumberChange (steps) {
    // Returns the length of decimal places in a number
    const dpl = num => (num.toString().split('.')[1] || []).length
    const numericValue = this.valueValue ? parseFloat(this.valueValue) : 0

    if (isNaN(numericValue)) {
      return
    }

    // Making sure the new value has the same length of decimal places as the
    // step / value has.
    const decimalPlaces = Math.max(dpl(numericValue), dpl(this.normalizedStep))

    const newValue = Math.min(
      Number(this.normalizedMax),
      Math.max(numericValue + steps * this.normalizedStep, Number(this.normalizedMin)),
    )

    this.valueValue = String(newValue.toFixed(decimalPlaces))
  }

  onMinusClick () {
    this.handleNumberChange(-1)
  }

  onPlusClick () {
    this.handleNumberChange(1)
  }

  get step () {
    return parseInt(this.inputTarget.getAttribute('step'))
  }

  get normalizedStep () {
    return this.step != null ? this.step : 1;
  }

  get normalizedMax () {
    return this.maxValue != null ? this.maxValue : Infinity;
  }

  get normalizedMin () {
    return this.minValue != null ? this.minValue : -Infinity;
  }
}
