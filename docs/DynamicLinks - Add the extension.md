

## Required Extensions

You should have been through the setup of the Firebase Core before attempting to proceed with Dynamic Links.

Make sure you have added all the extensions required for the Firebase Core extension as outlined ![](here|Core - Add the extensions).


### Firebase Dynamic Links

The only required additional ANE is the Dynamic Links ANE located in this repository:

- `com.distriqt.firebase.DynamicLinks` : https://github.com/distriqt/ANE-Firebase

This ANE contains all the required libraries for the main Firebase Dynamic Links functionality.



## Extension IDs

The following should be added to your `extensions` node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>com.distriqt.Firebase</extensionID>
    <extensionID>com.distriqt.firebase.DynamicLinks</extensionID>
	
    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.androidsupport.V4</extensionID>
    <extensionID>com.distriqt.playservices.Base</extensionID>

	<extensionID>com.distriqt.CustomResources</extensionID>
</extensions>
```



---

## Android Manifest Additions


As with plain deep links, you must add an intent filter to the activity that handles deep links for your app. 
The intent filter should catch deep links of your domain, since the Dynamic Link will redirect to your domain 
if your app is installed. This is required for your app to receive the Dynamic Link data after it is installed 
from the Play Store. In AndroidManifest.xml:


```xml
<intent-filter>
	<action android:name="android.intent.action.VIEW"/>
	<category android:name="android.intent.category.DEFAULT"/>
	<category android:name="android.intent.category.BROWSABLE"/>

	<data android:host="airnativeextensions.com" android:scheme="http"/>
	<data android:host="airnativeextensions.com" android:scheme="https"/>
</intent-filter>
```

This intent filter should be added directly after the `<application>` tag in your manifest additions. 
(Note: This is not the main `<application>` tag in your AIR application descriptor but the one inside 
your manifest additions!) 

For example:

```xml
<android>
	<manifestAdditions><![CDATA[
		<manifest android:installLocation="auto">
			<uses-permission android:name="android.permission.INTERNET"/>
			
			<!-- OTHER PERMISSIONS / REQUIREMENTS -->

			<application>

				<intent-filter>
					<action android:name="android.intent.action.VIEW"/>
					<category android:name="android.intent.category.DEFAULT"/>
					<category android:name="android.intent.category.BROWSABLE"/>

					<data android:host="airnativeextensions.com" android:scheme="http"/>
					<data android:host="airnativeextensions.com" android:scheme="https"/>
				</intent-filter>
			
				<!-- OTHER ADDITIONS -->

			</application>
		</manifest>
	)></manifestAdditions>
</android>
```


When users open a link to the scheme and host you specify, your app will start an activity to handle the link.

For more details on these fields and how to handle other types of App Links you can
read the official Android documentation on [Handling App Links](https://developer.android.com/training/app-links/index.html)



## iOS 

Ensure that your app's App Store ID and your Apple Developer Team ID is specified in your app's settings. To view and edit your app's settings, go to your Firebase project's Settings page and select your iOS app.

You can confirm that your Firebase project is properly configured to use Dynamic Links in your iOS app by opening the following URL (replacing `app_code` with your app code):

```
https://app_code.app.goo.gl/apple-app-site-association
```

If your app is connected, the apple-app-site-association file contains a reference to your app's App Store ID and bundle ID. For example:

```
{"applinks":{"apps":[],"details":[{"appID":"1234567890.com.example.ios","paths":["/*"]}]}}
```

If the details field is empty, double-check that you specified your Team ID.




### Developer Console


Ensure your application identifier in the iOS developer member center has enabled "Associated Domains".
Enabling Associated Domains allows an app to be associated with a specified domain for specified services
such as accessing Safari saved passwords and activity continuation.

To do this, log into the member center and open your [App IDs](https://developer.apple.com/account/ios/identifier/bundle)

Select your App ID and select "Edit". You need to enable the "Associated Domains" service as below:

![](images/dynamiclinks-ios-associateddomains.png)

>
> Note: You will need to regenerate and download your provisioning profiles after making this change. 
>


### Info Additions and Entitlements

You will firstly need to add any custom url scheme to your info additions, by adding
the following and replacing `APP_SCHEME` with your applications custom url scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>APP_SCHEME</string>
		</array>
	</dict>
</array>
```

You need to add the associated domain to your iOS Entitlements section, replacing 
`APP_CODE` below with your Dynamic Links domain.

```xml
<key>com.apple.developer.associated-domains</key>
<array>
	<string>applinks:APP_CODE.app.goo.gl</string>
</array>
```

For example:

```xml
<iPhone>
	<InfoAdditions><![CDATA[

		<key>CFBundleURLTypes</key>
		<array>
			<dict>
				<key>CFBundleURLSchemes</key>
				<array>
					<string>distriqt</string>
				</array>
			</dict>
		</array>

	)></InfoAdditions>
	<requestedDisplayResolution>high</requestedDisplayResolution>
	<Entitlements><![CDATA[
		
		<key>com.apple.developer.associated-domains</key>
		<array>
			<string>applinks:abc123.app.goo.gl</string>
		</array>

	)></Entitlements>
</iPhone>
```




