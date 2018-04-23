//
//  PublishStartView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/11.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "PublishStartView.h"
#import "AYFacadeBase.h"

@implementation PublishStartView {
    
    UILabel *location;
    UIImageView *icon;
    UILabel *title;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor white]];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(11);
            make.height.mas_equalTo(13);
            make.left.mas_equalTo(16);
            make.top.mas_equalTo(20);
            
        }];
        
        [imageView setImage:IMGRESOURCE(@"home_icon_location")];
        
        location = [UILabel creatLabelWithText:@"朝阳区酒仙桥路" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:location];
        
        [location mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(imageView);
            make.left.equalTo(imageView.mas_right).offset(4);
            
        }];
        
        [location setFont:[UIFont regularFont:15.0f]];
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(53);
            
        }];
        
        [line setBackgroundColor:[UIColor line]];
        
        icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(line).offset(16);
            make.left.mas_equalTo(16);
            make.bottom.mas_equalTo(-16);
            make.width.mas_equalTo(116);
            
        }];
        
        title = [UILabel creatLabelWithText:@"品牌名称加服务leaf品牌名称加服务leaf" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self -> icon);
            make.left.equalTo(self -> icon.mas_right).offset(16);
            make.right.mas_equalTo(-16);
            
        }];
        
        [title setFont:[UIFont mediumFont:15]];
        [title setNumberOfLines:0];
        
    }
    return self;
}

- (void)setUp:(id)args {
    
    NSDictionary *dic = [args objectForKey:@"service_data"];
    
    NSString *address = [args objectForKey:@"address"];
    
    NSRange range = [address rangeOfString:@"路"];
    
    address = [address substringToIndex:range.location + 1];
    
    [location setText:address];
    
    NSString *service_img = [dic objectForKey:kAYServiceArgsImage];
    
    NSString *service_leaf = [dic objectForKey:@"service_leaf"];
    
    NSArray *service_tags = [dic objectForKey:@"service_tags"];
    
    NSString *service_tag = [service_tags firstObject];
    
    [title setText:[NSString stringWithFormat:@"%@%@",service_tag,service_leaf]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:service_img forKey:@"key"];
    [dict setValue:icon forKey:@"imageView"];
    [dict setValue:@228 forKey:@"wh"];
    
    id tmp = [dict copy];
    id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
    id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
    
    [cmd_oss_get performWithResult:&tmp];
    
}


@end
