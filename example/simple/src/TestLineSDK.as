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
 */
package
{
	import com.distriqt.extension.linesdk.LineProfile;
	import com.distriqt.extension.linesdk.LineSDK;
	import com.distriqt.extension.linesdk.LineSDK;
	import com.distriqt.extension.linesdk.events.LineSDKEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * Sample application for using the LineSDK Native Extension
	 */
	public class TestLineSDK extends Sprite
	{
		//
		//	VARIABLES
		//
		
		private var _text:TextField;
		
		
		//
		//	FUNCTIONALITY
		//
		
		public function TestLineSDK()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat( "_typewriter", 18 );
			addChild( _text );
			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			init();
		}
		
		
		private function init():void
		{
			message( "LineSDK Supported: " + LineSDK.isSupported );
			message( "LineSDK Version:   " + LineSDK.instance.version );
			
			if (LineSDK.isSupported)
			{
				LineSDK.instance.addEventListener( LineSDKEvent.LOGIN_COMPLETE, loginCompleteHandler );
				LineSDK.instance.addEventListener( LineSDKEvent.LOGIN_ERROR, loginErrorHandler );
				
				LineSDK.instance.addEventListener( LineSDKEvent.INITIALISED, function ( event:LineSDKEvent ):void {
					if (LineSDK.instance.isAuthorized())
					{
						message( "USER LOGGED IN" );
						printUserProfile();
					}
					else
					{
						message( "--------- TAP SCREEN TO LOGIN ---------" );
					}
				} );
				LineSDK.instance.initialiseSDK( "1602220840" );
			}
		}
		
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText( str + "\n" );
		}
		
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private function printUserProfile():void
		{
			// Get the user profile
			var profile:LineProfile = LineSDK.instance.getLastProfile();
			if (profile != null)
			{
				message( "PROFILE ----------------------------- " );
				message( "userId:        " + profile.userId );
				message( "displayName:   " + profile.displayName );
				message( "statusMessage: " + profile.statusMessage );
				message( "pictureUrl:    " + profile.pictureUrl );
			}
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//	Attempt login when screen clicked
			if (LineSDK.isSupported)
			{
				message( "START LOGIN" );
				LineSDK.instance.startLogin();
			}
		}
		
		
		private function loginCompleteHandler( event:LineSDKEvent ):void
		{
			message( "loginCompleteHandler" );
			printUserProfile();
		}
		
		
		private function loginErrorHandler( event:LineSDKEvent ):void
		{
			message( "loginErrorHandler: " + event.text );
		}
		
		
	}
	
}

