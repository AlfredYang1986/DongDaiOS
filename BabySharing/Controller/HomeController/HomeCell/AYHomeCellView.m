//
//  HomeCell.m
//  BabySharing
//
//  Created by monkeyheng on 16/3/10.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "AYHomeCellView.h"
#import "Tools.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "GPUImage.h"
#import "Define.h"
#import "PhotoTagView.h"
#import "QueryContentTag.h"
#import "QueryContentChaters.h"
#import "QueryContent+ContextOpt.h"
#import "AppDelegate.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYHomeCellDefines.h"
#import "AYFacadeBase.h"

@interface InsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end

@implementation InsetsLabel
@synthesize insets=_insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {2, 4, 2, 4};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}
@end

@interface AYHomeCellView ()

@property (nonatomic, strong, readonly) UIImageView *ownerImage;
@property (nonatomic, strong, readonly) UILabel *ownerNameLable;
@property (nonatomic, strong, readonly) InsetsLabel *ownerRole;
@property (nonatomic, strong, readonly) UILabel *ownerDate;
@property (nonatomic, strong, readonly) UIImageView *mainImage;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@property (nonatomic, strong, readonly) UILabel *praiseCount;
@property (nonatomic, strong, readonly) UILabel *usefulCount;
@property (nonatomic, strong, readonly) UIImageView *firstImage;
@property (nonatomic, strong, readonly) UIImageView *secondImage;
@property (nonatomic, strong, readonly) UIImageView *thirdImage;
@property (nonatomic, strong, readonly) UILabel *talkerCount;
@property (nonatomic, strong, readonly) UITextField *jionGroup;
@property (nonatomic, strong, readonly) UIImageView *videoSign;
@property (nonatomic, strong, readonly) QueryContentItem *queryContentItem;

@property (nonatomic, weak) QueryContent *content;

@property (nonatomic, strong) PhotoTagView *tagViewBand;
@property (nonatomic, strong) PhotoTagView *tagViewTime;
@property (nonatomic, strong) PhotoTagView *tagViewLocation;

@property (nonatomic, weak) UIView* filterView;
@end

@implementation AYHomeCellView {
    UIImageView *praiseImage;//
    UIImageView *pushImage;
    UIImageView *jionImage;
    UIView *lineView;
    UIView *jionGroupView;
    NSInteger indexChater;
    CGFloat originX;
}

@synthesize filterView = _filterView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.indexPath = indexPath;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _ownerImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_ownerImage];
        
        _ownerNameLable = [[UILabel alloc] init];
        _ownerNameLable.font = [UIFont systemFontOfSize:14];
        _ownerNameLable.textColor = TextColor;
        [self.contentView addSubview:_ownerNameLable];
        
        _ownerRole = [[InsetsLabel alloc]init];

        _ownerRole.text = @"";
        _ownerRole.font = [UIFont systemFontOfSize:12];
        _ownerRole.backgroundColor = [Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0];
        _ownerRole.textAlignment = NSTextAlignmentCenter;
        _ownerRole.layer.masksToBounds = YES;
        _ownerRole.layer.cornerRadius = 3;
        _ownerRole.layer.shouldRasterize = YES;
        _ownerRole.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _ownerRole.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_ownerRole];
        
        _ownerDate = [[UILabel alloc] init];
        _ownerDate.font = [UIFont systemFontOfSize:11];
        _ownerDate.textAlignment = NSTextAlignmentRight;
        _ownerDate.textColor = TextColor;
        [self.contentView addSubview:_ownerDate];
        
        _mainImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_mainImage];
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:15.0];
        _descriptionLabel.textColor = TextColor;
        [self.contentView addSubview:_descriptionLabel];
        
        praiseImage = [[UIImageView alloc] init];
        praiseImage.image = PNGRESOURCE(@"home_like_default");
        [self.contentView addSubview:praiseImage];
        _praiseCount = [[UILabel alloc] init];
        _praiseCount.font = [UIFont systemFontOfSize:12];
        _praiseCount.textAlignment = NSTextAlignmentCenter;
        _praiseCount.textColor = TextColor;
        _praiseCount.text = @"赞";
        
        pushImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        pushImage.image = PNGRESOURCE(@"push");
        [self.contentView addSubview:pushImage];
        [self.contentView addSubview:_praiseCount];
        _usefulCount = [[UILabel alloc] init];
        _usefulCount.textAlignment = NSTextAlignmentCenter;
        _usefulCount.font = [UIFont systemFontOfSize:12];
        _usefulCount.textColor = TextColor;
        _usefulCount.text = @"咚";
        
        // 中间的一条线
//        lineView = [CALayer layer];
        lineView = [[UIView alloc]init];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = [Tools colorWithRED:231.0 GREEN:231.0 BLUE:231.0 ALPHA:1.0];
        
        [self.contentView addSubview:_usefulCount];
        _firstImage = [[UIImageView alloc] init];
        _firstImage.tag = 1;
        _firstImage.clipsToBounds = YES;
        
        [self.contentView addSubview:_firstImage];
        _secondImage = [[UIImageView alloc] init];
        _secondImage.tag = 2;
        _secondImage.clipsToBounds = YES;
        
        [self.contentView addSubview:_secondImage];
        _thirdImage = [[UIImageView alloc] init];
        _thirdImage.tag = 3;
        _thirdImage.clipsToBounds = YES;
        
        [self.contentView addSubview:_thirdImage];
        _talkerCount = [[UILabel alloc] init];
        _talkerCount.text = @"没有返回全聊人数";
        _talkerCount.font = [UIFont systemFontOfSize:12];
        _talkerCount.textColor = TextColor;
        [self.contentView addSubview:_talkerCount];
        [self.contentView bringSubviewToFront:_talkerCount];
        
        _jionGroup = [[UITextField alloc] init];
        _jionGroup.enabled = YES;
        _jionGroup.font = [UIFont systemFontOfSize:12];
        _jionGroup.text = @"  加入圈聊";
        _jionGroup.textColor = TextColor;
        [self.contentView addSubview:_jionGroup];
        jionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        jionImage.image = PNGRESOURCE(@"home_chat");
        _jionGroup.leftView = jionImage;
        _jionGroup.leftViewMode = UITextFieldViewModeAlways;
        [self.contentView addSubview:_jionGroup];
        
        jionGroupView = [[UIView alloc] init];
        jionGroupView.alpha = 0.1;
        jionGroupView.backgroundColor = [UIColor whiteColor];
        [_jionGroup addSubview:jionGroupView];
        // 播放按钮
        _videoSign = [[UIImageView alloc] init];
        UIImage *image = PNGRESOURCE(@"playvideo");
        _videoSign.image = image;
        _videoSign.frame = CGRectMake(0, 0, 30, 30);
        [_mainImage addSubview:_videoSign];

        _tagViewBand = [[PhotoTagView alloc] initWithTagName:@"" andType:TagTypeBrand];
        [_mainImage addSubview:_tagViewBand];
        _tagViewTime = [[PhotoTagView alloc] initWithTagName:@"" andType:TagTypeTime];
        [_mainImage addSubview:_tagViewTime];
        _tagViewLocation = [[PhotoTagView alloc] initWithTagName:@"" andType:TagTypeLocation];
        [_mainImage addSubview:_tagViewLocation];

        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
        self.contentView.layer.shadowOpacity = 0.25;
        self.contentView.layer.shadowRadius = 2;
        self.contentView.layer.shouldRasterize = YES;
        self.contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.backgroundColor = [Tools colorWithRED:242.0 GREEN:242.0 BLUE:242.0 ALPHA:1.0];
        self.contentView.backgroundColor = [UIColor whiteColor];
        // 加入动作
        _ownerImage.userInteractionEnabled = YES;
        [_ownerImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherInfo)]];
        pushImage.userInteractionEnabled = YES;
        [pushImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushGroupTap)]];
        _mainImage.userInteractionEnabled = YES;
        [_mainImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainImageTap)]];
        praiseImage.userInteractionEnabled = YES;
        [praiseImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseImageTap)]];
        [_jionGroup addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jionGroupTap)]];
        
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.contentView.frame = CGRectMake(12.5, 10.5, CGRectGetWidth(self.contentView.frame) - 25, CGRectGetHeight(self.contentView.frame) - 10.5);
    [_ownerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    [_ownerNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ownerImage);
        make.left.equalTo(_ownerImage.mas_right).offset(8);
    }];

    [_ownerRole sizeToFit];
    [_ownerRole mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_ownerImage);
        make.left.equalTo(_ownerNameLable.mas_right).offset(10);
    }];

    if (CGRectGetWidth(_ownerRole.frame) != 0) {
        [_ownerRole mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_ownerImage);
            make.left.equalTo(_ownerNameLable.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-50);
            make.width.equalTo(@(CGRectGetWidth(_ownerRole.frame) + 8));
            make.height.equalTo(@(CGRectGetHeight(_ownerRole.frame) + 4));
        }];
    }

    [_ownerDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(16));
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@(50));
        make.height.equalTo(@(14));
    }];

    [_mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_ownerImage.mas_bottom).offset(8);
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-128);
    }];

    [_videoSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_mainImage);
        make.centerX.equalTo(_mainImage);
    }];



    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainImage.mas_bottom).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@18);
    }];

    [praiseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionLabel.mas_bottom).offset(14);
        make.left.equalTo(self.contentView).offset(17);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
    [_praiseCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(praiseImage);
        make.left.equalTo(praiseImage.mas_right).offset(10);
    }];
    
    [pushImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(praiseImage);
        make.left.equalTo(praiseImage.mas_right).offset(60);
        make.size.equalTo(praiseImage);
    }];

    [_usefulCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(praiseImage);
        make.left.equalTo(pushImage.mas_right).offset(10);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(praiseImage.mas_bottom).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];

    [_firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(8);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.width.equalTo(@28);
        make.height.equalTo(@28);
    }];

    [_secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstImage);
        make.left.equalTo(_firstImage).offset(22);
        make.size.equalTo(_firstImage);
    }];

    [_thirdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_secondImage);
        make.left.equalTo(_secondImage).offset(22);
        make.size.equalTo(_secondImage);
    }];

    [self.contentView bringSubviewToFront:_thirdImage];
    [self.contentView bringSubviewToFront:_secondImage];
    [self.contentView bringSubviewToFront:_firstImage];
    
    [_talkerCount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstImage);
        make.left.equalTo(self.contentView.mas_left).offset(originX);
    }];
    
    [_jionGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_firstImage);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(@85);
        make.height.equalTo(@26);
    }];
    
    [jionGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_jionGroup);
        make.left.equalTo(_jionGroup);
        make.size.equalTo(_jionGroup);
    }];
    
    [_tagViewBand mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.bounds.size.width * _tagViewBand.offset_y);
        make.left.mas_equalTo(self.contentView.bounds.size.width * _tagViewBand.offset_x);
        make.width.equalTo(@(_tagViewBand.bounds.size.width));
        make.height.equalTo(@(_tagViewBand.bounds.size.height));
    }];

    [_tagViewTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.bounds.size.width * _tagViewTime.offset_y);
        make.left.mas_equalTo(self.contentView.bounds.size.width * _tagViewTime.offset_x);
        make.width.equalTo(@(_tagViewTime.bounds.size.width));
        make.height.equalTo(@(_tagViewTime.bounds.size.height));
    }];

    [_tagViewLocation mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.bounds.size.width * _tagViewLocation.offset_y);
        make.left.mas_equalTo(self.contentView.bounds.size.width * _tagViewLocation.offset_x);
        make.width.equalTo(@(_tagViewLocation.bounds.size.width));
        make.height.equalTo(@(_tagViewLocation.bounds.size.height));
    }];

    // 圆角
    CGFloat radius = 14.f;
    CGFloat ownerImageRadius = 16.f;
    _ownerImage.layer.cornerRadius = ownerImageRadius;
    _ownerImage.layer.masksToBounds = YES;
    _ownerImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25].CGColor;
    _ownerImage.layer.borderWidth = 2;
    self.ownerImage.layer.shouldRasterize = YES;
    self.ownerImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    _thirdImage.layer.cornerRadius = radius;
    _thirdImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25 ].CGColor;
    _thirdImage.layer.borderWidth = 2.0;
    _secondImage.layer.cornerRadius = radius;
    _secondImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25 ].CGColor;
    _secondImage.layer.borderWidth = 2.0;
    self.secondImage.layer.shouldRasterize = YES;
    self.secondImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _firstImage.layer.cornerRadius = radius;
    _firstImage.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25 ].CGColor;
    _firstImage.layer.borderWidth = 2.0;
    self.firstImage.layer.shouldRasterize = YES;
    self.firstImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)updateViewWith:(QueryContent *)content {
    
    _firstImage.hidden = YES;
    _secondImage.hidden = YES;
    _thirdImage.hidden = YES;
    
    self.content = content;
    originX = 10;
    indexChater = 0;
    if (self.content.chaters.count > 0) {
        for (QueryContentChaters *chater in self.content.chaters) {
            if (indexChater == 3) {
                break;
            }
            UIImageView *imageView = [self.contentView viewWithTag:++indexChater];
            imageView.image = PNGRESOURCE(@"default_user");
            imageView.hidden = NO;
             UIImage *image = [TmpFileStorageModel enumImageWithName:chater.chaterImg withDownLoadFinishBolck:^(BOOL success, UIImage *img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = img;
                    });
                } else {
                    NSLog(@"MonkeyHengLog: %@ === %@", @"下载头像失败", chater.chaterImg);
                }
            }];
            if (image) {
                imageView.image = image;
            }
        }
        originX = originX + (indexChater) * 28 + 10 - (indexChater - 1) * 5;
    }
    
    
    self.ownerNameLable.text = content.owner_name;
    self.descriptionLabel.text = content.content_description;
    self.ownerRole.text = content.owner_role;
    self.ownerDate.text = [Tools compareCurrentTime:content.content_post_date];
    if ((unsigned long)self.content.chaters.count > 3) {
        NSLog(@"MonkeyHengLog: %lu === %d, %@", (unsigned long)self.content.chaters.count, self.content.group_chat_count.intValue, self.content.content_post_id);
    }
    self.talkerCount.text = [NSString stringWithFormat:@"%lu人正在圈聊", (unsigned long)(self.content.chaters == nil ? 0 : self.content.chaters.count)];

    // 设置头像
    self.ownerImage.image = [TmpFileStorageModel enumImageWithName:self.content.owner_photo withDownLoadFinishBolck:^(BOOL success, UIImage *img) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self) {
                    self.ownerImage.image = img;
                    NSLog(@"owner img download success");
                }
            });
        }
    }];
    
    if (self.ownerImage.image == nil) {
        self.ownerImage.image = PNGRESOURCE(@"default_user");// [UIImage imageNamed:defaultHeadPath];
    }
    
    // 设置大图
    for (QueryContentItem *item in self.content.items) {
        if (item.item_type.unsignedIntegerValue != PostPreViewMovie) {
            self.mainImage.image = [TmpFileStorageModel enumImageWithName:item.item_name withDownLoadFinishBolck:^(BOOL success, UIImage *img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            self.mainImage.image = img;
                            NSLog(@"owner img download success");
                        }
                    });
                }
            }];
            if (self.mainImage.image == nil) {
//                NSString *defaultMainPath = [resourceBundle pathForResource:[NSString stringWithFormat:@"chat_mine_bg"] ofType:@"png"];
                self.mainImage.image = PNGRESOURCE(@"chat_mine_bg"); //  [UIImage imageNamed:defaultMainPath];
            }
            break;
        }
    }
    _videoSign.hidden = YES;
    _queryContentItem = nil;
    for (QueryContentItem *item in self.content.items) {
        if (item.item_type.unsignedIntegerValue == PostPreViewMovie) {
            _queryContentItem = item;
            _videoSign.hidden = NO;
        }
    }
    
    praiseImage.image = self.content.isLike.integerValue == 0 ? PNGRESOURCE(@"home_like_default") : PNGRESOURCE(@"home_like_like");
    pushImage.image = self.content.isPush.integerValue == 0 ? PNGRESOURCE(@"push") : PNGRESOURCE(@"pushed");
    
    // 添加标签
    self.tagViewLocation.hidden = YES;
    self.tagViewBand.hidden = YES;
    self.tagViewTime.hidden = YES;

    QueryContent *tmp = (QueryContent*)_content;
    for (QueryContentTag *tag in tmp.tags) {
        NSLog(@"MonkeyHengLog: %@ === %d", @"tag", tag.tag_type.intValue);
        switch (tag.tag_type.intValue) {
            case TagTypeBrand:
                self.tagViewBand.hidden = NO;
                self.tagViewBand.content = tag.tag_content;
                self.tagViewBand.offset_x = tag.tag_offset_x.floatValue;
                self.tagViewBand.offset_y = tag.tag_offset_y.floatValue;
                break;
            case TagTypeTime:
                self.tagViewTime.hidden = NO;
                self.tagViewTime.content = tag.tag_content;
                self.tagViewTime.offset_x = tag.tag_offset_x.floatValue;
                self.tagViewTime.offset_y = tag.tag_offset_y.floatValue;
                break;
            case TagTypeLocation:
                self.tagViewLocation.hidden = NO;
                self.tagViewLocation.content = tag.tag_content;
                self.tagViewLocation.offset_x = tag.tag_offset_x.floatValue;
                self.tagViewLocation.offset_y = tag.tag_offset_y.floatValue;
                break;
            default:
                break;
        }
    }
}

- (void)changeMovie:(NSURL*)path {
    NSLog(@"start to play movie at home cell");
    
    if (path) {
        id<AYFacadeBase> f = MOVIEPLAYER;
        if (self.filterView == nil) {
            id<AYCommand> cmd_view = [f.commands objectForKey:@"MovieDisplayView"];
            id url = path;
            [cmd_view performWithResult:&url];
            
            self.filterView = url;
            
            self.filterView.frame = CGRectMake(0, 0, CGRectGetWidth(_mainImage.frame), CGRectGetHeight(_mainImage.frame));
            [_mainImage addSubview:self.filterView];
        }
        
        self.filterView.hidden = NO;
        id<AYCommand> cmd_play = [f.commands objectForKey:@"PlayMovie"];
        id url = path;
        [cmd_play performWithResult:&url];
    }
}

- (void)mainImageTap {
    if (_queryContentItem != nil) { //&& _gpuImageMovie.progress == 0) {
        NSURL* url = [TmpFileStorageModel enumFileWithName:_queryContentItem.item_name andType:_queryContentItem.item_type.unsignedIntegerValue withDownLoadFinishBlock:^(BOOL success, NSURL *path) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _videoSign.hidden = YES;
                    [self changeMovie:path];
                });
                
            } else {
                NSLog(@"down load movie %@ failed", _queryContentItem.item_name);
            }
        }];
        if (url) {
            _videoSign.hidden = YES;
            [self changeMovie:url];
        }
    }
}

- (void)stopViedo {
    NSLog(@"end to play movie at home cell");
    _videoSign.hidden = NO;
    
    id<AYFacadeBase> f = MOVIEPLAYER;
    id<AYCommand> cmd = [f.commands objectForKey:@"ReleaseMovie"];
    id url = [TmpFileStorageModel enumFileWithName:_queryContentItem.item_name andType:_queryContentItem.item_type.unsignedIntegerValue withDownLoadFinishBlock:nil];
    if (url != nil) {
        [cmd performWithResult:&url];
    }
    [self.filterView removeFromSuperview];
}

- (void)praiseImageTap {
    NSLog(@"heart btn did selected");
    if (self.content.isLike.integerValue == 1) {
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_content forKey:kAYHomeCellContentKey];
        [dic setValue:self forKey:kAYHomeCellCellKey];
        
        id<AYCommand> cmd = [self.notifies objectForKey:@"unLikePostItem:"];
        [cmd performWithResult:&dic];
        
    } else {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:_content forKey:kAYHomeCellContentKey];
        [dic setValue:self forKey:kAYHomeCellCellKey];
        
        id<AYCommand> cmd = [self.notifies objectForKey:@"likePostItem:"];
        [cmd performWithResult:&dic];
        
    }
}

- (void)pushGroupTap {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_content forKey:kAYHomeCellContentKey];
    [dic setValue:self forKey:kAYHomeCellCellKey];
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"pushPostItem:"];
    [cmd performWithResult:&dic];
}

- (void)jionGroupTap {
    NSLog(@"加入圈聊");
}

- (void)otherInfo {
    id<AYCommand> cmd = [self.notifies objectForKey:@"showUserInfo:"];
    QueryContent* args = _content;
    [cmd performWithResult:&args];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> header = VIEW(kAYHomeCellName, kAYHomeCellName);
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
- (id)willDisappear:(id)obj {
    
    NSDictionary* dic = (NSDictionary*)obj;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    [cell stopViedo];
    
    return nil;
}

- (id)resetContent:(id)obj {

    NSDictionary* dic = (NSDictionary*)obj;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    QueryContent* content = [dic objectForKey:kAYHomeCellContentKey];
    [cell updateViewWith:content];
    return nil;
}

- (id)queryContentCellHeight {
    return [NSNumber numberWithFloat:[UIScreen mainScreen].bounds.size.height - 60 - 44 - 35];
}

- (id)resetLike:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    NSNumber* like_result = [dic objectForKey:@"like_result"];
    
    cell.content.isLike = like_result;
    return nil;
}

- (id)resetPush:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    AYHomeCellView* cell = [dic objectForKey:kAYHomeCellCellKey];
    NSNumber* push_result = [dic objectForKey:@"push_result"];
    
    cell.content.isPush = push_result;
    return nil;
}

@end
