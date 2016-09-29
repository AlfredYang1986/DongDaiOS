//
//  LoginToken+CoreDataProperties.h
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "LoginToken+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LoginToken (CoreDataProperties)

+ (NSFetchRequest<LoginToken *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *auth_token;
@property (nullable, nonatomic, copy) NSString *contact_no;
@property (nullable, nonatomic, copy) NSNumber *date;
@property (nullable, nonatomic, copy) NSNumber *is_real_name_cert;
@property (nullable, nonatomic, copy) NSNumber *is_service_provider;
@property (nullable, nonatomic, copy) NSString *personal_description;
@property (nullable, nonatomic, copy) NSString *phoneNo;
@property (nullable, nonatomic, copy) NSString *role_tag;
@property (nullable, nonatomic, copy) NSString *screen_image;
@property (nullable, nonatomic, copy) NSString *screen_name;
@property (nullable, nonatomic, copy) NSString *user_id;
@property (nullable, nonatomic, copy) NSNumber *has_phone;
@property (nullable, nonatomic, retain) NSSet<Providers *> *connectWith;
@property (nullable, nonatomic, retain) DetailInfo *detailInfo;
@property (nullable, nonatomic, retain) CurrentToken *logined;
@property (nullable, nonatomic, retain) RegCurrentToken *reglogined;

@end

@interface LoginToken (CoreDataGeneratedAccessors)

- (void)addConnectWithObject:(Providers *)value;
- (void)removeConnectWithObject:(Providers *)value;
- (void)addConnectWith:(NSSet<Providers *> *)values;
- (void)removeConnectWith:(NSSet<Providers *> *)values;

@end

NS_ASSUME_NONNULL_END
