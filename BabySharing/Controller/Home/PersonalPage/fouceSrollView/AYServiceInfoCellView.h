//
//  AYServiceInfoCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AYServiceInfoCellView : UITableViewCell
@property (nonatomic, strong) NSDictionary *service_info;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *babyNumbLabel;
@property (nonatomic, strong) UIImageView *starRangImage;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *MMAdressLabel;
//@property (nonatomic, strong) UILabel *aboutMMIntru;
@property (nonatomic, strong) UILabel *recallPersent;

@property (nonatomic, strong) UIButton *readMore;
@property (nonatomic, strong) UIButton *takeOffMore;
@property (nonatomic, strong) UIButton *dailyBtn;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIButton *showMore;
@property (nonatomic, strong) UIButton *costBtn;
@property (nonatomic, strong) UIButton *safePolicy;
@property (nonatomic, strong) UIButton *TDPolicy;
@end
