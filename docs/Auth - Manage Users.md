
If a user has signed in successfully you can get their account data 
at any point with the `getCurrentUser` method.


```as3
var user:FirebaseUser = FirebaseAuth.service.getCurrentUser();
if (user != null)
{
	trace( "displayName: " + user.displayName );
	trace( "email:       " + user.email );
	trace( "photo Uri:   " + user.photoUri );

	// The user's ID, unique to the Firebase project. Do NOT use this value to
	// authenticate with your backend server, if you have one. Use
	// FirebaseUser.getToken() instead.
	trace( "identifier:  " + user.identifier );
}
else 
{
	trace( "Not signed in" );
}
```


## Provider specific profile information

To get the profile information retrieved from the sign-in providers linked to a user, 
use the Vector array of `UserInfo` objects.

```as3
var user:FirebaseUser = FirebaseAuth.service.getCurrentUser();
if (user != null)
{
	for each (var info:UserInfo in user.providers)
	{
		trace( "provider:    " + info.providerId );
		trace( "identifier:  " + info.identifier );
		trace( "displayName: " + info.displayName );
		trace( "email:       " + info.email );
	}
}
```

## Update profile

You can update a user's basic profile information—the user's display name and profile 
photo URL—with the `updateProfile` method. For example:

```as3
var request:UserProfileChangeRequest = new UserProfileChangeRequestBuilder()
		.setDisplayName( "Jane Q. User" )
		.setPhotoUri( "https://example.com/jane-q-user/profile.jpg" )
		.build();

FirebaseAuth.service.getCurrentUser().addEventListener( 
	FirebaseUserEvent.UPDATE_PROFILE_COMPLETE,
	updateProfile_completeHandler );

FirebaseAuth.service.getCurrentUser().updateProfile( request );
```

You can use the `FirebaseUserEvent.UPDATE_PROFILE_COMPLETE` event to listen for the completion
of the `updateProfile` method.

```as3
private function updateProfile_completeHandler( event:FirebaseUserEvent ):void
{
	trace( "updateProfile(): complete: "+event.success +"::"+event.message );
	FirebaseAuth.service.getCurrentUser().removeEventListener( 
		FirebaseUserEvent.UPDATE_PROFILE_COMPLETE,
		updateProfile_completeHandler );
}
```


## Update email

You can set a user's email address with the `updateEmail` method. For example:

```as3
FirebaseAuth.service.getCurrentUser().addEventListener( 
	FirebaseUserEvent.UPDATE_EMAIL_COMPLETE,
	updateEmail_completeHandler );

FirebaseAuth.service.getCurrentUser().updateEmail( "user@example.com" );
```

You can use the `FirebaseUserEvent.UPDATE_EMAIL_COMPLETE` event to listen for the completion
of the `updateEmail` method.

```as3
private function updateEmail_completeHandler( event:FirebaseUserEvent ):void
{
	trace( "updateEmail(): complete: "+event.success +"::"+event.message );
	FirebaseAuth.service.getCurrentUser().removeEventListener( 
		FirebaseUserEvent.UPDATE_EMAIL_COMPLETE,
		updateEmail_completeHandler );
}
```

>
> Important: To set a user's email address, the user must have signed in recently. 
> See Re-authenticate a user.
>


## Verification email

You can send an address verification email to a user with the `sendEmailVerification` method. For example:

```as3
FirebaseAuth.service.getCurrentUser().addEventListener(
	FirebaseUserEvent.SEND_EMAIL_VERIFICATION_COMPLETE,
	sendEmailVerification_completeHandler );

FirebaseAuth.service.getCurrentUser().sendEmailVerification();
```

```as3
private function sendEmailVerification_completeHandler( event:FirebaseUserEvent ):void
{
	log( "sendEmailVerification(): complete: " + event.success +"::"+event.message );
	FirebaseAuth.service.getCurrentUser().removeEventListener(
		FirebaseUserEvent.SEND_EMAIL_VERIFICATION_COMPLETE,
		sendEmailVerification_completeHandler );
}
```

You can customize the email template that is used in Authentication section of the 
[Firebase console](https://firebase.google.com/console/), on the Email Templates page. 
See [Email Templates](https://support.google.com/firebase/answer/7000714) in Firebase Help Center.


## Update Password

You can set a user's password with the `updatePassword` method. For example:

```as3
FirebaseAuth.service.getCurrentUser().addEventListener( 
	FirebaseUserEvent.UPDATE_PASSWORD_COMPLETE,
	updatePassword_completeHandler );

FirebaseAuth.service.getCurrentUser().updatePassword( "SOME-SECURE-PASSWORD" );
```

You can use the `FirebaseUserEvent.UPDATE_PASSWORD_COMPLETE` event to listen for the completion
of the `updatePassword` method.

```as3
private function updatePassword_completeHandler( event:FirebaseUserEvent ):void
{
	trace( "updatePassword(): complete: "+event.success +"::"+event.message );
	FirebaseAuth.service.getCurrentUser().removeEventListener( 
		FirebaseUserEvent.UPDATE_PASSWORD_COMPLETE,
		updatePassword_completeHandler );
}
```

>
> Important: To set a user's email address, the user must have signed in recently. 
> See Re-authenticate a user.
>


## Send a password reset email

You can send a password reset email to a user with the sendPasswordResetEmail method. For example:



You can customize the email template that is used in Authentication section of the 
[Firebase console](https://firebase.google.com/console/), on the Email Templates page. 
See [Email Templates](https://support.google.com/firebase/answer/7000714) in Firebase Help Center.

You can also send password rest emails from the Firebase console.


## Delete a user

You can delete a user account with the delete method. For example:

```as3
FirebaseAuth.service.getCurrentUser().addEventListener( 
	FirebaseUserEvent.DELETE_USER_COMPLETE, 
	deleteUser_completeHandler );

FirebaseAuth.service.getCurrentUser().deleteUser();
```

You can use the `FirebaseUserEvent.DELETE_USER_COMPLETE` event to listen for the completion of this method.

```as3
private function deleteUser_completeHandler( event:FirebaseUserEvent ):void
{
	trace( "deleteUser(): complete: " + event.success +"::"+event.message );
}
```

Once deleted `getCurrentUser()` will return `null` and your user will be signed out. 


## Re-authenticate a user

Some security-sensitive actions—such as deleting an account, setting a primary email address, 
and changing a password—require that the user has recently signed in.
If you perform one of these actions, and the user signed in too long ago, 
the action fails (`event.success` will be `false`).

When this happens, re-authenticate the user by getting new sign-in credentials 
from the user and passing the credentials to `reauthenticate`. 

For example:

```as3
var credential:AuthCredential = EmailAuthProvider.getEmailAuthCredential( "user@example.com", "password1234" );

FirebaseAuth.service.getCurrentUser().addEventListener( 
	FirebaseUserEvent.REAUTHENTICATE_COMPLETE, 
	reauthenticate_completeHandler );

FirebaseAuth.service.getCurrentUser().reauthenticate( credential );
```

You can use the `FirebaseUserEvent.REAUTHENTICATE_COMPLETE` event to listen for the completion of this method.

```as3
private function reauthenticate_completeHandler( event:FirebaseUserEvent ):void
{
	FirebaseAuth.service.getCurrentUser().removeEventListener( 
		FirebaseUserEvent.REAUTHENTICATE_COMPLETE, 
		reauthenticate_completeHandler );
}
```


## User Token

You may wish to authenticate a user on your server for actions in Firebase from your application. 
To do this you'll need the users authentication token.

```as3
FirebaseAuth.service.getCurrentUser().addEventListener( 
	FirebaseUserEvent.GET_TOKEN_COMPLETE,
	getToken_completeHandler );

FirebaseAuth.service.getCurrentUser().getToken( true );
```

```as3
private function getToken_completeHandler(event:FirebaseUserEvent ):void
{
	if (event.success)
	{
		// Success means the event has a valid token in event.data
		trace( event.data );
	}

	FirebaseAuth.service.getCurrentUser().removeEventListener( 
		FirebaseUserEvent.GET_TOKEN_COMPLETE,
		getToken_completeHandler );
}
```


