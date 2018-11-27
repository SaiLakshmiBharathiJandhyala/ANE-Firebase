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
	import com.distriqt.extension.firebase.crash.FirebaseCrash;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the Firebase Crash Native Extension
	 */
	public class TestCrash extends Sprite
	{
		public static const APP_KEY : String = "1d74827537c017147bf89a6b90ad4c33bce42033dchN9OtgZEU0VC8H7x5Zg6+faWRA6TNZRn4t46DHaSiwiWFk376LOaQqh0QeJTbi1We5qOjsDV6KflK+QmcFgqt1lk5JnQqvSNLpaI5damdW22E3f/GtTycHUNHnzuQ+IEQPVm3zw10sBqJACGJVr3q7uMH/3AkuaBlKMoGLjDiPCyc7XR/oWMVz89QlIRLt+RmB3EVZg8De4qY3HLEAuDq54odw5PbYh6Y4n8QxI5OXyJSrMIJwPLM3G54cXwImNPAb8Y869N6G1HPO6dpC894UczxIebzljA6pbnd0a/YysH65aHasPu1c6mKVRNiFPQ540IYbp40BxNG0l9kAXw==";
		
		/**
		 * Class constructor 
		 */	
		public function TestCrash()
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
			

			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
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
				FirebaseCrash.init( APP_KEY );
				
				if (Firebase.isSupported)
				{
					message( "Firebase Version: " + Firebase.service.version );
					message( "Crash Supported:  " + FirebaseCrash.isSupported );
					message( "Crash Version:    " + FirebaseCrash.service.version );
					
					var success:Boolean = Firebase.service.initialiseApp();
					message( "Firebase.service.initialiseApp() = " + success );
					if (!success)
					{
						message( "CHECK YOUR CONFIGURATION" );
					}
				}
				
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
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			
			FirebaseCrash.service.log( "Testing a crash log message" );
			
			if (Math.random() > 0.6)
			{
				FirebaseCrash.service.forceCrash();
			}
			
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
		

		
	}
}

