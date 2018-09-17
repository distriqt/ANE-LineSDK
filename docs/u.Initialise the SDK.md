
## Checking for support

**Note you should always check whether the extension is supported before making calls.**
This allows you to react to whether the functionality is available on the device.


```as3
if (LineSDK.isSupported)
{
	// Functionality here
}
```


## Initialising the SDK

Before you can use any of the Line SDK functionality you need to initialise the extension and SDK.
This is done by calling the `initialiseSDK` function and awaiting the `LineSDKEvent.INITIALISED`.

During this process the extension will setup the sdk and check for any existing login session.
The `initialiseSDK` function takes the Channel Id of your Line Channel as a parameter. 

> This channel id is ignored on iOS as the value from the InfoAdditions is used.


```as3
LineSDK.instance.addEventListener( LineSDKEvent.INITIALISED, initialiseSDK_completeHandler );
LineSDK.instance.initialiseSDK( "1602220840" );


function initialiseSDK_completeHandler( event:LineSDKEvent ):void
{
	// SDK is now initialised and ready for use
}
```


>
> Note: Ensure you have called `Core.init()` before initialising the `LineSDK`.
>















