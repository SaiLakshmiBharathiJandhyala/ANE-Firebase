
With query cursors in Cloud Firestore, you can split data returned by a query into batches according to the parameters you define in your query.

Query cursors define the start and end points for a query, allowing you to:

- Return a subset of the data.
- Paginate query results.

However, to define a specific range for a query, you should use the where() method described in ![](Simple Queries|Firestore - Perform simple and compound queries).


## Add a simple cursor to a query

Use the `startAt()` or `startAfter()` methods to define the start point for a query. The `startAt()` method includes the start point, while the `startAfter()` method excludes it.

For example, if you use `startAt(A)` in a query, it returns the entire alphabet. If you use `startAfter(A)` instead, it returns B-Z.

```as3
// Get all cities with a population >= 1,000,000, ordered by population,
db.collection("cities")
        .orderBy("population")
        .startAt(1000000);
```

Similarly, use the `endAt()` or `endBefore()` methods to define an end point for your query results.

```as3
// Get all cities with a population <= 1,000,000, ordered by population,
db.collection("cities")
        .orderBy("population")
        .endAt(1000000);
```



## Paginate a query

> **NOT YET AVAILABLE** Coming soon

Paginate queries by combining query cursors with the `limit()` method. For example, use the last document in a batch as the start of a cursor for the next batch.


```as3
var first:Query = FirebaseFirestore.service.collection("users")
        .orderBy("born")
        .limit(5);

first.query()
        .addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
        {
            // Get the last visible document
            var lastVisible:DocumentSnapshot = snapshot.getDocuments()[ snapshot.size - 1 ];
            
            var next:Query = FirebaseFirestore.service.collection("users")
                    .orderBy("born")
                    .startAtSnapshot(lastVisible)
                    .limit(5);
            
            // Use the query for pagination
            // ...
        });
```



## Set multiple cursor conditions

To add more granularity to your cursor's start or end point, you can specify multiple conditions in the cursor clause. This is particularly useful if your data set includes fields where the first condition in a cursor clause would return multiple results. Use multiple conditions to further specify the start or end point and reduce ambiguity.

For example, in a data set containing all the cities named "Springfield" in the United States, there would be multiple start points for a query set to start at "Springfield":


| Cities | |
| --- | --- |
| Name | State |
| Springfield | Massachusetts |
| Springfield | Missouri |
| Springfield | Wisconsin |


To start at a specific Springfield, you could add the state as a secondary condition in your cursor clause.


```as3
// Will return all Springfields
FirebaseFirestore.service.collection("cities")
        .orderBy("name")
        .orderBy("state")
        .startAt("Springfield");
```

```as3
// Will return "Springfield, Missouri" and "Springfield, Wisconsin"
FirebaseFirestore.service.collection("cities")
        .orderBy("name")
        .orderBy("state")
        .startAt("Springfield", "Missouri");
```



