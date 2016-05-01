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
#import "AYRemoteCallCommand.h"

@implementation AYPostPhotoPublishController {
    UIImage* post_image;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        post_image = [dic objectForKey:kAYControllerChangeArgsKey];
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        post_image = [args objectForKey:@"image"];
        self.tags = [args objectForKey:@"tags"];
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

- (void)didSelectPostBtn {
    // TODO: tags ...
    
    NSArray* images = @[post_image];
    NSMutableDictionary* post_args = [[NSMutableDictionary alloc]init];
    [post_args setValue:images forKey:@"images"];
    [post_args setValue:self.tags forKey:@"tags"];
    
    id<AYViewBase> view_des = [self.views objectForKey:@"PublishContainer"];
    id<AYCommand> cmd_des = [view_des.commands objectForKey:@"queryUserDescription"];
    id description = nil;
    [cmd_des performWithResult:&description];
    [post_args setValue:description forKey:@"description"];
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"PostRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"PostPhotos"];
   
    [cmd performWithResult:[post_args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        [[[UIAlertView alloc]initWithTitle:@"success" message:@"post content success" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        id<AYCommand> cmd = REVERSMODULE;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [cmd performWithResult:&dic];
    }];
}
@end
