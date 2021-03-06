#= require mobile3/models/common_model

window.inbox = []
window.myid  = 24

class @M4_Message extends M4_CommonModel
  initialize: ->
    obj = @
    if @has('distributions')
      @distributions = new M4_Distributions @get('distributions')
      _(@distributions.models).each (dist) ->
        dist.set({'message': obj})
        window.inbox = window.inbox.concat(dist) if dist.get('member_id') == window.myid
  hasRSVP:      -> @has('rsvp_prompt')
  sentCount:    -> @distributions.models.length
  readCount:    ->
    val = _(@distributions.models).select (dist)->
      dist.get('read') == "yes"
    val.length
  unreadCount:  ->
    val = _(@distributions.models).select (dist)->
      dist.get('read') == "no"
    val.length
  rsvpYesCount: ->
    val = _(@distributions.models).select (dist)->
      dist.get('rsvp') == "yes"
    val.length
  rsvpNoCount:  ->
    val = _(@distributions.models).select (dist)->
      dist.get('rsvp') == "no"
    val.length