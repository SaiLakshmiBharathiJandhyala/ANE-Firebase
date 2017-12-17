
You can let your users authenticate with Firebase using their Facebook accounts by integrating Facebook Login into your app.

## Before you begin

- Ensure you have setup Firebase in your application
- On the [Facebook for Developers](https://developers.facebook.com/) site, get the App ID and an App Secret for your app. 
- Enable Facebook Login: 
  - In the [Firebase console](https://console.firebase.google.com/?authuser=0), open the **Auth** section
  - On the **Sign in method** tab, enable the **Facebook** sign-in method and specify the **App ID** and **App Secret** you got from Facebook
  - Then, make sure your **OAuth redirect URI** (e.g. my-app-12345.firebaseapp.com/__/auth/handler) is listed as one of your **OAuth redirect URIs** in your Facebook app's settings page on the Facebook for Developers site in the **Product Settings > Facebook Login** config.



## Authenticate with Facebook

In order to sign in using Facebook you will need to integrate **Facebook Login**. You can do this using the [Facebook API](https://airnativeextensions.com/extension/com.distriqt.FacebookAPI) native extension. The following guide uses this ANE however you can use any method you currently have to attain the Facebook access token.


Firstly, integrate Facebook in your application by following the steps outlined in the FacebookAPI ANE documentation, this includes setting up your Facebook application in the Facebook developers site and initialising the Facebook application using `FacebookAPI.service.initialiseApp()`. 



When you are logging in your users, you must ensure that you request at least the `public_profile` and `email` permissions. 

For example:

```as3
var permissions:Array = [ "public_profile", FacebookPermissions.USER_EMAIL ];

FacebookAPI.service.addEventListener( FacebookAPISessionEvent.SESSION_OPENED, sessionOpenedHandler );
				
FacebookAPI.service.createSession( permissions, true );

function sessionOpenedHandler( event:FacebookAPISessionEvent ):void
{
    // Grab the access token to use for Firebase authentication
    accessToken = event.accessToken.token;
}
```				


It is also useful to check if there is already a session opened for the user, in which case you should be able to grab the access token immediately.

```as3
if (FacebookAPI.service.isSessionOpen())
{
    accessToken = FacebookAPI.service.getAccessToken().token;
}
```




## Authenticate with Firebase

Once you have logged in your user into Facebook you can use the Facebook Access Token to authenticate your user with Firebase. You will use the access token to create an `AuthCredential` that you can pass to the `FirebaseAuth` `signInWithCredential` function.

To create an `AuthCredential` for Facebook use the `FacebookAuthProvider.getCredential` method:

```as3
var credential:AuthCredential = FacebookAuthProvider.getCredential( accessToken ); 
```

The passs this to `signInWithCredential`

```as3
FirebaseAuth.service.signInWithCredential( credential );
```

The `signInWithCredential` method will return the `FirebaseAuthEvent.SIGNIN_WITH_CREDENTIAL_COMPLETE` event.

For example, after acquiring the access token from Facebook:

```as3
var credential:AuthCredential = FacebookAuthProvider.getCredential( accessToken );
			
FirebaseAuth.service.addEventListener( FirebaseAuthEvent.SIGNIN_WITH_CREDENTIAL_COMPLETE, signInWithCredential_completeHandler );
FirebaseAuth.service.signInWithCredential( credential );


function signInWithCredential_completeHandler( event:FirebaseAuthEvent ):void 
{
    // Check the result
    if (event.success)
    {
        // Get the user
        var user:FirebaseUser = FirebaseAuth.service.getCurrentUser();

        trace( "identifier:  " + user.identifier );
        trace( "displayName: " + user.displayName );
        trace( "email:       " + user.email );
        
        // You will find a "facebook.com" provider in user.providers 
        // most likely will be the only provider for a new user

        for each (var info:UserInfo in user.providers)
        {
            trace( "------------------" );
            trace( "\tprovider:    " + info.providerId );
            trace( "\tidentifier:  " + info.identifier );
            trace( "\tdisplayName: " + info.displayName );
            trace( "\temail:       " + info.email );
        }
    }
}
```


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