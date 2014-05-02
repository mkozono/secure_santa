window.secureSanta ?= {} # create myNamespace if it doesn't already exist

window.secureSanta.addField = (link, association, content) ->
  new_id = new Date().getTime()
  regex = new RegExp("new_#{association}", "g")
  content = content.replace(regex, new_id)
  $("div.players").append(content)
  secureSanta.bindRemoveFields()

window.secureSanta.removeField = (link) ->
	$(link).prev("input[type=hidden]").val("1")
	$(link).closest(".field").hide()

window.secureSanta.bindRemoveFields = () ->
	$("a.remove_field").unbind("click").click (event) ->
		secureSanta.removeField(event.target)

$ ->
	$("a.add_field").click (event) ->
		$link = $(event.target)
		secureSanta.addField(event.target, $link.attr("data-association"), $link.attr("data-content"))

	secureSanta.bindRemoveFields()
