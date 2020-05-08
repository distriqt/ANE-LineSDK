
## Add the Extension

First step is always to add the extension to your development environment. 
To do this use the tutorial located [here](https://airnativeextensions.github.io/tutorials/getting-started).


### AIR SDK


This ANE currently requires at least AIR 33+. This is required in order to support versions of Android > 9.0 (API 28). We always recommend using the most recent build with AIR especially for mobile development where the OS changes rapidly.



## Dependencies

### Core ANE

The Core extension is required by this extension. You must include this extension in your application.

This extension requires you call the `init()` function at some point early in your application, generally at the same time as the initialisation of this extension. If you are using other extensions that also require the Core extension, you only need to initialise it once, before initialising the other extensions.

```as3
Core.init();
```

The Core extension doesn't provide any functionality in itself but provides support libraries and frameworks used by our extensions.
It also includes some centralised code for some common actions that can cause issues if they are implemented in each individual extension.

You can access this extension here: [https://github.com/distriqt/ANE-Core](https://github.com/distriqt/ANE-Core).



### Android Support ANE

The Android Support libraries encompass the Android Support, Android X and common Google libraries. 

These libraries are specific to Android. There are no issues including these on all platforms, they are just **required** for Android.

This extension requires the following extensions:

- [androidx.core](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/androidx.core.ane)
- [androidx.appcompat](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/androidx.appcompat.ane)
- [androidx.browser](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/androidx.browser.ane)

You can access these extensions here: [https://github.com/distriqt/ANE-AndroidSupport](https://github.com/distriqt/ANE-AndroidSupport).


>
> **Note**: if you have been using the older `com.distriqt.androidsupport.*` (Android Support) extensions you should remove these extensions and replace it with the `androidx` extensions listed above. This is the new version of the android support libraries and moving forward all our extensions will require AndroidX.
>



## Extension IDs

The following should be added to your extensions node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>com.distriqt.LineSDK</extensionID>

    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>androidx.core</extensionID>
    <extensionID>androidx.appcompat</extensionID>
    <extensionID>androidx.browser</extensionID>
</extensions>
```



---

## iOS

Make sure you have ![](created a channel|i.Getting started with LINE Login) for your app before proceeding.


### Configuring your channel

To link your app with your channel, complete the following fields in the "App settings" page of the console.

- **iOS bundle ID**: Bundle identifier of your app found in the “General” tab in your Xcode project settings. Must be lowercase. For example, `com.example.app`. You can specify multiple bundle identifiers by entering each one on a new line.

- **iOS scheme**: Set as `line3rdp.` followed by the bundle identifier. For example, if your bundle identifier is `com.example.app`, set the iOS scheme as `line3rdp.com.example.app`. Only one iOS scheme can be specified.

![](images/ios-app-settings-a4b52d7a.png)




### Info Additions and Entitlements

The LINE SDK require a few additions to the Info plist and Entitlements section of your application to correctly configure your application.

You must replace the `BUNDLE_SEED_ID` and `BUNDLE_IDENTIFIER` with the information you gathered when setting up your application in the Apple developer center, and the `LINE_CHANNEL_ID` with your channel id from the channel you setup in the Line Dashboard.


The `BUNDLE_SEED_ID` is also called the **App ID Prefix**, or **Team ID** and is of the form `XXXXXXXXX`. You find it in the developer center: https://developer.apple.com/account/#/membership/ .

The `BUNDLE_IDENTIFIER` is the **App ID** and should be the same as your air application id.


```xml
<iPhone>
    <InfoAdditions><![CDATA[
        <key>LineSDKConfig</key>
        <dict>
            <key>ChannelID</key>
            <string>LINE_CHANNEL_ID</string>
        </dict>

        <key>CFBundleURLTypes</key>
        <array>
            <dict>
                <key>CFBundleTypeRole</key>
                <string>Editor</string>
                <key>CFBundleURLSchemes</key>
                <array>
                    <string>line3rdp.BUNDLE_IDENTIFIER</string>
                </array>
            </dict>
        </array>
        <key>LSApplicationQueriesSchemes</key>
        <array>
            <string>lineauth</string>
            <string>line3rdp.BUNDLE_IDENTIFIER</string>
        </array>
    )></InfoAdditions>
    <requestedDisplayResolution>high</requestedDisplayResolution>
    <Entitlements>
        <![CDATA[
            <key>keychain-access-groups</key>
            <array>
                <string>BUNDLE_SEED_ID.*</string>
            </array>
        )>
    </Entitlements>
</iPhone>
```



### Dynamic Framework

The Line iOS SDK is implemented as a dynamic framework. This means that the framework must be packaged and signed with your application for runtime (dynamic) execution.

To correctly package a dynamic framework with AIR you need to create a `Frameworks` directory at the root level of your application package i.e. alongside your SWF. Make sure you name the directory exactly as listed with correct capitalisation.

In this directory, place all of the files contained in the build/Frameworks directory alongside the ANE, including the framework and dependent dylib files.

Make sure you are using at least version 30 of the AIR SDK, so when packaging your IPA AIR will sign the dynamic frameworks with your application identity.

>
> Due to some issues with AIR signing dynamic frameworks you will need to resign your IPA before it can be correctly installed on a debug device or submitted to the store. > See the ![](iOS Signing|i.iOS Signing) section for information.
>


---

## Android

Make sure you have ![](created a channel|i.Getting started with LINE Login) for your app before proceeding.


### Configuring your channel

To link your app with your channel, complete the following fields in the "App settings" page of the console.

- **Android package name**: Required. Application's package name used to launch the Google Play store.
- **Android package signature**: Optional. You can set multiple signatures by entering each one on a new line.
- **Android scheme**: Optional. Custom URL scheme used to launch your app.


![](images/android-app-settings-d056af24.png)


### Manifest Additions

You must add the following manifest additions. You must include the `INTERNET` permission and the two LINE SDK activities.
The LINE SDK is only supported on Android API v15 and higher so you will need to make sure the minimum sdk version is set to 15 or higher.

```xml
<manifest android:installLocation="auto" >
    <uses-sdk android:minSdkVersion="15" android:targetSdkVersion="28" />

    <uses-permission android:name="android.permission.INTERNET"/>
    
    <application android:hardwareAccelerated="true">

        <activity
            android:name="com.linecorp.linesdk.auth.internal.LineAuthenticationActivity"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:exported="false"
            android:launchMode="singleTop"
            android:theme="@style/LineSdk_AuthenticationActivity" />

        <activity
            android:name="com.linecorp.linesdk.auth.internal.LineAuthenticationCallbackActivity"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:exported="true" >
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="lineauth" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```



