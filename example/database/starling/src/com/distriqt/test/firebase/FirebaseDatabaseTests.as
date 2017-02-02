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
 * @file   		FirebaseCoreTests.as
 * @brief  		
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		21/06/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.firebase.Firebase;
	import com.distriqt.extension.firebase.database.DataSnapshot;
	import com.distriqt.extension.firebase.database.DatabaseReference;
	import com.distriqt.extension.firebase.database.FirebaseDatabase;
	import com.distriqt.extension.firebase.database.Query;
	import com.distriqt.extension.firebase.database.builders.UpdateChildrenBuilder;
	import com.distriqt.extension.firebase.database.events.DatabaseReferenceChildEvent;
	import com.distriqt.extension.firebase.database.events.DatabaseReferenceEvent;
	
	import flash.system.System;
	
	import starling.events.Event;
	
	/**	
	 * 
	 */
	public class FirebaseDatabaseTests
	{
		public static const TAG : String = "DB";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseDatabaseTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup(e:Event=null):void
		{
			try
			{
				Firebase.init( Config.distriqtApplicationKey );
				FirebaseDatabase.init( Config.distriqtApplicationKey );
				log( "Firebase Supported: " + Firebase.isSupported );
				log( "Database Supported: " + FirebaseDatabase.isSupported );
				
				if (Firebase.isSupported)
				{
					log( "Firebase Version:   " + Firebase.service.version );
					
					var success:Boolean = Firebase.service.initialiseApp();
					log( "Firebase.service.initialiseApp() = " + success );
					if (!success)
					{
						log( "CHECK YOUR CONFIGURATION" );
					}
				}
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		public function triggerGC():void 
		{
			System.gc();
			System.gc();
		}
		
		
		public function disposeUnusedReferences():void 
		{
			try
			{
				FirebaseDatabase.service.disposeUnusedReferences();
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		//
		//
		//	DATABASE
		//
		//		
		
		
		////////////////////////////////////////////////////////
		//	SET VALUES
		//

		public function setValueString():void 
		{
			log( "setValueString()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );
				
				var value:String = "a string value "+String(Math.floor(Math.random()*1000)); 
				
				ref.child("stringValue").setValue( value );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		public function setValueString2():void 
		{
			log( "setValueString2()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test2" );
				
				var value:String = "a string value "+String(Math.floor(Math.random()*1000)); 
				
				ref.child("stringValue").setValue( value );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		public function setValueNumber():void 
		{
			log( "setValueNumber()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );
				
				var value:Number = Math.floor(Math.random()*1000);
				
				ref.child("numericValue").setValue( value );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		public function setValue_null():void 
		{
			log( "setValue_null()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );
				ref.setValue( null );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		
		////////////////////////////////////////////////////////
		//	ROOT / PARENT TESTS
		//
		
		public function rootParentTest():void 
		{
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" ).child("testChild");
				
				ref.getRoot().child( "rootTest" ).setValue( "success" );
				ref.getParent().child( "parentTest" ).setValue( "success" );
				
				if (ref.getRoot().getParent() == null)
				{
					log( "root.getParent() is null" );
				}
				else 
				{
					log( "root.getParent() is NOT null" );
				}
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//	UPDATING CHILDREN
		//

		public function updateChildren():void 
		{
			log( "updateChildren()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );
				
				ref.updateChildren( 
					new UpdateChildrenBuilder()
						.update( "/children_test/numericValue", Math.floor(Math.random()*1000) )
						.update( "/children_test/stringValue", "a string value "+String(Math.floor(Math.random()*1000)) )
						.build()
				);
				
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		public function updateChildren_null():void 
		{
			log( "updateChildren_null()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );
				
				ref.updateChildren( 
					new UpdateChildrenBuilder()
						.update( "/children_test/numericValue", null )
						.update( "/children_test/stringValue", null )
						.build()
				);
				
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		
		////////////////////////////////////////////////////////
		//	REMOVE VALUE
		//
		
		public function removeValue():void
		{
			log( "removeValue()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );
				ref.addEventListener( DatabaseReferenceEvent.REMOVE_VALUE_COMPLETE, removeCompleteHandler );
				ref.addEventListener( DatabaseReferenceEvent.REMOVE_VALUE_ERROR, removeErrorHandler );
				ref.removeValue();
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		private function removeCompleteHandler( event:DatabaseReferenceEvent ):void 
		{
			log( "removeCompleteHandler" );
		}
		
		private function removeErrorHandler( event:DatabaseReferenceEvent ):void 
		{
			log( "removeErrorHandler: ["+event.errorCode+"] "+event.errorDescription );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	VALUE CHANGE EVENTS
		//
		
		public function readValue():void 
		{
			log("readValue()");
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" );
				
				ref.addEventListener( DatabaseReferenceEvent.VALUE_CHANGED, database_valueChangedHandler );
				
				ref.child("numericValue").addEventListener( DatabaseReferenceEvent.VALUE_CHANGED, database_valueChangedHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		private function database_valueChangedHandler( event:DatabaseReferenceEvent ):void 
		{
			log( "database_valueChangedHandler(): "+event.snapshot.toString() );
			
//			FirebaseDatabase.service.getReference( "test" ).removeEventListener( DatabaseReferenceEvent.VALUE_CHANGED, database_valueChangedHandler );
		}
			
		
		
		////////////////////////////////////////////////////////
		//	TRANSACTIONS
		//
		
		public function transaction():void 
		{
			log( "transaction()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "test" ).child( "count" );
				
				ref.addEventListener( DatabaseReferenceEvent.TRANSACTION_COMPLETE, transactionCompleteHandler );
				ref.addEventListener( DatabaseReferenceEvent.TRANSACTION_ERROR, transactionErrorHandler );
				
				ref.runTransaction( new CountTransactionHandler() );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		private function transactionCompleteHandler( event:DatabaseReferenceEvent ):void 
		{
			log( "transaction complete" );
		
			event.currentTarget.removeEventListener( DatabaseReferenceEvent.TRANSACTION_COMPLETE, transactionCompleteHandler );
			event.currentTarget.removeEventListener( DatabaseReferenceEvent.TRANSACTION_ERROR, transactionErrorHandler );
			
		}
		
		private function transactionErrorHandler( event:DatabaseReferenceEvent ):void 
		{
			log( "transaction error: ["+ event.errorCode + "]:"+event.errorDescription );

			event.currentTarget.removeEventListener( DatabaseReferenceEvent.TRANSACTION_COMPLETE, transactionCompleteHandler );
			event.currentTarget.removeEventListener( DatabaseReferenceEvent.TRANSACTION_ERROR, transactionErrorHandler );
		}
		
		
		
		////////////////////////////////////////////////////////
		//	LISTS 
		//
		
		public function push():void 
		{
			log( "push()" );
			try
			{
				var ref:DatabaseReference = FirebaseDatabase.service.getReference( "list" );
				
//				ref.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, childEventHandler );
				
				
				var item:DatabaseReference = ref.push();
				
//				item.child("name").setValue( "a pushed item" );
//				item.child("count").setValue( Math.floor(Math.random()*1000) );
				
				item.setValue( {
					name: "a pushed item",
					count: Math.floor(Math.random()*1000)
				});
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
//		private function childEventHandler( event:DatabaseReferenceChildEvent ):void
//		{
//			log( event.type+"::"+event.snapshot.key +"::"+event.previousChildName +"::"+JSON.stringify(event.snapshot.value) );
//			event.currentTarget.removeEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, childEventHandler );
//		}
		
		
		private var _query:Query;
		
		public function orderByKey():void 
		{
			log( "orderByKey()" );
			try
			{
				clearQuery();
				_query = FirebaseDatabase.service.getReference( "list" ).orderByKey();
				_query.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, query_childAddedHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		public function orderByChild():void 
		{
			log( "orderByChild()" );
			try
			{
				clearQuery();
				_query = FirebaseDatabase.service.getReference( "list" ).orderByChild( "count" );
				_query.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, query_childAddedHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		public function orderByPriority():void 
		{
			log( "orderByPriority()" );
			try
			{
				clearQuery();
				_query = FirebaseDatabase.service.getReference( "list" ).orderByPriority();
				_query.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, query_childAddedHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		public function orderByValue():void 
		{
			log( "orderByValue()" );
			try
			{
				clearQuery();
				_query = FirebaseDatabase.service.getReference( "list" ).orderByValue();
				_query.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, query_childAddedHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
			
		private function query_childAddedHandler( event:DatabaseReferenceChildEvent ):void
		{
			log( event.type+"::"+event.snapshot.key +"::"+event.previousChildName +"::"+JSON.stringify(event.snapshot.value) );
//			event.currentTarget.removeEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, childEventHandler );
		}
		
		private function query_valueChangedHandler( event:DatabaseReferenceEvent ):void
		{
			log( event.type+"::"+event.snapshot.key +"::"+JSON.stringify(event.snapshot.value) );
			for each (var child:DataSnapshot in event.snapshot.children)
			{
				log( JSON.stringify( child.value ));
			}
		}
		
		
		public function clearQuery():void 
		{
			if (_query != null)
			{
				_query.removeEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, query_childAddedHandler );
				_query = null;
			
				FirebaseDatabase.service.disposeUnusedReferences();
			}
		}
		
		
		
		public function generalQueryTest():void 
		{
			try
			{
				clearQuery();
				_query = FirebaseDatabase.service.getReference( "list" ).orderByChild("count").startAt(400, "count").limitToFirst(5);
				_query.addEventListener( DatabaseReferenceChildEvent.CHILD_ADDED, query_childAddedHandler );
				_query.addEventListener( DatabaseReferenceEvent.VALUE_CHANGED, query_valueChangedHandler );
			}
			catch (e:Error)
			{
			}
		}
		
		
		
		
		
	}
}
