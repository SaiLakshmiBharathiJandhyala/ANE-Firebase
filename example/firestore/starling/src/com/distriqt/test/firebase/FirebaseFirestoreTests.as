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
 * @brief
 * @author        "Michael Archbold (ma&#64;distriqt.com)"
 * @created        21/06/2016
 * @copyright    http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.core.Core;
	import com.distriqt.extension.firebase.Firebase;
	import com.distriqt.extension.firebase.FirebaseOptions;
	import com.distriqt.extension.firebase.firestore.CollectionReference;
	import com.distriqt.extension.firebase.firestore.DocumentChange;
	import com.distriqt.extension.firebase.firestore.DocumentReference;
	import com.distriqt.extension.firebase.firestore.DocumentSnapshot;
	import com.distriqt.extension.firebase.firestore.FieldValue;
	import com.distriqt.extension.firebase.firestore.FirebaseFirestore;
	import com.distriqt.extension.firebase.firestore.FirebaseFirestoreSettings;
	import com.distriqt.extension.firebase.firestore.MetadataChanges;
	import com.distriqt.extension.firebase.firestore.Query;
	import com.distriqt.extension.firebase.firestore.QueryDirection;
	import com.distriqt.extension.firebase.firestore.QuerySnapshot;
	import com.distriqt.extension.firebase.firestore.SetOptions;
	import com.distriqt.extension.firebase.firestore.SetOptions;
	import com.distriqt.extension.firebase.firestore.Source;
	import com.distriqt.extension.firebase.firestore.Transaction;
	import com.distriqt.extension.firebase.firestore.Transaction;
	import com.distriqt.extension.firebase.firestore.WriteBatch;
	import com.distriqt.extension.firebase.firestore.events.CollectionReferenceEvent;
	import com.distriqt.extension.firebase.firestore.events.DocumentReferenceEvent;
	import com.distriqt.extension.firebase.firestore.events.QueryEvent;
	import com.distriqt.extension.firebase.firestore.events.TransactionEvent;
	import com.distriqt.extension.firebase.firestore.events.WriteBatchEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.InvokeEvent;
	
	import flash.net.SharedObject;
	
	import flash.net.URLRequest;
	
	import flash.net.navigateToURL;
	
	import starling.events.Event;
	
	
	/**
	 *
	 */
	public class FirebaseFirestoreTests
	{
		public static const TAG:String = "FS";
		
		private var _l:ILogger;
		
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseFirestoreTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup( e:Event = null ):void
		{
			try
			{
				Core.init();
				Firebase.init( Config.distriqtApplicationKey );
				FirebaseFirestore.init( Config.distriqtApplicationKey );
				log( "Firebase Supported:     " + Firebase.isSupported );
				log( "Firestore Supported:    " + FirebaseFirestore.isSupported );
				
				if (Firebase.isSupported)
				{
					log( "Firebase Version:     " + Firebase.service.version );
					log( "Firestore Version:    " + FirebaseFirestore.service.version );
					
					var success:Boolean = Firebase.service.initialiseApp();
					
					log( "Firebase.service.initialiseApp() = " + success );
					if (!success)
					{
						log( "CHECK YOUR CONFIGURATION" );
					}
					
					FirebaseFirestore.service.addEventListener( ErrorEvent.ERROR, errorHandler );
					
				}
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		private function errorHandler( event:ErrorEvent ):void
		{
			log( "ERROR::" + event.text );
		}
		
		
		//
		//
		//	FIRESTORE
		//
		//
		
		
		public function getSettings():void
		{
			var settings:FirebaseFirestoreSettings = FirebaseFirestore.service.getFirestoreSettings();
			
			log( settings.toString() );
		}
		
		
		public function setSettings():void
		{
			var settings:FirebaseFirestoreSettings = FirebaseFirestore.service.getFirestoreSettings();
			settings.areTimestampsInSnapshotsEnabled = true;
//			settings.isPersistenceEnabled = false;
			
			FirebaseFirestore.service.setFirestoreSettings( settings );
		}
		
		
		
		//
		//	COLLECTIONS
		//
		
		
		public function collection_getInfo():void
		{
			var usersCollection:CollectionReference = FirebaseFirestore.service.collection( "users" );
			
			log( "id:   " + usersCollection.getId() );
			log( "path: " + usersCollection.getPath() );
			
			var parent:DocumentReference = usersCollection.getParent();
			log( "parent: " + (parent == null ? "null" : parent.getId() ) );
			
		}
		
		
		
		
		
		public function collection_add():void
		{
			log( "collection_add()" );
			var user:Object = {
				first: "Ada",
				last:  "Lovelace",
				born:  1815
			};
			
			var usersCollection:CollectionReference = FirebaseFirestore.service.collection( "users" );
			usersCollection.addEventListener( CollectionReferenceEvent.ADD_SUCCESS, collection_addSuccessHandler );
			usersCollection.addEventListener( CollectionReferenceEvent.ADD_ERROR, collection_addErrorHandler );
			usersCollection
					.add( user )
					.addOnSuccessListener( function( document:DocumentReference ):void
					{
						log( "addOnSuccessListener: document.getId()   = " + document.getId() );
						log( "addOnSuccessListener: document.getPath() = " + document.getPath() );
					})
					.addOnFailureListener( function( message:String ):void
					{
						log( "addOnFailureListener: " + message );
					});
		}
		
		private function collection_addSuccessHandler( event:CollectionReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_SUCCESS, collection_addSuccessHandler );
			event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_ERROR, collection_addErrorHandler );
			
			log( "Add Success: document.getId()   = " + event.document.getId() );
			log( "Add Success: document.getPath() = " + event.document.getPath() );
			
			_testDocumentPath = event.document.getPath();
		}
		
		private function collection_addErrorHandler( event:CollectionReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_SUCCESS, collection_addSuccessHandler );
			event.currentTarget.removeEventListener( CollectionReferenceEvent.ADD_ERROR, collection_addErrorHandler );
			
			log( "Add Error: " + event.message );
		}
		
		
		
		
		
		//
		//	QUERY
		//
		
		
		public function collection_allValues():void
		{
			log( "collection_allValues" );
			
			FirebaseFirestore.service.collection("users").addEventListener( QueryEvent.SUCCESS, collection_querySuccessHandler );
			
			try
			{
				var query:Query = FirebaseFirestore.service.collection("users");
				
				query.addEventListener( QueryEvent.SUCCESS, querySuccessHandler );
				query.addEventListener( QueryEvent.ERROR, queryErrorHandler );
				
				query.query()
						.addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
						{
							log( "addOnQuerySuccessHandler" );
						})
						.addOnQueryFailureListener( function( message:String ):void
						{
							log( "addOnQueryFailureListener: " + message );
						});
			}
			catch (e:Error)
			{
				log( "ERROR: " + e.message );
			}
		}
		
		private function collection_querySuccessHandler( event:QueryEvent ):void
		{
			log( "collection_querySuccessHandler" );
			event.currentTarget.removeEventListener( QueryEvent.SUCCESS, collection_querySuccessHandler );
		}

		private function querySuccessHandler( event:QueryEvent ):void
		{
			log( "querySuccessHandler" );
			event.currentTarget.removeEventListener( QueryEvent.SUCCESS, querySuccessHandler );
			event.currentTarget.removeEventListener( QueryEvent.ERROR, queryErrorHandler );
		}
		
		private function queryErrorHandler( event:QueryEvent ):void
		{
			log( "queryErrorHandler" );
			event.currentTarget.removeEventListener( QueryEvent.SUCCESS, querySuccessHandler );
			event.currentTarget.removeEventListener( QueryEvent.ERROR, queryErrorHandler );
		}
		
		
		//
		//	QUERY COMPLEX
		//
		
		
		public function query_limit():void
		{
			log( "query_limit" );
			
			var query:Query = FirebaseFirestore.service.collection("users")
					.limit( 5 )
					.orderBy( "last", QueryDirection.ASCENDING )
			;
			
			query.addEventListener( QueryEvent.SUCCESS, query_successHandler );
			query.addEventListener( QueryEvent.ERROR, query_errorHandler );
			
			query.query()
					.addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
					{
						log( "addOnQuerySuccessHandler" );
					})
					.addOnQueryFailureListener( function( message:String ):void
					{
						log( "addOnQueryFailureListener: " + message );
					});
		}
		
		
		
		public function query_where():void
		{
			log( "query_where" );
			
			var query:Query = FirebaseFirestore.service.collection("users")
					.limit( 5 )
					.orderBy( "born", QueryDirection.ASCENDING )
					.whereGreaterThanOrEqualTo( "born", 1900 )
					.whereLessThanOrEqualTo( "born", 2000 );
			;
			
			query.addEventListener( QueryEvent.SUCCESS, query_successHandler );
			query.addEventListener( QueryEvent.ERROR, query_errorHandler );
			
			query.query()
					.addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
					{
						log( "addOnQuerySuccessHandler" );
					})
					.addOnQueryFailureListener( function( message:String ):void
					{
						log( "addOnQueryFailureListener: " + message );
					});
		}
		
		
		public function query_startAt():void
		{
			log( "query_startAt" );
			
			var query:Query = FirebaseFirestore.service.collection("users")
					.orderBy("born")
					.orderBy("last")
					.startAt(1900, "A")
			;
			
			query.addEventListener( QueryEvent.SUCCESS, query_successHandler );
			query.addEventListener( QueryEvent.ERROR, query_errorHandler );
			
			query.query()
					.addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
					{
						log( "addOnQuerySuccessHandler" );
					})
					.addOnQueryFailureListener( function( message:String ):void
					{
						log( "addOnQueryFailureListener: " + message );
					});
		}
		
		
		public function query_error():void
		{
			log( "query_error" );
			
			var query:Query = FirebaseFirestore.service.collection("users")
					.limit( 5 )
					.orderBy( "last", QueryDirection.ASCENDING )
					.whereGreaterThanOrEqualTo( "born", 2000 )
			;
			
			query.addEventListener( QueryEvent.SUCCESS, query_successHandler );
			query.addEventListener( QueryEvent.ERROR, query_errorHandler );
			
			query.query()
					.addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
					{
						log( "addOnQuerySuccessHandler" );
					})
					.addOnQueryFailureListener( function( message:String ):void
					{
						log( "addOnQueryFailureListener: " + message );
					});
		}
		
		private function query_successHandler( event:QueryEvent ):void
		{
			log( "query_successHandler" );
			event.currentTarget.removeEventListener( QueryEvent.SUCCESS, query_successHandler );
			event.currentTarget.removeEventListener( QueryEvent.ERROR, query_errorHandler );
		}
		
		private function query_errorHandler( event:QueryEvent ):void
		{
			log( "query_errorHandler: " + event.message );
			event.currentTarget.removeEventListener( QueryEvent.SUCCESS, query_successHandler );
			event.currentTarget.removeEventListener( QueryEvent.ERROR, query_errorHandler );
		}
		
		
		
		//
		//	QUERY UPDATES
		//
		
		public function query_listenUpdates():void
		{
			log( "query_listenUpdates" );
			FirebaseFirestore.service.collection( "users" )
					.addSnapshotListener( query_snapshotEventHandler, MetadataChanges.INCLUDE );
		}
		
		public function query_removeUpdates():void
		{
			log( "query_removeUpdates" );
			FirebaseFirestore.service.collection( "users" )
					.removeSnapshotListener( query_snapshotEventHandler );
		}
		
		
		private function query_snapshotEventHandler( event:QueryEvent ):void
		{
			var snapshot:QuerySnapshot = event.snapshot;
			if (event.message && event.message != "")
			{
				log( "Error query: " + event.message );
			}
			else
			{
				if (snapshot != null)
				{
					log( "query_snapshotEventHandler: " );
					log( "   hasPendingWrites: " + snapshot.getMetadata().hasPendingWrites );
					
					for each (var doc:DocumentSnapshot in event.snapshot.getDocuments())
					{
						trace( "   doc: " + JSON.stringify(doc.getData()) );
					}
					
					for each (var docChange:DocumentChange in event.snapshot.getDocumentChanges())
					{
						trace( "   change type: " + docChange.changeType );
						switch (docChange.changeType)
						{
							case DocumentChange.ADDED:
							case DocumentChange.MODIFIED:
							case DocumentChange.REMOVED:
								//
						}
					}
					
				}
			}
		}
		

		
		
		
		//
		//	DOCUMENTS
		//
		
		
		public function document_listenUpdates():void
		{
			var document:DocumentReference = FirebaseFirestore.service.document( _testDocumentPath );
			document.addSnapshotListener( document_snapshotEventHandler, MetadataChanges.INCLUDE );
		}
		
		public function document_removeUpdates():void
		{
			FirebaseFirestore.service.document( _testDocumentPath )
				.removeSnapshotListener( document_snapshotEventHandler );
		}
		
		
		private function document_snapshotEventHandler( event:DocumentReferenceEvent ):void
		{
			var snapshot:DocumentSnapshot = event.snapshot;
			if (event.message != "")
			{
				log( "Error fetching document: " + event.message );
			}
			else
			{
				if (snapshot != null && snapshot.exists())
				{
					log( "document_snapshotEventHandler: " );
					log( "   hasPendingWrites: " + snapshot.getMetadata().hasPendingWrites );
					log( "   " + JSON.stringify( snapshot.getData() ) );
				}
			}
		}

		
		
		
		
		public function document_dataTypeTest():void
		{
			var data:Object = {
				stringExample: "Hello world!",
				booleanExample: true,
				numberExample: 3.14159265,
				dateExample: new Date().time,
				arrayExample: [ 1, 2, 3 ],
				nestedData: {
					a: 5,
					b: true
				},
				nullExample: null
			};
			
			
			
			var document:DocumentReference = FirebaseFirestore.service.collection("data").document("one");
			
			document.setDocument( data )
					.addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
					{
						log( "data type test :: success" );
						
						FirebaseFirestore.service.collection("data")
								.document("one")
								.getDocument()
								.addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
								{
									log( "get document :: success" );
								})
								.addOnFailureListener( function( message:String ):void
								{
									log( "get document :: failed :: " + message );
								});
					})
					.addOnFailureListener( function( message:String ):void
					{
						log( "data type test :: failed :: " + message );
					});
		}
		
		
		
		private var _testDocumentPath:String = "users/y6uqertewert";
		
		public function document_get():void
		{
			log( "document_get()" );
			var document:DocumentReference = FirebaseFirestore.service.document( _testDocumentPath );
			
			document.addEventListener( DocumentReferenceEvent.GET_SUCCESS, document_getDocumentSuccessHandler );
			document.addEventListener( DocumentReferenceEvent.GET_ERROR, document_getDocumentErrorHandler );
			document.getDocument()
					.addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
					{
						log( "addOnSuccessListener: " );
						if (snapshot.exists())
						{
							log( JSON.stringify( snapshot.getData() ) );
						}
					})
					.addOnFailureListener( function( message:String ):void
					{
						log( "addOnFailureListener: " + message );
					});
		}
		
		private function document_getDocumentSuccessHandler( event:DocumentReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_SUCCESS, document_getDocumentSuccessHandler );
			event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_ERROR, document_getDocumentErrorHandler );
			
			if (event.snapshot.exists())
			{
				log( "Get Document: DATA: " );
				log( JSON.stringify( event.snapshot.getData() ) );
			}
			else
			{
				log( "Get Document: Does not exist" );
			}
		}
		
		private function document_getDocumentErrorHandler( event:DocumentReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_SUCCESS, document_getDocumentSuccessHandler );
			event.currentTarget.removeEventListener( DocumentReferenceEvent.GET_ERROR, document_getDocumentErrorHandler );
			
			log( "Get Document Error: " + event.message );
		}
		
		
		
		
		
		
		
		public function document_set():void
		{
			log( "document_set()" );
			
			var user:Object = {
				title: "Mr",
				first: "Joe",
				last:  "Cook",
				born:  1915,
				count: Math.random() * 1000,
				likes: [ "movies", "snowboarding", "architecture" ]
			};
			
			var document:DocumentReference = FirebaseFirestore.service.document( _testDocumentPath );
			
			document.addEventListener( DocumentReferenceEvent.SET_SUCCESS, document_setDocumentSuccessHandler );
			document.addEventListener( DocumentReferenceEvent.SET_ERROR, document_setDocumentErrorHandler );
			document.setDocument( user )
					.addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
					{
						log( "addOnSuccessListener: " );
					})
					.addOnFailureListener( function( message:String ):void
					{
						log( "addOnFailureListener: " + message );
					});
		}
		
		private function document_setDocumentSuccessHandler( event:DocumentReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_SUCCESS, document_setDocumentSuccessHandler );
			event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_ERROR, document_setDocumentErrorHandler );
			
			log( "Set Document: Success" );
		}
		
		private function document_setDocumentErrorHandler( event:DocumentReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_SUCCESS, document_setDocumentSuccessHandler );
			event.currentTarget.removeEventListener( DocumentReferenceEvent.SET_ERROR, document_setDocumentErrorHandler );
			
			log( "Get Document Error: " + event.message );
		}
		
		
		public function document_update():void
		{
			log( "document_update()" );
			
			var changes:Object = {
				born:  2012,
				time: FieldValue.serverTimestamp(),
				likes: FieldValue.deleteValue()
//				likes: FieldValue.arrayRemove("movies")
			};
			
			var document:DocumentReference = FirebaseFirestore.service.document( _testDocumentPath );
			
			document.addEventListener( DocumentReferenceEvent.UPDATE_SUCCESS, document_updateSuccessHandler );
			document.addEventListener( DocumentReferenceEvent.UPDATE_ERROR, document_updateErrorHandler );
			document.update( changes )
					.addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
					{
						log( "addOnSuccessListener: " );
					})
					.addOnFailureListener( function( message:String ):void
					{
						log( "addOnFailureListener: " + message );
					});
		}
		
		private function document_updateSuccessHandler( event:DocumentReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_SUCCESS, document_updateSuccessHandler );
			event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_ERROR, document_updateErrorHandler );
			
			log( "Update Document: Success" );
		}
		
		private function document_updateErrorHandler( event:DocumentReferenceEvent ):void
		{
			event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_SUCCESS, document_updateSuccessHandler );
			event.currentTarget.removeEventListener( DocumentReferenceEvent.UPDATE_ERROR, document_updateErrorHandler );
			
			log( "Update Document Error: " + event.message );
		}
		
		
		
		
		
		public function document_createAndSet():void
		{
			log( "document_createAndSet()" );
			var user:Object = {
				title: "Mr",
				first: "Antonio",
				last:  "Grit",
				born:  1915
			};
			
			var document:DocumentReference = FirebaseFirestore.service.collection("users").document();
			
			_testDocumentPath = document.getPath();
			
			log( "document_createAndSet(): " + _testDocumentPath );
			
			document.addEventListener( DocumentReferenceEvent.SET_SUCCESS, document_setDocumentSuccessHandler );
			document.addEventListener( DocumentReferenceEvent.SET_ERROR, document_setDocumentErrorHandler );
			
			document.setDocument( user )
					.addOnSuccessListener( function( snapshot:DocumentSnapshot ):void
					{
						log( "addOnSuccessListener: " );
					})
					.addOnFailureListener( function( message:String ):void
					{
						log( "addOnFailureListener: " + message );
					});
		}
		
		
		
		public function document_delete():void
		{
			log("document_delete()" );
			
			FirebaseFirestore.service.document(_testDocumentPath)
					.deleteDocument();
		}
		
	
		
		//
		//	PAGINATION
		//
		
		
		public function pagination():void
		{
			// NOT WORKING YET
			
			var first:Query = FirebaseFirestore.service.collection("users")
					.orderBy("born")
					.limit(5);
			
			first.query()
					.addOnQuerySuccessHandler( function( snapshot:QuerySnapshot ):void
					{
						// Get the last visible document
						var lastVisible:DocumentSnapshot = snapshot.getDocuments()[ snapshot.size - 1 ];
						
						var next:Query = FirebaseFirestore.service.collection("users")
								.orderBy("born")
								.startAtSnapshot(lastVisible)
								.limit(5);
						
						// Use the query for pagination
						// ...
					});
		}
		
		
		
		
		//
		//	TRANSACTIONS
		//
		
		public function transaction():void
		{
			var user:DocumentReference = FirebaseFirestore.service.document(_testDocumentPath);
			
			var transaction:Transaction = FirebaseFirestore.service.runTransaction(
					function( transaction:Transaction ):void
					{
						log( "apply( transaction )" );
						transaction.getDocument( user, function( snapshot:DocumentSnapshot, message:String ):void
						{
							log( "transaction getDocument complete" );
							if (snapshot != null) log( "snapshot: " + JSON.stringify(snapshot.getData()) );
							log( "message: " + message );
							
							var data:Object = { first: "James", update: "transaction" };
							transaction.setDocument( user, data, SetOptions.merge(), function( snapshot:DocumentSnapshot, message:String ):void
							{
								log( "transaction setDocument complete: " + message == null ? "null" : message );
								transaction.update( user, { count: Math.random()*10000 }, function( snapshot:DocumentSnapshot, message:String ):void
								{
									log( "transaction update complete: " + message == null ? "null" : message );
									transaction.finish();
								});
							});
						});
					}
			);
			
			transaction.addEventListener( TransactionEvent.SUCCESS, transaction_successHandler );
			transaction.addEventListener( TransactionEvent.FAILED, transaction_failedHandler );
		}
		
		private function transaction_successHandler( event:TransactionEvent ):void
		{
			log( "transaction_successHandler: " + (event.data == null ? "null" : String(event.data)) );
			
			event.currentTarget.removeEventListener( TransactionEvent.SUCCESS, transaction_successHandler );
			event.currentTarget.removeEventListener( TransactionEvent.FAILED, transaction_failedHandler );
		}
		
		private function transaction_failedHandler( event:TransactionEvent ):void
		{
			log( "transaction_failedHandler: " + event.message );
			
			event.currentTarget.removeEventListener( TransactionEvent.SUCCESS, transaction_successHandler );
			event.currentTarget.removeEventListener( TransactionEvent.FAILED, transaction_failedHandler );
		}
		
		
		
		public function transaction_example():void
		{
			var user:DocumentReference = FirebaseFirestore.service.document( _testDocumentPath );
			
			var transaction:Transaction = FirebaseFirestore.service.runTransaction(
					function( transaction:Transaction ):void
					{
						// Read the user document reference
						transaction.getDocument( user, function( snapshot:DocumentSnapshot, message:String ):void
						{
							if (snapshot == null)
							{
								// Error
								transaction.abort();
							}
							else
							{
								// Get the user's current count
								var currentCount:Number = snapshot.getData().count;
								var newCount:Number = currentCount + 1;
								
								// Change the first name with a setDocument merge
								var data:Object = { first: "James" };
								transaction.setDocument( user, data, SetOptions.merge(), function( snapshot:DocumentSnapshot, message:String ):void
								{
									// Update count
									transaction.update( user, { count: newCount }, function( snapshot:DocumentSnapshot, message:String ):void
									{
										// Finish the transaction - returning the new count
										transaction.finish( newCount );
									});
								});
							}
						});
					}
			);
			
			transaction.addEventListener( TransactionEvent.SUCCESS, transaction_successHandler );
			transaction.addEventListener( TransactionEvent.FAILED, transaction_failedHandler );
		}
		
		
		
		
		
		public function batch():void
		{
			var user:DocumentReference = FirebaseFirestore.service.document(_testDocumentPath);
			
			try
			{
				var batch:WriteBatch = FirebaseFirestore.service.batch();
				
				batch.update( user, { count: Math.random()*10000 } );
				batch.setDocument( user, { first: "Hector", update: "batch"}, SetOptions.merge() );
				
				batch.addEventListener( WriteBatchEvent.SUCCESS, batch_successHandler );
				batch.addEventListener( WriteBatchEvent.FAILED, batch_failedHandler );
				
				batch.commit();
			}
			catch (e:Error)
			{
				log( "batch error: " + e.message );
			}
		}
		
		private function batch_successHandler( event:WriteBatchEvent ):void
		{
			log( "batch_successHandler" );
			
			event.currentTarget.removeEventListener( WriteBatchEvent.SUCCESS, batch_successHandler );
			event.currentTarget.removeEventListener( WriteBatchEvent.FAILED, batch_failedHandler );
		}
		
		private function batch_failedHandler( event:WriteBatchEvent ):void
		{
			log( "batch_failedHandler: " + event.message );
			
			event.currentTarget.removeEventListener( WriteBatchEvent.SUCCESS, batch_successHandler );
			event.currentTarget.removeEventListener( WriteBatchEvent.FAILED, batch_failedHandler );
		}
		
	}
	
}
