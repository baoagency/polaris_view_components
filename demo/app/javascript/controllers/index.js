// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

// For local development
import { registerPolarisControllers } from "../../../../app/assets/javascripts/polaris"
registerPolarisControllers(application)

// Test before release
// import "polaris-view-components"
// registerPolarisControllers(application)
