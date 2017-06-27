built by [distriqt //](https://airnativeextensions.com) 

![](images/hero.png)


# Firebase

This extension enables the use of the Google Firebase platform.

Identical code base can be used across all platforms without any platform specific code, 
allowing you to develop once and deploy everywhere! 

It comes with detailed guides, AS docs, and a complete example application.


### Features:

- [Analytics](https://github.com/distriqt/ANE-Firebase/wiki/Core---Introduction)
- Develop
	- [Authentication](https://github.com/distriqt/ANE-Firebase/wiki/Auth---Introduction)
	- [Realtime Database](https://github.com/distriqt/ANE-Firebase/wiki/Database---Introduction)
	- [Storage](https://github.com/distriqt/ANE-Firebase/wiki/Storage---Introduction)
	- [Crash Reporting](https://github.com/distriqt/ANE-Firebase/wiki/Crash---Introduction)
- Grow
	- [Notifications (Cloud Messaging)](https://github.com/distriqt/ANE-Firebase/wiki/FCM---Introduction)
	- [Remote Config](https://github.com/distriqt/ANE-Firebase/wiki/RemoteConfig---Introduction)
	- [Dynamic Links](https://github.com/distriqt/ANE-Firebase/wiki/DynamicLinks---Introduction)
	- Invites
- Single API interface - your code works across iOS and Android with no modifications
- Sample project code and ASDocs reference



## Documentation

Latest documentation can be found in the [wiki](https://github.com/distriqt/ANE-Firebase/wiki)

Quick Example: 

```actionscript
Firebase.initialiseApp();

// Log an event to analytics
var event:EventObject = new EventObject();
event.name = EventObject.ADD_TO_CART;
event.params[Params.PRICE] = 1.99;

Firebase.service.analytics.logEvent( event );
```

More information here: 

[com.distriqt.Firebase](https://airnativeextensions.com/extension/com.distriqt.Firebase)


## License

You can purchase a license for using this extension:

[airnativeextensions.com](https://airnativeextensions.com/)

distriqt retains all copyright.


![](images/promo.png)


