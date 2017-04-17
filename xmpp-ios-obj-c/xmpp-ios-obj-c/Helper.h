//
//  Helper.h
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 14/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void(^)())handler;

@end
