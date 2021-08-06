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

class _class extends Controller {
  update(event) {
    const select = event.currentTarget;
    const option = select.options[select.selectedIndex];
    this.selectedOptionTarget.innerText = option.text;
  }
}

_defineProperty(_class, "targets", [ "selectedOption" ]);

function registerPolarisControllers(application) {
  application.register("polaris-select", _class);
}

export { _class as Select, registerPolarisControllers };
