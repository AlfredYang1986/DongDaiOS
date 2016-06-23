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

#import "AYServiceInfoCellView.h"
#import "AYFouceCellView.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define WIDTH               SCREEN_WIDTH - 15*2

@implementation AYServicePageDelegate{
    NSArray *imageNameArr;
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
//        AYFouceCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"AYFouceCellView" forIndexPath:indexPath];
        AYFouceCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"AYFouceCellView"];
        if (cell == nil) {
            cell = [[AYFouceCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYFouceCellView"];
        }
        cell.imageNameArr = imageNameArr;
        
        [cell.friendsImage  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didXFriendImage:)]];
        [cell.popImage      addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPopImage:)]];
        
        return (UITableViewCell*)cell;
    } else {
        AYServiceInfoCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"AYServiceInfoCellView"];
        if (cell == nil) {
            cell = [[AYServiceInfoCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AYServiceInfoCellView"];
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
        return 1000;
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
