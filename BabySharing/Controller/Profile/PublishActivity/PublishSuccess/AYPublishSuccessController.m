//
//  AYPublishSuccessController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYPublishSuccessController.h"

@interface AYPublishSuccessController ()

@end

@implementation AYPublishSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *success = [UILabel creatLabelWithText:@"发布成功！" textColor:[UIColor theme] fontSize:24.0f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:success];
    
    [success mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        
    }];
    
    
    [success setFont:[UIFont mediumFont:24]];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [self.view addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(31);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(success.mas_top).offset(-40);
        
    }];
    [icon setImage:IMGRESOURCE(@"checked_icon")];
    
    UIButton *close = [[UIButton alloc] init];
    [self.view addSubview:close];
    
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.width.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(34);
        
    }];
    
    [close setImage:IMGRESOURCE(@"content_close") forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];

    
}


-(void) close {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:@"PublishSuccess" forKey:kAYControllerChangeArgsKey];
    
    
    id<AYCommand> cmd = REVERSMODULE;
    [cmd performWithResult:&dic];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
