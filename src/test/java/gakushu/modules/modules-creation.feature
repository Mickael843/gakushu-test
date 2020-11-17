Feature: Endpoint for Module creation

  Background:
    * url 'http://localhost:8080/gakushu/v1/modules'
    * def generate = Java.type('gakushu.DataGenerator')

  Scenario: A valid payload must create a Module only once

    * def externalId = generate.uuid()
    * def payload =
    """
    {
      externalId: '#(externalId)',
      name: '#(generate.randomName())',
      month: '#(generate.randomMonth())',
      conclude: false
    }
    """

    Given request payload
    When method post
    Then status 201

    Given request payload
    When method post
    Then status 400
    And match response contains { title:'Duplicated data!', status:400 }

  Scenario: get all modules and then get the first module by id
    When method get
    Then status 200

    * def first = response[0]

    Given path '/', first.externalId
    When method get
    Then status 200
