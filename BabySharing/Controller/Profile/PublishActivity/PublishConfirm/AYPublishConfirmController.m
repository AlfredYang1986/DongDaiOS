//
//  AYPublishConfirmController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYPublishConfirmController.h"
#import "AYPublishConfirmView.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
@interface AYPublishConfirmController () {
    
    NSDictionary *data;
    AYPublishConfirmView *publishConfirmView;
    NSArray *openDays;
}

@end

@implementation AYPublishConfirmController

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        if ([dic objectForKey:kAYControllerChangeArgsKey]) {
            
            data = [[NSDictionary alloc] init];
            data = [dic objectForKey:kAYControllerChangeArgsKey];
            
        }
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        if( [dic objectForKey:kAYControllerChangeArgsKey]) {
            
            if ([[dic objectForKey:kAYControllerChangeArgsKey] isKindOfClass:[NSString class]]) {
                
                NSString *s = [dic objectForKey:kAYControllerChangeArgsKey];
                
                if ([s  isEqual: @"PublishSuccess"]) {
                    
                    
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                    [dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
                    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
                    
                    AYViewController *des = DEFAULTCONTROLLER(@"Profile");
                    
                    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
                    id<AYCommand> cmd = POPTODEST;
                    [cmd performWithResult:&dic];
                    
                    
                }
                
            }else {
                
                openDays = [dic objectForKey:kAYControllerChangeArgsKey];
                
            }
            
            
        }
        
        
       
    
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor garyBackground]];
    
    publishConfirmView = [[AYPublishConfirmView alloc] init];
    [self.view addSubview:publishConfirmView];
    
    [publishConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(16 + kNavBarH + kStatusBarH);
        make.height.mas_equalTo(336);
        
    }];
    [publishConfirmView setDelegate:self];
    [publishConfirmView setUp:data];
    
    UIButton *publish = [UIButton creatBtnWithTitle:@"发布招生" titleColor:[UIColor white] fontSize:17.0f backgroundColor:[UIColor theme]];
    [self.view addSubview:publish];
    
    [publish mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(56);
        make.top.equalTo(self -> publishConfirmView.mas_bottom).offset(16);
    }];
    
    [publish.layer setCornerRadius:4];
    [publish.layer setMasksToBounds:YES];
    [publish.titleLabel setFont:[UIFont mediumFont:17]];
    [publish addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *tip = [[UILabel alloc] init];
    [self.view addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(-16);
        make.centerX.equalTo(self.view);
        
    }];
    
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:@"什么是开放体验日?" attributes:@{NSForegroundColorAttributeName : [UIColor gary166],NSFontAttributeName : [UIFont regularFont:13],NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineColorAttributeName : [UIColor gary166]}];
    
    [tip setAttributedText:s];
    
    
    
    
}


#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor garyBackground];
    return nil;
    
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor garyBackground];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton *right = [UIButton creatBtnWithTitle:@"预览" titleColor:[UIColor black] fontSize:17.0f backgroundColor:nil];
    [right.titleLabel setFont:[UIFont mediumFont:17.0f]];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &right);
    
    NSNumber* right_enable = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
    
    return nil;
    
}

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    
    return nil;
    
}

- (id)rightBtnSelected {
    
    
    
    
    return nil;
}

- (void)publish {
    
    
//    AYViewController *des = DEFAULTCONTROLLER(@"PublishSuccess");
//    
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
//    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//
//    id<AYCommand> cmd = SHOWMODULEUP;
//    [cmd performWithResult:&dic];
    
    
    NSDictionary *user;
    CURRENUSER(user);
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];

    NSMutableDictionary * recruit = [[NSMutableDictionary alloc] init];
    [recruit setValue:[[[data objectForKey:@"service"] objectForKey:@"service_data"]objectForKey:@"service_id"] forKey:@"service_id"];

    if ([data objectForKey:@"temp"]) {

        NSDictionary *temp = [data objectForKey:@"temp"];

        for (NSString *key in temp) {

            [recruit setValue:temp[key] forKey:key];

        }

    }
    [dic setValue:recruit forKey:@"recruit"];

    AYFacade* f = [self.facades objectForKey:@"PublishRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"PublishInfomation"];

    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {

        if(success) {

            AYViewController *des = DEFAULTCONTROLLER(@"PublishSuccess");

            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
            [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
            [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];

            id<AYCommand> cmd = SHOWMODULEUP;
            [cmd performWithResult:&dic];



        }else {


            NSLog(@"%@",result);


        }

    }];
    
    
        
    }
     
     - (void)setOpenDay {
         
         AYViewController* des = DEFAULTCONTROLLER(@"OpenDayChoose");
         
         NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
         [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
         [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
         [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
         [dic_push setValue:openDays forKey:kAYControllerChangeArgsKey];
         
         id<AYCommand> cmd = PUSH;
         [cmd performWithResult:&dic_push];
         
     }
     
     
     - (void)didReceiveMemoryWarning {
         [super didReceiveMemoryWarning];
         
     }
     
     
     
     
     
     
@end
     
