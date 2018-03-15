
![](images/hero.png)


# Firebase

The [Firebase platform](https://firebase.google.com) forms one of the biggest 
platforms for application development available today bringing together a range 
of Google services along with the acquired Firebase infrastructure services.

We have been working with Google to bring you the best available ANEs 
integrating Google services tightly with your AIR application.

This extension is to bring access Google's Firebase infrastructure to your AIR application.

The simple API allows you to quickly integrate Firebase in your AIR application. 
Identical code base can be used across all platforms allowing you to concentrate 
on your application and not device specifics.

We provide complete guides to get you up and running with Firebase as quickly and easily as possible.


### Features:

- ![](Analytics|Core - Introduction)
- Develop
	- ![](Authentication|Auth - Introduction)
	- ![](Realtime Database|Database - Introduction)
	- ![](Storage|Storage - Introduction)
	- ![](Performance Monitoring|Performance - Introduction)
	- ![](Crash Reporting|Crash - Introduction)
- Grow
	- ![](Notifications (Cloud Messaging)|FCM - Introduction)
	- ![](Remote Config|RemoteConfig - Introduction)
	- ![](Dynamic Links|DynamicLinks - Introduction)
	- ![](Invites|Invites - Introduction)
- Single API interface - your code works across iOS and Android with no modifications
- Sample project code and ASDocs reference


### Quick Example: 

```as3
Firebase.initialiseApp();

// Log an event to analytics
var event:EventObject = new EventObject();
event.name = EventObject.ADD_TO_CART;
event.params[Params.PRICE] = 1.99;

Firebase.service.analytics.logEvent( event );
```



![](images/promo.png)

