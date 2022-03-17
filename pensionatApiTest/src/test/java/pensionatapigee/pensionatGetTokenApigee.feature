Feature: MVP_LOGIN_API_Generar el Token

  Scenario: Validar que se genere el access token de manera exitosa.
    
    * def requestToken = 
    	"""
    			{
    				'client_id' : '21gYjSJ7jie6GUCTGpQXYyTN1DUCkQBO',
    				'client_secret' : 'g4QQkgiNr1xcqao1',
    				'grant_type' : 'client_credentials'
    			}
    	"""
    			
    Given url 'https://api.qa.profuturo.mx/oauth2/token'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And form fields requestToken
    When method POST
    Then status 200
    And if (responseStatus != 200) karate.fail('Error al obtener status 200')
    Then print 'Response: ', response
    * def access_token = response.access_token
    Then print 'Token: ', access_token  