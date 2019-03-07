

## iOS Signing

AIR currently does not handle some dynamic frameworks correctly when packaging the IPA.

In order to correct this you will need to resign your IPA before it will install on a debug device or be accepted by the AppStore.


Below is a script that you can use to resign your application. The script basically pulls the IPA apart then signs the Branch framework with your identity and then repackages the IPA. You need to update the configuration at the top of the file and then run the script on a macOS machine with the signing identity installed.


To determine the signing identity you should run the following in a terminal:

```
security find-identity -v -p codesigning
```

This will output something like:

```
1) D9C8084063F1941D60C69DD73BBFB0B8B943832A "iPhone Distribution: Distriqt Pty Ltd (XXXXXXXXXX)"
```

You need to copy the part in inverted commas and use this as the `SIGNING_IDENTITY` in the script.


The output of the script will be a `app_resigned.ipa` file which you can use to install on a debug device or submit to the store (depending on the certificate and profile that you used).



### Script


```
#!/bin/bash

#####################################
## CONFIG

# You need to set the values below for your application
# We suggest they are full paths to the files. 

# The path to the ipa generated from your AIR application packaging
IPA="/path/to/your/dist_app.ipa"

# The distribution provisioning profile for your application
PROVISIONING_PROFILE="/path/to/your/distribution_profile.mobileprovision"

# The name of the signing identity. You get this by running the following in a terminal 
# and selecting the name of your distribution certificate:
# 
# security find-identity -v -p codesigning
SIGNING_IDENTITY="iPhone Distribution: Distriqt Pty Ltd (XXXXXXXXXX)"

## END CONFIG
#####################################




OUTPUT=.
WORKING_DIR=.tmp
WORKING_PROFILE="profile.mobileprovision"
IPA_NAME=$(basename ${IPA%.*})

cp -f "$PROVISIONING_PROFILE" "$WORKING_PROFILE"

rm -rf "$WORKING_DIR"
unzip -qq -o $IPA -d $WORKING_DIR
find . -iname '$WORKING_DIR/*.DS_Store' -delete 

rm -rf "$WORKING_DIR/Payload/$APP_NAME/_CodeSignature/"
rm -f "$WORKING_DIR/Payload/$APP_NAME/embedded.mobileprovision"

APP_NAME=$(ls -1 $WORKING_DIR/Payload)


#####################################
echo "Create Signing Entitlements"
ENTITLEMENTS="$OUTPUT/Entitlements.plist"
WORKING_PROFILE_PLIST="$OUTPUT/$WORKING_PROFILE.plist"
security cms -D -i "$WORKING_PROFILE" > "$WORKING_PROFILE_PLIST"


# /usr/libexec/PlistBuddy  -x -c 'Print :Entitlements' "$WORKING_PROFILE_PLIST" > "$ENTITLEMENTS"
    
TEAM_IDENTIFIER=$(/usr/libexec/Plistbuddy -c "Print :TeamIdentifier:0" "$WORKING_PROFILE_PLIST")
APPLICATION_IDENTIFIER_PREFIX=$(/usr/libexec/Plistbuddy -c "Print :ApplicationIdentifierPrefix:0" "$WORKING_PROFILE_PLIST")
BUNDLE_IDENTIFIER=$(/usr/libexec/Plistbuddy -c "Print :CFBundleIdentifier" "$WORKING_DIR/Payload/$APP_NAME/Info.plist")
APS_ENVIRONMENT=$(/usr/libexec/Plistbuddy -c "Print Entitlements:aps-environment" "$WORKING_PROFILE_PLIST")
BETA_REPORTS=$(/usr/libexec/Plistbuddy -c "Print Entitlements:beta-reports-active" "$WORKING_PROFILE_PLIST")
PROVISIONING_GET_TASK_ALLOW=$(/usr/libexec/Plistbuddy -c "Print :Entitlements:get-task-allow" "$WORKING_PROFILE_PLIST")
 
echo "\tAPP_NAME = $APP_NAME"
echo "\tTEAM_IDENTIFIER = $TEAM_IDENTIFIER"
echo "\tAPPLICATION_IDENTIFIER_PREFIX = $APPLICATION_IDENTIFIER_PREFIX"
echo "\tBUNDLE_IDENTIFIER = $BUNDLE_IDENTIFIER"
echo "\tAPS_ENVIRONMENT = $APS_ENVIRONMENT"
echo "\tBETA_REPORTS = $BETA_REPORTS"
echo "\tPROVISIONING_GET_TASK_ALLOW = $PROVISIONING_GET_TASK_ALLOW"


/usr/libexec/PlistBuddy -c "Add :application-identifier string $APPLICATION_IDENTIFIER_PREFIX.$BUNDLE_IDENTIFIER" "$ENTITLEMENTS"
/usr/libexec/PlistBuddy -c "Add :get-task-allow bool $PROVISIONING_GET_TASK_ALLOW" "$ENTITLEMENTS"
/usr/libexec/PlistBuddy -c "Add :keychain-access-groups array" "$ENTITLEMENTS"
/usr/libexec/PlistBuddy -c "Add :keychain-access-groups:0 string $APPLICATION_IDENTIFIER_PREFIX.$BUNDLE_IDENTIFIER" "$ENTITLEMENTS"
/usr/libexec/PlistBuddy -c "Add :aps-environment string $APS_ENVIRONMENT" "$ENTITLEMENTS"
# /usr/libexec/PlistBuddy -c "Add :beta-reports-active bool $BETA_REPORTS" "$ENTITLEMENTS"

cp "$ENTITLEMENTS" "$WORKING_DIR/Payload/$APP_NAME/archived-expanded-entitlements.xcent"

cat "$WORKING_DIR/Payload/$APP_NAME/archived-expanded-entitlements.xcent"

#####################################
echo "Sign Frameworks" 

function sign_framework() {
    FRAMEWORK=$1.framework
    if [ -d "$WORKING_DIR/Payload/$APP_NAME/Frameworks/$FRAMEWORK" ];
    then
        codesign --force --sign "$SIGNING_IDENTITY" --verbose "$WORKING_DIR/Payload/$APP_NAME/Frameworks/$FRAMEWORK"
    fi
}

sign_framework LineSDK
sign_framework LineSDKObjC

#####################################
echo "Sign Application"
codesign --force --entitlements "$ENTITLEMENTS" --sign "$SIGNING_IDENTITY" "$WORKING_DIR/Payload/$APP_NAME" --verbose
codesign --verify --verbose --deep --no-strict "$WORKING_DIR/Payload/$APP_NAME"

OUTPUT_IPA="$OUTPUT/"$IPA_NAME"_resigned.ipa"
cd $WORKING_DIR
zip -q --symlinks --recurse-paths "../.tmp_output.ipa" .
cd ..
mv ".tmp_output.ipa" "$OUTPUT_IPA"


# Cleanup
rm -Rf "$WORKING_DIR"
rm -f "$ENTITLEMENTS" 
rm -f "$WORKING_PROFILE_PLIST"
rm -f "$WORKING_PROFILE"
```

