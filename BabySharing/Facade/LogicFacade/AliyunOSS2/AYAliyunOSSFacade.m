//
//  AYAliyunOSSFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYAliyunOSSFacade.h"


@implementation AYAliyunOSSFacade {
	NSString *stsID;
	NSString *stsSecretKey;
	NSString *stsToken;
}

@synthesize para = _para;

#pragma mark -- commands
- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeDefaultFacade;
}

- (void)postPerform {
	
}
//- (OSSClient *)OSSClient {
//
//	return self.client;
//}

- (OSSClient*)client {
	
	dispatch_sync(dispatch_get_global_queue(0, 0), ^{
		
		__block BOOL isWaiting = YES;
		if (!_client) {
			NSDictionary *user;
			CURRENUSER(user);
			NSDictionary *oss_dic = @{kAYCommArgsToken:[user objectForKey:kAYCommArgsToken]};
			id<AYFacadeBase> oss_f = DEFAULTFACADE(@"OSSSTSRemote");
			AYRemoteCallCommand* oss_cmd = [oss_f.commands objectForKey:@"OSSSTSQuery"];
			[oss_cmd performWithResult:[oss_dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
				if (success) {
					NSDictionary *OssConnectInfo = [result objectForKey:@"OssConnectInfo"];
					
					stsID = [OssConnectInfo objectForKey:@"accessKeyId"];
					stsSecretKey = [OssConnectInfo objectForKey:@"accessKeySecret"];
					stsToken = [OssConnectInfo objectForKey:@"SecurityToken"];
					
					id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsID secretKeyId:stsSecretKey securityToken:stsToken];
					_client = [[OSSClient alloc] initWithEndpoint:AYOSSEndPoint credentialProvider:credential];
					
					NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
					[defUser setValue:[NSNumber numberWithDouble:([NSDate date].timeIntervalSince1970)] forKey:kAYDongDaOSSSTSTokenAuth];
					[defUser synchronize];
				}
				isWaiting = NO;
			}];
			
		} else {
			NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
			NSTimeInterval note = [[defUser objectForKey:kAYDongDaOSSSTSTokenAuth] doubleValue];
			NSTimeInterval now = [NSDate date].timeIntervalSince1970;
			if (note+3600 <= now) {
				NSDictionary *user;
				CURRENUSER(user);
				NSDictionary *oss_dic = @{kAYCommArgsToken:[user objectForKey:kAYCommArgsToken]};
				id<AYFacadeBase> oss_f = DEFAULTFACADE(@"OSSSTSRemote");
				AYRemoteCallCommand* oss_cmd = [oss_f.commands objectForKey:@"OSSSTSQuery"];
				[oss_cmd performWithResult:[oss_dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
					if (success) {
						NSDictionary *OssConnectInfo = [result objectForKey:@"OssConnectInfo"];
						
						stsID = [OssConnectInfo objectForKey:@"accessKeyId"];
						stsSecretKey = [OssConnectInfo objectForKey:@"accessKeySecret"];
						stsToken = [OssConnectInfo objectForKey:@"SecurityToken"];
						
						id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsID secretKeyId:stsSecretKey securityToken:stsToken];
						_client = [[OSSClient alloc] initWithEndpoint:AYOSSEndPoint credentialProvider:credential];
						
						NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
						[defUser setValue:[NSNumber numberWithDouble:([NSDate date].timeIntervalSince1970)] forKey:kAYDongDaOSSSTSTokenAuth];
						[defUser synchronize];
					}
					isWaiting = NO;
				}];
			} else {
				isWaiting = NO;
			}
		}
		
		while (isWaiting) {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		}
		
//		dispatch_semaphore_t semap = dispatch_semaphore_create(1);
//		dispatch_semaphore_wait(semap, dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC));
//		dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//
//		});
	});
	
	return _client;
}

- (OSSClient*)client2 {
	
	@synchronized(self) {
		if (!_client) {
			dispatch_semaphore_t semap = dispatch_semaphore_create(0);
			
			NSDictionary *user;
			CURRENUSER(user);
			
			
			NSDictionary *oss_dic = @{kAYCommArgsToken:[user objectForKey:kAYCommArgsToken]};
			id<AYFacadeBase> oss_f = DEFAULTFACADE(@"OSSSTSRemote");
			AYRemoteCallCommand* oss_cmd = [oss_f.commands objectForKey:@"OSSSTSQuery"];
			[oss_cmd performWithResult:[oss_dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
				NSLog(@"michauxs:%@", result);
				if (success) {
					NSDictionary *OssConnectInfo = [result objectForKey:@"OssConnectInfo"];
					
					stsID = [OssConnectInfo objectForKey:@"accessKeyId"];
					stsSecretKey = [OssConnectInfo objectForKey:@"accessKeySecret"];
					stsToken = [OssConnectInfo objectForKey:@"SecurityToken"];
					
					id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsID secretKeyId:stsSecretKey securityToken:stsToken];
					_client = [[OSSClient alloc] initWithEndpoint:AYOSSEndPoint credentialProvider:credential];
					
					NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
					[defUser setValue:[NSNumber numberWithDouble:([NSDate date].timeIntervalSince1970)] forKey:kAYDongDaOSSSTSTokenAuth];
					[defUser synchronize];
					
					dispatch_semaphore_signal(semap);
				}
			}];
			dispatch_semaphore_wait(semap, dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC));
			
		} else {
			
			NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
			NSTimeInterval note = [[defUser objectForKey:kAYDongDaOSSSTSTokenAuth] doubleValue];
			NSTimeInterval now = [NSDate date].timeIntervalSince1970;
			if (note+3600 <= now) {
				dispatch_semaphore_t semap = dispatch_semaphore_create(0);
				
				NSDictionary *user;
				CURRENUSER(user);
				
				NSDictionary *oss_dic = @{kAYCommArgsToken:[user objectForKey:kAYCommArgsToken]};
				id<AYFacadeBase> oss_f = DEFAULTFACADE(@"OSSSTSRemote");
				AYRemoteCallCommand* oss_cmd = [oss_f.commands objectForKey:@"OSSSTSQuery"];
				[oss_cmd performWithResult:[oss_dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
					NSLog(@"michauxs:%@", result);
					if (success) {
						
						stsID = [result objectForKey:@"accessKeyId"];
						stsSecretKey = [result objectForKey:@"accessKeySecret"];
						stsToken = [result objectForKey:@"SecurityToken"];
						
						id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsID secretKeyId:stsSecretKey securityToken:stsToken];
						_client = [[OSSClient alloc] initWithEndpoint:AYOSSEndPoint credentialProvider:credential];
						
						NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
						[defUser setValue:[NSNumber numberWithDouble:([NSDate date].timeIntervalSince1970)] forKey:kAYDongDaOSSSTSTokenAuth];
						[defUser synchronize];
						
						dispatch_semaphore_signal(semap);
					}
					
				}];
				dispatch_semaphore_wait(semap, dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC));
				
			}
		}
		
	}
	
	
	return _client;
}


- (OSSClient*)getClient {
	
	NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
	NSTimeInterval note = [[defUser objectForKey:kAYDongDaOSSSTSTokenAuth] doubleValue];
	NSTimeInterval now = [NSDate date].timeIntervalSince1970;
	if (note+3600 <= now) {
		
		dispatch_semaphore_t semap = dispatch_semaphore_create(0);
		dispatch_async(dispatch_queue_create("quert token thread", nil), ^{
			NSDictionary *user;
			CURRENUSER(user);
			
			NSDictionary *oss_dic = @{kAYCommArgsToken:[user objectForKey:kAYCommArgsToken]};
			id<AYFacadeBase> oss_f = DEFAULTFACADE(@"OSSSTSRemote");
			AYRemoteCallCommand* oss_cmd = [oss_f.commands objectForKey:@"OSSSTSQuery"];
			[oss_cmd performWithResult:[oss_dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
				NSLog(@"michauxs:%@", result);
				
				stsID = [result objectForKey:@"accessKeyId"];
				stsSecretKey = [result objectForKey:@"accessKeySecret"];
				stsToken = [result objectForKey:@"SecurityToken"];
				
				id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:stsID secretKeyId:stsSecretKey securityToken:stsToken];
				_client = [[OSSClient alloc] initWithEndpoint:AYOSSEndPoint credentialProvider:credential];
				
				NSUserDefaults *defUser = [NSUserDefaults standardUserDefaults];
				[defUser setValue:[NSNumber numberWithDouble:([NSDate date].timeIntervalSince1970)] forKey:kAYDongDaOSSSTSTokenAuth];
				[defUser synchronize];
				
				dispatch_semaphore_signal(semap);
				
			}];
			dispatch_semaphore_wait(semap, dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC));
		});
	}
	
	
	return _client;
}

@end
