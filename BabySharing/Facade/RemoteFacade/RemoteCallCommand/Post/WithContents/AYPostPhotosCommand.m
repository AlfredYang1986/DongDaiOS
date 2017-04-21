//
//  AYPostPhotosCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/21/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostPhotosCommand.h"
#import <UIKit/UIKit.h>
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYQueryModelDefines.h"

#import "TmpFileStorageModel.h"

@implementation AYPostPhotosCommand

- (void)performWithResult:(id)args andFinishBlack:(asynCommandFinishBlock)block {
   
    /**
     * 0. 得到需要上传的照片数量, 并初始化数据
     */
	NSArray* images = args;
	
    NSMutableArray* semaphores_upload_photos = [[NSMutableArray alloc]init];   // 每一个图片是一个上传线程，需要一个semaphores等待上传完成
	NSMutableArray* post_image_result = [[NSMutableArray alloc]init];           // 记录每一个图片在线中上传的结果
	
    for (int index = 0; index < images.count; ++index) {
        dispatch_semaphore_t tmp = dispatch_semaphore_create(0);
        [semaphores_upload_photos addObject:tmp];
		[post_image_result addObject:[NSNumber numberWithBool:NO]];
    }
	
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);              // 用户上传数据库信息
	
//    __block BOOL post_data_result = NO;                                         // 记录上传用户数据线程的结果
//    __block NSDictionary* server_reture_data = nil;                             // 服务器返回的数据
	
    /**
     * 1. 主线程 调用loading 阻塞用户消息
     */
//    [self beforeAsyncCall];
//
//    // 子线程1: 等待所有线程执行完毕, 最近进行主线程返回
//    dispatch_queue_t qw = dispatch_queue_create("wait thread", nil);
//    dispatch_async(qw, ^{
//		
//        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 2.1 最后一步，回到主线程，说明执行完了
//            NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
//            NSArray* image_result = [post_image_result filteredArrayUsingPredicate:p];
//            [self endAsyncCall];
//            block((image_result.count == 0 && post_data_result), server_reture_data);
//        });
//    });
	
    // 5. 组合上传内容
    dispatch_queue_t qp = dispatch_queue_create("post thread", nil);
    dispatch_async(qp, ^{
		
//        NSDictionary* user = nil;
//        CURRENUSER(user);
//        NSMutableDictionary* post_args = [user mutableCopy];
//        [post_args setValue:[args objectForKey:@"description"] forKey:@"description"];
//        [post_args setValue:[args objectForKey:@"tags"] forKey:@"tags"];
		
        NSMutableArray* arr_items = [[NSMutableArray alloc]init];
		
        for (int index = 0; index < images.count; ++index) {
            UIImage* iter = [images objectAtIndex:index];
//            NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:iter];
			NSString* extent = [TmpFileStorageModel generateFileName];
        
            // 3. 启动异步线程对图片进行上传
			NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
			[photo_dic setValue:extent forKey:@"image"];
			[photo_dic setValue:iter forKey:@"upload_image"];
			
			AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
			[up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
				NSLog(@"upload result are %d", success);
				[post_image_result replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:success]];
				dispatch_semaphore_signal([semaphores_upload_photos objectAtIndex:index]);
			}];
			
//            NSMutableDictionary* dic_tmp = [[NSMutableDictionary alloc]init];
//            [dic_tmp setObject:[NSNumber numberWithInteger:ModelAttchmentTypeImage] forKey:@"type"];
//            [dic_tmp setObject:extent forKey:@"name"];
            [arr_items addObject:extent];
        } //for end
//        [post_args setObject:arr_items forKey:@"items"];

        // 4. 等待图片进程全部处理完成
        for (dispatch_semaphore_t iter in semaphores_upload_photos) {
            dispatch_semaphore_wait(iter, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        }
        
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
		NSArray* image_result = [post_image_result filteredArrayUsingPredicate:p];
		dispatch_async(dispatch_get_main_queue(), ^{
			// 2.1 最后一步，回到主线程，说明执行完了
			
			if (image_result.count == 0) {
				//            AYRemoteCallCommand* cmd = COMMAND(@"Remote", @"PostContent");
				//            [cmd performWithResult:[post_args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
				//                post_data_result = success;
				//                server_reture_data = result;
				//                dispatch_semaphore_signal(semaphore);
				//			}];
				block(YES, [arr_items copy]);
			} else {
				//            post_data_result = NO;
				//            server_reture_data = @{@"error":@"post image error"};
				//            dispatch_semaphore_signal(semaphore);
				block(NO, nil);
			}
		});
    });
}
@end
