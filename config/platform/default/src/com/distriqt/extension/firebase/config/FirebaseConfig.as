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
 * @brief  		Firebase Config Native Extension
 * @author 		Michael Archbold
 * @created		Jan 19, 2012
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.extension.firebase.config
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	
	/**	
	 * <p>This class represents the Firebase Config extension.</p>
	 */
	public final class FirebaseConfig extends EventDispatcher
	{
		
		////////////////////////////////////////////////////////
		//	CONSTANTS
		//
		
		//
		//	ID and Version numbers
		public static const EXT_CONTEXT_ID			: String = "com.distriqt.firebase.Config";
		public static const VERSION					: String = Version.VERSION;
		
		
		//
		//	Error Messages
		private static const ERROR_CREATION			: String = "The native extension context could not be created";
		private static const ERROR_SINGLETON		: String = "The extension has already been created. Use ExtensionClass.service to access the functionality of the class";
		
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		//
		// Singleton variables
		private static var _instance				: FirebaseConfig;
		private static var _shouldCreateInstance	: Boolean = false;
		
		
		////////////////////////////////////////////////////////
		//	SINGLETON INSTANCE
		//
		
		public static function get service():FirebaseConfig
		{
			createInstance();
			return _instance;
		}
		
		
		private static function createInstance():void
		{
			if(_instance == null)
			{
				_shouldCreateInstance = true; 
				_instance = new FirebaseConfig();
				_shouldCreateInstance = false;
			}
		}
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseConfig()
		{
			if (_shouldCreateInstance)
			{
			}
			else
			{
				throw new Error( ERROR_SINGLETON );
			}
		}
		
		
		public function dispose():void
		{
			_instance = null;
		}
		
		
		public function get version():String
		{
			return VERSION;
		}
		
	}
}
