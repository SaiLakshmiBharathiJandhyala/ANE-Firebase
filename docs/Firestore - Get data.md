
There are two ways to retrieve data stored in Cloud Firestore. Either of these methods can be used with documents, collections of documents, or the results of queries:

- Call a method to get the data.
- Set a listener to receive data-change events.

When you set a listener, Cloud Firestore sends your listener an initial snapshot of the data, and then another snapshot each time the document changes.



## Get a document

To retrieve the contents of a single doucment you call the `getDocument()` function on a `DocumentReference`.

As with most of the functionality in this extension you can either use success and failure listeners or event listeners to handle the responses.


> 
> Note: If there is no document at the location referenced by the `DocumentReference`, the resulting document will be empty and calling exists on it will return false.
>


#### Using Success and Failure Listeners 

The following example shows how to retrieve the contents of a single document using `getDocument()` using success and failure listeners:

```as3
FirebaseFirestore.service.document("path")
        .getDocument()
        .addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
        {
            if (event.snapshot.exists())
            {
                trace( "Document data: " + JSON.stringify( event.snapshot.getData() ) );
            }
            else
            {
                trace( "Get Document: Does not exist" );
            }
        })
        .addOnFailureListener( function( message:String ):void
        {
            trace( "get document :: failed :: " + message );
        });
```


#### Using Event Listeners 

The following example shows how to retrieve the contents of a single document using `getDocument()` using event listeners:

```as3
var document:DocumentReference = FirebaseFirestore.service.document( _testDocumentPath );
			
document.addEventListener( DocumentReferenceEvent.GET_SUCCESS, getDocumentSuccessHandler );
document.addEventListener( DocumentReferenceEvent.GET_ERROR, getDocumentErrorHandler );
document.getDocument();

function getDocumentSuccessHandler( event:DocumentReferenceEvent ):void
{
    event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_SUCCESS, getDocumentSuccessHandler );
    event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_ERROR, getDocumentErrorHandler );
    
    if (event.snapshot.exists())
    {
        trace( "Document data: " + JSON.stringify( event.snapshot.getData() ) );
    }
    else
    {
        trace( "Get Document: Does not exist" );
    }
}

function getDocumentErrorHandler( event:DocumentReferenceEvent ):void
{
    event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_SUCCESS, getDocumentSuccessHandler );
    event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_ERROR, getDocumentErrorHandler );
    
    trace( "Get Document Error: " + event.message );
}
```

>
> Note: You need to ensure you remove event listeners after the result in order to allow the references 
> to get garbage collected at the appropriate time. Leaving event listeners attached to a query, collection
> or document will result in the object not being removed from memory.
>



### Source Options 

For platforms with offline support, you can set the source option to control how a get call uses the offline cache.

By default, a get call will attempt to fetch the latest document snapshot from your database. On platforms with offline support, the client library will use the offline cache if the network is unavailable or if the request times out.

You can specify the source option in a `getDocument()` call to change the default behavior. You can fetch from only the database and ignore the offline cache, or you can fetch from only the offline cache. For example:

```as3
FirebaseFirestore.service.document("path")
        .getDocument( Source.CACHE )
        .addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
        {
            // Document found in the offline cache and exists should be true
            if (event.snapshot.exists())
            {
                trace( "Document data: " + JSON.stringify( event.snapshot.getData() ) );
            }
            else
            {
                trace( "Get Document: Does not exist" );
            }
        })
        .addOnFailureListener( function( message:String ):void
        {
            trace( "get document :: failed :: " + message );
        });
```



## Get multiple documents from a collection

You can also retrieve multiple documents with one request by querying documents in a collection. For example, you can use `whereEqualTo()` to query for all of the documents that meet a certain condition, then use `query()` to retrieve the results.

As with most of the functionality in this extension you can either use success and failure listeners or event listeners to handle the responses.


#### Using Success and Failure Listeners

The following example shows how to retrieve the result of the query using success and failure listeners. The listeners should be added after the `query()` call using the `addOnQuerySuccessHandler` and `addOnQueryFailureListener` functions:


```as3
FirebaseFirestore.service.collection("users")
    	.whereEqualTo( "born", 1980 )
        .query()
        .addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
        {
            trace( "addOnQuerySuccessHandler" );
        })
        .addOnQueryFailureListener( function( message:String ):void
        {
            trace( "addOnQueryFailureListener: " + message );
        });
```


#### Using Event Listeners 

The following example shows how to retrieve the result of the query using event listeners:


```as3
var query:Query = FirebaseFirestore.service.collection("users")
    	.whereEqualTo( "born", 1980 );

query.addEventListener( QueryEvent.SUCCESS, querySuccessHandler );
query.addEventListener( QueryEvent.ERROR, queryErrorHandler );

query.query();

function querySuccessHandler( event:QueryEvent ):void
{
    trace( "querySuccessHandler" );
    event.currentTarget.removeEventListener( QueryEvent.SUCCESS, querySuccessHandler );
    event.currentTarget.removeEventListener( QueryEvent.ERROR, queryErrorHandler );
}

function queryErrorHandler( event:QueryEvent ):void
{
    trace( "queryErrorHandler: " + event.message );
    event.currentTarget.removeEventListener( QueryEvent.SUCCESS, querySuccessHandler );
    event.currentTarget.removeEventListener( QueryEvent.ERROR, queryErrorHandler );
}
```

>
> Note: You need to ensure you remove event listeners after the result in order to allow the references 
> to get garbage collected at the appropriate time. Leaving event listeners attached to a query, collection
> or document will result in the object not being removed from memory.
>



### Get all documents in a collection

In addition, you can retrieve all documents in a collection by omitting the `whereEqualTo()` filter entirely and just referencing the collection.

```as3
FirebaseFirestore.service.collection("users")
    .query()
    .addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
    {
        trace( "addOnQuerySuccessHandler" );
    })
    .addOnQueryFailureListener( function( message:String ):void
    {
        trace( "addOnQueryFailureListener: " + message );
    });
```



## List subcollections of a document

The `getCollections()` method of the Cloud Firestore server client libraries lists all subcollections of a document reference.

Retrieving a list of collections is not possible with the mobile/web client libraries. You should only look up collection names as part of administrative tasks in trusted server environments. If you find that you need this capability in the mobile/web client libraries, consider restructuring your data so that subcollection names are predictable.


