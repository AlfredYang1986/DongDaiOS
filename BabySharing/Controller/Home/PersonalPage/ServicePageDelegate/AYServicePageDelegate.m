//
//  AYServicePageDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServicePageDelegate.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define WIDTH               SCREEN_WIDTH - 15*2

@interface AYFouceCell : UITableViewCell

@end

@implementation AYFouceCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
@end
/********* ********/

@interface AYMainCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *personal_info;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *babyNumbLabel;
@property (nonatomic, strong) UIImageView *starRangImage;
@property (nonatomic, strong) UILabel *aboutMMIntru;
@property (nonatomic, strong) UIButton *readMore;
@property (nonatomic, strong) UIButton *takeOffMore;

@property (nonatomic, strong) UIButton *dailyBtn;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIButton *showMore;
@property (nonatomic, strong) UIButton *costBtn;
@property (nonatomic, strong) UIButton *safePolicy;
@property (nonatomic, strong) UIButton *TDPolicy;
@end

@implementation AYMainCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel = [Tools setLabelWith:_titleLabel andText:@"一句话了解妈妈" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(30);
            make.left.equalTo(self).offset(18);
        }];
        
        _starRangImage = [[UIImageView alloc]init];
        _starRangImage.image = IMGRESOURCE(@"star_rang_1");
        [self addSubview:_starRangImage];
        [_starRangImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(90, 14));
        }];
        
        UILabel *countLabel = [[UILabel alloc]init];
        countLabel = [Tools setLabelWith:countLabel andText:@"(0)" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
        countLabel.text = @"(00)";
        [self addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_starRangImage);
            make.left.equalTo(_starRangImage.mas_right).offset(10);
        }];
        
        UILabel *babyAgeLabel = [[UILabel alloc]init];
        babyAgeLabel.text = @"我的孩子年龄：0岁宝宝";
        babyAgeLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        babyAgeLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:babyAgeLabel];
        [babyAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_starRangImage.mas_bottom).offset(10);
            make.left.equalTo(_titleLabel);
        }];
        
        _babyNumbLabel = [[UILabel alloc]init];
        _babyNumbLabel.text = @"我还可以看护的孩子：0个";
        _babyNumbLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        _babyNumbLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_babyNumbLabel];
        [_babyNumbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(babyAgeLabel.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
        }];
        
        UILabel *babyPlayingLabel = [[UILabel alloc]init];
        babyPlayingLabel.text = @"我可以带宝宝做什么：";
        babyPlayingLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        babyPlayingLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:babyPlayingLabel];
        [babyPlayingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_babyNumbLabel.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
        }];
        
        UILabel *MMLabel = [[UILabel alloc]init];
        MMLabel.text = @"看护妈妈：";
        MMLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        MMLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:MMLabel];
        [MMLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(babyPlayingLabel.mas_bottom).offset(25);
            make.left.equalTo(_titleLabel);
        }];
        UILabel *MMIntruLabel = [[UILabel alloc]init];
        MMIntruLabel.text = @"25岁妈妈  朝阳区，北京";
        MMIntruLabel.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
        MMIntruLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:MMIntruLabel];
        [MMIntruLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(MMLabel.mas_bottom).offset(8);
            make.left.equalTo(_titleLabel);
        }];
        
        UIImageView *photoImageView = [[UIImageView alloc]init];
        photoImageView.backgroundColor = [UIColor orangeColor];
        photoImageView.layer.cornerRadius = 26.f;
        photoImageView.clipsToBounds = YES;
        photoImageView.image = [UIImage imageNamed:@"lol"];
        [self addSubview:photoImageView];
        [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WIDTH - 52);
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
            make.left.equalTo(_titleLabel);
        }];
        _aboutMMIntru = [[UILabel alloc]init];
        _aboutMMIntru.text = @"关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈关于妈妈,关于妈妈关于妈妈关于妈妈,";
        _aboutMMIntru.textColor = [UIColor colorWithWhite:0.4f alpha:1.f];
        _aboutMMIntru.font = [UIFont systemFontOfSize:14.f];
        _aboutMMIntru.numberOfLines = 3.f;
        [self addSubview:_aboutMMIntru];
        [_aboutMMIntru mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(aboutMMTitle.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
            make.width.mas_equalTo(WIDTH);
        }];
        _readMore = [[UIButton alloc]init];
        [_readMore setTitle:@"阅读更多" forState:UIControlStateNormal];
        [_readMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        _readMore.titleLabel.textAlignment = NSTextAlignmentLeft;
        _readMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_readMore];
        [_readMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_aboutMMIntru.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 16));
        }];
        [_readMore addTarget:self action:@selector(didReadMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _takeOffMore = [[UIButton alloc]init];
        [_takeOffMore setTitle:@"收起" forState:UIControlStateNormal];
        [_takeOffMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        _takeOffMore.titleLabel.textAlignment = NSTextAlignmentLeft;
        _takeOffMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _takeOffMore.hidden = YES;
        [self addSubview:_takeOffMore];
        [_takeOffMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_aboutMMIntru.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(30, 16));
        }];
        [_takeOffMore addTarget:self action:@selector(didTakeOffMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        /*************************************/
        UIView *contentHeadView = [[UIView alloc]init];
        [self addSubview:contentHeadView];
        [contentHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_readMore.mas_bottom).offset(35);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(WIDTH, 90));
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
            make.left.equalTo(_titleLabel);
            make.width.mas_equalTo(WIDTH);
        }];
        _showMore = [[UIButton alloc]init];
        [_showMore setTitle:@"展开更多" forState:UIControlStateNormal];
        [_showMore setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        _showMore.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_showMore];
        [_showMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contextlabel.mas_bottom).offset(5);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 16));
        }];
        
        UILabel *safeDeviceLabel = [[UILabel alloc]init];
        safeDeviceLabel.text = @"安全设施：安全插座";
        safeDeviceLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        safeDeviceLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:safeDeviceLabel];
        [safeDeviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_showMore.mas_bottom).offset(25);
            make.left.equalTo(_titleLabel);
        }];
        
        UILabel *familyLabel = [[UILabel alloc]init];
        familyLabel.text = @"家庭成员描述：";
        familyLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        familyLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:familyLabel];
        [familyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeDeviceLabel.mas_bottom).offset(8);
            make.left.equalTo(_titleLabel);
        }];
        
        UILabel *addPlusLabel = [[UILabel alloc]init];
        addPlusLabel.text = @"附加：";
        addPlusLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.f];
        addPlusLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:addPlusLabel];
        [addPlusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(familyLabel.mas_bottom).offset(8);
            make.left.equalTo(_titleLabel);
        }];
        
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatBtn setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateNormal];
        _chatBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 27, 20, -27);
        [_chatBtn setTitle:@"与TA沟通" forState:UIControlStateNormal];
        [_chatBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _chatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _chatBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -10, -20, 10);
        [self addSubview:_chatBtn];
        [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addPlusLabel.mas_bottom).offset(30);
            make.left.mas_equalTo((WIDTH - 75)*0.5);
            make.size.mas_equalTo(CGSizeMake(75, 80));
        }];
        
        _dailyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dailyBtn setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateNormal];
        _dailyBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 27, 20, -27);
        [_dailyBtn setTitle:@"TA的日程" forState:UIControlStateNormal];
        [_dailyBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
        _dailyBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _dailyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dailyBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -10, -20, 10);
        [self addSubview:_dailyBtn];
        [_dailyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chatBtn);
            make.right.equalTo(_chatBtn.mas_left).offset(-50);
            make.size.equalTo(_chatBtn);
        }];
        
        _costBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_costBtn setImage:[UIImage imageNamed:@"tab_found_selected"] forState:UIControlStateNormal];
        _costBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 27, 20, -27);
        [_costBtn setTitle:@"费用说明" forState:UIControlStateNormal];
        [_costBtn setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
        _costBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _costBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _costBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -10, -20, 10);
        [self addSubview:_costBtn];
        [_costBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chatBtn);
            make.left.equalTo(_chatBtn.mas_right).offset(50);
            make.size.equalTo(_chatBtn);
        }];
        
        _safePolicy = [[UIButton alloc]init];
        [_safePolicy setTitle:@"安全政策" forState:UIControlStateNormal];
        [_safePolicy setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
        _safePolicy.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_safePolicy];
        [_safePolicy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chatBtn.mas_bottom).offset(20);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 16));
        }];
        
        _TDPolicy = [[UIButton alloc]init];
        [_TDPolicy setTitle:@"退订政策" forState:UIControlStateNormal];
        [_TDPolicy setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
        _TDPolicy.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_TDPolicy];
        [_TDPolicy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_safePolicy.mas_bottom).offset(10);
            make.left.equalTo(_titleLabel);
            make.size.mas_equalTo(CGSizeMake(60, 16));
        }];
        
    }
    return self;
}
//More
-(void)didReadMoreClick:(UIButton*)btn{
    _aboutMMIntru.numberOfLines = 6.f;
    _readMore.hidden = YES;
    _takeOffMore.hidden = NO;
}
-(void)didTakeOffMoreClick:(UIButton*)btn{
    _aboutMMIntru.numberOfLines = 3.f;
    _readMore.hidden = NO;
    _takeOffMore.hidden = YES;
}
@end
/********* ********/

@implementation AYServicePageDelegate{
    NSArray *imageNameArr;
    SDCycleScrollView *cycleScrollView;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    
    imageNameArr = @[@"lol",@"lol",@"lol"];
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)changeQueryData:(id)array{
//    querydata = (NSArray*)array;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
//        AYFouceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AYFouceCell" forIndexPath:indexPath];
        AYFouceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AYFouceCell"];
        if (cell == nil) {
            cell = [[AYFouceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYFouceCell"];
        }
        
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225) shouldInfiniteLoop:YES imageNamesGroup:imageNameArr];
        cycleScrollView.delegate = self;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        cycleScrollView.currentPageDotColor = [Tools themeColor];
        cycleScrollView.pageControlDotSize = CGSizeMake(10, 10);
        [cell addSubview:cycleScrollView];
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.autoScrollTimeInterval = 4.0;
        
        UIImageView *popImage = [[UIImageView alloc]init];
        popImage.image = IMGRESOURCE(@"bar_left_white");
        [cell addSubview:popImage];
        [popImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(18);
            make.top.equalTo(cell).offset(38);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        popImage.userInteractionEnabled = YES;
        [popImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPopImage:)]];
        
        UILabel *xFriend = [[UILabel alloc]init];
        xFriend = [Tools setLabelWith:xFriend andText:@"0个共同好友" andTextColor:[UIColor whiteColor] andFontSize:12.f andBackgroundColor:[UIColor clearColor] andTextAlignment:0];
        [cell addSubview:xFriend];
        [xFriend mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell).offset(-18);
            make.top.equalTo(cell).offset(39);
        }];
        UIImageView *friendsImage = [[UIImageView alloc]init];
        [friendsImage setBackgroundColor:[UIColor orangeColor]];
        friendsImage.layer.cornerRadius = 14.f;
        friendsImage.clipsToBounds = YES;
        [cell addSubview:friendsImage];
        [friendsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(xFriend.mas_left).offset(-12.5);
            make.centerY.equalTo(xFriend);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        friendsImage.userInteractionEnabled = YES;
        [friendsImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didXFriendImage:)]];
        
        UILabel *costLabel = [[UILabel alloc]init];
        costLabel = [Tools setLabelWith:costLabel andText:[NSString stringWithFormat:@"¥ %.1f／小时",80.f] andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.2f] andTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:costLabel];
        [costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell);
            make.bottom.equalTo(cell).offset(-15);
            make.size.mas_equalTo(CGSizeMake(125, 35));
        }];
        
        return (UITableViewCell*)cell;
    } else {
        AYMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AYMainCell"];
        if (cell == nil) {
            cell = [[AYMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYMainCell"];
        }
        
        [cell.chatBtn   addTarget:self  action:@selector(didChatBtnClick:)      forControlEvents:UIControlEventTouchUpInside];
        [cell.dailyBtn  addTarget:self  action:@selector(didDailyBtnClick:)     forControlEvents:UIControlEventTouchUpInside];
        [cell.showMore  addTarget:self  action:@selector(didShowMoreClick:)     forControlEvents:UIControlEventTouchUpInside];
        [cell.costBtn   addTarget:self  action:@selector(didCostBtnClick:)      forControlEvents:UIControlEventTouchUpInside];
        [cell.safePolicy addTarget:self action:@selector(didSafePolicyClick:)   forControlEvents:UIControlEventTouchUpInside];
        [cell.TDPolicy  addTarget:self  action:@selector(didTDPolicyClick:)     forControlEvents:UIControlEventTouchUpInside];
        
        return (UITableViewCell*)cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 225;
    }else {
        return 810;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat off_y = scrollView.contentOffset.y;
    NSLog(@"%f",off_y);
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollOffsetY:"];
    NSNumber *y = [NSNumber numberWithFloat:off_y];
    [cmd performWithResult:&y];
}

#pragma mark -- actions
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
-(void)didDailyBtnClick:(UIButton*)btn {
    
}
-(void)didChatBtnClick:(UIButton*)btn {
    
}
-(void)didCostBtnClick:(UIButton*)btn {
    
}

//2
-(void)didSafePolicyClick:(UIButton*)btn {
    
}

-(void)didTDPolicyClick:(UIButton*)btn {
    
}

-(void)didXFriendImage:(UIGestureRecognizer*)tap {
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"共同好友" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
}

-(void)didPopImage:(UIGestureRecognizer*)tap {
    id<AYCommand> pop = [self.notifies objectForKey:@"sendPopMessage"];
    [pop performWithResult:nil];
}
@end
