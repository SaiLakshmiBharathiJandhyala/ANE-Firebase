

The first call should always be to `init`. This function initialises the actual extension
and sets your application key.

```as3
try
{
	Firebase.init( APP_KEY );
}
catch (e:Error)
{
	trace( e );
}
```

You generate your application keys (`APP_KEY`) here: [/user/applications](https://airnativeextensions.com/user/applications)

If you have any issues with the application key, check this [FAQ](https://airnativeextensions.com/knowledgebase/faq/10)




## Application Configuration

You must perform the Firebase configuration somewhere early in your application.

This process involves calling `initialiseApp` which will load your configuration files (as required) 
and ensure the Firebase application is initialised appropriately based on the current platform.


```as3
if (Firebase.isSupported)
{
	var success:Boolean = Firebase.service.initialiseApp();
	if (!success)
	{
		// CHECK YOUR CONFIGURATION FILES
	}
}
```

The call to `initialiseApp` returns a Boolean value indicating whether you have a configured 
Firebase application available.

If the call returns `false`, you should return to the ![](Configuration Files|Setup - Configuration Files) section
and ensure you have correctly setup all the appropriate options.


## Manual Configuration

If you wish you can manually setup your application. 
To do this you create an instance of the `FirebaseOptions` class and set the details for your application.
You can locate these in the configuration files downloaded above.

This is not the suggested method however it is a valid way of configuring your Firebase Application.


```as3
var options:FirebaseOptions = new FirebaseOptions();  
options.apiKey      = google_api_key;
options.clientID    = default_web_client_id;
options.databaseURL = firebase_database_url
options.gcmSenderID = gcm_defaultSenderId;
options.googleAppID = google_app_id;

Firebase.service.initialiseApp( options );
```

