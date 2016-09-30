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
        UIButton* barBtn = [[UIButton alloc]init];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)IMGRESOURCE(@"bar_left_black").CGImage;
        layer.frame = CGRectMake(0, 0, 25, 25);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didSelectLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        leftBtn = barBtn;
        [self addSubview:barBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-4.f);
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(10.5f);
            make.width.equalTo(@30);
            make.height.equalTo(@26);
        }];
        
    }
    {
        UIButton* barBtn = [[UIButton alloc]init];
        CALayer * layer = [CALayer layer];
        layer.contents = (id)PNGRESOURCE(@"profile_setting_dark").CGImage;
        layer.frame = CGRectMake(0, 0, 25, 25);
        [barBtn.layer addSublayer:layer];
        [barBtn addTarget:self action:@selector(didSelectRightBtn) forControlEvents:UIControlEventTouchUpInside];
        rightBtn = barBtn;
        [self addSubview:barBtn];
        
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-4.f);
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-10.5f);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
    }
    
    self.backgroundColor = [UIColor whiteColor];
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
    
//    CALayer* line = [CALayer layer];
//    line.frame = CGRectMake(0, self.frame.size.height - 0.5, [UIScreen mainScreen].bounds.size.width, 0.5);
//    line.backgroundColor = [Tools garyLineColor].CGColor;
//    [self.layer addSublayer:line];
}

#pragma mark -- 
- (id)setTitleText:(id)args {
    
    NSString *title = (NSString*)args;
    UILabel *titleView = [self viewWithTag:999];
    if (!titleView) {
        
        titleView = [[UILabel alloc]init];
        titleView.tag = 999;
        titleView = [Tools setLabelWith:titleView andText:title andTextColor:[Tools blackColor] andFontSize:-16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:titleView];
        [titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.width.mas_lessThanOrEqualTo([UIScreen mainScreen].bounds.size.width - 180);
        }];
    }
    
    titleView.text = title;
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
    [leftBtn setImage:img forState:UIControlStateNormal];
    
    
//    for (CALayer* layer in leftBtn.layer.sublayers) {
//        [layer removeFromSuperlayer];
//    }
//
//    CALayer * layer = [CALayer layer];
//    layer.contents = (id)img.CGImage;
//    layer.frame = CGRectMake(0, 0, 25, 25);
//    [leftBtn.layer addSublayer:layer];
    return nil;
}

- (id)setRightBtnImg:(id)args {

    UIImage* img = (UIImage*)args;
    for (CALayer* layer in rightBtn.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    [rightBtn setImage:img forState:UIControlStateNormal];
    
//    CALayer * layer = [CALayer layer];
//    layer.contents = (id)img.CGImage;
//    layer.frame = CGRectMake(0, 0, 25, 25);
//    [rightBtn.layer addSublayer:layer];
    return nil;
}

- (id)setLeftBtnWithBtn:(id)args {
    UIButton* btn = (UIButton*)args;
    
    [leftBtn removeFromSuperview];
    [btn addTarget:self action:@selector(didSelectLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    leftBtn = btn;
    [self addSubview:btn];
    
    return nil;
}

- (id)setRightBtnWithBtn:(id)args {
    UIButton* btn = (UIButton*)args;
    
    [rightBtn removeFromSuperview];
    
    //    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //    btn.frame = CGRectMake(width - 15 - 30, 10, 30, 25);
    [btn addTarget:self action:@selector(didSelectRightBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBtn = btn;
    [self addSubview:btn];
    
    return nil;
}

- (id)setRightBtnWithTitle:(id)args {
    NSString* title = (NSString*)args;
    [rightBtn removeFromSuperview];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[Tools blackColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:title forState:UIControlStateNormal];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 10.5 - bar_right_btn.frame.size.width / 2, self.frame.size.height * 0.5);
    
    [bar_right_btn addTarget:self action:@selector(didSelectRightBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBtn = bar_right_btn;
    [self addSubview:bar_right_btn];
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

- (id)setBarBotLine {
    CALayer* line = [CALayer layer];
    line.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    line.backgroundColor = [Tools garyLineColor].CGColor;
    [self.layer addSublayer:line];
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
