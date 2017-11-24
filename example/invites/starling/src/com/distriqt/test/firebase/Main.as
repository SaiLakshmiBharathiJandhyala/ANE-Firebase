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
		
		private var _tests:FirebaseInvitesTests;
		private var _gid:GoogleIdentityHelper;

		private var _container:ScrollContainer;
		private var _text:TextField;
		
		
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
			_text = new TextField( stage.stageWidth, stage.stageHeight, "", "_typewriter", 18, Color.WHITE );
			_text.hAlign = HAlign.LEFT; 
			_text.vAlign = VAlign.TOP;
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			layout.gap = 5;
			
			_container = new ScrollContainer();
			_container.y = 50;
			_container.layout = layout;
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight-50;
			
			_tests = new FirebaseInvitesTests( this );
			_gid = new GoogleIdentityHelper( this );
			
			addAction( "Setup :Core", _tests.setup );
			
			addAction( "Generate Link :DynamicLinks", _tests.generateLink );
			addAction( "Generate Short Link :DynamicLinks", _tests.generateShortLink );
			addAction( "Open Link :DynamicLinks", _tests.openLink );
			
			addAction( "Listen :Receive", _tests.listenForLinks );
			
			addAction( "Send Invite :Invites", _tests.sendInvite );
			addAction( "Listen :Invites", _tests.listenForInvites );
			
			addAction( "----------", null );
			
			addAction( "Setup :GoogleIdentity", _gid.setup );
			addAction( "Sign In :GoogleIdentity", _gid.signIn );
			
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