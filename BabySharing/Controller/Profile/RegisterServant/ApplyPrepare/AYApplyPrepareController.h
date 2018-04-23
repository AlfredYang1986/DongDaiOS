//
//  AYApplyPrepareController.h
//  BabySharing
//
//  Created by 王坤田 on 2018/4/20.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"
#import "SwipeView.h"
#import "AYNameInputView.h"
#import "AYCityInputView.h"
#import "AYPhoneInputView.h"
#import "AYServiceChooseView.h"

@interface AYApplyPrepareController : AYViewController<SwipeViewDelegate, SwipeViewDataSource, AYNameInputViewDelegate, AYCityInputViewDelegate, AYPhoneInputViewDelegate,AYServiceChooseViewDelegate>

@end
