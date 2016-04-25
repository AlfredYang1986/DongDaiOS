//
//  AYProfilePushDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYProfilePushDelegate.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "QueryContent.h"
#import "QueryContentItem.h"
#import "AYAlbumDefines.h"
#import "AYQueryModelDefines.h"

@implementation AYProfilePushDelegate

- (void)changeCellInfo:(id<AYViewBase>)cell {
    id<AYCommand> cmd_info = [cell.commands objectForKey:@"setCellInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:cell forKey:kAYAlbumTableCellSelfKey];
    [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginLeftKey];
    [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginRightKey];
    [dic setValue:[NSNumber numberWithFloat:3.f] forKey:kAYAlbumTableCellCornerRadiusKey];
    [dic setValue:[NSNumber numberWithFloat:2.f] forKey:kAYAlbumTableCellMarginBetweenKey];
    [cmd_info performWithResult:&dic];
}
@end
