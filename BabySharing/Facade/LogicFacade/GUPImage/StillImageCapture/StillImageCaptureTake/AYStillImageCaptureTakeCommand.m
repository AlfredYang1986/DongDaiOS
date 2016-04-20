//
//  AYStillImageCaptureStartCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYStillImageCaptureTakeCommand.h"
#import "GPUImage.h"
#import "AYStillImageCaptureFacade.h"
#import "AYFactoryManager.h"
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"
#import "Tools.h"

@implementation AYStillImageCaptureTakeCommand
@synthesize para = _para;
- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {
    AYStillImageCaptureFacade* f = GPUSTILLIMAGECAPTURE;
    
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallStartFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
    
    dispatch_queue_t queue = dispatch_queue_create("capture pic", NULL);
    dispatch_async(queue, ^{
        [f.stillCamera capturePhotoAsImageProcessedUpToFilter:f.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            
            // TODO: save image to local sandbox
            UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES, (id)processedImage);
                
                SEL sel = NSSelectorFromString(kAYRemoteCallEndFuncName);
                Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
                if (m) {
                    id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
                    func(cur, sel, name);
                }
            });
        }];
    });
}

#pragma mark -- save image callback
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
    } else {
        NSLog(@"error occured while saving the picture%@", error);
    }
}
@end
