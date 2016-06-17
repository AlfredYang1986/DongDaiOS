//
//  AYSearchFriendController.m
//  BabySharing
//
//  Created by Alfred Yang on 17/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYLocationController.h"
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

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#import "Tools.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchKit.h>

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@interface AYLocationController ()<UISearchBarDelegate, CLLocationManagerDelegate, AMapSearchDelegate>
@property (nonatomic, strong) CLLocationManager  *manager;
@property (nonatomic, strong) CLGeocoder *gecoder;
@end

@implementation AYLocationController{
    NSMutableArray *loading_status;
    
    CLLocation *loc;
    AMapSearchAPI *search;
    
    AMapBusLine *aBusMapTip;
}

@synthesize manager = _manager;
@synthesize gecoder = _gecoder;

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
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"7d5d988618fd8a707018941f8cd52931";
    
    //初始化检索对象
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"Location"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
        id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"LocationCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];
    
    UIView* titleSearch = [self.views objectForKey:@"SearchBar"];
    self.navigationItem.titleView = titleSearch;
    self.navigationItem.hidesBackButton = YES;
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 9, SCREEN_WIDTH, 1);
    [headView.layer addSublayer:line2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //授权使用定位服务
    [self.manager requestAlwaysAuthorization];
//    [self.manager requestWhenInUseAuthorization];
    //定位精度
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    self.manager.delegate = self;
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位
        [self.manager startUpdatingLocation];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UIView* view = [self.views objectForKey:@"SearchBar"];
    [view resignFirstResponder];
}

//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //CLLocation  位置对象
    
    loc = [locations firstObject];
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    NSLog(@"%f  %f",coordinate.latitude,coordinate.longitude);
    
    //位置改变幅度大 ->重新定位
    [manager stopUpdatingLocation];
    
    [self.gecoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *pl = [placemarks firstObject];
        NSString *name = pl.name;
        
        id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"Location"];
        id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"autoLocationData:"];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:name forKey:@"auto_location_name"];
        [dic setValue:loc forKey:@"auto_location"];
        [cmd performWithResult:&dic];
        
        id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
        [cmd_refresh performWithResult:nil];
        
    }];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 10+64, SCREEN_WIDTH, SCREEN_HEIGHT - 74);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

- (id)SearchBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"registerDelegate:"];
    id del = self;
    [cmd performWithResult:&del];
    
    id<AYCommand> cmd_place_hold = [((id<AYViewBase>)view).commands objectForKey:@"changeSearchBarPlaceHolder:"];
    id place_holder = @"输入你的位置";
    [cmd_place_hold performWithResult:&place_holder];
    
    id<AYCommand> cmd_apperence = [((id<AYViewBase>)view).commands objectForKey:@"foundSearchBar"];
    [cmd_apperence performWithResult:nil];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- search bar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = searchText;
    tips.city     = @"北京";
    tips.cityLimit = YES; //是否限制城市
    [search AMapInputTipsSearch:tips];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
//    [self.tips setArray:response.tips];
    
    id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"Location"];

    id<AYCommand> cmd = [cmd_relations.commands objectForKey:@"changeLocationResultData:"];
    
    NSArray* tmp = response.tips;
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (AMapTip *tip in tmp) {
//        if (tip.uid != nil && tip.location != nil) /* 可以直接在地图打点  */
//        {
//            CLLocation *location = [[CLLocation alloc]initWithLatitude:tip.location.latitude longitude:tip.location.longitude];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:tip.name forKey:@"location_name"];
//            [dic setValue:location forKey:@"location"];
//            [arr addObject:dic];
//        }
//        else if (tip.uid != nil && tip.location == nil)/* 公交路线，显示出来*/
//        {
//            AMapBusLineIDSearchRequest *request = [[AMapBusLineIDSearchRequest alloc] init];
//            request.city                        = @"北京";
//            request.uid                         = tip.uid;
//            request.requireExtension            = YES;
//            
//            [search AMapBusLineIDSearch:request];
//            
//            if (aBusMapTip) {
//                CLLocation *location = [[CLLocation alloc]initWithLatitude:aBusMapTip.location.latitude longitude:aBusMapTip.location.latitude];NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//                [dic setValue:aBusMapTip.name forKey:@"location_name"];
//                [dic setValue:location forKey:@"location"];
//                [arr addObject:dic];
//            }
//        }
//        else if(tip.uid == nil && tip.location == nil)/* 品牌名，进行POI关键字搜索 */
//        {
//            
//        }
//    }
    
    
    [cmd performWithResult:&tmp];

    id<AYCommand> cmd_refresh = [view_friend.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
}
/* 公交搜索回调. */
- (void)onBusLineSearchDone:(AMapBusLineBaseSearchRequest *)request response:(AMapBusLineSearchResponse *)response
{
    if (response.buslines.count != 0)
    {
        aBusMapTip = response.buslines.firstObject;
//        AMapBusLine *busLine
    }
    
}

- (id)searchTextChanged:(id)obj {
    NSString* search_text = (NSString*)obj;
    NSLog(@"text %@", search_text);
    
    return nil;
}

- (id)scrollToHideKeyBoard {
    UIView* view = [self.views objectForKey:@"SearchBar"];
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
    }
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}

@end
