//
//  AYLocationDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 31/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYLocationDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"

#import "Tools.h"
#import "AYSearchDefines.h"
#import "AYFoundSearchResultCellDefines.h"

#import <AMapSearchKit/AMapSearchKit.h>

@interface AutoLocationCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationlabel;
@property (nonatomic, strong) UIImageView *locationIcon;
@end

@implementation AutoLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.f];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.text = @"当前位置";
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(18);
            make.left.equalTo(self).offset(20);
        }];
        
        self.locationlabel = [[UILabel alloc]init];
        self.locationlabel.font = [UIFont systemFontOfSize:12.f];
        self.locationlabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
        self.locationlabel.textAlignment = NSTextAlignmentLeft;
        self.locationlabel.text = @"正在获取当前位置...";
        [self addSubview:self.locationlabel];
        [self.locationlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.left.equalTo(self).offset(20);
        }];
        
        self.locationIcon = [[UIImageView alloc]init];
        [self.locationIcon setImage:[UIImage imageNamed:@"tab_found_selected"]];
        [self addSubview:self.locationIcon];
        [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return self;
}

@end

@implementation AYLocationDelegate {
    NSArray* previewDic;
    NSString *locationName;
}
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (previewDic.count == 0) {
        return 1;
    } else {
        return previewDic.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (previewDic == nil || previewDic.count == 0) {
        AutoLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        if (cell == nil) {
            cell = [[AutoLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
//        NSString *location = [NSString stringWithFormat:@"%@",@"北京市"];
//        location = [NSString stringWithFormat:@"%@，%@",location,@"朝阳区"];
        if (locationName && ![locationName isEqualToString:@""]) {
            cell.locationlabel.text = locationName;
        }
        return cell;
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"LocationCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYViewBase> cell =[tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = VIEW(@"LocationCell", @"LocationCell");
        }
        
        cell.controller = self.controller;
        
        AMapTip *tip = previewDic[indexPath.row];
        
//        cell.textLabel.text = tip.name;
//        cell.detailTextLabel.text = tip.district;
        
        id<AYCommand> cmd = [cell.commands objectForKey:@"resetContent:"];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:tip.name forKey:@"location_name"];
        [cmd performWithResult:&dic];
        
        return (UITableViewCell*)cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (previewDic == nil || previewDic.count == 0) {
        return 80;
    }
    else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (previewDic != nil && previewDic.count != 0) {
//        NSDictionary* dic = [previewDic objectAtIndex:indexPath.row];
//        NSString* role_tag = [dic objectForKey:@"role_tag"];
//        
//        AYViewController* des = DEFAULTCONTROLLER(@"UserPerview");
//        
//        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
//        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
//        [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//        
//        [dic_push setValue:role_tag forKey:kAYControllerChangeArgsKey];
//        
//        id<AYCommand> cmd = PUSH;
//        [cmd performWithResult:&dic_push];
    }
}

#pragma mark -- scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollToHideKeyBoard"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
-(id)autoLocationData:(id)args{
    NSString *name = (NSString*)args;
    locationName = name;
    return nil;
}
- (id)changeLocationResultData:(id)obj {
    previewDic = (NSArray*)obj;
    return nil;
}
@end
