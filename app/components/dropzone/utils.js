const dragEvents = ['dragover', 'dragenter', 'drop']

export function fileAccepted (file, accept) {
  return file.type === 'application/x-moz-file' || accepts(file, accept)
}

export function getDataTransferFiles (event) {
  console.log(event, isDragEvent(event), isChangeEvent(event))

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
