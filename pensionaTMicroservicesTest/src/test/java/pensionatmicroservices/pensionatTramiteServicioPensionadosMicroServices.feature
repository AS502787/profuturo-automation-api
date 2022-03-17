Feature: MVP_Microservicios_Trámite servicio a pensionados alta y o cambio de forma de pago
    
    Background:
    
    * configure ssl = { keyStore: 'Cert.p12', keyStorePassword: 'changeit', keyStoreType: 'pkcs12' }
    
  Scenario: Validar que los catálogos funcionen correctamente.
    
    Given url 'https://catalogos-api-service-tsf-profuturo3-dev.apps.paasprofuturo-d.r6b1.p1.openshiftapps.com/catalogos/todos'
    And header Content-Type = 'application/json'    
    When method GET
    Then status 200
    And if (responseStatus != 200) karate.fail('Error al obtener status 200')
    And print 'Response: ', response
    
  Scenario Outline: Validar que la información que se regresa del API sea correcta respecto a la póliza dada
    							& que el grupo familiar corresponda a la información del cliente una vez ingresado su póliza.

    Given url 'https://clientes-api-service-tsf-profuturo3-dev.apps.paasprofuturo-d.r6b1.p1.openshiftapps.com/clientes/grupoFamiliar'
    And header Content-Type = 'application/json'
    And request {"poliza":<poliza>}
    When method POST
    Then status 200
    And if (responseStatus != 200) karate.fail('Error al obtener status 200')
    And print 'Response: ',response
    * def id_poliza = $.poliza[0].id_poliza
    * def id_grupo_pago = $.poliza[0].grupoPago[0].id_grupo_pago
    * def id_beneficiario_poliza = $.poliza[0].grupoPago[0].beneficiario[1].id_beneficiario_poliza
    And print 'id_poliza: ', id_poliza
    And print 'id_grupo_pago: ', id_grupo_pago
    And print 'id_beneficiario_poliza: ', id_beneficiario_poliza
    And match $.poliza[0].grupoPago[0].numero_renta_vitalicia == <poliza>
    Given url 'https://clientes-api-service-tsf-profuturo3-dev.apps.paasprofuturo-d.r6b1.p1.openshiftapps.com/clientes/detalleCliente'
    And header Content-Type = 'application/json'
    And request {"consecutivo_beneficiario":0,"id_beneficiario_poliza":'#(id_beneficiario_poliza)',"id_grupo_pago":'#(id_grupo_pago)',"id_oferta":0,"id_poliza":'#(id_poliza)'}
    When method POST
    Then status 200
    And if (responseStatus != 200) karate.fail('Error al obtener status 200')
    And print 'Response: ',response
    And match response == {"code":200,"message":"Consulta exitosa","response":{"solicitante":{"id_oferta":1024683,"id_poliza":'#(id_poliza)',"id_grupo_pago":'#(id_grupo_pago)',"fecha_nacimiento":"","curp":"NAEM791207MTSCLR02","rfc":"NAEM791207","e_firma":"","apellido_paterno":"NACIANCENO","apellido_materno":"ELIAS","nombre":"MARCELA GUADALUPE","id_titular_cobro":228930,"ocupacion":"","correo":"","gpo_pago":1,"folio_oferta":"31805020893","domicilio":{"calle":"TAMAULIPAS","id_pais":141,"pais_descripcion":"MEXICO","asentamiento":"UNIDAD NACIONAL","ciudad":"CIUDAD MADERO","estado":"TAMAULIPAS","municipio":"CIUDAD MADERO","num_ext":"111","codigo_postal":"89410"},"telefonos":[{"id_telefono":15917551,"consecutivo_referencia":"","clave_nacional":"833","clave_internacional":"","indicador_preferente":0,"indicador_sms":0,"numero":"4534761","tipo_telefono":"MOVIL","extension":"","horario_de":"","horario_hasta":""}],"referencias":[{"id_parentesco":"591","desc_parentesco":"OTRO","id_referencia_personal":47010,"consecutivo_referencia":"","apellido_materno":"SMITH","apellido_paterno":"LUGO","consecutivo_grupo_pago":1,"nombre":"ALEJANDRA","telefonos":[]}],"datos_bancarios":{"descripcion":"BBVA BANCOMER","tipo_cuenta":"DEPOSITO EN CUENTA BANCARIA","clabe":"012813004634489676","id_banco":50}}}}  
    
    Examples: 
      | read('../pensionatInputData/inputDataTramiteServicioPensionados.csv') |
      
  Scenario: Validar que los documentos se muestran correctamente.
    
    Given url 'https://documentos-api-service-tsf-profuturo3-dev.apps.paasprofuturo-d.r6b1.p1.openshiftapps.com/documentos/tramites'
    And header Content-Type = 'application/json'  
    When method GET
    Then status 200
    And if (responseStatus != 200) karate.fail('Error al obtener status 200')
    And print 'Response: ', response
      
  Scenario Outline: Validar que se envíe alerta sms correctamente.
    
    Given url 'https://envios-api-service-tsf-profuturo3-dev.apps.paasprofuturo-d.r6b1.p1.openshiftapps.com/notificaciones/sendSms'
    And header Content-Type = 'application/json'    
    And request {"rqt":{"telefono":<numero_telefono>,"message":"Apreciable cliente: hemos registrado tu  con el folio 5529711574"}}
    When method POST
    Then status 200
    And if (responseStatus != 200) karate.fail('Error al obtener status 200')
    And print 'Response: ', response
    And match response == {"status":200,"statusText":"OK","resultado":true}
    
    Examples: 
      | read('../pensionatInputData/inputDataTramiteServicioPensionados.csv') |
      
  Scenario Outline: Validar que se envíe alerta por email correctamente.
    
    Given url 'https://envios-api-service-tsf-profuturo3-dev.apps.paasprofuturo-d.r6b1.p1.openshiftapps.com/notificaciones/sendEmail'
    And header Content-Type = 'application/json'    
    And request {"rqt":{"encabezado":{"asunto":"Prueba envio de Email MVP MICROSERVICIOS","remitente":"tu-tramite-pensiones@profuturo.com.mx","destinatario":<email>},"adjunto":{"nombre":"","contenido":"","intentos":"3"}}}
    When method POST
    Then status 200
    And if (responseStatus != 200) karate.fail('Error al obtener status 200')
    And print 'Response: ', response
    * def success = $.success
    And print 'success: ', success
    And match $.success == success
    
    Examples: 
      | read('../pensionatInputData/inputDataTramiteServicioPensionados.csv') |    
      
      