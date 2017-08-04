## Disable the Firebase Performance Monitoring

To let you users opt-in or opt-out of using Firebase Performance Monitoring, you might want to configure your app so that you can enable and disable Performance Monitoring. You might also find this capability to be useful during app development and testing.

You can disable the Performance Monitoring SDK when building your app with the option to re-enable it at runtime, or build your app with Performance Monitoring enabled and then have the option to disable it at runtime using Firebase Remote Config. You can also completely deactivate Performance Monitoring, with no option to enable it at runtime.

## Disable during your app build process

One situation where disabling Performance Monitoring during your app build process could 
be useful is to avoid reporting performance data from a pre-release version of your app 
during app development and testing.

### iOS

You can add one of two keys to the Info Additions for your iOS app to disable or deactivate Performance Monitoring:

- To disable Performance Monitoring, but allow your app to enable it at runtime, set `firebase_performance_collection_enabled` to `false`
- To completely deactivate Performance Monitoring with no option to enable it at runtime, set `firebase_performance_collection_deactivated` to `true`. This setting overrides the `firebase_performance_collection_enabled` setting and must be removed to re-enable Performance Monitoring.


```xml
<iPhone>
	<InfoAdditions><![CDATA[

		<key>firebase_performance_collection_enabled</key>
        <false/>

        <key>firebase_performance_collection_deactivated</key>
        <true/>

    )></InfoAdditions>

    <!-- Other iPhone settings -->

</iPhone>
```


### Android 

You can disable Performance Monitoring at build time, but allow your app to enable it at runtime, 
by adding a <meta-data> element to the <application> element of your app's manifest additions as follows:

```xml
<application>
    ...
    <meta-data android:name="firebase_performance_collection_enabled" android:value="false" />
    ...
</application>
```

To completely deactivate Performance Monitoring with no option to enable it at runtime, 
add a <meta-data> element to the <application> element of your app's manifest additions, as follows:

```xml
<application>
    ...
    <meta-data android:name="firebase_performance_collection_deactivated" android:value="true" />
    ...
</application>
```
>
> Note: This setting overrides the `firebase_performance_collection_enabled` setting and must be 
> removed from your app's manifest additions to re-enable Performance Monitoring.
>


## Disable your app at runtime


To disable or enable your app at runtime you can use the `setPerformanceCollectionEnabled` method.

For example to enable the collection at runtime:

```as3
FirebasePerformance.service.setPerformanceCollectionEnabled( true );
```

You can also use the `isPerformanceCollectionEnabled` method to check if performance monitoring 
is enabled in your application.


Remote Config lets you make changes to the behavior and appearance of your app, 
so it provides an ideal way to let you disable Performance Monitoring in deployed 
instances of your app. Simply use a remote config variable to pass to the 
`setPerformanceCollectionEnabled` function.


