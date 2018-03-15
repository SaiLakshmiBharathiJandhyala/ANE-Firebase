

## Required Extensions

You should have been through the setup of the Firebase Core before attempting to proceed with Authentication.

Make sure you have added all the extensions required for the Firebase Core extension as outlined ![](here|Core - Add the extensions).


### Firebase Auth

The only required additional ANE is the Auth ANE located in this repository:

- `com.distriqt.firebase.Auth` : https://github.com/distriqt/ANE-Firebase

This ANE contains all the required libraries for the main Firebase authentication functionality,
however some of the authentication providers (such as Facebook and Google) may require additional
extensions. We list these in the documentation in each of the specific providers so you only 
include the required extensions for your situation.



## Extension IDs

The following should be added to your `extensions` node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>com.distriqt.Firebase</extensionID>
    <extensionID>com.distriqt.firebase.Auth</extensionID>
	
    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.androidsupport.V4</extensionID>
    <extensionID>com.distriqt.playservices.Base</extensionID>

	<extensionID>com.distriqt.CustomResources</extensionID>
</extensions>
```



---

## Android Manifest Additions

No additional manifest additions are required


## iOS Info Additions

No additional additions are required. There is an exception with Phone Authentication
and the details of these additions are in the documentation for that method.

