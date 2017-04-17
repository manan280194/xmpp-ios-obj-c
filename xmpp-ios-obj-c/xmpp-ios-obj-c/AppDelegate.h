//
//  AppDelegate.h
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 12/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@import XMPPFramework;

//  ---------- If host name is dynamic, Provide host name in user defaults along with jabber id ----------

#define XMPPHostName @"your xmpp host name"
#define XMPPHostPort 5222 // your xmpp host port. default port - 5222

// ---------- Keys to store user default values. ----------

#define JabberID @"jabberID"
#define JabberPassword @"jabberPassword"
#define Recepient @"recepient"

@protocol XMPPDelegate <NSObject>

- (void)buddyWentOnline:(NSString *)name;
- (void)buddyWentOffline:(NSString *)name;
- (void)didDisconnect;
- (void)xmppConnectionSuccessful;
- (void)userCouldNotAuthenticate;
- (void)failedToRegisterUser;
- (void)userRegisteredSuccessfully;
- (void)messageReceived:(XMPPMessage *)message;
- (void)presenceReceivedFromUser:(NSString *)user;
- (void)userAuthenticatedSuccessfully;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPStreamDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id <XMPPDelegate> delegate;
@property (strong, nonatomic) XMPPStream *xmppStream;

@end

