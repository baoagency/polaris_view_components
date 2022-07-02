// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

import "controllers"

document.documentElement.className = document.documentElement.className.replace('no-js', 'js');
