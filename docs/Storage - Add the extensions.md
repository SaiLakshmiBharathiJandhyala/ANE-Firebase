

## Required Extensions

You should have been through the setup of the Firebase Core before attempting to proceed with Storage.

Make sure you have added all the extensions required for the Firebase Core extension as outlined ![](here|Core - Add the extensions).


### Firebase Storage

The only required additional ANE is the Auth ANE located in this repository:

- `com.distriqt.firebase.Storage` : https://github.com/distriqt/ANE-Firebase

This ANE contains all the required libraries for the main Firebase Storage functionality.


## Extension IDs

The following should be added to your `extensions` node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>com.distriqt.Firebase</extensionID>
    <extensionID>com.distriqt.firebase.Storage</extensionID>
	
    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.androidsupport.V4</extensionID>
    <extensionID>com.distriqt.playservices.Base</extensionID>

	<extensionID>com.distriqt.CustomResources</extensionID>
</extensions>
```


---

## Android Manifest Additions

No additional manifest additions are required



