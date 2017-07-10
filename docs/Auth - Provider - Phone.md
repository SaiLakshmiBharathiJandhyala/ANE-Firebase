
You can use Firebase Authentication to sign in a user by sending an SMS message to the user's phone. 
The user signs in using a one-time code contained in the SMS message.



### Security Concerns

Authentication using only a phone number, while convenient, is less secure than the other available methods, because possession of a phone number can be easily transferred between users. Also, on devices with multiple user profiles, any user that can receive SMS messages can sign in to an account using the device's phone number.

If you use phone number based sign-in in your app, you should offer it alongside more secure sign-in methods, and inform users of the security tradeoffs of using phone number sign-in.




## Enable Phone Number sign-in

To sign in users by SMS, you must first enable the Phone Number sign-in method for your Firebase project:

1. In the [Firebase console](https://console.firebase.google.com/), open the **Authentication** section.
2. On the **Sign-in Method** page, enable the **Phone Number** sign-in method.
3. Ensure you have setup your APNs certificates for iOS
4. Add the application descriptor additions below


### iOS Info Additions and Entitlements

With iOS your app must be able to receive APNs notifications from Firebase.
When you sign in a user with their phone number for the first time on a device, 
Firebase Authentication sends a silent push notification to the device to verify 
that the phone number sign-in request comes from your app. (For this reason, phone 
number sign-in cannot be used on a simulator.)

So it's important that you've been through the steps to add your APNs certificates
to your application in the Firebase console.

If you are using FCM or Push Notifications you will already have already added these
to your application descriptor however if you aren't you need to add the following
tags to your iPhone Entitlements section in your application descriptor.

#### Development Example

```xml
<InfoAdditions><![CDATA[
)></InfoAdditions>
<requestedDisplayResolution>high</requestedDisplayResolution>
<Entitlements><![CDATA[
	
	<key>get-task-allow</key>
	<true/>
	<key>aps-environment</key>
	<string>development</string>
	
	<key>application-identifier</key>
	<string>X5LW23Q6CJ.com.distriqt.test</string>
	<key>keychain-access-groups</key>
	<array>
		<string>X5LW23Q6CJ.*</string>
	</array>
	
)></Entitlements>
```

#### Production Example

```xml
<InfoAdditions><![CDATA[
)></InfoAdditions>
<requestedDisplayResolution>high</requestedDisplayResolution>
<Entitlements><![CDATA[
	
	<key>aps-environment</key>
	<string>production</string>
	
	<key>application-identifier</key>
	<string>X5LW23Q6CJ.com.distriqt.test</string>
	<key>keychain-access-groups</key>
	<array>
		<string>X5LW23Q6CJ.*</string>
	</array>
	
)></Entitlements>
```




## Send a Verification Code

To initiate phone number sign-in, present the user an interface that prompts them to type their phone number. 
Legal requirements vary, but as a best practice and to set expectations for your users, you should inform them 
that if they use phone sign-in, they might receive an SMS message for verification and standard rates apply.

Then, pass their phone number to the PhoneAuthProvider.verifyPhoneNumber method to request that Firebase 
verify the user's phone number. For example:

```as3
FirebaseAuth.service.verifyPhoneNumber( phoneNumber, 60 );
```

This call will dispatch one of 3 potential events from `FirebaseAuthEvent`:

- `VERIFY_PHONE_NUMBER_FAILED`: An error occurred. You can check the event for more details
- `VERIFY_PHONE_NUMBER_CODE_SENT`: The SMS code has been sent to the specified phone number - you should ask the user to enter this number as below
- `SIGNIN_WITH_CREDENTIAL_COMPLETE`: It is possible at this point that the authentication completes due to either:
  - **Instant verification**: In some cases the phone number can be instantly verified without needing to send or enter a verification code.
  - **Auto-retrieval**: On some devices Google Play services can automatically detect the incoming verification SMS and perform verificaiton without user action




## Create a Credential 

After the user enters the verification code that Firebase sent to the user's phone, create a `PhoneAuthCredential` object, using the verification code and the verification ID that was returned.

To create a credential call `PhoneAuthProvider.getCredential`:

```as3
var credential:PhoneAuthCredential = PhoneAuthProvider.getCredential( verificationId, code );
```


>
> To prevent abuse, Firebase enforces a limit on the number of SMS messages that can be sent to a single 
> phone number within a period of time. If you exceed this limit, phone number verification requests might 
> be throttled. If you encounter this issue during development, use a different phone number for testing, 
> or try the request again later.
>


## Sign In

After you get a PhoneAuthCredential object you can call:

```as3
FirebaseAuth.service.signInWithCredential( credential );
```

This will dispatch a `FirebaseAuthEvent.SIGNIN_WITH_CREDENTIAL_COMPLETE` event when complete 
and you can check the value of `success` to see whether it succeeded. 



## Next 

After a user signs in for the first time, a new user account is created and linked to the credentials — 
that is, the user name and password, phone number, or auth provider information—the user signed in with. 
This new account is stored as part of your Firebase project, and can be used to identify a user across 
every app in your project, regardless of how the user signs in.




## Example

The following example shows the complete sign in process, using a simple text input dialog 
(from the Dialog ANE) to gather the SMS code from the user.


```as3
FirebaseAuth.service.addEventListener( FirebaseAuthEvent.VERIFY_PHONE_NUMBER_FAILED, verifyPhoneNumber_failedHandler );
FirebaseAuth.service.addEventListener( FirebaseAuthEvent.VERIFY_PHONE_NUMBER_CODE_SENT, verifyPhoneNumber_codeSentHandler );
FirebaseAuth.service.addEventListener( FirebaseAuthEvent.SIGNIN_WITH_CREDENTIAL_COMPLETE, signInWithPhoneNumber_completeHandler );

FirebaseAuth.service.verifyPhoneNumber( phoneNumber, 60 );

var verificationId:String;

function verifyPhoneNumber_failedHandler( event:FirebaseAuthEvent ):void 
{
	// An error occurred
}

function verifyPhoneNumber_codeSentHandler( event:FirebaseAuthEvent ):void 
{
	//  Here we should save the verification id somewhere persistent
	//  in case the application crashes or something else occurs while
	//  the user is getting the sms code from their message application.
	//
	//  Then we should display an input for the sms code
	
	verificationId = event.verificationId;

	//
	//  Then we should display an input for the sms code

	//	Here we use a simple dialog from the Dialog ANE:
	var dialogView:DialogView = Dialog.service.create(
			new AlertBuilder(true)
					.setTitle("Enter SMS Code")
					.addTextField( "", "SMS Code" )
					.addOption("OK", DialogAction.STYLE_POSITIVE)
					.build()
	);
	dialogView.addEventListener( DialogViewEvent.CLOSED, dialogClosedHandler );
	dialogView.show();
}

function dialogClosedHandler( event:DialogViewEvent ):void
{
	var smsCode:String = event.values[0];

	// Start the sign in with the user entered SMS code
	signInWithPhoneNumber( verificationId, smsCode );
}


function signInWithPhoneNumber( verificationId:String, smsCode:String ):void
{
	var credential:PhoneAuthCredential = PhoneAuthProvider.getCredential( verificationId, smsCode );
	FirebaseAuth.service.signInWithCredential( credential );
}


function signInWithPhoneNumber_completeHandler( event:FirebaseAuthEvent ):void 
{
	trace( "signInWithPhoneNumber: complete: " + event.success );

	if (event.success)
	{
		// You will now have a valid user
		var user:FirebaseUser = FirebaseAuth.service.getCurrentUser();
	}
}
```




