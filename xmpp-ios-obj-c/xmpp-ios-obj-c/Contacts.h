//
//  Contacts.h
//  xmpp-ios-obj-c
//
//  Created by Vimal Rughani on 12/04/17.
//  Copyright © 2017 Virtual Reality Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"
#import "AppDelegate.h"

@interface Contacts : UITableViewController <XMPPDelegate> {
    NSMutableArray *availableUsers;
}

@property (strong, nonatomic) AppDelegate *appDelegate;

@end
