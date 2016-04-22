//
//  AYTagEntryView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagEntryView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"

#import "PhotoTagEnumDefines.h"

#define TAG_BTN_WIDTH                   50
#define TAG_BTN_HEIGHT                  TAG_BTN_WIDTH

#define TAG_ICON_WIDTH                  25
#define TAG_ICON_HEIGHT                 TAG_ICON_WIDTH

#define TAG_LABEL_WIDTH                 TAG_BTN_WIDTH
#define TAG_LABEL_HEIGHT                20
#define TAG_LABEL_FONT_SIXE             14.f

#define TAG_VIEW_WIDTH                  TAG_BTN_WIDTH
#define TAG_VIEW_HEIGHT                 TAG_BTN_HEIGHT + TAG_LABEL_HEIGHT

#define TAG_BTN_MARGIN_BETWEEN          (50 + TAG_BTN_WIDTH)

@implementation AYTagEntryView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)layoutSubviews {
//    CGFloat width = self.frame.size.width;
//    CGFloat height = self.frame.size.height;
//    CGFloat button_height = self.frame.size.height / 3;

    [_tagTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(TAG_BTN_WIDTH);
        make.height.mas_equalTo(TAG_BTN_WIDTH);
    }];
    
    [_tagBand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_tagTime.mas_left).offset(-45);
        make.size.equalTo(_tagTime);
    }];
    
    [_tagLocal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_tagTime.mas_right).offset(45);
        make.size.equalTo(_tagTime);
    }];
    
}

#pragma mark -- commands
- (void)postPerform {
    [self addSubview:[self addTagBtn:@"品牌" image:PNGRESOURCE(@"post_band_tag") tag:-3]];
    [self addSubview:[self addTagBtn:@"时刻" image:PNGRESOURCE(@"post_time_tag") tag:-2]];
    [self addSubview:[self addTagBtn:@"地点" image:PNGRESOURCE(@"post_location_tag") tag:-1]];
    
    _tagBand = [[UIView alloc]init];
    _tagTime = [[UIView alloc]init];
    _tagLocal = [[UIView alloc]init];
    for (UIView* tmp in self.subviews) {
        if (tmp.tag == -3) {
            _tagBand = tmp;
        }else if (tmp.tag == -2){
            _tagTime = tmp;
        }else _tagLocal = tmp;
    }
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selfSelected)];
    [self addGestureRecognizer:tap];
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

- (UIView*)addTagBtn:(NSString*)title image:(UIImage*)img tag:(NSInteger)tag {
    
    UIView* reVal = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TAG_VIEW_WIDTH, TAG_VIEW_HEIGHT)];
    
    UIButton* tag_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TAG_BTN_WIDTH, TAG_BTN_WIDTH)];
    //    tag_btn.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:0.7];
    tag_btn.layer.cornerRadius = TAG_BTN_WIDTH / 2;
    tag_btn.clipsToBounds = YES;
    tag_btn.titleLabel.text = title;
    tag_btn.titleLabel.hidden = YES;
    
    CALayer* icon = [CALayer layer];
    icon.contents = (id)img.CGImage;
    //    icon.frame = CGRectMake(0, 0, TAG_ICON_WIDTH, TAG_ICON_HEIGHT);
    icon.frame = CGRectMake(0, 0, TAG_BTN_WIDTH, TAG_BTN_WIDTH);
    icon.position = CGPointMake(TAG_BTN_WIDTH / 2, TAG_BTN_HEIGHT / 2);
    [tag_btn.layer addSublayer:icon];
    
    [tag_btn addTarget:self action:@selector(tagBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [reVal addSubview:tag_btn];
    
    UILabel* tag_label = [[UILabel alloc] initWithFrame:CGRectMake(0, TAG_BTN_HEIGHT + 2, TAG_LABEL_WIDTH, TAG_LABEL_HEIGHT)];
    tag_label.font = [UIFont systemFontOfSize:14.f];
    tag_label.textColor = [UIColor whiteColor];
    
    tag_label.textAlignment = NSTextAlignmentCenter;
    tag_label.text = title;
    
    reVal.tag = tag;
    [reVal addSubview:tag_label];
//    reVal.center = center;
    
    return reVal;
}

#pragma mark -- messages
- (id)startSubBtnAnimation {
    return nil;
}

- (void)tagBtnSelected:(UIButton*)sender {
    NSNumber* tag_type = nil;
    switch (sender.superview.tag) {
        case -3:
            tag_type = [NSNumber numberWithInteger:TagTypeBrand];
            break;
        case -2:
            tag_type = [NSNumber numberWithInteger:TagTypeTime];
            break;
        case -1:
            tag_type = [NSNumber numberWithInteger:TagTypeLocation];
            break;
        default:
            return;
    }
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"didTagEntrySelected:"];
    [cmd performWithResult:&tag_type];
}

- (void)selfSelected {
    id<AYCommand> cmd = [self.notifies objectForKey:@"entryViewTaped"];
    [cmd performWithResult:nil];
}
@end
