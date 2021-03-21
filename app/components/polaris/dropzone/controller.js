import { Controller } from 'stimulus'

import { fileAccepted, getDataTransferFiles } from './utils'

// eslint-disable-next-line import/no-default-export
export default class extends Controller {
  static targets = ['container', 'fileUpload', 'input', 'itemTemplate', 'itemsTemplate', 'overlay']
  static values = {
    accept: String,
    allowMultiple: Boolean,
    disabled: Boolean,
    dropOnPage: Boolean,
    focused: Boolean,
  }

  _files = []
  _acceptedFiles = []
  _rejectedFiles = []
  _dragging = false
  dragTargets = []
  filesRendered = false

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

  renderUploadedFiles () {
    if (this.files.length === 0) return

    const clone = this.itemsTemplateTarget.content.cloneNode(true)
    const filesTarget = clone.querySelector('.target')

    this.files
      .map(file => this.renderFile(file))
      .forEach(fragment => filesTarget.parentNode.appendChild(fragment))
    filesTarget.remove()

    this.containerTarget.prepend(clone)

    this.filesRendered = true
  }

  renderFile (file) {
    const clone = this.itemTemplateTarget.content.cloneNode(true)
    const [image, content, caption] = [
      clone.querySelector('img'),
      clone.querySelector('.content'),
      clone.querySelector('.Polaris-Caption'),
    ]
    image.alt = file.name
    image.src = window.URL.createObjectURL(file)
    content.insertAdjacentText('afterbegin', file.name)
    caption.textContent = `${file.size} bytes`

    return clone
  }

  clearFiles () {
    if (!this.filesRendered) return

    this.acceptedFiles = []
    this.files = []
    this.rejectedFiles = []

    const rendered = this.element.querySelector('[data-rendered]')
    if (!rendered) return

    rendered.remove()
    this.filesRendered = false
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

  get files () {
    return this._files
  }

  set files (val) {
    this._files = val

    const hasFiles = val.length > 0

    this.fileUploadTarget.classList.toggle('Polaris-VisuallyHidden', hasFiles)

    if (hasFiles && !this.filesRendered) {
      this.renderUploadedFiles()
    }
  }

  get acceptedFiles () {
    return this._acceptedFiles
  }

  set acceptedFiles (val) {
    this._acceptedFiles = val
  }

  get rejectedFiles () {
    return this._rejectedFiles
  }

  set rejectedFiles (val) {
    this._rejectedFiles = val
  }
}
