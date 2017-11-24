

## Send Invitiations

To initiate the send invitation dialog you call the `sendInvite` function with the required options.
The options include things such as the dialog title, message content and application ids on other platforms.
If you wish to use invitations to launch your application it is important you specify the deep link to use for the invitation. 


```as3
var options:InviteOptions = new InviteOptions();
			
options.title = "Invite Test";
options.message = "Check this out!";
options.deepLink = "distriqt://invite";

FirebaseInvites.service.sendInvite( options );
```

The dialog will dispatch one of three events:

- `InviteEvent.SENDINVITE_COMPLETE`: If the invitation process was completed successfully, the event will contain an array of invitation ids identifying each invitation sent; 
- `InviteEvent.SENDINVITE_CANCELLED`: if the user cancelled the dialog;
- `InviteEvent.SENDINVITE_FAILED`: if there was an error sending the invitations.


```as3
FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_COMPLETE, inviteSentHandler );
FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_CANCELLED, inviteErrorHandler );
FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_FAILED, inviteErrorHandler );

function inviteSentHandler( event:InviteEvent ):void
{
	trace( "sendInvite(): sent: " + event.invitationIds.join(",") );
}

function inviteSentHandler( event:InviteEvent ):void
{
	trace( "sendInvite(): error: " + event.type );
}
```

>
> If you are using iOS and haven't logged in your user through Google Identity you will not be able to send invitations.
>



## Receive Invitiations

If you have correctly set the deep link to launch your application then you can listen for the `InviteEvent.RECEIVED` event
which will get dispatched whenever an invitation is received by your application.

This will include invitations at launch. These will be dispatched immediately after you register your listener for the event.

```as3
FirebaseInvites.service.addEventListener( InviteEvent.RECEIVED, invite_receivedHandler );

function invite_receivedHandler( event:InviteEvent ):void
{
	trace( "invite_receivedHandler(): " + event.invitationIds.join(",") );
}
```

The event will contain a single invitation id that was received by the user.

