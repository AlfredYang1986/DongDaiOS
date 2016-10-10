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

#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYControllerActionDefines.h"

#import <QuartzCore/QuartzCore.h>

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
    [super awakeFromNib];
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
    
     // 圆形头像
    [self setSearchResultCount:img_arr.count];
   
    for (int index = 0; index < RECOMMEND_COUNT; ++index) {
         UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
         tmp.layer.cornerRadius = 0.f;
         tmp.layer.borderColor = [UIColor clearColor].CGColor;
         tmp.layer.borderWidth = 0.f;
    }

    for (int index = 0; index < MIN(RECOMMEND_COUNT, img_arr.count); ++index) {
        NSDictionary* iter = [img_arr objectAtIndex:index];
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.masksToBounds = YES;
        tmp.layer.borderWidth = 3;
        tmp.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.45].CGColor;
        tmp.layer.cornerRadius = 19.f;
        tmp.clipsToBounds = YES;
        
        UIView *border = [[UIView alloc]initWithFrame:CGRectMake(-1, -1, tmp.bounds.size.width+2, tmp.bounds.size.width+2)];
        border.layer.masksToBounds = YES;
        border.layer.borderWidth = 2.5;
        border.layer.borderColor = [UIColor whiteColor].CGColor;
        border.layer.cornerRadius = (tmp.bounds.size.width + 3) * 0.5;
        [tmp addSubview:border];
        [tmp bringSubviewToFront:border];
//        [border drawRect:tmp.frame];
//        
//        UIGraphicsBeginImageContext(tmp.frame.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
//        CGContextSetLineWidth(context, 1.0);//线的宽度
//        CGContextAddArc(context, 19, 19, 2, 0, 2*3.14, 0); //添加一个圆
//        CGContextDrawPath(context, kCGPathStroke); //绘制路径
//        
//        UIGraphicsEndImageContext();
        
        
        NSString* photo_name = [iter objectForKey:@"screen_photo"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:photo_name forKey:@"image"];
        [dic setValue:@"img_icon" forKey:@"expect_size"];
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            UIImage* img = (UIImage*)result;
            if (img != nil) {
                tmp.image = img;
            }else{
                [tmp setImage:IMGRESOURCE(@"default_user")];
            }
        }];
        
//        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
//            if (success) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (self) {
//                        tmp.image = user_img;
//                        NSLog(@"owner img download success");
//                    }
//                });
//            } else {
//                NSLog(@"down load owner image %@ failed", photo_name);
//            }
//        }];
//        
//        if (userImg == nil) {
//            userImg = PNGRESOURCE(@"default_user");
//        }
//        [tmp setImage:userImg];
    }
}

- (void)setUserContentImages:(NSArray *)img_arr {
    // 正方形 发布图片
    [self setSearchResultCount:img_arr.count];
    self.margin1.constant = 4;
    self.margin2.constant = 4;
   
    for (int index = 0; index < RECOMMEND_COUNT; ++index) {
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.cornerRadius = 0.f;
        tmp.layer.borderColor = [UIColor clearColor].CGColor;
        tmp.layer.borderWidth = 0.f;
        [tmp.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        tmp.image = nil;
    }
    
    for (int index = 0; index < MIN(RECOMMEND_COUNT, img_arr.count); ++index) {
        NSDictionary* iter = [img_arr objectAtIndex:index];
        NSArray* items = [iter objectForKey:@"items"];
        NSDictionary* item = items.firstObject;
        
        UIImageView* tmp = (UIImageView*)[self viewWithTag:-3 + index];
        tmp.layer.cornerRadius = 3.f;
        tmp.clipsToBounds = YES;
        
        tmp.layer.borderColor = [UIColor clearColor].CGColor;
        tmp.layer.borderWidth = 0.f;
        
        NSString* photo_name = [item objectForKey:@"name"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:photo_name forKey:@"image"];
        [dic setValue:@"img_icon" forKey:@"expect_size"];
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            UIImage* img = (UIImage*)result;
            if (img != nil) {
                tmp.image = img;
            }else{
                [tmp setImage:PNGRESOURCE(@"default_user")];
            }
        }];
        
//        UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
//            if (success) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (self) {
//                        tmp.image = user_img;
//                        NSLog(@"owner img download success");
//                    }
//                });
//            } else {
//                NSLog(@"down load owner image %@ failed", photo_name);
//            }
//        }];
//        
//        if (userImg == nil) {
//            userImg = PNGRESOURCE(@"default_user");
//        }
//        [tmp setImage:userImg];
    }
}

- (void)setSearchTag:(NSString*)title andType:(NSNumber*)type {
    
    UIFont* font = [UIFont systemFontOfSize:11.f];
    CGSize size = CGSizeMake(320, FLT_MAX);
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize sz_font = [title boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
   
    if (_btn == nil) {
        _btn = [[UIView alloc] init];
        [self addSubview:_btn];
        
        UIImageView* img = [[UIImageView alloc]init];
        [_btn addSubview:img];
        img.tag = -98;
        
        UILabel* label = [[UILabel alloc]init];
        [_btn addSubview:label];
        label.font = font;
        label.tag = -99;
        label.textAlignment = NSTextAlignmentCenter;

        _btn.clipsToBounds = YES;
    }
    
    if (type.integerValue == -1) {
        self.type = SearchRole;
        
        CGSize sz = CGSizeMake(sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        _btn.layer.borderWidth = 0.f;
        [_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(TAG_MARGIN);
            make.width.mas_equalTo(sz.width + TAG_MARGIN);
            make.height.mas_equalTo(TAG_HEIGHT);
        }];
        
        UIImageView* img = [_btn viewWithTag:-98];
        img.hidden = YES;
        
        UILabel* label = [_btn viewWithTag:-99];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btn);
            make.left.equalTo(_btn.mas_left).offset(TAG_MARGIN *0.5);
            make.right.equalTo(_btn.mas_right).offset(-TAG_MARGIN *0.5);
        }];
        
        _btn.layer.cornerRadius = 3;
        _btn.layer.shouldRasterize = YES;
        _btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [_btn setBackgroundColor:[Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0]];

    } else {
        self.type = SearchSige;
        CGSize sz = CGSizeMake(TAG_MARGIN + ICON_WIDTH + sz_font.width + TAG_MARGIN, TAG_HEIGHT);
        UIImageView* img = [_btn viewWithTag:-98];
        img.hidden = NO;
        
        _btn.layer.borderColor = [UIColor colorWithWhite:0.6078 alpha:1.f].CGColor;
        _btn.layer.borderWidth = 1.f;
        _btn.layer.cornerRadius = TAG_CORDIUS;
        [_btn setBackgroundColor:[UIColor whiteColor]];
        
        [_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(TAG_MARGIN);
            make.width.mas_equalTo(sz.width);
            make.height.mas_equalTo(TAG_HEIGHT);
        }];
        
        if (type.integerValue == 0) {
            img.image = PNGRESOURCE(@"tag_location_dark");
        } else if (type.integerValue == 1) {
            img.image = PNGRESOURCE(@"tag_time_dark");
        } else if (type.integerValue == 3){
            img.image = PNGRESOURCE(@"tag_brand_dark");
        } else {
            
        }
        
        [img mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btn);
            make.left.equalTo(_btn.mas_left).offset(TAG_MARGIN * 0.5);
            make.width.mas_equalTo(ICON_WIDTH);
            make.height.mas_equalTo(ICON_HEIGHT);
        }];
        
        UILabel* label = [_btn viewWithTag:-99];
        label.text = title;
        label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
        
        [label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_btn);
            make.left.equalTo(img.mas_right).offset(0);
            make.right.equalTo(_btn.mas_right).offset(- TAG_MARGIN * 0.5);
        }];
        
    }
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
    return 61;
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
    id<AYViewBase> cell = VIEW(kAYFoundSearchResultCellName, kAYFoundSearchResultCellName);
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_resultCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(_btn.mas_right).offset(TAG_MARGIN);
    }];
    
}
@end
