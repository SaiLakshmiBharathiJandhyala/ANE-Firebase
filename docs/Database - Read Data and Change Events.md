
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


### Read Data Once

In some cases you may want a callback to be called once and then immediately removed, 
such as when initializing a UI element that you don't expect to change. This is useful 
for data that only needs to be loaded once and isn't expected to change frequently or 
require active listening.

To this end you can use the `once( callback:Function )` method and provide a callback 
function to handle the result.

```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );

ref.once( function( value:Object ):void 
{
	if (value != null)
	{
		trace( JSON.stringify( value ) );
	}
	else 
	{
		// There was an error
	}
});
```

The `once` function takes a `Function` as a parameter which will be called when the value 
has been read. This function should have one parameter of type `Object` which will be the 
resulting `value` of the read operation. This value may be `null` if an error occurred. 


