
Cloud Firestore supports offline data persistence. This feature caches a copy of the Cloud Firestore data that your app is actively using, so your app can access the data when the device is offline. You can write, read, listen to, and query the cached data. When the device comes back online, Cloud Firestore synchronizes any local changes made by your app to the data stored remotely in Cloud Firestore.

> Note: Offline persistence is supported only in Android, iOS, and web apps.

To use offline persistence, you don't need to make any changes to the code that you use to access Cloud Firestore data. With offline persistence enabled, the Cloud Firestore client library automatically manages online and offline data access and synchronizes local data when the device is back online.


## Configure offline persistence

When you initialize Cloud Firestore, you can enable or disable offline persistence:

- For Android and iOS, offline persistence is enabled by default. To disable persistence, set the `isPersistenceEnabled` option to `false`.


```as3
var settings:FirebaseFirestoreSettings = FirebaseFirestore.service.getFirestoreSettings();
settings.isPersistenceEnabled = false;

FirebaseFirestore.service.setFirestoreSettings( settings );
```
