
## Add data

Cloud Firestore stores data in Documents, which are stored in Collections. Cloud Firestore creates collections and documents implicitly the first time you add data to the document. You do not need to explicitly create collections or documents.


There are several ways to write data to Cloud Firestore:

- Set the data of a document within a collection, explicitly specifying a document identifier.
- Add a new document to a collection. In this case, Cloud Firestore automatically generates the document identifier.
- Create an empty document with an automatically generated identifier, and assign data to it later.

This guide explains how to use the `setDocument()`, `add()`, or `update()` methods to write data to individual documents in Cloud Firestore. 


### Set a document

To create or overwrite a single document, use the `setDocument()` method:

```as3
var city:Object = {
				name: "Los Angeles",
				state: "CA",
				country:  "USA"
			};

var document:DocumentReference = FirebaseFirestore.service.collection( "cities" ).document( "LA" );
			
document.addEventListener( DocumentReferenceEvent.SET_SUCCESS, successHandler );
document.addEventListener( DocumentReferenceEvent.SET_ERROR, errorHandler );
document.setDocument( city );
```

The `setDocument()` call will dispatch one of two events:

- `DocumentReferenceEvent.SET_SUCCESS`: The document has been correctly set with the new data
- `DocumentReferenceEvent.SET_ERROR`: There was an error setting the data to the document

You should ensure you remove the event listeners at this point to ensure the extension can correctly clean up memory usage of unused document references.

```as3
function successHandler( event:DocumentReferenceEvent ):void
{
	event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_SUCCESS, successHandler );
	event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_ERROR, errorHandler );
	
	trace( "Set Document: Success" );
}

function errorHandler( event:DocumentReferenceEvent ):void
{
	event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_SUCCESS, successHandler );
	event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_ERROR, errorHandler );
	
	trace( "Get Document Error: " + event.message );
}
```

Alternatively you can add a success and failure listener directly:

```as3
document.setDocument( city )
	.addOnSuccessListener( function( snapshot:DocumentSnapshot ):void {
		// Document was successfully set
	})
	.addOnFailureListener( function( message:String ):void {
		// Error occurred
	});
```

If the document does not exist, it will be created. If the document does exist, its contents will be overwritten with the newly provided data, unless you specify that the data should be merged into the existing document, as follows:

```as3
document.setDocument( city, SetOptions.merge() );
```

If you're not sure whether the document exists, pass the option to merge the new data with any existing document to avoid overwriting entire documents.



### Data types

Cloud Firestore lets you write a variety of data types inside a document, including strings, booleans, numbers, dates, null, and nested arrays and objects. Cloud Firestore always stores numbers as doubles, regardless of what type of number you use in your code.


```as3
var data:Object = {
	stringExample: "Hello world!",
	booleanExample: true,
	numberExample: 3.14159265,
	dateExample: new Date(),
	nullExample: null,
	arrayExample: [ 1, 2, 3 ],
	nestedData: {
		a: 5,
		b: true
	}
};
```


### Custom objects

Not currently supported


### Add a document

When you use `setDocument()` to create a document, you must specify an ID for the document to create. For example:

```as3
FirebaseFirestore.service.collection( "cities" ).document( "LA" ).setDocument(data);
```

But sometimes there isn't a meaningful ID for the document, and it's more convenient to let Cloud Firestore auto-generate an ID for you. You can do this by calling `add()`:

```as3
var collection:CollectionReference = FirebaseFirestore.service.collection( "cities" );

collection.addEventListener( CollectionReferenceEvent.ADD_SUCCESS, successHandler );
collection.addEventListener( CollectionReferenceEvent.ADD_ERROR, errorHandler );
collection.add( data );
		
function successHandler( event:CollectionReferenceEvent ):void
{
	event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_SUCCESS, successHandler );
	event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_ERROR, errorHandler );
	
	trace( "Add Success: document.getId()   = " + event.document.getId() );
	trace( "Add Success: document.getPath() = " + event.document.getPath() );
}

function errorHandler( event:CollectionReferenceEvent ):void
{
	event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_SUCCESS, successHandler );
	event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_ERROR, errorHandler );
	
	trace( "Add Error: " + event.message );
}
```

In some cases, it can be useful to create a document reference with an auto-generated ID, then use the reference later. For this use case, you can call `document()`:


```as3
var document:DocumentReference = FirebaseFirestore.service.collection( "cities" ).document();

// ... later
document.set( data );
```


Behind the scenes, `.add(...)` and `.document().setDocument(...)` are completely equivalent, so you can use whichever is more convenient.







### Update a document

To update some fields of a document without overwriting the entire document, use the `update()` method:


```as3
var changes:Object = {
				population:  4018000
			};
			
var document:DocumentReference = FirebaseFirestore.service.collection( "cities" ).document( "LA" );

document.addEventListener( DocumentReferenceEvent.UPDATE_SUCCESS, successHandler );
document.addEventListener( DocumentReferenceEvent.UPDATE_ERROR, errorHandler );
document.update( changes );


function successHandler( event:DocumentReferenceEvent ):void
{
	event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_SUCCESS, successHandler );
	event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_ERROR, errorHandler );
	
	trace( "Update Success" );
}

function errorHandler( event:DocumentReferenceEvent ):void
{
	event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_SUCCESS, successHandler );
	event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_ERROR, errorHandler );
	
	trace( "Update Error: " + event.message );
}
```


You can also add server timestamps to specific fields in your documents, to track when an update was received by the server:


```as3
var changes:Object = {
				population:  4018000,
				timestamp: FieldValue.serverTimestamp()
			};

var document:DocumentReference = FirebaseFirestore.service.collection( "cities" ).document( "LA" );
		
document.update( changes );
```