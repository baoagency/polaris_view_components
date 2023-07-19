import Autocomplete from './autocomplete_controller'
import Button from './button_controller'
import Collapsible from './collapsible_controller'
import DataTable from './data_table_controller'
import Dropzone from './dropzone_controller'
import Frame from './frame_controller'
import Modal from './modal_controller'
import OptionList from './option_list_controller'
import Polaris from './polaris_controller'
import Popover from './popover_controller'
import ResourceItem from './resource_item_controller'
import Scrollable from './scrollable_controller'
import Select from './select_controller'
import TextField from './text_field_controller'
import Toast from './toast_controller'
import Tooltip from './tooltip_controller'


export { Frame, Modal, Polaris, Popover, ResourceItem, Scrollable, Select, TextField, Tooltip }

export function registerPolarisControllers(application) {
  application.register('polaris-autocomplete', Autocomplete)
  application.register('polaris-button', Button)
  application.register('polaris-collapsible', Collapsible)
  application.register('polaris-dropzone', Dropzone)
  application.register('polaris-data-table', DataTable)
  application.register('polaris-frame', Frame)
  application.register('polaris-modal', Modal)
  application.register('polaris-option-list', OptionList)
  application.register('polaris', Polaris)
  application.register('polaris-popover', Popover)
  application.register('polaris-resource-item', ResourceItem)
  application.register('polaris-scrollable', Scrollable)
  application.register('polaris-select', Select)
  application.register('polaris-text-field', TextField)
  application.register('polaris-toast', Toast)
  application.register('polaris-tooltip', Tooltip)
}
