/**
 * @param {Function} fn
 * @param {number} wait
 *
 * @return {Function}
 */
 export function debounce (fn, wait) {
  let timeoutId

  return (...args) => {
    clearTimeout(timeoutId)
    timeoutId = setTimeout(() => fn.apply(this, args), wait)
  }
}

export function formatBytes (bytes, decimals) {
  if (bytes == 0) return '0 Bytes'
  const k = 1024,
    dm = decimals || 2,
    sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
    i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]
}

export { useTransition } from "./use-transition"
