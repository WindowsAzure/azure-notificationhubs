//
//  ViewController.m
//  nhubsample
//
//  Copyright © 2018 MMicrosoft All rights reserved.
//  Licensed under the MIT license.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load raw tags text from storage and initialize the text field
    NSString *tags = [[NSUserDefaults standardUserDefaults] valueForKey:NHUserDefaultTags];
    self.tagsTextField.text = tags;
}

- (IBAction)handleRegister:(id)sender {
    UNAuthorizationOptions options =  UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    
    // Save raw tags text in storage
    [[NSUserDefaults standardUserDefaults] setValue:self.tagsTextField.text forKey:@"notification_tags"];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    [center requestAuthorizationWithOptions:(options) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error requesting for authorization: %@", error);
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [self logAlert:notification.request.content.userInfo];
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    [self logAlert:response.notification.request.content.userInfo];
    completionHandler();
}

-(void)logAlert:(NSDictionary *)userInfo {
    NSLog(@"User Info : %@", userInfo);
    [self MessageBox:@"Notification" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]];
}

- (IBAction)handleUnregister:(id)sender {
    SBNotificationHub *hub = [self getNotificationHub];
    
    [hub unregisterNativeWithCompletion :^(NSError* error) {
        if (error != nil) {
            NSLog(@"Error unregistering for push: %@", error);
        } else {
            [self MessageBox:@"Registration Status" message:@"Unregistered"];
        }
    }];
}

-(void)MessageBox:(NSString *) title message:(NSString *)messageText {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messageText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}

- (SBNotificationHub *)getNotificationHub {
    NSString *hubName = [[NSBundle mainBundle] objectForInfoDictionaryKey:NHInfoHubName];
    NSString *connectionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:NHInfoConnectionString];
    
    NSLog(@"Loaded hub name: %@", hubName);
    NSLog(@"Loaded connection string: %@", connectionString);
    
    return [[SBNotificationHub alloc] initWithConnectionString:connectionString notificationHubPath:hubName];
}

@end
