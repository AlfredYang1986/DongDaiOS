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

#import <AMapSearchKit/AMapSearchKit.h>

#define SHOW_OFFSET_Y				SCREEN_HEIGHT - 196
#define FAKE_BAR_HEIGHT				44
#define locBGViewHeight				175
#define nextBtnHeight				50

@implementation AYNapAreaController {
    
    NSMutableDictionary *service_info;
	
    UILabel *areaLabel;
    CLLocation *loc;
    
    //new
    NSString *navTitleStr;
    UIView *locBGView;
    UILabel *adressLabel;
    UITextField *adjustAdress;
    NSString *editMode;
}

- (CLLocationManager *)manager {
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}
- (CLGeocoder *)gecoder {
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc]init];
    }
    return _gecoder;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
		id args = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([args isKindOfClass:[NSDictionary class]]) {
            service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        } else if ([args isKindOfClass:[NSString class]]) {
            editMode = @"确定";
        }
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *dic_loc = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_loc) {
            NSString* headAdressStr = [dic_loc objectForKey:@"location_name"];
            loc = [dic_loc objectForKey:@"location"];
            
            adressLabel.text = headAdressStr;
            
            id<AYViewBase> map = [self.views objectForKey:@"NapAreaMap"];
            id<AYCommand> cmd = [map.commands objectForKey:@"queryOnesLocal:"];
            CLLocation *loction = [loc copy];
            [cmd performWithResult:&loction];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.manager requestWhenInUseAuthorization];
    //定位精度
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.manager.delegate = self;
    
    BOOL isEnabled = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
    if (isEnabled) {
        [self.manager startUpdatingLocation];
    } else {
        NSString *title = @"发布服务需要开启定位服务";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
    }
    
    locBGView = [[UIView alloc]init];
    locBGView.backgroundColor = [Tools whiteColor];
    [self.view addSubview:locBGView];
    [locBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(175);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 175));
    }];
    CALayer *topLine = [CALayer layer];
    topLine.backgroundColor = [Tools garyLineColor].CGColor;
    topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    [locBGView.layer addSublayer:topLine];
    
    adressLabel = [Tools creatUILabelWithText:@"正在定位" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [locBGView addSubview:adressLabel];
    [adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locBGView.mas_top).offset(30);
        make.left.equalTo(locBGView).offset(20);
        make.right.equalTo(locBGView).offset(-20);
    }];
    adressLabel.userInteractionEnabled = YES;
    [adressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAdressLabeTap)]];
    
    UIImageView *access = [[UIImageView alloc]init];
    [locBGView addSubview:access];
    access.image = IMGRESOURCE(@"plan_time_icon");
    [access mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(locBGView).offset(-20);
        make.centerY.equalTo(adressLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    CALayer *centerLine = [CALayer layer];
    centerLine.backgroundColor = [Tools garyLineColor].CGColor;
    centerLine.frame = CGRectMake(10, 60, SCREEN_WIDTH - 20, 0.5);
    [locBGView.layer addSublayer:centerLine];
    
//    adjustAdress = [Tools creatUILabelWithText:@"门牌号" andTextColor:[Tools garyColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    adjustAdress = [[UITextField alloc]init];
    adjustAdress.font = kAYFontLight(17.f);
    adjustAdress.placeholder = @"门牌号";
    adjustAdress.textColor = [Tools blackColor];
    adjustAdress.clearButtonMode = UITextFieldViewModeWhileEditing;
    adjustAdress.returnKeyType = UIReturnKeyDone;
    adjustAdress.delegate = self;
    [locBGView addSubview:adjustAdress];
    [adjustAdress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressLabel).offset(60);
        make.left.equalTo(adressLabel);
        make.right.equalTo(locBGView).offset(-10);
    }];
	
    UIButton *nextBtn = [Tools creatUIButtonWithTitle:@"下一步" andTitleColor:[Tools whiteColor] andFontSize:17.f andBackgroundColor:[Tools themeColor]];
    [locBGView addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(didNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(locBGView);
        make.centerX.equalTo(locBGView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    if (editMode) {
        [nextBtn setTitle:editMode forState:UIControlStateNormal];
    }
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapGesture {
    [adjustAdress resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    NSString *title = @"正在定位";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)NapAreaMapLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
    return nil;
}

- (id)PickerLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
    view.backgroundColor = [Tools garyColor];
    return nil;
}

#pragma mark -- textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [adjustAdress resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -- 定位代理方法
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            [self.manager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied: NSLog(@"Denied"); break;
        case kCLAuthorizationStatusNotDetermined: NSLog(@"not Determined"); break;
        case kCLAuthorizationStatusRestricted: NSLog(@"Restricted"); break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    loc = [locations firstObject];
    
    id<AYViewBase> map = [self.views objectForKey:@"NapAreaMap"];
    id<AYCommand> cmd = [map.commands objectForKey:@"queryOnesLocal:"];
    CLLocation *loction = loc;
    [cmd performWithResult:&loction];
    
    [manager stopUpdatingLocation];
    
    [self.gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pl = [placemarks firstObject];
        NSString *city = pl.locality;
        
        if (city == nil) {
            
            return ;
        } else {
            
            navTitleStr = city;
            NSLog(@"%@",city);
            kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &city)
            
            if (![navTitleStr isEqualToString:@"北京市"] && ![navTitleStr isEqualToString:@"Beijing"]) {
                NSString *title = [NSString stringWithFormat:@"咚哒目前只支持北京市地区. \n我们正在努力达到%@",navTitleStr];
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
                return ;
            }
            
//            NSString *address = pl.name;
			NSString *addressStr = pl.name;
			NSString *stringPre = @"中国北京市";
			if ([addressStr hasPrefix:stringPre]) {
				addressStr = [addressStr substringFromIndex:5];
			}
			
            adressLabel.text = (!addressStr || [addressStr isEqualToString:@""]) ? @"点击选择区域" : addressStr;
            [UIView animateWithDuration:0.25 animations:^{
                UIView *view = [self.views objectForKey:@"NapAreaMap"];
                view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH - 175);
                [locBGView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view);
                }];
                [self.view layoutIfNeeded];
            }];
            
        }
        
    }];
}

#pragma mark -- actions
- (void)didSelectedArea:(UIButton*)btn {
    id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
    UIView *picker = (UIView*)view_picker;
    [self.view bringSubviewToFront:picker];
    
    id<AYCommand> cmd_show = [view_picker.commands objectForKey:@"showPickerView"];
    [cmd_show performWithResult:nil];
}

- (void)didAdressLabeTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"NapLocation");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"push" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)didNextBtnClick:(UIButton*)btn {
    
    if ([adjustAdress.text isEqualToString:@""]) {
        NSString *title = @"请完成具体地址设置";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
    if (editMode) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        
        NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
        [location setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:kAYServiceArgsLatitude];
        [location setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:kAYServiceArgsLongtitude];
        
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:location forKey:@"location"];
        [tmp setValue:navTitleStr forKey:kAYServiceArgsDistrict];
        [tmp setValue:adressLabel.text forKey:@"address"];
        [tmp setValue:adjustAdress.text forKey:kAYServiceArgsAdjustAddress];
        [dic setValue:tmp forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
    } else {
        //    id<AYCommand> dist = DEFAULTCONTROLLER(@"MainInfo");
        id<AYCommand> dist = DEFAULTCONTROLLER(@"SetServiceCapacity");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:dist forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
		
		NSMutableDictionary *info_location = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *pin = [[NSMutableDictionary alloc]init];
        [pin setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:kAYServiceArgsLatitude];
        [pin setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:kAYServiceArgsLongtitude];
		[info_location setValue:pin forKey:kAYServiceArgsPin];
		
        [info_location setValue:navTitleStr forKey:kAYServiceArgsDistrict];
        [info_location setValue:adressLabel.text forKey:kAYServiceArgsAddress];
        [info_location setValue:adjustAdress.text forKey:kAYServiceArgsAdjustAddress];
		
		[service_info setValue:info_location forKey:kAYServiceArgsLocationInfo];
		[dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];
		
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}
- (id)rightBtnSelected {
    
    return nil;
}

- (id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"NapArea"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSString *address = nil;
    [cmd_index performWithResult:&address];
    
    if (address) {
        areaLabel.text = address;
    }
    return nil;
}

- (id)didCancelClick {
    return nil;
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
    
    NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	[UIView animateWithDuration:0.25 animations:^{
		[locBGView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.view).offset(-step.floatValue+nextBtnHeight);
		}];
		[self.view layoutIfNeeded];
	}];
	
    return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
	
	[UIView animateWithDuration:0.25 animations:^{
		[locBGView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.view);
		}];
		[self.view layoutIfNeeded];
	}];
    return nil;
}

@end
