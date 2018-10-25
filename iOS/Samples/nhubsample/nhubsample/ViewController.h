//
//  ViewController.h
//  nhubsample
//
//  Copyright © 2018 MMicrosoft All rights reserved.
//  Licensed under the MIT license.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>
#import <UserNotifications/UserNotifications.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *tagsTextField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIButton *unregisterButton;

@end

