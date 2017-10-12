//
//  AYScheduleWeekDaysView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYScheduleWeekDaysView.h"
#import "AYShadowRadiusView.h"
#import "AYSpecialDayCellView.h"

#define btnSpaceW				(SCREEN_WIDTH - 40) / 7
#define btnWH					30

@implementation AYScheduleWeekDaysView {
    AYWeekDayBtn *noteBtn;
    UIView *currentSign;
	
	UIView *animatView;
	
	UICollectionView *scheduleView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	CGFloat margin  = 20;
	self.frame = CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, 60);
	
	AYShadowRadiusView *BGView = [[AYShadowRadiusView alloc] initWithRadius:4.f];
	[self addSubview:BGView];
	[self sendSubviewToBack:BGView];
	[BGView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	animatView = [[UIView alloc] init];
	[BGView addSubview:animatView];
	[animatView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(BGView);
		make.bottom.equalTo(BGView);
		make.width.equalTo(BGView);
		make.height.equalTo(@20);
	}];
	animatView.userInteractionEnabled = YES;
	UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
	//如果想支持上下左右清扫  那么一个手势不能实现  需要创建两个手势
	swipe.direction = UISwipeGestureRecognizerDirectionDown;
	[animatView addGestureRecognizer:swipe];
	
	UISwipeGestureRecognizer *swipe_up =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
	swipe_up.direction = UISwipeGestureRecognizerDirectionUp;
	[animatView addGestureRecognizer:swipe_up];
	
	UIView *swipeSignView = [[UIView alloc] init];
	[animatView addSubview:swipeSignView];
	[swipeSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(animatView);
		make.size.mas_equalTo(CGSizeMake(35, 5));
	}];
	[Tools setViewBorder:swipeSignView withRadius:2.5 andBorderWidth:0 andBorderColor:nil andBackground:[Tools garyColor]];
	
	CGFloat itemWH = self.frame.size.width / 7;
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
	layout.itemSize = CGSizeMake(itemWH, itemWH);
	layout.minimumLineSpacing = 0;
	layout.minimumInteritemSpacing = 0;
	
	scheduleView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width, itemWH*5 ) collectionViewLayout:layout];
	scheduleView.backgroundColor = [UIColor clearColor];
	[self addSubview:scheduleView];
	scheduleView.delegate = self;
	scheduleView.dataSource = self;
	//	_calendarContentView.allowsMultipleSelection = YES;
	scheduleView.showsVerticalScrollIndicator = NO;
	
	[scheduleView registerClass:[AYSpecialDayCellView class] forCellWithReuseIdentifier:@"AYSpecialDayCellView"];
	[scheduleView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AYSpecialDayHeader"];
	
    currentSign = [[UIView alloc] init];
	currentSign.backgroundColor = [Tools themeColor];
    [self addSubview:currentSign];
    [currentSign mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(BGView);
        make.centerX.equalTo(self.mas_left).offset(btnSpaceW - btnWH * 0.5);
        make.size.mas_equalTo(CGSizeMake(btnSpaceW, 2));
    }];
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

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
	
	if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
		NSLog(@"UP");
	} else if(swipe.direction == UISwipeGestureRecognizerDirectionDown) {
		NSLog(@"DOWN");
	}
}

#pragma mark -- notifies
- (id)setViewInfo:(NSArray*)args {
    
    NSMutableArray *tmp = [NSMutableArray array];
    [args enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmp addObject:[obj objectForKey:@"day"]];
    }];
    
    NSArray *weekdays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六" ];
    for (int i = 0; i < weekdays.count; ++i) {
        AYWeekDayBtn *dayBtn = [[AYWeekDayBtn alloc] initWithTitle:weekdays[i]];
        dayBtn.tag = i;
        dayBtn.states = WeekDayBtnStateNormal;
        [dayBtn addTarget:self action:@selector(didDayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dayBtn];
        [dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (i+1) - btnSpaceW * 0.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
        }];
        
        if([tmp containsObject:[NSNumber numberWithInt:i]]) {
            dayBtn.states = WeekDayBtnStateSeted;
        }
        
        if (i == 0) {
            dayBtn.states = WeekDayBtnStateSelected;
            noteBtn = dayBtn;
        }
        
    }
    return nil;
}

#pragma mark -- actions
- (void)didDayBtnClick:(AYWeekDayBtn*)btn {
    if (noteBtn == btn) {
        return;
    }
    
    //notifies
    NSNumber *index = [NSNumber numberWithInteger:btn.tag];
    kAYViewSendNotify(self, @"changeCurrentIndex:", &index)
    //此处index返回值是有意义的：是否有值（是否切换）／NSNumber封装int(0/2)（是否已设置标志）
    
    if(!index) {
        return;
    }
    
    btn.states = WeekDayBtnStateSelected;
    noteBtn.states = index.intValue;
    noteBtn = btn;
    
//    [currentSign mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_bottom);
//        make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (btn.tag + 1) - btnWH * 0.5);
//        make.size.mas_equalTo(CGSizeMake(18, 7));
//    }];
	[UIView animateWithDuration:0.25 animations:^{
		[currentSign mas_updateConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(btnSpaceW * (btn.tag + 1) - btnSpaceW * 0.5);
		}];
		[self layoutIfNeeded];
	}];
}

#pragma mark -- ollectionViewDelegate
- (AYCalendarDate*)useTime {
	if (!_useTime) {
		_useTime = [[AYCalendarDate alloc]init];
	}
	return _useTime;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 12;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	NSString *strYear = [NSString stringWithFormat:@"%ld", section / 12 + [_useTime getYear]];
	NSString *strMonth = [NSString stringWithFormat:@"%ld", section % 12 + 1];
	//每个月的第一天
	NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01", strYear, strMonth];
	
	return [self.useTime timeFewWeekInMonth:dateStr] * 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYSpecialDayCellView *cell = (AYSpecialDayCellView *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AYSpecialDayCellView" forIndexPath:indexPath];
	
	//每个月的第一天
	NSString *dateStr = [self getDateStrForSection:indexPath.section day:1];
	//获得这个月的天数
	NSInteger monthNumber = [self.useTime timeNumberOfDaysInString:dateStr];
	//获得这个月第一天是星期几
	NSInteger dayOfWeek = [self.useTime timeMonthWeekDayOfFirstDay:dateStr];
	
	NSInteger firstCorner = dayOfWeek;
	NSInteger lastConter = dayOfWeek + monthNumber - 1;
	if (indexPath.item < firstCorner || indexPath.item > lastConter) {
		cell.hidden = YES;
	} else {
		
	}
	return cell;
}

//获得据section／cell的完整日期
- (NSString *)getDateStrForSection:(NSInteger)section day:(NSInteger)day {
	return [NSString stringWithFormat:@"%ld-%ld-%ld", section/12 + [_useTime getYear], section%12 + 1, day];
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"AYDayCollectionHeader" forIndexPath:indexPath];
		
		UILabel *label = [headerView viewWithTag:119];
		if (label == nil) {
			//添加日期
			label = [Tools creatUILabelWithText:nil andTextColor:[Tools blackColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
			label.tag = 119;
			[headerView addSubview:label];
			[label mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerY.equalTo(headerView);
				make.left.equalTo(headerView).offset(13);
			}];
		}
		
		//设置属性
		label.text = [NSString stringWithFormat:@"%ld年 %.2ld月", indexPath.section/12 + [_useTime getYear], indexPath.section % 12 + 1];
		return headerView;
	}
	return nil;
}

//设置header的高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	
	CGFloat width = SCREEN_WIDTH - 10 * 2;
	return (CGSize){width, width / 7};
}

#pragma mark -- cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//	AYSpecialDayCellView * cell = (AYSpecialDayCellView *)[collectionView cellForItemAtIndexPath:indexPath];
//	if (cell.isGone) {
//		return ;
//	}
//	//	cell.isLightColor = YES;
//	NSTimeInterval time_p = cell.timeSpan;
//	NSNumber *tmp = [NSNumber numberWithDouble:time_p];
//	kAYViewSendNotify(self, @"didSelectItemAtIndexPath:", &tmp)
	
}
@end
