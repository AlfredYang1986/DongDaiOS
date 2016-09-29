//
//  AYServiceConsumerFaceView.m
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYServiceConsumerFaceView.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "PhotoTagEnumDefines.h"

@implementation AYServiceConsumerFaceView {
    UILabel* title;
    UIImageView* lhs;
    UIImageView* rhs;
    UIImageView* logo;
    UILabel* des;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    title = [[UILabel alloc]init];
    title.text = @"准备好预定XX的服务";
    [title sizeToFit];
    [title setCenter:CGPointMake(SCREEN_WIDTH / 2, 10)];
    [self addSubview:title];
    
    lhs = [[UIImageView alloc]init];
    lhs.frame = CGRectMake(0, 0, 50, 50);
    lhs.center = CGPointMake(20, 50);
    [self addSubview:lhs];
    
    rhs = [[UIImageView alloc]init];
    rhs.frame = CGRectMake(0, 0, 50, 50);
    rhs.center = CGPointMake(20, 50);
    [self addSubview:rhs];
    
    logo = [[UIImageView alloc]init];
    logo.frame = CGRectMake(0, 0, 50, 50);
    logo.center = CGPointMake(SCREEN_WIDTH / 2, 50);
    [self addSubview:logo];
    
    des = [[UILabel alloc]init];
    des.text = @"balabalabala";
    [des sizeToFit];
    [self addSubview:des];
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- messages
- (void)selfClicked {
    @throw [[NSException alloc]initWithName:@"error" reason:@"cannot call base view" userInfo:nil];
}


#pragma mark -- actions
- (id)lhsImage:(id)args {
    lhs.image = (UIImage*)args;
    return nil;
}

- (id)rhsImage:(id)args {
    rhs.image = (UIImage*)args;
    return nil;
}

- (id)resetTitle:(id)args {
    return nil;
}

- (id)queryHintHight {
    return [NSNumber numberWithInt:100];
}
@end
