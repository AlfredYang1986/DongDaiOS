//
//  AYFoundHotTagsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFoundHotTagsCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "FoundHotTagBtn.h"
#import "Tools.h"

#define MARGIN                  13
#define MARGIN_VER              12

// 内部
#define ICON_WIDTH              12
#define ICON_HEIGHT             12

#define TAG_HEIGHT              25
#define TAG_MARGIN              10
#define TAG_CORDIUS             5
#define TAG_MARGIN_BETWEEN      10.5

#define PREFERRED_HEIGHT        61

@implementation AYFoundHotTagsCellView {
    CALayer* line;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;


@synthesize isDarkTheme = _isDarkTheme;
@synthesize isHiddenSepline = _isHiddenSepline;
@synthesize ver_margin = _ver_margin;
//@synthesize delegate = _delegate;

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

#pragma mark -- life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)setUpReuseCell {
    //    id<AYViewBase> header = VIEW([self getViewName], [self getViewName]);
    id<AYViewBase> header = VIEW(@"FoundHotTagsCell", @"FoundHotTagsCell");
    self.commands = [[header commands] copy];
    self.notifies = [[header notifies] copy];
    
    for (AYViewCommand* cmd in self.commands.allValues) {
        cmd.view = self;
    }
    
    for (AYViewNotifyCommand* nty in self.notifies.allValues) {
        nty.view = self;
    }
    
    NSLog(@"reuser view with commands : %@", self.commands);
    NSLog(@"reuser view with notifications: %@", self.notifies);
}

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

+ (CGFloat)preferredHeightWithTags:(NSArray*)arr {
    return PREFERRED_HEIGHT;
}

- (void)setHiddenLine:(BOOL)b {
    _isHiddenSepline = b;
    line.hidden = _isHiddenSepline;
}

- (id)setHotTagsText:(id)obj{
    NSArray* arr = (NSArray*)obj;
    
    [self clearAllTags];
    
    CGFloat offset = 0;
    CGFloat preTagWidth = 0;
    for (NSString* tmp in arr) {
        
        UIFont* font = [UIFont systemFontOfSize:16.f];
        CGSize sz_font = [Tools sizeWithString:tmp withFont:font andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
        CGSize sz = CGSizeMake(TAG_MARGIN /*+ ICON_WIDTH*/ + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        FoundHotTagBtn* btn = [[FoundHotTagBtn alloc]init];
        btn.tag_name = tmp;
        btn.layer.borderColor = _isDarkTheme ? [UIColor whiteColor].CGColor : [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = TAG_CORDIUS;
        btn.clipsToBounds = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(roleTagBtnSelected:)];
        [btn addGestureRecognizer:tap];
        
        offset += TAG_MARGIN + preTagWidth;
        if ((offset + sz.width) > [UIScreen mainScreen].bounds.size.width - 20)
            break;
        
        [self addSubview:btn];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
//            make.top.equalTo(self).offset(4);
            make.left.equalTo(self).offset(offset);
            make.width.mas_equalTo(sz.width);
            make.height.mas_equalTo(sz.height);
        }];
        
        preTagWidth = sz.width;
        
        UILabel* label = [[UILabel alloc] init];
        [btn addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).offset(6);
            make.right.equalTo(btn).offset(-6);
        }];
        
        label.font = font;
        label.text = tmp;
        label.textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentLeft;
    }
    return nil;
}

- (void)setHotTagsTest:(NSArray*)arr {
    
    [self clearAllTags];
    
//    int index = 0;
//    CGFloat offset = 0;
//    for (RecommandRoleTag* tmp in arr) {
//        
//        UIFont* font = [UIFont systemFontOfSize:11.f];
//        //        CGSize sz_font = [tmp.tag_name sizeWithFont:font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
//        CGSize size = CGSizeMake(320, 2000); //设置一个行高上限
//        NSDictionary *attribute = @{NSFontAttributeName: font};
//        CGSize sz_font = [tmp.tag_name boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        CGSize sz = CGSizeMake(TAG_MARGIN /*+ ICON_WIDTH*/ + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
//        
//        FoundHotTagBtn* btn = [[FoundHotTagBtn alloc]initWithFrame:CGRectMake(0, 0, sz.width, sz.height)];
//        btn.tag_name = tmp.tag_name;
//        
//        UILabel* label = [[UILabel alloc]init];
//        label.font = font;
//        label.text = tmp.tag_name;
//        //        label.textColor = _isDarkTheme ? [UIColor whiteColor] : [UIColor brownColor];
//        label.textColor = _isDarkTheme ? [UIColor whiteColor] : TextColor;
//        label.frame = CGRectMake(TAG_MARGIN /*+ ICON_WIDTH*/, 0, sz_font.width, TAG_HEIGHT);
//        label.textAlignment = NSTextAlignmentLeft;
//        [btn addSubview:label];
//        
//        btn.layer.borderColor = _isDarkTheme ?[UIColor whiteColor].CGColor : [UIColor colorWithWhite:0.5922 alpha:1.0f].CGColor;
//        btn.layer.borderWidth = 1.f;
//        btn.layer.cornerRadius = TAG_CORDIUS;
//        btn.clipsToBounds = YES;
//        
//        //        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + index * (MARGIN + btn.frame.size.width), MARGIN_VER + btn.frame.size.height / 2);
//        //        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, _ver_margin + btn.frame.size.height / 2);
//        btn.center = CGPointMake(MARGIN + btn.frame.size.width / 2 + offset, 66 / 2 - 10);
//        offset += btn.frame.size.width + TAG_MARGIN_BETWEEN;
//        
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(roleTagBtnSelected:)];
//        [btn addGestureRecognizer:tap];
//        
//        if (offset >= [UIScreen mainScreen].bounds.size.width - 10)
//            break;
//        
//        [self addSubview:btn];
//        ++index;
//    }
}

- (id)setHotTags:(id)obj {
    NSArray* arr = (NSArray*)obj;
    
    [self clearAllTags];
    
    CGFloat offset = 0;
    CGFloat preTagWidth = 0;
    for (NSDictionary* tmp in arr) {
        UIFont* font = [UIFont systemFontOfSize:11.f];
        
        CGSize size = CGSizeMake(320, 2000); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: font};
        
        NSString* tag_name = [tmp objectForKey:@"tag_name"];
        NSInteger tag_type = ((NSNumber*)[tmp objectForKey:@"tag_type"]).integerValue;
        
        CGSize sz_font = [tag_name boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        offset += TAG_MARGIN + preTagWidth;
        if ((offset + sz.width) > [UIScreen mainScreen].bounds.size.width - 20)
            break;
        
        FoundHotTagBtn* btn = [[FoundHotTagBtn alloc]init];
        [self addSubview:btn];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
//            make.top.equalTo(self).offset(4);
            make.left.equalTo(self).offset(offset);
            make.width.mas_equalTo(sz.width);
            make.height.mas_equalTo(sz.height);
        }];
        
        preTagWidth = sz.width;
        btn.tag_name = tag_name;
        btn.tag_type = tag_type;
        
        UIImageView* img = [[UIImageView alloc] init];
        [btn addSubview:img];
        [img mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(btn).offset(6);
            make.width.mas_equalTo(ICON_WIDTH);
            make.height.mas_equalTo(ICON_HEIGHT);
        }];
        
        if (tag_type == 0) {
            img.image = PNGRESOURCE(@"tag_location_dark");
        } else if (tag_type == 1) {
            img.image = PNGRESOURCE(@"tag_time_dark");
        } else if (tag_type == 3){
            img.image = PNGRESOURCE(@"tag_brand_dark");
        }
        
        
        UILabel* label = [[UILabel alloc]init];
        [btn addSubview:label];
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.left.equalTo(img.mas_right).offset(5);
            make.right.equalTo(btn.mas_right).offset(-6);
        }];
        label.font = font;
        label.text = tag_name;
        label.textColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:0.9f];
        label.textAlignment = NSTextAlignmentLeft;
        
        btn.layer.borderColor = [UIColor colorWithRed:74.0 / 255.0 green:74.0 / 255.0 blue:74.0 / 255.0 alpha:0.45f].CGColor;
        btn.layer.borderWidth = 1.f;
        btn.layer.cornerRadius = TAG_CORDIUS;
        btn.clipsToBounds = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tagBtnSelected:)];
        [btn addGestureRecognizer:tap];
        NSLog(@"sunfei--%f",CGRectGetMaxY(self.frame));
    }
    
    return nil;
}

- (void)clearAllTags {
    while (self.subviews.count > 0) {
        [self.subviews.firstObject removeFromSuperview];
    }
    
    [self addButtomLine];
}

- (void)tagBtnSelected:(UITapGestureRecognizer*)tap {
//    FoundHotTagBtn* tmp = (FoundHotTagBtn*)tap.view;
//    [_delegate recommandTagBtnSelected:tmp.tag_name adnType:tmp.tag_type];
}

- (void)roleTagBtnSelected:(UITapGestureRecognizer*)tap {
//    FoundHotTagBtn* tmp = (FoundHotTagBtn*)tap.view;
//    [_delegate recommandRoleTagBtnSelected:tmp.tag_name];
}

- (void)addButtomLine{
    
    CALayer *lineup = [CALayer layer];
    lineup.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    lineup.borderWidth = 1.f;
    lineup.frame = CGRectMake(0, 61 - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [self.layer addSublayer:lineup];
    
}

- (id)queryCellHeight {
    return [NSNumber numberWithFloat:PREFERRED_HEIGHT];
}
@end
