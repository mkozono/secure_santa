window.secureSanta ?= {} # create namespace if it doesn't already exist

window.secureSanta.initEditable = () ->
  $('.editable').each ->
      this.contentEditable = true

$ ->
  secureSanta.bindAddField()
  secureSanta.bindRemoveFields()
  secureSanta.initEditable()