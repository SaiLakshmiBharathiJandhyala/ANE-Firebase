
## Delete Data 

The simplest way to delete data is to call `removeValue()` on a reference to 
the location of that data.

You can also delete by specifying null as the value for another write operation 
such as `setValue()` or `updateChildren()`. You can use this technique with 
`updateChildren()` to delete multiple children in a single API call.

