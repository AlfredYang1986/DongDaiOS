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

#import "Tools.h"
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"

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
        [self beforeAsyncCall];
        [RemoteInstance uploadPicture:[args objectForKey:@"upload_image"] withName:photo toUrl:[NSURL URLWithString:self.route] callBack:^(BOOL successs, NSString *message) {
            [self endAsyncCall];
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

- (void)beforeAsyncCall {
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallStartFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
}

- (void)endAsyncCall {
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallEndFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
}
@end
