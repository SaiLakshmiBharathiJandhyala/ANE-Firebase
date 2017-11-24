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
 * @file   		GoogleIdentityHelper.as
 * @brief  		
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		08/01/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.core.Core;
	import com.distriqt.extension.googleidentity.GoogleIdentity;
	import com.distriqt.extension.googleidentity.GoogleIdentityOptions;
	import com.distriqt.extension.googleidentity.events.GoogleIdentityEvent;
	import com.distriqt.extension.playservices.base.ConnectionResult;
	import com.distriqt.extension.playservices.base.GoogleApiAvailability;
	import com.distriqt.extension.playservices.base.PlayServicesBase;
	
	
	/**	
	 */
	public class GoogleIdentityHelper
	{
		
		public static const TAG : String = "GID";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function GoogleIdentityHelper( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup():void
		{
			try
			{
				GoogleIdentity.init( Config.googleIdentityKey );
				if (GoogleIdentity.isSupported)
				{
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.SETUP_COMPLETE, 	setupCompleteHandler );
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.SIGN_IN, 			signInHandler );
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.SIGN_OUT, 			signOutHandler );
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.DISCONNECT, 		disconnectHandler );
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.ERROR,		 		errorHandler );
					
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.TOKEN_UPDATED,		tokenUpdatedHandler );
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.TOKEN_FAILED,		tokenFailedHandler );

					var options:GoogleIdentityOptions = new GoogleIdentityOptions( Config.clientID_Android, Config.clientID_iOS );
					
					// Optional: Required if you need to call `getToken`
					options.clientSecret_Android = Config.clientSecret_Android;
					options.clientSecret_iOS = Config.clientSecret_iOS;
					
					options.requestIdToken = true;
					options.requestServerAuthCode = true;
					options.scopes.push( "https://www.googleapis.com/auth/plus.login" );
					options.scopes.push( "https://www.googleapis.com/auth/plus.me" );
					options.scopes.push( "profile" );
					
					GoogleIdentity.service.setup( options );
				}
			}
			catch (e:Error)
			{
				trace( e );
			}
		}
		
		
		public function checkPlayServices():void
		{
			var result:int = GoogleApiAvailability.instance.isGooglePlayServicesAvailable();
			if (result != ConnectionResult.SUCCESS)
			{
				if (GoogleApiAvailability.instance.isUserRecoverableError( result ))
				{
					GoogleApiAvailability.instance.showErrorDialog( result );
				}
				else
				{
					log( "Google Play Services aren't available on this device" );
				}
			}
			else
			{
				log( "Google Play Services are Available" );
			}
		}
		
		
		
		public function signIn():void
		{
			if (GoogleIdentity.isSupported)
			{
				GoogleIdentity.service.signIn();
			}
		}
		
		
		
		public function signOut():void
		{
			if (GoogleIdentity.isSupported)
			{
				GoogleIdentity.service.signOut();
			}
		}
		
		
		public function disconnect():void
		{
			if (GoogleIdentity.isSupported)
			{
				GoogleIdentity.service.disconnect();
			}
		}
		
		
		public function getToken():void
		{
			if (GoogleIdentity.isSupported)
			{
				GoogleIdentity.service.getToken();
			} 
		}
		
		
		//
		//
		//	GOOGLE IDENTITY HANDLERS
		//
		//		
		
		private function setupCompleteHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type );
//			GoogleIdentity.service.signInSilently();
		}
				
		private function signInHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type + "::"+event.user.toString() );
			log( "serverAuthCode: "+event.user.serverAuthCode );

//			GoogleIdentity.service.getToken();
		}
		
		private function signOutHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type );
		}
		
		private function disconnectHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type );
		}
		
		private function errorHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type +"::["+event.errorCode+"] "+event.error );
		}

		
		private function tokenUpdatedHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type );
			
			log( "id token: "+event.user.authentication.idToken );
			log( "refresh token: " +event.user.authentication.refreshToken );
			log( "access token: " +event.user.authentication.accessToken );
		}
		
		private function tokenFailedHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type );
		}
		
		
	}
}
