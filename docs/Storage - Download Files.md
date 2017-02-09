
## Download Files 

To download a file, first create a Firebase Storage reference to the file you want to download.

```as3
var reference:StorageReference = FirebaseStorage.service.getReference().child( "downloads/example.png" );
```


## Download Files

Once you have a reference, you can download files from Firebase Storage by calling 
the `getBytes()` or if you prefer to download the file with another library, 
you can get a download URL with `getDownloadUrl()`.


