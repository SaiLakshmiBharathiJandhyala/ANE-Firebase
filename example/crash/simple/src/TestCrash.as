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
		public static const APP_KEY : String = "a2734845a1a55260da5a0b319247f5e4dc95b315RGe4ODm5EGEkXwhnT7bOf/YtPybyw8Aojp7e9MyHCYbrBRnuvbHLhMjt+K0mgvzSzAr98MelMQcZBM5ShbdMzIjuYfg42H+CJeryuxCp068oQubQdaYx2nnHNDP2a7EUYa3J1ZY35OBrVBzhxJpHH6uAy11a3ARXay7gsw3sHJXaicl4C7oSYa/mYskbBdfTMQh/3JxkRGm9dDa0dE7mbkokr4YM+J1GDkmjgYs+XCQAnSOvyZzVetBrzkoGIraBmWRwp7cq+fxKITonagf2br/mSfpG2FUhgt4RUKDvGneYT9XFBHtWqG8ZC3WWqNdrLWOWv8hlhYW7yIXa1KCD/w==";
		
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

