//
//  AYAboutDDController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAboutDDController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"

@interface AYAboutDDController ()
@property (nonatomic, strong) UIImageView *logoView;
@end

@implementation AYAboutDDController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
        id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
        NSString* title = @"关于咚哒";
        [cmd_title performWithResult:&title];
        
    }
    
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_about = [self.delegates objectForKey:@"AboutDongda"];
        
        id obj = (id)cmd_about;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_about;
        [cmd_delegate performWithResult:&obj];
        
    }
    
    _logoView = [[UIImageView alloc]init];
    _logoView.image = PNGRESOURCE(@"profile_about_dongda");
    [_logoView sizeToFit];
    _logoView.frame = CGRectMake((SCREEN_WIDTH - _logoView.bounds.size.width)*0.5, 50, _logoView.bounds.size.width, _logoView.bounds.size.height);
//    NSLog(@"--%f,--%f",_logoView.bounds.size.width, _logoView.bounds.size.height);
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    [(UIView*)view_table addSubview:_logoView];
}

#pragma mark -- layout
- (id)TableLayout:(UIView*)view {
    view.frame = self.view.bounds;
    ((UITableView*)view).scrollEnabled = NO;
    [((UITableView*)view) setSeparatorColor:[UIColor clearColor]];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    self.navigationItem.titleView = view;
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}

#pragma mark -- notification
- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}


@end
