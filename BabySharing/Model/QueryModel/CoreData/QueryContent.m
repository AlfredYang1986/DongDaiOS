//
//  QueryContent.m
//  
//
//  Created by Alfred Yang on 6/08/2015.
//
//

#import "QueryContent.h"
#import "QueryComments.h"
#import "QueryContentItem.h"
#import "QueryContentTag.h"
#import "QueryLikes.h"
#import "QueryContentChaters.h"


@implementation QueryContent

@dynamic comment_count;
@dynamic comment_time_span;
@dynamic content_description;
@dynamic content_post_date;
@dynamic content_post_id;
@dynamic content_post_location;
@dynamic content_title;
@dynamic likes_count;
@dynamic likes_time_span;
@dynamic owner_id;
@dynamic owner_name;
@dynamic owner_photo;
@dynamic owner_role;
@dynamic relations;
@dynamic comments;
@dynamic items;
@dynamic likes;
@dynamic tags;
@dynamic chaters;
@dynamic isPush;
@dynamic isLike;
@dynamic group_chat_count;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@" %@ === %@", @"没有当前的key", key);
    return;
}


@end
