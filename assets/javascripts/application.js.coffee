#= require vendor
#= require_self

$.getJSON '/templates.json', (data) =>
  @templates = data
  ich.addTemplate(template.name, template.template) for template in data
  $(window).trigger('templates-loaded')

History = window.History
@dmp = new diff_match_patch
@basetext = ''
@url = document.URL
@pad = @url.substring(@url.lastIndexOf('/') + 1);

$(window).on 'templates-loaded', =>
  #icanhaz templates available
  $(window).on 'statechange', =>
    State = History.getState()
    History.log(State.data, State.title, State.url)
  
ws = new WebSocket('ws://localhost:9000/ws')
ws.onmessage = (evt) =>
  console.log "evt.data: #{evt.data}"
  msg = JSON.parse(evt.data)
  switch msg.type
    when 'subscription'
      console.log 'subscribed'
    when 'basetext'
      @basetext = msg.basetext
      input_text = @basetext
    when 'update'
      patch = dmp.patch_fromText( msg.diff )
      input_text = dmp.patch_apply(patch, @basetext)[0]
  $("#inputarea").val( input_text )
ws.onopen = (evt) =>
  console.log 'connected'
  ws.send JSON.stringify({ 'type' : 'subscribe', 'pad' : @pad })
ws.onclose = (evt) =>
  console.log 'disconnected'
ws.onerror = (evt) =>
  console.log "error #{evt}"

$('#container').on 'keyup', '#inputarea', (e) =>
  unless @basetext == e.currentTarget.value
    diff = dmp.patch_toText( dmp.patch_make( @basetext, e.currentTarget.value ))
    ws.send JSON.stringify({ 'type': 'update', 'pad' : @pad, 'diff' : diff })