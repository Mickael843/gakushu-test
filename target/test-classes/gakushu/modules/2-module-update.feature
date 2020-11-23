Feature: Endpoint for Module update

  Background:
    * url 'http://localhost:8080/gakushu/v1/modules'
    * def generate = Java.type('gakushu.DataGenerator')

  Scenario: A valid payload must update a Module

    When method get
    Then status 200

    * def first = response[0]

    * def externalId = generate.uuid()
    * def name = generate.randomName()
    * def month = generate.randomMonth()


    * def payload =
    """
    {
      externalId: '#(externalId)',
      name: '#(name)',
      month: '#(month)',
      conclude: false
    }
    """

    Given request payload
    And path '/', first.externalId
    When method put
    Then status 204

    Given  path '/', first.externalId
    When method get
    Then status 200
    And match response contains {externalId:'#(first.externalId)', name:'#(name)', month: '#(month)'}

    Scenario: A valid payload for update the field conclude only

      When method get
      Then status 200

      * def first = response[0]
      * def conclude = generate.oppositeValue(first.conclude)
      * def payload =
      """
      {
        conclude: #(conclude)
      }
      """

      Given request payload
      And path '/', first.externalId
      When method patch
      Then status 204

      Given  path '/', first.externalId
      When method get
      Then status 200
      And match response contains {conclude: #(conclude)}

    Scenario Outline: Invalid fields must return error code 400

      Given url 'http://localhost:8080/gakushu/v1/modules'
      When method get
      Then status 200

      * def first = response[0]

      Given path '/', first.externalId
      And request
      """
      {
        externalId: <externalId>,
        name: <name>,
        month: <month>,
        conclude: <conclude>
      }
      """

      When method put
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