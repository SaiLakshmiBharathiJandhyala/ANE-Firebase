

## Required Extensions

You should have been through the setup of the Firebase Core before attempting to proceed with Cloud Firestore.

Make sure you have added all the extensions required for the Firebase Core extension as outlined ![](here|Core - Add the extensions).


### Cloud Firestore

Usage of the Cloud Firestore requires adding the Firestore ANE along with the Database ANE located in this repository:

https://github.com/distriqt/ANE-Firebase

- [`com.distriqt.firebase.Firestore`](https://github.com/distriqt/ANE-Firebase/raw/master/lib/com.distriqt.firebase.Firestore.ane)
- [`com.distriqt.firebase.Database`](https://github.com/distriqt/ANE-Firebase/raw/master/lib/com.distriqt.firebase.Database.ane)


These ANEs contain the required libraries for the Cloud Firestore functionality.



## Extension IDs

The following should be added to your `extensions` node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>com.distriqt.Firebase</extensionID>
    <extensionID>com.distriqt.firebase.Database</extensionID>
    <extensionID>com.distriqt.firebase.Firestore</extensionID>
	
    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.androidsupport.V4</extensionID>
    <extensionID>com.distriqt.playservices.Base</extensionID>

	<extensionID>com.distriqt.CustomResources</extensionID>
</extensions>
```


---

## Android Manifest Additions

No additional manifest additions are required


---

## Create a Cloud Firestore project

1. Open the [Firebase Console](https://console.firebase.google.com/) and create a new project.

2. In the Database section, click the Get Started button for Cloud Firestore.

3. Select a starting mode for your Cloud Firestore Security Rules:
  - **Test mode**: Good for getting started with the mobile and web client libraries, but allows anyone to read and overwrite your data. After testing, make sure to see the [Secure your data](https://firebase.google.com/docs/firestore/quickstart#secure_your_data) section. 
  - **Locked mode**: Denies all reads and writes from mobile and web clients. Your authenticated application servers (C#, Go, Java, Node.js, PHP, Python, or Ruby) can still access your database.

4. Click **Enable**.


