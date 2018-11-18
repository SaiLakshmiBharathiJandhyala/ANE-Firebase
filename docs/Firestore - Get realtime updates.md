
You can listen to document updates by adding a listener for the `DocumentReference.SNAPSHOT_EVENT` or by calling the `addSnapshotListener()` method. 

Adding this listener to the document will create a snapshot event immediately with the current contents of the single document. Then, each time the contents change, another event will be dispatched with the updates to the document snapshot.

```as3
var document:DocumentReference = FirebaseFirestore.service.collection("cities").document("SF");
document.addSnapshotListener( snapshotEventHandler );

function snapshotEventHandler( event:DocumentReferenceEvent ):void 
{
    var snapshot:DocumentSnapshot = event.snapshot;
    if (event.message != "") 
    {
        trace( "Error fetching document: " + event.message );
    }
    else 
    {
        if (snapshot != null && snapshot.exists())
        {
            trace( JSON.stringify( snapshot.getData() ) );
        }
    }
}
```


## Events for local changes

Local writes in your app will invoke snapshot listeners immediately. This is because of an important feature called "latency compensation." When you perform a write, your listeners will be notified with the new data before the data is sent to the backend.

Retrieved documents have a `metadata.hasPendingWrites` property that indicates whether the document has local changes that haven't been written to the backend yet. You can use this property to determine the source of events received by your snapshot listener:


```as3
function snapshotEventHandler( event:DocumentReferenceEvent ):void 
{
    var snapshot:DocumentSnapshot = event.snapshot;
    if (event.message != null && event.message != "") 
    {
        trace( "Error fetching document: " + event.message );
    }
    else 
    {
        var source:String = snapshot.getMetadata().hasPendingWrites ? "Local" : "Server";
        // ...
    }
}
```


## Events for metadata changes

When listening for changes to a document, collection, or query, you can pass options to control the granularity of events that your listener will receive.

By default, listeners are not notified of changes that only affect metadata. Consider what happens when your app writes a new document:

- A change event is immediately fired with the new data. The document has not yet been written to the backend so so the "pending writes" flag is true.
- The document is written to the backend.
- The backend notifies the client of the successful write. There is no change to the document data, but there is a metadata change because the "pending writes" flag is now `false`.

If you want to receive snapshot events when the document or query metadata changes, pass a listen options object when attaching your listener:

```as3
document.addSnapshotListener( snapshotEventHandler, MetadataChanges.INCLUDE );
```


## Listen to multiple documents in a collection

As with documents, you can use `addSnapshotListener()` instead of `query()` to listen to the results of a query. This creates a query snapshot. For example, to listen to the documents with state CA:

```as3
FirebaseFirestore.service.collection("cities")
        .whereEqualTo("state", "CA")
        .addSnapshotListener( querySnapshotEventHandler );

function querySnapshotEventHandler( event:QueryEvent ):void 
{
    if (event.message != null && event.message != "") 
    {
        trace( "Error with query: " + event.message );
    }
    else 
    {
        for each (var doc:DocumentSnapshot in event.snapshot.getDocuments())
        {
            // ... list cities in CA
        }
    }
}
```

The snapshot handler will receive a new query snapshot every time the query results change (that is, when a document is added, removed, or modified).

>
> **Important**: As explained above under Events for local changes, you will receive events immediately for your local writes. Your listener can use the metadata.hasPendingWrites field on each document to determine whether the document has local changes that have not yet been written to the backend.
>


## View changes between snapshots

It is often useful to see the actual changes to query results between query snapshots, instead of simply using the entire query snapshot. For example, you may want to maintain a cache as individual documents are added, removed, and modified.


```as3
FirebaseFirestore.service.collection("cities")
        .whereEqualTo("state", "CA")
        .addSnapshotListener( querySnapshotEventHandler );

function querySnapshotEventHandler( event:QueryEvent ):void 
{
    if (event.message != null && event.message != "") 
    {
        trace( "Error with query: " + event.message );
    }
    else 
    {
        for each (var docChange:DocumentChange in event.snapshot.getDocumentChanges())
        {
            switch (docChange.changeType)
            {
                case DocumentChange.ADDED:
                    // New city
                    break;
                case DocumentChange.MODIFIED:
                    // Nodified city
                    break;
                case DocumentChange.REMOVED:
                    // Removed city
                    break;
            }
        }
    }
}
```



>
> **Important**: The first query snapshot contains added events for all existing documents that match the query. This is because you're getting a set of changes that bring your query snapshot current with the initial state of the query. This allows you, for instance, to directly populate your UI from the changes you receive in the first query snapshot, without needing to add special logic for handling the initial state.
>

The initial state can come from the server directly, or from a local cache. If there is state available in a local cache, the query snapshot will be initially populated with the cached data, then updated with the server's data when the client has caught up with the server's state.



## Detach a listener

When you are no longer interested in listening to your data, you must detach your listener so that your event callbacks stop getting called. This allows the client to stop using bandwidth to receive updates.

You can use the `removeSnapshotListener()` function to remove your handler and stop updates.

```as3
FirebaseFirestore.service.collection("cities").document("SF")
    .removeSnapshotListener( snapshotEventHandler );
```


