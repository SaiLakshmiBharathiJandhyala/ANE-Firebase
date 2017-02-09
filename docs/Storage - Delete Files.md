
## Delete Files

To delete a file, first create a reference. to that file. Then call the `deleteReference()` method on that reference.

```as3
var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test.png" );

reference.addEventListener( StorageReferenceEvent.DELETE_SUCCESS, deleteHandler );
reference.addEventListener( StorageReferenceEvent.DELETE_ERROR, deleteHandler );

reference.deleteReference();
```

Then you will receive either a success or error event:

```as3
private function reference_deleteHandler( event:StorageReferenceEvent ):void 
{
	trace( event.type );

	// Remove listeners 
	var reference:StorageReference = StorageReference(event.currentTarget);
	reference.removeEventListener( StorageReferenceEvent.DELETE_SUCCESS, reference_deleteHandler );
	reference.removeEventListener( StorageReferenceEvent.DELETE_ERROR, reference_deleteHandler );
}
```



