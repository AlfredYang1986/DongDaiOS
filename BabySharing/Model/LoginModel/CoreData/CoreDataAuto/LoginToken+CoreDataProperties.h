//
//  LoginToken+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 3/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LoginToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginToken (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *auth_token;
@property (nullable, nonatomic, retain) NSString *phoneNo;
@property (nullable, nonatomic, retain) NSString *role_tag;
@property (nullable, nonatomic, retain) NSString *screen_image;
@property (nullable, nonatomic, retain) NSString *screen_name;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *address;
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
