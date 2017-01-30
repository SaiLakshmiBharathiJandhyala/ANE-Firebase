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
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
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

		private var _buttons	: Vector.<Button>;
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
			_tests = new FirebaseDatabaseTests( this );
		}
		
		
		private function createUI():void
		{
			_text = new TextField( stage.stageWidth, stage.stageHeight, "", "_typewriter", 18, Color.WHITE );
			_text.hAlign = HAlign.LEFT; 
			_text.vAlign = VAlign.TOP;
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.gap = 5;
			var container:ScrollContainer = new ScrollContainer();
			container.layout = layout;
			container.width = stage.stageWidth;
			container.height = stage.stageHeight-50;
			
			_buttons = new Vector.<Button>();
			
			addAction( "Setup :Core", _tests.setup );
			
			addAction( "setValue String 1 :Database", _tests.setValueString );
			addAction( "setValue String 2 :Database", _tests.setValueString2 );
			addAction( "setValue int :Database", _tests.setValueNumber );
			addAction( "setValue null :Database", _tests.setValue_null );
			
			
			addAction( "rootParentTest :Datbase", _tests.rootParentTest );
			
			addAction( "updateChildren :Database", _tests.updateChildren );
			addAction( "updateChildren null :Database", _tests.updateChildren_null );
			
			addAction( "removeValue :Database", _tests.removeValue );
			
			addAction( "readValue :Database", _tests.readValue );
			
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
			
			
			addChild( _text );
			for each (var button:Button in _buttons)
			{
				container.addChild(button);
			}
			addChild( container );
		}
		
		
		private function addAction( label:String, listener:Function ):void
		{
			var b:Button = new Button();
			b.label = label;
			b.addEventListener( starling.events.Event.TRIGGERED, listener );
			_buttons.push( b );
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
			new MetalWorksMobileTheme();
			init();
			createUI();
		}
		
		
	}
}