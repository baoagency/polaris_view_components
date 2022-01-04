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
