
## Test your Firebase Crashlytics implementation

### Force a crash to test your implementation

You don't have to wait for a crash to know that Crashlytics is working. You can call `forceCrash()` to force a crash:


```as3
FirebaseCrashlytics.service.forceCrash();
```

When testing, reopen your app after calling the `forceCrash` method to make sure Crashlytics has a chance to report the crash. The report should appear in the Firebase console within five minutes.



### Enable Crashlytics debug mode

If your forced crash didn't crash, crashed before you wanted it to, or you're experiencing some other issue with Crashlytics, you can enable Crashlytics debug mode to track down the problem.

To enable debug mode you will need to call `setDebugMode( true )` before you enable collection:


```as3
Firebase.service.initialiseApp();

// Enable debug mode
FirebaseCrashlytics.service.setDebug( true );

FirebaseCrashlytics.service.enableCollection();
```

Enabling debug mode will result in more logs being output to the logs which you can access via this [tutorial](https://airnativeextensions.github.io/tutorials/device-logs):

[https://airnativeextensions.github.io/tutorials/device-logs](https://airnativeextensions.github.io/tutorials/device-logs)





