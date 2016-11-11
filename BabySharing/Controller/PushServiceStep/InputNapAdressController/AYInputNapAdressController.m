//
//  AYInputNapAdressController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYInputNapAdressController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   228

@interface AYInputNapAdressController ()<UITextViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *gecoder;
@end

@implementation AYInputNapAdressController {
    CLLocation *loc;
    
    UILabel *headAdress;
    NSString *headAdressString;
    
    UITextField *customField;
    NSString *customString;
    
}

- (CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}
-(CLGeocoder *)gecoder{
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc]init];
    }
    return _gecoder;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_cost = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_cost) {
            headAdressString = [dic_cost objectForKey:@"address"];
            customString = [dic_cost objectForKey:@"adjust_address"];
            loc = [dic_cost objectForKey:@"location"];
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *dic_loc = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_loc) {
            headAdressString = [dic_loc objectForKey:@"location_name"];
            loc = [dic_loc objectForKey:@"location"];
            
            headAdress.text = headAdressString;
            id<AYViewBase> map = [self.views objectForKey:@"NapAdressMap"];
            id<AYCommand> cmd = [map.commands objectForKey:@"queryOnesLocal:"];
            CLLocation *loction = loc;
            [cmd performWithResult:&loction];
        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *headbg = [[UIView alloc]init];
    [self.view addSubview:headbg];
    headbg.backgroundColor = [UIColor whiteColor];
    [headbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(104);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
    }];
    
    headAdress = [[UILabel alloc]init];
    [headbg addSubview:headAdress];
    headAdress = [Tools setLabelWith:headAdress andText:@"正在定位, 请稍后..." andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    headAdress.layoutMargins = UIEdgeInsetsMake(15, 0, 0, 0);
    [headAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headbg);
        make.left.equalTo(headbg).offset(10);
        make.right.equalTo(headbg);
    }];
    headAdress.userInteractionEnabled = YES;
    [headAdress addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSetCustomAdress:)]];
    
    if (!headAdressString) {
        //    [self.manager requestAlwaysAuthorization];
        [self.manager requestWhenInUseAuthorization];
        
        //定位精度
        self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.manager.delegate = self;
        if ([CLLocationManager locationServicesEnabled]) {
            //开始定位
            [self.manager startUpdatingLocation];
        }
    } else {
        headAdress.text = headAdressString;
        id<AYViewBase> map = [self.views objectForKey:@"NapAdressMap"];
        id<AYCommand> cmd = [map.commands objectForKey:@"queryOnesLocal:"];
        CLLocation *loction = loc;
        [cmd performWithResult:&loction];
    }
    
    UIImageView *icon = [[UIImageView alloc]init];
    [self.view addSubview:icon];
    icon.image = IMGRESOURCE(@"plan_time_icon");
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headAdress);
        make.right.equalTo(headAdress).offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    customField = [[UITextField alloc]init];
    [self.view addSubview:customField];
    if (customString) {
        customField.text = customString;
    }
    customField.textColor = [Tools blackColor];
    customField.font = [UIFont systemFontOfSize:14.f];
    customField.backgroundColor = [UIColor whiteColor];
    UILabel*paddingView= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
    paddingView.backgroundColor= [UIColor clearColor];
    customField.leftView = paddingView;
    customField.leftViewMode = UITextFieldViewModeAlways;
    customField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [customField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headbg.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 40));
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //CLLocation  位置对象
    
    loc = [locations firstObject];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    id<AYViewBase> map = [self.views objectForKey:@"NapAdressMap"];
    id<AYCommand> cmd = [map.commands objectForKey:@"queryOnesLocal:"];
    CLLocation *loction = loc;
    [cmd performWithResult:&loction];
    
    NSLog(@"%f  %f",coordinate.latitude,coordinate.longitude);
    
    //位置改变幅度大 ->重新定位
    [manager stopUpdatingLocation];
    
    [self.gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pl = [placemarks firstObject];
        NSString *address = pl.name;
        headAdress.text = (!address||[address isEqualToString:@"(null)"]||[address isEqualToString:@""])?@"点击选择区域":address;
    }];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"具体位置";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)NapAdressMapLayout:(UIView*)view {
    view.frame = CGRectMake(0, 240, SCREEN_WIDTH, SCREEN_HEIGHT - 240);
    return nil;
}

#pragma mark -- actions
-(void)didSetCustomAdress:(UIGestureRecognizer*)tap{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"NapLocation");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"push" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}
- (id)rightBtnSelected {
    
    if ([headAdress.text isEqualToString:@"正在定位, 请稍后..."] || [headAdress.text isEqualToString:@"点击选择区域"] || [customField.text isEqualToString:@""]) {
        
        NSString *title = @"请完成具体地址设置";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:loc forKey:@"location"];
    [dic_info setValue:headAdress.text forKey:@"address"];
    [dic_info setValue:customField.text forKey:@"adjust_address"];
    [dic_info setValue:@"nap_adress" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    if ([customField isFirstResponder]) {
        [customField resignFirstResponder];
    }
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}
@end
