*** Settings ***
Documentation    Tests ServeRest

Resource         ../../variables/variables.robot

Suite Setup     Token


*** Test Cases ***

###   POST USER   ###

#CN01
Scenario: Validate the creation of a new user
  Given I want to create a new user
#   When I send all the required data in the request
#   Then the response should return status code 201 Created
