
Cloud Firestore provides powerful query functionality for specifying which documents you want to retrieve from a collection. These queries can also be used with either `query()` or `addSnapshotListener()`, as described in ![](Get Data|Firestore - Get data) and ![](Get Realtime Updates|Firestore - Get realtime updates).


## Simple queries

The following query returns all cities with state `CA`:

```as3
// Create a reference to the cities collection
var citiesRef:CollectionReference = FirebaseFirestore.service.collection("cities");

// Create a query against the collection.
var query:Query = citiesRef.whereEqualTo("state", "CA");
```

The following query returns all the capital cities:


```as3
var query:Query = FirebaseFirestore.service.collection("cities").whereEqualTo("capital", true);
```

There are several variants of the `where...` method each take two parameters, a field to filter on and a value.

Some example filters:

```as3
citiesRef.whereEqualTo("state", "CA");
citiesRef.whereLessThan("population", 100000);
citiesRef.whereGreaterThanOrEqualTo("name", "San Francisco");
```


## Compound queries

You can also chain multiple `where...` methods to create more specific queries (logical AND). However, to combine the equality operator (==) with a range or array-contains clause (<, <=, >, >=, or array_contains), make sure to create a [composite index](https://firebase.google.com/docs/firestore/query-data/indexing).


```as3
citiesRef.whereEqualTo("state", "CO").whereEqualTo("name", "Denver");
citiesRef.whereEqualTo("state", "CA").whereLessThan("population", 1000000);
```

You can only perform range comparisons (<, <=, >, >=) on a single field.

**Valid**: Range filters on only one field

```as3
citiesRef.whereGreaterThanOrEqualTo("state", "CA")
        .whereLessThanOrEqualTo("state", "IN");
citiesRef.whereEqualTo("state", "CA")
        .whereGreaterThan("population", 1000000);
```

**Invalid**: Range filters on different fields:

```as3
citiesRef.whereGreaterThanOrEqualTo("state", "CA").whereGreaterThan("population", 100000);
```


## Query limitations

Cloud Firestore does not support the following types of queries:

- Queries with range filters on different fields, as described in the previous section.
- Single queries across multiple collections or subcollections. Each query runs against a single collection of documents. For more information about how your data structure affects your queries, see Choose a Data Structure.
- Logical OR queries. In this case, you should create a separate query for each OR condition and merge the query results in your app.
- Queries with a != clause. In this case, you should split the query into a greater-than query and a less-than query. For example, although the query clause where("age", "!=", "30") is not supported, you can get the same result set by combining two queries, one with the clause where("age", "<", "30") and one with the clause where("age", ">", 30).



