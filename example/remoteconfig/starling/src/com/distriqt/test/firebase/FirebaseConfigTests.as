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
	
	import com.distriqt.extension.firebase.Firebase;
	import com.distriqt.extension.firebase.remoteconfig.FirebaseRemoteConfig;
	import com.distriqt.extension.firebase.remoteconfig.FirebaseRemoteConfigInfo;
	import com.distriqt.extension.firebase.remoteconfig.events.FirebaseRemoteConfigEvent;
	
	import flash.system.System;
	
	import starling.events.Event;
	
	/**	
	 * 
	 */
	public class FirebaseConfigTests
	{
		public static const TAG : String = "RC";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseConfigTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup(e:Event=null):void
		{
			try
			{
				Firebase.init( Config.distriqtApplicationKey );
				FirebaseRemoteConfig.init( Config.distriqtApplicationKey );
				log( "Firebase Supported:     " + Firebase.isSupported );
				log( "RemoteConfig Supported: " + FirebaseRemoteConfig.isSupported );
				
				if (Firebase.isSupported && FirebaseRemoteConfig.isSupported)
				{
					log( "Firebase Version:     " + Firebase.service.version );
					log( "RemoteConfig Version: " + FirebaseRemoteConfig.service.version );
					
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
		//	REMOTE CONFIG
		//
		//		
		
		
		
		////////////////////////////////////////////////////////
		//  DEFAULTS
		//
		
		public function setDefaults():void
		{
			log( "setDefaults()" );
			
			var defaultValues:Object = {
				welcome_message: "Default welcome message",
				welcome_message_caps: true
			};
			
			FirebaseRemoteConfig.service.setDefaults( defaultValues );
			
		}
		
		
		//
		//  KEYS
		//
		
		public function getKeysByPrefix():void
		{
			log( "getKeysByPrefix()" );
			var keys:Array = FirebaseRemoteConfig.service.getKeysByPrefix( "" );
			for each (var key:String in keys)
			{
				log( "key = " + key );
			}
		}
		
		////////////////////////////////////////////////////////
		//  VALUES
		//
		
		public function getString():void
		{
			var key:String = "welcome_message";
			
			log( "getString( " + key + " ) = " + FirebaseRemoteConfig.service.getString( key ) );
		}
		
		
		////////////////////////////////////////////////////////
		//  FETCH
		//
		
		public function fetch():void
		{
			FirebaseRemoteConfig.service.addEventListener( FirebaseRemoteConfigEvent.FETCH_COMPLETE, fetch_completeHandler );
			FirebaseRemoteConfig.service.addEventListener( FirebaseRemoteConfigEvent.FETCH_ERROR, fetch_errorHandler );
			
			var success:Boolean = FirebaseRemoteConfig.service.fetch( 30 );
			
			log( "fetch() = " + success );
		}
		
		private function fetch_completeHandler( event:FirebaseRemoteConfigEvent ):void
		{
			log( event.type );
			
			FirebaseRemoteConfig.service.removeEventListener( FirebaseRemoteConfigEvent.FETCH_COMPLETE, fetch_completeHandler );
			FirebaseRemoteConfig.service.removeEventListener( FirebaseRemoteConfigEvent.FETCH_ERROR, fetch_errorHandler );
		}
		
		private function fetch_errorHandler( event:FirebaseRemoteConfigEvent ):void
		{
			log( event.type );
			
			FirebaseRemoteConfig.service.removeEventListener( FirebaseRemoteConfigEvent.FETCH_COMPLETE, fetch_completeHandler );
			FirebaseRemoteConfig.service.removeEventListener( FirebaseRemoteConfigEvent.FETCH_ERROR, fetch_errorHandler );
		}
		
		
		
		////////////////////////////////////////////////////////
		//  INFO
		//
		
		public function getInfo():void
		{
			var info:FirebaseRemoteConfigInfo = FirebaseRemoteConfig.service.getInfo();
			log( "info: " + info.lastFetchStatus + "::"+info.fetchTimestamp );
		}
		
		
	}
}
