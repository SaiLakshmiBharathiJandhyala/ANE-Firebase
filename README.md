built by [distriqt //](https://airnativeextensions.com) 

![](images/hero.png)

> ---
> # Development
>
> This ANE is in development and this repository is being used to display progress 
> and get feedback on features and requirements from the community.
> 
> We have populated the repository with our initial set of milestones and development schedule 
> but as always we welcome your input so please add any requests you may have for this ANE.
> 
> This repository will eventually be used as the release repository once the ANE is complete.
> 
> While this ANE is in development links to some documentation and licenses may not be available.
> 
> 
> 
> ## Beta testing
> 
> If you are interested in beta testing the Firebase ANE(s) simply make sure you are watching this repository for updates
> and let us know of any issues you encounter. 
> 
> If you wish to be contacted about major updates send us an email at airnativeextensions@distriqt.com 
> and we will make sure you get on our email list.  
> 
> As an incentive, beta testers will be rewarded for active participation in the beta. 
> So make sure you get involved and watch the repository for updates.
> 
> 
> 
> ## Funding
> 
> If you would like to help us be able to spend more time on this ANE we would really welcome any donations that 
> you can make to our development time. Any donations over $50 will be given a license for the extension once completed 
> and any donors will be referenced on our site as a contributor. 
> 
> [![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=SUTDJB94ZJN4W)
> 
> We are always looking for the best ways to be able to continue supporting the AIR community so feel free to
> drop us a line and let us know how we're going.
> 
> ---

# Firebase

This extension enables the use of the Google Firebase platform.

Identical code base can be used across all platforms without any platform specific code, 
allowing you to develop once and deploy everywhere! 

It comes with detailed guides, AS docs, and a complete example application.


### Features:

- Analytics
- Develop
	- Realtime Database
	- Remote Config
- Grow
	- Notifications (Cloud Messaging)
	- Invites
	- Dynamic Links
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


