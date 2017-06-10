
The first call should always be to `init`. This function initialises the actual extension and sets your application key.

You can use the same key as for the main Firebase ANE so we suggest calling it as below: 

```as3
try
{
	Firebase.init( APP_KEY );
	FirebaseRemoteConfig.init( APP_KEY );
}
catch (e:Error)
{
	trace( e );
}
```

You generate your application keys (`APP_KEY`) here: [/user/applications](https://airnativeextensions.com/user/applications)

If you have any issues with the application key, check this [FAQ](https://airnativeextensions.com/knowledgebase/faq/10)




