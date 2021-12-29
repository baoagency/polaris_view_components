/**
 * @param {Function} fn
 * @param {number} wait
 *
 * @return {Function}
 */
export function debounce (fn, wait) {
  let t

  return (...args) => {
    clearTimeout(t)
    t = setTimeout(() => fn.apply(this, args), wait)
  }
}
