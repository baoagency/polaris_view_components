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

function debounce$1(fn, wait) {
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
  onInputChange=debounce$1((() => {
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
  disable(event) {
    if (this.button.disabled) {
      event.preventDefault();
    } else {
      this.button.disabled = true;
      this.button.classList.add("Polaris-Button--disabled", "Polaris-Button--loading");
      this.buttonContent.insertAdjacentHTML("afterbegin", this.spinnerHTML);
    }
  }
  enable() {
    if (this.button.disabled) {
      this.button.disabled = false;
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
  onWindowResize=debounce$1((() => {
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
    this.clearFiles();
    const fileList = getDataTransferFiles(e);
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
    const validImageTypes = [ "image/gif", "image/jpeg", "image/png" ];
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
    this.element.insertAdjacentHTML("afterend", `<div class="${this.backdropClass}"></div>`);
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
  disableButton() {
    this.findElement("button").disable();
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

var top = "top";

var bottom = "bottom";

var right = "right";

var left = "left";

var auto = "auto";

var basePlacements = [ top, bottom, right, left ];

var start = "start";

var end = "end";

var clippingParents = "clippingParents";

var viewport = "viewport";

var popper = "popper";

var reference = "reference";

var variationPlacements = basePlacements.reduce((function(acc, placement) {
  return acc.concat([ placement + "-" + start, placement + "-" + end ]);
}), []);

var placements = [].concat(basePlacements, [ auto ]).reduce((function(acc, placement) {
  return acc.concat([ placement, placement + "-" + start, placement + "-" + end ]);
}), []);

var beforeRead = "beforeRead";

var read = "read";

var afterRead = "afterRead";

var beforeMain = "beforeMain";

var main = "main";

var afterMain = "afterMain";

var beforeWrite = "beforeWrite";

var write = "write";

var afterWrite = "afterWrite";

var modifierPhases = [ beforeRead, read, afterRead, beforeMain, main, afterMain, beforeWrite, write, afterWrite ];

function getNodeName$1(element) {
  return element ? (element.nodeName || "").toLowerCase() : null;
}

function getWindow$1(node) {
  if (node == null) {
    return window;
  }
  if (node.toString() !== "[object Window]") {
    var ownerDocument = node.ownerDocument;
    return ownerDocument ? ownerDocument.defaultView || window : window;
  }
  return node;
}

function isElement$1(node) {
  var OwnElement = getWindow$1(node).Element;
  return node instanceof OwnElement || node instanceof Element;
}

function isHTMLElement$1(node) {
  var OwnElement = getWindow$1(node).HTMLElement;
  return node instanceof OwnElement || node instanceof HTMLElement;
}

function isShadowRoot$1(node) {
  if (typeof ShadowRoot === "undefined") {
    return false;
  }
  var OwnElement = getWindow$1(node).ShadowRoot;
  return node instanceof OwnElement || node instanceof ShadowRoot;
}

function applyStyles(_ref) {
  var state = _ref.state;
  Object.keys(state.elements).forEach((function(name) {
    var style = state.styles[name] || {};
    var attributes = state.attributes[name] || {};
    var element = state.elements[name];
    if (!isHTMLElement$1(element) || !getNodeName$1(element)) {
      return;
    }
    Object.assign(element.style, style);
    Object.keys(attributes).forEach((function(name) {
      var value = attributes[name];
      if (value === false) {
        element.removeAttribute(name);
      } else {
        element.setAttribute(name, value === true ? "" : value);
      }
    }));
  }));
}

function effect$2(_ref2) {
  var state = _ref2.state;
  var initialStyles = {
    popper: {
      position: state.options.strategy,
      left: "0",
      top: "0",
      margin: "0"
    },
    arrow: {
      position: "absolute"
    },
    reference: {}
  };
  Object.assign(state.elements.popper.style, initialStyles.popper);
  state.styles = initialStyles;
  if (state.elements.arrow) {
    Object.assign(state.elements.arrow.style, initialStyles.arrow);
  }
  return function() {
    Object.keys(state.elements).forEach((function(name) {
      var element = state.elements[name];
      var attributes = state.attributes[name] || {};
      var styleProperties = Object.keys(state.styles.hasOwnProperty(name) ? state.styles[name] : initialStyles[name]);
      var style = styleProperties.reduce((function(style, property) {
        style[property] = "";
        return style;
      }), {});
      if (!isHTMLElement$1(element) || !getNodeName$1(element)) {
        return;
      }
      Object.assign(element.style, style);
      Object.keys(attributes).forEach((function(attribute) {
        element.removeAttribute(attribute);
      }));
    }));
  };
}

var applyStyles$1 = {
  name: "applyStyles",
  enabled: true,
  phase: "write",
  fn: applyStyles,
  effect: effect$2,
  requires: [ "computeStyles" ]
};

function getBasePlacement(placement) {
  return placement.split("-")[0];
}

var max$1 = Math.max;

var min$1 = Math.min;

var round$1 = Math.round;

function getUAString() {
  var uaData = navigator.userAgentData;
  if (uaData != null && uaData.brands && Array.isArray(uaData.brands)) {
    return uaData.brands.map((function(item) {
      return item.brand + "/" + item.version;
    })).join(" ");
  }
  return navigator.userAgent;
}

function isLayoutViewport() {
  return !/^((?!chrome|android).)*safari/i.test(getUAString());
}

function getBoundingClientRect$1(element, includeScale, isFixedStrategy) {
  if (includeScale === void 0) {
    includeScale = false;
  }
  if (isFixedStrategy === void 0) {
    isFixedStrategy = false;
  }
  var clientRect = element.getBoundingClientRect();
  var scaleX = 1;
  var scaleY = 1;
  if (includeScale && isHTMLElement$1(element)) {
    scaleX = element.offsetWidth > 0 ? round$1(clientRect.width) / element.offsetWidth || 1 : 1;
    scaleY = element.offsetHeight > 0 ? round$1(clientRect.height) / element.offsetHeight || 1 : 1;
  }
  var _ref = isElement$1(element) ? getWindow$1(element) : window, visualViewport = _ref.visualViewport;
  var addVisualOffsets = !isLayoutViewport() && isFixedStrategy;
  var x = (clientRect.left + (addVisualOffsets && visualViewport ? visualViewport.offsetLeft : 0)) / scaleX;
  var y = (clientRect.top + (addVisualOffsets && visualViewport ? visualViewport.offsetTop : 0)) / scaleY;
  var width = clientRect.width / scaleX;
  var height = clientRect.height / scaleY;
  return {
    width: width,
    height: height,
    top: y,
    right: x + width,
    bottom: y + height,
    left: x,
    x: x,
    y: y
  };
}

function getLayoutRect(element) {
  var clientRect = getBoundingClientRect$1(element);
  var width = element.offsetWidth;
  var height = element.offsetHeight;
  if (Math.abs(clientRect.width - width) <= 1) {
    width = clientRect.width;
  }
  if (Math.abs(clientRect.height - height) <= 1) {
    height = clientRect.height;
  }
  return {
    x: element.offsetLeft,
    y: element.offsetTop,
    width: width,
    height: height
  };
}

function contains(parent, child) {
  var rootNode = child.getRootNode && child.getRootNode();
  if (parent.contains(child)) {
    return true;
  } else if (rootNode && isShadowRoot$1(rootNode)) {
    var next = child;
    do {
      if (next && parent.isSameNode(next)) {
        return true;
      }
      next = next.parentNode || next.host;
    } while (next);
  }
  return false;
}

function getComputedStyle$2(element) {
  return getWindow$1(element).getComputedStyle(element);
}

function isTableElement$1(element) {
  return [ "table", "td", "th" ].indexOf(getNodeName$1(element)) >= 0;
}

function getDocumentElement$1(element) {
  return ((isElement$1(element) ? element.ownerDocument : element.document) || window.document).documentElement;
}

function getParentNode$1(element) {
  if (getNodeName$1(element) === "html") {
    return element;
  }
  return element.assignedSlot || element.parentNode || (isShadowRoot$1(element) ? element.host : null) || getDocumentElement$1(element);
}

function getTrueOffsetParent$1(element) {
  if (!isHTMLElement$1(element) || getComputedStyle$2(element).position === "fixed") {
    return null;
  }
  return element.offsetParent;
}

function getContainingBlock$1(element) {
  var isFirefox = /firefox/i.test(getUAString());
  var isIE = /Trident/i.test(getUAString());
  if (isIE && isHTMLElement$1(element)) {
    var elementCss = getComputedStyle$2(element);
    if (elementCss.position === "fixed") {
      return null;
    }
  }
  var currentNode = getParentNode$1(element);
  if (isShadowRoot$1(currentNode)) {
    currentNode = currentNode.host;
  }
  while (isHTMLElement$1(currentNode) && [ "html", "body" ].indexOf(getNodeName$1(currentNode)) < 0) {
    var css = getComputedStyle$2(currentNode);
    if (css.transform !== "none" || css.perspective !== "none" || css.contain === "paint" || [ "transform", "perspective" ].indexOf(css.willChange) !== -1 || isFirefox && css.willChange === "filter" || isFirefox && css.filter && css.filter !== "none") {
      return currentNode;
    } else {
      currentNode = currentNode.parentNode;
    }
  }
  return null;
}

function getOffsetParent$1(element) {
  var window = getWindow$1(element);
  var offsetParent = getTrueOffsetParent$1(element);
  while (offsetParent && isTableElement$1(offsetParent) && getComputedStyle$2(offsetParent).position === "static") {
    offsetParent = getTrueOffsetParent$1(offsetParent);
  }
  if (offsetParent && (getNodeName$1(offsetParent) === "html" || getNodeName$1(offsetParent) === "body" && getComputedStyle$2(offsetParent).position === "static")) {
    return window;
  }
  return offsetParent || getContainingBlock$1(element) || window;
}

function getMainAxisFromPlacement(placement) {
  return [ "top", "bottom" ].indexOf(placement) >= 0 ? "x" : "y";
}

function within(min, value, max) {
  return max$1(min, min$1(value, max));
}

function withinMaxClamp(min, value, max) {
  var v = within(min, value, max);
  return v > max ? max : v;
}

function getFreshSideObject() {
  return {
    top: 0,
    right: 0,
    bottom: 0,
    left: 0
  };
}

function mergePaddingObject(paddingObject) {
  return Object.assign({}, getFreshSideObject(), paddingObject);
}

function expandToHashMap(value, keys) {
  return keys.reduce((function(hashMap, key) {
    hashMap[key] = value;
    return hashMap;
  }), {});
}

var toPaddingObject = function toPaddingObject(padding, state) {
  padding = typeof padding === "function" ? padding(Object.assign({}, state.rects, {
    placement: state.placement
  })) : padding;
  return mergePaddingObject(typeof padding !== "number" ? padding : expandToHashMap(padding, basePlacements));
};

function arrow$1(_ref) {
  var _state$modifiersData$;
  var state = _ref.state, name = _ref.name, options = _ref.options;
  var arrowElement = state.elements.arrow;
  var popperOffsets = state.modifiersData.popperOffsets;
  var basePlacement = getBasePlacement(state.placement);
  var axis = getMainAxisFromPlacement(basePlacement);
  var isVertical = [ left, right ].indexOf(basePlacement) >= 0;
  var len = isVertical ? "height" : "width";
  if (!arrowElement || !popperOffsets) {
    return;
  }
  var paddingObject = toPaddingObject(options.padding, state);
  var arrowRect = getLayoutRect(arrowElement);
  var minProp = axis === "y" ? top : left;
  var maxProp = axis === "y" ? bottom : right;
  var endDiff = state.rects.reference[len] + state.rects.reference[axis] - popperOffsets[axis] - state.rects.popper[len];
  var startDiff = popperOffsets[axis] - state.rects.reference[axis];
  var arrowOffsetParent = getOffsetParent$1(arrowElement);
  var clientSize = arrowOffsetParent ? axis === "y" ? arrowOffsetParent.clientHeight || 0 : arrowOffsetParent.clientWidth || 0 : 0;
  var centerToReference = endDiff / 2 - startDiff / 2;
  var min = paddingObject[minProp];
  var max = clientSize - arrowRect[len] - paddingObject[maxProp];
  var center = clientSize / 2 - arrowRect[len] / 2 + centerToReference;
  var offset = within(min, center, max);
  var axisProp = axis;
  state.modifiersData[name] = (_state$modifiersData$ = {}, _state$modifiersData$[axisProp] = offset, 
  _state$modifiersData$.centerOffset = offset - center, _state$modifiersData$);
}

function effect$1(_ref2) {
  var state = _ref2.state, options = _ref2.options;
  var _options$element = options.element, arrowElement = _options$element === void 0 ? "[data-popper-arrow]" : _options$element;
  if (arrowElement == null) {
    return;
  }
  if (typeof arrowElement === "string") {
    arrowElement = state.elements.popper.querySelector(arrowElement);
    if (!arrowElement) {
      return;
    }
  }
  if (!contains(state.elements.popper, arrowElement)) {
    return;
  }
  state.elements.arrow = arrowElement;
}

var arrow$2 = {
  name: "arrow",
  enabled: true,
  phase: "main",
  fn: arrow$1,
  effect: effect$1,
  requires: [ "popperOffsets" ],
  requiresIfExists: [ "preventOverflow" ]
};

function getVariation(placement) {
  return placement.split("-")[1];
}

var unsetSides = {
  top: "auto",
  right: "auto",
  bottom: "auto",
  left: "auto"
};

function roundOffsetsByDPR(_ref, win) {
  var x = _ref.x, y = _ref.y;
  var dpr = win.devicePixelRatio || 1;
  return {
    x: round$1(x * dpr) / dpr || 0,
    y: round$1(y * dpr) / dpr || 0
  };
}

function mapToStyles(_ref2) {
  var _Object$assign2;
  var popper = _ref2.popper, popperRect = _ref2.popperRect, placement = _ref2.placement, variation = _ref2.variation, offsets = _ref2.offsets, position = _ref2.position, gpuAcceleration = _ref2.gpuAcceleration, adaptive = _ref2.adaptive, roundOffsets = _ref2.roundOffsets, isFixed = _ref2.isFixed;
  var _offsets$x = offsets.x, x = _offsets$x === void 0 ? 0 : _offsets$x, _offsets$y = offsets.y, y = _offsets$y === void 0 ? 0 : _offsets$y;
  var _ref3 = typeof roundOffsets === "function" ? roundOffsets({
    x: x,
    y: y
  }) : {
    x: x,
    y: y
  };
  x = _ref3.x;
  y = _ref3.y;
  var hasX = offsets.hasOwnProperty("x");
  var hasY = offsets.hasOwnProperty("y");
  var sideX = left;
  var sideY = top;
  var win = window;
  if (adaptive) {
    var offsetParent = getOffsetParent$1(popper);
    var heightProp = "clientHeight";
    var widthProp = "clientWidth";
    if (offsetParent === getWindow$1(popper)) {
      offsetParent = getDocumentElement$1(popper);
      if (getComputedStyle$2(offsetParent).position !== "static" && position === "absolute") {
        heightProp = "scrollHeight";
        widthProp = "scrollWidth";
      }
    }
    offsetParent = offsetParent;
    if (placement === top || (placement === left || placement === right) && variation === end) {
      sideY = bottom;
      var offsetY = isFixed && offsetParent === win && win.visualViewport ? win.visualViewport.height : offsetParent[heightProp];
      y -= offsetY - popperRect.height;
      y *= gpuAcceleration ? 1 : -1;
    }
    if (placement === left || (placement === top || placement === bottom) && variation === end) {
      sideX = right;
      var offsetX = isFixed && offsetParent === win && win.visualViewport ? win.visualViewport.width : offsetParent[widthProp];
      x -= offsetX - popperRect.width;
      x *= gpuAcceleration ? 1 : -1;
    }
  }
  var commonStyles = Object.assign({
    position: position
  }, adaptive && unsetSides);
  var _ref4 = roundOffsets === true ? roundOffsetsByDPR({
    x: x,
    y: y
  }, getWindow$1(popper)) : {
    x: x,
    y: y
  };
  x = _ref4.x;
  y = _ref4.y;
  if (gpuAcceleration) {
    var _Object$assign;
    return Object.assign({}, commonStyles, (_Object$assign = {}, _Object$assign[sideY] = hasY ? "0" : "", 
    _Object$assign[sideX] = hasX ? "0" : "", _Object$assign.transform = (win.devicePixelRatio || 1) <= 1 ? "translate(" + x + "px, " + y + "px)" : "translate3d(" + x + "px, " + y + "px, 0)", 
    _Object$assign));
  }
  return Object.assign({}, commonStyles, (_Object$assign2 = {}, _Object$assign2[sideY] = hasY ? y + "px" : "", 
  _Object$assign2[sideX] = hasX ? x + "px" : "", _Object$assign2.transform = "", _Object$assign2));
}

function computeStyles(_ref5) {
  var state = _ref5.state, options = _ref5.options;
  var _options$gpuAccelerat = options.gpuAcceleration, gpuAcceleration = _options$gpuAccelerat === void 0 ? true : _options$gpuAccelerat, _options$adaptive = options.adaptive, adaptive = _options$adaptive === void 0 ? true : _options$adaptive, _options$roundOffsets = options.roundOffsets, roundOffsets = _options$roundOffsets === void 0 ? true : _options$roundOffsets;
  var commonStyles = {
    placement: getBasePlacement(state.placement),
    variation: getVariation(state.placement),
    popper: state.elements.popper,
    popperRect: state.rects.popper,
    gpuAcceleration: gpuAcceleration,
    isFixed: state.options.strategy === "fixed"
  };
  if (state.modifiersData.popperOffsets != null) {
    state.styles.popper = Object.assign({}, state.styles.popper, mapToStyles(Object.assign({}, commonStyles, {
      offsets: state.modifiersData.popperOffsets,
      position: state.options.strategy,
      adaptive: adaptive,
      roundOffsets: roundOffsets
    })));
  }
  if (state.modifiersData.arrow != null) {
    state.styles.arrow = Object.assign({}, state.styles.arrow, mapToStyles(Object.assign({}, commonStyles, {
      offsets: state.modifiersData.arrow,
      position: "absolute",
      adaptive: false,
      roundOffsets: roundOffsets
    })));
  }
  state.attributes.popper = Object.assign({}, state.attributes.popper, {
    "data-popper-placement": state.placement
  });
}

var computeStyles$1 = {
  name: "computeStyles",
  enabled: true,
  phase: "beforeWrite",
  fn: computeStyles,
  data: {}
};

var passive = {
  passive: true
};

function effect(_ref) {
  var state = _ref.state, instance = _ref.instance, options = _ref.options;
  var _options$scroll = options.scroll, scroll = _options$scroll === void 0 ? true : _options$scroll, _options$resize = options.resize, resize = _options$resize === void 0 ? true : _options$resize;
  var window = getWindow$1(state.elements.popper);
  var scrollParents = [].concat(state.scrollParents.reference, state.scrollParents.popper);
  if (scroll) {
    scrollParents.forEach((function(scrollParent) {
      scrollParent.addEventListener("scroll", instance.update, passive);
    }));
  }
  if (resize) {
    window.addEventListener("resize", instance.update, passive);
  }
  return function() {
    if (scroll) {
      scrollParents.forEach((function(scrollParent) {
        scrollParent.removeEventListener("scroll", instance.update, passive);
      }));
    }
    if (resize) {
      window.removeEventListener("resize", instance.update, passive);
    }
  };
}

var eventListeners = {
  name: "eventListeners",
  enabled: true,
  phase: "write",
  fn: function fn() {},
  effect: effect,
  data: {}
};

var hash$1 = {
  left: "right",
  right: "left",
  bottom: "top",
  top: "bottom"
};

function getOppositePlacement$1(placement) {
  return placement.replace(/left|right|bottom|top/g, (function(matched) {
    return hash$1[matched];
  }));
}

var hash = {
  start: "end",
  end: "start"
};

function getOppositeVariationPlacement(placement) {
  return placement.replace(/start|end/g, (function(matched) {
    return hash[matched];
  }));
}

function getWindowScroll(node) {
  var win = getWindow$1(node);
  var scrollLeft = win.pageXOffset;
  var scrollTop = win.pageYOffset;
  return {
    scrollLeft: scrollLeft,
    scrollTop: scrollTop
  };
}

function getWindowScrollBarX$1(element) {
  return getBoundingClientRect$1(getDocumentElement$1(element)).left + getWindowScroll(element).scrollLeft;
}

function getViewportRect$1(element, strategy) {
  var win = getWindow$1(element);
  var html = getDocumentElement$1(element);
  var visualViewport = win.visualViewport;
  var width = html.clientWidth;
  var height = html.clientHeight;
  var x = 0;
  var y = 0;
  if (visualViewport) {
    width = visualViewport.width;
    height = visualViewport.height;
    var layoutViewport = isLayoutViewport();
    if (layoutViewport || !layoutViewport && strategy === "fixed") {
      x = visualViewport.offsetLeft;
      y = visualViewport.offsetTop;
    }
  }
  return {
    width: width,
    height: height,
    x: x + getWindowScrollBarX$1(element),
    y: y
  };
}

function getDocumentRect$1(element) {
  var _element$ownerDocumen;
  var html = getDocumentElement$1(element);
  var winScroll = getWindowScroll(element);
  var body = (_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body;
  var width = max$1(html.scrollWidth, html.clientWidth, body ? body.scrollWidth : 0, body ? body.clientWidth : 0);
  var height = max$1(html.scrollHeight, html.clientHeight, body ? body.scrollHeight : 0, body ? body.clientHeight : 0);
  var x = -winScroll.scrollLeft + getWindowScrollBarX$1(element);
  var y = -winScroll.scrollTop;
  if (getComputedStyle$2(body || html).direction === "rtl") {
    x += max$1(html.clientWidth, body ? body.clientWidth : 0) - width;
  }
  return {
    width: width,
    height: height,
    x: x,
    y: y
  };
}

function isScrollParent(element) {
  var _getComputedStyle = getComputedStyle$2(element), overflow = _getComputedStyle.overflow, overflowX = _getComputedStyle.overflowX, overflowY = _getComputedStyle.overflowY;
  return /auto|scroll|overlay|hidden/.test(overflow + overflowY + overflowX);
}

function getScrollParent(node) {
  if ([ "html", "body", "#document" ].indexOf(getNodeName$1(node)) >= 0) {
    return node.ownerDocument.body;
  }
  if (isHTMLElement$1(node) && isScrollParent(node)) {
    return node;
  }
  return getScrollParent(getParentNode$1(node));
}

function listScrollParents(element, list) {
  var _element$ownerDocumen;
  if (list === void 0) {
    list = [];
  }
  var scrollParent = getScrollParent(element);
  var isBody = scrollParent === ((_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body);
  var win = getWindow$1(scrollParent);
  var target = isBody ? [ win ].concat(win.visualViewport || [], isScrollParent(scrollParent) ? scrollParent : []) : scrollParent;
  var updatedList = list.concat(target);
  return isBody ? updatedList : updatedList.concat(listScrollParents(getParentNode$1(target)));
}

function rectToClientRect$1(rect) {
  return Object.assign({}, rect, {
    left: rect.x,
    top: rect.y,
    right: rect.x + rect.width,
    bottom: rect.y + rect.height
  });
}

function getInnerBoundingClientRect$1(element, strategy) {
  var rect = getBoundingClientRect$1(element, false, strategy === "fixed");
  rect.top = rect.top + element.clientTop;
  rect.left = rect.left + element.clientLeft;
  rect.bottom = rect.top + element.clientHeight;
  rect.right = rect.left + element.clientWidth;
  rect.width = element.clientWidth;
  rect.height = element.clientHeight;
  rect.x = rect.left;
  rect.y = rect.top;
  return rect;
}

function getClientRectFromMixedType(element, clippingParent, strategy) {
  return clippingParent === viewport ? rectToClientRect$1(getViewportRect$1(element, strategy)) : isElement$1(clippingParent) ? getInnerBoundingClientRect$1(clippingParent, strategy) : rectToClientRect$1(getDocumentRect$1(getDocumentElement$1(element)));
}

function getClippingParents(element) {
  var clippingParents = listScrollParents(getParentNode$1(element));
  var canEscapeClipping = [ "absolute", "fixed" ].indexOf(getComputedStyle$2(element).position) >= 0;
  var clipperElement = canEscapeClipping && isHTMLElement$1(element) ? getOffsetParent$1(element) : element;
  if (!isElement$1(clipperElement)) {
    return [];
  }
  return clippingParents.filter((function(clippingParent) {
    return isElement$1(clippingParent) && contains(clippingParent, clipperElement) && getNodeName$1(clippingParent) !== "body";
  }));
}

function getClippingRect$1(element, boundary, rootBoundary, strategy) {
  var mainClippingParents = boundary === "clippingParents" ? getClippingParents(element) : [].concat(boundary);
  var clippingParents = [].concat(mainClippingParents, [ rootBoundary ]);
  var firstClippingParent = clippingParents[0];
  var clippingRect = clippingParents.reduce((function(accRect, clippingParent) {
    var rect = getClientRectFromMixedType(element, clippingParent, strategy);
    accRect.top = max$1(rect.top, accRect.top);
    accRect.right = min$1(rect.right, accRect.right);
    accRect.bottom = min$1(rect.bottom, accRect.bottom);
    accRect.left = max$1(rect.left, accRect.left);
    return accRect;
  }), getClientRectFromMixedType(element, firstClippingParent, strategy));
  clippingRect.width = clippingRect.right - clippingRect.left;
  clippingRect.height = clippingRect.bottom - clippingRect.top;
  clippingRect.x = clippingRect.left;
  clippingRect.y = clippingRect.top;
  return clippingRect;
}

function computeOffsets(_ref) {
  var reference = _ref.reference, element = _ref.element, placement = _ref.placement;
  var basePlacement = placement ? getBasePlacement(placement) : null;
  var variation = placement ? getVariation(placement) : null;
  var commonX = reference.x + reference.width / 2 - element.width / 2;
  var commonY = reference.y + reference.height / 2 - element.height / 2;
  var offsets;
  switch (basePlacement) {
   case top:
    offsets = {
      x: commonX,
      y: reference.y - element.height
    };
    break;

   case bottom:
    offsets = {
      x: commonX,
      y: reference.y + reference.height
    };
    break;

   case right:
    offsets = {
      x: reference.x + reference.width,
      y: commonY
    };
    break;

   case left:
    offsets = {
      x: reference.x - element.width,
      y: commonY
    };
    break;

   default:
    offsets = {
      x: reference.x,
      y: reference.y
    };
  }
  var mainAxis = basePlacement ? getMainAxisFromPlacement(basePlacement) : null;
  if (mainAxis != null) {
    var len = mainAxis === "y" ? "height" : "width";
    switch (variation) {
     case start:
      offsets[mainAxis] = offsets[mainAxis] - (reference[len] / 2 - element[len] / 2);
      break;

     case end:
      offsets[mainAxis] = offsets[mainAxis] + (reference[len] / 2 - element[len] / 2);
      break;
    }
  }
  return offsets;
}

function detectOverflow$1(state, options) {
  if (options === void 0) {
    options = {};
  }
  var _options = options, _options$placement = _options.placement, placement = _options$placement === void 0 ? state.placement : _options$placement, _options$strategy = _options.strategy, strategy = _options$strategy === void 0 ? state.strategy : _options$strategy, _options$boundary = _options.boundary, boundary = _options$boundary === void 0 ? clippingParents : _options$boundary, _options$rootBoundary = _options.rootBoundary, rootBoundary = _options$rootBoundary === void 0 ? viewport : _options$rootBoundary, _options$elementConte = _options.elementContext, elementContext = _options$elementConte === void 0 ? popper : _options$elementConte, _options$altBoundary = _options.altBoundary, altBoundary = _options$altBoundary === void 0 ? false : _options$altBoundary, _options$padding = _options.padding, padding = _options$padding === void 0 ? 0 : _options$padding;
  var paddingObject = mergePaddingObject(typeof padding !== "number" ? padding : expandToHashMap(padding, basePlacements));
  var altContext = elementContext === popper ? reference : popper;
  var popperRect = state.rects.popper;
  var element = state.elements[altBoundary ? altContext : elementContext];
  var clippingClientRect = getClippingRect$1(isElement$1(element) ? element : element.contextElement || getDocumentElement$1(state.elements.popper), boundary, rootBoundary, strategy);
  var referenceClientRect = getBoundingClientRect$1(state.elements.reference);
  var popperOffsets = computeOffsets({
    reference: referenceClientRect,
    element: popperRect,
    strategy: "absolute",
    placement: placement
  });
  var popperClientRect = rectToClientRect$1(Object.assign({}, popperRect, popperOffsets));
  var elementClientRect = elementContext === popper ? popperClientRect : referenceClientRect;
  var overflowOffsets = {
    top: clippingClientRect.top - elementClientRect.top + paddingObject.top,
    bottom: elementClientRect.bottom - clippingClientRect.bottom + paddingObject.bottom,
    left: clippingClientRect.left - elementClientRect.left + paddingObject.left,
    right: elementClientRect.right - clippingClientRect.right + paddingObject.right
  };
  var offsetData = state.modifiersData.offset;
  if (elementContext === popper && offsetData) {
    var offset = offsetData[placement];
    Object.keys(overflowOffsets).forEach((function(key) {
      var multiply = [ right, bottom ].indexOf(key) >= 0 ? 1 : -1;
      var axis = [ top, bottom ].indexOf(key) >= 0 ? "y" : "x";
      overflowOffsets[key] += offset[axis] * multiply;
    }));
  }
  return overflowOffsets;
}

function computeAutoPlacement(state, options) {
  if (options === void 0) {
    options = {};
  }
  var _options = options, placement = _options.placement, boundary = _options.boundary, rootBoundary = _options.rootBoundary, padding = _options.padding, flipVariations = _options.flipVariations, _options$allowedAutoP = _options.allowedAutoPlacements, allowedAutoPlacements = _options$allowedAutoP === void 0 ? placements : _options$allowedAutoP;
  var variation = getVariation(placement);
  var placements$1 = variation ? flipVariations ? variationPlacements : variationPlacements.filter((function(placement) {
    return getVariation(placement) === variation;
  })) : basePlacements;
  var allowedPlacements = placements$1.filter((function(placement) {
    return allowedAutoPlacements.indexOf(placement) >= 0;
  }));
  if (allowedPlacements.length === 0) {
    allowedPlacements = placements$1;
  }
  var overflows = allowedPlacements.reduce((function(acc, placement) {
    acc[placement] = detectOverflow$1(state, {
      placement: placement,
      boundary: boundary,
      rootBoundary: rootBoundary,
      padding: padding
    })[getBasePlacement(placement)];
    return acc;
  }), {});
  return Object.keys(overflows).sort((function(a, b) {
    return overflows[a] - overflows[b];
  }));
}

function getExpandedFallbackPlacements(placement) {
  if (getBasePlacement(placement) === auto) {
    return [];
  }
  var oppositePlacement = getOppositePlacement$1(placement);
  return [ getOppositeVariationPlacement(placement), oppositePlacement, getOppositeVariationPlacement(oppositePlacement) ];
}

function flip$1(_ref) {
  var state = _ref.state, options = _ref.options, name = _ref.name;
  if (state.modifiersData[name]._skip) {
    return;
  }
  var _options$mainAxis = options.mainAxis, checkMainAxis = _options$mainAxis === void 0 ? true : _options$mainAxis, _options$altAxis = options.altAxis, checkAltAxis = _options$altAxis === void 0 ? true : _options$altAxis, specifiedFallbackPlacements = options.fallbackPlacements, padding = options.padding, boundary = options.boundary, rootBoundary = options.rootBoundary, altBoundary = options.altBoundary, _options$flipVariatio = options.flipVariations, flipVariations = _options$flipVariatio === void 0 ? true : _options$flipVariatio, allowedAutoPlacements = options.allowedAutoPlacements;
  var preferredPlacement = state.options.placement;
  var basePlacement = getBasePlacement(preferredPlacement);
  var isBasePlacement = basePlacement === preferredPlacement;
  var fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipVariations ? [ getOppositePlacement$1(preferredPlacement) ] : getExpandedFallbackPlacements(preferredPlacement));
  var placements = [ preferredPlacement ].concat(fallbackPlacements).reduce((function(acc, placement) {
    return acc.concat(getBasePlacement(placement) === auto ? computeAutoPlacement(state, {
      placement: placement,
      boundary: boundary,
      rootBoundary: rootBoundary,
      padding: padding,
      flipVariations: flipVariations,
      allowedAutoPlacements: allowedAutoPlacements
    }) : placement);
  }), []);
  var referenceRect = state.rects.reference;
  var popperRect = state.rects.popper;
  var checksMap = new Map;
  var makeFallbackChecks = true;
  var firstFittingPlacement = placements[0];
  for (var i = 0; i < placements.length; i++) {
    var placement = placements[i];
    var _basePlacement = getBasePlacement(placement);
    var isStartVariation = getVariation(placement) === start;
    var isVertical = [ top, bottom ].indexOf(_basePlacement) >= 0;
    var len = isVertical ? "width" : "height";
    var overflow = detectOverflow$1(state, {
      placement: placement,
      boundary: boundary,
      rootBoundary: rootBoundary,
      altBoundary: altBoundary,
      padding: padding
    });
    var mainVariationSide = isVertical ? isStartVariation ? right : left : isStartVariation ? bottom : top;
    if (referenceRect[len] > popperRect[len]) {
      mainVariationSide = getOppositePlacement$1(mainVariationSide);
    }
    var altVariationSide = getOppositePlacement$1(mainVariationSide);
    var checks = [];
    if (checkMainAxis) {
      checks.push(overflow[_basePlacement] <= 0);
    }
    if (checkAltAxis) {
      checks.push(overflow[mainVariationSide] <= 0, overflow[altVariationSide] <= 0);
    }
    if (checks.every((function(check) {
      return check;
    }))) {
      firstFittingPlacement = placement;
      makeFallbackChecks = false;
      break;
    }
    checksMap.set(placement, checks);
  }
  if (makeFallbackChecks) {
    var numberOfChecks = flipVariations ? 3 : 1;
    var _loop = function _loop(_i) {
      var fittingPlacement = placements.find((function(placement) {
        var checks = checksMap.get(placement);
        if (checks) {
          return checks.slice(0, _i).every((function(check) {
            return check;
          }));
        }
      }));
      if (fittingPlacement) {
        firstFittingPlacement = fittingPlacement;
        return "break";
      }
    };
    for (var _i = numberOfChecks; _i > 0; _i--) {
      var _ret = _loop(_i);
      if (_ret === "break") break;
    }
  }
  if (state.placement !== firstFittingPlacement) {
    state.modifiersData[name]._skip = true;
    state.placement = firstFittingPlacement;
    state.reset = true;
  }
}

var flip$2 = {
  name: "flip",
  enabled: true,
  phase: "main",
  fn: flip$1,
  requiresIfExists: [ "offset" ],
  data: {
    _skip: false
  }
};

function getSideOffsets(overflow, rect, preventedOffsets) {
  if (preventedOffsets === void 0) {
    preventedOffsets = {
      x: 0,
      y: 0
    };
  }
  return {
    top: overflow.top - rect.height - preventedOffsets.y,
    right: overflow.right - rect.width + preventedOffsets.x,
    bottom: overflow.bottom - rect.height + preventedOffsets.y,
    left: overflow.left - rect.width - preventedOffsets.x
  };
}

function isAnySideFullyClipped(overflow) {
  return [ top, right, bottom, left ].some((function(side) {
    return overflow[side] >= 0;
  }));
}

function hide(_ref) {
  var state = _ref.state, name = _ref.name;
  var referenceRect = state.rects.reference;
  var popperRect = state.rects.popper;
  var preventedOffsets = state.modifiersData.preventOverflow;
  var referenceOverflow = detectOverflow$1(state, {
    elementContext: "reference"
  });
  var popperAltOverflow = detectOverflow$1(state, {
    altBoundary: true
  });
  var referenceClippingOffsets = getSideOffsets(referenceOverflow, referenceRect);
  var popperEscapeOffsets = getSideOffsets(popperAltOverflow, popperRect, preventedOffsets);
  var isReferenceHidden = isAnySideFullyClipped(referenceClippingOffsets);
  var hasPopperEscaped = isAnySideFullyClipped(popperEscapeOffsets);
  state.modifiersData[name] = {
    referenceClippingOffsets: referenceClippingOffsets,
    popperEscapeOffsets: popperEscapeOffsets,
    isReferenceHidden: isReferenceHidden,
    hasPopperEscaped: hasPopperEscaped
  };
  state.attributes.popper = Object.assign({}, state.attributes.popper, {
    "data-popper-reference-hidden": isReferenceHidden,
    "data-popper-escaped": hasPopperEscaped
  });
}

var hide$1 = {
  name: "hide",
  enabled: true,
  phase: "main",
  requiresIfExists: [ "preventOverflow" ],
  fn: hide
};

function distanceAndSkiddingToXY(placement, rects, offset) {
  var basePlacement = getBasePlacement(placement);
  var invertDistance = [ left, top ].indexOf(basePlacement) >= 0 ? -1 : 1;
  var _ref = typeof offset === "function" ? offset(Object.assign({}, rects, {
    placement: placement
  })) : offset, skidding = _ref[0], distance = _ref[1];
  skidding = skidding || 0;
  distance = (distance || 0) * invertDistance;
  return [ left, right ].indexOf(basePlacement) >= 0 ? {
    x: distance,
    y: skidding
  } : {
    x: skidding,
    y: distance
  };
}

function offset$1(_ref2) {
  var state = _ref2.state, options = _ref2.options, name = _ref2.name;
  var _options$offset = options.offset, offset = _options$offset === void 0 ? [ 0, 0 ] : _options$offset;
  var data = placements.reduce((function(acc, placement) {
    acc[placement] = distanceAndSkiddingToXY(placement, state.rects, offset);
    return acc;
  }), {});
  var _data$state$placement = data[state.placement], x = _data$state$placement.x, y = _data$state$placement.y;
  if (state.modifiersData.popperOffsets != null) {
    state.modifiersData.popperOffsets.x += x;
    state.modifiersData.popperOffsets.y += y;
  }
  state.modifiersData[name] = data;
}

var offset$2 = {
  name: "offset",
  enabled: true,
  phase: "main",
  requires: [ "popperOffsets" ],
  fn: offset$1
};

function popperOffsets(_ref) {
  var state = _ref.state, name = _ref.name;
  state.modifiersData[name] = computeOffsets({
    reference: state.rects.reference,
    element: state.rects.popper,
    strategy: "absolute",
    placement: state.placement
  });
}

var popperOffsets$1 = {
  name: "popperOffsets",
  enabled: true,
  phase: "read",
  fn: popperOffsets,
  data: {}
};

function getAltAxis(axis) {
  return axis === "x" ? "y" : "x";
}

function preventOverflow(_ref) {
  var state = _ref.state, options = _ref.options, name = _ref.name;
  var _options$mainAxis = options.mainAxis, checkMainAxis = _options$mainAxis === void 0 ? true : _options$mainAxis, _options$altAxis = options.altAxis, checkAltAxis = _options$altAxis === void 0 ? false : _options$altAxis, boundary = options.boundary, rootBoundary = options.rootBoundary, altBoundary = options.altBoundary, padding = options.padding, _options$tether = options.tether, tether = _options$tether === void 0 ? true : _options$tether, _options$tetherOffset = options.tetherOffset, tetherOffset = _options$tetherOffset === void 0 ? 0 : _options$tetherOffset;
  var overflow = detectOverflow$1(state, {
    boundary: boundary,
    rootBoundary: rootBoundary,
    padding: padding,
    altBoundary: altBoundary
  });
  var basePlacement = getBasePlacement(state.placement);
  var variation = getVariation(state.placement);
  var isBasePlacement = !variation;
  var mainAxis = getMainAxisFromPlacement(basePlacement);
  var altAxis = getAltAxis(mainAxis);
  var popperOffsets = state.modifiersData.popperOffsets;
  var referenceRect = state.rects.reference;
  var popperRect = state.rects.popper;
  var tetherOffsetValue = typeof tetherOffset === "function" ? tetherOffset(Object.assign({}, state.rects, {
    placement: state.placement
  })) : tetherOffset;
  var normalizedTetherOffsetValue = typeof tetherOffsetValue === "number" ? {
    mainAxis: tetherOffsetValue,
    altAxis: tetherOffsetValue
  } : Object.assign({
    mainAxis: 0,
    altAxis: 0
  }, tetherOffsetValue);
  var offsetModifierState = state.modifiersData.offset ? state.modifiersData.offset[state.placement] : null;
  var data = {
    x: 0,
    y: 0
  };
  if (!popperOffsets) {
    return;
  }
  if (checkMainAxis) {
    var _offsetModifierState$;
    var mainSide = mainAxis === "y" ? top : left;
    var altSide = mainAxis === "y" ? bottom : right;
    var len = mainAxis === "y" ? "height" : "width";
    var offset = popperOffsets[mainAxis];
    var min = offset + overflow[mainSide];
    var max = offset - overflow[altSide];
    var additive = tether ? -popperRect[len] / 2 : 0;
    var minLen = variation === start ? referenceRect[len] : popperRect[len];
    var maxLen = variation === start ? -popperRect[len] : -referenceRect[len];
    var arrowElement = state.elements.arrow;
    var arrowRect = tether && arrowElement ? getLayoutRect(arrowElement) : {
      width: 0,
      height: 0
    };
    var arrowPaddingObject = state.modifiersData["arrow#persistent"] ? state.modifiersData["arrow#persistent"].padding : getFreshSideObject();
    var arrowPaddingMin = arrowPaddingObject[mainSide];
    var arrowPaddingMax = arrowPaddingObject[altSide];
    var arrowLen = within(0, referenceRect[len], arrowRect[len]);
    var minOffset = isBasePlacement ? referenceRect[len] / 2 - additive - arrowLen - arrowPaddingMin - normalizedTetherOffsetValue.mainAxis : minLen - arrowLen - arrowPaddingMin - normalizedTetherOffsetValue.mainAxis;
    var maxOffset = isBasePlacement ? -referenceRect[len] / 2 + additive + arrowLen + arrowPaddingMax + normalizedTetherOffsetValue.mainAxis : maxLen + arrowLen + arrowPaddingMax + normalizedTetherOffsetValue.mainAxis;
    var arrowOffsetParent = state.elements.arrow && getOffsetParent$1(state.elements.arrow);
    var clientOffset = arrowOffsetParent ? mainAxis === "y" ? arrowOffsetParent.clientTop || 0 : arrowOffsetParent.clientLeft || 0 : 0;
    var offsetModifierValue = (_offsetModifierState$ = offsetModifierState == null ? void 0 : offsetModifierState[mainAxis]) != null ? _offsetModifierState$ : 0;
    var tetherMin = offset + minOffset - offsetModifierValue - clientOffset;
    var tetherMax = offset + maxOffset - offsetModifierValue;
    var preventedOffset = within(tether ? min$1(min, tetherMin) : min, offset, tether ? max$1(max, tetherMax) : max);
    popperOffsets[mainAxis] = preventedOffset;
    data[mainAxis] = preventedOffset - offset;
  }
  if (checkAltAxis) {
    var _offsetModifierState$2;
    var _mainSide = mainAxis === "x" ? top : left;
    var _altSide = mainAxis === "x" ? bottom : right;
    var _offset = popperOffsets[altAxis];
    var _len = altAxis === "y" ? "height" : "width";
    var _min = _offset + overflow[_mainSide];
    var _max = _offset - overflow[_altSide];
    var isOriginSide = [ top, left ].indexOf(basePlacement) !== -1;
    var _offsetModifierValue = (_offsetModifierState$2 = offsetModifierState == null ? void 0 : offsetModifierState[altAxis]) != null ? _offsetModifierState$2 : 0;
    var _tetherMin = isOriginSide ? _min : _offset - referenceRect[_len] - popperRect[_len] - _offsetModifierValue + normalizedTetherOffsetValue.altAxis;
    var _tetherMax = isOriginSide ? _offset + referenceRect[_len] + popperRect[_len] - _offsetModifierValue - normalizedTetherOffsetValue.altAxis : _max;
    var _preventedOffset = tether && isOriginSide ? withinMaxClamp(_tetherMin, _offset, _tetherMax) : within(tether ? _tetherMin : _min, _offset, tether ? _tetherMax : _max);
    popperOffsets[altAxis] = _preventedOffset;
    data[altAxis] = _preventedOffset - _offset;
  }
  state.modifiersData[name] = data;
}

var preventOverflow$1 = {
  name: "preventOverflow",
  enabled: true,
  phase: "main",
  fn: preventOverflow,
  requiresIfExists: [ "offset" ]
};

function getHTMLElementScroll(element) {
  return {
    scrollLeft: element.scrollLeft,
    scrollTop: element.scrollTop
  };
}

function getNodeScroll$1(node) {
  if (node === getWindow$1(node) || !isHTMLElement$1(node)) {
    return getWindowScroll(node);
  } else {
    return getHTMLElementScroll(node);
  }
}

function isElementScaled(element) {
  var rect = element.getBoundingClientRect();
  var scaleX = round$1(rect.width) / element.offsetWidth || 1;
  var scaleY = round$1(rect.height) / element.offsetHeight || 1;
  return scaleX !== 1 || scaleY !== 1;
}

function getCompositeRect(elementOrVirtualElement, offsetParent, isFixed) {
  if (isFixed === void 0) {
    isFixed = false;
  }
  var isOffsetParentAnElement = isHTMLElement$1(offsetParent);
  var offsetParentIsScaled = isHTMLElement$1(offsetParent) && isElementScaled(offsetParent);
  var documentElement = getDocumentElement$1(offsetParent);
  var rect = getBoundingClientRect$1(elementOrVirtualElement, offsetParentIsScaled, isFixed);
  var scroll = {
    scrollLeft: 0,
    scrollTop: 0
  };
  var offsets = {
    x: 0,
    y: 0
  };
  if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
    if (getNodeName$1(offsetParent) !== "body" || isScrollParent(documentElement)) {
      scroll = getNodeScroll$1(offsetParent);
    }
    if (isHTMLElement$1(offsetParent)) {
      offsets = getBoundingClientRect$1(offsetParent, true);
      offsets.x += offsetParent.clientLeft;
      offsets.y += offsetParent.clientTop;
    } else if (documentElement) {
      offsets.x = getWindowScrollBarX$1(documentElement);
    }
  }
  return {
    x: rect.left + scroll.scrollLeft - offsets.x,
    y: rect.top + scroll.scrollTop - offsets.y,
    width: rect.width,
    height: rect.height
  };
}

function order(modifiers) {
  var map = new Map;
  var visited = new Set;
  var result = [];
  modifiers.forEach((function(modifier) {
    map.set(modifier.name, modifier);
  }));
  function sort(modifier) {
    visited.add(modifier.name);
    var requires = [].concat(modifier.requires || [], modifier.requiresIfExists || []);
    requires.forEach((function(dep) {
      if (!visited.has(dep)) {
        var depModifier = map.get(dep);
        if (depModifier) {
          sort(depModifier);
        }
      }
    }));
    result.push(modifier);
  }
  modifiers.forEach((function(modifier) {
    if (!visited.has(modifier.name)) {
      sort(modifier);
    }
  }));
  return result;
}

function orderModifiers(modifiers) {
  var orderedModifiers = order(modifiers);
  return modifierPhases.reduce((function(acc, phase) {
    return acc.concat(orderedModifiers.filter((function(modifier) {
      return modifier.phase === phase;
    })));
  }), []);
}

function debounce(fn) {
  var pending;
  return function() {
    if (!pending) {
      pending = new Promise((function(resolve) {
        Promise.resolve().then((function() {
          pending = undefined;
          resolve(fn());
        }));
      }));
    }
    return pending;
  };
}

function mergeByName(modifiers) {
  var merged = modifiers.reduce((function(merged, current) {
    var existing = merged[current.name];
    merged[current.name] = existing ? Object.assign({}, existing, current, {
      options: Object.assign({}, existing.options, current.options),
      data: Object.assign({}, existing.data, current.data)
    }) : current;
    return merged;
  }), {});
  return Object.keys(merged).map((function(key) {
    return merged[key];
  }));
}

var DEFAULT_OPTIONS = {
  placement: "bottom",
  modifiers: [],
  strategy: "absolute"
};

function areValidElements() {
  for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
    args[_key] = arguments[_key];
  }
  return !args.some((function(element) {
    return !(element && typeof element.getBoundingClientRect === "function");
  }));
}

function popperGenerator(generatorOptions) {
  if (generatorOptions === void 0) {
    generatorOptions = {};
  }
  var _generatorOptions = generatorOptions, _generatorOptions$def = _generatorOptions.defaultModifiers, defaultModifiers = _generatorOptions$def === void 0 ? [] : _generatorOptions$def, _generatorOptions$def2 = _generatorOptions.defaultOptions, defaultOptions = _generatorOptions$def2 === void 0 ? DEFAULT_OPTIONS : _generatorOptions$def2;
  return function createPopper(reference, popper, options) {
    if (options === void 0) {
      options = defaultOptions;
    }
    var state = {
      placement: "bottom",
      orderedModifiers: [],
      options: Object.assign({}, DEFAULT_OPTIONS, defaultOptions),
      modifiersData: {},
      elements: {
        reference: reference,
        popper: popper
      },
      attributes: {},
      styles: {}
    };
    var effectCleanupFns = [];
    var isDestroyed = false;
    var instance = {
      state: state,
      setOptions: function setOptions(setOptionsAction) {
        var options = typeof setOptionsAction === "function" ? setOptionsAction(state.options) : setOptionsAction;
        cleanupModifierEffects();
        state.options = Object.assign({}, defaultOptions, state.options, options);
        state.scrollParents = {
          reference: isElement$1(reference) ? listScrollParents(reference) : reference.contextElement ? listScrollParents(reference.contextElement) : [],
          popper: listScrollParents(popper)
        };
        var orderedModifiers = orderModifiers(mergeByName([].concat(defaultModifiers, state.options.modifiers)));
        state.orderedModifiers = orderedModifiers.filter((function(m) {
          return m.enabled;
        }));
        runModifierEffects();
        return instance.update();
      },
      forceUpdate: function forceUpdate() {
        if (isDestroyed) {
          return;
        }
        var _state$elements = state.elements, reference = _state$elements.reference, popper = _state$elements.popper;
        if (!areValidElements(reference, popper)) {
          return;
        }
        state.rects = {
          reference: getCompositeRect(reference, getOffsetParent$1(popper), state.options.strategy === "fixed"),
          popper: getLayoutRect(popper)
        };
        state.reset = false;
        state.placement = state.options.placement;
        state.orderedModifiers.forEach((function(modifier) {
          return state.modifiersData[modifier.name] = Object.assign({}, modifier.data);
        }));
        for (var index = 0; index < state.orderedModifiers.length; index++) {
          if (state.reset === true) {
            state.reset = false;
            index = -1;
            continue;
          }
          var _state$orderedModifie = state.orderedModifiers[index], fn = _state$orderedModifie.fn, _state$orderedModifie2 = _state$orderedModifie.options, _options = _state$orderedModifie2 === void 0 ? {} : _state$orderedModifie2, name = _state$orderedModifie.name;
          if (typeof fn === "function") {
            state = fn({
              state: state,
              options: _options,
              name: name,
              instance: instance
            }) || state;
          }
        }
      },
      update: debounce((function() {
        return new Promise((function(resolve) {
          instance.forceUpdate();
          resolve(state);
        }));
      })),
      destroy: function destroy() {
        cleanupModifierEffects();
        isDestroyed = true;
      }
    };
    if (!areValidElements(reference, popper)) {
      return instance;
    }
    instance.setOptions(options).then((function(state) {
      if (!isDestroyed && options.onFirstUpdate) {
        options.onFirstUpdate(state);
      }
    }));
    function runModifierEffects() {
      state.orderedModifiers.forEach((function(_ref) {
        var name = _ref.name, _ref$options = _ref.options, options = _ref$options === void 0 ? {} : _ref$options, effect = _ref.effect;
        if (typeof effect === "function") {
          var cleanupFn = effect({
            state: state,
            name: name,
            instance: instance,
            options: options
          });
          var noopFn = function noopFn() {};
          effectCleanupFns.push(cleanupFn || noopFn);
        }
      }));
    }
    function cleanupModifierEffects() {
      effectCleanupFns.forEach((function(fn) {
        return fn();
      }));
      effectCleanupFns = [];
    }
    return instance;
  };
}

var defaultModifiers = [ eventListeners, popperOffsets$1, computeStyles$1, applyStyles$1, offset$2, flip$2, preventOverflow$1, arrow$2, hide$1 ];

var createPopper = popperGenerator({
  defaultModifiers: defaultModifiers
});

class Popover extends Controller {
  static targets=[ "activator", "popover", "template" ];
  static classes=[ "open", "closed" ];
  static values={
    appendToBody: Boolean,
    placement: String,
    active: Boolean
  };
  connect() {
    const popperOptions = {
      placement: this.placementValue,
      modifiers: [ {
        name: "offset",
        options: {
          offset: [ 0, 5 ]
        }
      }, {
        name: "flip",
        options: {
          allowedAutoPlacements: [ "top-start", "bottom-start", "top-end", "bottom-end" ]
        }
      } ]
    };
    if (this.appendToBodyValue) {
      const clonedTemplate = this.templateTarget.content.cloneNode(true);
      this.target = clonedTemplate.firstElementChild;
      popperOptions["strategy"] = "fixed";
      document.body.appendChild(clonedTemplate);
    }
    this.popper = createPopper(this.activatorTarget, this.target, popperOptions);
    if (this.activeValue) {
      this.show();
    }
  }
  async toggle() {
    this.target.classList.toggle(this.closedClass);
    this.target.classList.toggle(this.openClass);
    await this.popper.update();
  }
  async show() {
    this.target.classList.remove(this.closedClass);
    this.target.classList.add(this.openClass);
    await this.popper.update();
  }
  hide(event) {
    if (this.element.contains(event.target)) return;
    if (this.target.classList.contains(this.closedClass)) return;
    if (this.appendToBodyValue && this.target.contains(event.target)) return;
    this.forceHide();
  }
  forceHide() {
    this.target.classList.remove(this.openClass);
    this.target.classList.add(this.closedClass);
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
    this.tooltip = element.appendChild(tooltip);
    const arrowElement = element.querySelector("[data-tooltip-arrow]");
    autoUpdate(element, this.tooltip, (() => {
      computePosition(element, this.tooltip, {
        placement: this.positionValue,
        middleware: [ offset(this.offsetValue), flip(), shift({
          padding: 5
        }), arrow({
          element: arrowElement
        }) ]
      }).then((({x: x, y: y, placement: placement, middlewareData: middlewareData}) => {
        Object.assign(this.tooltip.style, {
          left: `${x}px`,
          top: `${y}px`
        });
        const {x: arrowX, y: arrowY} = middlewareData.arrow;
        const staticSide = {
          top: "bottom",
          right: "left",
          bottom: "top",
          left: "right"
        }[placement.split("-")[0]];
        Object.assign(arrowElement.style, {
          left: arrowX != null ? `${arrowX}px` : "",
          top: arrowY != null ? `${arrowY}px` : "",
          right: "",
          bottom: "",
          [staticSide]: "-4px"
        });
      }));
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
