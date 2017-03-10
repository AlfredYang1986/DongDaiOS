//
//  WXSTransitionManager+TypeTool.h
//  WXSTransition
//
//  Created by AlanWang on 16/9/20.
//  Copyright © 2016年 王小树. All rights reserved.
//

#import "WXSTransitionManager.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
@interface WXSTransitionManager (TypeTool) <CAAnimationDelegate>
#else
@interface WXSTransitionManager (TypeTool)
#endif

//@interface WXSTransitionManager (TypeTool)
-(void)backAnimationTypeFromAnimationType:(WXSTransitionAnimationType)type;
-(CATransition *)getSysTransitionWithType:(WXSTransitionAnimationType )type;
@end
