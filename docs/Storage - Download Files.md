
## Download Files 

To download a file, first create a Firebase Storage reference to the file you want to download.

```as3
var reference:StorageReference = FirebaseStorage.service.getReference().child( "downloads/example.png" );
```


## Download Files

Once you have a reference, you can download files from Firebase Storage by calling 
the `getBytes()` or `getFile()`. You can also download the file directly from the URL
using a standard AS3 loader.


## Download in memory

Download the file to a `ByteArray` with the `getBytes()` method. This is the easiest way 
to download a file, but it must load the entire contents of your file into memory. 

If you request a file larger than your app's available memory, your app will crash. 
To protect against memory issues, `getBytes()` takes a maximum amount of bytes to 
download. Set the maximum size to something you know your app can handle, or use 
another download method.

```as3
var task:DownloadTask = reference.getBytes( 1024*1024 );
```

> 
> Note: `DownloadTask` retrieved from `getBytes` cannot be paused or canceled and 
> will not dispatch the equivalent progress or paused events.
> 

To get access to the byte data you should listen for the `SUCCESS` event:

```as3
task.addEventListener( DownloadTaskEvent.SUCCESS, downloadSuccessHandler );
```

In your handler you will have access to the byte data via the `taskSnapshot`:

```as3
private function downloadSuccessHandler( event:DownloadTaskEvent ):void 
{
	var data:ByteArray = event.taskSnapshot.bytes; 
}
```



## Download to a local file

The `getFile()` method downloads a file directly to a local device. 

Use this if your users want to have access to the file while offline or to share 
the file in a different app. `getFile()` returns a `DownloadTask` which you can use 
to manage your download and monitor the status of the download.


```as3 
var file:File = File.applicationStorageDirectory.resolvePath( "downloads/test.png" );

var task:DownloadTask = reference.getFile( file );
```

> 
> A `DownloadTask` from `getFile` will have access to all the functionality defined 
> including progress and paused events.
>



## Monitor Download Progress

A download task dispatches `DownloadTaskEvent`s to indicate completion, progress, and errors:

```as3
task.addEventListener( DownloadTaskEvent.SUCCESS, downloadSuccessHandler );
task.addEventListener( DownloadTaskEvent.ERROR, downloadErrorHandler );
```


Events are dispatched with a `DownloadTaskSnapshot` object. 
This object is an immutable view of the task at the time the event occurred.

```as3
private function downloadSuccessHandler( event:DownloadTaskEvent ):void 
{
	// event.taskSnapshot contains details about the completed download
}

private function downloadErrorHandler( event:DownloadTaskEvent ):void 
{
	// Handle unsuccessful download
	// event.errorMessage contains the reason for the error
}
```


## Manage Downloads

In addition to starting downloads, you can pause, resume, and cancel uploads 
using the `pause()`, `resume()`, and `cancel()` methods. Pause and resume 
events raise pause and progress state changes respectively. Canceling a
download causes the download to fail with an error indicating that the download 
was canceled.

```as3
// Pause the download
task.pause();

// Resume the download
task.resume();

// Cancel the download
task.cancel();
```
