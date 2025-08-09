*** Settings ***
Documentation    Tests ServeRest

Resource         ../variables/variables.robot

# Suite Setup     Token


*** Test Cases ***
Scenario: List all carts
  Given I want to list all carts
  When I send a GET request to /carrinhos
  Then the response should return status code 200 OK
  And the list should contain one or more carts

Scenario: Create a new cart with valid products
  Given I am authenticated
  And I have a valid product ID
  When I send a POST request to /carrinhos with the product and quantity
  Then the response should return status code 201 Created
  And the message should be "Cadastro realizado com sucesso"

Scenario: Retrieve cart by valid ID
  Given I have a valid cart ID
  When I send a GET request to /carrinhos/{valid_id}
  Then the response should return status code 200 OK
  And the returned cart ID should match the requested ID

Scenario: Retrieve cart by invalid ID
  Given I have an invalid cart ID
  When I send a GET request to /carrinhos/{invalid_id}
  Then the response should return status code 404 Not Found

Scenario: Add product to cart - success case
  Given I have a valid cart ID
  And I have a valid product ID
  When I send a request to add the product to the cart
  Then the response should return status code 200 OK
  And the product should be listed in the cart

Scenario: Fail to add product to cart - non-existent product or zero quantity
  Given I have a valid cart ID
  When I send a request to add an invalid product or with zero quantity
  Then the response should return status code 400 Bad Request

Scenario: Remove product from cart - success case
  Given I have a valid cart ID with a product
  When I send a request to remove that product from the cart
  Then the response should return status code 200 OK
  And the product should no longer be in the cart

Scenario: Fail to remove product from cart - invalid product or not in cart
  Given I have a valid cart ID
  When I send a request to remove a product that is not in the cart
  Then the response should return status code 400 Bad Request

Scenario: Finish purchase successfully
  Given I have a valid cart with products
  When I send a DELETE request to /carrinhos/concluir-compra
  Then the response should return status code 200 OK
  And the stock of the purchased products should be reduced accordingly

Scenario: Cancel purchase
  Given I have a valid cart with products
  When I send a DELETE request to /carrinhos/cancelar-compra
  Then the response should return status code 200 OK
  And the stock of the products should be restored to the original value
