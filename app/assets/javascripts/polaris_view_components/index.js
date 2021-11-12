import Button from './button_controller'
import Modal from './modal_controller'
import Polaris from './polaris_controller'
import Popover from './popover_controller'
import ResourceItem from './resource_item_controller'
import Scrollable from './scrollable_controller'
import Select from './select_controller'
import TextField from './text_field_controller'

export { Modal, Polaris, Popover, ResourceItem, Scrollable, Select, TextField }

export function registerPolarisControllers(application) {
  application.register('polaris-button', Button)
  application.register('polaris-modal', Modal)
  application.register('polaris', Polaris)
  application.register('polaris-popover', Popover)
  application.register('polaris-resource-item', ResourceItem)
  application.register('polaris-scrollable', Scrollable)
  application.register('polaris-select', Select)
  application.register('polaris-text-field', TextField)
}
