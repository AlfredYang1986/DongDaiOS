//
//  AYCoursePublishPrepareController.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/11.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYCoursePublishPrepareController.h"

#import "SwipeView.h"
#import "AYLineView.h"
#import "AYCourseNumSetView.h"
#import "AYCoursePaySetView.h"
#import "AYCourseAgeChooseView.h"



@interface AYCoursePublishPrepareController () {
    
    AYLineView *line;
    
    SwipeView *swipeView;
    
    NSMutableDictionary *data;
    
}

@end

@implementation AYCoursePublishPrepareController


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
            
            if ([tmp objectForKey:@"payment_time"]) {
                
                NSDictionary *payment_time = [tmp objectForKey:@"payment_time"];
                
                if([data objectForKey:@"temp"]) {
                    
                    [[data objectForKey:@"temp"] setValue:payment_time forKey:@"payment_time"];
                    
                }
                
                AYCoursePaySetView *v = (AYCoursePaySetView *)[swipeView itemViewAtIndex:swipeView.currentPage];
                
                [v selectByTime];
                
                NSNumber* right_enable = [NSNumber numberWithBool:YES];
                kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
                
            }
            
            if ([tmp objectForKey:@"payment_membership"]) {
                
                NSDictionary *payment_membership= [tmp objectForKey:@"payment_membership"];
                
                if([data objectForKey:@"temp"]) {
                    
                    [[data objectForKey:@"temp"] setValue:payment_membership forKey:@"payment_membership"];
                    
                }
                
                
                AYCoursePaySetView *v = (AYCoursePaySetView *)[swipeView itemViewAtIndex:swipeView.currentPage];
                
                [v selectByMember];
                
                NSNumber* right_enable = [NSNumber numberWithBool:YES];
                kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
                
            }
            
            
            
        }
        
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pickViewDidUpdateAge) name:@"AYCourseAgePickViewDidUpdateAge" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(courseNumSet) name:@"CourseTextFieldDidEndEditing" object:nil];
    
    
    line = [[AYLineView alloc] init];
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
        
        
        AYCourseAgeChooseView *v = (AYCourseAgeChooseView *)[swipeView itemViewAtIndex:index];
        
        NSMutableDictionary *age_boundary = [[NSMutableDictionary alloc] init];
        [age_boundary setValue: [NSNumber numberWithInteger:v.ageMin] forKey:@"lbl"];
        [age_boundary setValue: [NSNumber numberWithInteger:v.ageMax] forKey:@"ubl"];
        
        
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
            
            AYCourseNumSetView *v = (AYCourseNumSetView *)[swipeView itemViewAtIndex:index];
            
            NSMutableDictionary *stud_boundary = [[NSMutableDictionary alloc] init];
            [stud_boundary setValue: [NSNumber numberWithInteger:v.maxNum] forKey:@"max"];
            [stud_boundary setValue: [NSNumber numberWithInteger:v.minNum] forKey:@"min"];
            
            
            if ([data objectForKey:@"temp"]) {
                
                [[data objectForKey:@"temp"] setValue:stud_boundary forKey:@"stud_boundary"];
                
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

-(void)courseNumSet {
    
    NSNumber* right_enable = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnEnableMessage, &right_enable);
    
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    
    return 3;
    
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    
    if (index == 0) {
        
        AYCourseAgeChooseView *v = [[AYCourseAgeChooseView alloc] init];
        
        return v;
        
    }
    
    if (index == 1) {
        
        AYCourseNumSetView *v = [[AYCourseNumSetView alloc] init];
        
        return v;
        
    }
    
    if (index == 2) {
        
        AYCoursePaySetView *v = [[AYCoursePaySetView alloc] init];
        
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
        
        AYCourseAgeChooseView * v = (AYCourseAgeChooseView *)[swipeView itemViewAtIndex:swipeView.currentPage];
        
        if ([v.pickView isShowed]) {
            
             [v.pickView dismiss];
            
        }
        
       
        
    }
    
}

- (void)payByTime {
    
    AYViewController* des = DEFAULTCONTROLLER(@"CoursePayByTime");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if ([[data objectForKey:@"temp"] objectForKey:@"payment_time"]) {
        
        [dic_push setValue:[[data objectForKey:@"temp"] objectForKey:@"payment_time"] forKey:kAYControllerChangeArgsKey];
        
    }
    
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    
    
}

- (void)payByMember {
    
    AYViewController* des = DEFAULTCONTROLLER(@"CoursePayByMember");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if ([[data objectForKey:@"temp"] objectForKey:@"payment_membership"]) {
        
        [dic_push setValue:[[data objectForKey:@"temp"] objectForKey:@"payment_membership"] forKey:kAYControllerChangeArgsKey];
        
    }
    
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
