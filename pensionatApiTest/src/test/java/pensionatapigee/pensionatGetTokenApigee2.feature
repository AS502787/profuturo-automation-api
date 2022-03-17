Feature: MVP_LOGIN_API_Generar el Token

  Scenario: Validar que se genere el access token de manera exitosa.
    #* def token = "iCE8Go5jjj74dEgVXqONUFftq2ti"
    * def responseJson = read('file:resources/requestJson/detalleCliente.json') 			
		* set json
    | path   | value    |
    | consecutivo_beneficiario  | 123   |
    | id_beneficiario_poliza  | 200      | 