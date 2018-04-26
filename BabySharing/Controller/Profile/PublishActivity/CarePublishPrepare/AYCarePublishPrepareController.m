//
//  AYCarePublishPrepareController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/13.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCarePublishPrepareController.h"
#import "SwipeView.h"
#import "AYLineView.h"
#import "AYCareAgeChooseView.h"
#import "AYCareProportionSetView.h"
#import "AYCarePaySetView.h"


@interface AYCarePublishPrepareController () {
    
    SwipeView *swipeView;
    AYLineView *line;
    NSMutableDictionary *data;
}

@end

@implementation AYCarePublishPrepareController


- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        if ([dic objectForKey:kAYControllerChangeArgsKey]) {
            
            data = [[NSMutableDictionary alloc] init];
            [data setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:@"service"];
            
        }
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        if ([dic objectForKey:kAYControllerChangeArgsKey]) {
            
            NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
            
            if ([tmp objectForKey:@"payment_daily"]) {
                
                NSDictionary *payment_daily = [tmp objectForKey:@"payment_daily"];
                
                if([data objectForKey:@"temp"]) {
                    
                    [[data objectForKey:@"temp"] setValue:payment_daily forKey:@"payment_daily"];
                    
                }
                
                
                AYCarePaySetView *v = (AYCarePaySetView *)[swipeView itemViewAtIndex:swipeView.currentPage];
                
                [v selectFlexible];
                
                NSNumber* right_enable = [NSNumber numberWithBool:YES];
                kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
                
            }
            
            if ([tmp objectForKey:@"payment_monthly"]) {
                
                NSDictionary *payment_monthly = [tmp objectForKey:@"payment_monthly"];
                
                if([data objectForKey:@"temp"]) {
                    
                    [[data objectForKey:@"temp"] setValue:payment_monthly forKey:@"payment_monthly"];
                    
                }
                
                AYCarePaySetView *v = (AYCarePaySetView *)[swipeView itemViewAtIndex:swipeView.currentPage];
                
                [v selectFixed];
                
                NSNumber* right_enable = [NSNumber numberWithBool:YES];
                kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
                
            }
            
            
            
        }
        
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickViewDidUpdateAge) name:@"CareAgePickViewDidUpdateAge" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(careNumSet) name:@"CareTextFieldDidEndEditing" object:nil];
    
    line = [[AYLineView alloc] initWithNumber:3];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(4);
        make.top.mas_equalTo(kNavBarH + kStatusBarH);
        
    }];
    
    [line setStep:0];
    
    swipeView = [[SwipeView alloc] init];
    [self.view addSubview:swipeView];
    
    [swipeView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kNavBarH + kStatusBarH + 8);
        
    }];
    
    [swipeView setDelegate:self];
    [swipeView setDataSource:self];
    [swipeView setScrollEnabled:NO];
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    view.backgroundColor = [UIColor garyBackground];
    return nil;
    
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
    view.backgroundColor = [UIColor garyBackground];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton *right = [UIButton creatBtnWithTitle:@"下一步" titleColor:[UIColor theme] fontSize:17.0f backgroundColor:nil];
    [right.titleLabel setFont:[UIFont mediumFont:17.0f]];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &right);
    
    NSNumber* right_enable = [NSNumber numberWithBool:NO];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
    
    return nil;
    
}

- (id)leftBtnSelected {
    
    //    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    //    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    //    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    //
    //    id<AYCommand> cmd = REVERSMODULE;
    //    [cmd performWithResult:&dic];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [self pickViewDisMiss];
    
    
    return nil;
    
}

- (id)rightBtnSelected {
    
    [self pickViewDisMiss];
    
    NSInteger index = swipeView.currentPage;
    
    if (index == 0) {
        
        AYCareAgeChooseView *v = (AYCareAgeChooseView *)[swipeView itemViewAtIndex:index];
        
        NSMutableDictionary *age_boundary = [[NSMutableDictionary alloc] init];
        [age_boundary setValue: [NSNumber numberWithInt:v.ageMin * 10] forKey:@"lbl"];
        [age_boundary setValue: [NSNumber numberWithInt:v.ageMax * 10] forKey:@"ubl"];
        
        
        if ([data objectForKey:@"temp"]) {
            
            [[data objectForKey:@"temp"] setValue:age_boundary forKey:@"age_boundary"];
            
        }else {
            
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
            [temp setValue:age_boundary forKey:@"age_boundary"];
            [data setValue:temp forKey:@"temp"];
            
        }
        
    }
    
    if (index == 1) {
        
        if(data) {
            
            AYCareProportionSetView *v = (AYCareProportionSetView *)[swipeView itemViewAtIndex:index];
            
            NSMutableDictionary *stud_tech = [[NSMutableDictionary alloc] init];
            [stud_tech setValue: [NSNumber numberWithInteger:v.teacherNum] forKey:@"tech"];
            [stud_tech setValue: [NSNumber numberWithInteger:v.studentNum] forKey:@"stud"];
            [stud_tech setValue: [NSNumber numberWithInteger:v.peopleNum] forKey:@"people"];
            
            
            if ([data objectForKey:@"temp"]) {
                
                [[data objectForKey:@"temp"] setValue:stud_tech forKey:@"stud_tech"];
                
            }
            
        }

        
    }
    
    if (index != 2) {
        
        [swipeView scrollToPage:index + 1 duration:0.3];
        
        [line setStep:index + 1];
        
        NSNumber* right_enable = [NSNumber numberWithBool:NO];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
        
    }else {
        
        AYViewController* des = DEFAULTCONTROLLER(@"PublishConfirm");
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:data forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
        
    }
    
    
    return nil;
    
}



- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)pickViewDidUpdateAge {
    
    NSNumber* right_enable = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
}

-(void)careNumSet {
    
    NSNumber* right_enable = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
}


- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    
    return 3;
    
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    
    if (index == 0) {
        
        AYCareAgeChooseView *v = [[AYCareAgeChooseView alloc] init];
        return v;
        
    }
    
    if (index == 1) {
        
        AYCareProportionSetView *v = [[AYCareProportionSetView alloc] init];
        return v;
        
    }
    
    if (index == 2) {
        
        AYCarePaySetView *v = [[AYCarePaySetView alloc] init];
        v.delegate = self;
        return v;
        
    }
    
    
    return view;
    
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView {
    
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarH - kStatusBarH);
    
}

- (void)swipeViewWillBeginDragging:(SwipeView *)swipeView {
    
    [self pickViewDisMiss];
    
}

-(void) pickViewDisMiss {
    
    if (swipeView.currentPage == 0) {
        
        AYCareAgeChooseView *v  = (AYCareAgeChooseView *)[swipeView itemViewAtIndex:swipeView.currentPage];
        
        if ([v.pickView isShowed]) {
            
            [v.pickView dismiss];
            
        }
        
        
        
    }
    
}

- (void)payFixed {
    
    
    AYViewController* des = DEFAULTCONTROLLER(@"CarePayFixed");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if ([data objectForKey:@"payment_monthly"]) {
        
        [dic_push setValue:[data objectForKey:@"payment_monthly"] forKey:kAYControllerChangeArgsKey];
        
    }
    
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    
    
}

- (void)payFlexible {
    
    AYViewController* des = DEFAULTCONTROLLER(@"CarePayFlexible");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if ([data objectForKey:@"payment_daily"]) {
        
        [dic_push setValue:[data objectForKey:@"payment_daily"] forKey:kAYControllerChangeArgsKey];
        
    }
    
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
