import { Controller } from "@hotwired/stimulus";

import { get } from "@rails/request.js";

const alpineNames = {
  enterFromClass: "enter",
  enterActiveClass: "enterStart",
  enterToClass: "enterEnd",
  leaveFromClass: "leave",
  leaveActiveClass: "leaveStart",
  leaveToClass: "leaveEnd"
};

const defaultOptions = {
  transitioned: false,
  hiddenClass: "hidden",
  preserveOriginalClass: true,
  removeToClasses: true
};

const useTransition = (controller, options = {}) => {
  var _a, _b, _c;
  const targetName = controller.element.dataset.transitionTarget;
  let targetFromAttribute;
  if (targetName) {
    targetFromAttribute = controller[`${targetName}Target`];
  }
  const targetElement = (options === null || options === void 0 ? void 0 : options.element) || targetFromAttribute || controller.element;
  if (!(targetElement instanceof HTMLElement || targetElement instanceof SVGElement)) return;
  const dataset = targetElement.dataset;
  const leaveAfter = parseInt(dataset.leaveAfter || "") || options.leaveAfter || 0;
  const {transitioned: transitioned, hiddenClass: hiddenClass, preserveOriginalClass: preserveOriginalClass, removeToClasses: removeToClasses} = Object.assign(defaultOptions, options);
  const controllerEnter = (_a = controller.enter) === null || _a === void 0 ? void 0 : _a.bind(controller);
  const controllerLeave = (_b = controller.leave) === null || _b === void 0 ? void 0 : _b.bind(controller);
  const controllerToggleTransition = (_c = controller.toggleTransition) === null || _c === void 0 ? void 0 : _c.bind(controller);
  async function enter(event) {
    if (controller.transitioned) return;
    controller.transitioned = true;
    controllerEnter && controllerEnter(event);
    const enterFromClasses = getAttribute("enterFrom", options, dataset);
    const enterActiveClasses = getAttribute("enterActive", options, dataset);
    const enterToClasses = getAttribute("enterTo", options, dataset);
    const leaveToClasses = getAttribute("leaveTo", options, dataset);
    if (!!hiddenClass) {
      targetElement.classList.remove(hiddenClass);
    }
    if (!removeToClasses) {
      removeClasses(targetElement, leaveToClasses);
    }
    await transition(targetElement, enterFromClasses, enterActiveClasses, enterToClasses, hiddenClass, preserveOriginalClass, removeToClasses);
    if (leaveAfter > 0) {
      setTimeout((() => {
        leave(event);
      }), leaveAfter);
    }
  }
  async function leave(event) {
    if (!controller.transitioned) return;
    controller.transitioned = false;
    controllerLeave && controllerLeave(event);
    const leaveFromClasses = getAttribute("leaveFrom", options, dataset);
    const leaveActiveClasses = getAttribute("leaveActive", options, dataset);
    const leaveToClasses = getAttribute("leaveTo", options, dataset);
    const enterToClasses = getAttribute("enterTo", options, dataset);
    if (!removeToClasses) {
      removeClasses(targetElement, enterToClasses);
    }
    await transition(targetElement, leaveFromClasses, leaveActiveClasses, leaveToClasses, hiddenClass, preserveOriginalClass, removeToClasses);
    if (!!hiddenClass) {
      targetElement.classList.add(hiddenClass);
    }
  }
  function toggleTransition(event) {
    controllerToggleTransition && controllerToggleTransition(event);
    if (controller.transitioned) {
      leave();
    } else {
      enter();
    }
  }
  async function transition(element, initialClasses, activeClasses, endClasses, hiddenClass, preserveOriginalClass, removeEndClasses) {
    const stashedClasses = [];
    if (preserveOriginalClass) {
      initialClasses.forEach((cls => element.classList.contains(cls) && cls !== hiddenClass && stashedClasses.push(cls)));
      activeClasses.forEach((cls => element.classList.contains(cls) && cls !== hiddenClass && stashedClasses.push(cls)));
      endClasses.forEach((cls => element.classList.contains(cls) && cls !== hiddenClass && stashedClasses.push(cls)));
    }
    addClasses(element, initialClasses);
    removeClasses(element, stashedClasses);
    addClasses(element, activeClasses);
    await nextAnimationFrame();
    removeClasses(element, initialClasses);
    addClasses(element, endClasses);
    await afterTransition(element);
    removeClasses(element, activeClasses);
    if (removeEndClasses) {
      removeClasses(element, endClasses);
    }
    addClasses(element, stashedClasses);
  }
  function initialState() {
    controller.transitioned = transitioned;
    if (transitioned) {
      if (!!hiddenClass) {
        targetElement.classList.remove(hiddenClass);
      }
      enter();
    } else {
      if (!!hiddenClass) {
        targetElement.classList.add(hiddenClass);
      }
      leave();
    }
  }
  function addClasses(element, classes) {
    if (classes.length > 0) {
      element.classList.add(...classes);
    }
  }
  function removeClasses(element, classes) {
    if (classes.length > 0) {
      element.classList.remove(...classes);
    }
  }
  initialState();
  Object.assign(controller, {
    enter: enter,
    leave: leave,
    toggleTransition: toggleTransition
  });
  return [ enter, leave, toggleTransition ];
};

function getAttribute(name, options, dataset) {
  const datasetName = `transition${name[0].toUpperCase()}${name.substr(1)}`;
  const datasetAlpineName = alpineNames[name];
  const classes = options[name] || dataset[datasetName] || dataset[datasetAlpineName] || " ";
  return isEmpty(classes) ? [] : classes.split(" ");
}

async function afterTransition(element) {
  return new Promise((resolve => {
    const duration = Number(getComputedStyle(element).transitionDuration.split(",")[0].replace("s", "")) * 1e3;
    setTimeout((() => {
      resolve(duration);
    }), duration);
  }));
}

async function nextAnimationFrame() {
  return new Promise((resolve => {
    requestAnimationFrame((() => {
      requestAnimationFrame(resolve);
    }));
  }));
}

function isEmpty(str) {
  return str.length === 0 || !str.trim();
}

function debounce(fn, wait) {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout((() => fn.apply(this, args)), wait);
  };
}

function formatBytes(bytes, decimals) {
  if (bytes == 0) return "0 Bytes";
  const k = 1024, dm = decimals || 2, sizes = [ "Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB" ], i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + " " + sizes[i];
}

class Autocomplete extends Controller {
  static targets=[ "popover", "input", "hiddenInput", "results", "option", "emptyState" ];
  static values={
    multiple: Boolean,
    url: String,
    selected: Array
  };
  connect() {
    this.inputTarget.addEventListener("input", this.onInputChange);
  }
  disconnect() {
    this.inputTarget.removeEventListener("input", this.onInputChange);
  }
  toggle() {
    if (this.isRemote && this.visibleOptions.length == 0 && this.value.length == 0) {
      this.fetchResults();
    } else {
      this.handleResults();
    }
  }
  select(event) {
    const input = event.currentTarget;
    const label = input.closest("li").dataset.label;
    const changeEvent = new CustomEvent("polaris-autocomplete:change", {
      detail: {
        value: input.value,
        label: label,
        selected: input.checked
      }
    });
    this.element.dispatchEvent(changeEvent);
    if (!this.multipleValue) {
      this.popoverController.forceHide();
      this.inputTarget.value = label;
      if (this.hasHiddenInputTarget) this.hiddenInputTarget.value = input.value;
    }
  }
  onInputChange=debounce((() => {
    if (this.isRemote) {
      this.fetchResults();
    } else {
      this.filterOptions();
    }
  }), 200);
  reset() {
    this.inputTarget.value = "";
    this.optionTargets.forEach((option => {
      option.classList.add("Polaris--hidden");
    }));
    this.handleResults();
  }
  get isRemote() {
    return this.urlValue.length > 0;
  }
  get popoverController() {
    return this.application.getControllerForElementAndIdentifier(this.popoverTarget, "polaris-popover");
  }
  get value() {
    return this.inputTarget.value;
  }
  get visibleOptions() {
    return [ ...this.optionTargets ].filter((option => !option.classList.contains("Polaris--hidden")));
  }
  handleResults() {
    if (this.visibleOptions.length > 0) {
      this.hideEmptyState();
      this.popoverController.show();
      this.checkSelected();
    } else if (this.value.length > 0 && this.hasEmptyStateTarget) {
      this.showEmptyState();
    } else {
      this.popoverController.forceHide();
    }
  }
  filterOptions() {
    if (this.value === "") {
      this.optionTargets.forEach((option => {
        option.classList.remove("Polaris--hidden");
      }));
    } else {
      const filterRegex = new RegExp(this.value, "i");
      this.optionTargets.forEach((option => {
        if (option.dataset.label.match(filterRegex)) {
          option.classList.remove("Polaris--hidden");
        } else {
          option.classList.add("Polaris--hidden");
        }
      }));
    }
    this.handleResults();
  }
  async fetchResults() {
    const response = await get(this.urlValue, {
      query: {
        q: this.value
      }
    });
    if (response.ok) {
      const results = await response.html;
      this.resultsTarget.innerHTML = results;
      this.handleResults();
    }
  }
  showEmptyState() {
    if (this.hasEmptyStateTarget) {
      this.resultsTarget.classList.add("Polaris--hidden");
      this.emptyStateTarget.classList.remove("Polaris--hidden");
    }
  }
  hideEmptyState() {
    if (this.hasEmptyStateTarget) {
      this.emptyStateTarget.classList.add("Polaris--hidden");
      this.resultsTarget.classList.remove("Polaris--hidden");
    }
  }
  checkSelected() {
    this.visibleOptions.forEach((option => {
      const input = option.querySelector("input");
      if (!input) return;
      input.checked = this.selectedValue.includes(input.value);
    }));
  }
}

class Button extends Controller {
  static values={
    disabled: Boolean
  };
  disable(event) {
    if (this.disabledValue) {
      if (event) event.preventDefault();
    } else {
      this.disabledValue = true;
      this.button.classList.add("Polaris-Button--disabled", "Polaris-Button--loading");
      this.buttonContent.insertAdjacentHTML("afterbegin", this.spinnerHTML);
    }
  }
  disableWithoutLoader(event) {
    if (this.disabledValue) {
      if (event) event.preventDefault();
    } else {
      this.disabledValue = true;
      this.button.classList.add("Polaris-Button--disabled");
    }
  }
  enable() {
    if (this.disabledValue) {
      this.disabledValue = false;
      this.button.classList.remove("Polaris-Button--disabled", "Polaris-Button--loading");
      if (this.spinner) this.spinner.remove();
    }
  }
  get button() {
    return this.element;
  }
  get buttonContent() {
    return this.button.querySelector(".Polaris-Button__Content");
  }
  get spinner() {
    return this.button.querySelector(".Polaris-Button__Spinner");
  }
  get spinnerHTML() {
    return `\n      <span class="Polaris-Button__Spinner">\n        <span class="Polaris-Spinner Polaris-Spinner--sizeSmall">\n          <svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">\n            <path d="M7.229 1.173a9.25 9.25 0 1011.655 11.412 1.25 1.25 0 10-2.4-.698 6.75 6.75 0 11-8.506-8.329 1.25 1.25 0 10-.75-2.385z"></path>\n          </svg>\n        </span>\n      </span>\n    `;
  }
}

class Collapsible extends Controller {
  toggle() {
    if (this.isClosed) {
      this.element.style.maxHeight = "none";
      this.element.style.overflow = "visible";
      this.element.classList.remove("Polaris-Collapsible--isFullyClosed");
    } else {
      this.element.style.maxHeight = "0px";
      this.element.style.overflow = "hidden";
      this.element.classList.add("Polaris-Collapsible--isFullyClosed");
    }
  }
  get isClosed() {
    return this.element.classList.contains("Polaris-Collapsible--isFullyClosed");
  }
}

class DataTable extends Controller {
  static targets=[ "row" ];
  connect() {
    this.rowTargets.forEach((row => {
      row.addEventListener("mouseover", (() => this.handleHover(row)));
      row.addEventListener("mouseout", (() => this.handleLeave(row)));
    }));
  }
  disconnect() {
    this.rowTargets.forEach((row => {
      row.removeEventListener("mouseover", (() => this.handleHover(row)));
      row.removeEventListener("mouseout", (() => this.handleLeave(row)));
    }));
  }
  handleHover(row) {
    const cells = row.querySelectorAll(".Polaris-DataTable__Cell");
    cells.forEach((cell => {
      cell.classList.add("Polaris-DataTable__Cell--hovered");
    }));
  }
  handleLeave(row) {
    const cells = row.querySelectorAll(".Polaris-DataTable__Cell");
    cells.forEach((cell => {
      cell.classList.remove("Polaris-DataTable__Cell--hovered");
    }));
  }
}

const dragEvents = [ "dragover", "dragenter", "drop" ];

const SIZES = {
  SMALL: "small",
  MEDIUM: "medium",
  LARGE: "large",
  EXTRA_LARGE: "extraLarge"
};

class Dropzone extends Controller {
  static targets=[ "container", "fileUpload", "loader", "input", "preview", "previewTemplate", "itemTemplate", "overlay", "errorOverlay" ];
  static classes=[ "disabled" ];
  static values={
    accept: String,
    allowMultiple: Boolean,
    disabled: Boolean,
    dropOnPage: Boolean,
    focused: Boolean,
    renderPreview: Boolean,
    size: String,
    removePreviewsAfterUpload: Boolean
  };
  files=[];
  rejectedFiles=[];
  _dragging=false;
  dragTargets=[];
  previewRendered=false;
  _acceptedFiles=[];
  _size="large";
  connect() {
    document.body.addEventListener("click", this.onExternalTriggerClick);
    addEventListener("resize", this.onWindowResize);
    addEventListener("direct-uploads:start", this.onDirectUploadsStart);
    addEventListener("direct-uploads:end", this.onDirectUploadsEnd);
    addEventListener("direct-upload:initialize", this.onDirectUploadInitialize);
    addEventListener("direct-upload:start", this.onDirectUploadStart);
    addEventListener("direct-upload:progress", this.onDirectUploadProgress);
    addEventListener("direct-upload:error", this.onDirectUploadError);
    addEventListener("direct-upload:end", this.onDirectUploadEnd);
    this.onWindowResize();
  }
  disconnect() {
    document.body.removeEventListener("click", this.onExternalTriggerClick);
    removeEventListener("resize", this.onWindowResize);
    removeEventListener("direct-uploads:start", this.onDirectUploadsStart);
    removeEventListener("direct-uploads:end", this.onDirectUploadsEnd);
    removeEventListener("direct-upload:initialize", this.onDirectUploadInitialize);
    removeEventListener("direct-upload:start", this.onDirectUploadStart);
    removeEventListener("direct-upload:progress", this.onDirectUploadProgress);
    removeEventListener("direct-upload:error", this.onDirectUploadError);
    removeEventListener("direct-upload:end", this.onDirectUploadEnd);
  }
  onExternalTriggerClick=event => {
    const trigger = event.target.closest(`[data-${this.identifier}-external-target="trigger"]`);
    if (!trigger) return;
    event.preventDefault();
    this.onClick();
  };
  onWindowResize=debounce((() => {
    const size = this.calculateSize();
    if (size !== this.size) {
      this.size = size;
    }
  }), 50);
  onBlur() {
    this.focusedValue = false;
  }
  onChange(e) {
    this.stopEvent(e);
    if (this.disabled) return;
    const fileList = getDataTransferFiles(e);
    this.clearFiles();
    const {files: files, acceptedFiles: acceptedFiles, rejectedFiles: rejectedFiles} = this.getValidatedFiles(fileList);
    this.dragTargets = [];
    this.files = files;
    this.acceptedFiles = acceptedFiles;
    this.rejectedFiles = rejectedFiles;
    this.render();
  }
  onDragOver(e) {
    this.stopEvent(e);
    if (this.disabled) return;
  }
  onDragEnter(e) {
    this.stopEvent(e);
    if (this.disabled) return;
    if (e.target && !this.dragTargets.includes(e.target)) {
      this.dragTargets.push(e.target);
    }
    if (this.dragging) return;
    this.dragging = true;
  }
  onDragLeave(e) {
    this.stopEvent(e);
    if (this.disabled) return;
    this.dragTargets = this.dragTargets.filter((el => {
      const compareNode = this.element;
      return el !== e.target && compareNode && compareNode.contains(el);
    }));
    if (this.dragTargets.length > 0) return;
    this.dragging = false;
  }
  onDrop(e) {
    this.stopEvent(e);
    if (this.disabled) return;
    this.dragging = false;
    this.onChange(e);
  }
  onFocus() {
    this.focusedValue = true;
  }
  onClick() {
    if (this.disabledValue) return;
    this.open();
  }
  onDirectUploadsStart=() => {
    this.disable();
  };
  onDirectUploadsEnd=() => {
    this.enable();
    this.clearFiles(this.removePreviewsAfterUploadValue);
    if (this.acceptedFiles.length === 0) return;
    if (this.hasLoaderTarget) this.loaderTarget.classList.remove("Polaris--hidden");
  };
  onDirectUploadInitialize=event => {
    const {target: target, detail: detail} = event;
    const {id: id, file: file} = detail;
    const dropzone = target.closest(".Polaris-DropZone");
    if (!dropzone) return;
    if (this.acceptedFiles.length === 0) return;
    if (this.sizeValue == "small") {
      this.removePreview();
      if (this.hasLoaderTarget) this.loaderTarget.classList.remove("Polaris--hidden");
    } else {
      const content = dropzone.querySelector(`[data-file-name="${file.name}"]`);
      if (content) {
        const progressBar = content.parentElement.querySelector('[data-target="progress-bar"]');
        progressBar.id = `direct-upload-${id}`;
      }
    }
  };
  onDirectUploadStart=event => {
    const {id: id} = event.detail;
    const progressBar = document.getElementById(`direct-upload-${id}`);
    if (!progressBar) return;
    progressBar.classList.remove("Polaris--hidden");
  };
  onDirectUploadProgress=event => {
    const {id: id, progress: progress} = event.detail;
    const progressBar = document.getElementById(`direct-upload-${id}`);
    if (!progressBar) return;
    const progressElement = progressBar.querySelector(".Polaris-ProgressBar__Indicator");
    progressElement.style.width = `${progress}%`;
  };
  onDirectUploadError=event => {
    const {id: id, error: error} = event.detail;
    const progressBar = document.getElementById(`direct-upload-${id}`);
    if (!progressBar) return;
    event.preventDefault();
    progressBar.classList.add("Polaris--hidden");
    const uploadError = progressBar.parentElement.querySelector('[data-target="upload-error"]');
    const errorIcon = uploadError.querySelector(".Polaris-InlineError__Icon");
    if (errorIcon) errorIcon.remove();
    uploadError.classList.remove("Polaris--hidden");
  };
  onDirectUploadEnd=event => {
    const {id: id} = event.detail;
    const progressBar = document.getElementById(`direct-upload-${id}`);
    if (!progressBar) return;
    progressBar.classList.add("Polaris-ProgressBar--colorSuccess");
  };
  open() {
    this.inputTarget.click();
  }
  focusedValueChanged() {
    this.element.classList.toggle("Polaris-DropZone--focused", this.focusedValue);
  }
  stopEvent(e) {
    e.preventDefault();
    e.stopPropagation();
  }
  getValidatedFiles(files) {
    const acceptedFiles = [];
    const rejectedFiles = [];
    Array.from(files).forEach((file => {
      if (fileAccepted(file, this.acceptValue)) {
        acceptedFiles.push(file);
      } else {
        rejectedFiles.push(file);
      }
    }));
    if (!this.allowMultipleValue) {
      acceptedFiles.splice(1, acceptedFiles.length);
      rejectedFiles.push(...acceptedFiles.slice(1));
    }
    return {
      files: files,
      acceptedFiles: acceptedFiles,
      rejectedFiles: rejectedFiles
    };
  }
  render() {
    if (this.files.length === 0) {
      this.toggleFileUpload(true);
      this.toggleErrorOverlay(false);
    } else if (this.rejectedFiles.length > 0) {
      this.toggleFileUpload(false);
      this.toggleErrorOverlay(true);
      const dropRejectedEvent = new CustomEvent("polaris-dropzone:drop-rejected", {
        bubbles: true,
        detail: {
          rejectedFiles: this.rejectedFiles
        }
      });
      this.element.dispatchEvent(dropRejectedEvent);
    } else if (this.acceptedFiles.length > 0) {
      if (this.renderPreviewValue) {
        this.renderUploadedFiles();
        this.toggleFileUpload(false);
      }
      this.toggleErrorOverlay(false);
      const dropAcceptedEvent = new CustomEvent("polaris-dropzone:drop-accepted", {
        bubbles: true,
        detail: {
          acceptedFiles: this.acceptedFiles
        }
      });
      this.element.dispatchEvent(dropAcceptedEvent);
    }
    const dropEvent = new CustomEvent("polaris-dropzone:drop", {
      bubbles: true,
      detail: {
        files: this.files,
        acceptedFiles: this.acceptedFiles,
        rejectedFiles: this.rejectedFiles
      }
    });
    this.element.dispatchEvent(dropEvent);
  }
  renderUploadedFiles() {
    if (this.acceptedFiles.length === 0) return;
    const clone = this.previewTemplateTarget.content.cloneNode(true);
    const filesTarget = clone.querySelector(".target");
    let files = this.acceptedFiles;
    if (this.sizeValue == "small") files = [ files[0] ];
    files.map((file => this.renderFile(file))).forEach((fragment => filesTarget.parentNode.appendChild(fragment)));
    filesTarget.remove();
    this.containerTarget.prepend(clone);
    this.previewRendered = true;
  }
  toggleFileUpload(show = false) {
    this.fileUploadTarget.classList.toggle("Polaris-VisuallyHidden", !show);
  }
  toggleErrorOverlay(show = false) {
    this.errorOverlayTarget.classList.toggle("Polaris-VisuallyHidden", !show);
    this.element.classList.toggle("Polaris-DropZone--hasError", show);
  }
  renderFile(file) {
    const validImageTypes = [ "image/gif", "image/jpeg", "image/png", "image/svg+xml" ];
    const clone = this.itemTemplateTarget.content.cloneNode(true);
    const [icon, thumbnail, content, fileSize] = [ clone.querySelector('[data-target="icon"]'), clone.querySelector('[data-target="thumbnail"]'), clone.querySelector('[data-target="content"]'), clone.querySelector('[data-target="file-size"]') ];
    if (validImageTypes.includes(file.type)) {
      const img = thumbnail.querySelector("img");
      img.alt = file.name;
      img.src = window.URL.createObjectURL(file);
      icon.remove();
    } else {
      thumbnail.remove();
    }
    if (this.sizeValue != "small") {
      content.insertAdjacentText("afterbegin", file.name);
      content.setAttribute("data-file-name", file.name);
      fileSize.textContent = formatBytes(file.size);
    }
    return clone;
  }
  clearFiles(removePreview = true) {
    if (!this.previewRendered) return;
    this.acceptedFiles = [];
    this.files = [];
    this.rejectedFiles = [];
    if (removePreview) this.removePreview();
  }
  removePreview() {
    if (!this.hasPreviewTarget) return;
    this.previewTarget.remove();
    this.previewRendered = false;
  }
  calculateSize() {
    const width = this.element.getBoundingClientRect().width;
    let size = SIZES.LARGE;
    if (width < 100) {
      size = SIZES.SMALL;
    } else if (width < 160) {
      size = SIZES.MEDIUM;
    } else if (width > 300) {
      size = SIZES.EXTRA_LARGE;
    }
    this.size = size;
    return size;
  }
  getSizeClass(size = "large") {
    return this.sizeClassesSchema[size] || this.sizeClassesSchema.large;
  }
  disable() {
    this.disabled = true;
    this.element.classList.add(this.disabledClass);
    this.inputTarget.disabled = true;
  }
  enable() {
    this.disabled = false;
    this.element.classList.remove(this.disabledClass);
    this.inputTarget.disabled = false;
  }
  get fileListRendered() {
    return this.element.querySelector("[data-rendered]");
  }
  get dropNode() {
    return this.dropOnPageValue ? document : this.element;
  }
  get disabled() {
    return this.disabledValue;
  }
  set disabled(val) {
    this.disabledValue = val;
  }
  get dragging() {
    return this._dragging;
  }
  set dragging(val) {
    this._dragging = val;
    this.element.classList.toggle("Polaris-DropZone--isDragging", val);
    this.overlayTarget.classList.toggle("Polaris-VisuallyHidden", !val);
  }
  get sizeClassesSchema() {
    return {
      [SIZES.SMALL]: "Polaris-DropZone--sizeSmall",
      [SIZES.MEDIUM]: "Polaris-DropZone--sizeMedium",
      [SIZES.LARGE]: "Polaris-DropZone--sizeLarge",
      [SIZES.EXTRA_LARGE]: "Polaris-DropZone--sizeExtraLarge"
    };
  }
  get size() {
    return this._size;
  }
  set size(val) {
    this._size = val;
    const sizeClassesToRemove = Object.values(this.sizeClassesSchema);
    sizeClassesToRemove.forEach((className => this.element.classList.remove(className)));
    this.element.classList.add(this.getSizeClass(val));
  }
  get acceptedFiles() {
    return this._acceptedFiles;
  }
  set acceptedFiles(val) {
    this._acceptedFiles = val;
    const list = new DataTransfer;
    val.forEach((file => list.items.add(file)));
    this.inputTarget.files = list.files;
  }
}

function fileAccepted(file, accept) {
  return file.type === "application/x-moz-file" || accepts(file, accept);
}

function getDataTransferFiles(event) {
  if (isDragEvent(event) && event.dataTransfer) {
    const dt = event.dataTransfer;
    if (dt.files && dt.files.length) {
      return Array.from(dt.files);
    } else if (dt.items && dt.items.length) {
      return Array.from(dt.items);
    }
  } else if (isChangeEvent(event) && event.target.files) {
    return Array.from(event.target.files);
  }
  return [];
}

function accepts(file, acceptedFiles = [ "" ]) {
  if (file && acceptedFiles) {
    const fileName = file.name || "";
    const mimeType = file.type || "";
    const baseMimeType = mimeType.replace(/\/.*$/, "");
    const acceptedFilesArray = Array.isArray(acceptedFiles) ? acceptedFiles : acceptedFiles.split(",");
    return acceptedFilesArray.some((type => {
      const validType = type.trim();
      if (validType.startsWith(".")) {
        return fileName.toLowerCase().endsWith(validType.toLowerCase());
      } else if (validType.endsWith("/*")) {
        return baseMimeType === validType.replace(/\/.*$/, "");
      }
      return mimeType === validType;
    }));
  }
  return true;
}

function isDragEvent(event) {
  return dragEvents.indexOf(event.type) > 0;
}

function isChangeEvent(event) {
  return event.type === "change";
}

class Frame extends Controller {
  static targets=[ "navigationOverlay", "navigation", "saveBar" ];
  connect() {
    if (!this.hasNavigationTarget) {
      return;
    }
    useTransition(this, {
      element: this.navigationTarget,
      enterFrom: "Polaris-Frame__Navigation--enter",
      enterTo: "Polaris-Frame__Navigation--visible Polaris-Frame__Navigation--enterActive",
      leaveActive: "Polaris-Frame__Navigation--exitActive",
      leaveFrom: "Polaris-Frame__Navigation--exit",
      leaveTo: "",
      removeToClasses: false,
      hiddenClass: false
    });
  }
  openMenu() {
    this.enter();
    this.navigationOverlayTarget.classList.add("Polaris-Backdrop", "Polaris-Backdrop--belowNavigation");
  }
  closeMenu() {
    this.leave();
    this.navigationOverlayTarget.classList.remove("Polaris-Backdrop", "Polaris-Backdrop--belowNavigation");
  }
  showSaveBar() {
    this.saveBarTarget.classList.add("Polaris-Frame-CSSAnimation--endFade");
  }
  hideSaveBar() {
    this.saveBarTarget.classList.remove("Polaris-Frame-CSSAnimation--endFade");
  }
}

class Modal extends Controller {
  static classes=[ "hidden", "backdrop" ];
  static values={
    open: Boolean
  };
  connect() {
    if (this.openValue) {
      this.open();
    }
  }
  open() {
    this.element.classList.remove(this.hiddenClass);
    const dropElement = `<div class="${this.backdropClass}" data-controller="polaris" data-target="#${this.element.id}" data-action="click->polaris#closeModal"></div>`;
    this.element.insertAdjacentHTML("afterend", dropElement);
    this.backdrop = this.element.nextElementSibling;
  }
  close() {
    this.element.classList.add(this.hiddenClass);
    this.backdrop.remove();
  }
}

class OptionList extends Controller {
  static targets=[ "radioButton" ];
  static classes=[ "selected" ];
  connect() {
    this.updateSelected();
  }
  update(event) {
    const target = event.currentTarget;
    target.classList.add(this.selectedClass);
    this.deselectAll(target);
  }
  updateSelected() {
    this.radioButtonTargets.forEach((element => {
      const input = element.querySelector("input[type=radio]");
      if (input.checked) {
        element.classList.add(this.selectedClass);
      } else {
        element.classList.remove(this.selectedClass);
      }
    }));
  }
  deselectAll(target) {
    this.radioButtonTargets.forEach((element => {
      if (!element.isEqualNode(target)) {
        const input = element.querySelector("input[type=radio]");
        input.checked = false;
        element.classList.remove(this.selectedClass);
      }
    }));
  }
}

class Polaris extends Controller {
  openModal() {
    this.findElement("modal").open();
  }
  closeModal() {
    this.findElement("modal").close();
  }
  disableButton() {
    this.findElement("button").disable();
  }
  disableButtonWithoutLoader() {
    this.findElement("button").disableWithoutLoader();
  }
  enableButton() {
    this.findElement("button").enable();
  }
  showToast() {
    this.findElement("toast").show();
  }
  toggleCollapsible() {
    this.findElement("collapsible").toggle();
  }
  findElement(type) {
    const targetId = this.element.dataset.target.replace("#", "");
    const target = document.getElementById(targetId);
    const controllerName = `polaris-${type}`;
    return this.application.getControllerForElementAndIdentifier(target, controllerName);
  }
}

const min = Math.min;

const max = Math.max;

const round = Math.round;

const floor = Math.floor;

const createCoords = v => ({
  x: v,
  y: v
});

const oppositeSideMap = {
  left: "right",
  right: "left",
  bottom: "top",
  top: "bottom"
};

const oppositeAlignmentMap = {
  start: "end",
  end: "start"
};

function clamp(start, value, end) {
  return max(start, min(value, end));
}

function evaluate(value, param) {
  return typeof value === "function" ? value(param) : value;
}

function getSide(placement) {
  return placement.split("-")[0];
}

function getAlignment(placement) {
  return placement.split("-")[1];
}

function getOppositeAxis(axis) {
  return axis === "x" ? "y" : "x";
}

function getAxisLength(axis) {
  return axis === "y" ? "height" : "width";
}

function getSideAxis(placement) {
  return [ "top", "bottom" ].includes(getSide(placement)) ? "y" : "x";
}

function getAlignmentAxis(placement) {
  return getOppositeAxis(getSideAxis(placement));
}

function getAlignmentSides(placement, rects, rtl) {
  if (rtl === void 0) {
    rtl = false;
  }
  const alignment = getAlignment(placement);
  const alignmentAxis = getAlignmentAxis(placement);
  const length = getAxisLength(alignmentAxis);
  let mainAlignmentSide = alignmentAxis === "x" ? alignment === (rtl ? "end" : "start") ? "right" : "left" : alignment === "start" ? "bottom" : "top";
  if (rects.reference[length] > rects.floating[length]) {
    mainAlignmentSide = getOppositePlacement(mainAlignmentSide);
  }
  return [ mainAlignmentSide, getOppositePlacement(mainAlignmentSide) ];
}

function getExpandedPlacements(placement) {
  const oppositePlacement = getOppositePlacement(placement);
  return [ getOppositeAlignmentPlacement(placement), oppositePlacement, getOppositeAlignmentPlacement(oppositePlacement) ];
}

function getOppositeAlignmentPlacement(placement) {
  return placement.replace(/start|end/g, (alignment => oppositeAlignmentMap[alignment]));
}

function getSideList(side, isStart, rtl) {
  const lr = [ "left", "right" ];
  const rl = [ "right", "left" ];
  const tb = [ "top", "bottom" ];
  const bt = [ "bottom", "top" ];
  switch (side) {
   case "top":
   case "bottom":
    if (rtl) return isStart ? rl : lr;
    return isStart ? lr : rl;

   case "left":
   case "right":
    return isStart ? tb : bt;

   default:
    return [];
  }
}

function getOppositeAxisPlacements(placement, flipAlignment, direction, rtl) {
  const alignment = getAlignment(placement);
  let list = getSideList(getSide(placement), direction === "start", rtl);
  if (alignment) {
    list = list.map((side => side + "-" + alignment));
    if (flipAlignment) {
      list = list.concat(list.map(getOppositeAlignmentPlacement));
    }
  }
  return list;
}

function getOppositePlacement(placement) {
  return placement.replace(/left|right|bottom|top/g, (side => oppositeSideMap[side]));
}

function expandPaddingObject(padding) {
  return {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
    ...padding
  };
}

function getPaddingObject(padding) {
  return typeof padding !== "number" ? expandPaddingObject(padding) : {
    top: padding,
    right: padding,
    bottom: padding,
    left: padding
  };
}

function rectToClientRect(rect) {
  return {
    ...rect,
    top: rect.y,
    left: rect.x,
    right: rect.x + rect.width,
    bottom: rect.y + rect.height
  };
}

function computeCoordsFromPlacement(_ref, placement, rtl) {
  let {reference: reference, floating: floating} = _ref;
  const sideAxis = getSideAxis(placement);
  const alignmentAxis = getAlignmentAxis(placement);
  const alignLength = getAxisLength(alignmentAxis);
  const side = getSide(placement);
  const isVertical = sideAxis === "y";
  const commonX = reference.x + reference.width / 2 - floating.width / 2;
  const commonY = reference.y + reference.height / 2 - floating.height / 2;
  const commonAlign = reference[alignLength] / 2 - floating[alignLength] / 2;
  let coords;
  switch (side) {
   case "top":
    coords = {
      x: commonX,
      y: reference.y - floating.height
    };
    break;

   case "bottom":
    coords = {
      x: commonX,
      y: reference.y + reference.height
    };
    break;

   case "right":
    coords = {
      x: reference.x + reference.width,
      y: commonY
    };
    break;

   case "left":
    coords = {
      x: reference.x - floating.width,
      y: commonY
    };
    break;

   default:
    coords = {
      x: reference.x,
      y: reference.y
    };
  }
  switch (getAlignment(placement)) {
   case "start":
    coords[alignmentAxis] -= commonAlign * (rtl && isVertical ? -1 : 1);
    break;

   case "end":
    coords[alignmentAxis] += commonAlign * (rtl && isVertical ? -1 : 1);
    break;
  }
  return coords;
}

const computePosition$1 = async (reference, floating, config) => {
  const {placement: placement = "bottom", strategy: strategy = "absolute", middleware: middleware = [], platform: platform} = config;
  const validMiddleware = middleware.filter(Boolean);
  const rtl = await (platform.isRTL == null ? void 0 : platform.isRTL(floating));
  let rects = await platform.getElementRects({
    reference: reference,
    floating: floating,
    strategy: strategy
  });
  let {x: x, y: y} = computeCoordsFromPlacement(rects, placement, rtl);
  let statefulPlacement = placement;
  let middlewareData = {};
  let resetCount = 0;
  for (let i = 0; i < validMiddleware.length; i++) {
    const {name: name, fn: fn} = validMiddleware[i];
    const {x: nextX, y: nextY, data: data, reset: reset} = await fn({
      x: x,
      y: y,
      initialPlacement: placement,
      placement: statefulPlacement,
      strategy: strategy,
      middlewareData: middlewareData,
      rects: rects,
      platform: platform,
      elements: {
        reference: reference,
        floating: floating
      }
    });
    x = nextX != null ? nextX : x;
    y = nextY != null ? nextY : y;
    middlewareData = {
      ...middlewareData,
      [name]: {
        ...middlewareData[name],
        ...data
      }
    };
    if (reset && resetCount <= 50) {
      resetCount++;
      if (typeof reset === "object") {
        if (reset.placement) {
          statefulPlacement = reset.placement;
        }
        if (reset.rects) {
          rects = reset.rects === true ? await platform.getElementRects({
            reference: reference,
            floating: floating,
            strategy: strategy
          }) : reset.rects;
        }
        ({x: x, y: y} = computeCoordsFromPlacement(rects, statefulPlacement, rtl));
      }
      i = -1;
      continue;
    }
  }
  return {
    x: x,
    y: y,
    placement: statefulPlacement,
    strategy: strategy,
    middlewareData: middlewareData
  };
};

async function detectOverflow(state, options) {
  var _await$platform$isEle;
  if (options === void 0) {
    options = {};
  }
  const {x: x, y: y, platform: platform, rects: rects, elements: elements, strategy: strategy} = state;
  const {boundary: boundary = "clippingAncestors", rootBoundary: rootBoundary = "viewport", elementContext: elementContext = "floating", altBoundary: altBoundary = false, padding: padding = 0} = evaluate(options, state);
  const paddingObject = getPaddingObject(padding);
  const altContext = elementContext === "floating" ? "reference" : "floating";
  const element = elements[altBoundary ? altContext : elementContext];
  const clippingClientRect = rectToClientRect(await platform.getClippingRect({
    element: ((_await$platform$isEle = await (platform.isElement == null ? void 0 : platform.isElement(element))) != null ? _await$platform$isEle : true) ? element : element.contextElement || await (platform.getDocumentElement == null ? void 0 : platform.getDocumentElement(elements.floating)),
    boundary: boundary,
    rootBoundary: rootBoundary,
    strategy: strategy
  }));
  const rect = elementContext === "floating" ? {
    ...rects.floating,
    x: x,
    y: y
  } : rects.reference;
  const offsetParent = await (platform.getOffsetParent == null ? void 0 : platform.getOffsetParent(elements.floating));
  const offsetScale = await (platform.isElement == null ? void 0 : platform.isElement(offsetParent)) ? await (platform.getScale == null ? void 0 : platform.getScale(offsetParent)) || {
    x: 1,
    y: 1
  } : {
    x: 1,
    y: 1
  };
  const elementClientRect = rectToClientRect(platform.convertOffsetParentRelativeRectToViewportRelativeRect ? await platform.convertOffsetParentRelativeRectToViewportRelativeRect({
    rect: rect,
    offsetParent: offsetParent,
    strategy: strategy
  }) : rect);
  return {
    top: (clippingClientRect.top - elementClientRect.top + paddingObject.top) / offsetScale.y,
    bottom: (elementClientRect.bottom - clippingClientRect.bottom + paddingObject.bottom) / offsetScale.y,
    left: (clippingClientRect.left - elementClientRect.left + paddingObject.left) / offsetScale.x,
    right: (elementClientRect.right - clippingClientRect.right + paddingObject.right) / offsetScale.x
  };
}

const arrow = options => ({
  name: "arrow",
  options: options,
  async fn(state) {
    const {x: x, y: y, placement: placement, rects: rects, platform: platform, elements: elements, middlewareData: middlewareData} = state;
    const {element: element, padding: padding = 0} = evaluate(options, state) || {};
    if (element == null) {
      return {};
    }
    const paddingObject = getPaddingObject(padding);
    const coords = {
      x: x,
      y: y
    };
    const axis = getAlignmentAxis(placement);
    const length = getAxisLength(axis);
    const arrowDimensions = await platform.getDimensions(element);
    const isYAxis = axis === "y";
    const minProp = isYAxis ? "top" : "left";
    const maxProp = isYAxis ? "bottom" : "right";
    const clientProp = isYAxis ? "clientHeight" : "clientWidth";
    const endDiff = rects.reference[length] + rects.reference[axis] - coords[axis] - rects.floating[length];
    const startDiff = coords[axis] - rects.reference[axis];
    const arrowOffsetParent = await (platform.getOffsetParent == null ? void 0 : platform.getOffsetParent(element));
    let clientSize = arrowOffsetParent ? arrowOffsetParent[clientProp] : 0;
    if (!clientSize || !await (platform.isElement == null ? void 0 : platform.isElement(arrowOffsetParent))) {
      clientSize = elements.floating[clientProp] || rects.floating[length];
    }
    const centerToReference = endDiff / 2 - startDiff / 2;
    const largestPossiblePadding = clientSize / 2 - arrowDimensions[length] / 2 - 1;
    const minPadding = min(paddingObject[minProp], largestPossiblePadding);
    const maxPadding = min(paddingObject[maxProp], largestPossiblePadding);
    const min$1 = minPadding;
    const max = clientSize - arrowDimensions[length] - maxPadding;
    const center = clientSize / 2 - arrowDimensions[length] / 2 + centerToReference;
    const offset = clamp(min$1, center, max);
    const shouldAddOffset = !middlewareData.arrow && getAlignment(placement) != null && center != offset && rects.reference[length] / 2 - (center < min$1 ? minPadding : maxPadding) - arrowDimensions[length] / 2 < 0;
    const alignmentOffset = shouldAddOffset ? center < min$1 ? center - min$1 : center - max : 0;
    return {
      [axis]: coords[axis] + alignmentOffset,
      data: {
        [axis]: offset,
        centerOffset: center - offset - alignmentOffset,
        ...shouldAddOffset && {
          alignmentOffset: alignmentOffset
        }
      },
      reset: shouldAddOffset
    };
  }
});

const flip = function(options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: "flip",
    options: options,
    async fn(state) {
      var _middlewareData$arrow, _middlewareData$flip;
      const {placement: placement, middlewareData: middlewareData, rects: rects, initialPlacement: initialPlacement, platform: platform, elements: elements} = state;
      const {mainAxis: checkMainAxis = true, crossAxis: checkCrossAxis = true, fallbackPlacements: specifiedFallbackPlacements, fallbackStrategy: fallbackStrategy = "bestFit", fallbackAxisSideDirection: fallbackAxisSideDirection = "none", flipAlignment: flipAlignment = true, ...detectOverflowOptions} = evaluate(options, state);
      if ((_middlewareData$arrow = middlewareData.arrow) != null && _middlewareData$arrow.alignmentOffset) {
        return {};
      }
      const side = getSide(placement);
      const isBasePlacement = getSide(initialPlacement) === initialPlacement;
      const rtl = await (platform.isRTL == null ? void 0 : platform.isRTL(elements.floating));
      const fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipAlignment ? [ getOppositePlacement(initialPlacement) ] : getExpandedPlacements(initialPlacement));
      if (!specifiedFallbackPlacements && fallbackAxisSideDirection !== "none") {
        fallbackPlacements.push(...getOppositeAxisPlacements(initialPlacement, flipAlignment, fallbackAxisSideDirection, rtl));
      }
      const placements = [ initialPlacement, ...fallbackPlacements ];
      const overflow = await detectOverflow(state, detectOverflowOptions);
      const overflows = [];
      let overflowsData = ((_middlewareData$flip = middlewareData.flip) == null ? void 0 : _middlewareData$flip.overflows) || [];
      if (checkMainAxis) {
        overflows.push(overflow[side]);
      }
      if (checkCrossAxis) {
        const sides = getAlignmentSides(placement, rects, rtl);
        overflows.push(overflow[sides[0]], overflow[sides[1]]);
      }
      overflowsData = [ ...overflowsData, {
        placement: placement,
        overflows: overflows
      } ];
      if (!overflows.every((side => side <= 0))) {
        var _middlewareData$flip2, _overflowsData$filter;
        const nextIndex = (((_middlewareData$flip2 = middlewareData.flip) == null ? void 0 : _middlewareData$flip2.index) || 0) + 1;
        const nextPlacement = placements[nextIndex];
        if (nextPlacement) {
          return {
            data: {
              index: nextIndex,
              overflows: overflowsData
            },
            reset: {
              placement: nextPlacement
            }
          };
        }
        let resetPlacement = (_overflowsData$filter = overflowsData.filter((d => d.overflows[0] <= 0)).sort(((a, b) => a.overflows[1] - b.overflows[1]))[0]) == null ? void 0 : _overflowsData$filter.placement;
        if (!resetPlacement) {
          switch (fallbackStrategy) {
           case "bestFit":
            {
              var _overflowsData$map$so;
              const placement = (_overflowsData$map$so = overflowsData.map((d => [ d.placement, d.overflows.filter((overflow => overflow > 0)).reduce(((acc, overflow) => acc + overflow), 0) ])).sort(((a, b) => a[1] - b[1]))[0]) == null ? void 0 : _overflowsData$map$so[0];
              if (placement) {
                resetPlacement = placement;
              }
              break;
            }

           case "initialPlacement":
            resetPlacement = initialPlacement;
            break;
          }
        }
        if (placement !== resetPlacement) {
          return {
            reset: {
              placement: resetPlacement
            }
          };
        }
      }
      return {};
    }
  };
};

async function convertValueToCoords(state, options) {
  const {placement: placement, platform: platform, elements: elements} = state;
  const rtl = await (platform.isRTL == null ? void 0 : platform.isRTL(elements.floating));
  const side = getSide(placement);
  const alignment = getAlignment(placement);
  const isVertical = getSideAxis(placement) === "y";
  const mainAxisMulti = [ "left", "top" ].includes(side) ? -1 : 1;
  const crossAxisMulti = rtl && isVertical ? -1 : 1;
  const rawValue = evaluate(options, state);
  let {mainAxis: mainAxis, crossAxis: crossAxis, alignmentAxis: alignmentAxis} = typeof rawValue === "number" ? {
    mainAxis: rawValue,
    crossAxis: 0,
    alignmentAxis: null
  } : {
    mainAxis: 0,
    crossAxis: 0,
    alignmentAxis: null,
    ...rawValue
  };
  if (alignment && typeof alignmentAxis === "number") {
    crossAxis = alignment === "end" ? alignmentAxis * -1 : alignmentAxis;
  }
  return isVertical ? {
    x: crossAxis * crossAxisMulti,
    y: mainAxis * mainAxisMulti
  } : {
    x: mainAxis * mainAxisMulti,
    y: crossAxis * crossAxisMulti
  };
}

const offset = function(options) {
  if (options === void 0) {
    options = 0;
  }
  return {
    name: "offset",
    options: options,
    async fn(state) {
      const {x: x, y: y} = state;
      const diffCoords = await convertValueToCoords(state, options);
      return {
        x: x + diffCoords.x,
        y: y + diffCoords.y,
        data: diffCoords
      };
    }
  };
};

const shift = function(options) {
  if (options === void 0) {
    options = {};
  }
  return {
    name: "shift",
    options: options,
    async fn(state) {
      const {x: x, y: y, placement: placement} = state;
      const {mainAxis: checkMainAxis = true, crossAxis: checkCrossAxis = false, limiter: limiter = {
        fn: _ref => {
          let {x: x, y: y} = _ref;
          return {
            x: x,
            y: y
          };
        }
      }, ...detectOverflowOptions} = evaluate(options, state);
      const coords = {
        x: x,
        y: y
      };
      const overflow = await detectOverflow(state, detectOverflowOptions);
      const crossAxis = getSideAxis(getSide(placement));
      const mainAxis = getOppositeAxis(crossAxis);
      let mainAxisCoord = coords[mainAxis];
      let crossAxisCoord = coords[crossAxis];
      if (checkMainAxis) {
        const minSide = mainAxis === "y" ? "top" : "left";
        const maxSide = mainAxis === "y" ? "bottom" : "right";
        const min = mainAxisCoord + overflow[minSide];
        const max = mainAxisCoord - overflow[maxSide];
        mainAxisCoord = clamp(min, mainAxisCoord, max);
      }
      if (checkCrossAxis) {
        const minSide = crossAxis === "y" ? "top" : "left";
        const maxSide = crossAxis === "y" ? "bottom" : "right";
        const min = crossAxisCoord + overflow[minSide];
        const max = crossAxisCoord - overflow[maxSide];
        crossAxisCoord = clamp(min, crossAxisCoord, max);
      }
      const limitedCoords = limiter.fn({
        ...state,
        [mainAxis]: mainAxisCoord,
        [crossAxis]: crossAxisCoord
      });
      return {
        ...limitedCoords,
        data: {
          x: limitedCoords.x - x,
          y: limitedCoords.y - y
        }
      };
    }
  };
};

function getNodeName(node) {
  if (isNode(node)) {
    return (node.nodeName || "").toLowerCase();
  }
  return "#document";
}

function getWindow(node) {
  var _node$ownerDocument;
  return (node == null ? void 0 : (_node$ownerDocument = node.ownerDocument) == null ? void 0 : _node$ownerDocument.defaultView) || window;
}

function getDocumentElement(node) {
  var _ref;
  return (_ref = (isNode(node) ? node.ownerDocument : node.document) || window.document) == null ? void 0 : _ref.documentElement;
}

function isNode(value) {
  return value instanceof Node || value instanceof getWindow(value).Node;
}

function isElement(value) {
  return value instanceof Element || value instanceof getWindow(value).Element;
}

function isHTMLElement(value) {
  return value instanceof HTMLElement || value instanceof getWindow(value).HTMLElement;
}

function isShadowRoot(value) {
  if (typeof ShadowRoot === "undefined") {
    return false;
  }
  return value instanceof ShadowRoot || value instanceof getWindow(value).ShadowRoot;
}

function isOverflowElement(element) {
  const {overflow: overflow, overflowX: overflowX, overflowY: overflowY, display: display} = getComputedStyle$1(element);
  return /auto|scroll|overlay|hidden|clip/.test(overflow + overflowY + overflowX) && ![ "inline", "contents" ].includes(display);
}

function isTableElement(element) {
  return [ "table", "td", "th" ].includes(getNodeName(element));
}

function isContainingBlock(element) {
  const webkit = isWebKit();
  const css = getComputedStyle$1(element);
  return css.transform !== "none" || css.perspective !== "none" || (css.containerType ? css.containerType !== "normal" : false) || !webkit && (css.backdropFilter ? css.backdropFilter !== "none" : false) || !webkit && (css.filter ? css.filter !== "none" : false) || [ "transform", "perspective", "filter" ].some((value => (css.willChange || "").includes(value))) || [ "paint", "layout", "strict", "content" ].some((value => (css.contain || "").includes(value)));
}

function getContainingBlock(element) {
  let currentNode = getParentNode(element);
  while (isHTMLElement(currentNode) && !isLastTraversableNode(currentNode)) {
    if (isContainingBlock(currentNode)) {
      return currentNode;
    } else {
      currentNode = getParentNode(currentNode);
    }
  }
  return null;
}

function isWebKit() {
  if (typeof CSS === "undefined" || !CSS.supports) return false;
  return CSS.supports("-webkit-backdrop-filter", "none");
}

function isLastTraversableNode(node) {
  return [ "html", "body", "#document" ].includes(getNodeName(node));
}

function getComputedStyle$1(element) {
  return getWindow(element).getComputedStyle(element);
}

function getNodeScroll(element) {
  if (isElement(element)) {
    return {
      scrollLeft: element.scrollLeft,
      scrollTop: element.scrollTop
    };
  }
  return {
    scrollLeft: element.pageXOffset,
    scrollTop: element.pageYOffset
  };
}

function getParentNode(node) {
  if (getNodeName(node) === "html") {
    return node;
  }
  const result = node.assignedSlot || node.parentNode || isShadowRoot(node) && node.host || getDocumentElement(node);
  return isShadowRoot(result) ? result.host : result;
}

function getNearestOverflowAncestor(node) {
  const parentNode = getParentNode(node);
  if (isLastTraversableNode(parentNode)) {
    return node.ownerDocument ? node.ownerDocument.body : node.body;
  }
  if (isHTMLElement(parentNode) && isOverflowElement(parentNode)) {
    return parentNode;
  }
  return getNearestOverflowAncestor(parentNode);
}

function getOverflowAncestors(node, list, traverseIframes) {
  var _node$ownerDocument2;
  if (list === void 0) {
    list = [];
  }
  if (traverseIframes === void 0) {
    traverseIframes = true;
  }
  const scrollableAncestor = getNearestOverflowAncestor(node);
  const isBody = scrollableAncestor === ((_node$ownerDocument2 = node.ownerDocument) == null ? void 0 : _node$ownerDocument2.body);
  const win = getWindow(scrollableAncestor);
  if (isBody) {
    return list.concat(win, win.visualViewport || [], isOverflowElement(scrollableAncestor) ? scrollableAncestor : [], win.frameElement && traverseIframes ? getOverflowAncestors(win.frameElement) : []);
  }
  return list.concat(scrollableAncestor, getOverflowAncestors(scrollableAncestor, [], traverseIframes));
}

function getCssDimensions(element) {
  const css = getComputedStyle$1(element);
  let width = parseFloat(css.width) || 0;
  let height = parseFloat(css.height) || 0;
  const hasOffset = isHTMLElement(element);
  const offsetWidth = hasOffset ? element.offsetWidth : width;
  const offsetHeight = hasOffset ? element.offsetHeight : height;
  const shouldFallback = round(width) !== offsetWidth || round(height) !== offsetHeight;
  if (shouldFallback) {
    width = offsetWidth;
    height = offsetHeight;
  }
  return {
    width: width,
    height: height,
    $: shouldFallback
  };
}

function unwrapElement(element) {
  return !isElement(element) ? element.contextElement : element;
}

function getScale(element) {
  const domElement = unwrapElement(element);
  if (!isHTMLElement(domElement)) {
    return createCoords(1);
  }
  const rect = domElement.getBoundingClientRect();
  const {width: width, height: height, $: $} = getCssDimensions(domElement);
  let x = ($ ? round(rect.width) : rect.width) / width;
  let y = ($ ? round(rect.height) : rect.height) / height;
  if (!x || !Number.isFinite(x)) {
    x = 1;
  }
  if (!y || !Number.isFinite(y)) {
    y = 1;
  }
  return {
    x: x,
    y: y
  };
}

const noOffsets = createCoords(0);

function getVisualOffsets(element) {
  const win = getWindow(element);
  if (!isWebKit() || !win.visualViewport) {
    return noOffsets;
  }
  return {
    x: win.visualViewport.offsetLeft,
    y: win.visualViewport.offsetTop
  };
}

function shouldAddVisualOffsets(element, isFixed, floatingOffsetParent) {
  if (isFixed === void 0) {
    isFixed = false;
  }
  if (!floatingOffsetParent || isFixed && floatingOffsetParent !== getWindow(element)) {
    return false;
  }
  return isFixed;
}

function getBoundingClientRect(element, includeScale, isFixedStrategy, offsetParent) {
  if (includeScale === void 0) {
    includeScale = false;
  }
  if (isFixedStrategy === void 0) {
    isFixedStrategy = false;
  }
  const clientRect = element.getBoundingClientRect();
  const domElement = unwrapElement(element);
  let scale = createCoords(1);
  if (includeScale) {
    if (offsetParent) {
      if (isElement(offsetParent)) {
        scale = getScale(offsetParent);
      }
    } else {
      scale = getScale(element);
    }
  }
  const visualOffsets = shouldAddVisualOffsets(domElement, isFixedStrategy, offsetParent) ? getVisualOffsets(domElement) : createCoords(0);
  let x = (clientRect.left + visualOffsets.x) / scale.x;
  let y = (clientRect.top + visualOffsets.y) / scale.y;
  let width = clientRect.width / scale.x;
  let height = clientRect.height / scale.y;
  if (domElement) {
    const win = getWindow(domElement);
    const offsetWin = offsetParent && isElement(offsetParent) ? getWindow(offsetParent) : offsetParent;
    let currentIFrame = win.frameElement;
    while (currentIFrame && offsetParent && offsetWin !== win) {
      const iframeScale = getScale(currentIFrame);
      const iframeRect = currentIFrame.getBoundingClientRect();
      const css = getComputedStyle$1(currentIFrame);
      const left = iframeRect.left + (currentIFrame.clientLeft + parseFloat(css.paddingLeft)) * iframeScale.x;
      const top = iframeRect.top + (currentIFrame.clientTop + parseFloat(css.paddingTop)) * iframeScale.y;
      x *= iframeScale.x;
      y *= iframeScale.y;
      width *= iframeScale.x;
      height *= iframeScale.y;
      x += left;
      y += top;
      currentIFrame = getWindow(currentIFrame).frameElement;
    }
  }
  return rectToClientRect({
    width: width,
    height: height,
    x: x,
    y: y
  });
}

function convertOffsetParentRelativeRectToViewportRelativeRect(_ref) {
  let {rect: rect, offsetParent: offsetParent, strategy: strategy} = _ref;
  const isOffsetParentAnElement = isHTMLElement(offsetParent);
  const documentElement = getDocumentElement(offsetParent);
  if (offsetParent === documentElement) {
    return rect;
  }
  let scroll = {
    scrollLeft: 0,
    scrollTop: 0
  };
  let scale = createCoords(1);
  const offsets = createCoords(0);
  if (isOffsetParentAnElement || !isOffsetParentAnElement && strategy !== "fixed") {
    if (getNodeName(offsetParent) !== "body" || isOverflowElement(documentElement)) {
      scroll = getNodeScroll(offsetParent);
    }
    if (isHTMLElement(offsetParent)) {
      const offsetRect = getBoundingClientRect(offsetParent);
      scale = getScale(offsetParent);
      offsets.x = offsetRect.x + offsetParent.clientLeft;
      offsets.y = offsetRect.y + offsetParent.clientTop;
    }
  }
  return {
    width: rect.width * scale.x,
    height: rect.height * scale.y,
    x: rect.x * scale.x - scroll.scrollLeft * scale.x + offsets.x,
    y: rect.y * scale.y - scroll.scrollTop * scale.y + offsets.y
  };
}

function getClientRects(element) {
  return Array.from(element.getClientRects());
}

function getWindowScrollBarX(element) {
  return getBoundingClientRect(getDocumentElement(element)).left + getNodeScroll(element).scrollLeft;
}

function getDocumentRect(element) {
  const html = getDocumentElement(element);
  const scroll = getNodeScroll(element);
  const body = element.ownerDocument.body;
  const width = max(html.scrollWidth, html.clientWidth, body.scrollWidth, body.clientWidth);
  const height = max(html.scrollHeight, html.clientHeight, body.scrollHeight, body.clientHeight);
  let x = -scroll.scrollLeft + getWindowScrollBarX(element);
  const y = -scroll.scrollTop;
  if (getComputedStyle$1(body).direction === "rtl") {
    x += max(html.clientWidth, body.clientWidth) - width;
  }
  return {
    width: width,
    height: height,
    x: x,
    y: y
  };
}

function getViewportRect(element, strategy) {
  const win = getWindow(element);
  const html = getDocumentElement(element);
  const visualViewport = win.visualViewport;
  let width = html.clientWidth;
  let height = html.clientHeight;
  let x = 0;
  let y = 0;
  if (visualViewport) {
    width = visualViewport.width;
    height = visualViewport.height;
    const visualViewportBased = isWebKit();
    if (!visualViewportBased || visualViewportBased && strategy === "fixed") {
      x = visualViewport.offsetLeft;
      y = visualViewport.offsetTop;
    }
  }
  return {
    width: width,
    height: height,
    x: x,
    y: y
  };
}

function getInnerBoundingClientRect(element, strategy) {
  const clientRect = getBoundingClientRect(element, true, strategy === "fixed");
  const top = clientRect.top + element.clientTop;
  const left = clientRect.left + element.clientLeft;
  const scale = isHTMLElement(element) ? getScale(element) : createCoords(1);
  const width = element.clientWidth * scale.x;
  const height = element.clientHeight * scale.y;
  const x = left * scale.x;
  const y = top * scale.y;
  return {
    width: width,
    height: height,
    x: x,
    y: y
  };
}

function getClientRectFromClippingAncestor(element, clippingAncestor, strategy) {
  let rect;
  if (clippingAncestor === "viewport") {
    rect = getViewportRect(element, strategy);
  } else if (clippingAncestor === "document") {
    rect = getDocumentRect(getDocumentElement(element));
  } else if (isElement(clippingAncestor)) {
    rect = getInnerBoundingClientRect(clippingAncestor, strategy);
  } else {
    const visualOffsets = getVisualOffsets(element);
    rect = {
      ...clippingAncestor,
      x: clippingAncestor.x - visualOffsets.x,
      y: clippingAncestor.y - visualOffsets.y
    };
  }
  return rectToClientRect(rect);
}

function hasFixedPositionAncestor(element, stopNode) {
  const parentNode = getParentNode(element);
  if (parentNode === stopNode || !isElement(parentNode) || isLastTraversableNode(parentNode)) {
    return false;
  }
  return getComputedStyle$1(parentNode).position === "fixed" || hasFixedPositionAncestor(parentNode, stopNode);
}

function getClippingElementAncestors(element, cache) {
  const cachedResult = cache.get(element);
  if (cachedResult) {
    return cachedResult;
  }
  let result = getOverflowAncestors(element, [], false).filter((el => isElement(el) && getNodeName(el) !== "body"));
  let currentContainingBlockComputedStyle = null;
  const elementIsFixed = getComputedStyle$1(element).position === "fixed";
  let currentNode = elementIsFixed ? getParentNode(element) : element;
  while (isElement(currentNode) && !isLastTraversableNode(currentNode)) {
    const computedStyle = getComputedStyle$1(currentNode);
    const currentNodeIsContaining = isContainingBlock(currentNode);
    if (!currentNodeIsContaining && computedStyle.position === "fixed") {
      currentContainingBlockComputedStyle = null;
    }
    const shouldDropCurrentNode = elementIsFixed ? !currentNodeIsContaining && !currentContainingBlockComputedStyle : !currentNodeIsContaining && computedStyle.position === "static" && !!currentContainingBlockComputedStyle && [ "absolute", "fixed" ].includes(currentContainingBlockComputedStyle.position) || isOverflowElement(currentNode) && !currentNodeIsContaining && hasFixedPositionAncestor(element, currentNode);
    if (shouldDropCurrentNode) {
      result = result.filter((ancestor => ancestor !== currentNode));
    } else {
      currentContainingBlockComputedStyle = computedStyle;
    }
    currentNode = getParentNode(currentNode);
  }
  cache.set(element, result);
  return result;
}

function getClippingRect(_ref) {
  let {element: element, boundary: boundary, rootBoundary: rootBoundary, strategy: strategy} = _ref;
  const elementClippingAncestors = boundary === "clippingAncestors" ? getClippingElementAncestors(element, this._c) : [].concat(boundary);
  const clippingAncestors = [ ...elementClippingAncestors, rootBoundary ];
  const firstClippingAncestor = clippingAncestors[0];
  const clippingRect = clippingAncestors.reduce(((accRect, clippingAncestor) => {
    const rect = getClientRectFromClippingAncestor(element, clippingAncestor, strategy);
    accRect.top = max(rect.top, accRect.top);
    accRect.right = min(rect.right, accRect.right);
    accRect.bottom = min(rect.bottom, accRect.bottom);
    accRect.left = max(rect.left, accRect.left);
    return accRect;
  }), getClientRectFromClippingAncestor(element, firstClippingAncestor, strategy));
  return {
    width: clippingRect.right - clippingRect.left,
    height: clippingRect.bottom - clippingRect.top,
    x: clippingRect.left,
    y: clippingRect.top
  };
}

function getDimensions(element) {
  return getCssDimensions(element);
}

function getRectRelativeToOffsetParent(element, offsetParent, strategy) {
  const isOffsetParentAnElement = isHTMLElement(offsetParent);
  const documentElement = getDocumentElement(offsetParent);
  const isFixed = strategy === "fixed";
  const rect = getBoundingClientRect(element, true, isFixed, offsetParent);
  let scroll = {
    scrollLeft: 0,
    scrollTop: 0
  };
  const offsets = createCoords(0);
  if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
    if (getNodeName(offsetParent) !== "body" || isOverflowElement(documentElement)) {
      scroll = getNodeScroll(offsetParent);
    }
    if (isOffsetParentAnElement) {
      const offsetRect = getBoundingClientRect(offsetParent, true, isFixed, offsetParent);
      offsets.x = offsetRect.x + offsetParent.clientLeft;
      offsets.y = offsetRect.y + offsetParent.clientTop;
    } else if (documentElement) {
      offsets.x = getWindowScrollBarX(documentElement);
    }
  }
  return {
    x: rect.left + scroll.scrollLeft - offsets.x,
    y: rect.top + scroll.scrollTop - offsets.y,
    width: rect.width,
    height: rect.height
  };
}

function getTrueOffsetParent(element, polyfill) {
  if (!isHTMLElement(element) || getComputedStyle$1(element).position === "fixed") {
    return null;
  }
  if (polyfill) {
    return polyfill(element);
  }
  return element.offsetParent;
}

function getOffsetParent(element, polyfill) {
  const window = getWindow(element);
  if (!isHTMLElement(element)) {
    return window;
  }
  let offsetParent = getTrueOffsetParent(element, polyfill);
  while (offsetParent && isTableElement(offsetParent) && getComputedStyle$1(offsetParent).position === "static") {
    offsetParent = getTrueOffsetParent(offsetParent, polyfill);
  }
  if (offsetParent && (getNodeName(offsetParent) === "html" || getNodeName(offsetParent) === "body" && getComputedStyle$1(offsetParent).position === "static" && !isContainingBlock(offsetParent))) {
    return window;
  }
  return offsetParent || getContainingBlock(element) || window;
}

const getElementRects = async function(_ref) {
  let {reference: reference, floating: floating, strategy: strategy} = _ref;
  const getOffsetParentFn = this.getOffsetParent || getOffsetParent;
  const getDimensionsFn = this.getDimensions;
  return {
    reference: getRectRelativeToOffsetParent(reference, await getOffsetParentFn(floating), strategy),
    floating: {
      x: 0,
      y: 0,
      ...await getDimensionsFn(floating)
    }
  };
};

function isRTL(element) {
  return getComputedStyle$1(element).direction === "rtl";
}

const platform = {
  convertOffsetParentRelativeRectToViewportRelativeRect: convertOffsetParentRelativeRectToViewportRelativeRect,
  getDocumentElement: getDocumentElement,
  getClippingRect: getClippingRect,
  getOffsetParent: getOffsetParent,
  getElementRects: getElementRects,
  getClientRects: getClientRects,
  getDimensions: getDimensions,
  getScale: getScale,
  isElement: isElement,
  isRTL: isRTL
};

function observeMove(element, onMove) {
  let io = null;
  let timeoutId;
  const root = getDocumentElement(element);
  function cleanup() {
    clearTimeout(timeoutId);
    io && io.disconnect();
    io = null;
  }
  function refresh(skip, threshold) {
    if (skip === void 0) {
      skip = false;
    }
    if (threshold === void 0) {
      threshold = 1;
    }
    cleanup();
    const {left: left, top: top, width: width, height: height} = element.getBoundingClientRect();
    if (!skip) {
      onMove();
    }
    if (!width || !height) {
      return;
    }
    const insetTop = floor(top);
    const insetRight = floor(root.clientWidth - (left + width));
    const insetBottom = floor(root.clientHeight - (top + height));
    const insetLeft = floor(left);
    const rootMargin = -insetTop + "px " + -insetRight + "px " + -insetBottom + "px " + -insetLeft + "px";
    const options = {
      rootMargin: rootMargin,
      threshold: max(0, min(1, threshold)) || 1
    };
    let isFirstUpdate = true;
    function handleObserve(entries) {
      const ratio = entries[0].intersectionRatio;
      if (ratio !== threshold) {
        if (!isFirstUpdate) {
          return refresh();
        }
        if (!ratio) {
          timeoutId = setTimeout((() => {
            refresh(false, 1e-7);
          }), 100);
        } else {
          refresh(false, ratio);
        }
      }
      isFirstUpdate = false;
    }
    try {
      io = new IntersectionObserver(handleObserve, {
        ...options,
        root: root.ownerDocument
      });
    } catch (e) {
      io = new IntersectionObserver(handleObserve, options);
    }
    io.observe(element);
  }
  refresh(true);
  return cleanup;
}

function autoUpdate(reference, floating, update, options) {
  if (options === void 0) {
    options = {};
  }
  const {ancestorScroll: ancestorScroll = true, ancestorResize: ancestorResize = true, elementResize: elementResize = typeof ResizeObserver === "function", layoutShift: layoutShift = typeof IntersectionObserver === "function", animationFrame: animationFrame = false} = options;
  const referenceEl = unwrapElement(reference);
  const ancestors = ancestorScroll || ancestorResize ? [ ...referenceEl ? getOverflowAncestors(referenceEl) : [], ...getOverflowAncestors(floating) ] : [];
  ancestors.forEach((ancestor => {
    ancestorScroll && ancestor.addEventListener("scroll", update, {
      passive: true
    });
    ancestorResize && ancestor.addEventListener("resize", update);
  }));
  const cleanupIo = referenceEl && layoutShift ? observeMove(referenceEl, update) : null;
  let reobserveFrame = -1;
  let resizeObserver = null;
  if (elementResize) {
    resizeObserver = new ResizeObserver((_ref => {
      let [firstEntry] = _ref;
      if (firstEntry && firstEntry.target === referenceEl && resizeObserver) {
        resizeObserver.unobserve(floating);
        cancelAnimationFrame(reobserveFrame);
        reobserveFrame = requestAnimationFrame((() => {
          resizeObserver && resizeObserver.observe(floating);
        }));
      }
      update();
    }));
    if (referenceEl && !animationFrame) {
      resizeObserver.observe(referenceEl);
    }
    resizeObserver.observe(floating);
  }
  let frameId;
  let prevRefRect = animationFrame ? getBoundingClientRect(reference) : null;
  if (animationFrame) {
    frameLoop();
  }
  function frameLoop() {
    const nextRefRect = getBoundingClientRect(reference);
    if (prevRefRect && (nextRefRect.x !== prevRefRect.x || nextRefRect.y !== prevRefRect.y || nextRefRect.width !== prevRefRect.width || nextRefRect.height !== prevRefRect.height)) {
      update();
    }
    prevRefRect = nextRefRect;
    frameId = requestAnimationFrame(frameLoop);
  }
  update();
  return () => {
    ancestors.forEach((ancestor => {
      ancestorScroll && ancestor.removeEventListener("scroll", update);
      ancestorResize && ancestor.removeEventListener("resize", update);
    }));
    cleanupIo && cleanupIo();
    resizeObserver && resizeObserver.disconnect();
    resizeObserver = null;
    if (animationFrame) {
      cancelAnimationFrame(frameId);
    }
  };
}

const computePosition = (reference, floating, options) => {
  const cache = new Map;
  const mergedOptions = {
    platform: platform,
    ...options
  };
  const platformWithCache = {
    ...mergedOptions.platform,
    _c: cache
  };
  return computePosition$1(reference, floating, {
    ...mergedOptions,
    platform: platformWithCache
  });
};

class Popover extends Controller {
  static targets=[ "activator", "popover", "template" ];
  static classes=[ "open", "closed" ];
  static values={
    appendToBody: Boolean,
    placement: String,
    active: Boolean,
    textFieldActivator: Boolean
  };
  connect() {
    if (this.appendToBodyValue) {
      const clonedTemplate = this.templateTarget.content.cloneNode(true);
      this.target = clonedTemplate.firstElementChild;
      document.body.appendChild(clonedTemplate);
    }
    this.target.style.display = "none";
    if (this.activeValue) {
      this.show();
    }
  }
  disconnect() {
    if (this.cleanup) {
      this.cleanup();
    }
  }
  updatePosition() {
    if (this.cleanup) {
      this.cleanup();
    }
    this.cleanup = autoUpdate(this.activator, this.target, (() => {
      computePosition(this.activator, this.target, {
        placement: this.placementValue,
        middleware: [ offset(5), flip(), shift({
          padding: 5
        }) ]
      }).then((({x: x, y: y}) => {
        Object.assign(this.target.style, {
          left: `${x}px`,
          top: `${y}px`
        });
      }));
    }));
  }
  toggle() {
    if (this.target.classList.contains(this.openClass)) {
      this.forceHide();
    } else {
      this.show();
    }
  }
  show() {
    this.target.style.display = "block";
    this.target.classList.remove(this.closedClass);
    this.target.classList.add(this.openClass);
    this.updatePosition();
  }
  hide(event) {
    if (this.element.contains(event.target)) return;
    if (this.target.classList.contains(this.closedClass)) return;
    if (this.appendToBodyValue && this.target.contains(event.target)) return;
    this.forceHide();
  }
  forceHide() {
    this.target.style.display = "none";
    this.target.classList.remove(this.openClass);
    this.target.classList.add(this.closedClass);
  }
  get activator() {
    if (this.textFieldActivatorValue) {
      return this.activatorTarget.querySelector('[data-controller="polaris-text-field"]');
    } else {
      return this.activatorTarget;
    }
  }
  get target() {
    if (this.hasPopoverTarget) {
      return this.popoverTarget;
    } else {
      return this._target;
    }
  }
  set target(value) {
    this._target = value;
  }
}

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

class Scrollable extends Controller {
  static targets=[ "topEdge", "bottomEdge" ];
  static classes=[ "topShadow", "bottomShadow" ];
  static values={
    shadow: Boolean
  };
  initialize() {
    this.topEdgeReached = false;
    this.bottomEdgeReached = true;
  }
  connect() {
    if (this.shadowValue) {
      this.observer = new IntersectionObserver(this.handleIntersection);
      this.observer.observe(this.topEdgeTarget);
      this.observer.observe(this.bottomEdgeTarget);
    }
  }
  disconnect() {
    if (this.shadowValue) {
      this.observer.disconnect();
    }
  }
  handleIntersection=entries => {
    entries.forEach((entry => {
      const target = entry.target.dataset.polarisScrollableTarget;
      switch (target) {
       case "topEdge":
        this.topEdgeReached = entry.isIntersecting;
        break;

       case "bottomEdge":
        this.bottomEdgeReached = entry.isIntersecting;
        break;
      }
    }));
    this.updateShadows();
  };
  updateShadows() {
    if (!this.topEdgeReached && !this.bottomEdgeReached) {
      this.element.classList.add(this.topShadowClass, this.bottomShadowClass);
    } else if (this.topEdgeReached && this.bottomEdgeReached) {
      this.element.classList.remove(this.topShadowClass, this.bottomShadowClass);
    } else if (this.topEdgeReached) {
      this.element.classList.remove(this.topShadowClass);
      this.element.classList.add(this.bottomShadowClass);
    } else if (this.bottomEdgeReached) {
      this.element.classList.add(this.topShadowClass);
      this.element.classList.remove(this.bottomShadowClass);
    }
  }
}

class Select extends Controller {
  static targets=[ "select", "selectedOption" ];
  connect() {
    this.update();
  }
  update() {
    const option = this.selectTarget.options[this.selectTarget.selectedIndex];
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
    const oldValue = this.value;
    this.value = null;
    if (this.value != oldValue) {
      this.inputTarget.dispatchEvent(new Event("change"));
    }
  }
  clearErrorMessages() {
    const wrapper = this.inputTarget.parentElement;
    const inlineError = this.inputTarget.closest(".polaris-text-field-wrapper").querySelector(".Polaris-InlineError");
    if (wrapper) {
      wrapper.classList.remove("Polaris-TextField--error");
    }
    if (inlineError) {
      inlineError.remove();
    }
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
    const oldValue = this.value;
    const newValue = Math.min(Number(this.maxValue), Math.max(numericValue + steps * this.stepValue, Number(this.minValue)));
    this.value = String(newValue.toFixed(decimalPlaces));
    if (this.value != oldValue) {
      this.inputTarget.dispatchEvent(new Event("change"));
    }
  }
}

class Toast extends Controller {
  static activeClass="Polaris-Frame-ToastManager--toastWrapperEnterDone";
  static defaultDuration=5e3;
  static defaultDurationWithAction=1e4;
  static values={
    hidden: Boolean,
    duration: Number,
    hasAction: Boolean
  };
  connect() {
    if (!this.hiddenValue) {
      this.show();
    }
  }
  show=() => {
    this.element.dataset.position = this.position;
    this.element.style.cssText = this.getStyle(this.position);
    this.element.classList.add(this.constructor.activeClass);
    setTimeout(this.close, this.timeoutDuration);
  };
  close=() => {
    this.element.classList.remove(this.constructor.activeClass);
    this.element.addEventListener("transitionend", this.updatePositions, false);
  };
  updatePositions=() => {
    this.visibleToasts.sort(((a, b) => parseInt(a.dataset.position) - parseInt(b.dataset.position))).forEach(((toast, index) => {
      const position = index + 1;
      toast.dataset.position = position;
      toast.style.cssText = this.getStyle(position);
    }));
    this.element.removeEventListener("transitionend", this.updatePositions, false);
  };
  getStyle(position) {
    const height = this.element.offsetHeight + this.heightOffset;
    const translateIn = height * -1;
    const translateOut = 150 - height;
    return `--pc-toast-manager-translate-y-in: ${translateIn}px; --pc-toast-manager-translate-y-out: ${translateOut}px;`;
  }
  get timeoutDuration() {
    if (this.durationValue > 0) {
      return this.durationValue;
    } else if (this.hasActionValue) {
      return this.constructor.defaultDurationWithAction;
    } else {
      return this.constructor.defaultDuration;
    }
  }
  get toastManager() {
    return this.element.closest(".Polaris-Frame-ToastManager");
  }
  get visibleToasts() {
    return [ ...this.toastManager.querySelectorAll(`.${this.constructor.activeClass}`) ];
  }
  get position() {
    return this.visibleToasts.filter((el => !this.element.isEqualNode(el))).length + 1;
  }
  get heightOffset() {
    return this.visibleToasts.filter((el => !this.element.isEqualNode(el) && this.element.dataset.position > el.dataset.position)).map((el => el.offsetHeight)).reduce(((a, b) => a + b), 0);
  }
}

class Tooltip extends Controller {
  static targets=[ "template" ];
  static values={
    active: Boolean,
    position: String
  };
  show(event) {
    if (!this.activeValue) return;
    const element = event.currentTarget;
    let tooltip = document.createElement("span");
    tooltip.className = "Polaris-Tooltip";
    tooltip.innerHTML = this.templateTarget.innerHTML;
    document.body.appendChild(tooltip);
    this.tooltip = tooltip;
    const arrowElement = this.tooltip.querySelector(".Polaris-Tooltip-Arrow");
    computePosition(element, this.tooltip, {
      placement: this.positionValue,
      middleware: [ offset(10), flip(), shift({
        padding: 5
      }), arrow({
        element: arrowElement
      }) ]
    }).then((({x: x, y: y, placement: placement, middlewareData: middlewareData}) => {
      Object.assign(this.tooltip.style, {
        left: `${x}px`,
        top: `${y}px`
      });
      Object.assign(arrowElement.style, {
        left: "",
        top: "",
        right: "",
        bottom: ""
      });
      const {x: arrowX, y: arrowY} = middlewareData.arrow || {};
      const primaryPlacement = placement.split("-")[0];
      switch (primaryPlacement) {
       case "top":
        Object.assign(arrowElement.style, {
          left: arrowX ? `${arrowX}px` : "",
          bottom: "-4px"
        });
        break;

       case "bottom":
        Object.assign(arrowElement.style, {
          left: arrowX ? `${arrowX}px` : "",
          top: "-4px"
        });
        break;

       case "left":
        Object.assign(arrowElement.style, {
          top: arrowY ? `${arrowY}px` : "",
          right: "-4px"
        });
        break;

       case "right":
        Object.assign(arrowElement.style, {
          top: arrowY ? `${arrowY}px` : "",
          left: "-4px"
        });
        break;
      }
    }));
  }
  hide() {
    if (this.tooltip) {
      this.tooltip.remove();
    }
  }
  get offsetValue() {
    switch (this.positionValue) {
     case "top":
     case "bottom":
     case "left":
      return 8;

     case "right":
      return 6;
    }
  }
}

function registerPolarisControllers(application) {
  application.register("polaris-autocomplete", Autocomplete);
  application.register("polaris-button", Button);
  application.register("polaris-collapsible", Collapsible);
  application.register("polaris-dropzone", Dropzone);
  application.register("polaris-data-table", DataTable);
  application.register("polaris-frame", Frame);
  application.register("polaris-modal", Modal);
  application.register("polaris-option-list", OptionList);
  application.register("polaris", Polaris);
  application.register("polaris-popover", Popover);
  application.register("polaris-resource-item", ResourceItem);
  application.register("polaris-scrollable", Scrollable);
  application.register("polaris-select", Select);
  application.register("polaris-text-field", TextField);
  application.register("polaris-toast", Toast);
  application.register("polaris-tooltip", Tooltip);
}

export { Frame, Modal, Polaris, Popover, ResourceItem, Scrollable, Select, TextField, Tooltip, registerPolarisControllers };
