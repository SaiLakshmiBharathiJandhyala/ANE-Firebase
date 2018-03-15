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
	import com.distriqt.extension.firebase.performance.FirebasePerformance;
	import com.distriqt.extension.firebase.performance.metrics.Trace;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	
	/**	
	 * Sample application for using the Performance Native Extension
	 */
	public class TestPerformance extends Sprite
	{
		public static var APP_KEY : String = "APPLICATION_KEY";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestPerformance()
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
			_text.defaultTextFormat = new TextFormat( "_typewriter", 18 );
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
		}
		
		
		private function init( ):void
		{
			try
			{
				Firebase.init( APP_KEY );
				FirebasePerformance.init( APP_KEY );
				
				log( "Firebase Supported: " + Firebase.isSupported );
				log( "Firebase Version:   " + Firebase.service.version );
				log( "Performance Supported: " + FirebasePerformance.isSupported );
				log( "Performance Version:   " + FirebasePerformance.service.version );
				
				//
				//	Add test inits here
				//
				
				var success:Boolean = Firebase.service.initialiseApp();
				if (!success)
				{
					log( "CHECK YOUR CONFIGURATION" );
				}
			}
			catch (e:Error)
			{
				log( "ERROR::"+e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function log( str:String ):void
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
			//
			//	Do something when user clicks screen?
			//
			
			if (FirebasePerformance.isSupported)
			{
				if (FirebasePerformance.service.isPerformanceCollectionEnabled())
				{
					log( "START LOOP TEST" );
					var loopTestTrace:Trace = FirebasePerformance.service.newTrace( "loopTest" );
					loopTestTrace.start();
					
					// In a real application you would be monitoring some process or download
					// but here we'll just use a random timer to complete the trace.
					setTimeout( function():void {
						log( "END LOOP TEST" );
						loopTestTrace.stop();
					}, Math.random() * 5000 );
				
					var request:URLRequest = new URLRequest( "https://airnativeextensions.com" );
					var loader:URLLoader = new URLLoader();
					loader.addEventListener( Event.COMPLETE, loader_completeHandler );
					loader.load( request );
					
				}
				else
				{
					// Enable performance collection
					log( "Enable performance collection" );
					
					FirebasePerformance.service.setPerformanceCollectionEnabled( true );
					
				}
				
				
				
			}
			
			
			
			
			
			
		}
		

		private function loader_completeHandler( event:Event ):void
		{
			log( "loader complete" );
		}

		
	}
}

