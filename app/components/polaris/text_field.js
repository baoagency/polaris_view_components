import { Controller } from 'stimulus';
// eslint-disable-next-line import/no-default-export
export default class default_1 extends Controller {
    valueValueChanged() {
        this.inputTarget.value = this.valueValue;
    }
    handleInput(e) {
        var _a;
        this.value = ((_a = e === null || e === void 0 ? void 0 : e.currentTarget) === null || _a === void 0 ? void 0 : _a.value) || '';
    }
    handleNumberChange(steps) {
        // Returns the length of decimal places in a number
        const dpl = (num) => (num.toString().split('.')[1] || []).length;
        const numericValue = this.valueValue ? parseFloat(this.valueValue) : 0;
        if (isNaN(numericValue)) {
            return;
        }
        // Making sure the new value has the same length of decimal places as the
        // step / value has.
        const decimalPlaces = Math.max(dpl(numericValue), dpl(this.normalizedStep));
        const newValue = Math.min(Number(this.normalizedMax), Math.max(numericValue + steps * this.normalizedStep, Number(this.normalizedMin)));
        this.valueValue = String(newValue.toFixed(decimalPlaces));
    }
    onClearClick() {
        this.value = '';
    }
    onMinusClick() {
        this.handleNumberChange(-1);
    }
    onPlusClick() {
        this.handleNumberChange(1);
    }
    get value() {
        return this.valueValue;
    }
    set value(val) {
        this.valueValue = val;
        if (this.hasClearButtonTarget) {
            this.clearButtonTarget.classList.toggle(this.clearButtonVisibilityClass, val === '');
            this.clearButtonTarget.setAttribute('tab-index', val === '' ? '-1' : '-');
        }
        if (this.hasCharacterCountTarget) {
            this.characterCountTarget.textContent = this.textTemplateValue
                .replace(`{count}`, `${val.length}`)
                .replace(`{max_count}`, `${this.maxLengthValue}`);
            this.characterCountTarget.setAttribute('aria-label', this.labelTemplateValue
                .replace(`{count}`, `${val.length}`)
                .replace(`{max_count}`, `${this.maxLengthValue}`));
        }
    }
    get step() {
        return parseInt(this.inputTarget.getAttribute('step') || '1');
    }
    get normalizedStep() {
        return this.step != null ? this.step : 1;
    }
    get normalizedMax() {
        return this.maxValue != null ? this.maxValue : Infinity;
    }
    get normalizedMin() {
        return this.minValue != null ? this.minValue : -Infinity;
    }
}
default_1.targets = ['input', 'clearButton', 'characterCount'];
default_1.values = {
    min: Number,
    max: Number,
    value: String,
    labelTemplate: String,
    textTemplate: String,
    maxLength: Number,
};
default_1.classes = ['clearButtonVisibility'];
