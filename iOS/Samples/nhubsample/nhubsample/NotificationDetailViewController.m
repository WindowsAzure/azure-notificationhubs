//
//  NotificationDetailViewController.m
//  nhubsample
//
//  Copyright © 2018 Microsoft All rights reserved.
//  Licensed under the Apache License (2.0).
//

#import "NotificationDetailViewController.h"

@interface NotificationDetailViewController ()

@end

@implementation NotificationDetailViewController

- (id)initWithUserInfo:(NSDictionary *)userInfo {
    self = [super initWithNibName:@"NotificationDetail" bundle:nil];
    if (self) {
        _userInfo = userInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *aps = [_userInfo valueForKey:@"aps"];
    NSDictionary *alert = [aps valueForKey:@"alert"];
    self.titleLabel.text = [alert valueForKey:@"title"];
    self.bodyLabel.text = [alert valueForKey:@"body"];
}


- (IBAction)handleDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
