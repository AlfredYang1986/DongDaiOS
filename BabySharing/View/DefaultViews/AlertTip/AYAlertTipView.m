//
//  AYAlertTipView.m
//  BabySharing
//
//  Created by Alfred Yang on 29/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAlertTipView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "Tools.h"

@implementation AYAlertTipView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
}

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

#pragma mark -- commands
- (void)touchUpInside {
    id<AYCommand> cmd = [self.notifies objectForKey:@"touchUpInside"];
    [cmd performWithResult:nil];
}

- (instancetype)initWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor{
    self = [super init];
    if (self) {
        //        self.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
        self.layer.cornerRadius = 20.f;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5];
        
        _titleLabel = [UILabel new];
        _titleLabel = [Tools setLabelWith:_titleLabel andText:title andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [_titleLabel sizeToFit];
        _titleSize = _titleLabel.frame.size;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}
@end
