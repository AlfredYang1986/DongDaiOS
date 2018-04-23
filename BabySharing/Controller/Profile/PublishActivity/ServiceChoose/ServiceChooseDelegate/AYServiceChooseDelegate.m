//
//  AYServiceChooseDelegate.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/10.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYServiceChooseDelegate.h"

@implementation AYServiceChooseDelegate {
    
    NSArray *serviceData;
    NSString *address;
    
}


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



-(id)changeQueryData:(NSDictionary*)args {
    
    NSDictionary *dic = args;
    
    address = [dic objectForKey:@"address"];
    serviceData = [dic objectForKey:@"serviceData"];
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [serviceData count] + 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [serviceData count]) {
        
        id<AYViewBase> cell;
        
        NSString* class_name = @"AYServiceAddCellView";
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return (UITableViewCell*)cell;
        
        
    }
    
    
    id<AYViewBase> cell;
    
    NSString* class_name = @"AYServiceChooseCellView";
    cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    [tmp setValue:[serviceData objectAtIndex:indexPath.row] forKey:@"service"];
    
    [(UITableViewCell*)cell performAYSel:kAYCellSetInfoMessage withResult:&tmp];
    
    return (UITableViewCell*)cell;
    
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [serviceData count]) {
        
        return 76;
        
    }
    
    
    return 112;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.transform = CGAffineTransformMakeScale(1.08, 1.08);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        cell.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        if (finished) {
            
            if (indexPath.row != [self -> serviceData count]) {
                
                NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
                
                [data setObject:self -> address forKey:@"address"];
                [data setObject:[self -> serviceData objectAtIndex:indexPath.row] forKey:@"service_data"];
                
                AYViewController* des = DEFAULTCONTROLLER(@"PublishStart");
                NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
                [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
                [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
                [dic_push setValue:self -> _controller forKey:kAYControllerActionSourceControllerKey];
                [dic_push setValue:[data copy] forKey:kAYControllerChangeArgsKey];
                
                id<AYCommand> cmd = PUSH;
                [cmd performWithResult:&dic_push];
                
            }
            
        }
        
        
    }];
    
}


@end
