#= require vendor
#= require_self

$.getJSON '/templates.json', (data) =>
  @templates = data
  ich.addTemplate(template.name, template.template) for template in data
  $(window).trigger('templates-loaded')

History = window.History

$(window).on 'templates-loaded', =>
  #icanhaz templates available
  $(window).on 'statechange', =>
    State = History.getState()
    History.log(State.data, State.title, State.url)
