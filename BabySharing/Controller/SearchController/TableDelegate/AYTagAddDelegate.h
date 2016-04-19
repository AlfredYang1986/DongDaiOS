//
//  AYRoleTagAddDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYTagAddDelegate : NSObject <AYDelegateBase, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray* recommand_tags;
@property (nonatomic, strong) NSString* searchText;
@property (nonatomic, strong) NSArray* showing_tags;
@end
