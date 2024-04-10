import { unref, watch } from "vue"

/**
 * @template Options
 * @template ReturnType
 * @param {typeof Map} globalState - a Map instance for storing global state
 * @param {function(Options): ReturnType} useFunction - use function that returns a reactive state object
 * @param {Options} key - the key to ensure state for
 * @returns {ReturnType} The reactive state object.
 */
function ensureStateFor(globalState, useFunction, key) {
  if ([undefined, null].includes(key)) {
    return useFunction(key) // return without creating mapping for undefined or null keys
  }

  if (globalState.has(key)) {
    return globalState.get(key)
  } else {
    // NOTE: the use function is using an unreffed key here,
    // reactivity is maintined by the watch in the global factory function
    const localState = useFunction(key)
    globalState.set(key, localState)
    return localState
  }
}

/**
 * @template Options
 * @template ReturnType
 * @param {typeof Map} globalState - a Map instance for storing global state
 * @param {function(Options): ReturnType} useFunction - use function that returns a reactive state object
 * @returns {function(Options): ReturnType} The enhanced use function that returns a reactive state object.
 */
export function asGlobalUse(globalState, useFunction) {
  return (key) => {
    watch(
      () => unref(key),
      (newKey) => {
        ensureStateFor(globalState, useFunction, newKey)
      },
      {
        immediate: true,
      }
    )

    return ensureStateFor(globalState, useFunction, unref(key))
  }
}

/**
 * A higher-order function that takes a function and adds global state management to it.
 *
 * @template Options
 * @template ReturnType
 * @param {function(Options): ReturnType} useFunction - use function that returns a reactive state object
 * @returns {function(Options): ReturnType} The enhanced use function that returns a reactive state object.
 */
export function defineUse(useFunction) {
  const globalState = new Map()

  return asGlobalUse(globalState, useFunction)
}
