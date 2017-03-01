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
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		21/06/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.firebase.Firebase;
	import com.distriqt.extension.firebase.analytics.FirebaseAnalytics;
	import com.distriqt.extension.firebase.auth.AuthCredential;
	import com.distriqt.extension.firebase.auth.EmailAuthProvider;
	import com.distriqt.extension.firebase.auth.FirebaseAuth;
	import com.distriqt.extension.firebase.auth.builders.UserProfileChangeRequestBuilder;
	import com.distriqt.extension.firebase.auth.events.FirebaseAuthEvent;
	import com.distriqt.extension.firebase.auth.events.FirebaseUserEvent;
	import com.distriqt.extension.firebase.auth.user.FirebaseUser;
	import com.distriqt.extension.firebase.auth.user.UserInfo;
	
	import starling.events.Event;
	
	/**	
	 * 
	 */
	public class FirebaseAuthTests
	{
		public static const TAG : String = "Auth";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function FirebaseAuthTests( logger:ILogger )
		{
			_l = logger;
		}
		
		
		public function setup(e:Event=null):void
		{
			try
			{
				Firebase.init( Config.distriqtApplicationKey );
				FirebaseAuth.init( Config.distriqtApplicationKey );
				
				log( "Firebase Supported: " + Firebase.isSupported );
				
				if (Firebase.isSupported)
				{
					log( "Firebase     Version:   " + Firebase.service.version );
					log( "FirebaseAuth Version:   " + FirebaseAuth.service.version );
					
					var success:Boolean = Firebase.service.initialiseApp();
					log( "Firebase.service.initialiseApp() = " + success );
					if (!success)
					{
						log( "CHECK YOUR CONFIGURATION" );
					}
					
					FirebaseAuth.service.addEventListener( FirebaseAuthEvent.AUTHSTATE_CHANGED, authState_changedHandler );
				}
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		public function dispose():void
		{
			try
			{
				FirebaseAuth.service.removeEventListener( FirebaseAuthEvent.AUTHSTATE_CHANGED, authState_changedHandler );
				
				Firebase.service.dispose();
				FirebaseAuth.service.dispose();
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		//
		//
		//	AUTH
		//
		//		
		
		public function getCurrentUser():void 
		{
			if (FirebaseAuth.isSupported)
			{
				var user:FirebaseUser = FirebaseAuth.service.getCurrentUser();
				if (user != null)
				{
					log( "identifier:  " + user.identifier );
					log( "displayName: " + user.displayName );
					log( "email:       " + user.email );
					
					for each (var info:UserInfo in user.providers)
					{
						log( "------------------" );
						log( "\tprovider:    " + info.providerId );
						log( "\tidentifier:  " + info.identifier );
						log( "\tdisplayName: " + info.displayName );
						log( "\temail:       " + info.email );
					}
				}
				else 
				{
					log( "Not signed in" );
				}
			}
		}
		

		public function signOut():void 
		{
			if (FirebaseAuth.isSupported)
			{
				if (FirebaseAuth.service.isSignedIn())
				{
					var success:Boolean = FirebaseAuth.service.signOut();
					log( "signOut()="+success );
				}
				else 
				{
					log( "Not signed in" );
				}
			}
		}
		
		
		private function authState_changedHandler( event:FirebaseAuthEvent ):void
		{
			log( "auth state changed: "+FirebaseAuth.service.isSignedIn() );
		}
		
		
		
		public function sendPasswordResetEmail():void
		{
			if (FirebaseAuth.isSupported)
			{
				log( "sendPasswordResetEmail()" );
				FirebaseAuth.service.addEventListener( 
					FirebaseAuthEvent.SEND_PASSWORD_RESET_EMAIL_COMPLETE,
					sendPasswordResetEmail_completeHandler );
				
				FirebaseAuth.service.sendPasswordResetEmail( email );
			}
		}
		
		private function sendPasswordResetEmail_completeHandler( event:FirebaseAuthEvent ):void
		{
			log( "sendPasswordResetEmail(): complete: " + event.success +"::"+event.message );
			
			FirebaseAuth.service.removeEventListener( 
				FirebaseAuthEvent.SEND_PASSWORD_RESET_EMAIL_COMPLETE,
				sendPasswordResetEmail_completeHandler );
		}
		
		
		
		
		//
		//	EMAIL AUTHENTICATION
		//
		
		
		private var email:String = "ma@distriqt.com";
		private var password:String = "dfgh*&!@7822";
		
		
		public function createUserWithEmail():void
		{
			if (FirebaseAuth.isSupported)
			{
				log( "createUserWithEmailAndPassword()" );
				FirebaseAuth.service.addEventListener( 
					FirebaseAuthEvent.CREATE_USER_WITH_EMAIL_COMPLETE,
					createUserWithEmailAndPassword_completeHandler );
				
				FirebaseAuth.service.createUserWithEmailAndPassword( email, password );
			}
		}
		
		private function createUserWithEmailAndPassword_completeHandler( event:FirebaseAuthEvent ):void
		{
			log( "createUserWithEmailAndPassword(): complete: " + event.success +"::"+event.message );
			
			FirebaseAuth.service.removeEventListener( 
				FirebaseAuthEvent.CREATE_USER_WITH_EMAIL_COMPLETE,
				createUserWithEmailAndPassword_completeHandler );
		}
		
		
		public function signInWithEmail():void
		{
			if (FirebaseAuth.isSupported)
			{
				if (!FirebaseAuth.service.isSignedIn())
				{
					log( "signInWithEmailAndPassword()" );
					
					FirebaseAuth.service.addEventListener( 
						FirebaseAuthEvent.SIGNIN_WITH_EMAIL_COMPLETE,
						signInWithEmailAndPassword_completeHandler );
					
					FirebaseAuth.service.signInWithEmailAndPassword( email, password );
				}
				else 
				{
					log( "Already signed in" );
				}
			}
		}
		
		
		private function signInWithEmailAndPassword_completeHandler( event:FirebaseAuthEvent ):void
		{
			log( "signInWithEmailAndPassword(): complete: " + event.success +"::"+event.message );
		
			FirebaseAuth.service.removeEventListener( 
				FirebaseAuthEvent.SIGNIN_WITH_EMAIL_COMPLETE,
				signInWithEmailAndPassword_completeHandler );
		
			if (event.success)
			{
				var user:FirebaseUser = FirebaseAuth.service.getCurrentUser();
				log( user.identifier );
			}
		}
		
		
		public function linkEmailAuthCredential():void
		{
			if (FirebaseAuth.isSupported)
			{
				if (FirebaseAuth.service.isSignedIn())
				{
					log( "linkWithCredential()" );
					
					var credential:AuthCredential = EmailAuthProvider.getEmailAuthCredential( email, password );
					
					FirebaseAuth.service.getCurrentUser().addEventListener( 
						FirebaseUserEvent.LINK_WITH_CREDENTIAL_COMPLETE, 
						linkWithCredential_completeHandler );
					
					FirebaseAuth.service.getCurrentUser().linkWithCredential( credential );
				}
			}
		}
		
		
		private function linkWithCredential_completeHandler( event:FirebaseUserEvent ):void
		{
			log( "linkWithCredential(): complete: " + event.success +"::"+event.message );
			FirebaseAuth.service.getCurrentUser().removeEventListener( 
				FirebaseUserEvent.LINK_WITH_CREDENTIAL_COMPLETE, 
				linkWithCredential_completeHandler );
			
			getCurrentUser();
		}
		
		
		//
		//	ANONYMOUS AUTHENTICATION
		//
		
		public function signInAnonymously():void
		{
			if (FirebaseAuth.isSupported)
			{
				if (!FirebaseAuth.service.isSignedIn())
				{
					FirebaseAuth.service.addEventListener( FirebaseAuthEvent.SIGNIN_ANONYMOUSLY_COMPLETE, signInAnonymously_completeHandler );
					var success:Boolean = FirebaseAuth.service.signInAnonymously();
					log( "signInAnonymously()="+success );
				}
				else 
				{
					log( "Already signed in" );
				}
			}
		}
		
		
		private function signInAnonymously_completeHandler( event:FirebaseAuthEvent ):void
		{
			FirebaseAuth.service.removeEventListener( FirebaseAuthEvent.SIGNIN_ANONYMOUSLY_COMPLETE, signInAnonymously_completeHandler );
			log( "signInAnonymously(): complete: " + event.message );
			
			if (event.success)
			{
				var user:FirebaseUser = FirebaseAuth.service.getCurrentUser();
				
				log( user.identifier );
			}
		}
		
		
		//
		//	USER
		//
		
		public function sendEmailVerification():void
		{
			if (FirebaseAuth.isSupported && FirebaseAuth.service.isSignedIn())
			{
				log( "sendEmailVerification()" );
				
				FirebaseAuth.service.getCurrentUser().addEventListener(
					FirebaseUserEvent.SEND_EMAIL_VERIFICATION_COMPLETE,
					sendEmailVerification_completeHandler );
				
				FirebaseAuth.service.getCurrentUser().sendEmailVerification();
			}
		}
		
		private function sendEmailVerification_completeHandler( event:FirebaseUserEvent ):void
		{
			log( "sendEmailVerification(): complete: " + event.success +"::"+event.message );
			FirebaseAuth.service.getCurrentUser().removeEventListener(
				FirebaseUserEvent.SEND_EMAIL_VERIFICATION_COMPLETE,
				sendEmailVerification_completeHandler );
		}
		
		
		
		public function deleteUser():void
		{
			if (FirebaseAuth.isSupported)
			{
				if (FirebaseAuth.service.isSignedIn())
				{
					log( "deleteUser()" );
					FirebaseAuth.service.getCurrentUser().addEventListener( 
						FirebaseUserEvent.DELETE_USER_COMPLETE, 
						deleteUser_completeHandler );
					FirebaseAuth.service.getCurrentUser().deleteUser();
				}
			}
		}
		
		private function deleteUser_completeHandler( event:FirebaseUserEvent ):void
		{
			log( "deleteUser(): complete: " + event.success +"::"+event.message );
		}
			
		
		public function updateProfile():void
		{
			if (FirebaseAuth.isSupported && FirebaseAuth.service.isSignedIn())
			{
				var newDisplayName:String = "Test Awesome " + Math.floor(Math.random()*1000);
				log( "updateProfile(): displayName = " + newDisplayName );
				FirebaseAuth.service.getCurrentUser().addEventListener( 
					FirebaseUserEvent.UPDATE_PROFILE_COMPLETE,
					updateProfile_completeHandler );
				
				FirebaseAuth.service.getCurrentUser().updateProfile( 
					new UserProfileChangeRequestBuilder()
						.setDisplayName( newDisplayName )
						.build()
					);
			}
		}
		
		private function updateProfile_completeHandler( event:FirebaseUserEvent ):void
		{
			log( "updateProfile(): complete: "+event.success +"::"+event.message );
			
			log( "updateProfile(): " + FirebaseAuth.service.getCurrentUser().displayName );
			
			FirebaseAuth.service.getCurrentUser().removeEventListener( 
				FirebaseUserEvent.UPDATE_PROFILE_COMPLETE,
				updateProfile_completeHandler );
		}
		
		
		public function getToken():void
		{
			if (FirebaseAuth.isSupported && FirebaseAuth.service.isSignedIn())
			{
				log( "getToken()" );
				FirebaseAuth.service.getCurrentUser().addEventListener( 
					FirebaseUserEvent.GET_TOKEN_COMPLETE,
					getToken_completeHandler );
				
				FirebaseAuth.service.getCurrentUser().getToken( true );
			}
		}
		
		private function getToken_completeHandler(event:FirebaseUserEvent ):void
		{
			log( "getToken(): complete: "+event.success+"::"+event.data );
			FirebaseAuth.service.getCurrentUser().removeEventListener( 
				FirebaseUserEvent.GET_TOKEN_COMPLETE,
				getToken_completeHandler );
		}
	}
}
