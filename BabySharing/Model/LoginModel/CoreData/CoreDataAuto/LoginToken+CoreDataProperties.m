//
//  LoginToken+CoreDataProperties.m
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "LoginToken+CoreDataProperties.h"

@implementation LoginToken (CoreDataProperties)

+ (NSFetchRequest<LoginToken *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LoginToken"];
}

@dynamic address;
@dynamic auth_token;
@dynamic phoneNo;
@dynamic role_tag;
@dynamic screen_image;
@dynamic screen_name;
@dynamic user_id;
@dynamic date;
@dynamic personal_description;
@dynamic is_real_name_cert;
@dynamic contact_no;
@dynamic is_service_provider;
@dynamic connectWith;
@dynamic detailInfo;
@dynamic logined;
@dynamic reglogined;

@end
