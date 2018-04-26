//
//  AYSwitchRoleController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/18.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYSwitchRoleController.h"
#import "AYNavigationController.h"

@interface AYSwitchRoleController ()

@end

@implementation AYSwitchRoleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *appMode = [defaults objectForKey:kAYDongDaAppMode];
    
    if (appMode.intValue == DongDaAppModeServant) {
        
        [self switchToCommon];
        
    }else if(appMode.intValue == DongDaAppModeCommon) {
        
        [self switchToService];
        
    }
    
   
    

}

-(void)switchToService {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 1; i < 13; i++) {
        
        NSString *filename = [NSString stringWithFormat:@"demo%d.png",i];
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [images addObject:image];
        
    }
    [imageView setImage:IMGRESOURCE(@"demo12.png")];
    
    imageView.animationImages = images;
    imageView.animationDuration = 1.0;
    imageView.animationRepeatCount = 1;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView startAnimating];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(-50);
        make.left.mas_equalTo(89);
        make.right.mas_equalTo(-89);
        make.height.mas_equalTo(95);
        
        
    }];
    UILabel *tip = [UILabel creatLabelWithText:@"正在切换为服务模式" textColor:[UIColor theme] font:[UIFont mediumFont:16] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom);
        
    }];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:[NSNumber numberWithInt:DongDaAppModeServant] forKey:kAYDongDaAppMode];
    
    [defaults synchronize];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        AYViewController *des = DEFAULTCONTROLLER(@"Profile");
        AYNavigationController *nav = DEFAULTCONTROLLER(@"Navigation");
        [nav pushViewController:des animated:YES];
        
        NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
        [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
        [dic_show_module setValue:nav forKey:kAYControllerActionDestinationControllerKey];
        [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
        
    
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"switchToService" forKey:@"exchange"];
        [userDefaults synchronize];
        
        id<AYCommand> cmd_exchange = EXCHANGEWINDOWS;
        [cmd_exchange performWithResult:&dic_show_module];
        
    });
    
}
-(void)switchToCommon {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 12; i > 0; i--) {
        
        NSString *filename = [NSString stringWithFormat:@"demo%d.png",i];
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [images addObject:image];
        
    }
    [imageView setImage:IMGRESOURCE(@"demo1.png")];
    
    imageView.animationImages = images;
    imageView.animationDuration = 1.0;
    imageView.animationRepeatCount = 1;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView startAnimating];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.view).offset(-50);
        make.left.mas_equalTo(89);
        make.right.mas_equalTo(-89);
        make.height.mas_equalTo(95);
        
        
    }];
    UILabel *tip = [UILabel creatLabelWithText:@"正在切换为预定模式" textColor:[UIColor theme] font:[UIFont mediumFont:16] backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:tip];
    
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageView.mas_bottom);
        
    }];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:[NSNumber numberWithInt:DongDaAppModeCommon] forKey:kAYDongDaAppMode];
    
    [defaults synchronize];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        AYViewController *des = DEFAULTCONTROLLER(@"Home");
        AYNavigationController *nav = DEFAULTCONTROLLER(@"Navigation");
        [nav pushViewController:des animated:YES];
        
        NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
        [dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
        [dic_show_module setValue:nav forKey:kAYControllerActionDestinationControllerKey];
        [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
        
        id<AYCommand> cmd_exchange = EXCHANGEWINDOWS;
        [cmd_exchange performWithResult:&dic_show_module];
        
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
