//
//  AYOSSGetCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYOSSGetCommand.h"

@implementation AYOSSGetCommand

//
//- (void)performWithResult:(NSObject *__autoreleasing *)obj {
//	
//	__block UIImage *img;
//	OSSGetObjectRequest * request = [OSSGetObjectRequest new];
//	// 必填字段
//	request.bucketName = @"<bucketName>";
//	request.objectKey = @"<objectKey>";
//	// 可选字段
//	request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//		// 当前下载段长度、当前已经下载总长度、一共需要下载的总长度
//		NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//	};
//	// request.range = [[OSSRange alloc] initWithStart:0 withEnd:99]; // bytes=0-99，指定范围下载
//	// request.downloadToFileURL = [NSURL fileURLWithPath:@"<filepath>"]; // 如果需要直接下载到文件，需要指明目标文件地址
//	
//	AYAliyunOSSFacade *ossFacade = DEFAULTFACADE(@"ProfileRemote");
//	OSSTask * getTask = [ossFacade.client getObject:request];
//	[getTask continueWithBlock:^id(OSSTask *task) {
//		if (!task.error) {
//			NSLog(@"download object success!");
//			OSSGetObjectResult * getResult = task.result;
//			NSLog(@"download result: %@", getResult.downloadedData);
//			img = [UIImage imageWithData:getResult.downloadedData];
//		} else {
//			NSLog(@"download object failed, error: %@" ,task.error);
//		}
//		return nil;
//	}];
//	
//	[getTask waitUntilFinished];
//	
//	*obj = img;
//}

@end
