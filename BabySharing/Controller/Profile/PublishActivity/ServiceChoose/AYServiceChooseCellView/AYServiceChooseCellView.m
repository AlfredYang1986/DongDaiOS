//
//  AYServiceChooseCellView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYServiceChooseCellView.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYShadowRadiusView.h"

@implementation AYServiceChooseCellView{
    
    UIImageView *iconImageView;
    
    UILabel *title;
    
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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
        
        [self.contentView setBackgroundColor:[UIColor garyBackground]];
        
        AYShadowRadiusView *shadowView = [[AYShadowRadiusView alloc] initWithRadius:4];
        [self.contentView addSubview:shadowView];
        
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-4);
            make.top.mas_equalTo(4);
        }];
        
        UIView *content = [[UIView alloc] init];
        [shadowView addSubview:content];
        
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.bottom.equalTo(shadowView);
            
        }];
        
        [content.layer setCornerRadius:4];
        [content.layer setMasksToBounds:YES];
        [content setBackgroundColor:[UIColor white]];
        
        iconImageView = [[UIImageView alloc] init];
        [content addSubview:iconImageView];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.mas_equalTo(16);
            make.bottom.mas_equalTo(-16);
            make.width.mas_equalTo(116);
            
        }];
        
        [iconImageView setImage:IMGRESOURCE(@"")];
        
        title = [UILabel creatLabelWithText:@"品牌名称加服务leaf品牌名称加服务leaf" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [content addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self->iconImageView.mas_right).offset(16);
            make.right.mas_equalTo(-16);
            make.centerY.equalTo(content);
            
        }];
        
        [title setNumberOfLines:0];
        [title setFont:[UIFont mediumFont:15.0f]];
        
        
    }
    
    return self;
}

- (void)setCellInfo:(id)args {
    
    NSDictionary *dic = [args objectForKey:@"service"];
    
    NSString *service_img = [dic objectForKey:kAYServiceArgsImage];
    
    NSString *service_leaf = [dic objectForKey:@"service_leaf"];
    
    NSArray *service_tags = [dic objectForKey:@"service_tags"];
    
    NSString *service_tag = [service_tags firstObject];
    
    [title setText:[NSString stringWithFormat:@"%@%@",service_tag,service_leaf]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:service_img forKey:@"key"];
    [dict setValue:iconImageView forKey:@"imageView"];
    [dict setValue:@228 forKey:@"wh"];
    
    id tmp = [dict copy];
    id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
    id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
    
    [cmd_oss_get performWithResult:&tmp];
    
    
    
    
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
