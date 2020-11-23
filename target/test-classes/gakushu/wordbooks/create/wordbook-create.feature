Feature: Endpoint for Wordbook Creation

  Background:
    * url 'http://localhost:8080/gakushu/v1/modules'
    * def generate = Java.type('gakushu.DataGenerator')

  Scenario: A valid payload must create a Wordbook for one Module only once

    When method get
    Then status 200

    * def module = response[0]
    * def externalId = generate.uuid()
    * def expectedLocation = '/v1/modules/' + module.externalId + '/wordbooks/' + externalId
    * def payload =
    """
    {
      externalId: '#(externalId)',
      title: '#(generate.randomTitle())',
      content: '#(generate.randomContent())'
    }
    """

    Given request payload
    And path '/', module.externalId, '/wordbooks'
    When  method post
    Then status 201
    And match responseHeaders['Location'][0] == expectedLocation

    Given request payload
    And path '/', module.externalId, '/wordbooks'
    When method post
    Then status 400
    And match response contains { title:'Invalid duplicated data', status:400 }

  Scenario Outline: Invalid fields must return error code 400

    When method get
    Then status 200

    * def module = response[0]

    Given path '/', module.externalId, '/wordbooks'
    And request
    """
    {
      externalId: <externalId>,
      title: <title>,
      content: <content>
    }
    """

    When method post
    Then status 400
    And match response contains <expected>

    Examples:
    | externalId | title | content | expected
    | null | #(generate.randomTitle()) | #(generate.randomContent()) | { title:'Invalid fields!', status:400 }
    | #(generate.uuid()) | null | #(generate.randomContent()) | { title:'Invalid fields!', status:400 }
    | #(generate.uuid()) | '  ' | #(generate.randomContent()) | { title:'Invalid fields!', status:400 }
    | #(generate.uuid()) | #(generate.randomTitle()) | null | { title:'Invalid fields!', status:400 }
    | #(generate.uuid()) | #(generate.randomTitle()) | '  ' | { title:'Invalid fields!', status:400 }