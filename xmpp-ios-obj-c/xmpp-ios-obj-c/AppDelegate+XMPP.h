//
//  AppDelegate+XMPP.h
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 14/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (XMPP)

- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
- (BOOL)connect;
- (void)disconnect;
- (void)sendMessage:(NSString *)message;

@end
