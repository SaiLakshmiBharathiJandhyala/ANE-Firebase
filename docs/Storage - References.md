
## Storage Reference

Your files are stored in a Firebase Storage bucket. The files in this bucket are 
presented in a hierarchical structure, just like the file system on your local 
hard disk, or the data in the Firebase Realtime Database. 

By creating a reference to a file, your app gains access to it. These references 
can then be used to upload or download data, get or update metadata or delete 
the file. A reference can either point to a specific file or to a higher level 
in the hierarchy.

If you've used the Firebase Realtime Database, these paths should seem very 
familiar to you. However, your file data is stored in Google Cloud Storage 
**not** in the Realtime Database.


## Create a Reference

Create a reference to upload, download, or delete a file, or to get or update 
its metadata. A reference can be thought of as a pointer to a file in the cloud. 
References are lightweight, so you can create as many as you need. 
They are also reusable for multiple operations.

References are created using the `FirebaseStorage.service` singleton instance
and calling either `getReference` or `getReferenceFromUrl`.

For example to get a reference to the root of your storage tree:

```as3
var rootReference:StorageReference = FirebaseStorage.service.getReference();
```

Or you can pass a path to get a location lower in the tree:

```as3
var reference:StorageReference = FirebaseStorage.service.getReference( "images/test.png" );
```

Or you can use `child` to navigate through your tree, the following is the equivalent of the above:

```as3 
var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test.png" );
```


## Navigate with References

You can also use the `getParent()` and `getRoot()` methods to navigate up in our file hierarchy. 
`getParent()` navigates up one level, while `getRoot()` navigates all the way to the top.

```as3
// Parent allows us to move our reference to point to
// imagesRef now points to 'images'
var parentReference:StorageReference = reference.getParent();

// Root allows us to move all the way back to the top of our bucket
// rootRef now points to the root
var rootReference:StorageReference = reference.getRoot();
```

Along with `child()` these can all be chained together:

```as3
var earthReference:StorageReference = reference.getParent().child( "earth.jpg" );
```


## Reference Properties

You can inspect references to better understand the files they point to using 
the `getPath()`, `getName()`, and `getBucket()` methods. These methods get the 
file's full path, name and bucket.

```as3
// Reference's path is: "images/space.jpg"
// This is analogous to a file path on disk
reference.getPath();

// Reference's name is the last segment of the full path: "space.jpg"
// This is analogous to the file name
reference.getName();

// Reference's bucket is the name of the storage bucket that the files are stored in
reference.getBucket();
```


