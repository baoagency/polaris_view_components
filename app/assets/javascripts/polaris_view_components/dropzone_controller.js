import { Controller } from '@hotwired/stimulus'
import { debounce, formatBytes } from './utils'

const dragEvents = ['dragover', 'dragenter', 'drop']
const SIZES = {
  SMALL: 'small',
  MEDIUM: 'medium',
  LARGE: 'large',
  EXTRA_LARGE: 'extraLarge',
}

// eslint-disable-next-line import/no-default-export
export default class extends Controller {
  static targets = [
    'container',
    'fileUpload',
    'loader',
    'input',
    'preview',
    'previewTemplate',
    'itemTemplate',
    'overlay',
    'errorOverlay'
  ]
  static classes = ['disabled']
  static values = {
    accept: String,
    allowMultiple: Boolean,
    disabled: Boolean,
    dropOnPage: Boolean,
    focused: Boolean,
    renderPreview: Boolean,
    size: String,
    removePreviewsAfterUpload: Boolean
  }

  files = []
  rejectedFiles = []
  _dragging = false
  dragTargets = []
  previewRendered = false

  _acceptedFiles = []
  _size = 'large'

  connect () {
    document.body.addEventListener('click', this.onExternalTriggerClick)
    addEventListener('resize', this.onWindowResize)
    addEventListener('direct-uploads:start', this.onDirectUploadsStart)
    addEventListener('direct-uploads:end', this.onDirectUploadsEnd)
    addEventListener('direct-upload:initialize', this.onDirectUploadInitialize)
    addEventListener('direct-upload:start', this.onDirectUploadStart)
    addEventListener('direct-upload:progress', this.onDirectUploadProgress)
    addEventListener('direct-upload:error', this.onDirectUploadError)
    addEventListener('direct-upload:end', this.onDirectUploadEnd)

    this.onWindowResize()
  }

  disconnect () {
    document.body.removeEventListener('click', this.onExternalTriggerClick)
    removeEventListener('resize', this.onWindowResize)
    removeEventListener('direct-uploads:start', this.onDirectUploadsStart)
    removeEventListener('direct-uploads:end', this.onDirectUploadsEnd)
    removeEventListener('direct-upload:initialize', this.onDirectUploadInitialize)
    removeEventListener('direct-upload:start', this.onDirectUploadStart)
    removeEventListener('direct-upload:progress', this.onDirectUploadProgress)
    removeEventListener('direct-upload:error', this.onDirectUploadError)
    removeEventListener('direct-upload:end', this.onDirectUploadEnd)
  }

  onExternalTriggerClick = (event) => {
    const trigger = event.target.closest(`[data-${this.identifier}-external-target="trigger"]`)
    if (!trigger) return

    event.preventDefault()

    this.onClick()
  }

  onWindowResize = debounce(() => {
    const size = this.calculateSize()

    if (size !== this.size) {
      this.size = size
    }
  }, 50)

  onBlur () {
    this.focusedValue = false
  }

  onChange (e) {
    this.stopEvent(e)
    if (this.disabled) return

    const fileList = getDataTransferFiles(e)
    this.clearFiles()

    const { files, acceptedFiles, rejectedFiles } = this.getValidatedFiles(fileList)
    this.dragTargets = []

    this.files = files
    this.acceptedFiles = acceptedFiles
    this.rejectedFiles = rejectedFiles

    this.render()
  }

  onDragOver (e) {
    this.stopEvent(e)
    if (this.disabled) return
  }

  onDragEnter (e) {
    this.stopEvent(e)
    if (this.disabled) return

    if (e.target && !this.dragTargets.includes(e.target)) {
      this.dragTargets.push(e.target)
    }

    if (this.dragging) return

    this.dragging = true
  }

  onDragLeave (e) {
    this.stopEvent(e)
    if (this.disabled) return

    this.dragTargets = this.dragTargets.filter(el => {
      const compareNode = this.element

      return el !== e.target && compareNode && compareNode.contains(el)
    })

    if (this.dragTargets.length > 0) return

    this.dragging = false
  }

  onDrop (e) {
    this.stopEvent(e)
    if (this.disabled) return

    this.dragging = false

    this.onChange(e)
  }

  onFocus () {
    this.focusedValue = true
  }

  onClick () {
    if (this.disabledValue) return

    this.open()
  }

  onDirectUploadsStart = () => {
    this.disable()
  }

  onDirectUploadsEnd = () => {
    this.enable()
    this.clearFiles(this.removePreviewsAfterUploadValue)

    if (this.acceptedFiles.length === 0) return

    if (this.hasLoaderTarget)
      this.loaderTarget.classList.remove("Polaris--hidden")
  }

  onDirectUploadInitialize = (event) => {
    const { target, detail } = event
    const { id, file } = detail
    const dropzone = target.closest('.Polaris-DropZone')
    if (!dropzone) return
    if (this.acceptedFiles.length === 0) return

    if (this.sizeValue == 'small') {
      this.removePreview()
      if (this.hasLoaderTarget)
        this.loaderTarget.classList.remove("Polaris--hidden")
    } else {
      const content = dropzone.querySelector(`[data-file-name="${file.name}"]`)
      if (content) {
        const progressBar = content.parentElement.querySelector('[data-target="progress-bar"]')
        progressBar.id = `direct-upload-${id}`
      }
    }
  }

  onDirectUploadStart = (event) => {
    const { id } = event.detail
    const progressBar = document.getElementById(`direct-upload-${id}`)
    if (!progressBar) return

    progressBar.classList.remove("Polaris--hidden")
  }

  onDirectUploadProgress = (event) => {
    const { id, progress } = event.detail
    const progressBar = document.getElementById(`direct-upload-${id}`)
    if (!progressBar) return

    const progressElement = progressBar.querySelector('.Polaris-ProgressBar__Indicator')
    progressElement.style.width = `${progress}%`
  }

  onDirectUploadError = (event) => {
    const { id, error } = event.detail
    const progressBar = document.getElementById(`direct-upload-${id}`)
    if (!progressBar) return

    event.preventDefault()
    progressBar.classList.add("Polaris--hidden")
    const uploadError = progressBar.parentElement.querySelector('[data-target="upload-error"]')
    const errorIcon = uploadError.querySelector('.Polaris-InlineError__Icon')
    if (errorIcon) errorIcon.remove()
    uploadError.classList.remove("Polaris--hidden")
  }

  onDirectUploadEnd = (event) => {
    const { id } = event.detail
    const progressBar = document.getElementById(`direct-upload-${id}`)
    if (!progressBar) return

    progressBar.classList.add("Polaris-ProgressBar--colorSuccess")
  }

  open () {
    this.inputTarget.click()
  }

  focusedValueChanged () {
    this.element.classList.toggle('Polaris-DropZone--focused', this.focusedValue)
  }

  stopEvent (e) {
    e.preventDefault()
    e.stopPropagation()
  }

  getValidatedFiles (files) {
    const acceptedFiles = []
    const rejectedFiles = []

    Array.from(files).forEach(file => {
      if (fileAccepted(file, this.acceptValue)) {
        acceptedFiles.push(file)
      } else {
        rejectedFiles.push(file)
      }
    })

    if (!this.allowMultipleValue) {
      acceptedFiles.splice(1, acceptedFiles.length)
      rejectedFiles.push(...acceptedFiles.slice(1))
    }

    return { files, acceptedFiles, rejectedFiles }
  }

  render () {
    if (this.files.length === 0) {
      this.toggleFileUpload(true)
      this.toggleErrorOverlay(false)
    } else if (this.rejectedFiles.length > 0) {
      this.toggleFileUpload(false)
      this.toggleErrorOverlay(true)

      const dropRejectedEvent = new CustomEvent('polaris-dropzone:drop-rejected', {
        bubbles: true,
        detail: { rejectedFiles: this.rejectedFiles }
      })
      this.element.dispatchEvent(dropRejectedEvent)
    } else if (this.acceptedFiles.length > 0) {
      if (this.renderPreviewValue) {
        this.renderUploadedFiles()
        this.toggleFileUpload(false)
      }

      this.toggleErrorOverlay(false)

      const dropAcceptedEvent = new CustomEvent('polaris-dropzone:drop-accepted', {
        bubbles: true,
        detail: {acceptedFiles: this.acceptedFiles }
      })
      this.element.dispatchEvent(dropAcceptedEvent)
    }

    const dropEvent = new CustomEvent('polaris-dropzone:drop', {
      bubbles: true,
      detail: {
        files: this.files,
        acceptedFiles: this.acceptedFiles,
        rejectedFiles: this.rejectedFiles
      }
    })
    this.element.dispatchEvent(dropEvent)
  }

  renderUploadedFiles () {
    if (this.acceptedFiles.length === 0) return

    const clone = this.previewTemplateTarget.content.cloneNode(true)
    const filesTarget = clone.querySelector('.target')
    let files = this.acceptedFiles

    if (this.sizeValue == 'small') files = [files[0]]

    files
      .map(file => this.renderFile(file))
      .forEach(fragment => filesTarget.parentNode.appendChild(fragment))
    filesTarget.remove()

    this.containerTarget.prepend(clone)

    this.previewRendered = true
  }

  toggleFileUpload (show = false) {
    this.fileUploadTarget.classList.toggle('Polaris-VisuallyHidden', !show)
  }

  toggleErrorOverlay (show = false) {
    this.errorOverlayTarget.classList.toggle('Polaris-VisuallyHidden', !show)
    this.element.classList.toggle('Polaris-DropZone--hasError', show)
  }

  renderFile (file) {
    const validImageTypes = ['image/gif', 'image/jpeg', 'image/png', 'image/svg+xml']
    const clone = this.itemTemplateTarget.content.cloneNode(true)
    const [icon, thumbnail, content, fileSize] = [
      clone.querySelector('[data-target="icon"]'),
      clone.querySelector('[data-target="thumbnail"]'),
      clone.querySelector('[data-target="content"]'),
      clone.querySelector('[data-target="file-size"]')
    ]

    if (validImageTypes.includes(file.type)) {
      const img = thumbnail.querySelector('img')
      img.alt = file.name
      img.src = window.URL.createObjectURL(file)
      icon.remove()
    } else {
      thumbnail.remove()
    }

    if (this.sizeValue != 'small') {
      content.insertAdjacentText('afterbegin', file.name)
      content.setAttribute('data-file-name', file.name)
      fileSize.textContent = formatBytes(file.size)
    }

    return clone
  }

  clearFiles (removePreview = true) {
    if (!this.previewRendered) return

    this.acceptedFiles = []
    this.files = []
    this.rejectedFiles = []

    if (removePreview)
      this.removePreview()
  }

  removePreview () {
    if (!this.hasPreviewTarget) return

    this.previewTarget.remove()
    this.previewRendered = false
  }

  calculateSize () {
    const width = this.element.getBoundingClientRect().width

    let size = SIZES.LARGE

    if (width < 100) {
      size = SIZES.SMALL
    } else if (width < 160) {
      size = SIZES.MEDIUM
    } else if (width > 300) {
      size = SIZES.EXTRA_LARGE
    }

    this.size = size

    return size
  }

  getSizeClass (size = 'large') {
    return this.sizeClassesSchema[size] || this.sizeClassesSchema.large
  }

  disable() {
    this.disabled = true
    this.element.classList.add(this.disabledClass)
    this.inputTarget.disabled = true
  }

  enable() {
    this.disabled = false
    this.element.classList.remove(this.disabledClass)
    this.inputTarget.disabled = false
  }

  get fileListRendered () {
    return this.element.querySelector('[data-rendered]')
  }

  get dropNode () {
    return this.dropOnPageValue ? document : this.element
  }

  get disabled () {
    return this.disabledValue
  }

  set disabled (val) {
    this.disabledValue = val
  }

  get dragging () {
    return this._dragging
  }

  set dragging (val) {
    this._dragging = val

    this.element.classList.toggle('Polaris-DropZone--isDragging', val)
    this.overlayTarget.classList.toggle('Polaris-VisuallyHidden', !val)
  }

  get sizeClassesSchema () {
    return {
      [SIZES.SMALL]: 'Polaris-DropZone--sizeSmall',
      [SIZES.MEDIUM]: 'Polaris-DropZone--sizeMedium',
      [SIZES.LARGE]: 'Polaris-DropZone--sizeLarge',
      [SIZES.EXTRA_LARGE]: 'Polaris-DropZone--sizeExtraLarge',
    }
  }

  get size () {
    return this._size
  }

  set size (val) {
    this._size = val

    const sizeClassesToRemove = Object.values(this.sizeClassesSchema)
    sizeClassesToRemove.forEach(className => this.element.classList.remove(className))

    this.element.classList.add(this.getSizeClass(val))
  }

  get acceptedFiles () {
    return this._acceptedFiles
  }

  set acceptedFiles (val) {
    this._acceptedFiles = val

    const list = new DataTransfer()

    val.forEach(file => list.items.add(file))

    this.inputTarget.files = list.files
  }
}

export function fileAccepted (file, accept) {
  return file.type === 'application/x-moz-file' || accepts(file, accept)
}

export function getDataTransferFiles (event) {
  if (isDragEvent(event) && event.dataTransfer) {
    const dt = event.dataTransfer

    if (dt.files && dt.files.length) {
      return Array.from(dt.files)
    } else if (dt.items && dt.items.length) {
      // Chrome is the only browser that allows to read the file list on drag
      // events and uses `items` instead of `files` in this case.
      return Array.from(dt.items)
    }
  } else if (isChangeEvent(event) && event.target.files) {
    // Return files from even when a file was selected from an upload dialog
    return Array.from(event.target.files)
  }

  return []
}

function accepts (file, acceptedFiles = ['']) {
  if (file && acceptedFiles) {
    const fileName = file.name || ''
    const mimeType = file.type || ''
    const baseMimeType = mimeType.replace(/\/.*$/, '')
    const acceptedFilesArray = Array.isArray(acceptedFiles)
      ? acceptedFiles
      : acceptedFiles.split(',')

    return acceptedFilesArray.some((type) => {
      const validType = type.trim()
      if (validType.startsWith('.')) {
        return fileName.toLowerCase().endsWith(validType.toLowerCase())
      } else if (validType.endsWith('/*')) {
        // This is something like a image/* mime type
        return baseMimeType === validType.replace(/\/.*$/, '')
      }

      return mimeType === validType
    })
  }

  return true
}

function isDragEvent (event) {
  return dragEvents.indexOf(event.type) > 0
}

function isChangeEvent (event) {
  return event.type === 'change'
}
