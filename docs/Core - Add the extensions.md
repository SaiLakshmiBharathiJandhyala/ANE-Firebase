

## Required ANEs

We have attempted to keep the required extensions to a minimum, packaging required libraries into the ANEs wherever possible
however we still will be left with a couple of ANEs that you will need to add to your application.

Each of the separate components of Firebase will require additional ANEs which will be identified in the individual sections 
however the following list will be required by any AIR application using Firebase.

Quick links:

- [`com.distriqt.Core`](https://github.com/distriqt/ANE-Core/raw/master/lib/com.distriqt.Core.ane)
- [`com.distriqt.androidsupport.V4.ane`](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.distriqt.androidsupport.V4.ane)
- [`com.distriqt.playservices.Base.ane`](https://github.com/distriqt/ANE-GooglePlayServices/raw/master/lib/com.distriqt.playservices.Base.ane)
- [`com.distriqt.Firebase`](https://github.com/distriqt/ANE-Firebase/raw/master/lib/com.distriqt.Firebase.ane)

---

### Core ANE

The Core ANE is required by this ANE. You must include and package this extension in your application.

The Core ANE doesn't provide any functionality in itself but provides support libraries and frameworks used by our extensions.
It also includes some centralised code for some common actions that can cause issues if they are implemented in each individual extension.

You can access this extension here: [https://github.com/distriqt/ANE-Core](https://github.com/distriqt/ANE-Core).

---

### Android Support ANE

Due to several of our ANE's using the Android Support library the library has been separated 
into a separate ANE allowing you to avoid conflicts and duplicate definitions.
This means that you need to include the some of the android support native extensions in 
your application along with this extension. 

You will add these extensions as you do with any other ANE, and you need to ensure it is 
packaged with your application. There is no problems including this on all platforms, 
they are just required on Android.

This ANE requires the following Android Support extensions:

- [com.distriqt.androidsupport.V4.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.distriqt.androidsupport.V4.ane)

You can access these extensions here: [https://github.com/distriqt/ANE-AndroidSupport](https://github.com/distriqt/ANE-AndroidSupport).

>
> **Note**: if you have been using the older `com.distriqt.AndroidSupport.ane` you should remove that
> ANE and replace it with the equivalent `com.distriqt.androidsupport.V4.ane`. This is the new 
> version of this ANE and has been renamed to better identify the ANE with regards to its contents.
>

---

### Google Play Services

This ANE requires usage of certain aspects of the Google Play Services client library. 
The client library is available as a series of ANEs that you add into your applications packaging options. 
Each separate ANE provides a component from the Play Services client library and are used by different ANEs. 
These client libraries aren't packaged with this ANE as they are used by multiple ANEs and separating them 
will avoid conflicts, allowing you to use multiple ANEs in the one application.

This ANE requires the following Google Play Services:

- [`com.distriqt.playservices.Base.ane`](https://github.com/distriqt/ANE-GooglePlayServices/raw/master/lib/com.distriqt.playservices.Base.ane)

You must include the above native extensions in your application along with this extension, 
and you need to ensure they are packaged with your application.

You can access the Google Play Services client library extensions here: [https://github.com/distriqt/ANE-GooglePlayServices](https://github.com/distriqt/ANE-GooglePlayServices).

---

### Firebase Core 

Finally the all important Firebase extension:

- `com.distriqt.Firebase` : [https://github.com/distriqt/ANE-Firebase](https://github.com/distriqt/ANE-Firebase)


If you are building for Android using the Android resources configuration you should also make sure you 
package your `com.distriqt.firebase.Config.ane`.





---

## Android Manifest Additions 

You must add all of the following Firebase related manifest additions. 

Make sure you only have one `<application>` node in your manifest additions combining them if you have multiple. 

The following shows the complete manifest additions node. You must replace `YOUR_APPLICATION_PACKAGE` with your 
AIR application's Java package name, something like `air.com.distriqt.test`.
Generally this is your AIR application id prefixed by `air.` unless you have specified no air flair in your build options.


```xml
<manifest android:installLocation="auto">
	<uses-sdk android:minSdkVersion="14" />
	
	<uses-permission android:name="android.permission.INTERNET"/>
	<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
	<uses-permission android:name="android.permission.WAKE_LOCK"/>
	
	<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
	<permission android:name="YOUR_APPLICATION_PACKAGE.permission.C2D_MESSAGE" android:protectionLevel="signature" />
	<uses-permission android:name="YOUR_APPLICATION_PACKAGE.permission.C2D_MESSAGE" />
	
	
	<application android:name="android.support.multidex.MultiDexApplication">
		
		<meta-data
			android:name="com.google.android.gms.version"
			android:value="@integer/google_play_services_version" />
			
		<activity android:name="com.google.android.gms.common.api.GoogleApiActivity" 
			android:theme="@android:style/Theme.Translucent.NoTitleBar" 
			android:exported="false"/>
			
			
		<!-- FIREBASE CORE -->
		<!-- analytics -->
		<receiver
			android:name="com.google.android.gms.measurement.AppMeasurementReceiver"
			android:enabled="true">
			<intent-filter>
				<action android:name="com.google.android.gms.measurement.UPLOAD"/>
			</intent-filter>
		</receiver>
		<service
			android:name="com.google.android.gms.measurement.AppMeasurementService"
			android:enabled="true"
			android:exported="false"/>
			
		<!-- common -->
		<provider
			android:authorities="YOUR_APPLICATION_PACKAGE.firebaseinitprovider"
			android:name="com.google.firebase.provider.FirebaseInitProvider"
			android:exported="false"
			android:initOrder="100" />
		
		<!-- iid -->
		<receiver
			android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver"
			android:exported="true"
			android:permission="com.google.android.c2dm.permission.SEND" >
			<intent-filter>
				<action android:name="com.google.android.c2dm.intent.RECEIVE" />
				<action android:name="com.google.android.c2dm.intent.REGISTRATION" />
				<category android:name="YOUR_APPLICATION_PACKAGE" />
			</intent-filter>
		</receiver>
		<receiver
			android:name="com.google.firebase.iid.FirebaseInstanceIdInternalReceiver"
			android:exported="false" />
		<service
			android:name="com.google.firebase.iid.FirebaseInstanceIdService"
			android:exported="true">
			<intent-filter android:priority="-500">
				<action android:name="com.google.firebase.INSTANCE_ID_EVENT" />
			</intent-filter>
		</service>
		
	</application>
	
</manifest>
```


### MultiDex Applications 

If you have a large application and are supporting Android 4.x then you will need to ensure you
enable your application to correctly support MultiDex to allow the application to be broken up
into smaller dex packages.

This is enabled by default with recent releases of AIR (25+), except in the Android 4.x case where 
you need to change the manifest additions for the application tag to match the following and use 
the `MultiDexApplication`:

```xml
<manifest android:installLocation="auto">
	<!-- PERMISSIONS -->

	<application android:name="android.support.multidex.MultiDexApplication">

		<!-- ACTIVITIES / RECEIVERS / SERVICES -->

	</application>
</manifest>
```



---

## iOS Info Additions / Entitlements

In order for the Firebase system to work well with AIR and other extensions we need
to disable the automatic delegate proxy that Firebase implements on iOS. To do so 
you must add the following to your InfoAdditions:

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

Eg:

```xml
<iPhone>
	<InfoAdditions><![CDATA[
		<key>UIDeviceFamily</key>
		<array>
			<string>1</string>
			<string>2</string>
		</array>
		
		<key>FirebaseAppDelegateProxyEnabled</key>
		<false/>
			
	)></InfoAdditions>
	<requestedDisplayResolution>high</requestedDisplayResolution>
	<Entitlements>
	<![CDATA[
	)>
	</Entitlements>
</iPhone>
```

You may wish to add a minimum iOS version to restrict your application to the 
minimum Firebase version.

