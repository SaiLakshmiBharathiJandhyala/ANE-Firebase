
## Usage

Nothing in particular is required to start reporting crashes, as long as 
you have correctly initialised the Firebase application using the main Firebase 
extension and included the Firebase Crash extension then crashes will start 
to appear in your console.

### Logs

You can add logs to your reports by using the `log` function. 

This method adds a message to the crash reporter logging system. 
The recent logs will be sent with the crash report when the application 
exits abnormally. Note that the timestamp of this message and the 
timestamp of the console message may differ by a few milliseconds.

```as3
FirebaseCrash.service.log( "Testing a crash log message" );
```


### Report

On Android you can force a crash report by calling the `report` function.

This will use the `Error` passed as the message for the crash report. It is 
generally not particularly useful as we can't take advantage of the Java Exception
from AIR however you may find it useful to be able to force error reports.

```as3
var error:Error = new Error( "Some error occurred" );

FirebaseCrash.service.report( error ); 
```

>
> This does nothing on iOS as this functionality is not supported by the SDK
>


### Debugging

You can force your application to crash causing a crash report in Firebase by calling 
the `forceCrash` function.

```as3
FirebaseCrash.service.forceCrash();
```

This creates an error that will cause your application to crash. Your application 
may continue to operate on some operating systems, however you should consider the 
application unstable after calling this function.

