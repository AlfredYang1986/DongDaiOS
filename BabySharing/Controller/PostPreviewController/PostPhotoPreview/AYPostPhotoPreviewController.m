//
//  AYPostPhotoPreviewController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostPhotoPreviewController.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

@interface AYPostPhotoPreviewController ()
@end

@implementation AYPostPhotoPreviewController {
    UIImage* origin_image;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    [super performWithResult:obj];
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        origin_image = (UIImage*)[dic objectForKey:kAYControllerChangeArgsKey];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainContentView.image = origin_image;
    
    id<AYViewBase> view_filter = [self.views objectForKey:@"FilterPreview"];
    id<AYCommand> cmd_source = [view_filter.commands objectForKey:@"setOriginImage:"];
    id args = origin_image;
    [cmd_source performWithResult:&args];
}


- (NSString*)getNavTitle {
    return @"编辑图片";
}

- (NSArray*)getFunctionBarItems {
    return @[@"标签", @"滤镜"];
}

#pragma mark -- notifications
- (id)didSelectedFilterPhoto:(id)obj {
    UIImage* img = (UIImage*)obj;
    self.mainContentView.image = img;
    return nil;
}

- (id)rightBtnSelected {
    UIImage* img = self.mainContentView.image;
   
    AYViewController* des = DEFAULTCONTROLLER(@"PostPhotoPublish");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:img forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}
@end
