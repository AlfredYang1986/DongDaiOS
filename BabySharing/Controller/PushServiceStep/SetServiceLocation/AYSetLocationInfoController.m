//
//  AYSetServiceLocationController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetLocationInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#define kMaxImagesCount             9
static NSString* const kTableDelegate =					@"SetLocationInfo";

@implementation AYSetLocationInfoController {
	
	NSMutableDictionary *push_service_info;
	NSMutableDictionary *tmp_service_info;
	
	NSMutableArray *selectImageArr;
	
	BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSString *desc = [dic objectForKey:kAYControllerChangeArgsKey];
		[tmp_service_info setValue:desc forKey:kAYServiceArgsDescription];
		
		id tmp = [tmp_service_info copy];
		kAYDelegatesSendMessage(kTableDelegate, kAYDelegateChangeDataMessage, &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		
		[self setNavRightBtnEnableStatus];
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"场地信息" andTextColor:[Tools blackColor] andFontSize:622.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:kTableDelegate];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	NSArray *class_name_arr = @[@"AYSetServiceYardTypeCellView", @"AYSetServiceAddressCellView", @"AYSetServiceFacilityCellView", @"AYSetServiceYardImagesCellView"];
	for (NSString *class_name in class_name_arr) {
		id t = [class_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &t)
	}
	
	tmp_service_info = [[NSMutableDictionary alloc] init];
	NSDictionary *info_location = [push_service_info objectForKey:kAYServiceArgsLocationInfo];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsYardType] forKey:kAYServiceArgsYardType];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsAddress] forKey:kAYServiceArgsAddress];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsAdjustAddress] forKey:kAYServiceArgsAdjustAddress];
//	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsFacility] forKey:kAYServiceArgsFacility];
//	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsLocImages] forKey:kAYServiceArgsLocImages];
	
	[tmp_service_info setValue:class_name_arr forKey:kAYDefineArgsCellNames];
	
	id tmp = [tmp_service_info copy];
	kAYDelegatesSendMessage(kTableDelegate, kAYDelegateChangeDataMessage, &tmp);
	{
		id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
		id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
		
		id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"YardTypePick"];
		
		id obj = (id)cmd_recommend;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_recommend;
		[cmd_delegate performWithResult:&obj];
		
		[self.view bringSubviewToFront:(UIView*)view_picker];
//		NSNumber *index = [NSNumber numberWithInteger:0];
//		kAYDelegatesSendMessage(@"SetAgeBoundary", kAYDelegateChangeDataMessage, &index)
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:616.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
//	((UITableView*)view).estimatedRowHeight = 100;
//	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
	view.frame = CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT - 130);
	return nil;
}
#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
	TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount - 1 delegate:self];
	
	imagePickerVc.isSelectOriginalPhoto = NO/*_isSelectOriginalPhoto*/;
	imagePickerVc.allowTakePicture = YES; // 是否显示拍照按钮
	
	// 2. 在这里设置imagePickerVc的外观
	imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
	imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
	imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
	
	// 3.你可以通过block或者代理，来得到用户选择的照片.
	[imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
		
	}];
	
	[self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
	NSLog(@"cancel");
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	if ([type isEqualToString:@"public.image"]) {
		
		TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount delegate:self];
		[tzImagePickerVc showProgressHUD];
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
		[self setNavRightBtnEnableStatus];
		
		// 保存图片，获取到asset
		[[TZImageManager manager] savePhotoWithImage:image completion:^{
			
			[tzImagePickerVc hideProgressHUD];
			
		}];
	}
}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
	
	selectImageArr = [tmp_service_info objectForKey:kAYServiceArgsYardImages];
	if (!selectImageArr) {
		selectImageArr = [NSMutableArray array];
		[tmp_service_info setValue:selectImageArr forKey:kAYServiceArgsYardImages];
	}
	[selectImageArr addObjectsFromArray:photos];
	[self refreshMainDelegate];
	
}

#pragma mark -- actions
- (void)setNavRightBtnEnableStatus {
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:616.f andBackgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}

- (void)refreshMainDelegate {
	
	id tmp = [tmp_service_info copy];
	kAYDelegatesSendMessage(kTableDelegate, kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	[self setNavRightBtnEnableStatus];
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
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[tmp_service_info setValue:@"part_basic" forKey:@"key"];
	[dic setValue:[tmp_service_info copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)sendTransHeight:(id)args {
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	
	[view_table beginUpdates];
	kAYDelegatesSendMessage(kTableDelegate, @"resetCellHeight:", &args)
	[view_table endUpdates];
	
	return nil;
}

- (id)pickYardType {
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)didAddressLabelTap {
	id<AYCommand> dest = DEFAULTCONTROLLER(@"NapLocation");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc] init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
//	[dic_push setValue:[tmp_service_info objectForKey:kAYServiceArgsFacility] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	return nil;
}

- (id)setServiceFacility {
	
	id<AYCommand> dest = DEFAULTCONTROLLER(@"EditServiceCapacity");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc] init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:[tmp_service_info objectForKey:kAYServiceArgsFacility] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	return nil;
}

- (id)deletedImageWithIndex:(id)args {
	[selectImageArr removeObjectAtIndex:[args integerValue]];
	[self refreshMainDelegate];
	return nil;
}
- (id)beginImagePicker {
	[self pushImagePickerController];
	return nil;
}
- (id)editYardImagesTag:(id)args {
	
	return nil;
}



- (id)PickerLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
	return nil;
}
- (id)didSaveClick {
	
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"YardTypePick"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	id brige = [self.views objectForKey:kAYPickerView];
	[cmd_index performWithResult:&brige];
	
	NSDictionary *args = (NSDictionary*)brige;
	
	[self setNavRightBtnEnableStatus];
	return nil;
}

- (id)didCancelClick {
	//do nothing else ,but be have to invoke this methed
	return nil;
}
@end
