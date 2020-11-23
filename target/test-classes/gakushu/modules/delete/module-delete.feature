Feature: Endpoint for Module delete

  Background:
    * url 'http://localhost:8080/gakushu/v1/modules'
    * def generate = Java.type('gakushu.DataGenerator')

  Scenario: Must delete a Module

    When method get
    Then status 200

    * def first = response[0]

    Given path '/', first.externalId
    When method delete
    Then status 204

    Given  path '/', first.externalId
    When method get
    Then status 404

  Scenario: Given a invalid external id and return not found

    Given path '/', generate.uuid()
    When method delete
    Then status 404
    And match response contains {"title":"Module not found","status":404}
