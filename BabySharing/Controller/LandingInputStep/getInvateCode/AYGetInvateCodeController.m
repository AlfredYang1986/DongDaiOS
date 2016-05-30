//
//  AYUserAgreeController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYGetInvateCodeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"
#import "SGActionView.h"
#import "RemoteInstance.h"
#import "Tools.h"
#import "AYModel.h"
#import "AYRemoteCallCommand.h"


#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height

@interface AYGetInvateCodeController ()

@end

@implementation AYGetInvateCodeController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
        id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
        NSString* title = @"如何获取验证码";
        [cmd_title performWithResult:&title];
    }
    
    {
        id<AYViewBase> web_view = [self.views objectForKey:@"Web"];
        
        id<AYCommand> cmd_delegate = [web_view.commands objectForKey:@"registerDelegate:"];
        id<AYDelegateBase> cmd_user_agreement = [self.delegates objectForKey:@"UserAgree"];
        id obj = (id)cmd_user_agreement;
        [cmd_delegate performWithResult:&obj];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- layout
- (id)WebLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100 + 49);
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"privacy" ofType:@"html"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSURL* url = [NSURL fileURLWithPath:path];
    //    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    //    [webView loadRequest:request];
    [(UIWebView*)view loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:url];
    
    [((UIWebView*)view) setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:((UIWebView*)view)];
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

- (id)SetNevigationBarRightBtnLayout:(UIView*)view {
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
