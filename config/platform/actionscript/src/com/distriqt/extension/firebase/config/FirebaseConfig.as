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
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	
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
		private static const ERROR_SINGLETON		: String = "The singleton has already been created. Use Config.service to access the functionality";
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		//
		// Singleton variables
		private static var _instance				: FirebaseConfig;
		private static var _shouldCreateInstance	: Boolean = false;
		private static var _extContext				: ExtensionContext;

		
		////////////////////////////////////////////////////////
		//	SINGLETON INSTANCE
		//
		
		/**
		 * The singleton instance of the Config class.
		 * @throws Error If there was a problem creating or accessing the extension, or if the key is invalid
		 */
		public static function get service():FirebaseConfig
		{
			createInstance();
			return _instance;
		}
		
		
		/**
		 * @private
		 * Creates the actual singleton instance 
		 */
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
		
		/**
		 * Constructor
		 * 
		 * You should not call this directly, but instead use the singleton access
		 */
		public function FirebaseConfig()
		{
			if (_shouldCreateInstance)
			{
				try
				{
					_extContext = ExtensionContext.createExtensionContext( EXT_CONTEXT_ID, null );
				}
				catch (e:Error)
				{
					throw new Error( ERROR_CREATION );
				}
			}
			else
			{
				throw new Error( ERROR_SINGLETON );
			}
		}
		
		
		/**
		 * <p>
		 * Disposes the extension and releases any allocated resources. Once this function 
		 * has been called, a call to <code>init</code> is neccesary again before any of the 
		 * extensions functionality will work.
		 * </p>
		 */		
		public function dispose():void
		{
			if (_extContext)
			{
				_extContext.dispose();
				_extContext = null;
			}
			_instance = null;
		}
		
		
		/**
		 * <p>
		 * The version of this extension.
		 * </p>
		 * <p>
		 * This should be of the format, MAJOR.MINOR.BUILD
		 * </p>
		 */
		public function get version():String
		{
			return VERSION;
		}
		
		
	}
}
