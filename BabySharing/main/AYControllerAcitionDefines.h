//
//  AYControllerAcitionDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYControllerAcitionDefines_h
#define AYControllerAcitionDefines_h

static NSString* const kAYControllerActionKey = @"action name";

static NSString* const kAYControllerActionInitValue = @"controller init";
static NSString* const kAYControllerActionPushValue = @"controller push";
static NSString* const kAYControllerActionModelValue = @"controller show model";

static NSString* const kAYControllerActionModelTypeKey = @"what kind of model";

static NSString* const kAYControllerActionDestinationControllerKey = @"destination controller";
static NSString* const kAYControllerActionSourceControllerKey = @"srouce controller";

static NSString* const kAYControllerIndentifierKey = @"controller identifier";      // 类型由source controller自行确定

static NSString* const kAYControllerChangeArgsKey = @"controller exchange args";      

#endif /* AYControllerAcitionDefines_h */
