
Cloud Firestore supports atomic operations for reading and writing data. In a set of atomic operations, either all of the operations succeed, or none of them are applied. There are two types of atomic operations in Cloud Firestore:

- Transactions: a transaction is a set of read and write operations on one or more documents.
-  Batched Writes: a batched write is a set of write operations on one or more documents.

Each transaction or batch of writes can write to a maximum of 500 documents. For additional limits related to writes, see [Quotas and Limits](https://firebase.google.com/docs/firestore/quotas#writes_and_transactions).


## Updating data with transactions

Using the Cloud Firestore client libraries, you can group multiple operations into a single transaction. Transactions are useful when you want to update a field's value based on its current value, or the value of some other field. You could increment a counter by creating a transaction that reads the current value of the counter, increments it, and writes the new value to Cloud Firestore.

A transaction consists of any number of `getDocument()` operations followed by any number of write operations such as `setDocument()`, `update()`, or `deleteDocument()`. In the case of a concurrent edit, Cloud Firestore runs the entire transaction again. For example, if a transaction reads documents and another client modifies any of those documents, Cloud Firestore retries the transaction. This feature ensures that the transaction runs on up-to-date and consistent data.

Transactions never partially apply writes. All writes execute at the end of a successful transaction.

When using transactions, note that:

- Read operations must come before write operations.
- A function calling a transaction (transaction function) might run more than once if a concurrent edit affects a document that the transaction reads.
- Transaction functions should not directly modify application state.
- Transactions will fail when the client is offline.

The following example shows how to create and run a transaction:

```as3
var transaction:Transaction = FirebaseFirestore.service.runTransaction(
        function( transaction:Transaction ):void
        {
            trace( "apply( transaction )" );
            
            // Perform transaction operations - may be called multiple times to re-run the transaction

            // You must call finish or abort to complete the transaction
            transaction.finish();
        }
);

transaction.addEventListener( TransactionEvent.SUCCESS, successHandler );
transaction.addEventListener( TransactionEvent.FAILED, failedHandler );


function successHandler( event:TransactionEvent ):void
{
    trace( "success" );
    
    event.currentTarget.removeEventListener( TransactionEvent.SUCCESS, successHandler );
    event.currentTarget.removeEventListener( TransactionEvent.FAILED, failedHandler );
}

function failedHandler( event:TransactionEvent ):void
{
    trace( "failed: " + event.message );
    
    event.currentTarget.removeEventListener( TransactionEvent.SUCCESS, successHandler );
    event.currentTarget.removeEventListener( TransactionEvent.FAILED, failedHandler );
}
```

### Example

This example loads a "user", updates the user's `first` name and increments a `count` property, returning the new count in the event

```as3
var user:DocumentReference = FirebaseFirestore.service.document( "users/12345" );
			
var transaction:Transaction = FirebaseFirestore.service.runTransaction(
        function( transaction:Transaction ):void
        {
            // Read the user document reference
            transaction.getDocument( user, function( snapshot:DocumentSnapshot, message:String ):void
            {
                if (snapshot == null) 
                {
                    // Error
                    transaction.abort();
                }
                else 
                {
                    // Get the user's current count
                    var currentCount:Number = snapshot.getData().count;
                    var newCount:Number = currentCount + 1;
								
                    // Change the first name with a setDocument merge
                    var data:Object = { first: "James" };
                    transaction.setDocument( user, data, SetOptions.merge(), function( snapshot:DocumentSnapshot, message:String ):void
                    {
                        // Update count
                        transaction.update( user, { count: newCount }, function( snapshot:DocumentSnapshot, message:String ):void
                        {
                            // Finish the transaction
                            transaction.finish();
                        });
                    });
                }
            });
        }
);
```

> Note: the `setDocument()` and `update()` calls probably could be combined in this example, but we just wanted to demonstrate the functionality.



### Passing information out of transactions

Do not modify application state inside of your transaction functions. Doing so will introduce concurrency issues, because transaction functions can run multiple times and are not guaranteed to run on the UI thread. Instead, pass information you need out of your transaction functions. The following example builds on the previous example to show how to pass information out of a transaction:


```as3
var user:DocumentReference = FirebaseFirestore.service.document( "users/12345" );
			
var transaction:Transaction = FirebaseFirestore.service.runTransaction(
        function( transaction:Transaction ):void
        {
            // Read the user document reference
            transaction.getDocument( user, function( snapshot:DocumentSnapshot, message:String ):void
            {
                if (snapshot == null) 
                {
                    // Error
                    transaction.abort();
                }
                else 
                {
                    // Get the user's current count
                    var currentCount:Number = snapshot.getData().count;
                    var newCount:Number = currentCount + 1;
								
                    // Change the first name with a setDocument merge
                    var data:Object = { first: "James" };
                    transaction.setDocument( user, data, SetOptions.merge(), function( snapshot:DocumentSnapshot, message:String ):void
                    {
                        // Update count
                        transaction.update( user, { count: newCount }, function( snapshot:DocumentSnapshot, message:String ):void
                        {
                            // Finish the transaction - returning the new count
                            transaction.finish( newCount );
                        });
                    });
                }
            });
        }
);

transaction.addEventListener( TransactionEvent.SUCCESS, successHandler );
transaction.addEventListener( TransactionEvent.FAILED, failedHandler );


function successHandler( event:TransactionEvent ):void
{
    trace( "success" ); 
    
    // event.data will contain the Object passed to finish
    var count:Number = Number(event.data);

    event.currentTarget.removeEventListener( TransactionEvent.SUCCESS, successHandler );
    event.currentTarget.removeEventListener( TransactionEvent.FAILED, failedHandler );
}

function failedHandler( event:TransactionEvent ):void
{
    trace( "failed: " + event.message );
    
    event.currentTarget.removeEventListener( TransactionEvent.SUCCESS, successHandler );
    event.currentTarget.removeEventListener( TransactionEvent.FAILED, failedHandler );
}
```


### Transaction failure

A transaction can fail for the following reasons:

- The transaction contains read operations after write operations. Read operations must always come before any write operations.
- The transaction read a document that was modified outside of the transaction. In this case, the transaction automatically runs again. The transaction is retried a finite number of times.

A failed transaction returns an error and does not write anything to the database. You do not need to roll back the transaction; Cloud Firestore does this automatically.


## Batched writes

If you do not need to read any documents in your operation set, you can execute multiple write operations as a single batch that contains any combination of set(), update(), or delete() operations. A batch of writes completes atomically and can write to multiple documents.

Batched writes are also useful for migrating large data sets to Cloud Firestore. A batched write can contain up to 500 operations and batching operations together reduces connection overhead resulting in faster data migration.

Batched writes have fewer failure cases than transactions and use simpler code. They are not affected by contention issues, because they don't depend on consistently reading any documents. Batched writes execute even when the user's device is offline. The following example shows how to build and commit a batch of writes:


```as3
var batch:WriteBatch = FirebaseFirestore.service.batch();

batch.addEventListener( WriteBatchEvent.SUCCESS, successHandler );
batch.addEventListener( WriteBatchEvent.FAILED, failedHandler );

var ref:DocumentReference = FirebaseFirestore.service.document( "document/path" );

batch.setDocument( ref, { name: "Hector" } );

batch.update( ref, { count: 10000 } );

batch.commit();



function successHandler( event:WriteBatchEvent ):void
{
    trace( "success" );
    
    event.currentTarget.removeEventListener( WriteBatchEvent.SUCCESS, successHandler );
    event.currentTarget.removeEventListener( WriteBatchEvent.FAILED, failedHandler );
}

function failedHandler( event:WriteBatchEvent ):void
{
    trace( "failed: " + event.message );
    
    event.currentTarget.removeEventListener( WriteBatchEvent.SUCCESS, successHandler );
    event.currentTarget.removeEventListener( WriteBatchEvent.FAILED, failedHandler );
}
```
