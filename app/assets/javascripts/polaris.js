import { Controller } from "stimulus";

function _defineProperty(obj, key, value) {
  if (key in obj) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true
    });
  } else {
    obj[key] = value;
  }
  return obj;
}

class _class$2 extends Controller {
  open(event) {
    if (this.hasLinkTarget && this.targetIsNotLink(event.target)) {
      this.linkTarget.click();
    }
  }
  targetIsNotLink(element) {
    return !element.closest("a") && !element.closest("button");
  }
}

_defineProperty(_class$2, "targets", [ "link" ]);

class _class$1 extends Controller {
  update(event) {
    const select = event.currentTarget;
    const option = select.options[select.selectedIndex];
    this.selectedOptionTarget.innerText = option.text;
  }
}

_defineProperty(_class$1, "targets", [ "selectedOption" ]);

class _class extends Controller {
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
    console.log(numericValue, this.stepValue);
    const decimalPlaces = Math.max(dpl(numericValue), dpl(this.stepValue));
    const newValue = Math.min(Number(this.maxValue), Math.max(numericValue + steps * this.stepValue, Number(this.minValue)));
    this.value = String(newValue.toFixed(decimalPlaces));
  }
}

_defineProperty(_class, "targets", [ "input", "clearButton", "characterCount" ]);

_defineProperty(_class, "classes", [ "hasValue", "clearButtonHidden" ]);

_defineProperty(_class, "values", {
  value: String,
  labelTemplate: String,
  textTemplate: String,
  step: Number,
  min: Number,
  max: Number
});

function registerPolarisControllers(application) {
  application.register("polaris-resource-item", _class$2);
  application.register("polaris-select", _class$1);
  application.register("polaris-text-field", _class);
}

export { _class$2 as ResourceItem, _class$1 as Select, _class as TextField, registerPolarisControllers };
