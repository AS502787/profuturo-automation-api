function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
      env: env,
      myVarName: 'someValue'	
  }
  if (env == 'dev') {
    // customize
	var result = karate.callSingle('classpath:pensionatapigee/pensionatGetTokenApigee.feature',config);  
	config.authInfo = { authToken: result.access_token };    
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}