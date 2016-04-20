//
//  AYPostMoviePreviewController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostMoviePreviewController.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"

@implementation AYPostMoviePreviewController {
    NSURL* movie_url;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        movie_url = (NSURL*)[dic objectForKey:kAYControllerChangeArgsKey];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mainViewHandleTap:)];
    //    [_mainContentView addGestureRecognizer:tap];
    
//    id<AYViewBase> view_filter = [self.views objectForKey:@"FilterPreview"];
//    id<AYCommand> cmd_source = [view_filter.commands objectForKey:@"setOriginImage:"];
//    id args = origin_image;
//    [cmd_source performWithResult:&args];
}

- (NSString*)getNavTitle {
    return @"编辑视频";
}

- (NSArray*)getFunctionBarItems {
    return @[@"封面", @"滤镜"];
}

#pragma mark -- notifications
- (id)didSelectedFilter:(id)obj {
//    UIImage* img = (UIImage*)obj;
//    self.mainContentView.image = img;
    return nil;
}
@end
