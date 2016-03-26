//
//  AYLoginModelFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginModelFacade.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

static NSString* const LOCALDB_LOGIN = @"loginData.sqlite";

@interface AYLoginModelFacade ()
@property (strong, nonatomic) UIManagedDocument* doc;
@end

@implementation AYLoginModelFacade

@synthesize doc = _doc;

- (void)postPerform {
    [super postPerform];
    
    /**
     * get authorised user array in the local database
     */
    NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_LOGIN]];
    _doc = (UIManagedDocument*)[[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:NO]) {
        [_doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            [self enumDataFromLocalDB:_doc];
        }];
    } else if (_doc.documentState == UIDocumentStateClosed) {
        [_doc openWithCompletionHandler:^(BOOL success){
            [self enumDataFromLocalDB:_doc];
        }];
    } else {
        
    }
}

- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
    dispatch_queue_t aq = dispatch_queue_create("load_data", NULL);
    dispatch_async(aq, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [document.managedObjectContext performBlock: ^(void){
//                authorised_users = [LoginToken enumAllLoginUsersWithContext:_doc.managedObjectContext];
//                _current_user = [self getCurrentUser];
                
                // TODO: send notifycation
            }];
        });
    });
}

@end
