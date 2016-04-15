//
//  AYHomeQueryModelFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYHomeQueryModelFacade.h"

static NSString* const LOCALDB_HOME_QUERY = @"queryData.sqlite";

@implementation AYHomeQueryModelFacade

@synthesize doc = _doc;
@synthesize querydata = _querydata;

- (void)postPerform {
    [super postPerform];
    
    /**
     * get authorised user array in the local database
     */
    if (_doc == nil) {
        NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_HOME_QUERY]];
        _doc = (UIManagedDocument*)[[UIManagedDocument alloc] initWithFileURL:url];
        
        BOOL isDir = NO;
        if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:&isDir]) {
            [_doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                [self enumDataFromLocalDB:_doc];
            }];
        } else if (_doc.documentState == UIDocumentStateClosed) {
            [_doc openWithCompletionHandler:^(BOOL success){
                [self enumDataFromLocalDB:_doc];
            }];
        } else if (_doc.documentState == UIDocumentStateInConflict) {
            [_doc saveToURL:url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
                [self enumDataFromLocalDB:_doc];
            }];
        } else {
            
        }
    }
}

#pragma mark -- instuction
- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
    //    dispatch_queue_t aq = dispatch_queue_create("load_query_data", NULL);
    //
    //    dispatch_async(aq, ^(void){
    //        dispatch_async(dispatch_get_main_queue(), ^(void){
    //            [document.managedObjectContext performBlock:^(void){
    //                _querydata =  [QueryContent enumLocalQueyDataInContext:document.managedObjectContext];
    //                if (_querydata == nil || _querydata.count == 0) {
    //                    [self refreshQueryDataByUser:self.delegate.lm.current_user_id withToken:self.delegate.lm.current_auth_token];
    //                }
    //                [[NSNotificationCenter defaultCenter]postNotificationName:@"query data ready" object:nil];
    //            }];
    //        });
    //    });
}
@end