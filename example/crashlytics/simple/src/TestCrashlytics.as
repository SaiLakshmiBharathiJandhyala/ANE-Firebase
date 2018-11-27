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
 * This is a test application for the distriqt extension
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.firebase.Firebase;
	import com.distriqt.extension.firebase.crashlytics.FirebaseCrashlytics;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	
	/**	
	 * Sample application for using the Crashlytics Native Extension
	 */
	public class TestCrashlytics extends Sprite
	{
		public static var APP_KEY : String = "1d74827537c017147bf89a6b90ad4c33bce42033dchN9OtgZEU0VC8H7x5Zg6+faWRA6TNZRn4t46DHaSiwiWFk376LOaQqh0QeJTbi1We5qOjsDV6KflK+QmcFgqt1lk5JnQqvSNLpaI5damdW22E3f/GtTycHUNHnzuQ+IEQPVm3zw10sBqJACGJVr3q7uMH/3AkuaBlKMoGLjDiPCyc7XR/oWMVz89QlIRLt+RmB3EVZg8De4qY3HLEAuDq54odw5PbYh6Y4n8QxI5OXyJSrMIJwPLM3G54cXwImNPAb8Y869N6G1HPO6dpC894UczxIebzljA6pbnd0a/YysH65aHasPu1c6mKVRNiFPQ540IYbp40BxNG0l9kAXw==";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestCrashlytics()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat( "_typewriter", 18, 0x000000 );
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			addEventListener( Event.ACTIVATE, activateHandler, false, 0, true );
			addEventListener( Event.DEACTIVATE, deactivateHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				Firebase.init( APP_KEY );
				FirebaseCrashlytics.init( APP_KEY );
				
				message( "Crashlytics Supported: " + FirebaseCrashlytics.isSupported );
				message( "Crashlytics Version:   " + FirebaseCrashlytics.service.version );
				
				FirebaseCrashlytics.service.addEventListener( ErrorEvent.ERROR, errorHandler );

				// Must ensure your app is initialised before enabling crashlytics collection
				Firebase.service.initialiseApp();
				
				FirebaseCrashlytics.service.setDebug( true );
				FirebaseCrashlytics.service.enableCollection();
				
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		

		private var _stage : int = 0;
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	Do something when user clicks screen?
			//
			
			switch (_stage)
			{
				case 0:
				{
//					FirebaseCrashlytics.service.setDebug( true );
					FirebaseCrashlytics.service.enableCollection();
					FirebaseCrashlytics.service.log( "enableCollection" );
					break;
				}
				
				case 1:
				{
					FirebaseCrashlytics.service.log( "setUserIdentifier" );
					FirebaseCrashlytics.service.setUserIdentifier( "my_user_identifier_1" );
					break;
				}
				
				case 2:
				{
					FirebaseCrashlytics.service.log( "setStringValue" );
					FirebaseCrashlytics.service.setStringValue( "a value", "test_val" );
					break;
				}
				
				case 3:
				{
					var e:Error = new Error( "Test custom error", -1001 );
					FirebaseCrashlytics.service.recordError( e );
					break;
				}
				
				default:
					_stage = -1;
//					FirebaseCrashlytics.service.log( "Forcing a crash" );
//					FirebaseCrashlytics.service.forceCrash();
			}
			
			_stage ++;
			
		}
		
		
		private function activateHandler( event:Event ):void
		{
		}
		
		private function deactivateHandler( event:Event ):void
		{
		}

		
		//
		//	EXTENSION HANDLERS
		//
		
		private function errorHandler( event:ErrorEvent ):void
		{
			message( event.text );
		}
		
		
		
	}
}

