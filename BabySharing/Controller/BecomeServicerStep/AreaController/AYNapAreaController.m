//
//  AYNapAreaController.m
//  BabySharing
//
//  Created by Alfred Yang on 18/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNapAreaController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "Tools.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define SHOW_OFFSET_Y               SCREEN_HEIGHT - 196
#define FAKE_BAR_HEIGHT             44

@interface AYNapAreaController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *gecoder;

@end

@implementation AYNapAreaController{
    UIView *picker;
    UILabel *areaLabel;
    CLLocation *loc;
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

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
//    [self.manager requestAlwaysAuthorization];
    [self.manager requestWhenInUseAuthorization];
    //定位精度
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.manager.delegate = self;
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位
        [self.manager startUpdatingLocation];
    }
    
    UILabel *title = [[UILabel alloc]init];
    [self.view addSubview:title];
    title = [Tools setLabelWith:title andText:@"您看护宝宝的区域" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(94);
        make.centerX.equalTo(self.view);
    }];
    
    CGFloat margin = 30.f;
    UIView *areaView = [[UIView alloc]init];
    [self.view addSubview:areaView];
    areaView.backgroundColor = [UIColor whiteColor];
    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - margin*2, 30));
    }];
    areaView.userInteractionEnabled = YES;
    [areaView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedArea:)]];
    
    areaLabel = [[UILabel alloc]init];
    areaLabel = [Tools setLabelWith:areaLabel andText:@"北京北京市" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [areaView addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(areaView);
        make.left.equalTo(areaView).offset(10);
    }];
    
    UIImageView *access = [[UIImageView alloc]init];
    [areaView addSubview:access];
    access.image = IMGRESOURCE(@"chan_group_back");
    [access mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(areaView).offset(-10);
        make.centerY.equalTo(areaView);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"NapArea"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
    UIButton *nextBtn = [[UIButton alloc]init];
    nextBtn.backgroundColor = [Tools themeColor];
    [nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    [self.view bringSubviewToFront:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
    [nextBtn addTarget:self action:@selector(didNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //CLLocation  位置对象
    
    loc = [locations firstObject];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    id<AYViewBase> map = [self.views objectForKey:@"NapAreaMap"];
    id<AYCommand> cmd = [map.commands objectForKey:@"queryOnesLocal:"];
    CLLocation *loction = loc;
    [cmd performWithResult:&loction];
    
    NSLog(@"%f  %f",coordinate.latitude,coordinate.longitude);
    
    //位置改变幅度大 ->重新定位
    [manager stopUpdatingLocation];
    
    [self.gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pl = [placemarks firstObject];
        NSString *prvince = pl.administrativeArea;
        if ([prvince isEqualToString:@"北京市"] || [prvince isEqualToString:@"天津市"] || [prvince isEqualToString:@"上海市"] || [prvince isEqualToString:@"重庆市"]) {
            prvince = [prvince substringToIndex:2];
        }
        NSString *city = pl.locality;
        NSString *area = pl.subLocality;
        NSString *address = [NSString stringWithFormat:@"%@%@%@",prvince, city, area];
        areaLabel.text = address;
    }];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor whiteColor];
//    CALayer *line = [CALayer layer];
//    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
//    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
//    [view.layer addSublayer:line];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
//    id<AYCommand> cmd_left_vis = [bar.commands objectForKey:@"setLeftBtnVisibility:"];
//    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
//    [cmd_left_vis performWithResult:&left_hidden];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    
    titleView.text = @"位置";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    return nil;
}

- (id)NapAreaMapLayout:(UIView*)view {
    view.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - 200);
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- actions
- (void)didSelectedArea:(UIButton*)btn{
    id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
    picker = (UIView*)view_picker;
    [self.view bringSubviewToFront:picker];
    
    if (picker.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
        }];
    }
}

- (void)didNextBtnClick:(UIButton*)btn{
//    MainInfo
    id<AYCommand> setting = DEFAULTCONTROLLER(@"MainInfo");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}
- (id)rightBtnSelected {
    
//    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您修改的信息已提交$.$" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    return nil;
}

-(id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"NapArea"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSString *address = nil;
    [cmd_index performWithResult:&address];
    
    if (address) {
        areaLabel.text = address;
    }
    
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}
-(id)didCancelClick {
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}

@end
