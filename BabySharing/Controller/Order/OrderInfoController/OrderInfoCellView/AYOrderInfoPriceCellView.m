//
//  AYOrderInfoPriceCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderInfoPriceCellView.h"
#import "TmpFileStorageModel.h"
#import "QueryContentItem.h"
#import "GPUImage.h"
#import "Define.h"
#import "PhotoTagEnumDefines.h"
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
#import "AYRemoteCallCommand.h"

#import "AYThumbsAndPushDefines.h"

#import "InsetsLabel.h"
#import "OBShapedButton.h"

@implementation AYOrderInfoPriceCellView {
    
    UILabel *priceLabel;
    
    UILabel *themeTitleLabel;
    UILabel *themePriceLabel;
    
    UILabel *isLeaveTitleLabel;
    UILabel *isLeavePriceLabel;
    
    UIButton *isShowDetail;
    
    NSDictionary *servicePrice;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel = [Tools setLabelWith:titleLabel andText:@"价格" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(25);
            make.left.equalTo(self).offset(15);
        }];
        
        priceLabel = [[UILabel alloc]init];
        priceLabel = [Tools setLabelWith:priceLabel andText:@"￥ 000" andTextColor:[Tools blackColor] andFontSize:116.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
        [self addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(self).offset(-15);
        }];
        
        themeTitleLabel = [[UILabel alloc]init];
        themeTitleLabel = [Tools setLabelWith:themeTitleLabel andText:@"主题服务" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:themeTitleLabel];
        [themeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(45);
            make.left.equalTo(titleLabel);
        }];
        
        themePriceLabel = [[UILabel alloc]init];
        themePriceLabel = [Tools setLabelWith:themePriceLabel andText:@"￥ 00 * 0 Hour" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:themePriceLabel];
        [themePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(themeTitleLabel);
            make.right.equalTo(priceLabel);
        }];
        
        UIView *sperator = [[UIView alloc]init];
        sperator.backgroundColor = [Tools garyLineColor];
        [self addSubview:sperator];
        [sperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(themeTitleLabel.mas_bottom).offset(20);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.mas_equalTo(0.5f);
        }];
        
        isLeaveTitleLabel = [[UILabel alloc]init];
        isLeaveTitleLabel = [Tools setLabelWith:isLeaveTitleLabel andText:@"看顾" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
        [self addSubview:isLeaveTitleLabel];
        [isLeaveTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sperator.mas_bottom).offset(20);
            make.left.equalTo(titleLabel);
        }];
        
        isLeavePriceLabel = [[UILabel alloc]init];
        isLeavePriceLabel = [Tools setLabelWith:isLeavePriceLabel andText:@"￥ 00" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
        [self addSubview:isLeavePriceLabel];
        [isLeavePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(isLeaveTitleLabel);
            make.right.equalTo(priceLabel);
        }];
        
        isShowDetail = [[UIButton alloc]init];
        [isShowDetail setTitle:@"查看详情" forState:UIControlStateNormal];
        [isShowDetail setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        isShowDetail.titleLabel.font = kAYFontLight(12.f);
        isShowDetail.titleLabel.textAlignment = NSTextAlignmentRight;
        [isShowDetail sizeToFit];
        [self addSubview:isShowDetail];
        [isShowDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-15);
            make.right.equalTo(priceLabel);
            make.size.mas_equalTo(CGSizeMake(isShowDetail.bounds.size.width, isShowDetail.bounds.size.height));
        }];
        [isShowDetail addTarget:self action:@selector(didShowDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        CALayer *line_separator = [CALayer layer];
        line_separator.backgroundColor = [Tools garyLineColor].CGColor;
        line_separator.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
        [self.layer addSublayer:line_separator];
        
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"OrderInfoPriceCell", @"OrderInfoPriceCell");
    
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

#pragma mark -- actions
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap{
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
    
}

- (void)didShowDetailClick:(UIButton*)btn {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didShowDetailClick"];
    [cmd performWithResult:nil];
    
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"查看详情"]) {
//        [btn setImage:IMGRESOURCE(@"content_close") forState:UIControlStateNormal];
        [btn setTitle:@"收起" forState:UIControlStateNormal];
        NSString *tmp = btn.titleLabel.text;
        NSLog(@"%@",tmp);
        
    } else if([title isEqualToString:@"收起"]){
//        [btn setImage:nil forState:UIControlStateNormal];
        [btn setTitle:@"查看详情" forState:UIControlStateNormal];
        
    }
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args {
    
    NSDictionary *dic_args = [args objectForKey:@"service_info"];
    NSDictionary *setedTimes = [args objectForKey:@"order_times"];
    
    CGFloat sumPrice = 0;
    
    BOOL isLeave = ((NSNumber*)[dic_args objectForKey:@"allow_leave"]).boolValue;
    if (isLeave) {
        isLeavePriceLabel.text = @"￥40";
        sumPrice += 40;
    }
    
    NSNumber *unit_price = [dic_args objectForKey:@"price"];            //单价
    
    if (setedTimes) {
        
        NSString *start = [setedTimes objectForKey:@"start"];
        NSString *end = [setedTimes objectForKey:@"end"];
        int startClock = [start substringToIndex:2].intValue;
        int endClock = [end substringToIndex:2].intValue;
        
        themePriceLabel.text = [NSString stringWithFormat:@"￥%.f*%d小时",unit_price.floatValue,(endClock - startClock)];
        
        sumPrice = sumPrice + unit_price.floatValue * (endClock - startClock);
        priceLabel.text = [NSString stringWithFormat:@"￥%.f",sumPrice];
        
    } else {
        
        NSNumber *least_hours = [dic_args objectForKey:@"least_hours"];
        themePriceLabel.text = [NSString stringWithFormat:@"￥%.f*%d+小时",unit_price.floatValue,least_hours.intValue];
        
        sumPrice = sumPrice + unit_price.floatValue * least_hours.intValue;
        priceLabel.text = [NSString stringWithFormat:@"￥%.f+",sumPrice];
    }
    
    return nil;
}

@end
