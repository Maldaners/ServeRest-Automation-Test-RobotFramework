*** Settings ***
Documentation    Tests ServeRest

Resource         ../variables/variables.robot

# Suite Setup     Token


*** Test Cases ***

###   POST USER   ###

#01
Scenario: Validate the creation of a new user
  Given I want to create a new user
  When I send all the required data in the request
  Then the response should return status code 201 Created

Scenario: List all users without filters
  Given I want to get the list of users
  When I send a GET request to /usuarios without filters
  Then the response should return status code 200 OK
  And the list should contain one or more users

Scenario: List users with filters
  Given I want to search users by a specific field
  When I send a GET request to /usuarios?nome=John
  Then the response should return status code 200 OK
  And all returned users should have the name "John"

Scenario: Create a new user with valid data
  Given I want to register a new user
  When I send a POST request to /usuarios with valid unique email, name, password and admin field
  Then the response should return status code 201 Created
  And the message should be "Cadastro realizado com sucesso"

Scenario: Fail to create a user with an already registered email
  Given an existing user email
  When I send a POST request to /usuarios with the same email
  Then the response should return status code 400 Bad Request or 409 Conflict
  And the message should indicate the email is already in use

Scenario: Fail to create a user with empty or invalid fields
  Given I want to create a user
  When I send a POST request to /usuarios with empty or invalid values for name, email, password or admin
  Then the response should return status code 400 Bad Request

Scenario: Retrieve user by valid ID
  Given I have a valid user ID
  When I send a GET request to /usuarios/{valid_id}
  Then the response should return status code 200 OK
  And the returned user ID should match the requested ID

Scenario: Retrieve user by invalid ID
  Given I have an invalid user ID
  When I send a GET request to /usuarios/{invalid_id}
  Then the response should return status code 404 Not Found

Scenario: Update existing user with valid data
  Given I have a valid user ID
  When I send a PUT request to /usuarios/{valid_id} with updated valid fields
  Then the response should return status code 200 OK
  And the message should be "Registro alterado com sucesso"

Scenario: Update non-existent user
  Given I have a non-existent user ID
  When I send a PUT request to /usuarios/{nonexistent_id} with valid data
  Then the response should return status code 201 Created or error according to spec

Scenario: Delete a user without a cart
  Given I have a valid user ID without a cart
  When I send a DELETE request to /usuarios/{valid_id}
  Then the response should return status code 200 OK
  And the message should indicate successful deletion

Scenario: Fail to delete a user with a cart
  Given I have a user ID linked to an existing cart
  When I send a DELETE request to /usuarios/{id_with_cart}
  Then the response should return status code 400 Bad Request
  And the message should indicate the user cannot be deleted
