//
//  AYPostPhotoPublishController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostPhotoPublishController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

@implementation AYPostPhotoPublishController {
    UIImage* post_image;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        post_image = [dic objectForKey:kAYControllerChangeArgsKey];
    } 
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainContentView.image = post_image;
}

#pragma mark -- actions
- (NSString*)getNavTitle {
    return @"图片说明";
}
@end
