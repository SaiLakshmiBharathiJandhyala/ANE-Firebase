

Once you have configured the core Firebase project you can use the analytics features in your AIR application.


## Log Events


```as3
var event:EventObject = new EventObject();

event.name = EventObject.ADD_TO_CART;
event.params[Params.PRICE] = 1.99;
event.params[Params.CURRENCY] = "USD";
event.params[Params.VALUE] = 88;

Firebase.service.analytics.logEvent( event );
```


## Set User Properties

You can set a user id to identify your users.

```as3
Firebase.service.analytics.setUserID( userId ); 
```


You can set user properties to describe the users of your application and then use these properties to filter your reports.

```as3
Firebase.service.analytics.setUserProperty( name, value );
```
