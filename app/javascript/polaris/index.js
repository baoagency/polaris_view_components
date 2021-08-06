import Select from './select_controller'

export { Select }

export function registerPolarisControllers(application) {
  application.register('polaris-select', Select)
}
