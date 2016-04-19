//
//  AYTagSearchController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/19/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTagSearchController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYSearchDefines.h"

#import "PhotoTagEnumDefines.h"

@interface AYTagSearchController ()
@property (nonatomic, setter=setCurrentStatus:) TagType status;
@end

@implementation AYTagSearchController {
    TagType current_type;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        current_type = ((NSNumber*)[dic objectForKey:kAYControllerChangeArgsKey]).integerValue;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.status = current_type;
}

- (void)setCurrentStatus:(TagType)status {
    _status = status;
  
    NSString* place_holder = nil;
    NSString* title = nil;
    
    switch (_status) {
        case TagTypeBrand: {
            place_holder = @"请输入品牌";
            title = @"添加品牌";
            }
            break;
        case TagTypeLocation: {
            place_holder = @"请输入地址";
            title = @"添加地址";
            }
            break;
        case TagTypeTime: {
            place_holder = @"请输入时刻";
            title = @"添加时刻";
            }
            break;
            
        default:
            return;
    }
    
    id<AYViewBase> view = [self.views objectForKey:@"SearchBar"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeSearchBarPlaceHolder:"];
    [cmd performWithResult:&place_holder];
    
    
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
    [cmd_title performWithResult:&title];
   
}

#pragma mark -- life cycle
- (BOOL)prefersStatusBarHidden {
    return YES; //返回NO表示要显示，返回YES将hiden
}
@end
