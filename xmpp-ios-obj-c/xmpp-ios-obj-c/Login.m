//
//  Login.m
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 12/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import "Login.h"
#import "AppDelegate+XMPP.h"

@interface Login ()

@end

@implementation Login

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        isCurrentProcessLogin = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.appDelegate setDelegate:self];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.appDelegate disconnect];
}


#pragma mark - Actions

- (IBAction)loginPressed:(id)sender {
    [self.view endEditing:YES];
    isCurrentProcessLogin = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:self.jabberID.text forKey:JabberID];
    [[NSUserDefaults standardUserDefaults] setValue:self.jabberPassword.text forKey:JabberPassword];
    
    if (![self.appDelegate.xmppStream isConnected]) {
        [self.appDelegate connect];
    }
}


- (IBAction)registerPressed:(id)sender {
    [self.view endEditing:YES];
    isCurrentProcessLogin = NO;
    [[NSUserDefaults standardUserDefaults] setValue:self.jabberID.text forKey:JabberID];
    [[NSUserDefaults standardUserDefaults] setValue:self.jabberPassword.text forKey:JabberPassword];
    
    if (![self.appDelegate.xmppStream isConnected]) {
        [self.appDelegate connect];
    }
}


#pragma mark - XMPP Delegate

- (void)didDisconnect {
    [Helper presentAlertWithTitle:@"XMPP" message:@"Disconnected"];
}


- (void)messageReceived:(XMPPMessage *)message {
    if (message.isErrorMessage) {
        [Helper presentAlertWithTitle:@"XMPP" message:[NSString stringWithFormat:@"Error: %@", message.errorMessage.localizedDescription]];
    } else {
        [Helper presentAlertWithTitle:@"XMPP" message:[NSString stringWithFormat:@"Message: %@", message.body]];
    }
}


- (void)xmppConnectionSuccessful {
//     ---------- Login or register -----------
    NSError *error = nil;
    NSString *jabberPassword = [[NSUserDefaults standardUserDefaults] stringForKey:JabberPassword];

    if (isCurrentProcessLogin) {
        [[self.appDelegate xmppStream] authenticateWithPassword:jabberPassword error:&error];
    } else {
        [[self.appDelegate xmppStream] registerWithPassword:jabberPassword error:&error];
    }
}


- (void)userAuthenticatedSuccessfully {
    [self.appDelegate.xmppStream disconnect];
    [Helper presentAlertWithTitle:@"XMPP" message:@"Authenticated Successfully" handler:^{
        [self performSegueWithIdentifier:@"contacts" sender:self];
    }];
}


- (void)userCouldNotAuthenticate {
    [self.appDelegate.xmppStream disconnect];
    [Helper presentAlertWithTitle:@"XMPP" message:@"Not authorised"];
}


- (void)presenceReceivedFromUser:(NSString *)user {
    [Helper presentAlertWithTitle:@"XMPP" message:@"Presence received"];
}


- (void)failedToRegisterUser {
    [Helper presentAlertWithTitle:@"XMPP" message:@"Registration Failed"];
}


- (void)userRegisteredSuccessfully {
    [self.appDelegate.xmppStream disconnect];
    [Helper presentAlertWithTitle:@"XMPP" message:@"Registration Successful" handler:^{
        [self performSegueWithIdentifier:@"contacts" sender:self];
    }];
}


- (void)buddyWentOnline:(NSString *)name {
    [Helper presentAlertWithTitle:@"XMPP" message:[NSString stringWithFormat:@"Went Online: %@", name]];
}


- (void)buddyWentOffline:(NSString *)name {
    [Helper presentAlertWithTitle:@"XMPP" message:[NSString stringWithFormat:@"Went Offline: %@", name]];
}

@end
