/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import 'trix/dist/trix.css'
import '../css/cms'

require("trix")
require("@rails/actiontext")
require("@rails/activestorage").start()

window.CodeMirror = require("codemirror")
require("codemirror/mode/css/css")
require("codemirror/mode/htmlmixed/htmlmixed")
require("codemirror/addon/edit/closetag")
require("codemirror/addon/edit/matchtags")
require("codemirror/addon/edit/matchbrackets")

$(document).ready(function() {
  $('a[data-toggle="tab"][href="#template"]').on('shown.bs.tab', function() {
    $('.CodeMirror').each(function() {
      this.CodeMirror.refresh()
    })
  })
  $('textarea.codemirror').each(function() {
    CodeMirror.fromTextArea(this, {
      lineNumbers: true,
      theme: 'darcula'
    });
  })
})


