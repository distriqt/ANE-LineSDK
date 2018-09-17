

## Logging in users

In order to start the login process you call the `startLogin` method.

This process will dispatch one of two events:

- `LineSDKEvent.LOGIN_COMPLETE`: when the login process is complete and the user has successfully logged in;
- `LineSDKEvent.LOGIN_ERROR`: when there was an error during the login process


Example:

```as3
LineSDK.instance.addEventListener( LineSDKEvent.LOGIN_COMPLETE, loginCompleteHandler );
LineSDK.instance.addEventListener( LineSDKEvent.LOGIN_ERROR, loginErrorHandler );
LineSDK.instance.startLogin();

function loginCompleteHandler( event:LineSDKEvent ):void
{
    trace( "loginCompleteHandler" );
}

function loginErrorHandler( event:LineSDKEvent ):void
{
    trace( "loginErrorHandler: " + event.text );
}
```

After successful login you can access the ![](user's profile|u.User Profile) and ![](access token|u.Access Token).

>
> Note: If you call `startLogin` when a user is already logged in then the `LOGIN_COMPLETE` event will dispatch immediately 
> and no screens will be shown to your user. You should call `logout` before calling `startLogin` to present the login screen again.
> 


## Logout

If at any point you wish to logout your user from LINE you use the `logout` method.

This process will dispatch one of two events:

- `LineSDKEvent.LOGOUT_COMPLETE`: when the logout process is complete and the user is no longer logged in;
- `LineSDKEvent.LOGOUT_ERROR`: when there was an error during the logout process (eg the user was not logged in)


Example:

```as3
LineSDK.instance.addEventListener( LineSDKEvent.LOGOUT_COMPLETE, logout_completeHandler );
LineSDK.instance.addEventListener( LineSDKEvent.LOGOUT_ERROR, logout_errorHandler );
LineSDK.instance.logout();


function logout_completeHandler( event:LineSDKEvent ):void
{
    trace( "logout_completeHandler" );
}

private function logout_errorHandler( event:LineSDKEvent ):void
{
    trace( "logout_errorHandler: " + event.text );
}
```


## Checking Existing 

After initialisation you can check whether there is an existing user already logged in. 

To check if the user is signed in use the `isAuthorized` function:

```as3
if (LineSDK.instance.isAuthorized())
{
    // User is logged in
}
```

You can use this to see if you have a returning user to your application that has previously signed in to your application using their credentials.  This way you can bypass your login screen and present the correct information for your user.




