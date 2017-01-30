
## Working with Lists of Data

The following covers working with lists of data, including pushing values, 
child events, and, sorting and filtering the data.


### Get a DatabaseReference

To read and write data from the database, you need an instance of `DatabaseReference`:

```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference( "list" );
```



## Read and Write Lists

### Append to a list of data

Use the `push()` method to append data to a list in multiuser applications. 
The `push()` method generates a unique key every time a new child is added 
to the specified Firebase reference. By using these auto-generated keys for 
each new element in the list, several clients can add children to the same 
location at the same time without write conflicts. The unique key generated 
by `push()` is based on a timestamp, so list items are automatically ordered 
chronologically.

You can use the reference to the new data returned by the `push()` method to 
get the value of the child's auto-generated key or set data for the child. 
Calling `getKey()` on a `push()` reference returns the value of the 
auto-generated key.


```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference( "list" );
var item:DatabaseReference = ref.push();

item.child("name").setValue( "a pushed item" );
item.child("count").setValue( 100 );
```


### Listen for child events

When working with lists, your application should listen for child events 
rather than the value events used for single objects.

Child events are triggered in response to specific operations that happen 
to the children of a node from an operation such as a new child added through 
the `push()` method or a child being updated through the `updateChildren()` 
method. Each of these together can be useful for listening to changes to a 
specific node in a database.

The child events are defined in the `DatabaseReferenceChildEvent` class:

- `CHILD_ADDED`: Retrieve lists of items or listen for additions to a list of items
- `CHILD_CHANGED`: Listen for changes to the items in a list
- `CHILD_REMOVED`: Listen for items being removed from a list
- `CHILD_MOVED`: Listen for changes to the order of items in an ordered list
- `ERROR`: Errors occurring with child operations

These events will contain the static (immutable) snapshot at the child location
and it's position in the list or information about the error.

For example:

```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference( "list" );
ref.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, childAddedHandler );
```

```as3
private function childAddedHandler( event:DatabaseReferenceChildEvent ):void
{
	trace( "child added::"+event.snapshot.key +"::"+event.previousChildName );
}
```


### Listen for value events

While using a listening for child events  is the recommended way to read lists 
of data, there are situations where attaching a value listener to a list reference 
is useful.

Attaching a `DatabaseReferenceEvent.VALUE_CHANGED` event listener to a list of 
data will return the entire list of data as a single DataSnapshot, which you can 
then loop over to access individual children

Even when there is only a single match for the query, the snapshot is still a list; 
it just contains a single item. To access the item, you need to loop over the result:

For example: 

```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference( "list" );
ref.addEventListener( DatabaseReferenceEvent.VALUE_CHANGED, valueChangedHandler );
```

```as3
private function valueChangedHandler( event:DatabaseReferenceEvent ):void
{
	trace( "child added::"+event.snapshot.key );
	for each (var child:DataSnapshot in event.snapshot.children)
	{
		trace( JSON.stringify( child.value ));
	}
}
```

This pattern can be useful when you want to fetch all children of a list in a 
single operation, rather than listening for additional child events.



## Sorting and filtering data

You can use the Realtime Database Query class to retrieve data sorted by key, 
by value, or by value of a child. You can also filter the sorted result to a 
specific number of results or a range of keys or values.

>
> Note: Filtering and sorting can be expensive, especially when done on the client. 
> If your app uses queries, define the .indexOn rule to index those keys on the 
> server and improve query performance as described in 
> [Indexing Your Data](https://firebase.google.com/docs/database/security/indexing-data).
>

### Sort data

To retrieve sorted data, start by specifying one of the order-by methods to 
determine how results are ordered:

| Method | Usage |
| --- | --- |
| `orderByChild()` |	Order results by the value of a specified child key. |
| `orderByKey()`   |	Order results by child keys. |
| `orderByValue()` |	Order results by child values. |

You can only use one order-by method at a time. Calling an order-by method multiple times in the same query throws an error.

The following example demonstrates how you could retrieve a list sorted by their count:

```as3
_query = FirebaseDatabase.service.getReference( "list" ).orderByChild( "count" );
_query.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, query_childAddedHandler );
```

Then in your handler, use `event.snapshot` to access data:

```as3
private function query_childAddedHandler( event:DatabaseReferenceChildEvent ):void 
{
	// Query result child added, trace out data value key
	trace( JSON.stringify( event.snapshot.value ) );
}
```

This defines a query that when combined with a child listener synchronizes the client 
with the data from the "list" path in the database, ordered by the number of "count" 
each item has. 

The call to the `orderByChild()` method specifies the child key to order the results by. 
In this case, data is sorted by the value of the `count` child in each post. 
For more information on how other data types are ordered, see 
[How query data is ordered](https://firebase.google.com/docs/database/android/lists-of-data#data-order).


### Filtering data

To filter data, you can combine any of the limit or range methods with an order-by method when constructing a query.

| Method | Usage |
| --- | --- |
| `limitToFirst()` | Sets the maximum number of items to return from the beginning of the ordered list of results. |
| `limitToLast()`  | Sets the maximum number of items to return from the end of the ordered list of results. |
| `startAt()`      | Return items greater than or equal to the specified key or value depending on the order-by method chosen. |
| `endAt()`        | Return items less than or equal to the specified key or value depending on the order-by method chosen. |
| `equalTo()`      | Return items equal to the specified key or value depending on the order-by method chosen. |

Unlike the order-by methods, you can combine multiple limit or range functions. 
For example, you can combine the startAt() and endAt() methods to limit the results 
to a specified range of values.

Even when there is only a single match for the query, the snapshot is still a list; 
it just contains a single item. To access the item, you need to loop over the result:

```as3
private function query_valueChangedHandler( event:DatabaseReferenceEvent ):void
{
	for each (var child:DataSnapshot in event.snapshot.children)
	{
		trace( JSON.stringify( child.value ));
	}
}
```

#### Limit the number of results

You can use the `limitToFirst()` and `limitToLast()` methods to set a maximum 
number of children to be synced for a given callback. For example, if you use 
`limitToFirst()` to set a limit of `100`, you initially only receive up to `100` 
`CHILD_ADDED` events. 

If you have fewer than `100` items stored in your Firebase database, a 
`CHILD_ADDED` event is dispatched for each item.

As items change, you receive `CHILD_ADDED` events for items that enter the 
query and `CHILD_REMOVED` events for items that drop out of it so that the 
total number stays at 100.

For example, the following demonstrates how to define a query to retrieve a 
list of the 100 most recent "list" items: 

```as3
var query:Query = FirebaseDatabase.service.getReference( "list" ).limitToFirst(100);
```


#### Filter by key or value

You can use startAt(), endAt(), and equalTo() to choose arbitrary starting, 
ending, and equivalence points for queries. This can be useful for paginating 
data or finding items with children that have a specific value.

For example, we can find all values in our "list" that have a "count" greater than
600:

```as3
var query:Query = FirebaseDatabase.service.getReference( "list" ).startAt( 600, "count" );
```


### How query data is ordered

> 
> This section explains how data is sorted by each of the order-by methods in the Query class.
> 
> #### orderByChild
> 
> When using `orderByChild()`, data that contains the specified child key is ordered as follows:
> 
> - Children with a `null` value for the specified child key come first.
> - Children with a value of `false` for the specified child key come next. If multiple children have a value of `false`, they are sorted [lexicographically](http://en.wikipedia.org/wiki/Lexicographical_order) by key.
> - Children with a value of `true` for the specified child key come next. If multiple children have a value of `true`, they are sorted lexicographically by key.
> - Children with a numeric value come next, sorted in ascending order. If multiple children have the same numerical value for the specified child node, they are sorted by key.
> - Strings come after numbers and are sorted lexicographically in ascending order. If multiple children have the same value for the specified child node, they are ordered lexicographically by key.
> - Objects come last and are sorted lexicographically by key in ascending order.
> 
> #### orderByKey
> 
> When using `orderByKey()` to sort your data, data is returned in ascending order by key.
> 
> - Children with a key that can be parsed as a 32-bit integer come first, sorios/read-and-write#listen_for_value_eventsted in ascending order.
> - Children with a string value as their key come next, sorted lexicographically in ascending order.
> 
> 
> #### orderByValue
> 
> When using `orderByValue()`, children are ordered by their value. The ordering criteria 
> are the same as in `orderByChild()`, except the value of the node is used instead of the 
> value of a specified child key.
> 


