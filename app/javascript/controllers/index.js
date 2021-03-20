// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

const application = Application.start()
const context = require.context('controllers', true, /_controller\.js$/)

application.load(definitionsFromContext(context))

const componentContext = require.context('../../components', true, /controller\.js$/)
application.load(componentDefinitionsFromContext(componentContext))

function componentDefinitionsFromContext (context) {
  return context.keys()
    .map(key => definitionForModuleWithContextAndKey(context, key))
    .filter(value => value)
}

function definitionForModuleWithContextAndKey (context, key) {
  const identifier = identifierForContextKey(key)

  if (identifier) {
    return definitionForModuleAndIdentifier(context(key), identifier)
  }
}

function definitionForModuleAndIdentifier (module, identifier) {
  const controllerConstructor = module.default
  if (typeof controllerConstructor === 'function') {
    return { identifier, controllerConstructor }
  }
}

function identifierForContextKey (key) {
  const logicalName = (key.match(/^(?:\.\/)?(.+)(?:\/controller\..+?)$/) || [])[1]

  if (logicalName) {
    return logicalName.replace(/_/g, '-').replace(/\//g, '--')
  }
}
