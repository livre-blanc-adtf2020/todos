*** Settings ***
Library         SeleniumLibrary
Resource        setup_teardown.resource
Suite Setup     Prepare the test suite
Test Setup      Prepare the test case
Test Teardown   Clean up the test case
Suite Teardown  Clean up the test suite

*** Variables ***
&{CATEGORIES}
...             private=Personnel
...             professional=Professionnel

*** Test Cases ***
I can add a todo
  Page should contain element  data-id:input.text.description
  Submit a todo  Adopter de bonnes pratiques de test
  A new todo should be created  1  Adopter de bonnes pratiques de test

I can complete one of several todos
  Submit a todo  Adopter de bonnes pratiques de test
  Submit a todo  Comprendre le Keyword-Driven Testing
  Submit a todo  Automatiser des cas de test avec Robot Framework
  A new todo should be created  1  Adopter de bonnes pratiques de test
  A new todo should be created  2  Comprendre le Keyword-Driven Testing
  A new todo should be created  3  Automatiser des cas de test avec Robot Framework
  Complete a todo  2
  The todo should be completed  2
  The todo should be uncompleted  1
  The todo should be uncompleted  3

I can remove a todo
  Submit a todo  Choisir le bon type de framework de test
  Remove a todo  1
  The todo should be deleted  1

I can categorize some todos
  Submit a todo  Choisir un livre intéressant
  The todo should not be categorized  1
  Submit a todo  Marcher et faire du vélo avec mon chien  ${CATEGORIES.private}
  The todo 2 should be private
  Submit a todo  Faire un câlin avec mon chat
  The todo 3 should be private
  Submit a todo  Automatiser un cas de test de plus  ${CATEGORIES.professional}
  The todo 4 should be professional

*** Keywords ***
Submit a todo
  [Arguments]  ${description}  ${category}=${None}
  Run keyword unless  '${category}' == '${None}'
  ...  Select from list by value  data-id:select.category  ${category}
  Input text  data-id:input.text.description  ${description}
  Submit form

A new todo should be created
  [Arguments]  ${number}  ${description}
  Element should contain  todo:${number}  ${description}
  Checkbox should not be selected  data-id:input.checkbox.done-${number}

Complete a todo
  [Arguments]  ${number}
  Select checkbox  data-id:input.checkbox.done-${number}

The todo should be completed
  [Arguments]  ${number}
  Checkbox should be selected  data-id:input.checkbox.done-${number}

The todo should be uncompleted
  [Arguments]  ${number}
  Checkbox should not be selected  data-id:input.checkbox.done-${number}

Remove a todo
  [Arguments]  ${number}
  Page should contain button  data-id:button.remove_todo-${number}
  Click button  data-id:button.remove_todo-${number}

The todo should be deleted
  [Arguments]  ${number}
  Page should not contain element  todo:${number}

The todo should not be categorized
  [Arguments]  ${number}
  Page should not contain element  data-id:category-${number}

The todo ${number} should be ${category}
  Element text should be  data-id:category-${number}  ${CATEGORIES.${category}}
