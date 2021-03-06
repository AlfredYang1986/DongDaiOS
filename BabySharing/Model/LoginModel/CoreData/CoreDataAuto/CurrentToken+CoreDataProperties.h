//
//  CurrentToken+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CurrentToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentToken (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *last_login_data;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) LoginToken *who;

@end

NS_ASSUME_NONNULL_END
