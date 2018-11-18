## Delete documents

To delete a document, use the `deleteDocument()` method:


```as3
FirebaseFirestore.service.collection("cities").document("DC")
					.deleteDocument();
```

When you delete a document, Cloud Firestore does not automatically delete the documents within its subcollections. You can still access the subcollection documents by reference. For example, you can access the document at path /mycoll/mydoc/mysubcoll/mysubdoc even if you delete the ancestor document at /mycoll/mydoc.

Non-existent ancestor documents appear in the console, but they do not appear in query results and snapshots.

If you want to delete a document and all the documents within its subcollections, you must do so manually. For more information, see Delete Collections.


## Delete fields

To delete specific fields from a document, use the `FieldValue.deleteValue()` method when you update a document:

```as3
var document:DocumentReference = FirebaseFirestore.service.collection("cities").document("DC");

var updates:Object = {
	captial: FieldValue.deleteValue()
};

document.update( updates );
```



## Delete collections

To delete an entire collection or subcollection in Cloud Firestore, retrieve all the documents within the collection or subcollection and delete them. If you have larger collections, you may want to delete the documents in smaller batches to avoid out-of-memory errors. Repeat the process until you've deleted the entire collection or subcollection.

Deleting a collection requires coordinating an unbounded number of individual delete requests. If you need to delete entire collections, do so only from a trusted server environment. While it is possible to delete a collection from a mobile/web client, doing so has negative security and performance implications.

To learn more about one recommended approach to deleting collections in production, see [Deleting Collections and Subcollections](https://firebase.google.com/docs/firestore/solutions/delete-collections).



