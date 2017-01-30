

## Get a DatabaseReference

To read or write data from the database, you need an instance of `DatabaseReference`:

```as3
var database:DatabaseReference;

database = FirebaseDatabase.service.getReference();
```

## Write Data

### Basic write operations

For basic write operations, you can use `setValue()` to save data to a specified 
reference, replacing any existing data at that path. You can use this method to:

- Pass types that correspond to the available types as follows: 
  - `String`
  - `Number`
  - `Boolean`
  - `Object`
  - `Array`

For example you can add a user with `setValue` as follows:

```as3 
var user:Object = { 
	username: "someuser",
	email: "user@test.com"
}

database.child("users").child(userId).setValue(user);
```

Using `setValue` will overwrite any data at the specified location, including any 
child nodes. However, you can still update a child without rewriting the entire object.
If you want to allow users to update their profiles you could update the username as follows:

```as3
database.child("users").child(userId).child("username").setValue(name);
```


### Updating Children

To simultaneously write to specific children of a node without overwriting other 
child nodes, use the `updateChildren()` method.

When calling `updateChildren()`, you can update lower-level child values by 
specifying a path for the key. 

To update children we recommend using the `UpdateChildrenBuilder`. This class
helps construct the correct parameters to pass to the `updateChildren` function.

It's usage is quite straight forward, simply construct an instance of the builder, 
then call `update` for each value update you intend to perform passing the `path` to 
the value and the new value.

```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );

ref.updateChildren( 
	new UpdateChildrenBuilder()
		.update( "/children_test/numericValue", 100 )
		.update( "/children_test/stringValue", "some string" )
		.build()
);
```




