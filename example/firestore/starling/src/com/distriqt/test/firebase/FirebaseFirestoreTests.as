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
	import com.distriqt.extension.firebase.firestore.FirebaseFirestore;
	
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	
	import flash.net.SharedObject;
	
	import flash.net.URLRequest;
	
	import flash.net.navigateToURL;
	
	import starling.events.Event;
	
	/**	
	 * 
	 */
	public class FirebaseFirestoreTests
	{
		public static const TAG : String = "FS";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseFirestoreTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup(e:Event=null):void
		{
			try
			{
				Core.init();
				Firebase.init( Config.distriqtApplicationKey );
				FirebaseFirestore.init( Config.distriqtApplicationKey );
				log( "Firebase Supported:     " + Firebase.isSupported );
				log( "Firestore Supported:    " + FirebaseFirestore.isSupported );
				
				if (Firebase.isSupported)
				{
					log( "Firebase Version:     " + Firebase.service.version );
					log( "Firestore Version:    " + FirebaseFirestore.service.version );
					
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
		//	FIRESTORE
		//
		//

		
		
		
		
		
		
		
		
	}
}
