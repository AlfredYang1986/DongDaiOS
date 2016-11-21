//
//  AYQueryScreenNameAndPhotoCommand.m
//  BabySharing
//
//  Created by BM on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryScreenNameAndPhotoCommand.h"
#import "AYScreenNameAndPhotoCacheFacade.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"

@implementation AYQueryScreenNameAndPhotoCommand

- (void)beforeAsyncCall {
    
}

- (void)endAsyncCall {
    
}

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {
  
    NSString* user_id = [args objectForKey:@"user_id"];
    
    AYScreenNameAndPhotoCacheFacade* f = USERCACHE;
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.user_id=%@", user_id];
    
    NSArray* arr = [f.head_lst filteredArrayUsingPredicate:p];
    if (arr.count > 1) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"cache error with primary key" userInfo:nil];
    } else if (arr.count == 1) {
        block(YES, arr.lastObject);
    } else {
        id<AYFacadeBase> f_profile = DEFAULTFACADE(@"ProfileRemote");
        AYRemoteCallCommand* cmd = [f_profile.commands objectForKey:@"QueryUserProfile"];
        
        NSDictionary* user = nil;
        CURRENUSER(user);
        
        NSMutableDictionary* dic = [user mutableCopy];
        [dic setValue:user_id forKey:@"owner_user_id"];
        
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
                NSMutableDictionary* reVal = [[NSMutableDictionary alloc]init];
                [reVal setValue:user_id forKey:@"user_id"];
                [reVal setValue:[result objectForKey:@"screen_name"] forKey:@"screen_name"];
                [reVal setValue:[result objectForKey:@"screen_photo"] forKey:@"screen_photo"];
                
                id<AYCommand> cmd_push = [f.commands objectForKey:@"PushScreenNameAndPhoto"];
                id arg_push = [reVal copy];
                [cmd_push performWithResult:&arg_push];
                
                block(YES, [reVal copy]);
            } else {
                block(NO, nil);
            }
        }];
    }
}
@end
