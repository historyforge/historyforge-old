String.prototype.strip = -> @replace(/^\s+/, '').replace(/\s+$/, '')
String.prototype.toSlug = -> @strip().toLowerCase().replace(/[^-a-z0-9~\s\.:;+=_]/g, '').replace(/[\s\.:;=+]+/g, '-')

# This section handles the activation of rich text editors and codemirror on the cms page form
$(document).ready ->
  $('#cms_page_title').change ->
    if $('#cms_page_automatic_url_alias').is(':checked')
      $('#cms_page_url_path').val @value.toSlug()

# Powers the Save & Edit button
$(document).on 'click', '.save-edit', ->
  $('#next').val 'edit'
$(document).on 'click', '.save-view', ->
  $('#next').val 'view'
$(document).on 'submit', '#cms-page-form', ->
  nextOption = $('#next').val()
  return nextOption and nextOption isnt ''

$(document).on 'click', '#add-picture-button', (event) -> add_cms_page_widget('picture', event)
$(document).on 'click', '#add-embed-button', (event) -> add_cms_page_widget('embed', event)
$(document).on 'click', '#add-audio-button', (event) -> add_cms_page_widget('audio', event)
$(document).on 'click', '#add-document-button', (event) -> add_cms_page_widget('document', event)
$(document).on 'click', '#add-text-button', (event) -> add_cms_page_widget('text', event)

add_cms_page_widget = (widget, event, callback) ->
  event.preventDefault()
  event.stopPropagation()
  name = prompt "What is your administrative name for this #{widget} section?"
  if name
    add_the_cms_widget(widget, name, callback)
    return
  return false

add_the_cms_widget = (widget, name, callback) ->
  code_name = name.toLowerCase().replace(/\W+/g, '-')

  # create the tab
  tab_link = $("<a class=\"dropdown-item\" href=\"##{code_name}\" data-toggle=\"tab\">#{name}</a>")

  # create the form
  tab_pane = $("#new_#{widget}_fields").text()
  new_id = new Date().getTime()
  regexp = new RegExp("new_widgets", "g")
  tab_pane = $ tab_pane.replace(regexp, new_id)
  tab_pane.find('input.id').remove()
  tab_pane.find('input.human_name').val(name)
  tab_pane.find('input.name').val(code_name)
  tab_pane.find('h3:first').text(name).append("<span class=\"badge badge-danger\">Not Saved</span>")
  tab_pane.attr('id', code_name)

  # add to the dom
  $('.nav-tabs li.nav-item:last .dropdown-menu').append tab_link
  $('.tab-pane:last').before tab_pane

  # select the tab
  tab_link.tab('show')

  available_tokens = []
  $('.page-section input.name').each -> available_tokens.push "{{#{@value}}}"
  $('#available-tokens').html available_tokens.join(', ')

  callback(new_id) if callback

  return
