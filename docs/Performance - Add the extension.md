

## Required Extensions

You should have been through the setup of the Firebase Core before attempting to proceed with Performance Monitoring.

Make sure you have added all the extensions required for the Firebase Core extension as outlined ![](here|Core - Add the extensions).


### Firebase Performance Monitoring

The only required additional ANE is the Performance Monitoring ANE located in this repository:

- `com.distriqt.firebase.Performance` : https://github.com/distriqt/ANE-Firebase

This ANE contains all the required libraries for the main Firebase Performance Monitoring functionality.


---

## Android Manifest Additions

In order to add performance monitoring you need to add the following permissions to 
your manifest additions:

- `com.google.android.providers.gsf.permission.READ_GSERVICES`
- `com.google.android.providers.gsf.permission.WRITE_GSERVICES`

You will also need to add the `FirebasePerfProvider`. You must replace `YOUR_APPLICATION_PACKAGE` with your 
AIR application's Java package name, something like `air.com.distriqt.test`.
Generally this is your AIR application id prefixed by `air.` unless you have specified no air flair in your build options.

For example:

```xml
<manifest android:installLocation="auto">
    <uses-permission android:name="android.permission.INTERNET"/>
    
    <!-- OTHER PERMISSIONS / REQUIREMENTS -->

    <uses-permission android:name="com.google.android.providers.gsf.permission.READ_GSERVICES" />
    <uses-permission android:name="com.google.android.providers.gsf.permission.WRITE_GSERVICES" />

    <application>

        <provider
            android:name="com.google.firebase.perf.provider.FirebasePerfProvider"
            android:authorities="YOUR_APPLICATION_PACKAGE.firebaseperfprovider"
            android:exported="false"
            android:initOrder="101" />

    </application>

    <!-- OTHER ADDITIONS -->

</manifest>
```


## iOS 

No particular additions are required for iOS





