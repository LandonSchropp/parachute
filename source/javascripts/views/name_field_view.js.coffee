###
A text field used to enter names. This text field disables spellcheck and autcomplete and enables
auto capitalization of words.
###
Parachute.NameFieldView = Ember.TextField.extend

  # extend the default attribute bindings
  attributeBindings: [ "spellcheck", "autocorrect", "autocapitalize", "placeholder" ],

  # disable autocorrect and spellcheck
  spellcheck: "false"
  autocorrect: "off"

  # enable capitalization of words
  autocapitalize: "words"

  # set the placeholder
  placeholder: "Type in a name"