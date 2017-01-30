
## Transactions

When working with data that could be corrupted by concurrent modifications, such 
as incremental counters, you can use a transaction operation. 

You give this operation an important argument: an instance of a `TransactionHandler`.

This class will implement a function that takes the current state of the data as an 
argument and returns the new desired state you would like to write. If another client 
writes to the location before your new value is successfully written, your update 
function is called again with the new current value, and the write is retried.

Using a transaction prevents data from being incorrect if multiple users change the 
same data at the same time or the client had stale data. If the transaction is rejected, 
the server returns the current value to the client, which runs the transaction again 
with the updated value. This repeats until the transaction is accepted or too many 
attempts have been made.


In the following example we will start a transaction, by calling `runTransaction()` 
on a `DatabaseReference` and pass in an instance of a class that implements the 
`TransactionHandler` interface. 

We will attempt to increment a "count" value which will be a synchronised counter.

```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference( "count" );

ref.runTransaction( new CountTransactionHandler() );
```

The implementation of the `CountTransactionHandler` sets the logic for updating 
the value of the data. It has one function `doTransaction` that will be called 
each time the Firebase transaction requires updating of the data value.
Here we will increment the count value:

```as3
public class CountTransactionHandler implements TransactionHandler
{
	
	public function doTransaction( mutableData:MutableData ):TransactionResult
	{
		var data:Object = mutableData.getValue();
		if (data == null)
		{
			// Set an initial value
			mutableData.setValue( 0 );
			return TransactionResult.success(mutableData);
		}
		mutableData.setValue( mutableData.getValue() + 1 );
		return TransactionResult.success(mutableData);
	}
	
}
```

You can use any logic in this `doTransaction` function that you require. However it 
is important that you return a `TransactionResult`:

- on **success** use: `TransactionResult.success( mutableData );`
- on **failure** use: `TransactionResult.abort();`


> 
> Note: Because `doTransaction()` is called multiple times, it must be able to handle 
> `null` data. Even if there is existing data in your remote database, it may not be 
> locally cached when the transaction function is run, resulting in `null` for the 
> initial value.
>

