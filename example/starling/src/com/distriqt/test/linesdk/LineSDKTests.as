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
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		08/01/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.linesdk
{
	import com.distriqt.extension.core.Core;
	import com.distriqt.extension.facebookapi.FacebookAPI;
	import com.distriqt.extension.linesdk.LineAccessToken;
	import com.distriqt.extension.linesdk.LineProfile;
	import com.distriqt.extension.linesdk.LineSDK;
	import com.distriqt.extension.linesdk.events.LineSDKEvent;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**	
	 */
	public class LineSDKTests extends Sprite
	{
		public static const TAG : String = "";
		
		private var _l : ILogger;
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function LineSDKTests( logger:ILogger )
		{
			_l = logger;
			try
			{
				Core.init();
				log( "LineSDK Supported: " + LineSDK.isSupported );
				if (LineSDK.isSupported)
				{
					log( "LineSDK Version:   " + LineSDK.instance.version );
				}
			}
			catch (e:Error)
			{
				trace( e );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//  
		//
		
		public function initialiseSDK():void
		{
			log( "initialiseSDK" );
			if (LineSDK.isSupported)
			{
				LineSDK.instance.addEventListener( LineSDKEvent.INITIALISED, initialiseSDK_completeHandler );
				LineSDK.instance.initialiseSDK( "1602220840" );
			}
		}
		
		private function initialiseSDK_completeHandler( event:LineSDKEvent ):void
		{
			log( "initialiseSDK_completeHandler" );
			LineSDK.instance.removeEventListener( LineSDKEvent.INITIALISED, initialiseSDK_completeHandler );
		}
		
		
		
		public function startLogin():void
		{
			log( "startLogin" );
			if (LineSDK.isSupported)
			{
				LineSDK.instance.addEventListener( LineSDKEvent.LOGIN_COMPLETE, loginCompleteHandler );
				LineSDK.instance.addEventListener( LineSDKEvent.LOGIN_ERROR, loginErrorHandler );
				LineSDK.instance.startLogin( ["profile", "openid" ] );
			}
		}
		
		private function loginCompleteHandler( event:LineSDKEvent ):void
		{
			log( "loginCompleteHandler" );
			LineSDK.instance.removeEventListener( LineSDKEvent.LOGIN_COMPLETE, loginCompleteHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.LOGIN_ERROR, loginErrorHandler );
			
			
			// Get the user profile
			var profile:LineProfile = LineSDK.instance.getLastProfile();
			if (profile != null)
			{
				log( "PROFILE ----------------------------- " );
				log( "userId:        " + profile.userId );
				log( "displayName:   " + profile.displayName );
				log( "statusMessage: " + profile.statusMessage );
				log( "pictureUrl:    " + profile.pictureUrl );
			}
			
		}
		
		private function loginErrorHandler( event:LineSDKEvent ):void
		{
			log( "loginErrorHandler: " + event.text );
			
			LineSDK.instance.removeEventListener( LineSDKEvent.LOGIN_COMPLETE, loginCompleteHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.LOGIN_ERROR, loginErrorHandler );
		}
		
		
		
		
		public function getProfile():void
		{
			log( "getProfile" );
			if (LineSDK.isSupported)
			{
				LineSDK.instance.addEventListener( LineSDKEvent.GETPROFILE_COMPLETE, getProfile_completeHandler );
				LineSDK.instance.addEventListener( LineSDKEvent.GETPROFILE_ERROR, getProfile_errorHandler );
				LineSDK.instance.getProfile();
			}
		}
		
		private function getProfile_completeHandler( event:LineSDKEvent ):void
		{
			log( "getProfile_completeHandler" );
			LineSDK.instance.removeEventListener( LineSDKEvent.GETPROFILE_COMPLETE, loginCompleteHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.GETPROFILE_ERROR, loginErrorHandler );
			
			// Get the user profile
			var profile:LineProfile = LineSDK.instance.getLastProfile();
			if (profile != null)
			{
				log( "PROFILE ----------------------------- " );
				log( "userId:        " + profile.userId );
				log( "displayName:   " + profile.displayName );
				log( "statusMessage: " + profile.statusMessage );
				log( "pictureUrl:    " + profile.pictureUrl );
			}
			
		}
		
		private function getProfile_errorHandler( event:LineSDKEvent ):void
		{
			log( "getProfile_errorHandler: " + event.text );
			
			LineSDK.instance.removeEventListener( LineSDKEvent.GETPROFILE_COMPLETE, loginCompleteHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.GETPROFILE_ERROR, loginErrorHandler );
		}
		
		
		
		
		public function logout():void
		{
			log( "logout" );
			if (LineSDK.isSupported)
			{
				LineSDK.instance.addEventListener( LineSDKEvent.LOGOUT_COMPLETE, logout_completeHandler );
				LineSDK.instance.addEventListener( LineSDKEvent.LOGOUT_ERROR, logout_errorHandler );
				LineSDK.instance.logout();
			}
		}
		
		private function logout_completeHandler( event:LineSDKEvent ):void
		{
			log( "logout_completeHandler" );
		}
		
		private function logout_errorHandler( event:LineSDKEvent ):void
		{
			log( "logout_errorHandler: " + event.text );
		}
		
		
		
		
		public function getAccessToken():void
		{
			log( "getAccessToken" );
			if (LineSDK.isSupported)
			{
				var accessToken:LineAccessToken = LineSDK.instance.getAccessToken();
				if (accessToken != null)
				{
					log( "accessToken: " + accessToken.accessToken );
					log( "expiry:      " + accessToken.expiry.toString() );
				}
			}
		}
		
		
		
		
		public function refreshAccessToken():void
		{
			log( "refreshAccessToken" );
			if (LineSDK.isSupported)
			{
				LineSDK.instance.addEventListener( LineSDKEvent.REFRESH_TOKEN_COMPLETE, refreshAccessToken_completeHandler );
				LineSDK.instance.addEventListener( LineSDKEvent.REFRESH_TOKEN_ERROR, refreshAccessToken_errorHandler );
				LineSDK.instance.refreshAccessToken();
			}
		}
		
		private function refreshAccessToken_completeHandler( event:LineSDKEvent ):void
		{
			log( "refreshAccessToken_completeHandler" );
			LineSDK.instance.removeEventListener( LineSDKEvent.REFRESH_TOKEN_COMPLETE, refreshAccessToken_completeHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.REFRESH_TOKEN_ERROR, refreshAccessToken_errorHandler );
		}
		
		private function refreshAccessToken_errorHandler( event:LineSDKEvent ):void
		{
			log( "refreshAccessToken_errorHandler: "+ event.text );
			LineSDK.instance.removeEventListener( LineSDKEvent.REFRESH_TOKEN_COMPLETE, refreshAccessToken_completeHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.REFRESH_TOKEN_ERROR, refreshAccessToken_errorHandler );
		}
		
		
		
		
		public function verifyAccessToken():void
		{
			log( "verifyAccessToken" );
			if (LineSDK.isSupported)
			{
				LineSDK.instance.addEventListener( LineSDKEvent.VERIFY_TOKEN_COMPLETE, verifyAccessToken_completeHandler );
				LineSDK.instance.addEventListener( LineSDKEvent.VERIFY_TOKEN_ERROR, verifyAccessToken_errorHandler );
				LineSDK.instance.verifyAccessToken();
			}
		}
		
		private function verifyAccessToken_completeHandler( event:LineSDKEvent ):void
		{
			log( "verifyAccessToken_completeHandler" );
			LineSDK.instance.removeEventListener( LineSDKEvent.VERIFY_TOKEN_COMPLETE, refreshAccessToken_completeHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.VERIFY_TOKEN_ERROR, refreshAccessToken_errorHandler );
		}
		
		private function verifyAccessToken_errorHandler( event:LineSDKEvent ):void
		{
			log( "verifyAccessToken_errorHandler: "+ event.text );
			LineSDK.instance.removeEventListener( LineSDKEvent.VERIFY_TOKEN_COMPLETE, refreshAccessToken_completeHandler );
			LineSDK.instance.removeEventListener( LineSDKEvent.VERIFY_TOKEN_ERROR, refreshAccessToken_errorHandler );
		}
		
		
	}
}
