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
#import "AYControllerActionDefines.h"
#import "AYFactoryManager.h"
#import <MapKit/MapKit.h>

#define CellWidth   258

@implementation AYShowBoardView{
    NSDictionary *resultAndLoc;
    int indexNumb;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
    self.delegate = self;
//    self.pagingEnabled = YES;
    indexNumb = 0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
    if (index.floatValue == 0) {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
    } else
        [self setContentOffset:CGPointMake(CellWidth * index.floatValue - (self.frame.size.width - CellWidth)*0.5, 0) animated:NO];
    
    return nil;
}

-(id)changeResultData:(NSDictionary*)args {
    resultAndLoc = args;
    
    CLLocation *loc = [resultAndLoc objectForKey:@"location"];
    NSArray *fiteResultData = [resultAndLoc objectForKey:@"result_data"];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.contentSize = CGSizeMake(268 * fiteResultData.count + 10, 0);
    for (int i = 0; i < fiteResultData.count; ++i) {
        CGFloat offset_x = 10 * (i+1) + CellWidth * i;
        AYShowBoardCellView *cell = [[AYShowBoardCellView alloc]initWithFrame:CGRectMake(offset_x, 0, CellWidth, 107)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.location = loc;
        cell.contentInfo = fiteResultData[i];
        
        [cell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCellClick:)]];
        [self addSubview:cell];
    }
    
    return nil;
}

#pragma mark -- actions
- (void)didCellClick:(UIGestureRecognizer*)tap {
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGFloat pre_offset_x = 0;
    CGFloat cur_offset_x = self.contentOffset.x;
    CGFloat slide = pre_offset_x - cur_offset_x;
    pre_offset_x = cur_offset_x;
    
    if (slide < 0) {
        if ((int)((self.contentOffset.x + (self.frame.size.width - CellWidth)*0.5) / CellWidth) > indexNumb) {
            indexNumb = (int)((self.contentOffset.x + (self.frame.size.width - CellWidth)*0.5) / CellWidth);
        }
        
    } else if (slide > 0){
        if ((int)((self.contentOffset.x + (self.frame.size.width - CellWidth)*0.5) / CellWidth) < indexNumb - 1) {
            indexNumb = (int)((self.contentOffset.x + (self.frame.size.width - CellWidth)*0.5) / CellWidth) + 1;
        }
        
    } else {
        
    }
    
    id<AYCommand> cmd = [self.notifies objectForKey:@"sendChangeAnnoMessage:"];
    NSNumber *index = [NSNumber numberWithInt:indexNumb];
    [cmd performWithResult:&index];
    NSLog(@"%d",indexNumb);
    
    if (self.contentOffset.x == 0) {
        indexNumb = 0;
        
        NSNumber *index = [NSNumber numberWithFloat:indexNumb];
        [cmd performWithResult:&index];
        NSLog(@"%d",indexNumb);
    }
    
}

//一个拖拽后续动作全部结束时 调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
@end
