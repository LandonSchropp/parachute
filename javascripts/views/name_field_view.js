/*
A text field used to enter names. This text field disables spellcheck and autcomplete and enables
auto capitalization of words.
*/
(function(){Parachute.NameFieldView=Ember.TextField.extend({attributeBindings:["spellcheck","autocorrect","autocapitalize","placeholder"],spellcheck:"false",autocorrect:"off",autocapitalize:"words",placeholder:"Type in a name"})}).call(this);