// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"
import { lazyLoadControllersFrom } from '@hotwired/stimulus-loading'
lazyLoadControllersFrom('controllers', application)

import { registerPolarisControllers } from "polaris-view-components"
registerPolarisControllers(application)
