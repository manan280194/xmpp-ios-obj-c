//
//  AppDelegate.m
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 12/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+XMPP.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize xmppStream;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDLog addLogger:[[DDTTYLogger alloc] init]];
//    ---------- XMPP setup. Set host name and delegate ----------
    [self setupStream];
    return YES;
}

@end
