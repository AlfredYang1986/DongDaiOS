//
//  AYUploaduserImageCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUploadUserImageCommand.h"
#import "TmpFileStorageModel.h"
#import "RemoteInstance.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"

@implementation AYUploadUserImageCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"upload user image to server: %@", args);

    NSString* photo = [args objectForKey:@"image"];
//    UIImage *image = [args objectForKey:@"upload_image"];
    
//    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//    [cmd performWithResult:args andFinishBlack:^(BOOL success, NSDictionary * result) {
//        UIImage* img = (UIImage*)result;
//        NSLog(@"%d",img? 1:0);
//        if (img != nil) {
//            [RemoteInstance uploadPicture:img withName:photo toUrl:[NSURL URLWithString:self.route] callBack:^(BOOL successs, NSString *message) {
//                if (successs) {
//                    NSLog(@"post image success");
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        block(YES, nil);
//                    });
//                    
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        block(NO, nil);
//                    });
//                }
//            }];
//        }
//    }];
    dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
    dispatch_async(post_queue, ^(void){
//        UIImage* img = [TmpFileStorageModel enumImageWithName:args withDownLoadFinishBolck:nil];

        [RemoteInstance uploadPicture:[args objectForKey:@"upload_image"] withName:photo toUrl:[NSURL URLWithString:self.route] callBack:^(BOOL successs, NSString *message) {
            if (successs) {
                NSLog(@"post image success");
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES, nil);
                });
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO, nil);
                });
            }
        }];
    });
}
@end
