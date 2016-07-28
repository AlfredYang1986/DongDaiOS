//
//  ChatViewCell.h
//  BabySharing
//
//  Created by Alfred Yang on 12/10/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"

//@class GotyeOCMessage;
@class EMMessage;

@interface AYChatMessageCellView : UITableViewCell <AYViewBase>

@property (nonatomic, weak, setter=setEMMessage:) EMMessage* message;

+ (CGFloat)preferredHeightWithInputText:(NSString*)content andSenderID:(NSString*)sender_user_id;

- (void)setEMMessage:(EMMessage*)msg;
@end
