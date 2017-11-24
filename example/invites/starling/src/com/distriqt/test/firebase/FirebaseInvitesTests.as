/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @brief
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		21/06/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.core.Core;
	import com.distriqt.extension.firebase.Firebase;
	import com.distriqt.extension.firebase.FirebaseOptions;
	import com.distriqt.extension.firebase.dynamiclinks.DynamicLink;
	import com.distriqt.extension.firebase.dynamiclinks.builders.AndroidParametersBuilder;
	import com.distriqt.extension.firebase.dynamiclinks.builders.DynamicLinkBuilder;
	import com.distriqt.extension.firebase.dynamiclinks.builders.GoogleAnalyticsParametersBuilder;
	import com.distriqt.extension.firebase.dynamiclinks.builders.IosParametersBuilder;
	import com.distriqt.extension.firebase.dynamiclinks.builders.ItunesConnectAnalyticsParametersBuilder;
	import com.distriqt.extension.firebase.dynamiclinks.builders.SocialMetaTagParametersBuilder;
	import com.distriqt.extension.firebase.dynamiclinks.events.DynamicLinkEvent;
	import com.distriqt.extension.firebase.dynamiclinks.events.ShortDynamicLinkEvent;
	import com.distriqt.extension.firebase.invites.FirebaseInvites;
	import com.distriqt.extension.firebase.invites.InviteOptions;
	import com.distriqt.extension.firebase.invites.events.InviteEvent;
	
	import flash.desktop.NativeApplication;
	
	import flash.events.InvokeEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import starling.events.Event;
	
	/**	
	 * 
	 */
	public class FirebaseInvitesTests
	{
		public static const TAG : String = "IN";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseInvitesTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup(e:Event=null):void
		{
			try
			{
				Core.init();
				Firebase.init( Config.distriqtApplicationKey );
				FirebaseInvites.init( Config.distriqtApplicationKey );
				log( "Firebase Supported:    " + Firebase.isSupported );
				log( "Invites Supported:     " + FirebaseInvites.isSupported );
				
				if (Firebase.isSupported)
				{
					log( "Firebase Version:      " + Firebase.service.version );
					log( "Invites Version:       " + FirebaseInvites.service.version );
					
					var success:Boolean = Firebase.service.initialiseApp();

					log( "Firebase.service.initialiseApp() = " + success );
					if (!success)
					{
						log( "CHECK YOUR CONFIGURATION" );
					}
				}
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		
		
		//
		//
		//	DYNAMIC LINKS
		//
		//
		
		private var _link : String = null;
		
		
		
		//
		//  GENERATE LINK
		//
		
		public function generateLink():void
		{
			log( "generateLink()" );
			
			var link:DynamicLink = FirebaseInvites.service.dynamicLinks.createDynamicLink(
					new DynamicLinkBuilder()
							.setLink( "https://airnativeextensions.com" )
							.setDynamicLinkDomain( "bb9g6.app.goo.gl" )
							.setAndroidParameters(
									new AndroidParametersBuilder( "air.com.distriqt.test.debug" )
											.setFallbackUrl("https://airnativeextensions.com")
											.build()
							)
							.setIosParameters(
									new IosParametersBuilder( "com.distriqt.test" )
											.setFallbackUrl("https://airnativeextensions.com")
											.setCustomScheme("distriqt")
											.build()
							)
							.setGoogleAnalyticsParameters(
									new GoogleAnalyticsParametersBuilder()
											.setSource("orkut")
											.setMedium("social")
											.setCampaign("example-promo")
											.build()
							)
							.setItunesConnectAnalyticsParameters(
									new ItunesConnectAnalyticsParametersBuilder()
											.setProviderToken( "123456" )
											.setCampaignToken("example-promo")
											.build()
							)
							.setSocialMetaTagParameters(
									new SocialMetaTagParametersBuilder()
											.setTitle("Example of a Dynamic Link")
											.setDescription("This link works whether the app is installed or not!")
											.build()
							)
							.build()
			);
			
			log( "link.url = " + link.url );
			
			_link = link.url;
		}
		
		
		
		//
		//  GENERATE SHORT LINK
		//
		
		
		public function generateShortLink():void
		{
			FirebaseInvites.service.dynamicLinks.addEventListener( ShortDynamicLinkEvent.LINK_CREATED, dynamicLinkCreatedHandler );
			FirebaseInvites.service.dynamicLinks.addEventListener( ShortDynamicLinkEvent.ERROR, dynamicLinkErrorHandler );
			
			var success:Boolean = FirebaseInvites.service.dynamicLinks.createShortDynamicLink(
					new DynamicLinkBuilder()
							.setLink( "https://airnativeextensions.com" )
							.setDynamicLinkDomain( "bb9g6.app.goo.gl" )
							.setAndroidParameters(
									new AndroidParametersBuilder( "air.com.distriqt.test.debug" )
											.setFallbackUrl("https://airnativeextensions.com")
											.build()
							)
							.setIosParameters(
									new IosParametersBuilder( "com.distriqt.test" )
											.setFallbackUrl("https://airnativeextensions.com")
											.setCustomScheme("distriqt")
											.build()
							)
							.build()
			);
			
			log( "generateShortLink() = " + success );
		}
		
		private function dynamicLinkCreatedHandler( event:ShortDynamicLinkEvent ):void
		{
			log( "dynamicLinkCreatedHandler() : " + event.link.shortLink );
			
			_link = event.link.shortLink;
		}
		
		private function dynamicLinkErrorHandler( event:ShortDynamicLinkEvent ):void
		{
			log( "dynamicLinkErrorHandler()" );
		}
		
		
		//
		//  OPEN LINK
		//
		
		public function openLink():void
		{
			if (_link != null)
			{
				log( "openLink() " + _link );
				navigateToURL(new URLRequest( _link ));
			}
		}
		
		
		
		//
		//  LISTEN FOR LINKS
		//
		
		public function listenForLinks():void
		{
			log( "listenForLinks()" );
			
			FirebaseInvites.service.dynamicLinks.addEventListener( DynamicLinkEvent.RECEIVED, dynamicLink_receivedHandler );

			NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, invokeHandler );
			NativeApplication.nativeApplication.addEventListener( flash.events.Event.ACTIVATE, activateHandler );
			NativeApplication.nativeApplication.addEventListener( flash.events.Event.DEACTIVATE, deactivateHandler );
		
			
		}
		
		private function dynamicLink_receivedHandler( event:DynamicLinkEvent ):void
		{
			log( "dynamicLink_receivedHandler(): " + event.link );
		}
		
		
		private function invokeHandler( event:InvokeEvent ):void
		{
			log( "invokeHandler(): " + event.arguments.join(",") );
		}
		
		private function activateHandler(event:flash.events.Event):void
		{
			log( "activateHandler" );
		}
		
		private function deactivateHandler(event:flash.events.Event):void
		{
			log( "deactivateHandler" );
		}
		
		
		//
		//
		//	INVITES
		//
		//
		
		
		//
		//	LISTEN FOR INVITES
		//
		
		public function listenForInvites():void
		{
			log( "listenForInvites()" );
			FirebaseInvites.service.addEventListener( InviteEvent.RECEIVED, invite_receivedHandler );
		}
		
		private function invite_receivedHandler( event:InviteEvent ):void
		{
			log( "invite_receivedHandler(): " + event.invitationIds.join(",") );
		}
		

		
		
		
		//
		//  SEND AN INVITE
		//
		
		public function sendInvite():void
		{
			log( "sendInvite()" );
			
			var options:InviteOptions = new InviteOptions();
			
			options.title = "Invite Test";
			options.message = "Check this out!";
			options.deepLink = "distriqt://invite";
//			options.deepLink = "https://airnativeextensions.com";
			
			FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_COMPLETE, inviteSentHandler );
			FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_CANCELLED, inviteErrorHandler );
			FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_FAILED, inviteErrorHandler );
			
			FirebaseInvites.service.sendInvite( options );
			
		}
		
		
		private function inviteSentHandler( event:InviteEvent ):void
		{
			log( "sendInvite(): sent: " + event.invitationIds.join(",") );
			
			FirebaseInvites.service.removeEventListener( InviteEvent.SENDINVITE_COMPLETE, inviteSentHandler );
			FirebaseInvites.service.removeEventListener( InviteEvent.SENDINVITE_CANCELLED, inviteErrorHandler );
			FirebaseInvites.service.removeEventListener( InviteEvent.SENDINVITE_FAILED, inviteErrorHandler );
			
		}
		
		
		private function inviteErrorHandler( event:InviteEvent ):void
		{
			log( "sendInvite(): error: " + event.type );
			
			FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_COMPLETE, inviteSentHandler );
			FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_CANCELLED, inviteErrorHandler );
			FirebaseInvites.service.addEventListener( InviteEvent.SENDINVITE_FAILED, inviteErrorHandler );
			
		}
		
		

		
	}
}
