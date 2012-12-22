# ----- Use JST Templates -----

Backbone.Marionette.Renderer.render = (template, data) -> JST[template](data)

# ----- Create Application -----

window.BB = new Backbone.Marionette.Application
  Collections : {}
  Models      : {}
  Routers     : {}
  Helpers     : {}
  Views       : {}
  HotKeys     : {}
  UI          : {}

# ----- Initializer -----

BB.addInitializer (options) ->
#  BB.Views.utilFooter      = new BB.Views.UtilFooter()
#  BB.Views.utilHeaderLeft  = new BB.Views.UtilHeaderLeft()
#  BB.Views.utilHeaderRight = new BB.Views.UtilHeaderRight()
#  BB.Views.utilNavbar      = new BB.Views.UtilNavbar()
  BB.Routers.app           = new BB.Routers.AppRouter()
  Backbone.history.start({pushState: true})

# ----- Init BB after document.ready -----

$(document).ready ->
  BB.start()
