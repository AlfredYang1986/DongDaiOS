//
//  AYAliyunOSSFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 28/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYAliyunOSSFacade.h"


@implementation AYAliyunOSSFacade

@synthesize para = _para;

#pragma mark -- commands
- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeDefaultFacade;
}

- (void)postPerform {
	
	id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AYOSSSTSId secretKeyId:AYOSSSTSSecretKey securityToken:AYOSSSTSSecurityToken];
	
	self.client = [[OSSClient alloc] initWithEndpoint:AYOSSEndPoint credentialProvider:credential];
}

@end
