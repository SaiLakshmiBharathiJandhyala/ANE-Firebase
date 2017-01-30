
The first call should always be to `init`. This function initialises the actual extension and sets your application key.

You can use the same key as for the main Firebase ANE so we suggest calling it as below: 

```as3
try
{
	Firebase.init( APP_KEY );
	FirebaseAuth.init( APP_KEY );
}
catch (e:Error)
{
	trace( e );
}
```

You generate your application keys (`APP_KEY`) here: [/user/applications](https://airnativeextensions.com/user/applications)

If you have any issues with the application key, check this [FAQ](https://airnativeextensions.com/knowledgebase/faq/10)



## Authentication State

The most important listener you will probably want to use is for the Authentication state change.

This event is dispatched whenever the state of the user's authentication changes, such as signing in or out.

```as3
FirebaseAuth.service.addEventListener( FirebaseAuthEvent.AUTHSTATE_CHANGED, authState_changedHandler );
```

Whenever this event is dispatched you can check the current sign in status using the `isSignedIn` function
as in the example event handler below:

```as3
private function authState_changedHandler( event:FirebaseAuthEvent ):void
{
	trace( "auth state changed: "+FirebaseAuth.service.isSignedIn() );
}
```

