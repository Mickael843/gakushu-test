Feature: Endpoint for Wordbook delete

  Background:
    * url 'http://localhost:8080/gakushu/v1/modules'
    * def generate = Java.type('gakushu.DataGenerator')

  Scenario: Must delete a Wordbook

    When method get
    Then status 200

    * def module = response[0]

    Given path '/', module.externalId, '/wordbooks'
    When method get
    Then status 200

    * def wordbook = response[0]
    * def externalId = wordbook.externalId

    Given path '/', module.externalId, '/wordbooks/', externalId
    When method delete
    Then status 204

    Given path '/', module.externalId, '/wordbooks/', externalId
    When method get
    Then status 404

    Scenario: Given invalid external id and return not found

      When method get
      Then status 200

      * def module = response[0]
      * def invalidExternalId = generate.uuid()

      Given path '/', module.externalId, '/wordbooks', invalidExternalId
      When method delete
      Then status 404
      And match response contains {"title":"Wordbook not found","status":404}