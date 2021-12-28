import { Controller } from "@hotwired/stimulus"

const dragEvents = ['dragover', 'dragenter', 'drop']

// eslint-disable-next-line import/no-default-export
export default class extends Controller {
  static targets = ['container', 'fileUpload', 'input', 'itemTemplate', 'itemsTemplate', 'overlay', 'errorOverlay']
  static values = {
    accept: String,
    allowMultiple: Boolean,
    disabled: Boolean,
    dropOnPage: Boolean,
    focused: Boolean,
  }

  files = []
  acceptedFiles = []
  rejectedFiles = []
  _dragging = false
  dragTargets = []
  filesRendered = false

  initialize () {
    super.initialize()

    console.log(this)
  }

  connect () {
    super.connect()

    this.onExternalTriggerClick = this.onExternalTriggerClick.bind(this)

    document.body.addEventListener('click', this.onExternalTriggerClick)
  }

  disconnect () {
    super.disconnect()

    document.body.removeEventListener('click', this.onExternalTriggerClick)
  }

  onExternalTriggerClick (e) {
    const trigger = e.target.closest(`[data-${this.identifier}-external-target="trigger"]`)
    if (!trigger) return

    e.preventDefault()

    this.onClick()
  }

  onBlur () {
    this.focusedValue = false
  }

  onChange (e) {
    this.stopEvent(e)
    if (this.disabled) return

    this.clearFiles()

    const fileList = getDataTransferFiles(e)
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
      if (!fileAccepted(file, this.acceptValue)) {
        return rejectedFiles.push(file)
      }

      acceptedFiles.push(file)
    })

    if (!this.allowMultipleValue) {
      acceptedFiles.splice(1, acceptedFiles.length)
      rejectedFiles.push(...acceptedFiles.slice(1))
    }

    return { files, acceptedFiles, rejectedFiles }
  }

  render () {
    console.log(this, this.files, this.rejectedFiles)

    if (this.files.length === 0) {
      this.toggleFileUpload(true)
      this.toggleErrorOverlay(false)
    } else if (this.rejectedFiles.length > 0) {
      this.toggleFileUpload(false)
      this.toggleErrorOverlay(true)
    } else if (this.acceptedFiles.length > 0) {
      this.renderUploadedFiles()

      this.toggleFileUpload(false)
      this.toggleErrorOverlay(false)
    }
  }

  renderUploadedFiles () {
    if (this.acceptedFiles.length === 0) return

    const clone = this.itemsTemplateTarget.content.cloneNode(true)
    const filesTarget = clone.querySelector('.target')

    this.acceptedFiles
      .map(file => this.renderFile(file))
      .forEach(fragment => filesTarget.parentNode.appendChild(fragment))
    filesTarget.remove()

    this.containerTarget.prepend(clone)

    this.filesRendered = true
  }

  toggleFileUpload (show = false) {
    this.fileUploadTarget.classList.toggle('Polaris-VisuallyHidden', !show)
  }

  toggleErrorOverlay (show = false) {
    this.errorOverlayTarget.classList.toggle('Polaris-VisuallyHidden', !show)
    this.element.classList.toggle('Polaris-DropZone--hasError', show)
  }

  renderFile (file) {
    const validImageTypes = ['image/gif', 'image/jpeg', 'image/png']
    const clone = this.itemTemplateTarget.content.cloneNode(true)
    const [svg, image, content, caption] = [
      clone.querySelector('svg'),
      clone.querySelector('img'),
      clone.querySelector('.content'),
      clone.querySelector('.Polaris-Caption'),
    ]

    if (validImageTypes.includes(file.type)) {
      image.alt = file.name
      image.src = validImageTypes.includes(file.type)
        ? window.URL.createObjectURL(file)
        : 'data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAgMjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBkPSJNNiAxMWg4VjlINnYyem0wIDRoOHYtMkg2djJ6bTAtOGg0VjVINnYyem02LTVINS41QTEuNSAxLjUgMCAwMDQgMy41djEzQTEuNSAxLjUgMCAwMDUuNSAxOGg5YTEuNSAxLjUgMCAwMDEuNS0xLjVWNmwtNC00eiIgZmlsbD0iIzVDNUY2MiIvPjwvc3ZnPgo='

      const parent = svg.closest('.Polaris-Stack__Item')

      if (parent) parent.remove()
    } else {
      const parent = image.closest('.Polaris-Stack__Item')

      if (parent) parent.remove()
    }

    content.insertAdjacentText('afterbegin', file.name)
    caption.textContent = `${file.size} bytes`

    return clone
  }

  clearFiles () {
    if (!this.filesRendered) return

    this.acceptedFiles = []
    this.files = []
    this.rejectedFiles = []

    if (!this.fileListRendered) return

    this.fileListRendered.remove()
    this.filesRendered = false
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
