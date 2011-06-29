###
This is code to support the members/edit form.
###

window.cleanup = (string) ->
  string.replace(/\&amp;/g,'&').replace(/\&lt;/g,'<').replace(/\&quot;/g,'"').replace(/\&gt;/g,'>')

# called when 'add' is clicked on the members/edit form
window.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  # cleanup the escaped string delivered by rails
  str    = content.replace(regexp, new_id)
  cleanStr = cleanup(str)
  # find the parent div
  tgtDiv = $(link).parent().next()
  divLen = tgtDiv.children("li").length
  if divLen == 0  # if the target div is empty, just drop in the new string
    tgtDiv.html(cleanStr)
  else # otherwise put it after the last child...
    tgtDiv.children().last().after(cleanStr)
  length = tgtDiv.children("li").length
  lastLi = tgtDiv.children("li").last()
  # set the sort attribute on the newly inserted element
  tgtInput = lastLi.children("input").first()
  tgtInput.attr("value", length)
  # highlight the inserted element
  lastLi.effect("shake", {times:1}, 250)
  lastLi.effect("highlight", {}, 1000)
  # set an auto-erase callback on all input and textarea elements
  $("input, textarea").focus ->    # erase the input value if it contains three dots...
    ele = $(this)
    ele.prop("value", "") if ele.prop("value").search(/\.\.\./) != -1

# called when 'remove' is clicked on the members/edit form
window.remove_fields = (link) ->
  $(link).next("input[type=hidden]").val("1")
  $(link).closest(".fields").hide()

$(document).ready ->
  $("#save_link").click ->
    $("#memberz_form").submit()