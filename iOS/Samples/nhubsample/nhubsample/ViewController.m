//
//  ViewController.m
//  nhubsample
//
//  Copyright © 2018 MMicrosoft All rights reserved.
//  Licensed under the MIT license.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)handleRegister:(id)sender {
    [self showAlert:@"Register" withTitle:nil];
}

- (IBAction)handleUnregister:(id)sender {
    [self showAlert:@"Unregister" withTitle:nil];
}

- (void)showAlert:(NSString *)message withTitle:(NSString *)title {
    if (!title) {
        title = @"Alert";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}

@end
