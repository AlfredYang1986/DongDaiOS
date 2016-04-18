//
//  AYEnumAllPhotoWithAlbumCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEnumAllPhotoWithAlbumCommand.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"
#import "Tools.h"

@implementation AYEnumAllPhotoWithAlbumCommand
- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    // 缩略图和PHAsset
    PHFetchResult* fetchResult = [args objectForKey:@"fetch"];
    
    if (fetchResult.count == 0) {
        return;
    }
    
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallStartFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
    
    dispatch_queue_t queue = dispatch_queue_create("getThumbnailImage", nil);
    //    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    NSMutableArray<UIImage *> *imageArr = [NSMutableArray array];
    NSMutableArray<PHAsset *> *assetArr = [NSMutableArray array];
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width / 3);
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    //     client may get several image results when the call is asynchronous or will get one result when the call is synchronous
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.synchronous = YES;
    dispatch_async(queue, ^{
        PHAsset *asset;
        for (int i = 0; i < fetchResult.count; i++) {
            asset = [fetchResult objectAtIndex:i];
            [assetArr addObject:asset];
            [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
                if (result) {
                    [imageArr addObject:result];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:imageArr forKey:@"images"];
            [dic setValue:assetArr forKey:@"assets"];
            block(YES, [dic copy]);
            
            SEL sel = NSSelectorFromString(kAYRemoteCallEndFuncName);
            Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
            if (m) {
                id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
                func(cur, sel, name);
            }
        });
    });
}
@end
