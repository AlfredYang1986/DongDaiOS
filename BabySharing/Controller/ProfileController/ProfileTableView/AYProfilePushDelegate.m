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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> v = VIEW(kAYAlbumTableCellName, kAYAlbumTableCellName);
    {
        id<AYCommand> cmd_info = [v.commands objectForKey:@"setCellInfo:"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginLeftKey];
        [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginRightKey];
        [dic setValue:[NSNumber numberWithFloat:3.f] forKey:kAYAlbumTableCellCornerRadiusKey];
        [dic setValue:[NSNumber numberWithFloat:2.f] forKey:kAYAlbumTableCellMarginBetweenKey];
        [cmd_info performWithResult:&dic];
    }
    
    id<AYCommand> cmd_height = [v.commands objectForKey:@"queryPerferedHeight"];
    NSNumber* height = nil;
    [cmd_height performWithResult:&height];
    return height.floatValue;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell = (id<AYViewBase>)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    {
        id<AYCommand> cmd_info = [cell.commands objectForKey:@"setCellInfo:"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:cell forKey:kAYAlbumTableCellSelfKey];
        [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginLeftKey];
        [dic setValue:[NSNumber numberWithFloat:10.5f] forKey:kAYAlbumTableCellMarginRightKey];
        [dic setValue:[NSNumber numberWithFloat:3.f] forKey:kAYAlbumTableCellCornerRadiusKey];
        [dic setValue:[NSNumber numberWithFloat:2.f] forKey:kAYAlbumTableCellMarginBetweenKey];
        [cmd_info performWithResult:&dic];
    }
    
    return (UITableViewCell*)cell;
}
@end
