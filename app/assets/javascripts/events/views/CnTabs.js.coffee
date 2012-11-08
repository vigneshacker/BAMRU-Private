class BB.Views.CnTabs extends Backbone.Marionette.Layout

  # ----- configuration -----

  template: 'events/templates/CnTabs'

  regions:
    tmenu:    '#tmenu'
    tbody:    '#tbody'

  # ----- initialization -----

  initialize: (options) ->
    @router = BB.Routers.app
    @page   = options.page
    @model  = BB.Collections.events.get(options.modelId)
    @model.periods.fetch()
    @model.eventLinks.fetch()
    @bindTo(BB.vent, 'click:CnTabsOverviewShow', @genOverviewShow, this)
    @bindTo(BB.vent, 'click:CnTabsOverviewEdit', @genOverviewEdit, this)
    @bindTo(BB.vent, 'click:tMenu',              @genNewPage,      this)

  onShow: ->
    @selectPage(@page, "noNav")
    BB.vent.trigger("show:CnTabs", @model)

  # ----- page select -----

  selectPage: (page, navOpt = "NA") ->
    switch page
      when "overview"      then @genOverviewShow navOpt
      when "overview-show" then @genOverviewShow navOpt
      when "overview-edit" then @genOverviewEdit navOpt
      when "roster"        then @genRoster       navOpt
      when "journal"       then @genJournal      navOpt
      when "forum"         then @genForum        navOpt
      when "media"         then @genMedia        navOpt
      when "chronicle"           then @genChronicle          navOpt

  # ----- methods -----

  genNewPage: (page) ->
    @page = page
    @selectPage(page)

  genOverviewShow: (navOption = "NA") ->
    @router.navigate("/events/#{@model.id}") unless navOption == "noNav"
    @tmenu.show(new BB.Views.CnTabsMenu("overview"))
    @tbody.show(new BB.Views.CnTbodyOverviewShow({model: @model}))

  genOverviewEdit: (navOption = "NA") ->
    @router.navigate("/events/#{@model.id}/edit") unless navOption == "noNav"
    @tmenu.show(new BB.Views.CnTabsMenu("overview"))
    @tbody.show(new BB.Views.CnTbodyOverviewEdit({model: @model}))

  genRoster: (navOption = "NA") ->
    @router.navigate("/events/#{@model.id}/roster") unless navOption == "noNav"
    @tmenu.show(new BB.Views.CnTabsMenu(@page))
    # create a period if it doesn't exist
    view = switch @model.get('typ')
      when 'meeting',  'social'    then BB.Views.CnTbodyRosterMt
      when 'training', 'community' then BB.Views.CnTbodyRosterOp
      when 'operation'             then BB.Views.CnTbodyRosterOp
    @tbody.show(new view({model: @model}))

  genJournal: (navOption = "NA") ->
    @router.navigate("/events/#{@model.id}/journal") unless navOption == "noNav"
    @tmenu.show(new BB.Views.CnTabsMenu(@page))
    @tbody.show(new BB.Views.CnTbodyJournal({model: @model}))

  genForum: (navOption = "NA") ->
    @router.navigate("/events/#{@model.id}/forum") unless navOption == "noNav"
    @tmenu.show(new BB.Views.CnTabsMenu(@page))
    @tbody.show(new BB.Views.CnTbodyForum({model: @model}))

  genMedia: (navOption = "NA") ->
    @router.navigate("/events/#{@model.id}/media") unless navOption == "noNav"
    @tmenu.show(new BB.Views.CnTabsMenu(@page))
    @tbody.show(new BB.Views.CnTbodyMedia({model: @model}))

  genChronicle: (navOption = "NA") ->
    @router.navigate("/events/#{@model.id}/chronicle") unless navOption == "noNav"
    @tmenu.show(new BB.Views.CnTabsMenu(@page))
    @tbody.show(new BB.Views.CnTbodyChronicle({model: @model}))


