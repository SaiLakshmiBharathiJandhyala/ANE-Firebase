
## Write data offline

If a client loses its network connection, your app will continue functioning correctly.

Every client connected to a Firebase database maintains its own internal version of any 
active data. When data is written, it's written to this local version first. The Firebase 
client then synchronizes that data with the remote database servers and with other clients 
on a "best-effort" basis.

As a result, all writes to the database trigger local events immediately, before any data 
is written to the server. This means your app remains responsive regardless of network 
latency or connectivity.

Once connectivity is reestablished, your app receives the appropriate set of events so 
that the client syncs with the current server state, without having to write any custom code.


## Enabling Offline Capabilities

In addition, Firebase provides tools for persisting data locally, managing presence, 
and handling latency.

Firebase apps automatically handle temporary network interruptions. Cached data is 
available while offline and Firebase resends any writes when network connectivity is 
restored.

When you enable disk persistence, your app writes the data locally to the device so 
your app can maintain state while offline, even if the user or operating system restarts 
the app.

You can enable disk persistence with just one line of code.

```as3
FirebaseDatabase.service.setPersistenceEnabled( true );
```

By enabling persistence, any data that the Firebase Realtime Database client would 
sync while online persists to disk and is available offline, even when the user or 
operating system restarts the app. This means your app works as it would online by 
using the local data stored in the cache. Listener callbacks will continue to fire 
for local updates.

The Firebase Realtime Database client automatically keeps a queue of all write 
operations that are performed while your app is offline. When persistence is 
enabled, this queue is also persisted to disk so all of your writes are available 
when the user or operating system restarts the app. When the app regains connectivity, 
all of the operations are sent to the Firebase Realtime Database server.

If your app uses Firebase Authentication, the Firebase Realtime Database client 
persists the user's authentication token across app restarts. If the auth token 
expires while your app is offline, the client pauses write operations until your 
app re-authenticates the user, otherwise the write operations might fail due to 
security rules.


### Keeping Data Fresh

The Firebase Realtime Database synchronizes and stores a local copy of the data 
for active listeners. In addition, you can keep specific locations in sync.

```as3
var ref:DatabaseReference = FirebaseDatabase.service.getReference("scores");
ref.keepSynced(true);
```

The Firebase Realtime Database client automatically downloads the data at these 
locations and keeps it in sync even if the reference has no active listeners. 
You can turn synchronization back off with the following line of code.

```as3
ref.keepSynced(false);
```

By default, 10MB of previously synced data is cached. This should be enough for 
most applications. If the cache outgrows its configured size, the Firebase Realtime 
Database purges data that has been used least recently. Data that is kept in sync 
is not purged from the cache.




