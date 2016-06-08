//
//  AYShowBoardView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShowBoardView.h"
#import "AYCommandDefines.h"
#import "AYShowBoardCellView.h"
#import "Tools.h"

@implementation AYShowBoardView{
    NSArray *fiteResultArrWithLoc;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    
}

- (void)layoutSubviews{
    self.contentSize = CGSizeMake(310 * fiteResultArrWithLoc.count + 10, 0);
    for (int i = 0; i < fiteResultArrWithLoc.count; ++i) {
        CGFloat offset_x = 10 * (i+1) + 300 * i;
        AYShowBoardCellView *cell = [[AYShowBoardCellView alloc]initWithFrame:CGRectMake(offset_x, 10, 300, 70)];
        
        [self addSubview:cell];
    }
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

@end
