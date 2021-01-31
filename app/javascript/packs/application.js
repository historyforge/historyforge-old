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

window.showSubmitButton = function() {
  document.getElementById('contact-submit-btn').style.display = 'block'
}

import Cart from './../js/cart'
import "controllers"
import React from 'react'
import ReactDOM from 'react-dom'
import Forge from '../forge/App'
import MiniForge from '../miniforge/App'

window.cart = new Cart()

document.addEventListener('DOMContentLoaded', () => {
  const forge = document.getElementById('forge')
  if (forge) ReactDOM.render(<Forge />, forge)
  const miniforge = document.getElementById('miniforge')
  if (miniforge) ReactDOM.render(<MiniForge />, miniforge)
})