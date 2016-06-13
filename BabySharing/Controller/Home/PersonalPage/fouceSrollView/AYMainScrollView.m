//
//  AYMainScrollView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMainScrollView.h"
#import "AYCommandDefines.h"
#import "AYShowBoardCellView.h"
#import "Tools.h"
#import "AYControllerActionDefines.h"
#import "AYFactoryManager.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width

@interface AYMainScrollView()
@property (nonatomic, strong) UIButton *oneStarBtn;
@property (nonatomic, strong) UIButton *twoStarBtn;
@property (nonatomic, strong) UIButton *threeStarBtn;
@property (nonatomic, strong) UIButton *fourStarBtn;
@property (nonatomic, strong) UIButton *fiveStarBtn;
@end

@implementation AYMainScrollView{
    UILabel *aboutMMIntru;
    UIButton *readMore;
    UIButton *takeOffMore;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    CGFloat width = SCREEN_WIDTH - 15*2;
    self.contentSize = CGSizeMake(width, 810);
    self.scrollEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"带着宝宝画插画";
    titleLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.left.equalTo(self);
    }];
    
    UIButton *shareBtn = [[UIButton alloc]init];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor colorWithWhite:0.1f alpha:1.f] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH - 15*2 - 36);
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(36, 18));
    }];
    UIButton *collectBtn = [[UIButton alloc]init];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor colorWithWhite:0.1f alpha:1.f] forState:UIControlStateNormal];
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:collectBtn];
    [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareBtn.mas_left).offset(-10);
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(36, 18));
    }];
    
    _oneStarBtn = [[UIButton alloc]init];
    [self addSubview:_oneStarBtn];
    [self setImageAndSelectImage:_oneStarBtn WithName:@"tab_found"];
    [_oneStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    _twoStarBtn = [[UIButton alloc]init];
    [self addSubview:_twoStarBtn];
    [self setImageAndSelectImage:_twoStarBtn WithName:@"tab_found"];
    [_twoStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oneStarBtn.mas_right).offset(5);
        make.centerY.equalTo(_oneStarBtn);
        make.size.equalTo(_oneStarBtn);
    }];
    
    _threeStarBtn = [[UIButton alloc]init];
    [self addSubview:_threeStarBtn];
    [self setImageAndSelectImage:_threeStarBtn WithName:@"tab_found"];
    [_threeStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_twoStarBtn.mas_right).offset(5);
        make.centerY.equalTo(_oneStarBtn);
        make.size.equalTo(_oneStarBtn);
    }];
    
    _fourStarBtn = [[UIButton alloc]init];
    [self addSubview:_fourStarBtn];
    [self setImageAndSelectImage:_fourStarBtn WithName:@"tab_found"];
    [_fourStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_threeStarBtn.mas_right).offset(5);
        make.centerY.equalTo(_oneStarBtn);
        make.size.equalTo(_oneStarBtn);
    }];
    
    _fiveStarBtn = [[UIButton alloc]init];
    [self addSubview:_fiveStarBtn];
    [self setImageAndSelectImage:_fiveStarBtn WithName:@"tab_found"];
    [_fiveStarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fourStarBtn.mas_right).offset(5);
        make.centerY.equalTo(_oneStarBtn);
        make.size.equalTo(_oneStarBtn);
    }];
    
    UILabel *countLabel = [[UILabel alloc]init];
    countLabel.text = @"(0)";
    countLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    countLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_oneStarBtn);
        make.left.equalTo(_fiveStarBtn.mas_right).offset(10);
    }];
    
    UILabel *babyAgeLabel = [[UILabel alloc]init];
    babyAgeLabel.text = @"我的孩子年龄：0岁宝宝";
    babyAgeLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    babyAgeLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:babyAgeLabel];
    [babyAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneStarBtn.mas_bottom).offset(10);
        make.left.equalTo(self);
    }];
    
    UILabel *babyNumbLabel = [[UILabel alloc]init];
    babyNumbLabel.text = @"我还可以看护的孩子：0个";
    babyNumbLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    babyNumbLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:babyNumbLabel];
    [babyNumbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyAgeLabel.mas_bottom).offset(5);
        make.left.equalTo(self);
    }];
    
    UILabel *babyPlayingLabel = [[UILabel alloc]init];
    babyPlayingLabel.text = @"我可以带宝宝做什么：";
    babyPlayingLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    babyPlayingLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:babyPlayingLabel];
    [babyPlayingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyNumbLabel.mas_bottom).offset(5);
        make.left.equalTo(self);
    }];
    
    UILabel *MMLabel = [[UILabel alloc]init];
    MMLabel.text = @"看护妈妈：";
    MMLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    MMLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:MMLabel];
    [MMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyPlayingLabel.mas_bottom).offset(25);
        make.left.equalTo(self);
    }];
    UILabel *MMIntruLabel = [[UILabel alloc]init];
    MMIntruLabel.text = @"25岁妈妈  朝阳区，北京";
    MMIntruLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
    MMIntruLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:MMIntruLabel];
    [MMIntruLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MMLabel.mas_bottom).offset(8);
        make.left.equalTo(self);
    }];
    
    UIImageView *photoImageView = [[UIImageView alloc]init];
    photoImageView.backgroundColor = [UIColor orangeColor];
    photoImageView.layer.cornerRadius = 26.f;
    photoImageView.clipsToBounds = YES;
    photoImageView.image = [UIImage imageNamed:@"lol"];
    [self addSubview:photoImageView];
    [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(width - 52);
        make.top.equalTo(MMLabel.mas_top).offset(-5);
        make.size.mas_equalTo(CGSizeMake(52, 52));
    }];
    
    UILabel *aboutMMTitle = [[UILabel alloc]init];
    aboutMMTitle.text = @"关于妈妈";
    aboutMMTitle.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    aboutMMTitle.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:aboutMMTitle];
    [aboutMMTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(MMIntruLabel.mas_bottom).offset(10);
        make.left.equalTo(self);
    }];
    aboutMMIntru = [[UILabel alloc]init];
    aboutMMIntru.text = @"关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈,";
    aboutMMIntru.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
    aboutMMIntru.font = [UIFont systemFontOfSize:14.f];
    aboutMMIntru.numberOfLines = 3.f;
    [self addSubview:aboutMMIntru];
    [aboutMMIntru mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboutMMTitle.mas_bottom).offset(5);
        make.left.equalTo(self);
        make.width.mas_equalTo(width);
    }];
    readMore = [[UIButton alloc]init];
    [readMore setTitle:@"阅读更多" forState:UIControlStateNormal];
    [readMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    readMore.titleLabel.textAlignment = NSTextAlignmentLeft;
    readMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:readMore];
    [readMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboutMMIntru.mas_bottom).offset(5);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 16));
    }];
    [readMore addTarget:self action:@selector(didReadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    takeOffMore = [[UIButton alloc]init];
    [takeOffMore setTitle:@"收起" forState:UIControlStateNormal];
    [takeOffMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    takeOffMore.titleLabel.textAlignment = NSTextAlignmentLeft;
    takeOffMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
    takeOffMore.hidden = YES;
    [self addSubview:takeOffMore];
    [takeOffMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboutMMIntru.mas_bottom).offset(5);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 16));
    }];
    [takeOffMore addTarget:self action:@selector(didTakeOffMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    /*************************************/
    UIView *contentHeadView = [[UIView alloc]init];
    [self addSubview:contentHeadView];
    [contentHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(readMore.mas_bottom).offset(35);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(width, 90));
    }];
    UILabel *contentCount = [[UILabel alloc]init];
    contentCount.text = @"0条评论";
    contentCount.textColor = [UIColor redColor];
    contentCount.font = [UIFont systemFontOfSize:16.f];
    [contentHeadView addSubview:contentCount];
    [contentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentHeadView);
        make.left.equalTo(contentHeadView);
    }];
    UIImageView *iconImageView = [[UIImageView alloc]init];
    iconImageView.backgroundColor = [UIColor orangeColor];
    iconImageView.layer.cornerRadius = 20.f;
    iconImageView.clipsToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"lol"];
    [contentHeadView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentCount.mas_bottom).offset(20);
        make.left.equalTo(contentHeadView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    UILabel *contentName = [[UILabel alloc]init];
    contentName.text = @"细心妈妈";
    contentName.textColor = [UIColor colorWithWhite:0.3f alpha:1.f];
    contentName.font = [UIFont systemFontOfSize:14.f];
    [contentHeadView addSubview:contentName];
    [contentName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView);
        make.left.equalTo(iconImageView.mas_right).offset(20);
    }];
    UILabel *baby = [[UILabel alloc]init];
    baby.text = @"0岁宝宝";
    baby.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
    baby.font = [UIFont systemFontOfSize:14.f];
    [contentHeadView addSubview:baby];
    [baby mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentName.mas_bottom).offset(8);
        make.left.equalTo(contentName);
    }];
    UILabel *contentDate = [[UILabel alloc]init];
    contentDate.text = @"2016年6月12日";
    contentDate.textColor = [UIColor colorWithWhite:0.5f alpha:1.f];
    contentDate.font = [UIFont systemFontOfSize:14.f];
    [contentHeadView addSubview:contentDate];
    [contentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentName);
        make.right.equalTo(contentHeadView);
    }];
    /*************************************/
    
    UILabel *contextlabel = [[UILabel alloc]init];
    contextlabel.text = @"关于妈妈关于。妈妈关于妈妈,关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈,";
    contextlabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
    contextlabel.font = [UIFont systemFontOfSize:14.f];
    contextlabel.numberOfLines = 2.f;
    [self addSubview:contextlabel];
    [contextlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentHeadView.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.width.mas_equalTo(width);
    }];
    UIButton *showMore = [[UIButton alloc]init];
    [showMore setTitle:@"展开更多" forState:UIControlStateNormal];
    [showMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    showMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:showMore];
    [showMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contextlabel.mas_bottom).offset(5);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 16));
    }];
    [showMore addTarget:self action:@selector(didShowMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *safeDeviceLabel = [[UILabel alloc]init];
    safeDeviceLabel.text = @"安全设施：安全插座";
    safeDeviceLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    safeDeviceLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:safeDeviceLabel];
    [safeDeviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showMore.mas_bottom).offset(25);
        make.left.equalTo(self);
    }];
    
    UILabel *familyLabel = [[UILabel alloc]init];
    familyLabel.text = @"家庭成员描述：";
    familyLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    familyLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:familyLabel];
    [familyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(safeDeviceLabel.mas_bottom).offset(8);
        make.left.equalTo(self);
    }];
    
    UILabel *addPlusLabel = [[UILabel alloc]init];
    addPlusLabel.text = @"附加：";
    addPlusLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
    addPlusLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:addPlusLabel];
    [addPlusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(familyLabel.mas_bottom).offset(8);
        make.left.equalTo(self);
    }];
    
    UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateNormal];
    chatBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 27, 20, -27);
    [chatBtn setTitle:@"与TA沟通" forState:UIControlStateNormal];
    [chatBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    chatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    chatBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -10, -20, 10);
    [self addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addPlusLabel.mas_bottom).offset(30);
        make.left.mas_equalTo((width - 75)*0.5);
        make.size.mas_equalTo(CGSizeMake(75, 80));
    }];
    [chatBtn addTarget:self action:@selector(didChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *dailyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dailyBtn setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateNormal];
    dailyBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 27, 20, -27);
    [dailyBtn setTitle:@"TA的日程" forState:UIControlStateNormal];
    [dailyBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    dailyBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    dailyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    dailyBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -10, -20, 10);
    [self addSubview:dailyBtn];
    [dailyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chatBtn);
        make.right.equalTo(chatBtn.mas_left).offset(-50);
        make.size.equalTo(chatBtn);
    }];
    [dailyBtn addTarget:self action:@selector(didDailyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *costBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [costBtn setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateNormal];
    costBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 27, 20, -27);
    [costBtn setTitle:@"费用说明" forState:UIControlStateNormal];
    [costBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    costBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    costBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    costBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -10, -20, 10);
    [self addSubview:costBtn];
    [costBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chatBtn);
        make.left.equalTo(chatBtn.mas_right).offset(50);
        make.size.equalTo(chatBtn);
    }];
    [costBtn addTarget:self action:@selector(didCostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *safePolicy = [[UIButton alloc]init];
    [safePolicy setTitle:@"安全政策" forState:UIControlStateNormal];
    [safePolicy setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    safePolicy.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:safePolicy];
    [safePolicy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chatBtn.mas_bottom).offset(20);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 16));
    }];
    [safePolicy addTarget:self action:@selector(didSafePolicyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *TDPolicy = [[UIButton alloc]init];
    [TDPolicy setTitle:@"退订政策" forState:UIControlStateNormal];
    [TDPolicy setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    TDPolicy.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:TDPolicy];
    [TDPolicy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(safePolicy.mas_bottom).offset(10);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 16));
    }];
    [TDPolicy addTarget:self action:@selector(didTDPolicyClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews{
    [super layoutSubviews];
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

#pragma mark -- actions
- (void)didCellClick:(UIGestureRecognizer*)tap{
}

-(void)setImageAndSelectImage:(UIButton*)button WithName:(NSString*)imagename{
    [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imagename]] forState:UIControlStateSelected];
}

//More
-(void)didReadMoreClick:(UIButton*)btn{
    aboutMMIntru.numberOfLines = 6.f;
    readMore.hidden = YES;
    takeOffMore.hidden = NO;
}
-(void)didTakeOffMoreClick:(UIButton*)btn{
    aboutMMIntru.numberOfLines = 3.f;
    readMore.hidden = NO;
    takeOffMore.hidden = YES;
}

-(void)didShowMoreClick:(UIButton*)btn{
    id<AYCommand> des = DEFAULTCONTROLLER(@"ContentList");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    //    [dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
}

//* 1/1/1 *//
-(void)didDailyBtnClick:(UIButton*)btn{
    
}
-(void)didChatBtnClick:(UIButton*)btn{
    
}
-(void)didCostBtnClick:(UIButton*)btn{
    
}

//2
-(void)didSafePolicyClick:(UIButton*)btn{
    
}

-(void)didTDPolicyClick:(UIButton*)btn{
    
}

#pragma mark -- UIScroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


@end
