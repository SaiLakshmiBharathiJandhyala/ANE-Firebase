
The first call should always be to `init`. This function initialises the actual extension and sets your application key.

You can use the same key as for the main Firebase ANE so we suggest calling it as below: 

```as3
try
{
	Firebase.init( APP_KEY );
	FirebaseDynamicLinks.init( APP_KEY );
}
catch (e:Error)
{
	trace( e );
}
```

You generate your application keys (`APP_KEY`) here: [/user/applications](https://airnativeextensions.com/user/applications)

If you have any issues with the application key, check this [FAQ](https://airnativeextensions.com/knowledgebase/faq/10)



## Setting Scheme

On iOS you must set the `deepLinkURLScheme` in the extension to correctly handle opened links.
This is the same url scheme (`APP_SCHEME`) that you added to the info additions previously when 
![](adding the extension|DynamicLinks - Add the extension)

The easiest way to do this is set as below, before calling `initialiseApp()`:

```as3
Firebase.service.deepLinkURLScheme = "APP_SCHEME";
Firebase.service.initialiseApp();
```


If you are passing your own `FirebaseOptions` to `initialiseApp` you can specify the scheme
as part of the options:

```as3
var options:FirebaseOptions = new FirebaseOptions();
// Other options
options.deepLinkURLScheme = "APP_SCHEME";

Firebase.service.initialiseApp( options );
```

>
> Note: You cannot use these two methods together
>

