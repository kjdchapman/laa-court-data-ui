// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import '../stylesheets/application.scss'
import { loadAnalytics } from '../javascripts/analytics.js'
import CookieBanner from '../javascripts/cookie-banner'
require('@rails/ujs').start()
require('govuk-frontend').initAll()
require.context('govuk-frontend/govuk/assets')
loadAnalytics()
new CookieBanner() // eslint-disable-line
// require("@rails/activestorage").start();
// require("channels");

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
