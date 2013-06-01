window.secureSanta ?= {} # create myNamespace if it doesn't already exist

window.secureSanta.addFields = (link, association, content) ->
  new_id = new Date().getTime()
  regex = new RegExp("new_#{association}", "g")
  content = content.replace(regex, new_id)
  $(link).before(content)

window.secureSanta.removeFields = (link) ->
  $(link).prev("input[type=hidden]").val("1")
  $(link).closest(".fields").hide()
