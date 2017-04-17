//
//  Contacts.m
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 12/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import "Contacts.h"
#import "AppDelegate+XMPP.h"

@interface Contacts ()

@end

@implementation Contacts

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        availableUsers = [[NSMutableArray alloc] init];
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.appDelegate setDelegate:self];
    if (![self.appDelegate.xmppStream isConnected]) {
        [self.appDelegate connect];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.appDelegate disconnect];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [availableUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.textLabel setText:availableUsers[indexPath.row]];
    return cell;
    
}

#pragma mark - UITableViewDelgate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showAlertToSendMessageForRow:indexPath.row];
}

#pragma mark - XMPP Delegate

- (void)didDisconnect {
    [Helper presentAlertWithTitle:@"XMPP" message:@"Disconnected"];
}

- (void)messageReceived:(XMPPMessage *)message {
    if (message.isErrorMessage) {
        [Helper presentAlertWithTitle:message.from.user message:[NSString stringWithFormat:@"Error: %@", message.errorMessage.localizedDescription]];
    } else {
        [Helper presentAlertWithTitle:message.from.user message:[NSString stringWithFormat:@"Message: %@", message.body]];
    }
}

- (void)xmppConnectionSuccessful {
    NSError *error = nil;
    NSString *jabberPassword = [[NSUserDefaults standardUserDefaults] stringForKey:JabberPassword];
    [[self.appDelegate xmppStream] authenticateWithPassword:jabberPassword error:&error];
}

- (void)userAuthenticatedSuccessfully {
    [self.appDelegate goOnline];
}

- (void)userCouldNotAuthenticate {
    [Helper presentAlertWithTitle:@"XMPP" message:@"Not authorised"];
}

- (void)presenceReceivedFromUser:(NSString *)user {
    [Helper presentAlertWithTitle:@"XMPP" message:[NSString stringWithFormat:@"Presence received name: %@", user]];
}

- (void)failedToRegisterUser {
    [Helper presentAlertWithTitle:@"XMPP" message:@"Registration Failed"];
}

- (void)userRegisteredSuccessfully {
    [Helper presentAlertWithTitle:@"XMPP" message:@"Registration Successful"];
}

- (void)buddyWentOnline:(NSString *)name {
    [Helper presentAlertWithTitle:@"XMPP" message:[NSString stringWithFormat:@"Went Online: %@", name]];
    if (![availableUsers containsObject:name]) {
        [availableUsers addObject:name];
        [self.tableView reloadData];
    }
}

- (void)buddyWentOffline:(NSString *)name {
    [Helper presentAlertWithTitle:@"XMPP" message:[NSString stringWithFormat:@"Went Offline: %@", name]];
    if ([availableUsers containsObject:name]) {
        [availableUsers removeObject:name];
        [self.tableView reloadData];
    }
}

#pragma mark - Helper

- (void)showAlertToSendMessageForRow:(NSInteger)row {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:availableUsers[row] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Message";
    }];
    UIAlertAction *send = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sendMessage:alertController.textFields[0].text forRow:row];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:send];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sendMessage:(NSString *)message forRow:(NSInteger)row {
    [[NSUserDefaults standardUserDefaults] setValue:availableUsers[row] forKey:Recepient];
    [self.appDelegate sendMessage:message];
}

@end
