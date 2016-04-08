//
//  AYSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#define SEARCH_BAR_HEIGHT   53


@implementation AYSearchController

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
//    CALayer* line = [CALayer layer];
//    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
//    line.borderWidth = 1.f;
//    line.frame = CGRectMake(0, 117, width, 1);
//    [self.view.layer addSublayer:line];
//    
//    CALayer* line_2 = [CALayer layer];
//    line_2.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.1].CGColor;
//    line_2.borderWidth = 1.f;
//    line_2.frame = CGRectMake(0, 127, width, 1);
//    [self.view.layer addSublayer:line_2];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view becomeFirstResponder];
}

#pragma mark -- layout
- (id)SearchBarLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat offset = 0; //self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
    view.frame = CGRectMake(0, offset, width, SEARCH_BAR_HEIGHT);
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    self.navigationItem.titleView = view;
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat offset = 0; //self.navigationController.navigationBar.frame.size.height + rectStatus.size.height;
    view.frame = CGRectMake(0, offset + SEARCH_BAR_HEIGHT, width, height - offset - SEARCH_BAR_HEIGHT);
    
    view.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f]; //[UIColor colorWithRed:0.2039 green:0.2078 blue:0.2314 alpha:1.f];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return nil;
}

#pragma mark -- notificaitons
- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
   
    UIView* sb = [self.views objectForKey:@"SearchBar"];
    [sb resignFirstResponder];
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}
@end
