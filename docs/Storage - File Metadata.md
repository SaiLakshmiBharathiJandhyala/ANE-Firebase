
## File Metadata

After uploading a file to Firebase Storage reference, you can also get and update 
the file metadata, for example to view or update the content type. Files can also 
store custom key/value pairs with additional file metadata.


## Get File Metadata

File metadata contains common properties such as name, size, and contentType 
(often referred to as MIME type) in addition to some less common ones like 
contentDisposition and timeCreated. This metadata can be retrieved from a 
Firebase Storage reference using the `getMetadata()` method.


```as3
var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test.png" );
reference.getMetadata();
```

This will dispatch one of two events when the process is complete,

- `StorageReferenceEvent.GET_METADATA_SUCCESS`: if metadata was successfully retrieved
- `StorageReferenceEvent.GET_METADATA_ERROR`: if there was an error

```as3
reference.addEventListener( StorageReferenceEvent.GET_METADATA_SUCCESS, getMetadata_successHandler );
reference.addEventListener( StorageReferenceEvent.GET_METADATA_ERROR, getMetadata_errorHandler );
```

```as3
private function getMetadata_successHandler( event:StorageReferenceEvent ):void 
{
	// getMetadata success
}

private function getMetadata_errorHandler( event:StorageReferenceEvent ):void 
{
	// getMetadata error
	trace( event.errorMessage );
}
```



