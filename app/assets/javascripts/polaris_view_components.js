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

function getNodeName(element) {
  return element ? (element.nodeName || "").toLowerCase() : null;
}

function getWindow(node) {
  if (node == null) {
    return window;
  }
  if (node.toString() !== "[object Window]") {
    var ownerDocument = node.ownerDocument;
    return ownerDocument ? ownerDocument.defaultView || window : window;
  }
  return node;
}

function isElement(node) {
  var OwnElement = getWindow(node).Element;
  return node instanceof OwnElement || node instanceof Element;
}

function isHTMLElement(node) {
  var OwnElement = getWindow(node).HTMLElement;
  return node instanceof OwnElement || node instanceof HTMLElement;
}

function isShadowRoot(node) {
  if (typeof ShadowRoot === "undefined") {
    return false;
  }
  var OwnElement = getWindow(node).ShadowRoot;
  return node instanceof OwnElement || node instanceof ShadowRoot;
}

function applyStyles(_ref) {
  var state = _ref.state;
  Object.keys(state.elements).forEach((function(name) {
    var style = state.styles[name] || {};
    var attributes = state.attributes[name] || {};
    var element = state.elements[name];
    if (!isHTMLElement(element) || !getNodeName(element)) {
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
      if (!isHTMLElement(element) || !getNodeName(element)) {
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

var max = Math.max;

var min = Math.min;

var round = Math.round;

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

function getBoundingClientRect(element, includeScale, isFixedStrategy) {
  if (includeScale === void 0) {
    includeScale = false;
  }
  if (isFixedStrategy === void 0) {
    isFixedStrategy = false;
  }
  var clientRect = element.getBoundingClientRect();
  var scaleX = 1;
  var scaleY = 1;
  if (includeScale && isHTMLElement(element)) {
    scaleX = element.offsetWidth > 0 ? round(clientRect.width) / element.offsetWidth || 1 : 1;
    scaleY = element.offsetHeight > 0 ? round(clientRect.height) / element.offsetHeight || 1 : 1;
  }
  var _ref = isElement(element) ? getWindow(element) : window, visualViewport = _ref.visualViewport;
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
  var clientRect = getBoundingClientRect(element);
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
  } else if (rootNode && isShadowRoot(rootNode)) {
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

function getComputedStyle$1(element) {
  return getWindow(element).getComputedStyle(element);
}

function isTableElement(element) {
  return [ "table", "td", "th" ].indexOf(getNodeName(element)) >= 0;
}

function getDocumentElement(element) {
  return ((isElement(element) ? element.ownerDocument : element.document) || window.document).documentElement;
}

function getParentNode(element) {
  if (getNodeName(element) === "html") {
    return element;
  }
  return element.assignedSlot || element.parentNode || (isShadowRoot(element) ? element.host : null) || getDocumentElement(element);
}

function getTrueOffsetParent(element) {
  if (!isHTMLElement(element) || getComputedStyle$1(element).position === "fixed") {
    return null;
  }
  return element.offsetParent;
}

function getContainingBlock(element) {
  var isFirefox = /firefox/i.test(getUAString());
  var isIE = /Trident/i.test(getUAString());
  if (isIE && isHTMLElement(element)) {
    var elementCss = getComputedStyle$1(element);
    if (elementCss.position === "fixed") {
      return null;
    }
  }
  var currentNode = getParentNode(element);
  if (isShadowRoot(currentNode)) {
    currentNode = currentNode.host;
  }
  while (isHTMLElement(currentNode) && [ "html", "body" ].indexOf(getNodeName(currentNode)) < 0) {
    var css = getComputedStyle$1(currentNode);
    if (css.transform !== "none" || css.perspective !== "none" || css.contain === "paint" || [ "transform", "perspective" ].indexOf(css.willChange) !== -1 || isFirefox && css.willChange === "filter" || isFirefox && css.filter && css.filter !== "none") {
      return currentNode;
    } else {
      currentNode = currentNode.parentNode;
    }
  }
  return null;
}

function getOffsetParent(element) {
  var window = getWindow(element);
  var offsetParent = getTrueOffsetParent(element);
  while (offsetParent && isTableElement(offsetParent) && getComputedStyle$1(offsetParent).position === "static") {
    offsetParent = getTrueOffsetParent(offsetParent);
  }
  if (offsetParent && (getNodeName(offsetParent) === "html" || getNodeName(offsetParent) === "body" && getComputedStyle$1(offsetParent).position === "static")) {
    return window;
  }
  return offsetParent || getContainingBlock(element) || window;
}

function getMainAxisFromPlacement(placement) {
  return [ "top", "bottom" ].indexOf(placement) >= 0 ? "x" : "y";
}

function within(min$1, value, max$1) {
  return max(min$1, min(value, max$1));
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

function arrow(_ref) {
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
  var arrowOffsetParent = getOffsetParent(arrowElement);
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

var arrow$1 = {
  name: "arrow",
  enabled: true,
  phase: "main",
  fn: arrow,
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
    x: round(x * dpr) / dpr || 0,
    y: round(y * dpr) / dpr || 0
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
    var offsetParent = getOffsetParent(popper);
    var heightProp = "clientHeight";
    var widthProp = "clientWidth";
    if (offsetParent === getWindow(popper)) {
      offsetParent = getDocumentElement(popper);
      if (getComputedStyle$1(offsetParent).position !== "static" && position === "absolute") {
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
  }, getWindow(popper)) : {
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
  var window = getWindow(state.elements.popper);
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

function getOppositePlacement(placement) {
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
  var win = getWindow(node);
  var scrollLeft = win.pageXOffset;
  var scrollTop = win.pageYOffset;
  return {
    scrollLeft: scrollLeft,
    scrollTop: scrollTop
  };
}

function getWindowScrollBarX(element) {
  return getBoundingClientRect(getDocumentElement(element)).left + getWindowScroll(element).scrollLeft;
}

function getViewportRect(element, strategy) {
  var win = getWindow(element);
  var html = getDocumentElement(element);
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
    x: x + getWindowScrollBarX(element),
    y: y
  };
}

function getDocumentRect(element) {
  var _element$ownerDocumen;
  var html = getDocumentElement(element);
  var winScroll = getWindowScroll(element);
  var body = (_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body;
  var width = max(html.scrollWidth, html.clientWidth, body ? body.scrollWidth : 0, body ? body.clientWidth : 0);
  var height = max(html.scrollHeight, html.clientHeight, body ? body.scrollHeight : 0, body ? body.clientHeight : 0);
  var x = -winScroll.scrollLeft + getWindowScrollBarX(element);
  var y = -winScroll.scrollTop;
  if (getComputedStyle$1(body || html).direction === "rtl") {
    x += max(html.clientWidth, body ? body.clientWidth : 0) - width;
  }
  return {
    width: width,
    height: height,
    x: x,
    y: y
  };
}

function isScrollParent(element) {
  var _getComputedStyle = getComputedStyle$1(element), overflow = _getComputedStyle.overflow, overflowX = _getComputedStyle.overflowX, overflowY = _getComputedStyle.overflowY;
  return /auto|scroll|overlay|hidden/.test(overflow + overflowY + overflowX);
}

function getScrollParent(node) {
  if ([ "html", "body", "#document" ].indexOf(getNodeName(node)) >= 0) {
    return node.ownerDocument.body;
  }
  if (isHTMLElement(node) && isScrollParent(node)) {
    return node;
  }
  return getScrollParent(getParentNode(node));
}

function listScrollParents(element, list) {
  var _element$ownerDocumen;
  if (list === void 0) {
    list = [];
  }
  var scrollParent = getScrollParent(element);
  var isBody = scrollParent === ((_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body);
  var win = getWindow(scrollParent);
  var target = isBody ? [ win ].concat(win.visualViewport || [], isScrollParent(scrollParent) ? scrollParent : []) : scrollParent;
  var updatedList = list.concat(target);
  return isBody ? updatedList : updatedList.concat(listScrollParents(getParentNode(target)));
}

function rectToClientRect(rect) {
  return Object.assign({}, rect, {
    left: rect.x,
    top: rect.y,
    right: rect.x + rect.width,
    bottom: rect.y + rect.height
  });
}

function getInnerBoundingClientRect(element, strategy) {
  var rect = getBoundingClientRect(element, false, strategy === "fixed");
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
  return clippingParent === viewport ? rectToClientRect(getViewportRect(element, strategy)) : isElement(clippingParent) ? getInnerBoundingClientRect(clippingParent, strategy) : rectToClientRect(getDocumentRect(getDocumentElement(element)));
}

function getClippingParents(element) {
  var clippingParents = listScrollParents(getParentNode(element));
  var canEscapeClipping = [ "absolute", "fixed" ].indexOf(getComputedStyle$1(element).position) >= 0;
  var clipperElement = canEscapeClipping && isHTMLElement(element) ? getOffsetParent(element) : element;
  if (!isElement(clipperElement)) {
    return [];
  }
  return clippingParents.filter((function(clippingParent) {
    return isElement(clippingParent) && contains(clippingParent, clipperElement) && getNodeName(clippingParent) !== "body";
  }));
}

function getClippingRect(element, boundary, rootBoundary, strategy) {
  var mainClippingParents = boundary === "clippingParents" ? getClippingParents(element) : [].concat(boundary);
  var clippingParents = [].concat(mainClippingParents, [ rootBoundary ]);
  var firstClippingParent = clippingParents[0];
  var clippingRect = clippingParents.reduce((function(accRect, clippingParent) {
    var rect = getClientRectFromMixedType(element, clippingParent, strategy);
    accRect.top = max(rect.top, accRect.top);
    accRect.right = min(rect.right, accRect.right);
    accRect.bottom = min(rect.bottom, accRect.bottom);
    accRect.left = max(rect.left, accRect.left);
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

function detectOverflow(state, options) {
  if (options === void 0) {
    options = {};
  }
  var _options = options, _options$placement = _options.placement, placement = _options$placement === void 0 ? state.placement : _options$placement, _options$strategy = _options.strategy, strategy = _options$strategy === void 0 ? state.strategy : _options$strategy, _options$boundary = _options.boundary, boundary = _options$boundary === void 0 ? clippingParents : _options$boundary, _options$rootBoundary = _options.rootBoundary, rootBoundary = _options$rootBoundary === void 0 ? viewport : _options$rootBoundary, _options$elementConte = _options.elementContext, elementContext = _options$elementConte === void 0 ? popper : _options$elementConte, _options$altBoundary = _options.altBoundary, altBoundary = _options$altBoundary === void 0 ? false : _options$altBoundary, _options$padding = _options.padding, padding = _options$padding === void 0 ? 0 : _options$padding;
  var paddingObject = mergePaddingObject(typeof padding !== "number" ? padding : expandToHashMap(padding, basePlacements));
  var altContext = elementContext === popper ? reference : popper;
  var popperRect = state.rects.popper;
  var element = state.elements[altBoundary ? altContext : elementContext];
  var clippingClientRect = getClippingRect(isElement(element) ? element : element.contextElement || getDocumentElement(state.elements.popper), boundary, rootBoundary, strategy);
  var referenceClientRect = getBoundingClientRect(state.elements.reference);
  var popperOffsets = computeOffsets({
    reference: referenceClientRect,
    element: popperRect,
    strategy: "absolute",
    placement: placement
  });
  var popperClientRect = rectToClientRect(Object.assign({}, popperRect, popperOffsets));
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
    acc[placement] = detectOverflow(state, {
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
  var oppositePlacement = getOppositePlacement(placement);
  return [ getOppositeVariationPlacement(placement), oppositePlacement, getOppositeVariationPlacement(oppositePlacement) ];
}

function flip(_ref) {
  var state = _ref.state, options = _ref.options, name = _ref.name;
  if (state.modifiersData[name]._skip) {
    return;
  }
  var _options$mainAxis = options.mainAxis, checkMainAxis = _options$mainAxis === void 0 ? true : _options$mainAxis, _options$altAxis = options.altAxis, checkAltAxis = _options$altAxis === void 0 ? true : _options$altAxis, specifiedFallbackPlacements = options.fallbackPlacements, padding = options.padding, boundary = options.boundary, rootBoundary = options.rootBoundary, altBoundary = options.altBoundary, _options$flipVariatio = options.flipVariations, flipVariations = _options$flipVariatio === void 0 ? true : _options$flipVariatio, allowedAutoPlacements = options.allowedAutoPlacements;
  var preferredPlacement = state.options.placement;
  var basePlacement = getBasePlacement(preferredPlacement);
  var isBasePlacement = basePlacement === preferredPlacement;
  var fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipVariations ? [ getOppositePlacement(preferredPlacement) ] : getExpandedFallbackPlacements(preferredPlacement));
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
    var overflow = detectOverflow(state, {
      placement: placement,
      boundary: boundary,
      rootBoundary: rootBoundary,
      altBoundary: altBoundary,
      padding: padding
    });
    var mainVariationSide = isVertical ? isStartVariation ? right : left : isStartVariation ? bottom : top;
    if (referenceRect[len] > popperRect[len]) {
      mainVariationSide = getOppositePlacement(mainVariationSide);
    }
    var altVariationSide = getOppositePlacement(mainVariationSide);
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

var flip$1 = {
  name: "flip",
  enabled: true,
  phase: "main",
  fn: flip,
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
  var referenceOverflow = detectOverflow(state, {
    elementContext: "reference"
  });
  var popperAltOverflow = detectOverflow(state, {
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

function offset(_ref2) {
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

var offset$1 = {
  name: "offset",
  enabled: true,
  phase: "main",
  requires: [ "popperOffsets" ],
  fn: offset
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
  var overflow = detectOverflow(state, {
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
    var min$1 = offset + overflow[mainSide];
    var max$1 = offset - overflow[altSide];
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
    var arrowOffsetParent = state.elements.arrow && getOffsetParent(state.elements.arrow);
    var clientOffset = arrowOffsetParent ? mainAxis === "y" ? arrowOffsetParent.clientTop || 0 : arrowOffsetParent.clientLeft || 0 : 0;
    var offsetModifierValue = (_offsetModifierState$ = offsetModifierState == null ? void 0 : offsetModifierState[mainAxis]) != null ? _offsetModifierState$ : 0;
    var tetherMin = offset + minOffset - offsetModifierValue - clientOffset;
    var tetherMax = offset + maxOffset - offsetModifierValue;
    var preventedOffset = within(tether ? min(min$1, tetherMin) : min$1, offset, tether ? max(max$1, tetherMax) : max$1);
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

function getNodeScroll(node) {
  if (node === getWindow(node) || !isHTMLElement(node)) {
    return getWindowScroll(node);
  } else {
    return getHTMLElementScroll(node);
  }
}

function isElementScaled(element) {
  var rect = element.getBoundingClientRect();
  var scaleX = round(rect.width) / element.offsetWidth || 1;
  var scaleY = round(rect.height) / element.offsetHeight || 1;
  return scaleX !== 1 || scaleY !== 1;
}

function getCompositeRect(elementOrVirtualElement, offsetParent, isFixed) {
  if (isFixed === void 0) {
    isFixed = false;
  }
  var isOffsetParentAnElement = isHTMLElement(offsetParent);
  var offsetParentIsScaled = isHTMLElement(offsetParent) && isElementScaled(offsetParent);
  var documentElement = getDocumentElement(offsetParent);
  var rect = getBoundingClientRect(elementOrVirtualElement, offsetParentIsScaled, isFixed);
  var scroll = {
    scrollLeft: 0,
    scrollTop: 0
  };
  var offsets = {
    x: 0,
    y: 0
  };
  if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
    if (getNodeName(offsetParent) !== "body" || isScrollParent(documentElement)) {
      scroll = getNodeScroll(offsetParent);
    }
    if (isHTMLElement(offsetParent)) {
      offsets = getBoundingClientRect(offsetParent, true);
      offsets.x += offsetParent.clientLeft;
      offsets.y += offsetParent.clientTop;
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
          reference: isElement(reference) ? listScrollParents(reference) : reference.contextElement ? listScrollParents(reference.contextElement) : [],
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
          reference: getCompositeRect(reference, getOffsetParent(popper), state.options.strategy === "fixed"),
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

var defaultModifiers = [ eventListeners, popperOffsets$1, computeStyles$1, applyStyles$1, offset$1, flip$1, preventOverflow$1, arrow$1, hide$1 ];

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
}

export { Frame, Modal, Polaris, Popover, ResourceItem, Scrollable, Select, TextField, registerPolarisControllers };
