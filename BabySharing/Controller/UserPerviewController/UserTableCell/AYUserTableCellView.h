//
//  UserSearchCell.h
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "AYQueryModelDefines.h"

@interface AYUserTableCellView : UITableViewCell <AYViewBase>

@property (nonatomic, strong) NSString* user_id;
@property (nonatomic, strong) NSString* screen_name;
@property (nonatomic, setter=setConnections:) UserPostOwnerConnections connections;

+ (CGFloat)preferredHeight;
@end
