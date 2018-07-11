//
//  AYLocationChooseCellView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/9.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYLocationChooseCellView.h"
#import "AYShadowRadiusView.h"

@implementation AYLocationChooseCellView {
    
    UIImageView *icon;
    UILabel *location;
    UILabel *detail;
    
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
        
        
        icon = [[UIImageView alloc] init];
        [content addSubview:icon];
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(11);
            make.top.mas_equalTo(21);
            make.left.mas_equalTo(16);
        }];
        
        [icon setImage:IMGRESOURCE(@"map_icon_location_sign")];
        
        
        location = [UILabel creatLabelWithText:@"朝阳区酒仙路52号院东方科技园" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [content addSubview:location];
        
        [location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self -> icon.mas_right).offset(4);
            make.top.mas_equalTo(17);
        }];
        
        [location setFont:[UIFont regularFont:15]];
        
        detail = [UILabel creatLabelWithText:@"B座1号楼3层" textColor:[UIColor lightGary] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        
        [content addSubview:detail];
        
        [detail setFont:[UIFont regularFont:15.0f]];
        
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self -> location);
            make.top.equalTo(self -> location.mas_bottom).offset(2);
        }];

        
    }
    
    return self;
}

- (void)setCellInfo:(id)args {
    
    NSString *address = [[args objectForKey:@"location"] objectForKey:@"address"];
   
    @try {
        
        NSRange range = [address rangeOfString:@"路"];
        
        [location setText:[address substringToIndex:range.location + 1]];
        [detail setText:[address substringFromIndex:range.location + 1]];

    } @catch(NSException* ex) {
        [location setText:address];
        [detail setText:@""];
    }
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
