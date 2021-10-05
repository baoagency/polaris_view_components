import { Controller } from "stimulus";

class ResourceItem extends Controller {
  static targets=[ "link" ];
  open(event) {
    if (this.hasLinkTarget && this.targetNotClickable(event.target)) {
      this.linkTarget.click();
    }
  }
  targetNotClickable(element) {
    return !element.closest("a") && !element.closest("button") && element.nodeName !== "INPUT";
  }
}

class Select extends Controller {
  static targets=[ "selectedOption" ];
  update(event) {
    const select = event.currentTarget;
    const option = select.options[select.selectedIndex];
    this.selectedOptionTarget.innerText = option.text;
  }
}

class TextField extends Controller {
  static targets=[ "input", "clearButton", "characterCount" ];
  static classes=[ "hasValue", "clearButtonHidden" ];
  static values={
    value: String,
    labelTemplate: String,
    textTemplate: String,
    step: Number,
    min: Number,
    max: Number
  };
  connect() {
    this.syncValue();
    this.stepValue = this.inputTarget.getAttribute("step");
    this.minValue = this.inputTarget.getAttribute("min");
    this.maxValue = this.inputTarget.getAttribute("max");
  }
  syncValue() {
    this.valueValue = this.inputTarget.value;
  }
  clear() {
    this.value = null;
  }
  increase() {
    this.changeNumber(1);
  }
  decrease() {
    this.changeNumber(-1);
  }
  valueValueChanged() {
    this.toggleHasValueClass();
    if (this.hasClearButtonTarget) {
      this.toggleClearButton();
    }
    if (this.hasCharacterCountTarget) {
      this.updateCharacterCount();
    }
  }
  get value() {
    return this.valueValue;
  }
  set value(newValue) {
    this.inputTarget.value = newValue;
    this.syncValue();
  }
  toggleHasValueClass() {
    if (this.value.length > 0) {
      this.element.classList.add(this.hasValueClass);
    } else {
      this.element.classList.remove(this.hasValueClass);
    }
  }
  toggleClearButton() {
    if (this.value.length > 0) {
      this.clearButtonTarget.classList.remove(this.clearButtonHiddenClass);
      this.clearButtonTarget.setAttribute("tab-index", "-");
    } else {
      this.clearButtonTarget.classList.add(this.clearButtonHiddenClass);
      this.clearButtonTarget.setAttribute("tab-index", "-1");
    }
  }
  updateCharacterCount() {
    this.characterCountTarget.textContent = this.textTemplateValue.replace(`{count}`, this.value.length);
    this.characterCountTarget.setAttribute("aria-label", this.labelTemplateValue.replace(`{count}`, this.value.length));
  }
  changeNumber(steps) {
    const dpl = num => (num.toString().split(".")[1] || []).length;
    const numericValue = this.value ? parseFloat(this.value) : 0;
    if (isNaN(numericValue)) {
      return;
    }
    const decimalPlaces = Math.max(dpl(numericValue), dpl(this.stepValue));
    const newValue = Math.min(Number(this.maxValue), Math.max(numericValue + steps * this.stepValue, Number(this.minValue)));
    this.value = String(newValue.toFixed(decimalPlaces));
  }
}

function registerPolarisControllers(application) {
  application.register("polaris-resource-item", ResourceItem);
  application.register("polaris-select", Select);
  application.register("polaris-text-field", TextField);
}

export { ResourceItem, Select, TextField, registerPolarisControllers };
