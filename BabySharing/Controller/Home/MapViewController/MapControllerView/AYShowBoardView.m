//
//  AYShowBoardView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShowBoardView.h"
#import "AYCommandDefines.h"
#import "AYShowBoardCellView.h"
#import "Tools.h"
#import "AYControllerActionDefines.h"
#import "AYFactoryManager.h"
#import <MapKit/MapKit.h>

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height
#define CellWidth   300

@implementation AYShowBoardView{
    NSArray *fiteResultArrWithLoc;
    int indexNumb;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.delegate = self;
    indexNumb = 0;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    id<AYCommand> query_cmd = [self.notifies objectForKey:@"queryResultDate:"];
    NSDictionary *resultAndLoc = nil;
    [query_cmd performWithResult:&resultAndLoc];
    
    //    CLLocation *loc0 = [[CLLocation alloc]initWithLatitude:39.901508 longitude:116.406997];
    //    CLLocation *loc1 = [[CLLocation alloc]initWithLatitude:39.961508 longitude:116.456997];
    //    arrayWithLoc = @[loc0, loc1];
    
    CLLocation *loc = [resultAndLoc objectForKey:@"location"];
    NSArray *fiteResultData = [resultAndLoc objectForKey:@"result_data"];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentSize = CGSizeMake(310 * fiteResultData.count + 10, 0);
    for (int i = 0; i < fiteResultData.count; ++i) {
        CGFloat offset_x = 10 * (i+1) + CellWidth * i;
        AYShowBoardCellView *cell = [[AYShowBoardCellView alloc]initWithFrame:CGRectMake(offset_x, 10, 300, 110)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.location = loc;
        cell.contentInfo = fiteResultData[i];
        
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCellClick:)]];
        [self addSubview:cell];
    }
}

#pragma mark -- commands
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

-(id)changeOffsetX:(NSNumber*)index {
//    self.contentOffset = CGPointMake(CellWidth * index.floatValue, 0);
    [self setContentOffset:CGPointMake(CellWidth * index.floatValue, 0) animated:YES];
    return nil;
}

#pragma mark -- actions
- (void)didCellClick:(UIGestureRecognizer*)tap{
    NSLog(@" cell did clik");
    UIView *view = tap.view;
    AYShowBoardCellView *cell = (AYShowBoardCellView*)view;
    id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[cell.contentInfo copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
}

#pragma mark -- scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",(self.contentOffset.x + SCREEN_WIDTH/2) / CellWidth);
    if ((int)((self.contentOffset.x + SCREEN_WIDTH/2) / CellWidth) != indexNumb) {
        indexNumb = (int)((self.contentOffset.x + SCREEN_WIDTH/2) / CellWidth);
        id<AYCommand> cmd = [self.notifies objectForKey:@"sendChangeAnnoMessage:"];
        NSNumber *index = [NSNumber numberWithFloat:indexNumb];
        [cmd performWithResult:&index];
    }
    
}

@end
