//
//  AYAboutDongdaCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAboutDongdaCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "FoundHotTagBtn.h"
#import "Tools.h"

#define MARGIN                  13
#define MARGIN_VER              12

// 内部
#define ICON_WIDTH              12
#define ICON_HEIGHT             12

#define TAG_HEIGHT              25
#define TAG_MARGIN              10
#define TAG_CORDIUS             5
#define TAG_MARGIN_BETWEEN      10.5

#define PREFERRED_HEIGHT        62

@implementation AYAboutDongdaCellView

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
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            self.label = [[UILabel alloc]init];
            self.label.textColor = [UIColor colorWithWhite:0.3059 alpha:1.f];
            self.label.font = [UIFont systemFontOfSize:14.f];
            [self addSubview:self.label];
            
            self.image = [[UIImageView alloc]init];
            [self addSubview:self.image];
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AYAboutDongdaCellView * cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
    
    if (cell == nil) {
        cell = [[AYAboutDongdaCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    }
    [cell.label sizeToFit];
    cell.label.frame = CGRectMake(10, (44 - CGRectGetHeight(cell.label.frame)) / 2, cell.label.frame.size.width, cell.label.frame.size.height);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        
        
    }
    else if(indexPath.row == 1){
        cell.label.text = @"用户协议";
        CALayer* line = [CALayer layer];
        line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.20].CGColor;
        line.borderWidth = 1.f;
        line.frame = CGRectMake(8, 44 - 1, tableView.frame.size.width, 1);
        [cell.layer addSublayer:line];
    }
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1){
        
        NSLog(@"aboutdongda view controller");
        
//        id<AYCommand> aboutDD = DEFAULTCONTROLLER(@"AboutDD");
//        
//        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
//        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//        [dic setValue:aboutDD forKey:kAYControllerActionDestinationControllerKey];
//        [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//        [_controller performWithResult:&dic];
        
    }
}


+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

+ (CGFloat)preferredHeightWithTags:(NSArray*)arr {
    return PREFERRED_HEIGHT;
}



@end
