//
//  AYServiceAddCellView.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYServiceAddCellView.h"

@implementation AYServiceAddCellView{
    
    UIImageView *icon;
    
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
        
        UIView *content = [[UIView alloc] init];
        [self.contentView addSubview:content];
        
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(19);
            make.right.mas_equalTo(-19);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(18);
            
        }];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"%@", content);
            
            CAShapeLayer *border = [CAShapeLayer layer];
            [border setPath:[UIBezierPath bezierPathWithRect:content.bounds].CGPath];
            [border setFrame:content.bounds];
            [border setLineWidth:1.0f];
            [border setLineCap:@"square"];
            [border setLineDashPattern:@[@8, @5]];
            [border setStrokeColor:[UIColor lightGary].CGColor];
            [border setFillColor:[UIColor clearColor].CGColor];
            
            [content.layer addSublayer:border];
            
        });
        
        
        icon = [[UIImageView alloc] init];
        [content addSubview:icon];
        
        title = [UILabel creatLabelWithText:@"+ 新增服务" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [content addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(content);
            
        }];
        
        [title setFont:[UIFont mediumFont:15.0f]];
        
    }
    
    return self;
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
