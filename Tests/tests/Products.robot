*** Settings ***
Documentation    Tests ServeRest

Resource         ../variables/variables.robot

# Suite Setup     Token


*** Test Cases ***
Scenario: List all products without filters
  Given I want to list all products
  When I send a GET request to /produtos without filters
  Then the response should return status code 200 OK
  And the list should contain one or more products

Scenario: List products with filters
  Given I want to search products by a specific field
  When I send a GET request to /produtos?nome=Logitech
  Then the response should return status code 200 OK
  And all returned products should have the name "Logitech"

Scenario: Create a product as an authenticated admin with valid data
  Given I am authenticated as an admin
  When I send a POST request to /produtos with valid name, price, description and quantity
  Then the response should return status code 201 Created
  And the message should be "Cadastro realizado com sucesso"

Scenario: Fail to create a product without token
  Given I am not authenticated
  When I send a POST request to /produtos with valid data
  Then the response should return status code 401 Unauthorized

Scenario: Fail to create a product with duplicate name
  Given an existing product name
  When I send a POST request to /produtos with the same name
  Then the response should return status code 400 Bad Request or 409 Conflict
  And the message should indicate the product name already exists

Scenario: Retrieve product by valid ID
  Given I have a valid product ID
  When I send a GET request to /produtos/{valid_id}
  Then the response should return status code 200 OK
  And the returned product ID should match the requested ID

Scenario: Retrieve product by invalid ID
  Given I have an invalid product ID
  When I send a GET request to /produtos/{invalid_id}
  Then the response should return status code 404 Not Found

Scenario: Update existing product
  Given I have a valid product ID
  When I send a PUT request to /produtos/{valid_id} with updated valid fields
  Then the response should return status code 200 OK
  And the message should be "Registro alterado com sucesso"

Scenario: Update non-existent product
  Given I have a non-existent product ID
  When I send a PUT request to /produtos/{nonexistent_id} with valid data
  Then the response should return status code 201 Created or error according to spec

Scenario: Delete existing product
  Given I have a valid product ID
  When I send a DELETE request to /produtos/{valid_id}
  Then the response should return status code 200 OK
  And the message should indicate successful deletion

Scenario: Delete non-existent product
  Given I have a non-existent product ID
  When I send a DELETE request to /produtos/{nonexistent_id}
  Then the response should return an error (e.g., 404 Not Found)
