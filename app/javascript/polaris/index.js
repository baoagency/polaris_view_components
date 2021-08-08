import Select from './select_controller'
import TextField from './text_field_controller'

export { Select, TextField }

export function registerPolarisControllers(application) {
  application.register('polaris-select', Select)
  application.register('polaris-text-field', TextField)
}
