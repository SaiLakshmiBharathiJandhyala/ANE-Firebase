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
	import com.distriqt.extension.googleidentity.GoogleIdentityOptionsBuilder;
	import com.distriqt.extension.googleidentity.events.GoogleIdentityEvent;
	import com.distriqt.extension.playservices.base.ConnectionResult;
	import com.distriqt.extension.playservices.base.GoogleApiAvailability;
	import com.distriqt.extension.playservices.base.PlayServicesBase;
	
	
	/**
	 *
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
				if (GoogleIdentity.isSupported)
				{
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.SIGN_IN, 			signInHandler );
					GoogleIdentity.service.addEventListener( GoogleIdentityEvent.ERROR,		 		errorHandler );
					
					var options:GoogleIdentityOptions = new GoogleIdentityOptionsBuilder()
							.requestEmail()
							.requestIdToken()
							.setIOSClientID( Config.clientID_iOS )
							.setServerClientID( Config.serverClientID )
							.build();
					
					GoogleIdentity.service.setup( options );
					GoogleIdentity.service.signInSilently();
				}
			}
			catch (e:Error)
			{
				trace( e );
			}
		}
		
		
		
		public function signIn():void
		{
			if (GoogleIdentity.isSupported)
			{
				GoogleIdentity.service.signIn();
			}
		}
		
		private function signInHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type + "::"+event.user.toString() );
		}
		
		private function errorHandler( event:GoogleIdentityEvent ):void
		{
			log( event.type +"::["+event.errorCode+"] "+event.error );
		}
		
		
	}
}
