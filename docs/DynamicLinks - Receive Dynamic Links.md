
## Receive Dynamic Links

Receiving dynamic links is simply a matter of listening for the `DynamicLinkEvent.RECEIVED` event.

When you add a listener for this event the extension will check for any dynamic links
that may have started your application and dispatch them, so you should be prepared to  
receive an event shortly after adding the listener:

```as3
FirebaseDynamicLinks.service.addEventListener( DynamicLinkEvent.RECEIVED, dynamicLink_receivedHandler );
```


The event will contain the dynamic link that was received:

```as3
function dynamicLink_receivedHandler( event:DynamicLinkEvent ):void
{
	trace( "dynamicLink_receivedHandler(): " + event.link );
}
```


### iOS 

>
> Receiving Firebase Dynamic Links requires iOS 8 or newer. You can target iOS 7 in your app, but 
> you won't receive any link events unless you are running iOS 8 or newer.
>




