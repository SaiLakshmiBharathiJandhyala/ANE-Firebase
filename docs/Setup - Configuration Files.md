
There are two ways to configure an application. 

- Using a packaged plist file on iOS or packaged resources on Android;
- Manual configuration passing in values at runtime.

The first method is the preferred method as it ensures your application is always correctly configured. 

The second method will rely on a function call from your code which can be delayed and may cause some errors in background / initialisation logging and events.
However these are minor and you may even never encounter them.

We highly suggest you use the first method whenever possible. 
It does require slightly more work on Android however it ensures 
your application is always running with the correct configuration.


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

As we don't have this option there are two available avenues to setup your application.

- Creating the Android Resource
- Delayed Configuration


### Create Android Resource

The first is the preferred method using Android resources. 
Here we manually create the `values.xml` file from the details in the `google-services.json` file and then package this into an ANE using a custom resources build script.
This is slightly more complex as you need to create an ANE containing your configuration resources 
however it is a simple process using the provided ant build scripts and ensures your application is correctly configured.

1. Locate the `config` folder in the repository and make a copy for yourself.

2. You will need to make sure you have all the tools installed to run `ant` 
  - see details in the [CustomResources tutorial](https://github.com/distriqt/ANE-CustomResources)

3. Open `build_config/build.config` and perform the following changes:
  - Change the AIR SDK and Android SDK paths to match your environment
  - Change the `android.package` variable to match your AIR applications Java package name. 
    This should be something like `air.com.distriqt.test`
  - You should have something like the following:

> ```
> # AIR SDK
> air.sdk = /Users/marchbold/work/sdks/air/current
> # ANDROID
> android.sdk = /Users/marchbold/work/sdks/android/android-sdk-macosx
> # YOUR APPLICATION PACKAGE NAME
> android.package = air.com.distriqt.test
> ```

4. Open the `res/values/values.xml` file and set the values from your `google-services.json` file as below:

>
> | Field Name | Json value | Comments |
> | --- | --- | --- |
> | **`google_app_id`**					| `{YOUR_CLIENT}/client_info/mobilesdk_app_id`	| |
> | **`gcm_defaultSenderId`** 			| `project_info/project_number` | |
> | **`default_web_client_id`** 			| `{YOUR_CLIENT}/oauth_client/client_id` | where `client_type == 3` |
> | **`firebase_database_url`** 			| `project_info/firebase_url` | |
> | **`google_api_key`** 					| `{YOUR_CLIENT}/api_key/current_key` | |
> | **`google_crash_reporting_api_key`** 	| `{YOUR_CLIENT}/api_key/current_key` | |
> | **`google_storage_bucket`**				| `project_info/storage_bucket` | | 
> | **`ga_trackingId`** 					| `{YOUR_CLIENT}/services/analytics-service/analytics_property/tracking_id` | optional |
>

>
> Complete `values.xml` example:
> 
> ```xml
> <?xml version="1.0" encoding="utf-8"?>
> <resources>
> 
>     <! -- Present in all applications -->
>     <string name="google_app_id" translatable="false">1:1035469437089:android:73a4fb8297b2cd4f</string>
> 
>     <! -- Present in applications with the appropriate services configured -->
>     <string name="gcm_defaultSenderId" translatable="false">1035469437089</string>
>     <string name="default_web_client_id" translatable="false">337894902146-e4uksm38sne0bqrj6uvkbo4oiu4hvigl.apps.googleusercontent.com</string>
>     <string name="ga_trackingId" translatable="false">UA-65557217-3</string>
>     <string name="firebase_database_url" translatable="false">https://example-url.firebaseio.com</string>
>     <string name="google_api_key" translatable="false">AIzbSyCILMsOuUKwN3qhtxrPq7FFemDJUAXTyZ8</string>
>     <string name="google_crash_reporting_api_key" translatable="false">AIzbSyCILMsOuUKwN3qhtxrPq7FFemDJUAXTyZ8</string>
>     <string name="google_storage_bucket" translatable="false">XXX</string>
>
> </resources>
> ```
> 

5. Run `ant` in the `config` directory and you will generate an ANE file in the `build` directory called `com.distriqt.firebase.Config.ane`. 
  This extension contains your configuration values resource and will be automatically loaded by the Firebase extension. 

6. Add `com.distriqt.firebase.Config.ane` to your AIR application and ensure it's packaged with your Android application

7. More information on the `google-services.json` format [here](https://developers.google.com/android/guides/google-services-plugin#processing_the_json_file)





### Delayed Configuration

The second method is a delayed configuration method similar to the manual configuration in the next section.

This method requires that you package the `google-services.json` and then read the values from this file at runtime.
Reading these values is done automatically for you if you package the file in the root of your application when you call `initialiseApp()`.

Download this file and place it in the root of your application package and ensure it is packaged with your Android AIR application.



## Manual Configuration

>
>	This method is not working completely as yet, please use the resource method for the moment
>

If you wish you can manually setup your application. 
To do this you create an instance of the `FirebaseOptions` class and set the details for your application.
You can locate these in the configuration files downloaded above.


```as3
var options:FirebaseOptions = new FirebaseOptions();  
options.apiKey      = google_api_key;
options.clientID    = default_web_client_id;
options.databaseURL = firebase_database_url
options.gcmSenderID = gcm_defaultSenderId;
options.googleAppID = google_app_id;

Firebase.service.initialiseApp( options );
```




## Further information

- [Download a configuration file](https://support.google.com/firebase/answer/7015592)
- [Google Services JSON](https://developers.google.com/android/guides/google-services-plugin#processing_the_json_file)


