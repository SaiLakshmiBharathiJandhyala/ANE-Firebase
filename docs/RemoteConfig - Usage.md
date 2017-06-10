
## 

You can use Firebase Remote Config to define parameters in your app and update their values in the cloud, allowing you to modify the appearance and behavior of your app without distributing an app update. This guide shows you how to use Remote Config in your app, following these steps:

- Set in-app default parameter values.
- Get parameter values to use in your app.
- Set parameter values in the Remote Config service (as needed).
- Fetch and activate values from the Remote Config service (as needed).



## Default Parameters

Default parameters are values you set in your application that will be used before the remote config
has been retrieved from the server. You should do this early in your application so your application
behaves predictably before it fetches values from the Remote Config service.

Setting defaults is a matter of constructing your default values and then calling the `setDefaults`
method:


```as3
var defaultValues:Object = {
	welcome_message: "Default welcome message",
	welcome_message_caps: true
};

FirebaseRemoteConfig.service.setDefaults( defaultValues );
```

The default values object must be a simple object, basically a key/value set. 
The values in the object must be of simple data types (`int`, `Number`, `String` etc) Anything more complex will cause issues.


## Get Parameters

Now you can get parameter values from the Remote Config object. If you set values in the Remote Config service, fetch them, and then activate them, those values are available to your app. Otherwise, you get the in-app parameter values configured using setDefaults(). To get these values, call the method listed below that maps to the data type expected by your app, providing the parameter key as an argument:

- `getBoolean`
- `getDouble`
- `getInt`
- `getString`

For example, to retrieve the "welcome message" above:

```as3
var welcomeMessage:String = FirebaseRemoteConfig.service.getString( "welcome_message" );
```


## Set parameter values in the service (as needed)

1. In the [Firebase console](https://console.firebase.google.com/), open your project.
2. Select **Remote Config** from the menu to view the Remote Config dashboard.
3. Define parameters with the same names as the parameters that you defined in your app. For each parameter, you can set a default value (which will eventually override the corresponding in-app default value), and you can also set conditional values. To learn more, see [Remote Config Parameters and Conditions](https://firebase.google.com/docs/remote-config/parameters).



## Fetch and activate values

To fetch parameter values from the Remote Config service, call the `fetch()` method. Any values that you set in the Remote Config service are fetched and cached in the Remote Config object.

```as3
FirebaseRemoteConfig.service.fetch();
```

Once complete the extension will automatically activate the new values and dispatch a complete event.

```as3
FirebaseRemoteConfig.service.addEventListener( FirebaseRemoteConfigEvent.FETCH_COMPLETE, fetch_completeHandler );
```

```as3
private function fetch_completeHandler( event:FirebaseRemoteConfigEvent ):void
{
	// New values available here
}
```




## Next Steps

To learn more about using Remote Config in your app, see the Remote Config Frequently Asked Questions on [fetching and activating parameter values](https://firebase.google.com/support/faq#remote-config-values), [developer mode and throtting](https://firebase.google.com/support/faq#remote-config-requests), and [fetch timing](https://firebase.google.com/support/faq#remote-config-timing).


