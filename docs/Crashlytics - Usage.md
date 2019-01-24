
## Usage

In order to enable collection of crash reports you simply need to call `enableCollection()` at some point in your application after having initialised your Firebase app.

```as3
Firebase.service.initialiseApp();

FirebaseCrashlytics.service.enableCollection();
```



## Customise Crash Reports

### Enable opt-in reporting

By default, Firebase Crashlytics automatically collects crash reports for all your app's users. To give users more control over the data they send, you can enable opt-in reporting instead.

To do that, you have to disable automatic collection and initialize Crashlytics only for opt-in users.

Then you can ask your user to opt-in as required only calling the crashlytics function `enableCollection()` after the user agrees:

```as3
FirebaseCrashlytics.service.enableCollection();
```

To turn off automatic collection use the following methods dependent on your platform:

#### Android 

Turn off automatic collection with a meta-data tag in your manifest additions, with in the `application` tag:

```xml
<meta-data
    android:name="firebase_crashlytics_collection_enabled"
    android:value="false" />
```

#### iOS 

Turn off automatic collection with a new key to your InfoAdditions:

```xml
<key>firebase_crashlytics_collection_enabled</key>
<false/>
```



### Add custom logs

To give yourself more context for the events leading up to a crash, you can add custom Crashlytics logs to your app. Crashlytics associates the logs with your crash data and makes them visible in the Firebase console.


```as3
FirebaseCrashlytics.service.log( "a log message" );
```

>
> To avoid slowing down your app, Crashlytics limits logs to 64kB. Crashlytics deletes older log entries if a session's logs go over that limit.
>



### Add custom keys

Custom keys help you get the specific state of your app leading up to a crash. You can associate arbitrary key/value pairs with your crash reports, and see them in the Firebase console.

There are several methods to set keys. Each handles a different data type:


```as3
FirebaseCrashlytics.service.setIntValue( 1 /* int value */, key );

FirebaseCrashlytics.service.setNumericValue( 1.0 /* Number value */, key );

FirebaseCrashlytics.service.setBooleanValue( true /* Boolean value */, key );

FirebaseCrashlytics.service.setStringValue( "a value" /* String value */, key );
```

The `key` value is a `String`.



### Set user IDs

To diagnose an issue, it’s often helpful to know which of your users experienced a given crash. Crashlytics includes a way to anonymously identify users in your crash reports.

To add user IDs to your reports, assign each user a unique identifier in the form of an ID number, token, or hashed value:


```as3
FirebaseCrashlytics.service.setUserIdentifier( "user123456789" );
```


If you ever need to clear a user identifier after you set it, reset the value to a blank string. Clearing a user identifier does not remove existing Crashlytics records. If you need to delete records associated with a user ID, [contact Firebase support](https://firebase.google.com/support/contact/?category=other-category&component=crashlytics&summary=Please%20delete%20records%20associated%20with%20UID%20[ENTER_USER_ID_HERE]).



### Log non-fatal exceptions

In addition to automatically reporting your app’s crashes, Crashlytics lets you log non-fatal exceptions.

You do this by calling the `recordError()` method, passing an `Error` object:

```as3
var e:Error = ...;

FirebaseCrashlytics.service.recordError( e );
```

All logged exceptions appear as non-fatal issues in the Firebase console.

>
> Crashlytics only stores the most recent 8 exceptions in a given app session. If your app throws more than 8 exceptions in a session, older exceptions are lost.
>



### Manage Crash Insights data

Crash Insights helps you resolve issues by comparing your anonymized stack traces to traces from other Firebase apps and letting you know if your issue is part of a larger trend. For many issues, Crash Insights even provides resources to help you debug the crash.

Crash Insights uses aggregated crash data to identify common stability trends. If you’d prefer not to share your app's data, you can opt-out of Crash Insights from the Crash Insights menu at the top of your Crashlytics issue list in the Firebase console.

