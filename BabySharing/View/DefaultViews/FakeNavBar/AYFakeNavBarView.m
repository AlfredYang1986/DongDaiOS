//
//  AYFakeNavBarView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFakeNavBarView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"

@implementation AYFakeNavBarView {
    UIButton* leftBtn;
    UIButton* rightBtn;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    {
        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 30, 25)];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)PNGRESOURCE(@"dongda_back").CGImage;
        layer.frame = CGRectMake(0, 0, 25, 25);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didSelectLeftBtn) forControlEvents:UIControlEventTouchDown];
        leftBtn = barBtn;
        [self addSubview:barBtn];
    }
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 15 - 30, 10, 30, 25)];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)PNGRESOURCE(@"profile_setting_dark").CGImage;
        layer.frame = CGRectMake(0, 0, 25, 25);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didSelectRightBtn) forControlEvents:UIControlEventTouchDown];
        rightBtn = barBtn;
        [self addSubview:barBtn];
    }
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

- (void)layoutSubviews {
    leftBtn.center = CGPointMake(leftBtn.center.x, self.frame.size.height / 2);
    rightBtn.center = CGPointMake(rightBtn.center.x, self.frame.size.height / 2);
}

#pragma mark -- 
- (id)setTitleText:(id)args {
    return nil;
}

- (id)setBackGroundColor:(id)args {
    
    UIColor* c = (UIColor*)args;
    self.backgroundColor = c;
    return nil;
}

- (id)setLeftBtnImg:(id)args {
    
    UIImage* img = (UIImage*)args;
    
    for (CALayer* layer in leftBtn.layer.sublayers) {
        [layer removeFromSuperlayer];
    }

    CALayer * layer = [CALayer layer];
    layer.contents = (id)img.CGImage;
    layer.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn.layer addSublayer:layer];
    return nil;
}

- (id)setRightBtnImg:(id)args {

    UIImage* img = (UIImage*)args;
    
    for (CALayer* layer in rightBtn.layer.sublayers) {
        [layer removeFromSuperlayer];
    }

    CALayer * layer = [CALayer layer];
    layer.contents = (id)img.CGImage;
    layer.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn.layer addSublayer:layer];
    return nil;
}

- (id)setLeftBtnVisibility:(id)args {
    BOOL bHidden = ((NSNumber*)args).boolValue;
    leftBtn.hidden = bHidden;
    return nil;
}

- (id)setRightBtnVisibility:(id)args {
    BOOL bHidden = ((NSNumber*)args).boolValue;
    rightBtn.hidden = bHidden;
    return nil;
}

#pragma mark -- notify
- (void)didSelectLeftBtn {
    id<AYCommand> n = [self.notifies objectForKey:@"leftBtnSelected"];
    [n performWithResult:nil];
}

- (void)didSelectRightBtn {
    id<AYCommand> n = [self.notifies objectForKey:@"rightBtnSelected"];
    [n performWithResult:nil];
}
@end
