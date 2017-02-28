
## Realtime Database

>
> Data is synced across all clients in realtime, and remains available when your app goes offline.
>
> The Firebase Realtime Database is a cloud-hosted database. Data is stored as JSON and synchronized 
> in realtime to every connected client. When you build cross-platform apps with our iOS, Android, 
> and JavaScript SDKs, all of your clients share one Realtime Database instance and automatically 
> receive updates with the newest data.
>


[![YOUTUBE](https://img.youtube.com/vi/U5aeM5dvUpA/0.jpg)](https://www.youtube.com/watch?v=U5aeM5dvUpA)

[https://firebase.google.com/docs/database/](https://firebase.google.com/docs/database/)


## Key capabilities

| | |
|---|---|
| Realtime   | Instead of typical HTTP requests, the Firebase Realtime Database uses data synchronization—every time data changes, any connected device receives that update within milliseconds. Provide collaborative and immersive experiences without thinking about networking code. |
| Offline | Firebase apps remain responsive even when offline because the Firebase Realtime Database SDK persists your data to disk. Once connectivity is reestablished, the client device receives any changes it missed, synchronizing it with the current server state. |
| Accessible from Client Devices | The Firebase Realtime Database can be accessed directly from a mobile device or web browser; there’s no need for an application server. Security and data validation are available through the Firebase Realtime Database Security Rules, expression-based rules that are executed when data is read or written. |


## Database Structure

All Firebase Realtime Database data is stored as JSON objects. You can think of 
the database as a cloud-hosted JSON tree. Unlike a SQL database, there are no 
tables or records. When you add data to the JSON tree, it becomes a node in the 
existing JSON structure with an associated key. You can provide your own keys, 
such as user IDs or semantic names, or they can be provided for you using push().

Best practices for data structure:

- [Avoid nesting data](https://firebase.google.com/docs/database/android/structure-data#avoid_nesting_data)
- [Flatten data structures](https://firebase.google.com/docs/database/android/structure-data#flatten_data_structures)
- [Create data that scales](https://firebase.google.com/docs/database/android/structure-data#fanout)

Read more about structuring your database [here](https://firebase.google.com/docs/database/android/structure-data)




