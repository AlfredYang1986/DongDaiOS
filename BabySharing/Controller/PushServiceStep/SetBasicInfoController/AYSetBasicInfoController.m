//
//  AYSetBasicInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetBasicInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"


#define kMaxImagesCount             9

@implementation AYSetBasicInfoController {
	
	NSMutableDictionary *service_info;
	
	NSMutableArray *selectImageArr;
	NSMutableDictionary *tmp_service_info;
	
	BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"Basic Servcie" andTextColor:[Tools blackColor] andFontSize:622.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetBasicInfo"];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
	NSArray *class_name_arr = @[@"AYSetServiceImagesCellView", @"AYSetServiceDescCellView", @"AYSetServiceCharactCellView"];
	for (NSString *class_name in class_name_arr) {
		id t = [class_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &t)
	}
	
	tmp_service_info = [[NSMutableDictionary alloc] init];
	selectImageArr = [NSMutableArray array];
	[tmp_service_info setValue:selectImageArr forKey:kAYServiceArgsImages];
	[tmp_service_info setValue:class_name_arr forKey:kAYDefineArgsCellNames];
	
	id tmp = [tmp_service_info copy];
	kAYDelegatesSendMessage(@"SetBasicInfo", kAYDelegateChangeDataMessage, &tmp);
	
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
	
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"下一步" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT - 130);
	return nil;
}
#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
	TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount - 1 delegate:self];
	
	//四类个性化设置，这些参数都可以不传，此时会走默认设置
	imagePickerVc.isSelectOriginalPhoto = NO/*_isSelectOriginalPhoto*/;
	
	// 1.如果你需要将拍照按钮放在外面，不要传这个参数
	//    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
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
	
//	[selectedPhotos addObjectsFromArray:photos];
//	
//	_isSelectOriginalPhoto = isSelectOriginalPhoto;
//	_layout.itemCount = selectedPhotos.count;
//	[_collectionView reloadData];
//	
//	[self setNavRightBtnEnableStatus];
	
}

#pragma mark -- actions
- (void)setNavRightBtnEnableStatus {
//	if (selectedPhotos.count == 0 || !selectedPhotos) {
//		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
//		bar_right_btn.userInteractionEnabled = NO;
//		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//	} else {
//		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
//		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//	}
}

- (void)didCourseSignLabelTap {
	
	//    if (((NSNumber*)[titleAndCourseSignInfo objectForKey:kAYServiceArgsCatSecondary]).intValue == -1) {
	//        kAYUIAlertView(@"提示", @"您需要重新设置服务主题，才能进行服务标签设置");
	//        return;
	//    }
	//
	//    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetCourseSign");
	//
	//    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	//    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	//    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	//    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	//
	//    [dic_push setValue:titleAndCourseSignInfo forKey:kAYControllerChangeArgsKey];
	//
	//    id<AYCommand> cmd = PUSH;
	//    [cmd performWithResult:&dic_push];
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
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"PushServiceMain");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
	return nil;
}

- (id)didCharactViewTap:(id)charact {
	
	return nil;
}

- (id)deletedImageWithIndex:(id)args {
	
	return nil;
}
- (id)beginImagePicker {
	[self pushImagePickerController];
	return nil;
}
@end
