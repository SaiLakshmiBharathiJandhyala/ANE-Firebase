
There are two ways to configure an application. 

- Using a packaged plist file on iOS and packaged resources (custom resources ANE) on Android;
- Manual configuration passing in values at runtime.

The first method is the preferred method as it ensures your application is always correctly configured. 

The second method will rely on a function call from your code which can be delayed and may cause some errors in background and initialisation operations particular with analytics. You may find Analytics doesn't work at all using the manual method. 

We highly suggest you use the first method whenever possible. It does require slightly more work on Android however it ensures your application is always running with the correct configuration. However if you are willing to sacrifice some functionality it is easier to use the manual method of initialisation.


## Configuration Files

The first step in configuring your application is to get the configuration files from the Firebase console.

Once you have created your project in the console you will be able to navigate to the manage settings page and download the latest configuration file.

These files contain configuration details such as keys and identifiers, for the services you have enabled in your applications.

Ideally you should be able to automatically configure your application using the configuration files downloaded from the Firebase console. 
However there are some slight complications that we will explain in the following sections.


## iOS

For an iOS project this configuration file takes the form of an xml plist file called `GoogleService-Info.plist`.

Download this file and place it in the root of your application package and ensure it is packaged with your iOS AIR application.

This is all that is required for iOS and packaging this file with your application ensures your application is using the first method mentioned above.

You can also use Manual Configuration (see below) if you require.



## Android

For an Android project this configuration file takes the form of a json file called `google-services.json`.

When an Android developer adds this file to his application part of the build process constructs resources file `values.xml` from this `json` file and packages them in their application. 

As we don't have this option there are two available avenues to setup your application:

- Creating the Android Resource
- Manual Configuration



### Android: Create Resource ANE

The first is the preferred method using Android resources. 

Here we manually create the `values.xml` file from the details in the `google-services.json` file and then package this into an ANE using a custom resources build script.
This is slightly more complex as you need to create an ANE containing your configuration resources 
however it is a simple process using the provided ant build scripts and ensures your application is correctly configured.

If you are wanting to use custom notification icons you are going to have to generate this ANE anyway so
it's a good idea to use this method from the start.


>
> **If you have any issues with this process, please send us your `values.xml` along with any custom icons and we can create the custom resources ANE for you.**
>


1. Check out the Custom Resources script and make a copy for yourself from the [repository here](https://github.com/distriqt/ANE-CustomResources).

2. You will need to make sure you have all the tools installed to run `ant` 
  - see details in the [CustomResources tutorial](https://github.com/distriqt/ANE-CustomResources)

3. Open `build_config/build.config` and perform the following changes:
  - Change the AIR SDK and Android SDK paths to match your environment
  - You should have something like the following:

> ```
> # AIR SDK
> air.sdk = /Users/marchbold/work/sdks/air/current
> # ANDROID
> android.sdk = /Users/marchbold/work/sdks/android/android-sdk-macosx
> ```

4. Create your values file at `res/values/values.xml` by copying the example below and 

>
> Complete `values.xml` example:
> 
> ```xml
> <?xml version="1.0" encoding="utf-8"?>
> <resources>
> 
>     <string name="google_app_id" translatable="false">1:1035469437089:android:73a4fb8297b2cd4f</string>
> 
>     <string name="gcm_defaultSenderId" translatable="false">1035469437089</string>
>     <string name="default_web_client_id" translatable="false">337894902146-e4uksm38sne0bqrj6uvkbo4oiu4hvigl.apps.googleusercontent.com</string>
>     <string name="ga_trackingId" translatable="false">UA-65557217-3</string>
>     <string name="firebase_database_url" translatable="false">https://example-url.firebaseio.com</string>
>     <string name="google_api_key" translatable="false">AIzbSyCILMsOuUKwN3qhtxrPq7FFemDJUAXTyZ8</string>
>     <string name="google_crash_reporting_api_key" translatable="false">AIzbSyCILMsOuUKwN3qhtxrPq7FFemDJUAXTyZ8</string>
>     <string name="google_storage_bucket" translatable="false">XXX</string>
>     <string name="project_id" translatable="false">mydemoapp</string>
>
> </resources>
> ```
> 

5. Set the values from your `google-services.json` file in your `values.xml` as per the table below:

>
> | Field Name | Json value | 
> | --- | --- | 
> | **`google_app_id`**					| `{YOUR_CLIENT}/client_info/mobilesdk_app_id`	| 
> | **`gcm_defaultSenderId`** 			| `project_info/project_number` | 
> | **`default_web_client_id`** 			| `{YOUR_CLIENT}/oauth_client/client_id` `(client_type == 3)` | 
> | **`ga_trackingId`** 					| `{YOUR_CLIENT}/services/analytics-service/analytics_property/tracking_id` |
> | **`firebase_database_url`** 			| `project_info/firebase_url` | 
> | **`google_api_key`** 					| `{YOUR_CLIENT}/api_key/current_key` | 
> | **`google_crash_reporting_api_key`** 	| `{YOUR_CLIENT}/api_key/current_key` | 
> | **`google_storage_bucket`**				| `project_info/storage_bucket` | 
> | **`project_id`** | `project_info/project_id` |
>


6. Run `ant` in the repository directory and you will generate an ANE file in the `build` directory (the name will be based on your package name). 
  This extension contains your configuration values resource and will be automatically loaded by the Firebase extension. 

7. Add that ANE to your AIR application and ensure it's packaged with your Android application

8. More information on the `google-services.json` format [here](https://developers.google.com/android/guides/google-services-plugin#processing_the_json_file)




### Android: Manual Configuration

The second method is a delayed configuration method which is the same as the manual configuration in the next section however the values are read directly from the json file if you package it with your Android application.

This method requires that you package the `google-services.json` at the root level of your application.
When you call `initialiseApp()`, the extension will look for this file and if found will read the values appropriate for your application.

See the notes on the manual configuration below as all the points there apply to this method.



## Manual Configuration

>
>	**This method while simple is not advised.** Firebase has issues with some aspects of it's functionality when initialised in this manner. Particularly it seems that Analytics will fail and you will get error messages about a missing `google_app_id`. This appears to be well known and no current solution is available.
>

If you wish you can manually setup your application. 

To do this you create an instance of the `FirebaseOptions` class and set the details for your application. You can locate these in the configuration files downloaded above.


```as3
var options:FirebaseOptions = new FirebaseOptions();  
options.apiKey      = google_api_key;
options.clientID    = default_web_client_id;
options.databaseURL = firebase_database_url
options.gcmSenderID = gcm_defaultSenderId;
options.googleAppID = google_app_id;

Firebase.service.initialiseApp( options );
```

If you are using manual configuration on Android it is important that you remove the `FirebaseInitProvider` from your manifest. This provider is the code responsible for initialising Firebase using your resources, if you aren't providing the configuration resources then this will fail.

i.e. remove the following:

```xml
<!-- common -->
<provider
    android:authorities="APPLICATION_PACKAGE.firebaseinitprovider"
    android:name="com.google.firebase.provider.FirebaseInitProvider"
    android:exported="false"
    android:initOrder="100" />
```




## Further information

- [Download a configuration file](https://support.google.com/firebase/answer/7015592)
- [Google Services JSON](https://developers.google.com/android/guides/google-services-plugin#processing_the_json_file)


