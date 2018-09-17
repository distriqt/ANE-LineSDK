
## Managing access tokens

The LINE SDK contains methods to get the current access token, verify that the token is valid, and refresh the token. The SDK automatically refreshes access tokens that are expired whenever an asynchronous call is made through the SDK.


### About access tokens

Access tokens are valid for 30 days after being issued. When an access token expires, API calls fail and a corresponding error is returned. Whenever you call a method, the SDK automatically verifies the validity of the access token and refreshes the token if it has expired. If the token cannot be refreshed, you must prompt the user to log in again to get a new access token.

The access token is deleted when the user deletes your app. If the user reinstalls your app, you must prompt the user to log in again to get a new access token.


### Getting the current access token

If you have a client-server application, you can get the current access token to make API calls from your server. Once you get the access token, you can call the Social API. For more information, see the [API reference](https://developers.line.me/en/reference/social-api/).

To get the current access token, call the `getAccessToken` method.

```as3
var accessToken:LineAccessToken = LineSDK.instance.getAccessToken();

trace( accessToken.accessToken );
```


>
> Note: When sending access tokens to your server, we recommend encrypting the token and using SSL to send the encrypted data. You should also verify that the access token received by your server matches the access token used to call the Social API and that the channel ID matches the one for your channel.
>


### Verifying access tokens

To verify the validity of the current access token, use the `verifyAccessToken()` method. This method returns one of two events:

- `LineSDKEvent.VERIFY_TOKEN_COMPLETE`: the token is valid;
- `LineSDKEvent.VERIFY_TOKEN_ERROR`: the access token is invalid, expired, or the API call failed in some manner.


```as3
LineSDK.instance.addEventListener( LineSDKEvent.VERIFY_TOKEN_COMPLETE, verifyAccessToken_completeHandler );
LineSDK.instance.addEventListener( LineSDKEvent.VERIFY_TOKEN_ERROR, verifyAccessToken_errorHandler );

LineSDK.instance.verifyAccessToken();

function verifyAccessToken_completeHandler( event:LineSDKEvent ):void
{
    // Access Token is valid 
}

function verifyAccessToken_errorHandler( event:LineSDKEvent ):void
{
    // Token is invalid - attempt a refresh or login
}
```



### Refreshing access tokens

To refresh the access token that is currently being used by the SDK, call the `refreshAccessToken()` method. You can call this method for up to 10 days after the access token has expired. If this call fails, then it means that the token has expired and the user must log in again to get a new access token.

This method will dispatch one of two events: 

```as3
LineSDK.instance.addEventListener( LineSDKEvent.REFRESH_TOKEN_COMPLETE, refreshAccessToken_completeHandler );
LineSDK.instance.addEventListener( LineSDKEvent.REFRESH_TOKEN_ERROR, refreshAccessToken_errorHandler );

LineSDK.instance.refreshAccessToken();

function refreshAccessToken_completeHandler( event:LineSDKEvent ):void
{
    // New valid token obtained 
}

function refreshAccessToken_errorHandler( event:LineSDKEvent ):void
{
    // Token is invalid, your user needs to login again
}
```



