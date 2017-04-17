//
//  Login.h
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 12/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "AppDelegate.h"

@interface Login : UIViewController <XMPPDelegate> {
    BOOL isCurrentProcessLogin;
}

@property (strong, nonatomic) IBOutlet UITextField *jabberID;
@property (strong, nonatomic) IBOutlet UITextField *jabberPassword;

@property (strong, nonatomic) AppDelegate *appDelegate;

- (IBAction)loginPressed:(id)sender;
- (IBAction)registerPressed:(id)sender;

@end
