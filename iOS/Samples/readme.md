# iOS Notification Hub Sample

This is a sample project intended to demonstrate the usage of the Azure Notification Hubs iOS Client SDK.  The sample app allows the developer to register the device with a Notification Hub with the given tags as well as unregister the device. 

This app handles the following scenarios
- Register and unregister the device with the Notification Hub with the given tags
- Receive push notifications
- Receive silent push notifications
- Handle mutable messages via a Notification Service Extension

## Getting Started

The sample application requires the following:
- macOS Sierra+
- Xcode 10+
- iOS device with iOS 10+

In order to set up the Azure Notification Hub, [follow the tutorial](https://docs.microsoft.com/en-us/azure/notification-hubs/notification-hubs-ios-apple-push-notification-apns-get-started) to create the required certificates and register your application.

To run the application, the following values in the `info.plist` must be changed:
- `NotificationHubConnectionString`: The `DefaultListenSharedAccessSignature` connection string to the notification hub
- `NotificationHubName`: The notification hub name such as "myhubname"

Once the values have been filled in, build and deploy the application to your device.  From there, you can register your device with the given tags for push, as well as unregister your device.

## Setting up the notification code

Diving into the code, the Azure Notification Hub, we can use the SDK to connect to the service taking both the connection string and hub name from the `info.plist`.

```objc
- (SBNotificationHub *)getNotificationHub {
    NSString *hubName = [[NSBundle mainBundle] objectForInfoDictionaryKey:NHInfoHubName];
    NSString *connectionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:NHInfoConnectionString];
    
    return [[SBNotificationHub alloc] initWithConnectionString:connectionString notificationHubPath:hubName];
}
```

We can then register for push notifications with sound and a badge with the following code:

```objc
- (void)handleRegister {
    UNAuthorizationOptions options =  UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    [center requestAuthorizationWithOptions:(options) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error requesting for authorization: %@", error);
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
```

And we can also unregister the application from the Azure Notification Hub with the following code:

```objc
- (void)handleUnregister {
    SBNotificationHub *hub = [self getNotificationHub];
    
    [hub unregisterNativeWithCompletion :^(NSError* error) {
        if (error != nil) {
            NSLog(@"Error unregistering for push: %@", error);
        } else {
            [self MessageBox:@"Registration Status" message:@"Unregistered"];
        }
    }];
}
```

## Handle a push notification

In order to demonstrate handling a push notification, use the Azure Portal for your Notification Hub and select "Test Send" to send messages to your application.  For example, we can send a simple message to our device by selecting the Apple Platform, adding your selected tags and the following message body:

```
{
    "aps": {
        "alert": {
            "title": "Alert title",
            "body": "This is the alert body"
        }
    }
}
```

Diving into the code, the push notifications were handled by two method implementations, `userNotificationCenter willPresentNotification` and `userNotification didReceiveNotificationResponse`.

```objc
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    // Your code goes here
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    // Your code goes here
}
```

## Handle a silent push

The iOS platform allows for [silent notifications](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/pushing_updates_to_your_app_silently?language=objc) to allow you to notify your application when new data becomes available.  Using the "Test Send" capability, we can send a silent notification using the `content-available` property in the message body.

```
{
    "aps": {
        "content-available": 1
    }
}
```

To handle this scenario in code, the `application:didReceiveRemoteNotification:fetchCompletionHandler:` method needs to be implemented such as the following:

```objc
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    NSLog(@"User Info : %@", userInfo);
    
    if(application.applicationState == UIApplicationStateInactive) {
        NSLog(@"Inactive");
        
        completionHandler(UIBackgroundFetchResultNewData);
    } else if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"Background");
        
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        NSLog(@"Active");
        
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
```

## Handle a mutable push message

The iOS platform also allows for you to [modify the incoming push notifications](https://developer.apple.com/documentation/usernotifications/modifying_content_in_newly_delivered_notifications?language=objc), for example if your message is encrypted or needs translation. We can test this scenario by adding the `mutable-content` flag to message body.

```
{
    "aps": {
        "alert": {
            "title": "Alert title",
            "body": "This is the alert body"
        },
        "mutable-content": 1
    }
}
```

This is implemented by adding a Notification Service Extension to the project and implementing the `didReceiveNotificationRequest` and `serviceExtensionTimeWillExpire` methods.

# Credits

- App icons are based on icons from [Material Design](https://material.io/tools/icons) and were packaged with [MakeAppIcon](https://makeappicon.com/).
