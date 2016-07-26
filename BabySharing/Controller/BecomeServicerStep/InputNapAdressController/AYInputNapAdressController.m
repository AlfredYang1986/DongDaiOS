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
#import "Tools.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
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
            headAdressString = [dic_cost objectForKey:@"head"];
            customString = [dic_cost objectForKey:@"detail"];
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
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
    UIColor* c_nav = [UIColor clearColor];
    [cmd_nav performWithResult:&c_nav];
    
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
    headAdress = [Tools setLabelWith:headAdress andText:@"正在定位...." andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
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
    }else {
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
        make.top.equalTo(headbg.mas_bottom).offset(30);
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
        headAdress.text = address;
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
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"保存" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"设置具体地址";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [Tools blackColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2 + 20);
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
    
    //整合数据
    NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
    [dic_options setValue:loc forKey:@"location"];
    [dic_options setValue:headAdress.text forKey:@"head"];
    [dic_options setValue:customField.text forKey:@"detail"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:dic_options forKey:@"content"];
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