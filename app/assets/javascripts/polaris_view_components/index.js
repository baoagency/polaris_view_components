import ResourceItem from './resource_item_controller'
import Scrollable from './scrollable_controller'
import Select from './select_controller'
import TextField from './text_field_controller'

export { ResourceItem, Scrollable, Select, TextField }

export function registerPolarisControllers(application) {
  application.register('polaris-resource-item', ResourceItem)
  application.register('polaris-scrollable', Scrollable)
  application.register('polaris-select', Select)
  application.register('polaris-text-field', TextField)
}
