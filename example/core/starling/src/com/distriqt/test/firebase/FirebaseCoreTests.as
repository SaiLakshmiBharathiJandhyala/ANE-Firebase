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
 * @file   		FirebaseCoreTests.as
 * @brief  		
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		21/06/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.firebase.Firebase;
	import com.distriqt.extension.firebase.analytics.EventObject;
	import com.distriqt.extension.firebase.analytics.Params;
	
	import starling.events.Event;
	
	/**	
	 * 
	 */
	public class FirebaseCoreTests
	{
		public static const TAG : String = "FirebaseCore";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseCoreTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup(e:Event=null):void
		{
			try
			{
				Firebase.init( Config.distriqtApplicationKey );
				log( "Firebase Supported: " + Firebase.isSupported );
				
				if (Firebase.isSupported)
				{
					log( "Firebase Version:   " + Firebase.service.version );
					
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
		//	ANALYTICS
		//
		//		

		
		public function logEvent(e:Event=null):void
		{
			if (Firebase.isSupported)
			{
				var event:EventObject = new EventObject();
				
				event.name = EventObject.ADD_TO_CART;
				event.params[Params.PRICE] = 1.99;
				event.params[Params.CURRENCY] = "USD";
				event.params[Params.VALUE] = 88;
				
				var success:Boolean = Firebase.service.analytics.logEvent( event );
			
				log( "logEvent = " + success );
			}
		}
		
		
		private var _userId : String = String(Math.floor(Math.random()*10000));
		
		public function setUserID(e:Event=null):void
		{
			if (Firebase.isSupported)
			{
				var success:Boolean = Firebase.service.analytics.setUserID( _userId );
				log( "setUserID( " + _userId + " ) = " + success );
			}
		}
		
		
		public function setUserProperty(e:Event=null):void
		{
			if (Firebase.isSupported)
			{
				var name:String = "test_user_prop";
				var value:String = String(Math.floor(Math.random()*10000));
				
				var success:Boolean = Firebase.service.analytics.setUserProperty( name, value );
				log( "setUserProperty( " + name+ ", " + value + " ) = " + success );
			}
		}
			
		
		public function setCurrentScreen():void 
		{
			if (Firebase.isSupported)
			{
				var screenName:String = "screen_test_"+String(Math.floor(Math.random()*10));;
				
				var success:Boolean = Firebase.service.analytics.setCurrentScreen( screenName );
				log( "setCurrentScreen( " + screenName +" ) = " + success );
			}
		}
		
	}
}
