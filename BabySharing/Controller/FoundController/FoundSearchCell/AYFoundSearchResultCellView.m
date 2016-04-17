//
//  FoundSearchResultCell.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "AYFoundSearchResultCellView.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "Define.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFoundSearchResultCellDefines.h"

#define RECOMMEND_COUNT         3

#define MARGIN                  13
#define MARGIN_VER              12
// 内部
#define ICON_WIDTH              15
#define ICON_HEIGHT             15

#define TAG_HEIGHT              25
#define TAG_MARGIN              10
#define TAG_CORDIUS             5
#define TAG_MARGIN_BETWEEN      10.5

@interface AYFoundSearchResultCellView ()

@property (weak, nonatomic) IBOutlet UIImageView *nextIcon;
@property (strong, nonatomic) UIView* btn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margin1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margin2;
@property (strong, nonatomic) UILabel *resultCountLabel;
@end

@implementation AYFoundSearchResultCellView

//@synthesize resultCountLabel = _resultCountLabel;
@synthesize nextIcon = _nextIcon;

- (void)awakeFromNib {
    // Initialization code
    _nextIcon.image = PNGRESOURCE(@"found_more_friend_arror");
    
    CALayer* layer = [CALayer layer];
    layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    layer.borderWidth = 1.f;
    layer.frame = CGRectMake(0, [AYFoundSearchResultCellView preferredHeight] - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [self.layer addSublayer:layer];
    
    [self setUpReuseCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserPhotoImage:(NSArray *)img_arr {
    
    self.margin1.constant = -15;
    self.margin2.constant = -15;
//    self.imageArr = img_arr;
     // 圆形头像
    [self setSearchResultCount:img_arr.count];
   
    for (int index = 0; index < RECOMMEND_COUNT; ++index) {
         UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
         tmp.layer.cornerRadius = 0.f;
         tmp.layer.borderColor = [UIColor clearColor].CGColor;
         tmp.layer.borderWidth = 0.f;
    }

    for (int index = 0; index < MIN(RECOMMEND_COUNT, img_arr.count); ++index) {
        //        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSDictionary* iter = [img_arr objectAtIndex:index];
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.masksToBounds = YES;
        tmp.layer.borderWidth = 1.5;
        tmp.layer.borderColor = [UIColor whiteColor].CGColor;
        tmp.layer.cornerRadius = 19.f;
        tmp.clipsToBounds = YES;
        
        NSString* photo_name = [iter objectForKey:@"screen_photo"];
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        tmp.image = user_img;
                        NSLog(@"owner img download success");
                    }
                });
            } else {
                NSLog(@"down load owner image %@ failed", photo_name);
            }
        }];
        
        if (userImg == nil) {
            userImg = PNGRESOURCE(@"default_user");
        }
        [tmp setImage:userImg];
    }
}


- (void)setUserContentImages:(NSArray *)img_arr {
    // 方头像
    [self setSearchResultCount:img_arr.count];
    self.margin1.constant = 4;
    self.margin2.constant = 4;
   
    for (int index = 0; index < RECOMMEND_COUNT; ++index) {
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.cornerRadius = 0.f;
        tmp.layer.borderColor = [UIColor clearColor].CGColor;
        tmp.layer.borderWidth = 0.f;
        tmp.image = nil;
    }
    
    for (int index = 0; index < MIN(RECOMMEND_COUNT, img_arr.count); ++index) {
//        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSArray* items = [iter objectForKey:@"items"];
        NSDictionary* item = items.firstObject;
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.cornerRadius = 3.f;
        tmp.clipsToBounds = YES;
        
        tmp.layer.borderColor = [UIColor clearColor].CGColor;
        tmp.layer.borderWidth = 0.f;
        
        NSString* photo_name = [item objectForKey:@"name"];
        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self) {
                        tmp.image = user_img;
                        NSLog(@"owner img download success");
                    }
                });
            } else {
                NSLog(@"down load owner image %@ failed", photo_name);
            }
        }];
        
        if (userImg == nil) {
            userImg = PNGRESOURCE(@"default_user");
        }
        [tmp setImage:userImg];
    }
}

- (void)setSearchTag:(NSString*)title andType:(NSNumber*)type {
    
    UIFont* font = [UIFont systemFontOfSize:11.f];
    CGSize size = CGSizeMake(320, FLT_MAX);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize sz_font = [title boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
   
    if (_btn == nil) {
        _btn = [[UIView alloc] init];
        
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(TAG_MARGIN / 2, TAG_MARGIN / 4, ICON_WIDTH, ICON_HEIGHT)];
        img.tag = -98;
        [_btn addSubview:img];
        
        UILabel* label = [[UILabel alloc]init];
        label.font = font;
        label.tag = -99;
        label.textAlignment = NSTextAlignmentCenter;
        [_btn addSubview:label];
        
        _btn.clipsToBounds = YES;
        [self addSubview:_btn];
    }
    
    if (type.integerValue == -1) {
        CGSize sz = CGSizeMake(sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        
        _btn.frame = CGRectMake(0, 0, sz.width, 16);

        UIImageView* img = [_btn viewWithTag:-98];
        img.hidden = YES;
        
        UILabel* label = [_btn viewWithTag:-99];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(5, 0, sz_font.width, TAG_HEIGHT);
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(CGRectGetWidth(_btn.frame) / 2, CGRectGetHeight(_btn.frame) / 2);

        _btn.layer.cornerRadius = 3;
        _btn.layer.shouldRasterize = YES;
        _btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _btn.center = CGPointMake(CGRectGetWidth(_btn.frame) / 2 + MARGIN, [AYFoundSearchResultCellView preferredHeight] / 2);
        [_btn setBackgroundColor:[Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0]];
        _btn.center = CGPointMake(CGRectGetWidth(_btn.frame) / 2 + MARGIN, [AYFoundSearchResultCellView preferredHeight] / 2);

    } else {
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
       
        _btn.frame = CGRectMake(0, 0, sz.width, sz.height);
        UIImageView* img = [_btn viewWithTag:-98];
        img.center = CGPointMake(TAG_MARGIN / 2 + img.frame.size.width / 2, TAG_HEIGHT / 2);
        img.hidden = NO;
        if (type.integerValue == 0) {
            img.image = PNGRESOURCE(@"tag_location_dark");
        } else if (type.integerValue == 1) {
            img.image = PNGRESOURCE(@"tag_time_dark");
        } else if (type.integerValue == 3){
            img.image = PNGRESOURCE(@"tag_brand_dark");
        } else {
            
        }
        UILabel* label = [_btn viewWithTag:-99];
        label.text = title;
        label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        label.frame = CGRectMake(TAG_MARGIN + ICON_WIDTH, 0, sz_font.width, TAG_HEIGHT);
        
        _btn.layer.borderColor = [UIColor colorWithWhite:0.6078 alpha:1.f].CGColor;
        _btn.layer.borderWidth = 1.f;
        _btn.layer.cornerRadius = TAG_CORDIUS;

        [_btn setBackgroundColor:[UIColor whiteColor]];
        _btn.center = CGPointMake(MARGIN + _btn.frame.size.width / 2, [AYFoundSearchResultCellView preferredHeight] / 2);
    }

//    CGFloat width = self.frame.size.width;;
//    UIView* tmp = [self viewWithTag:-1];
//    if (width - MARGIN - sz.width - tmp.frame.origin.x > self.resultCountLabel.frame.size.width + 20) {
//        self.resultCountLabel.hidden = NO;
//    }
}

- (void)setSearchResultCount:(NSInteger)count {
    if (count > 0) {
        self.resultCountLabel.text = self.type == SearchRole ? [NSString stringWithFormat:@"已有%ld个人认领了该角色", (long)count] : [NSString stringWithFormat:@"共%ld个分享", (long)count];
        [self.resultCountLabel sizeToFit];
        self.resultCountLabel.hidden = NO;
    } else {
        self.resultCountLabel.hidden = YES;
    }
}

+ (CGFloat)preferredHeight {
    return 80;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _btn.center = _btn.center;
    self.resultCountLabel.center = CGPointMake(CGRectGetMaxX(_btn.frame) + 10 + self.resultCountLabel.frame.size.width / 2, CGRectGetMidY(_btn.frame));
}

- (UILabel *)resultCountLabel {
    if (_resultCountLabel == nil) {
        _resultCountLabel = [[UILabel alloc] init];
        _resultCountLabel.font = [UIFont systemFontOfSize:11.0];
        _resultCountLabel.textColor = TextColor;
        [self addSubview:_resultCountLabel];
    }
    return _resultCountLabel;
}

#pragma mark -- AYCommands
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> header = VIEW(kAYFoundSearchResultCellName, kAYFoundSearchResultCellName);
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

#pragma mark -- messages
- (id)setCellInfo:(id)obj {
   
    NSDictionary* dic = (NSDictionary*)obj;
    
    AYFoundSearchResultCellView* cell = [dic objectForKey:kAYFoundSearchResultCellCellKey];
   
    NSNumber* type = [dic objectForKey:kAYFoundSearchResultCellTagTypeKey];
    NSString* type_name = [dic objectForKey:kAYFoundSearchResultCellTagNameKey];
   
    [cell setSearchTag:type_name andType:type];
    
    if (type.integerValue >= 0) {
        [cell setUserContentImages:[dic objectForKey:kAYFoundSearchResultCellContentKey]];
    } else {
        [cell setUserPhotoImage:[dic objectForKey:kAYFoundSearchResultCellContentKey]];
    }
    
    return nil;
}

- (id)queryCellHeight {
    return [NSNumber numberWithFloat:[AYFoundSearchResultCellView preferredHeight]];
}
@end
