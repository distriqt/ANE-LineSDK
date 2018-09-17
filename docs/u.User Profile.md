
## Getting user profiles

To access the user profile use the `getLastProfile` method. This method will return the currently known details about the user.
This can return `null` if the user is not logged in or if the profile information is not yet been updated for the user.
This information is updated at initialisation, user login and manually as below.  

```as3
var profile:LineProfile = LineSDK.instance.getLastProfile();
if (profile != null)
{
    trace( "userId:        " + profile.userId );
    trace( "displayName:   " + profile.displayName );
    trace( "statusMessage: " + profile.statusMessage );
    trace( "pictureUrl:    " + profile.pictureUrl );
}
```


## Updating user profiles

You may want to update the user's profile information retrieving any updates made to their LINE account.

You do this by calling the `getProfile` method and waiting for the response.

- `LineSDKEvent.GETPROFILE_COMPLETE`: when the method succeeded and the profile has been updated;
- `LineSDKEvent.GETPROFILE_ERROR`: when there was an error updating the profile.


```as3
LineSDK.instance.addEventListener( LineSDKEvent.GETPROFILE_COMPLETE, getProfile_completeHandler );
LineSDK.instance.addEventListener( LineSDKEvent.GETPROFILE_ERROR, getProfile_errorHandler );
LineSDK.instance.getProfile();


function getProfile_completeHandler( event:LineSDKEvent ):void
{
    var profile:LineProfile = LineSDK.instance.getLastProfile();
    if (profile != null)
    {
        trace( "userId:        " + profile.userId );
        trace( "displayName:   " + profile.displayName );
        trace( "statusMessage: " + profile.statusMessage );
        trace( "pictureUrl:    " + profile.pictureUrl );
    }
}

function getProfile_errorHandler( event:LineSDKEvent ):void
{
    trace( "getProfile_errorHandler: " + event.text );
}
```


