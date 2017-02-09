
## Upload Files 

To upload a file to Firebase Storage, you first create a reference to the full path of the file, including the file name.

```as3
var reference:StorageReference = FirebaseStorage.service.getInstance().child( "images/upload.png" );
```

Once you've created an appropriate reference, you then call the following to upload to Firebase Storage:

- `putBytes()`: Upload from data in memory
- `putFile()`: Upload a file on the file system


## Upload from data in memory

The `putBytes()` method is the simplest way to upload a file to Firebase Storage. 
`putBytes()` takes a `ByteArray` and returns an `UploadTask` that you can use to 
manage and monitor the status of the upload.

```as3
// Data from some source, eg encoding bitmap data to jpg
var bytes:ByteArray = ...; 

var task:UploadTask = reference.putBytes( bytes );
```

Because `putBytes()` accepts a `ByteArray`, it requires your app to hold the entire 
contents of a file in memory at once. 



## Upload from a local file

You can upload local files on the device, such as photos and videos from the camera, 
with the `putFile()` method. `putFile()` takes a File url and returns an `UploadTask` 
which you can use to manage and monitor the status of the upload.


```as3
var file:File = File.applicationStorageDirectory.resolvePath( "plane.png" );

var task:UploadTask = reference.putFile( "file://" + file.nativePath );
```


## Add File Metadata

You can also include metadata when you upload files. This metadata contains 
typical file metadata properties such as `name`, `size`, and `contentType` 
(commonly referred to as MIME type). The `putFile()` method automatically 
infers the MIME type from the File extension, but you can override the 
auto-detected type by specifying `contentType` in the metadata. If you do 
not provide a `contentType` and Firebase Storage cannot infer a default from 
the file extension, Firebase Storage uses `application/octet-stream`. 

See the [File Metadata|Storage - File Metadata] section for more information about file metadata.


```as3
var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test" );

var metadata:StorageMetadata = new StorageMetadata();
metadata.contentType = "image/jpg";

var task:UploadTask = reference.putFile( "file://" + file.nativePath, metadata );
```


## Manage Uploads

In addition to starting uploads, you can pause, resume, and cancel uploads 
using the `pause()`, `resume()`, and `cancel()` methods. Pause and resume 
events raise pause and progress state changes respectively. Canceling an 
upload causes the upload to fail with an error indicating that the upload 
was canceled.

```as3
// Pause the upload
task.pause();

// Resume the upload
task.resume();

// Cancel the upload
task.cancel();
```


## Monitor Upload Progress

An upload task dispatches `UploadTaskEvent`s to indicate completion, progress, and errors:

```as3
task.addEventListener( UploadTaskEvent.SUCCESS, uploadSuccessHandler );
task.addEventListener( UploadTaskEvent.ERROR, uploadErrorHandler );
```


Events are dispatched with a `UploadTaskSnapshot` object. 
This object is an immutable view of the task at the time the event occurred.

```as3
private function uploadSuccessHandler( event:UploadTaskEvent ):void 
{
	// event.snapshot contains details about the completed upload
}

private function uploadErrorHandler( event:UploadTaskEvent ):void 
{
	// Handle unsuccessful uploads
	// event.errorMessage contains the reason for the error
}
```




