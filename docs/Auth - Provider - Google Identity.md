
You can let your users authenticate with Firebase using their Google Accounts by integrating Google Sign-In into your app.


## Before you begin

- Ensure you have setup Firebase in your application
- Enable Google Sign-In in the Firebase console:
  - In the [Firebase console](https://console.firebase.google.com/), open the **Auth** section.
  - On the **Sign in method** tab, enable the **Google** sign-in method and click **Save**.


## Authenticate with Google

In order to sign in using Google accounts you will need to integrate **Google Sign-In**. 
You can do this using the [Google Identity](https://airnativeextensions.com/extension/com.distriqt.GoogleIdentity) extension.
The following guide uses this ANE however you can use any method you currently have to attain the id token.

Firstly, integrate Google Sign-In in your application by following the steps outlined in the Google Identity ANE.

You must ensure that you request the id token when setting up the extension, by setting `requestIdToken` to `true`:

```as3
var options:GoogleIdentityOptions = new GoogleIdentityOptionsBuilder()
	.requestIdToken()
	.setIOSClientID( Config.clientID_iOS )
	.setServerClientID( Config.serverClientID )
	.build();

GoogleIdentity.service.setup( options );
```

Then call sign in to authenticate your user using their Google account:

```as3
GoogleIdentity.service.addEventListener( GoogleIdentityEvent.SIGN_IN, googleIdentity_signInHandler );
					
GoogleIdentity.service.signIn();
```


## Authenticate with Firebase

When sign in completes you'll have access to the id token and access token. 
You use these to construct an `AuthCredential` that you can pass to the `FirebaseAuth` 
`signInWithCredential` function.

To create an `AuthCredential` for Google use the `GoogleAuthProvider.getCredential` method:

```as3
var credential:AuthCredential = GoogleAuthProvider.getCredential( idToken, accessToken );
```

Then pass this to `signInWithCredential`:

```as3
FirebaseAuth.service.signInWithCredential( credential );
```

The `signInWithCredential` method will return the `FirebaseAuthEvent.SIGNIN_WITH_CREDENTIAL_COMPLETE` event.


For example on the `GoogleIdentityEvent.SIGN_IN` event handler:

```as3
function googleIdentity_signInHandler( event:GoogleIdentityEvent ):void
{
	// Have google sign in, lets use this to sign into Firebase
	var idToken:String = event.user.authentication.idToken;
	var accessToken:String = event.user.authentication.accessToken; // probably will be null

	// Create AuthCredential	
	var credential:AuthCredential = GoogleAuthProvider.getCredential( idToken, accessToken );
	
	// Start sign-in to Firebase
	FirebaseAuth.service.addEventListener( FirebaseAuthEvent.SIGNIN_WITH_CREDENTIAL_COMPLETE, signInWithCredential_completeHandler );
	FirebaseAuth.service.signInWithCredential( credential );
}
```

You can then use the `SIGNIN_WITH_CREDENTIAL_COMPLETE` event to process the success sign-in 
which will have the `FirebaseUser` with a linked Google provider.


## Next steps

After a user signs in for the first time, a new user account is created and linked to the credentials—that is, the user name and password, phone number, or auth provider information—the user signed in with. This new account is stored as part of your Firebase project, and can be used to identify a user across every app in your project, regardless of how the user signs in.

In your apps, you can get the user's basic profile information from the `FirebaseUser` object. 
In your Firebase Realtime Database and Cloud Storage Security Rules, you can get the signed-in 
user's unique user ID from the auth variable, and use it to control what data a user can access.
You can allow users to sign in to your app using multiple authentication providers by linking 
auth provider credentials to an existing user account.

To sign out a user, call `signOut`:

```as3
FirebaseAuth.service.signOut();
```