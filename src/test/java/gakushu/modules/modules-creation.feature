Feature: Endpoint for Module creation

  Background:
    * url 'http://localhost:8080/gakushu/v1/modules'
    * def generate = Java.type('gakushu.DataGenerator')

  Scenario: A valid payload must create a Module only once

    * def externalId = generate.uuid()
    * def expectedLocation = '/gakushu/v1/modules/' + externalId
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
    And match responseHeaders['Location'][0] == expectedLocation

    Given request payload
    When method post
    Then status 400
    And match response contains { title:'Invalid duplicated data', status:400 }

  Scenario: get all modules and then get the first module by id
    When method get
    Then status 200

    * def first = response[0]

    Given path '/', first.externalId
    When method get
    Then status 200

  Scenario Outline: Invalid fields must return error code 400

    Given url 'http://localhost:8080/gakushu'
    And path 'v1/modules'
    And request
    """
    {
      externalId: <externalId>,
      name: <name>,
      month: <month>,
      conclude: <conclude>
    }
    """

    When method post
    Then status 400
    And match response contains <expected>

    Examples:
      | externalId | name | month | conclude | expected
      | null | #(generate.randomName()) | #(generate.randomMonth()) | false | { title:'Invalid fields!', status:400 }
      | #(generate.uuid()) | null | #(generate.randomMonth()) | false | { title:'Invalid fields!', status:400 }
      | #(generate.uuid()) | '  ' | #(generate.randomMonth()) | false | { title:'Invalid fields!', status:400 }
      | #(generate.uuid()) | #(generate.randomName()) | null | false | { title:'Invalid fields!', status:400 }
      | #(generate.uuid()) | #(generate.randomName()) | 0 | false | { title:'Month cannot be less than or equal to 0!', status:400 }
      | #(generate.uuid()) | #(generate.randomName()) | -3 | false | { title:'Month cannot be less than or equal to 0!', status:400 }
      | #(generate.uuid()) | #(generate.randomName()) | 15 | false | { title:'Month not be greater than 12!', status:400 }