//
//  MessageNotificationDetailCell.h
//  BabySharing
//
//  Created by Alfred Yang on 10/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumDefines.h"
#import "AYQueryModelDefines.h"
#import "AYViewBase.h"

@class Notifications;

@interface AYNotificationCellView : UITableViewCell <AYViewBase>
@property (weak, nonatomic, setter=setCurrentContent:) Notifications* notification;

+ (CGFloat)preferedHeight;

- (void)setUserImage:(NSString*)photo_name;
- (NSString*)getActtionTmplate:(NotificationActionType)type;

- (void)setDetailTarget:(NSString*)screen_name andActionType:(NotificationActionType)type andConnectContent:(NSString*)Post_id;
- (void)setTimeLabel:(NSDate*)time_label;
- (void)setRelationShip:(UserPostOwnerConnections)connetions;

@end
