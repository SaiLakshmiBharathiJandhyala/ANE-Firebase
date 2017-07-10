
You can integrate Firebase Authentication with a custom authentication system by 
modifying your authentication server to produce custom signed tokens when a user 
successfully signs in. Your app receives this token and uses it to authenticate with Firebase.

## Before you begin

- Get your project's server keys:
  - Go to the [Service Accounts](https://console.firebase.google.com/project/_/settings/serviceaccounts/adminsdk) page in your project's settings.
  - Click *Generate New Private Key* at the bottom of the *Firebase Admin SDK* section of the *Service Accounts* page.
  - The new service account's public/private key pair is automatically saved on your computer. Copy this file to your authentication server.


## Authenticate 

When users sign in to your app, send their sign-in credentials (for example, their username and password) 
to your authentication server. Your server checks the credentials and returns a [custom token](https://firebase.google.com/docs/auth/admin/create-custom-tokens) 
if they are valid.

After you receive the custom token from your authentication server, pass it to `signInWithCustomToken` to sign in the user:

```as3
FirebaseAuth.service.signInWithCustomToken( customToken );
```

This will dispatch `FirebaseAuthEvent.SIGNIN_WITH_CUSTOMTOKEN_COMPLETE` when complete and `success` will indicate whether
the sign-in succeeded.

If sign-in succeeds, you can use the `getCurrentUser` method to get the user's account data.

