//
//  AYLocationChooseController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/9.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYLocationChooseController.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYShadowRadiusView.h"
@interface AYLocationChooseController () {
    
    NSMutableArray *locationData;
    NSString *address;
    
}

@end

@implementation AYLocationChooseController

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        NSDictionary *temp = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"location"];
        
        //NSString *city = [temp objectForKey:@"city"];
        
        NSString *district = [temp objectForKey:@"district"];
        
        NSString *add = [temp objectForKey:@"address"];
        
        address = [NSString stringWithFormat:@"%@%@",district,add];
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"LocationChoose"];
    id obj = (id)cmd_notify;
    kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
    obj = (id)cmd_notify;
    kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
    
    NSString* class_name = @"AYLocationChooseCellView";
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    [self.view setBackgroundColor:[UIColor garyBackground]];
    
    UILabel *desc = [UILabel creatLabelWithText:@"你想要招生的场地是" textColor:[UIColor black] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:desc];
    [desc setFont:[UIFont boldFont:24]];
    
    [desc mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(14 + kStatusBarH + kNavBarH);
        
    }];
    
    UILabel *location = [UILabel creatLabelWithText:@"当前位置" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:location];
    [location setFont:[UIFont regularFont:15]];
    
    
    
    [location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(desc);
        make.top.equalTo(desc.mas_bottom).offset(40);
    }];
    
    AYShadowRadiusView *shadowView = [[AYShadowRadiusView alloc] initWithRadius:4];
    [self.view addSubview:shadowView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(location.mas_bottom).offset(8);
        make.height.mas_equalTo(77);
        
    }];
    
    UIButton *locationButton = [UIButton creatBtnWithTitle:@"" titleColor:[UIColor black] fontSize:15.0f backgroundColor:[UIColor white]];
    
    [self.view addSubview:locationButton];
    
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(shadowView);
        
    }];
    
   
    [locationButton.layer setCornerRadius:4];
    [locationButton.layer setMasksToBounds:YES];
    
    [shadowView addSubview:locationButton];
    
    UIImageView *icon = [[UIImageView alloc]init];
    [shadowView addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(11);
        make.centerY.equalTo(shadowView);
        make.left.mas_equalTo(26);
    }];
    
    [icon setImage:IMGRESOURCE(@"home_icon_location")];
    
    UILabel *place = [UILabel creatLabelWithText:address textColor:[UIColor black] fontSize:15 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    
    [shadowView addSubview:place];
    
    [place mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(4);
        make.centerY.equalTo(shadowView);
    }];
    
    [place setFont:[UIFont regularFont:15]];
    
    UIImageView *detail = [[UIImageView alloc]init];
    [shadowView addSubview:detail];
    
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13);
        make.centerY.equalTo(shadowView);
        make.right.mas_equalTo(-26);
        
    }];
    [detail setImage:IMGRESOURCE(@"details_icon_arrow_right")];
    
    
    UILabel *had = [UILabel creatLabelWithText:@"已有场地" textColor:[UIColor black] fontSize:15.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:had];
    
    [had mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(location);
        make.top.equalTo(shadowView.mas_bottom).offset(26);
        
        
    }];
    
    [had setFont:[UIFont regularFont:15]];
    
    
    {
        
        NSDictionary *user;
        CURRENUSER(user);
        
        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
        
        [condition setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
        
        NSMutableDictionary *brand = [[NSMutableDictionary alloc] init];
        
        
        [brand setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
        [brand setValue:condition forKey:kAYCommArgsCondition];
        
        id<AYFacadeBase> brandFacade = [self.facades objectForKey:@"BrandRemote"];
        AYRemoteCallCommand *cm = [brandFacade.commands objectForKey:@"QueryBrandID"];
        
        [cm performWithResult:[brand copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        
            if(success) {
                
                NSString *brand_id = [result objectForKey:@"brand_id"];
                
                if (![brand_id isEqual:nil] && ![brand_id isKindOfClass:[NSNull class]]) {
                    
                    //5a66fdea59a6270918508f25
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                    [dic setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
                    [dic setValue:brand_id forKey:@"brand_id"];
                    
                    id<AYFacadeBase> facade = [self.facades objectForKey:@"LocationRemote"];
                    AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"QueryUserLocation"];
                    
                    [cmd performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
                        
                        
                        if (success) {
                            
                            self -> locationData = [[result objectForKey:@"locations"] mutableCopy];
                            
                            id tmp = [self -> locationData copy];
                            
                            kAYDelegatesSendMessage(@"LocationChoose", kAYDelegateChangeDataMessage, &tmp)
                            
                            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
                            
                        }
                        
                        
                    }];
                    
                    
                }else {
                    
                    NSString *title = @"对不起，您还没有场地~";
                    AYShowBtmAlertView(title, BtmAlertViewTypeHideWithAction)
                    
                }
                
                
            }else {
                
                
                
            }
        }];
        
        
        
    
//        NSString* owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
//
//        [[dic objectForKey:kAYCommArgsCondition] setValue:owner_id  forKey:kAYCommArgsUserID];
//
//
//        id<AYFacadeBase> facade = [self.facades objectForKey:@"ProfileRemote"];
//
//        AYRemoteCallCommand* cmd = [facade.commands objectForKey:@"QueryUserProfile"];
    }
    
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
    
    
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(320);
        
    }];
    
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return nil;
    
}


- (id)leftBtnSelected {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"返回即退出本次发布，请确认放弃本次发布？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AYViewController *des = DEFAULTCONTROLLER(@"Profile");
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopToDestValue forKey:kAYControllerActionKey];
        [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        
        id<AYCommand> cmd = POPTODEST;
        [cmd performWithResult:&dic];
        
        
    }];
    [alert addAction:cancel];
    [alert addAction:certain];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    return nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
