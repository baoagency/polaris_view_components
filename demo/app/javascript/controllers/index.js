// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"
import { registerControllersFrom } from "@hotwired/stimulus-importmap-autoloader"
registerControllersFrom("controllers", application)

import { registerPolarisControllers } from "polaris-view-components"
registerPolarisControllers(application)
