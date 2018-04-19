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
 * @file   		Main.as
 * @brief  		
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		08/01/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	
	/**	
	 * 
	 */
	public class Main extends Sprite implements ILogger
	{
		////////////////////////////////////////////////////////
		//	CONSTANTS
		//
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _tests		: FirebaseDatabaseTests;
		
		private var _container:ScrollContainer;
		private var _text		: TextField;
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		/**
		 *  Constructor
		 */
		public function Main()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		
		public function log( tag:String, message:String ):void
		{
			trace( tag+"::"+message );
			if (_text)
				_text.text = tag+"::"+message + "\n" + _text.text ;
		}
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		private function init():void
		{
			var tf:TextFormat = new TextFormat( "_typewriter", 12, Color.WHITE, HorizontalAlign.LEFT, VerticalAlign.TOP );
			_text = new TextField( stage.stageWidth, stage.stageHeight, "", tf );
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.RIGHT;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.gap = 5;
			
			_container = new ScrollContainer();
			_container.y = 50;
			_container.layout = layout;
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight-50;
			
			_tests = new FirebaseDatabaseTests( this );
			
			addAction( "Setup :Core", _tests.setup );
			
			addAction( "connected :Database", _tests.connectedListener );
			
			addAction( "getKey :Database", _tests.getKey );
			
			addAction( "setValue String 1 :Database", _tests.setValueString );
			addAction( "setValue String 2 :Database", _tests.setValueString2 );
			addAction( "setValue int :Database", _tests.setValueNumber );
			addAction( "setValue complex :Database", _tests.setValueComplex );
			addAction( "setValue null :Database", _tests.setValue_null );
			addAction( "setValue ServerValue :Database", _tests.setValue_serverValue );
			
			
			addAction( "rootParentTest :Datbase", _tests.rootParentTest );
			
			addAction( "updateChildren :Database", _tests.updateChildren );
			addAction( "updateChildren null :Database", _tests.updateChildren_null );
			addAction( "updateChildren stress :Database", _tests.updateChildren_stress );
			addAction( "updateChildren stress 2 :Database", _tests.updateChildren_stress_2 );
			
			addAction( "removeValue :Database", _tests.removeValue );
			
			addAction( "readValue :Database", _tests.readValue );
			addAction( "once :Database", _tests.once );
			
			addAction( "transaction :Database", _tests.transaction );
			
			addAction( "push :Lists", _tests.push );
			
			addAction( "orderByChild :Query", _tests.orderByChild );
			addAction( "orderByKey :Query", _tests.orderByKey );
			addAction( "orderByPriority :Query", _tests.orderByPriority );
			addAction( "orderByValue :Query", _tests.orderByValue );
			
			addAction( "general query :Query", _tests.generalQueryTest );
			
			addAction( "clear query :Query", _tests.clearQuery );
			
			addAction( "trigger GC", _tests.triggerGC );
			addAction( "disposeUnusedReferences", _tests.disposeUnusedReferences );
			
			
			addAction( "setValue :OnDisconnect", _tests.disconnectSetValue );
			
			
			addChild( _text );
			addChild( _container );
		}
		
		
		private function addAction( label:String, listener:Function, parent:Sprite=null ):void
		{
			var b:Button = new Button();
			b.label = label;
			if (listener != null)
				b.addEventListener( starling.events.Event.TRIGGERED, listener );
			else
				b.isEnabled = false;
			
			if (parent != null) parent.addChild( b );
			else if (_container != null) _container.addChild( b );
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
			new MetalWorksMobileTheme();
			init();
		}
		
		
	}
}