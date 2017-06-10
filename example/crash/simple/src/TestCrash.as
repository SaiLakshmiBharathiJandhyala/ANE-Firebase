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
		public static const APP_KEY : String = "111c4110929ae7895af1a0c578014f3d62cfd39aYMUPcenKIoYHV8iQKBXRAoZt8VRbA85v0dq52LQ1vcnuMtGlfBw6Fe+hlSo3kGsSqTzqcpptJgVd3w9nfSRgeOhnTQvUJTAnoZW1okjswpz5nGQyPBATmrYLpAUrnJIh7IEvPep+LfdmN7jG7bTzk9Qzt/X9vYRW2pKE0E9MIJlbx1fI8UUtFadXp/9HYhc8XdvSKqehK084Baq+sHOZVokcbll9jnziSaYZ5vrosL1BZ+00txHkp1OES3LARHNlbLkIur6aENhb9RuyX3aA5CWckShbkI5SHq22qv5EHxyXyUYz6WwK4unEGPbLbR0iDCv8j1jRbGbZ+JxRmUKzug==";
		
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

