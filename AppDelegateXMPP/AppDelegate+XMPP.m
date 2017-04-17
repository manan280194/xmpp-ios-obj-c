//
//  AppDelegate+XMPP.m
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 14/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import "AppDelegate+XMPP.h"

@implementation AppDelegate (XMPP)

#pragma mark - XMPP Methods

- (void)setupStream {
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream setHostName:XMPPHostName];
    [self.xmppStream setHostPort:XMPPHostPort];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (BOOL)connect {
    if (!self.xmppStream.isConnected) {
        NSString *jabberID = [self getMergedJabberID];
        NSString *jabberPassword = [[NSUserDefaults standardUserDefaults] stringForKey:JabberPassword];
        
        if (!self.xmppStream.isDisconnected) {
            return true;
        }
        if (jabberID == nil && jabberPassword == nil) {
            return false;
        }
        
        self.xmppStream.myJID = [XMPPJID jidWithString:jabberID];
        NSError *error = nil;
        if ([self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
            NSLog(@"XMPP: success");
            return true;
        } else {
            NSLog(@"XMPP:  error: %@", error);
            return false;
        }
    } else {
        return true;
    }
}

- (void)goOnline {
    XMPPPresence *presence = [XMPPPresence presence];
    NSString *domain = self.xmppStream.myJID.domain;
    
    if ([domain isEqualToString:@"gmail.com"] || [domain isEqualToString:@"gtalk.com"] || [domain isEqualToString:@"talk.google.com"]) {
        DDXMLElement *priority = [[DDXMLElement alloc] initWithName:@"priority" stringValue:@"24"];
        [presence addChild:priority];
    }
    
    [self.xmppStream sendElement:presence];
}

- (void)goOffline {
    XMPPPresence *presence = [[XMPPPresence alloc] initWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (void)disconnect {
    [self goOffline];
    [self.xmppStream disconnect];
}

#pragma mark - XMPP Delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    [[self delegate] xmppConnectionSuccessful];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    NSLog(@"XMPP: Authenticated successfully");
    [[self delegate] userAuthenticatedSuccessfully];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    NSLog(@"XMPP: Could not authenticate Error:%@", error);
    [[self delegate] userCouldNotAuthenticate];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    NSLog(@"XMPP: Registration successful");
    [[self delegate] userRegisteredSuccessfully];
    [self disconnect];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    NSLog(@"XMPP: Problem registering user error:%@", [error elementsForName:@"RECV"]);
    [[self delegate] failedToRegisterUser];
}

- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence {
    NSLog(@"XMPP: Did Send Presence %@", presence);
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error {
    NSLog(@"XMPP: Error presense %@", error);
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    
    NSLog(@"XMPP: presence received: %@", presence);
    
    NSString *presenceType = presence.type;
    NSString *myUsername = self.xmppStream.myJID.user;
    NSString *fromUser = presence.from.user;
    
    if (myUsername != fromUser) {
        if ([presenceType isEqualToString:@"available"]) {
            [[self delegate] buddyWentOnline:fromUser];
            [[self delegate] presenceReceivedFromUser:fromUser];
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            [[self delegate] buddyWentOffline:fromUser];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
    NSLog(@"XMPP: did send message: %@", message);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    [[self delegate] messageReceived:message];
}

// MARK:- Helper

- (NSString *)getMergedJabberID {
    // JabberID@Hostname
    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:JabberID];
    
    jabberID = [jabberID stringByAppendingString:[NSString stringWithFormat:@"@%@", XMPPHostName]];
    
    return jabberID;
}

- (void)sendMessage:(NSString *)message {
    // Target Address: UnitID@HostAddress
    NSString *targetAddress = [[NSUserDefaults standardUserDefaults] stringForKey:Recepient];
    targetAddress = [targetAddress stringByAppendingString:[NSString stringWithFormat:@"@%@", XMPPHostName]];
    
    XMPPJID *senderID = [XMPPJID jidWithString:targetAddress];
    XMPPMessage *messageElement = [XMPPMessage messageWithType:@"chat" to:senderID];
    [messageElement addBody:message];
    [self.xmppStream sendElement:messageElement];
}

@end
