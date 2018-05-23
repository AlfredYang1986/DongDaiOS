//
//  AYServiceChooseController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/9.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYServiceChooseController.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@interface AYServiceChooseController () {
    
    NSMutableArray *locations;
    NSMutableArray *serviceData;
    NSString *address;
    
}

@end

@implementation AYServiceChooseController

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        NSString *location_id = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"location_id"];
        
        locations = [[NSMutableArray alloc] init];
        
        [locations addObject:location_id];
        
//        NSString *str  = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"address"];
//
//        NSRange range = [str rangeOfString:@"路"];
//
//        address = [str substringToIndex:range.location + 1];
        
        address = [[dic objectForKey:kAYControllerChangeArgsKey] objectForKey:@"address"];
        
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
       
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"ServiceChoose"];
    id obj = (id)cmd_notify;
    kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
    obj = (id)cmd_notify;
    kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
    
    NSString* class_name1 = @"AYServiceChooseCellView";
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name1)
    
    NSString* class_name2 = @"AYServiceAddCellView";
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name2)
    
    [self.view setBackgroundColor:[UIColor garyBackground]];
    
    UILabel *head = [UILabel creatLabelWithText:@"你想要招生的服务是" textColor:[UIColor black] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:head];
    
    [head mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(14 + kStatusBarH + kNavBarH);
        
    }];
    
    [head setFont:[UIFont boldFont:24]];
    
    
    {
        
        NSDictionary *user;
        CURRENUSER(user);
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
        [dic setValue:[locations copy] forKey:@"locations"];
        
        id<AYFacadeBase> facade = [self.facades objectForKey:@"ServiceRemote"];
        AYRemoteCallCommand *cmd = [facade.commands objectForKey:@"QueryUserService"];
        
        [cmd performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
            
            
            if (success) {
                
                self -> serviceData = [[result objectForKey:@"services"] mutableCopy];
                
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                
                [data setValue: self -> address forKey:@"address"];
                [data setValue: self -> serviceData forKey:@"serviceData"];
                
                id tmp = [data copy];
                
                kAYDelegatesSendMessage(@"ServiceChoose", kAYDelegateChangeDataMessage, &tmp)
                
                kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
                
                
                
            } else {
                
                
                
            }
            
            
        }];
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
        make.top.mas_equalTo(145);
        
    }];
    
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return nil;
    
}


- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    
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
