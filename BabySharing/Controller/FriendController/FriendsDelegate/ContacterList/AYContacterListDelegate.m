//
//  AYContacterListDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 14/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYContacterListDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYUserDisplayDefines.h"

#import <Contacts/CNContact.h>
#import <Contacts/CNContactStore.h>
#import <Contacts/CNContactFetchRequest.h>

@interface AYContacterListDelegate()
@property (nonatomic, weak, readonly, getter=getCurrentShowingData) NSArray* querydata;
@end

@implementation AYContacterListDelegate {
    
    NSArray* friends_data;
    NSArray* following_data;
    NSArray* followed_data;
    
    
    CNContactStore* tmpAddressBook;
    NSArray* people_all;
    NSMutableArray* people;
    
    NSArray* friend_profile_lst;
    NSArray* friend_lst;
    NSArray* none_friend_lst;
}

@synthesize querydata = _querydata;

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (id)init {
    self = [super init];
    if (self) {
        tmpAddressBook = [[CNContactStore alloc]init];
        people = [[NSMutableArray alloc]init];
    }
    
    if (tmpAddressBook) {
        CNContactFetchRequest* req = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]];
        req.predicate = nil;
        NSError* err = nil;
        if ([tmpAddressBook enumerateContactsWithFetchRequest:req error:&err usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            *stop = NO;
            [people addObject:contact];
        }]) {
            none_friend_lst = people;
            people_all = [people copy];
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[err.userInfo objectForKey:NSLocalizedDescriptionKey] message:[err.userInfo objectForKey:NSLocalizedFailureReasonErrorKey] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    return self;
}

- (NSArray*)getAllPhones2 {
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (CNContact* tmpPerson in people) {
        
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phones = tmpPerson.phoneNumbers;
        
        for (int index = 0; index < phones.count; ++index) {
            NSString* phoneNo = [phones objectAtIndex:index].value.stringValue;
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [arr addObject:phoneNo];
        }
    }
    return [arr copy];
}

- (id)getAllPhones {
    return [self getAllPhones2];
}

- (id)changeFriendsData:(id)obj {
    friends_data = (NSArray*)obj;
//    return nil;
//}
//- (void)splitWithFriends:(NSArray*)obj {
    NSPredicate* p = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        CNContact* tmpPerson = evaluatedObject;
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phones = tmpPerson.phoneNumbers; //ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        for (int index = 0; index < phones.count; ++index) {
            NSString* phoneNo = [phones objectAtIndex:index].value.stringValue; //CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, index));
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSPredicate* p_match = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                NSDictionary* iter = (NSDictionary*)evaluatedObject;
                return [[iter objectForKey:@"phoneNo"] isEqualToString:phoneNo];
            }];
            
            if ([obj filteredArrayUsingPredicate:p_match].count > 0) return YES;
        }
        return NO;
    }];
    
    friend_lst = [people filteredArrayUsingPredicate:p];
    friend_profile_lst = obj;
    
    NSPredicate* p_not = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        CNContact* tmpPerson = evaluatedObject;
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phones = tmpPerson.phoneNumbers; //ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        for (int index = 0; index < phones.count; ++index) {
            NSString* phoneNo = [phones objectAtIndex:index].value.stringValue; //CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, index));
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSPredicate* p_match = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                NSDictionary* iter = (NSDictionary*)evaluatedObject;
                return [[iter objectForKey:@"phoneNo"] isEqualToString:phoneNo];
            }];
            
            if ([obj filteredArrayUsingPredicate:p_match].count == 0) return YES;
        }
        return NO;
    }];
    
    none_friend_lst = [people filteredArrayUsingPredicate:p_not];
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.querydata count] + none_friend_lst.count ;
    return [self.querydata count] + none_friend_lst.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserDisplayTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
//    [(UIView*)cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (cell == nil) {
        cell = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
        
    }
    
    BOOL isFriends = NO;
    CNContact* tmpPerson = nil;
    @try {
        tmpPerson = [friend_lst objectAtIndex:indexPath.row];
        isFriends = YES;
    }
    @catch (NSException *exception) {
        tmpPerson = [none_friend_lst objectAtIndex:indexPath.row - friend_lst.count];
    }
    @finally {
        
    }
    id<AYCommand> cmd = [cell.commands objectForKey:@"setDisplayUserInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (isFriends) {
        
        NSDictionary* tmp = [self.querydata objectAtIndex:indexPath.row];
        {
            
            [dic setValue:[tmp objectForKey:@"user_id"] forKey:kAYUserDisplayTableCellSetUserIDKey];
            [dic setValue:[tmp objectForKey:@"screen_photo"] forKey:kAYUserDisplayTableCellSetUserScreenPhotoKey];
            [dic setValue:[tmp objectForKey:@"relations"] forKey:kAYUserDisplayTableCellSetUserRelationsKey];
            [dic setValue:[tmp objectForKey:@"screen_name"] forKey:kAYUserDisplayTableCellSetUserScreenNameKey];
            [dic setValue:[tmp objectForKey:@"role_tag"] forKey:kAYUserDisplayTableCellSetUserRoleTagKey];
            [dic setValue:cell forKey:kAYUserDisplayTableCellKey];
        }
    }else
    {
        NSString* tmpFirstName = tmpPerson.givenName;
        NSString* tmpLastName = tmpPerson.familyName;
        if (tmpLastName && tmpFirstName) {
            [dic setValue:[tmpLastName stringByAppendingString:tmpFirstName] forKey:kAYUserDisplayTableCellSetUserScreenNameKey];
        } else if (tmpFirstName) {
            [dic setValue:tmpFirstName forKey:kAYUserDisplayTableCellSetUserScreenNameKey];
        } else if (tmpLastName) {
            [dic setValue:tmpLastName forKey:kAYUserDisplayTableCellSetUserScreenNameKey];
        }
        [dic setValue:@"" forKey:kAYUserDisplayTableCellSetUserScreenPhotoKey];
        [dic setValue:[NSNumber numberWithInt:-1] forKey:kAYUserDisplayTableCellSetUserRelationsKey];
        [dic setValue:@"" forKey:kAYUserDisplayTableCellSetUserRoleTagKey];
        [dic setValue:cell forKey:kAYUserDisplayTableCellKey];
    }
    [cmd performWithResult:&dic];
    
    return (UITableViewCell*)cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"短信邀请" message:@"免费发送短信给联系人？" delegate:nil cancelButtonTitle:@"放弃" otherButtonTitles:@"邀请", nil];
    view.delegate = self;
    view.tag = indexPath.row;
    [view show];
}
#pragma mark -- alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"Send SMS....");
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
    id<AYCommand> cmd = [cell.commands objectForKey:@"queryCellHeight"];
    NSNumber* result = nil;
    [cmd performWithResult:&result];
    return result.floatValue;
}

#pragma mark -- message commands
//- (id)isFriendsDataReady {
//    return [NSNumber numberWithBool:friends_data != nil];
//}
//
//- (id)isFollowingDataReady {
//    return [NSNumber numberWithBool:following_data != nil];
//}
//
//- (id)isFollowedDataReady {
//    return [NSNumber numberWithBool:followed_data != nil];
//}

//- (id)changeFriendsData:(id)obj {
//    friends_data = (NSArray*)obj;
//    return nil;
//}

//- (id)changeFollowingData:(id)obj {
//    following_data = (NSArray*)obj;
//    return nil;
//}
//
//- (id)changeFollowedData:(id)obj {
//    followed_data = (NSArray*)obj;
//    return nil;
//}

- (NSArray*)getCurrentShowingData {
    return friends_data;
}

@end
