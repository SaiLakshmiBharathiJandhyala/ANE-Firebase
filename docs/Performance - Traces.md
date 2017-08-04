
## Automatic Traces

A trace is a report of performance data captured between two points in time in your app. When installed, the Performance Monitoring SDK automatically provides the following types of traces:

App start traces, which measure the time between when the user opens the app and when the app is responsive.
App in background traces, which measure the time when the app is running in the background.
App in foreground traces, which measure the time when the app is running in the foreground and available to the user.

### Automatic Trace Definitions

| Trace Name | iOS | Android |
|---|---|---|
| App start | Starts when the application loads the first Object to memory and stops after the first successful run loop that occurs after the application receives the UIApplicationDidBecomeActiveNotification notification. | Starts when the app's FirebasePerfProvider ContentProvider completes its onCreate method and stops when the first activity's onResume() method is called. |
| App in background | Starts when the application receives the UIApplicationWillResignActiveNotification notification and stops when it receives the UIApplicationDidBecomeActiveNotification notification. | Starts when the last activity to leave the foreground has its onStop() method called and stops when the first activity to reach the foreground has its onResume() method called. |
| App in foreground | Starts when the application receives the UIApplicationDidBecomeActiveNotification notification and stops when it receives the UIApplicationWillResignActiveNotification notification. | Starts when the first activity to reach the foreground has its onResume() method called and stops when the last activity to leave the foreground has its onStop() method called. |



## Custom Traces

A custom trace is a report of performance data associated with some of the code in your app. 

You can have multiple custom traces in your app, and it is possible to have more than one custom trace running at a time. Each custom trace can have one or more counters to count performance-related events in your app, and those counters are associated with the traces that create them.

1.  Add the following imports:

```as3
import com.distriqt.extension.firebase.performance.FirebasePerformance;
import com.distriqt.extension.firebase.performance.metrics.Trace;
```

2. Just before the code where you want to start a trace in your app, add the following line of code to start a trace called `test_trace`:

```as3
var testTrace:Trace = FirebasePerformance.service.newTrace( "test_trace" );
testTrace.start();
```

3. _Optional_ To count performance-related events that occur in your app (such as cache hits and misses), add a line of code similar to the following each time that the event occurs, using a string other than `item_counter` to name that event if you are counting a different type of event:

```as3
testTrace.incrementCounter( "item_counter" );
```

4. Just after the code where you want to stop your trace, add the following line of code:

```as3
testTrace.stop();
```



## Check the Firebase console for Performance Monitoring results

Results should appear in the Performance Monitoring section of the Firebase console within 12 hours.

