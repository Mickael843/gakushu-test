Feature: Endpoint for Wordbook update

  Background:
    * url 'http://localhost:8080/gakushu/v1/modules'
    * def generate = Java.type('gakushu.DataGenerator')

  Scenario: A valid payload must update a Wordbook

    When method get
    Then status 200

    * def module = response[0]

    Given path '/', module.externalId, '/wordbooks'
    When method get
    Then status 200

    * def wordbook = response[0]
    * def externalId = wordbook.externalId
    * def payload =
    """
    {
      externalId: '#(externalId)',
      title: '#(generate.randomTitle())',
      content: '#(generate.randomContent())'
    }
    """

    Given request payload
    And path '/', module.externalId, '/wordbooks/', externalId
    When method put
    Then status 204

    Scenario Outline: Invalid payload must return error code 400

      When method get
      Then status 200

      * def module = response[0]

      Given path '/', module.externalId, '/wordbooks'
      When method get
      Then status 200

      * def wordbook = response[0]
      * def externalId = wordbook.externalId

      Given path '/', module.externalId, '/wordbooks/', externalId
      And request
      """
      {
        externalId: <externalId>,
        title: <title>,
        content: <content>
      }
      """

      When method put
      Then status 400
      And match response contains <expected>

      Examples:
        | externalId | title | content | expected
        | null | #(generate.randomTitle()) | #(generate.randomContent()) | { title:'Invalid ExternalId', status:400 }
        | #(generate.uuid()) | #(generate.randomTitle()) | #(generate.randomContent()) | { title:'ExternalId in path and wordbook body is different!', status:400 }
        | #(externalId) | null | #(generate.randomContent()) | { title:'Invalid fields!', status:400 }
        | #(externalId) | '  ' | #(generate.randomContent()) | { title:'Invalid fields!', status:400 }
        | #(externalId) | #(generate.randomTitle()) | null | { title:'Invalid fields!', status:400 }
        | #(externalId) | #(generate.randomTitle()) | '  ' | { title:'Invalid fields!', status:400 }