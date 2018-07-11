//
//  AYPublishConfirmView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYPublishConfirmView.h"
#import "AYShadowRadiusView.h"
#import "AYFacadeBase.h"

@implementation AYPublishConfirmView {
    
    UIImageView *imageView;
    UILabel *location;
    UILabel *age;
    UILabel *course;
    
}

@synthesize delegate = _delegate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        AYShadowRadiusView *shadowView = [[AYShadowRadiusView alloc] initWithRadius:4];
        
        [self addSubview:shadowView];
        
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self);
            make.top.mas_equalTo(36);
            
        }];
        
        AYShadowRadiusView *imageShadowView = [[AYShadowRadiusView alloc] initWithRadius:3];
        
        [shadowView addSubview:imageShadowView];
        
        [imageShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(shadowView.mas_top);
            make.centerX.equalTo(shadowView);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(72);
            
        }];
        
        imageView= [[UIImageView alloc] init];
        [imageShadowView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.bottom.equalTo(imageShadowView);
            
        }];
        
        location = [UILabel creatLabelWithText:@"朝阳区酒仙桥路52号院" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
                             
        [shadowView addSubview:location];
        
        [location mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(shadowView);
            make.top.equalTo(imageShadowView.mas_bottom).offset(24);
            
        }];
        
        UIImageView *icon = [[UIImageView alloc] init];
        [shadowView addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(11);
            make.right.equalTo(self -> location.mas_left).offset(-4);
            make.centerY.equalTo(self -> location);
            
        }];
        [icon setImage:IMGRESOURCE(@"map_icon_location_sign")];
        
        UILabel *courseName = [UILabel creatLabelWithText:@"课程名称" textColor:[UIColor gary166] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [shadowView addSubview:courseName];
        
        [courseName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(16);
            make.top.equalTo(self -> location.mas_bottom).offset(50);
            
        }];
        
        [courseName setFont:[UIFont regularFontSF:15]];
        
        UILabel *ageName = [UILabel creatLabelWithText:@"孩子年龄" textColor:[UIColor gary166] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [shadowView addSubview:ageName];
        
        [ageName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(courseName);
            make.top.equalTo(courseName.mas_bottom).offset(17);
            
        }];
        [ageName setFont:[UIFont regularFontSF:15]];
        
        course = [UILabel creatLabelWithText:@"123" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentRight];
        
        [shadowView addSubview:course];
        
        [course mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-16);
            make.centerY.equalTo(courseName);
            
        }];
        [course setFont:[UIFont mediumFont:15]];
        
        age = [UILabel creatLabelWithText:@"5岁-12岁" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentRight];
        [shadowView addSubview:age];
        
        [age mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self -> course);
            make.centerY.equalTo(ageName);
            
        }];
        [age setFont:[UIFont regularFont:15]];
        
        UIView *line = [[UIView alloc] init];
        [shadowView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(shadowView);
            make.bottom.equalTo(shadowView).offset(-53);
            make.height.mas_equalTo(1);
            
        }];
        
        [line setBackgroundColor:[UIColor garyLine]];
        
        
        UIButton *button = [UIButton creatBtnWithTitle:@"去设置开放体验日" titleColor:[UIColor theme] fontSize:15.0f backgroundColor:nil];
        
        [shadowView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(shadowView);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(150);
            make.top.equalTo(line).offset(6);
        }];
        
        [button.titleLabel setFont:[UIFont regularFont:15.0f]];
        [button setImage:IMGRESOURCE(@"details_icon_arrow_right") forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 133, 0, -133)];
        [button addTarget:self action:@selector(setOpenDay) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setUp:(NSDictionary *)dic {
    
    NSDictionary *service = [dic objectForKey:@"service"];
    
    NSDictionary *serviceData = [service objectForKey:@"service_data"];
    
    NSString *service_image = [serviceData objectForKey:@"service_image"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:service_image forKey:@"key"];
    [dict setValue:imageView forKey:@"imageView"];
    [dict setValue:@228 forKey:@"wh"];
    
    id tmp = [dict copy];
    id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
    id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
    
    [cmd_oss_get performWithResult:&tmp];
    
    NSDictionary *temp = [[dic objectForKey:@"temp"] objectForKey:@"age_boundary"];
    
    NSString *ageMax = [NSString stringWithFormat:@"%.1f",[(NSNumber *)[temp objectForKey:@"ubl"] intValue] / 10.0];
    NSString *ageMin = [NSString stringWithFormat:@"%.1f",[(NSNumber *)[temp objectForKey:@"lbl"] intValue] / 10.0];
    
    [age setText:[NSString stringWithFormat:@"%@岁-%@岁",[ageMin deleteEndZero],[ageMax deleteEndZero]]];
    
    NSString *address = [service objectForKey:@"address"];
   
    @try {
        
        NSRange range = [address rangeOfString:@"路"];
        
        address = [address substringToIndex:range.location + 1];
    } @catch(NSException * ex) {
        // do nothing ...
    }
    
    [location setText:address];
    
    NSString *service_leaf = [serviceData objectForKey:@"service_leaf"];
    
    NSArray *service_tags = [serviceData objectForKey:@"service_tags"];
    
    NSString *service_tag = [service_tags firstObject];
    
    [course setText:[NSString stringWithFormat: @"%@%@",service_tag,service_leaf]];
    
}


-(void)setOpenDay {
    
    [_delegate setOpenDay];
    
}

@end
