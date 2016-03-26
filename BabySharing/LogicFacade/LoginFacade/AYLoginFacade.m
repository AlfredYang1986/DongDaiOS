//
//  AYLoginFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginFacade.h"
#import "AYLoginFacadeDefines.h"
#import "GotyeOCAPI.h"
#import "GotyeOCDeleget.h"

@interface AYLogicFacade () <GotyeOCDelegate>

@end

@implementation AYLoginFacade

- (void)postPerform {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SNSLogedIn:) name:kDongDaNotificationkeySNSLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedIn:) name:kDongDaNotificationkeyLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appIsReady:) name:kDongDaNotificationkeyAppReady object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDataIsReady:) name:kDongDaNotificationkeyQueryDataReady object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageAndNotificationDataIsReady:) name:kDongDaNotificationkeyMessageIsReady object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedOut:) name:kDongDaNotificationkeyUserSignOut object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedOutSuccessLocal:) name:kDongDaNotificationkeyUserSignOutSuccess object:nil];

//    [GotyeOCAPI addListener:self];
}

- (void)SNSLogedIn:(id)sender {
    NSLog(@"SNS login success");
//    if ([_lm isTmpLoginProcess]) {
//        isSNSLogin = YES;
//        [self performSegueWithIdentifier:@"loginSuccessSegue" sender:[_lm getRegTmpUserAttr]];
//        
//    } else {
//        // ERROR
//        NSLog(@"something error with SNS login");
//    }
}

- (void)userLogedIn:(id)sender {
    NSLog(@"login success");
    
//    if ([_lm isTmpLoginProcess]) {
//        [_lm resignTmpLoginUserProcess];
//    }
//    
//    isSNSLogin = NO;
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    
//    [self showLoadingView];
//    
//    if ([_lm isLoginedByUser]) {
//        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        if (!isQueryModelReady) [delegate createQueryModel];
//        else [self queryDataIsReady:nil];
//        [delegate registerDeviceTokenWithCurrentUser];
//    }
}

- (void)userLogedOut:(id)sender {
    NSLog(@"user login out");
//    [_lm signOutCurrentUser];
//    [GotyeOCAPI logout];
//    if (_contentController) {
//        [_contentController dismissViewControllerAnimated:YES completion:nil];
//        _contentController = nil;
//    }
}

- (void)userLogedOutSuccessLocal:(id)sender {
    NSLog(@"user login out local");
    
//    [self hideLoadingView];
}

- (void)appIsReady:(id)sender {
    NSLog(@"application is ready");
    
//    if ([_lm isLoginedByUser]) {
//        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        if (!isQueryModelReady) [delegate createQueryModel];
//        else [self queryDataIsReady:nil];
//        
//        [delegate registerDeviceTokenWithCurrentUser];
//        [_lm onlineCurrentUser];
//        //        [GotyeOCAPI login:_lm.current_user_id password:nil];
//    } else {
//        snsView.hidden = NO;
//        inputView.hidden = NO;
//        loadingView.hidden = YES;
//        [loadingView stopGif];
//    }
}

- (void)queryDataIsReady:(id)sender {
//    NSLog(@"queryDataIsReady");
//    NSLog(@"the login user is : %@", _lm.current_user_id);
//    NSLog(@"the login user token is : %@", _lm.current_auth_token);
//    
//    isQueryModelReady = YES;
//    
//    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    if (!isMessageModelReady) [delegate createMessageAndNotificationModel];
//    else [self messageAndNotificationDataIsReady:nil];
}

- (void)messageAndNotificationDataIsReady:(id)sender {
    NSLog(@"message is ready");
    
//    isMessageModelReady = YES;
//    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    _mm = app.mm;
//    
//    //    if (inputView.frame.origin.y + inputView.frame.size.height != [UIScreen mainScreen].bounds.size.height) {
//    //        CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    //
//    //        CGFloat last_height = inputView.bounds.size.height;
//    //        inputView.frame = CGRectMake(0, INPUT_VIEW_START_POINT, inputView.bounds.size.width, last_height);
//    //    }
//    
//    if (![GotyeOCAPI isOnline]) {
//        [GotyeOCAPI login:_lm.current_user_id password:nil];
//    } else if ([GotyeOCAPI getLoginUser].name != _lm.current_user_id) {
//        [GotyeOCAPI login:_lm.current_user_id password:nil];
//    }
}
@end
