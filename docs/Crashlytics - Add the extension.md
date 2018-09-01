

## Required Extensions

You should have been through the setup of the Firebase Core before attempting to proceed with Crashlytics.

Make sure you have added all the extensions required for the Firebase Core extension as outlined ![](here|Core - Add the extensions).

>
> If you have previously been using ![](Firebase Crash Reporting|Crash - Introduction) then you must make sure you remove this before integrating Crashlytics. Importantly remove `com.distriqt.firebase.Crash` extension from the extensions packaged with your application.
>


### Firebase Crashlytics

The only required additional ANE is the Crashlytics ANE located in this repository:

- `com.distriqt.firebase.Crashlytics` : https://github.com/distriqt/ANE-Firebase

This ANE contains all the required libraries for the main Firebase Crashlytics functionality.



## Extension IDs

The following should be added to your `extensions` node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>com.distriqt.Firebase</extensionID>
    <extensionID>com.distriqt.firebase.Crashlytics</extensionID>
	
    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.androidsupport.V4</extensionID>
    <extensionID>com.distriqt.playservices.Base</extensionID>

	<extensionID>com.distriqt.CustomResources</extensionID>
</extensions>
```



---

## Android 

### Manifest Additions

There are some small additions required to the manifest for Crashlytics. The following must be added inside the `application` node in your manifest additions.

You must replace `YOUR_APPLICATION_PACKAGE` with your AIR application's Java package name, something like `air.com.distriqt.test`. Generally this is your AIR application id prefixed by `air.` unless you have specified no air flair in your build options.

```xml
<!-- crashlytics -->
<meta-data android:name="firebase_crashlytics_collection_enabled" android:value="false" />
<provider
    android:name="com.crashlytics.android.CrashlyticsInitProvider"
    android:authorities="YOUR_APPLICATION_PACKAGE.crashlyticsinitprovider"
    android:exported="false"
    android:initOrder="90" />

<activity android:name="com.distriqt.extension.firebase.crashlytics.activities.CrashActivity" />
```


## iOS 

### Info Additions

You must add the following flag to your info additions node. This will delay initialisation of crashlytics until you call `enableCollection` allowing us to setup Crashlytics correctly.

```xml
<key>firebase_crashlytics_collection_enabled</key>
<false/>
```



