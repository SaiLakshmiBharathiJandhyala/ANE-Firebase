
## Reading Data and Listening to Value Change events

All data reading is an asynchronous process. 


## Get a DatabaseReference

To read or write data from the database, you need an instance of `DatabaseReference`:

```as3
var database:DatabaseReference;

database = FirebaseDatabase.service.getReference();
```


### Listen for value events

To read data at a path and listen for changes you add a listener for the `VALUE_CHANGED` 
event.

```as3
database.addEventListener( DatabaseReferenceEvent.VALUE_CHANGED, valueChangedHandler );
```

You can also attach these listeners to children to get specific updates when a particular
value changes:

```as3
database.child("someKey").addEventListener( DatabaseReferenceEvent.VALUE_CHANGED, valueChangedHandler );
```


In your handler you will have access to a `DataSnapshot` which represents the data 
contained in the node at the time of the event:

```as3
private function valueChangedHandler( event:DatabaseReferenceEvent ):void 
{
	// event.snapshot will contain the DataSnapshot of the reference this listener was attached
	trace( event.snapshot.toString() );
}
```

You should also listen for the `VALUE_CHANGED_ERROR` event at this point. It will 
be dispatched when there is an issue retrieving the value. For example, a read can 
fail if the client doesn't have permission to read from a Firebase database location.

When this event is dispatched the event will have the `errorCode` and `errorDescription`
fields populated with the details of the error.

```as3
database.addEventListener( DatabaseReferenceEvent.VALUE_CHANGED_ERROR, valueChangedErrorHandler );
```

```as3
private function valueChangedErrorHandler( event:DatabaseReferenceEvent ):void 
{
	trace( event.errorCode );
	trace( event.errorDescription );
}
```


