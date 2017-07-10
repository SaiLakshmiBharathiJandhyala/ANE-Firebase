
You can allow users to sign in to your app using multiple authentication providers by 
linking auth provider credentials to an existing user account. Users are identifiable 
by the same Firebase user ID regardless of the authentication provider they used to 
sign in. For example, a user who signed in with a password can link a Google account 
and sign in with either method in the future. Or, an anonymous user can link a Facebook 
account and then, later, sign in with Facebook to continue using your app.

## Link Auth Provider

To link auth provider credentials to an existing user account, firstly ensure you have 
a user signed into Firebase, then:

- Sign in the user using any authentication provider or method;
- Complete the sign-in flow for the new authentication provider up to, but not including, calling one of the FirebaseAuth.signInWith methods. For example, get the user's Google ID token, Facebook access token, or email and password.
- Get a AuthCredential for the new authentication provider:
- Instead of the `signInWith` method you would normally call, pass the `AuthCredential` to the signed-in user's `linkWithCredential` method:

```as3
var credential:AuthCredential = EmailAuthProvider.getEmailAuthCredential( Config.email, Config.password );

FirebaseAuth.service.getCurrentUser().addEventListener( 
	FirebaseUserEvent.LINK_WITH_CREDENTIAL_COMPLETE, 
	linkWithCredential_completeHandler );

FirebaseAuth.service.getCurrentUser().linkWithCredential( credential );
``` 

If the call to `linkWithCredential` succeeds, the user can now sign in using any linked authentication provider and access the same Firebase data.


## Unlink an auth provider from a user account

You can unlink an auth provider from an account, so that the user can no longer sign in with that provider.

To unlink an auth provider from a user account, pass the provider ID to the unlink method. 
You can get the provider IDs of the auth providers linked to a user by using the `providers` array of the `FirebaseUser`.

```as3
FirebaseAuth.service.getCurrentUser().addEventListener(
	FirebaseUserEvent.UNLINK_COMPLETE,
	unlinkCompleteHandler );

FirebaseAuth.service.getCurrentUser().unlink( providerId );
```

