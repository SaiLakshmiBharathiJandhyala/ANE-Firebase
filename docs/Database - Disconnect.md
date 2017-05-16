
## On Disconnect

The `OnDisconnect` class is used to manage operations that will be run on the server when this client disconnects. 
It can be used to add or remove data based on a client's connection status. 
It is very useful in applications looking for 'presence' functionality. 


### Managing Presence

In realtime applications it is often useful to detect when clients connect and disconnect. 
For example, you may want to mark a user as 'offline' when their client disconnects.

Firebase Database clients provide simple primitives that you can use to write to the database 
when a client disconnects from the Firebase Database servers. These updates occur whether the 
client disconnects cleanly or not, so you can rely on them to clean up data even if a connection 
is dropped or a client crashes. All write operations, including setting, updating, and removing, 
can be performed upon a disconnection.

Here is a simple example of writing data upon disconnection by using the onDisconnect primitive:

```as3
var presenceRef:DatabaseReference = FirebaseDatabase.service.getReference( "disconnectmessage" );

// Write a string when this client loses connection
presenceRef.onDisconnect().setValue("I disconnected!");
```


### How onDisconnect Works

When you establish an `onDisconnect()` operation, the operation lives on the Firebase Realtime Database server. 
The server checks security to make sure the user can perform the write event requested, and informs the your 
app if it is invalid. The server then monitors the connection. If at any point the connection times out, or 
is actively closed by the Realtime Database client, the server checks security a second time (to make sure 
the operation is still valid) and then invokes the event.


### Cancel

An onDisconnect event can also be canceled by calling `cancel()`:

```as3
presenceRef.onDisconnect().cancel();
```
