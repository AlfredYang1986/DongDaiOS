//
//  AYLocationChooseDelegate.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/9.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYLocationChooseDelegate.h"
#import "AYLocationChooseCellView.h"


@implementation AYLocationChooseDelegate {
    
    NSArray *locationData;
    
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



-(id)changeQueryData:(NSArray*)args {
    
    locationData = (NSArray*)args;
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [locationData count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<AYViewBase> cell;
    
    NSString* class_name = @"AYLocationChooseCellView";
    cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    [tmp setValue:[locationData objectAtIndex:indexPath.row] forKey:@"location"];
    
    [(UITableViewCell*)cell performAYSel:kAYCellSetInfoMessage withResult:&tmp];
    
    
    return (UITableViewCell*)cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.transform = CGAffineTransformMakeScale(1.08, 1.08);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        cell.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished){
        
        if (finished) {
            
            AYViewController* des = DEFAULTCONTROLLER(@"ServiceChoose");
            NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
            [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_push setValue:self -> _controller forKey:kAYControllerActionSourceControllerKey];
            
            NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
            
            NSString *location_id = [[self -> locationData objectAtIndex:indexPath.row] objectForKey:@"location_id"];
            
            NSString *address  = [[self -> locationData objectAtIndex:indexPath.row] objectForKey:@"address"];

            [tmp setValue:location_id forKey:@"location_id"];
            
            [tmp setValue:address forKey:@"address"];
            
            [dic_push setValue:tmp forKey: kAYControllerChangeArgsKey];
            
            id<AYCommand> cmd = PUSH;
            [cmd performWithResult:&dic_push];

        }
        
        
    }];
    
    
    
}


@end
