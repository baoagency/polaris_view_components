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
  }
  syncValue() {
    this.valueValue = this.inputTarget.value;
  }
  clear() {
    this.value = null;
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
    } else {
      this.clearButtonTarget.classList.add(this.clearButtonHiddenClass);
    }
  }
  updateCharacterCount() {
    this.characterCountTarget.textContent = this.textTemplateValue.replace(`{count}`, this.value.length);
    this.characterCountTarget.setAttribute("aria-label", this.labelTemplateValue.replace(`{count}`, this.value.length));
  }
}

_defineProperty(_class, "targets", [ "input", "clearButton", "characterCount" ]);

_defineProperty(_class, "classes", [ "hasValue", "clearButtonHidden" ]);

_defineProperty(_class, "values", {
  value: String,
  labelTemplate: String,
  textTemplate: String
});

function registerPolarisControllers(application) {
  application.register("polaris-select", _class$1);
  application.register("polaris-text-field", _class);
}

export { _class$1 as Select, _class as TextField, registerPolarisControllers };
