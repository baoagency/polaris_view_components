import { Application } from 'stimulus'

import TextField from './text_field'

export {
  TextField,
}

export function registerPolarisStimulusControllers (application: Application) {
  application.register('text-field', TextField)
}
