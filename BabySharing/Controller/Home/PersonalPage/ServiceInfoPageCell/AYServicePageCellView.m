//
//  AYServicePageCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServicePageCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"
#import "AYViewController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYFacade.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "AYAnnonation.h"

#import "AYPlayItemsView.h"

@interface AYServicePageCellView ()<MAMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageBoungaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allowLeaveImage;
@property (weak, nonatomic) IBOutlet UILabel *allowLeaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ownerPhoto;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *ownerAddress;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *readMoreLabel;
//@property (weak, nonatomic) IBOutlet UIButton *readMoreBtn;
@property (weak, nonatomic) IBOutlet UILabel *cansLabel;
@property (weak, nonatomic) IBOutlet UIButton *cansBtn;
@property (weak, nonatomic) IBOutlet UIButton *facalityBtn;
@property (weak, nonatomic) IBOutlet UIView *mapBackView;
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;
@property (weak, nonatomic) IBOutlet UIButton *costBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readMoreSpaceConst;

@property (nonatomic, strong) CLGeocoder *gecoder;

@end

@implementation AYServicePageCellView {
    NSArray *options_title_cans;
    NSArray *options_title_facility;
    
    NSDictionary *service_info;
    
    MAMapView *maMapView;
    AYAnnonation *currentAnno;
}

- (CLGeocoder *)gecoder {
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc]init];
    }
    return _gecoder;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _ownerPhoto.layer.cornerRadius = 30.f;
    _ownerPhoto.clipsToBounds = YES;
    
    _readMoreLabel.userInteractionEnabled = YES;
    [_readMoreLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didReadMoreClick)]];
    
    _cansBtn.hidden = YES;
    
    maMapView = [[MAMapView alloc]init];
    [_mapBackView addSubview:maMapView];
    [maMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mapBackView);
    }];
    maMapView.delegate = self;
    maMapView.scrollEnabled = NO;
//    maMapView.zoomEnabled = NO;
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"7d5d988618fd8a707018941f8cd52931";
    
    [self setUpReuseCell];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServicePageCell", @"ServicePageCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- actions
- (void)didReadMoreClick {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    /** 行高 */
    paraStyle.lineSpacing = 8;
    paraStyle.hyphenationFactor = 1.0;
    NSDictionary *dic_format = @{NSParagraphStyleAttributeName:paraStyle};
    
    NSString *desc = [service_info objectForKey:@"description"];
    if ([_readMoreLabel.text isEqualToString:@"阅读更多"]) {
        _readMoreLabel.text = @"收起";
//        id<AYCommand> reload = [self.notifies objectForKey:@"reLoad"];
//        [reload performWithResult:nil];
    } else {
        _readMoreLabel.text = @"阅读更多";
        desc = [desc substringToIndex:60];
        desc = [desc stringByAppendingString:@"..."];
//        id<AYCommand> reload = [self.notifies objectForKey:@"reLoad"];
//        [reload performWithResult:nil];
    }
    NSAttributedString *descAttri = [[NSAttributedString alloc]initWithString:desc attributes:dic_format];
    _descLabel.attributedText = descAttri;
}

- (IBAction)didReadMoreBtnClick:(id)sender {
}

- (IBAction)didCansBtnClick:(id)sender {
}

- (IBAction)didFacalityBtnClick:(id)sender {
    id<AYCommand> reload = [self.notifies objectForKey:@"showCansOrFacility:"];
    NSNumber *args = [service_info objectForKey:@"facility"];
    [reload performWithResult:&args];
}

- (IBAction)didCalendarBtnClick:(id)sender {
}

- (IBAction)didCostBtnClick:(id)sender {
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args{
    service_info = (NSDictionary*)args;
    
    NSString *titleStr = [service_info objectForKey:@"title"];
    _titleLabel.text = titleStr ? titleStr : @"标题未设置";
    
    NSDictionary *age_boundary = [service_info objectForKey:@"age_boundary"];
    NSNumber *usl = ((NSNumber *)[age_boundary objectForKey:@"usl"]);
    NSNumber *lsl = ((NSNumber *)[age_boundary objectForKey:@"lsl"]);
    NSString *ages = [NSString stringWithFormat:@"%d~%d岁",lsl.intValue,usl.intValue];
    _ageBoungaryLabel.text = [NSString stringWithFormat:@"适合%@孩子",ages];
    
    NSNumber *capacity = [service_info objectForKey:@"capacity"];
    _capacityLabel.text = [NSString stringWithFormat:@"可容纳%d个孩子",capacity.intValue];
    
    NSNumber *allow = [service_info objectForKey:@"allow_leave"];
    BOOL isAllow = allow.boolValue;
    if (isAllow) {
        _allowLeaveImage.hidden = _allowLeaveLabel.hidden = NO;
    } else {
        _allowLeaveImage.hidden = _allowLeaveLabel.hidden = YES;
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    /** 行高 */
    paraStyle.lineSpacing = 8;
    paraStyle.hyphenationFactor = 1.0;
    NSDictionary *dic_format = @{NSParagraphStyleAttributeName:paraStyle};
    NSString *desc = [service_info objectForKey:@"description"];
    if (!desc) {
        desc = @"描述未设置";
    }
    if (desc.length > 60) {
        desc = [desc substringToIndex:60];
        desc = [desc stringByAppendingString:@"..."];
        _readMoreLabel.hidden = NO;
        _readMoreSpaceConst.constant = 35;
    } else {
        _readMoreLabel.hidden = YES;
        _readMoreSpaceConst.constant = 15;
    }
    
    NSAttributedString *descAttri = [[NSAttributedString alloc]initWithString:desc attributes:dic_format];
    _descLabel.attributedText = descAttri;
    
    id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
    NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc]init];
    [dic_owner_id setValue:[service_info objectForKey:@"owner_id"] forKey:@"user_id"];
    
    [cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            _ownerName.text = [result objectForKey:@"screen_name"];
            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:[result objectForKey:@"screen_photo"] forKey:@"image"];
            [dic setValue:@"img_icon" forKey:@"expect_size"];
            [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                UIImage* img = (UIImage*)result;
                if (img != nil) {
                    [_ownerPhoto setImage:img];
                }
            }];
        }
    }];
    
    NSDictionary *dic_loc = [service_info objectForKey:@"location"];
    NSNumber *latitude = [dic_loc objectForKey:@"latitude"];
    NSNumber *longitude = [dic_loc objectForKey:@"longtitude"];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude.floatValue longitude:longitude.floatValue];
    [self.gecoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *pl = [placemarks firstObject];
        NSLog(@"%@",pl.addressDictionary);
        _ownerAddress.text = [NSString stringWithFormat:@"%@,%@",pl.thoroughfare,pl.subLocality];
    }];
    
    if (currentAnno) {
        [maMapView removeAnnotation:currentAnno];
        NSLog(@"remove current_anno");
    }
    //rang
    maMapView.visibleMapRect = MAMapRectMake(location.coordinate.latitude - 3000, location.coordinate.longitude - 5000, 6000, 10000);
    currentAnno = [[AYAnnonation alloc]init];
    currentAnno.coordinate = location.coordinate;
    currentAnno.title = @"定位位置";
    currentAnno.imageName = @"location_self";
    [maMapView addAnnotation:currentAnno];
    NSLog(@"add current_anno");
    //center
    [maMapView setCenterCoordinate:location.coordinate animated:YES];
    
    options_title_cans = @[@"看书",@"做瑜伽",@"做蛋糕",@"玩玩具",@"画画"];
    options_title_facility = @[@"无烟",@"急救包",@"防摔地板", @"安全桌角",@"安全插座", @"安全护栏"];
    
    long options = ((NSNumber*)[service_info objectForKey:@"cans"]).longValue;
    for (int i = 0; i < options_title_cans.count; ++i) {
        long note_pow = pow(2, i);
        if ((options & note_pow)) {
            _cansLabel.text = [NSString stringWithFormat:@"[ %@ ]",options_title_cans[i]];
            break;
        }
    }
    
    {
        long options = ((NSNumber*)[service_info objectForKey:@"facility"]).longValue;
        CGFloat offsetX = 15;
        int noteCount = 0;
        for (int i = 0; i < 4; ++i) {
            long note_pow = pow(2, i);
            if ((options & note_pow)) {
                AYPlayItemsView *item = [[AYPlayItemsView alloc]init];
                NSString *imageName = [NSString stringWithFormat:@"facility_%d",i];
                item.item_icon.image = IMGRESOURCE(imageName);
                item.item_name.text = options_title_facility[i];
                [self addSubview:item];
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self).offset(offsetX);
                    make.centerY.equalTo(_facalityBtn);
                    make.size.mas_equalTo(CGSizeMake(50, 55));
                }];
                offsetX += 85;
                noteCount ++;
            }
        }
        [_facalityBtn setTitle:[NSString stringWithFormat:@"+%d",noteCount] forState:UIControlStateNormal];
    }
    return nil;
}

#pragma mark -- MKMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[AYAnnonation class]]) {
        //默认红色小球
        static NSString *ID = @"anno";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        }
        //设置属性 指定图片
        AYAnnonation *anno = (AYAnnonation *) annotation;
        annotationView.image = [UIImage imageNamed:anno.imageName];
        annotationView.tag = anno.index;
        //展示详情界面
        annotationView.canShowCallout = NO;
        return annotationView;
    } else {
        //采用系统默认蓝色大头针
        return nil;
        
    }
}
@end
