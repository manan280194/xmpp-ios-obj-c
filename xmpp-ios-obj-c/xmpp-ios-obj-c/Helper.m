//
//  Helper.m
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 14/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:dismiss];
    [[self topMostViewController] presentViewController:alertController animated:YES completion:nil];
}


+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void(^)())handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [alertController addAction:dismiss];
    [[self topMostViewController] presentViewController:alertController animated:YES completion:nil];
}


+ (UIViewController *)topMostViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
@end
