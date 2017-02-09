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
	import com.distriqt.extension.firebase.storage.DownloadTask;
	import com.distriqt.extension.firebase.storage.FirebaseStorage;
	import com.distriqt.extension.firebase.storage.StorageMetadata;
	import com.distriqt.extension.firebase.storage.StorageReference;
	import com.distriqt.extension.firebase.storage.UploadTask;
	import com.distriqt.extension.firebase.storage.events.DownloadTaskEvent;
	import com.distriqt.extension.firebase.storage.events.StorageReferenceEvent;
	import com.distriqt.extension.firebase.storage.events.UploadTaskEvent;
	
	import flash.display.Loader;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import feathers.controls.ImageLoader;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**	
	 * 
	 */
	public class FirebaseStorageTests extends Sprite
	{
		public static const TAG : String = "ST";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseStorageTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup(e:Event=null):void
		{
			try
			{
				Firebase.init( Config.distriqtApplicationKey );
				FirebaseStorage.init( Config.distriqtApplicationKey );
				log( "Firebase Supported: " + Firebase.isSupported );
				log( "Storage Supported: " + FirebaseStorage.isSupported );
				
				if (Firebase.isSupported)
				{
					log( "Firebase Version:   " + Firebase.service.version );
					log( "Firebase Storage Version:   " + FirebaseStorage.service.version );
					
					var success:Boolean = Firebase.service.initialiseApp();
					log( "Firebase.service.initialiseApp() = " + success );
					if (!success)
					{
						log( "CHECK YOUR CONFIGURATION" );
					}
				}
				
				var sourceDir:File = File.applicationDirectory.resolvePath( "assets" );
				var destinationDir:File = File.applicationStorageDirectory.resolvePath( "assets" );
				sourceDir.copyTo( destinationDir, true );
				
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		public function printTimes():void 
		{
			log( "getMaxDownloadRetryTime  = "+FirebaseStorage.service.getMaxDownloadRetryTime() );
			log( "getMaxOperationRetryTime = "+FirebaseStorage.service.getMaxOperationRetryTime() );
			log( "getMaxUploadRetryTime    = "+FirebaseStorage.service.getMaxUploadRetryTime() );
		}
		
		
		//
		//
		//	REFERENCE DETAILS
		//
		//
		
		public function printReferenceInfo():void 
		{
			log( "printReferenceInfo()" );
			try
			{
				var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test.png" );
				
				log( "getBucket() = " + reference.getBucket() );
				log( "getName()   = " + reference.getName() );
				log( "getPath()   = " + reference.getPath() );
			
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		public function getMetadata():void 
		{
			log( "getMetadata()" );
			try
			{
				var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test_metadata.png" );
				
				reference.addEventListener( StorageReferenceEvent.GET_METADATA_SUCCESS, getMetadata_successHandler );
				reference.addEventListener( StorageReferenceEvent.GET_METADATA_ERROR, getMetadata_errorHandler );

				reference.getMetadata();
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		private function getMetadata_successHandler( event:StorageReferenceEvent ):void 
		{
			log( "getMetadata_successHandler" );
			
			log( event.metadata.name );
			log( event.metadata.md5Hash );
		}
		
		private function getMetadata_errorHandler( event:StorageReferenceEvent ):void 
		{
			log( "getMetadata_errorHandler" );
		}
		
		
		
		
		//
		//
		//	UPLOADING 
		//
		//		
		
		public function uploadFile():void 
		{
			try
			{
				var file:File = File.applicationStorageDirectory.resolvePath( "assets/plane.png" );
				
				var root:StorageReference = FirebaseStorage.service.getReference();
				var reference:StorageReference = root.child( "images/test.png" );
				
				var task:UploadTask = reference.putFile( "file://" + file.nativePath );
			
				task.addEventListener( UploadTaskEvent.COMPLETE, taskEventHandler );
				task.addEventListener( UploadTaskEvent.SUCCESS, taskEventHandler );
				task.addEventListener( UploadTaskEvent.ERROR, taskEventHandler );
				task.addEventListener( UploadTaskEvent.PAUSED, taskEventHandler );
				task.addEventListener( UploadTaskEvent.PROGRESS, taskEventHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		public function uploadFileWithMetadata():void 
		{
			try
			{
				var file:File = File.applicationStorageDirectory.resolvePath( "assets/plane.png" );
				
				var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test_metadata.png" );
				
				var metadata:StorageMetadata = new StorageMetadata();
				metadata.setCustomMetadata( "source", "distriqt-ane" );
				
				var task:UploadTask = reference.putFile( "file://" + file.nativePath, metadata );
				
				task.addEventListener( UploadTaskEvent.COMPLETE, taskEventHandler );
				task.addEventListener( UploadTaskEvent.SUCCESS, taskEventHandler );
				task.addEventListener( UploadTaskEvent.ERROR, taskEventHandler );
				task.addEventListener( UploadTaskEvent.PAUSED, taskEventHandler );
				task.addEventListener( UploadTaskEvent.PROGRESS, taskEventHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		public function uploadBytes():void 
		{
			try
			{
				var file:File = File.applicationStorageDirectory.resolvePath( "assets/Hyper_8_Bit_Memories_by_webbsta.jpg" );
				var fileStream:FileStream = new FileStream(); 
				fileStream.open(file, FileMode.READ);
				var bytes:ByteArray = new ByteArray();
				fileStream.readBytes(bytes);
				fileStream.close();
				
				var root:StorageReference = FirebaseStorage.service.getReference();
				var reference:StorageReference = root.child( "images/test.jpg" );
				
				var task:UploadTask = reference.putBytes( bytes );
				
				task.addEventListener( UploadTaskEvent.COMPLETE, taskEventHandler );
				task.addEventListener( UploadTaskEvent.SUCCESS, taskEventHandler );
				task.addEventListener( UploadTaskEvent.ERROR, taskEventHandler );
				task.addEventListener( UploadTaskEvent.PAUSED, taskEventHandler );
				task.addEventListener( UploadTaskEvent.PROGRESS, taskEventHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		private function taskEventHandler( event:UploadTaskEvent ):void 
		{
			log( "taskEventHandler: "+event.type );
			if (event.taskSnapshot != null) 
				log( "["+event.taskSnapshot.bytesTransferred +"/"+event.taskSnapshot.totalByteCount+"]" );
			
			var t:UploadTask = UploadTask(event.currentTarget);
			
//			log( "t.isCanceled()="+t.isCanceled() );
//			log( "t.isComplete()="+t.isComplete() );
//			log( "t.isInProgress()="+t.isInProgress() );
//			log( "t.isPaused()="+t.isPaused() );
//			log( "t.isSuccessful()="+t.isSuccessful() );
			
			if (event.type == UploadTaskEvent.COMPLETE)
			{
				t.removeEventListener( UploadTaskEvent.COMPLETE, taskEventHandler );
				t.removeEventListener( UploadTaskEvent.SUCCESS, taskEventHandler );
				t.removeEventListener( UploadTaskEvent.ERROR, taskEventHandler );
				t.removeEventListener( UploadTaskEvent.PAUSED, taskEventHandler );
				t.removeEventListener( UploadTaskEvent.PROGRESS, taskEventHandler );
			}
		}
		
		
		
		//
		//
		//	DELETE
		//
		//
		
		public function deleteReference():void 
		{
			log( "deleteReference()" );
			try
			{
				var reference:StorageReference = FirebaseStorage.service.getReference().child( "images/test.png" );
				
				reference.addEventListener( StorageReferenceEvent.DELETE_SUCCESS, reference_deleteHandler );
				reference.addEventListener( StorageReferenceEvent.DELETE_ERROR, reference_deleteHandler );
				
				reference.deleteReference();
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		private function reference_deleteHandler( event:StorageReferenceEvent ):void 
		{
			log( event.type );
			
			var reference:StorageReference = StorageReference(event.currentTarget);
			
			reference.removeEventListener( StorageReferenceEvent.DELETE_SUCCESS, reference_deleteHandler );
			reference.removeEventListener( StorageReferenceEvent.DELETE_ERROR, reference_deleteHandler );
			
		}
		
		
		
		//
		//
		//	DOWNLOADING
		//
		//
		
		
		public function downloadFile():void 
		{
			try
			{
				var file:File = File.applicationStorageDirectory.resolvePath( "downloads/test.png" );
					
				var reference:StorageReference = FirebaseStorage.service.getReference().child( "downloads/cloud-serpent03.jpg" );
				
				var task:DownloadTask = reference.getFile( file );
				
				task.addEventListener( DownloadTaskEvent.COMPLETE, downloadTaskEventHandler );
				task.addEventListener( DownloadTaskEvent.SUCCESS, downloadTaskEventHandler );
				task.addEventListener( DownloadTaskEvent.ERROR, downloadTaskEventHandler );
				task.addEventListener( DownloadTaskEvent.PAUSED, downloadTaskEventHandler );
				task.addEventListener( DownloadTaskEvent.PROGRESS, downloadTaskEventHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		private function downloadTaskEventHandler( event:DownloadTaskEvent ):void 
		{
			log( "downloadTaskEventHandler: "+event.type );
			if (event.taskSnapshot != null) 
				log( "["+event.taskSnapshot.bytesTransferred +"/"+event.taskSnapshot.totalByteCount+"]" );
			
			var t:DownloadTask = DownloadTask(event.currentTarget);
			
			//			log( "t.isCanceled()="+t.isCanceled() );
			//			log( "t.isComplete()="+t.isComplete() );
			//			log( "t.isInProgress()="+t.isInProgress() );
			//			log( "t.isPaused()="+t.isPaused() );
			//			log( "t.isSuccessful()="+t.isSuccessful() );
			
			if (event.type == DownloadTaskEvent.COMPLETE)
			{
				t.removeEventListener( UploadTaskEvent.COMPLETE, downloadTaskEventHandler );
				t.removeEventListener( UploadTaskEvent.SUCCESS, downloadTaskEventHandler );
				t.removeEventListener( UploadTaskEvent.ERROR, downloadTaskEventHandler );
				t.removeEventListener( UploadTaskEvent.PAUSED, downloadTaskEventHandler );
				t.removeEventListener( UploadTaskEvent.PROGRESS, downloadTaskEventHandler );
				
				var file:File = File.applicationStorageDirectory.resolvePath( "downloads/test.png" );
				if (file.exists)
				{
					var loader:ImageLoader = new ImageLoader();
					loader.source = "file://"+file.nativePath;
					addChild( loader );
				}
			}
		}
		
		
		
		
		private var _downloadByteArray : ByteArray;
		
		public function downloadBytes():void 
		{
			try
			{
				_downloadByteArray = new ByteArray();
				
				var reference:StorageReference = FirebaseStorage.service.getReference().child( "downloads/cloud-serpent03.jpg" );
				
				var task:DownloadTask = reference.getBytes( 1024*1024 );
				
				task.addEventListener( DownloadTaskEvent.COMPLETE, downloadBytesTaskEventHandler );
				task.addEventListener( DownloadTaskEvent.SUCCESS, downloadBytesTaskEventHandler );
				task.addEventListener( DownloadTaskEvent.ERROR, downloadBytesTaskEventHandler );
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		private function downloadBytesTaskEventHandler( event:DownloadTaskEvent ):void 
		{
			log( "downloadBytesTaskEventHandler: "+event.type );
			if (event.taskSnapshot != null) 
				log( "["+event.taskSnapshot.bytesTransferred +"/"+event.taskSnapshot.totalByteCount+"]" );
			
			var t:DownloadTask = DownloadTask(event.currentTarget);
			
			log( "t.isCanceled()="+t.isCanceled() );
			log( "t.isComplete()="+t.isComplete() );
			log( "t.isSuccessful()="+t.isSuccessful() );
			
			if (event.type == DownloadTaskEvent.COMPLETE)
			{
				t.removeEventListener( DownloadTaskEvent.COMPLETE, downloadTaskEventHandler );
				t.removeEventListener( DownloadTaskEvent.SUCCESS, downloadTaskEventHandler );
				t.removeEventListener( DownloadTaskEvent.ERROR, downloadTaskEventHandler );
				
				if (event.taskSnapshot != null && event.taskSnapshot.bytes != null)
				{
					log( "loaded: "+event.taskSnapshot.bytes.length );
				}
			}
		}
		
		
	}
}
