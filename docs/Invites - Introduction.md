
Firebase Invites are an out-of-the-box solution for app referrals and sharing via email or SMS.


## About 

Firebase Invites are an out-of-the-box solution for app referrals and sharing via email or SMS. 
To customize the invitation user experience, or to generate links programmatically, 
use ![](Firebase Dynamic Links|DynamicLinks - Introduction).

>
> Word of mouth is one of the most effective ways of getting users to install your app. 
> In a recent study of thousands of smartphone users, researchers found that the #1 reason 
> people discovered an app is because they heard about it from a friend or colleague. Firebase 
> Invites makes it easy to turn your app's users into your app's strongest advocates.
>
> Firebase Invites builds on Firebase Dynamic Links, which ensures that recipients of links 
> have the best possible experience for their platform and the apps they have installed.
>

[![YOUTUBE](https://img.youtube.com/vi/LkaIJCZ_HyM/0.jpg)](https://www.youtube.com/watch?v=LkaIJCZ_HyM)

[https://firebase.google.com/docs/invites/](https://firebase.google.com/docs/invites/)


## How does it work?

When a user taps one of your app's Share buttons and chooses the Firebase Invites channel—usually named 
"Email and SMS"—the Firebase Invites sharing screen opens. From the sharing screen, the user selects 
recipients from their Google contacts and contacts stored locally on the device, optionally customizes
the invitation message and sends the invitations. Invitations are sent by email or SMS, depending on 
the available contact information, and contain a Dynamic Link to your app.

When the invitation's recipients open the Dynamic Link in the invitation, they are sent to the Play 
Store or App Store if they need to install your app; then, your app opens and can retrieve and handle 
the link.



## Google Identity

On iOS Invites require that you have signed in your user using Google Identity. 
This means that you will need to integrate the [Google Identity ANE](https://airnativeextensions.com/extension/com.distriqt.GoogleIdentity) in order to get invites on iOS.

Android does not require this addition.

